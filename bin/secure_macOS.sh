#!/bin/bash
# This script should be run prior to connecting to a network.
# https://github.com/drduh/OS-X-Security-and-Privacy-Guide
# For 10.11+, you'll need to disable SIP for a few settings
# To disable SIP, do the following: 
# 1. Startup while pressing Cmd+R to enter Recovery mode
# 2. Open Utilities->Terminal
# 3. Run the command "csrutil disable"
# 4. Reboot, you'll land in the normal OS with SIP disabled
# 5. Run this script
# 6. Reboot again, and press Cmd+R to enter Recovery mode
# 7. Enable SIP with "csrutil enable"
# 8. Restart

if [[ "$1" == "-h" || "$1" == "--help" ]]; then cat <<HELP
Usage: $(basename "$0 <options>")

    -a,--admin       Secure configurations for an Administrator user
    -s,--standard    Secure configurations for a Standard user or single user
                     install (default)

HELP
exit; fi

################################################################################
## FUNCTIONS START                                                             #
################################################################################
# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;33m➜\033[0m  $@"; }

function setcomp() {
  if [[ "$1" == 1 ]]; then 
    shift; set 1 "comp" "$@"
  else
    set "comp" "$@"
  fi
}

################################################################################
## FUNCTIONS END                                                               #
################################################################################

[[ $1 == '-a' || $1 == '--admin' ]] && export ADMIN=True

if [[ $ADMIN ]]; then
  ###############################################################################
  # Firewall                                                                    #
  ###############################################################################
  e_header "Enable firewall"
  # Enable Firewall
  # Replace value with
  # 0 = off
  # 1 = on for specific services
  # 2 = on for essential services
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
  # Enable Stealth mode
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
  # Enable Firewall Logging
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
  # Disallow signed Apps
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off
  # Block all incoming connections
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on


  ###############################################################################
  # Sudo                                                                        #
  ###############################################################################
  e_header "Enable tty_tickets for sudo"
  user="$(whoami)"
  su $user -m -c "echo 'Defaults tty_tickets' | sudo tee -a /etc/sudoers"


  ###############################################################################
  # User Management                                                             #
  ###############################################################################
  e_header "Require password to unlock each System Preference pane"
  # Edit the /etc/authorization file using a text editor.
  # Find <key>system.preferences<key>.
  # Then find <key>shared<key>.
  # Then replace <true/> with <false/>.
  security -q authorizationdb read system.preferences > /tmp/system.preferences.plist
  defaults write /tmp/system.preferences.plist shared -bool false
  sudo security -q authorizationdb write system.preferences < /tmp/system.preferences.plist
  sudo rm -rf /tmp/system.preferences.plist

  e_header "Disable fast user switching" 
  sudo defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool NO

  e_header "Display login window as: Name and Password"
  sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

  e_header "Don't show any password hints"
  sudo defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0

  e_header "Disable Automatic login"
  sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.userspref.DisableAutoLogin -bool yes
  sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay -int 0

  e_header "Disable Guest login"
  sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -int 0

  # The following sets up a standard user to act as the primary user. All sudo
  # actions are handled via runaspw under the current admin user.
  e_header "Create non-admin group"
  read -p "Enter non-admin groupname: " groupname
  sudo dscl . -create /Groups/$groupname
  # Create the group name key
  sudo dscl . -create /Groups/$groupname RealName $groupname
  sudo dscl . -create /Groups/$groupname RecordName $groupname
  sudo dscl . -create /Groups/$groupname passwd “*”
  sudo dscl . -create /Groups/$groupname PrimaryGroupID 513

  e_header "Create user (Standard)"
  read -p "Enter new username (Standard): " username
  read -p "Enter user's full name: " fullname
  echo -n "Set the user's password: "
  read -s password
  echo
  echo -n "Confirm user's password: " 
  read -s passcheck
  echo
  if [[ $password == $passcheck ]]; then 
    # Create a new entry in the local domain under the category /users.
    sudo dscl . -create /Users/$username
    # Create and set the shell property to bash.
    sudo dscl . -create /Users/$username UserShell /bin/bash
    # Create and set the user’s full name.
    sudo dscl . -create /Users/$username RealName $fullname
    sudo dscl . -create /Users/$username RecordName $fullname
    # Create and set the user’s ID.
    sudo dscl . -create /Users/$username UniqueID 507
    # Create and set the user’s group ID property.
    sudo dscl . -create /Users/$username PrimaryGroupID 20
    # Create and set the user home directory.
    sudo mkdir /Users/$username
    sudo chown $username /Users/$username
    sudo dscl . -create /Users/$username NFSHomeDirectory /Users/$username
    # Set the password.
    sudo dscl . -passwd /Users/$username $password
    
    e_header "Adding $username to $groupname"
    sudo dseditgroup -o edit -a $username -t user $groupname

    e_header "Setting up /etc/sudoers..."
    adminuser=$(whoami)
    echo 'Defaults:%'$groupname' runas_default='$adminuser', runaspw' | sudo tee -a /etc/sudoers
    echo '%'$groupname' ALL=(ALL) ALL' | sudo tee -a /etc/sudoers

  else
    e_error "Passwords don't match -- run again"
    exit 1
  fi


  ###############################################################################
  # Filevault                                                                   #
  ###############################################################################
  # Restricting enabled users to Standard cause fucking Filevault doesn't
  # respect the name/pass setting 
  # https://discussions.apple.com/thread/3201161?start=15&tstart=0 
  e_header "Enable Filevault and pmsets"
  sudo fdesetup enable -user $username
  echo
  # Destroy Filevault Key when going to standby
  # mode. By default File vault keys are retained even when system goes
  # to standby. If the keys are destroyed, user will be prompted to
  # enter the password while coming out of standby mode.(value: 1 -
  # Destroy, 0 - Retain)
  sudo pmset -a destroyfvkeyonstandby 1

  # We do not recommend modifying hibernation settings. Any changes you
  # make are not supported. If you choose to do so anyway, we recommend
  # using one of these three settings. For your sake and mine, please
  # don't use anything other 0, 3, or 25.

  # hibernatemode = 0 (binary 0000) by default on supported desktops.
  # The system will not back memory up to persistent storage. The system
  # must wake from the contents of memory; the system will lose context
  # on power loss. This is, historically, plain old sleep.

  # hibernatemode = 3 (binary 0011) by default on supported portables.
  # The system will store a copy of memory to persistent storage (the
  # disk), and will power memory during sleep. The system will wake from
  # memory, unless a power loss forces it to restore from disk image.

  # hibernatemode = 25 (binary 0001 1001) is only settable via pmset.
  # The system will store a copy of memory to persistent storage (the
  # disk), and will remove power to memory. The system will restore from
  # disk image. If you want "hibernation" - slower sleeps, slower wakes,
  # and better battery life, you should use this setting.
  sudo pmset -a hibernatemode 25
  # Enable hard disk sleep.
  sudo pmset -a disksleep 0
  # Disable computer sleep.
  sudo pmset -a sleep 90
  # Display sleep
  sudo pmset -a displaysleep 60
  # Disable Wake for Ethernet network administrator access.
  sudo pmset -a womp 0
  # Disable Restart automatically after power failure.
  sudo pmset -a autorestart 0
  # specifies the delay, in seconds, before writing the
  # hibernation image to disk and powering off memory for Standby.
  sudo pmset -a standbydelay 300
fi


###############################################################################
# Screensaver                                                                 #
###############################################################################
e_header "Start screen saver -- bottom right corner"
defaults write com.apple.dock wvous-br-corner -int 5
defaults write com.apple.dock wvous-br-modifier -int 0

e_header "Disable screen saver -- bottom left corner"
defaults write com.apple.dock wvous-bl-corner -int 6
defaults write com.apple.dock wvous-bl-modifier -int 0

e_header "Require password to wake this computer from sleep or screen saver"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

e_header "Enable screensaver after 2 minutes"
defaults -currentHost write com.apple.screensaver idleTime 120


###############################################################################
# Siri                                                                        #
###############################################################################
e_header "Disable Siri"
defaults write com.apple.assistant.support "Assistant Enabled" -int 0
defaults write com.apple.Siri StatusMenuVisible -int 0


    ###############################################################################
    # Spotlight                                                                   #
    ###############################################################################
if [[ $ADMIN ]]; then
  csrutil status | grep 'disabled' &> /dev/null
  if [ $? == 0 ]; then
    # Hide the icon cause we really don't need it
    sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
    killall SystemUIServer

    e_header "Disable Spotlight indexing"
    sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
    launchctl unload -w /System/Library/LaunchAgents/com.apple.metadata.mdwrite.plist

  fi
fi

#Disable Spotlight indexing from indexing /Volumes
#sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

#Change indexing order and disable some search results in Spotlight TODO -- does this work?
#sudo defaults write com.apple.spotlight orderedItems -array \ 
#    '{"enabled" = 1;name = "APPLICATIONS";}' \
#    '{"enabled" = 0;name = "MENU_SPOTLIGHT_SUGGESTIONS";}' \
#    '{"enabled" = 1;name = "MENU_CONVERSION";}' \
#    '{"enabled" = 1;name = "MENU_EXPRESSION";}' \
#    '{"enabled" = 0;name = "MENU_DEFINITION";}' \
#    '{"enabled" = 1;name = "SYSTEM_PREFS";}' \
#    '{"enabled" = 0;name = "DOCUMENTS";}' \
#    '{"enabled" = 0;name = "DIRECTORIES";}' \
#    '{"enabled" = 0;name = "PRESENTATIONS";}' \
#    '{"enabled" = 0;name = "SPREADSHEETS";}' \
#    '{"enabled" = 0;name = "PDF";}' \
#    '{"enabled" = 0;name = "MESSAGES";}' \
#    '{"enabled" = 0;name = "CONTACT";}' \
#    '{"enabled" = 0;name = "EVENT_TODO";}' \
#    '{"enabled" = 0;name = "IMAGES";}' \
#    '{"enabled" = 0;name = "BOOKMARKS";}' \
#    '{"enabled" = 0;name = "MUSIC";}' \
#    '{"enabled" = 0;name = "MOVIES";}' \
#    '{"enabled" = 0;name = "FONTS";}' \
#    '{"enabled" = 0;name = "MENU_OTHER";}' \
#    '{"enabled" = 0;name = "MENU_WEBSEARCH";}' \
#    '{"enabled" = 0;name = "SOURCE";}' 

# Load new settings before rebuilding the index
#killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
#sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
#sudo mdutil -E / > /dev/null


###############################################################################
# Safari/Web                                                                  #
###############################################################################
e_header "Privacy: Don’t send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

e_header "Prevent Safari from opening ‘safe’ files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
e_header "Disable Safari’s thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2


###############################################################################
# Data Management                                                             #
###############################################################################
# I do not need my documents to be cloud
e_header "Disable Document Save in iCloud"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

e_header "Empty Trash securely by default"
defaults write com.apple.finder EmptyTrashSecurely -bool true


###############################################################################
# Services                                                                    #
###############################################################################
if [[ $ADMIN ]]; then
  e_header "Disable IR remote control"
  sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool no
  e_header "Disable Remote Management"
  sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop -quiet
  e_header "Disable Internet Sharing"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict Enabled -int 0
  e_header "Disable Captive Portal"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false
  e_header "Turn Bluetooth off"
  sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0

  e_header "Disable Bluetooth Sharing"
  sudo defaults write com.apple.bluetooth PrefKeyServicesEnabled 0
  #launchctl unload /System/Library/LaunchDaemons/com.apple.blued.plist
fi

if [[ $ADMIN ]]; then
  csrutil status | grep 'disabled' &> /dev/null
  if [ $? == 0 ]; then
    e_header "Disable Location Services"
    sudo defaults write /System/Library/LaunchDaemons/com.apple.locationd Disabled -bool true

    e_header "Disable Bonjour"
    #sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool YES
    sudo defaults write /System/Library/LaunchDaemons/com.apple.mDNSResponder ProgramArguments -array-add "-NoMulticastAdvertisements"
    sudo launchctl unload /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
    sudo launchctl load /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist

    e_header "Disable Crash Reporter"
    defaults write com.apple.CrashReporter DialogType none

    bad=("org.apache.httpd" "com.openssh.sshd" "com.apple.VoiceOver" "com.apple.ScreenReaderUIServer" "com.apple.scrod.plist")
    loaded="$(launchctl list | awk 'NR>1 && $3 !~ /0x[0-9a-fA-F]+\.(anonymous|mach_init)/ {print $3}')"
    bad_list=($(setcomp "${bad[*]}" "$loaded"))
    if (( ${#bad_list[@]} > 0 )); then
      for rmv in "${bad_list[@]}"; do
        e_header "Unloading: $rmv"
        launchctl unload -wF "/System/Library/LaunchAgents/"$rmv".plist"
      done
    fi
  fi

  e_header "Mute microphone"
  sudo osascript -e 'tell application "System Events" to set volume input volume 0'

  e_header "Setup a firmware password"
  # https://github.com/drduh/OS-X-Security-and-Privacy-Guide#firmware-password
  echo "1. Shutdown the Mac.
2. Start up your Mac again and immediately hold the Command and R keys
   after you hear the startup sound to start from OS X Recovery.
3. When the Recovery window appears, choose Firmware Password Utility from
   the Utilities menu.
4. In the Firmware Utility window that appears, select Turn On Firmware Password.
5. Enter a new password, then enter the same password in the Verify field.
6. Select Set Password.
7. Select Quit Firmware Utility to close the Firmware Password Utility.
8. Select the Apple menu and choose Restart or Shutdown."
fi

# Disabling Apple's calls to home 
#e_header "Disabling Apple home calls"
#if [[ -e "$HOME/.dotfiles/bin/macOS-home-call-drop" ]]; then
#  bash "$HOME/.dotfiles/bin/macOS-home-call-drop/homecall.sh" fixmacos
#fi

