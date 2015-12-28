#!/bin/bash
# This script should be run prior to connecting to a network.
# https://github.com/drduh/OS-X-Security-and-Privacy-Guide
if [[ "$1" == "-h" || "$1" == "--help" ]]; then cat <<HELP
Usage: sudo $(basename "$0 <options>")

    -a,--admin       Secure configurations for an Administrator user
    -s,--standard    Secure configurations for a Standard user (default)

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
  e_header "Enable Filevault"
  sudo fdesetup enable
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

  e_header "Enable firewall"
  # Enable Firewall
  # Replace value with
  # 0 = off
  # 1 = on for specific services
  # 2 = on for essential services
  sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2
  # Enable Stealth mode.
  sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
  # Enable Firewall Logging.
  sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true
  # Allow signed APPS
  sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false

  e_header "Enable tty_tickets for sud"
  user="$(whoami)"
  su $user -m -c "echo 'Defaults tty_tickets' | sudo tee -a /etc/suders"


  ###############################################################################
  # User Management                                                             #
  ###############################################################################
  # Require password to unlock each System Preference pane.
  # Edit the /etc/authorization file using a text editor.
  # Find <key>system.preferences<key>.
  # Then find <key>shared<key>.
  # Then replace <true/> with <false/>.
  security -q authorizationdb read system.preferences > /tmp/system.preferences.plist
  defaults write /tmp/system.preferences.plist shared -bool false
  sudo security -q authorizationdb write system.preferences < /tmp/system.preferences.plist
  sudo rm -rf /tmp/system.preferences.plist

  # Disable fast user switching 
  sudo defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool NO

  # Display login window as: Name and password
  sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

  # Don't show any password hints
  sudo defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0

  # Disable Automatic login.
  sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.userspref.DisableAutoLogin -bool yes
  sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay -int 0

  # Disable Guest login.
  sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -int 0

  # The following sets up a standard user to act as the primary user. All sud
  # actions are handled via runaspw under the current admin user.
  e_header "Create non-admin group"
  read -p "Enter non-admin groupname: " groupname
  sudo dscl . create /Groups/$groupname
  # Create the group name key
  sudo dscl . create /Groups/$groupname RealName $groupname
  sudo dscl . create /Groups/$groupname RecordName $groupname
  sudo dscl . create /Groups/$groupname passwd “*”
  sudo dscl . create /Groups/$groupname PrimaryGroupID 503

  e_header "Create user (Standard)"
  read -p "Enter new username (Standard): " username
  read -p "Enter user's full name: " fullname
  read -p "Set the user's password: " password
  # Create a new entry in the local domain under the category /users.
  sudo dscl . -create /Users/$username
  # Create and set the shell property to bash.
  sudo dscl . -create /Users/$username UserShell /bin/bash
  # Create and set the user’s full name.
  sudo dscl . -create /Users/$username RealName $fullname
  sudo dscl . -create /Users/$username RecordName $fullname
  # Create and set the user’s ID.
  sudo dscl . -create /Users/$username UniqueID 502
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

  e_header "Setting up /etc/suders..."
  adminuser=$(whoami)
  echo 'Defaults:%'$groupname' runas_default='$adminuser', runaspw' | sudo tee -a /etc/suders
  echo '%'$groupname' ALL=(ALL) ALL' | sudo tee -a /etc/suders

  #  e_header "Hide current admin user"
  #  read -p "Enter admin username: " adminuser
  #  sudo dscl . -create /Users/$adminuser IsHidden 1
  #  sudo dscl . -delete "/SharePoints/"$adminuser"'s Public Folder"
fi


###############################################################################
# Screensaver                                                                 #
###############################################################################
# Start screen saver -- bottom right corner
defaults write com.apple.dock wvous-br-corner -int 5
defaults write com.apple.dock wvous-br-modifier -int 0

# Disable screen saver -- bottom left corner
defaults write com.apple.dock wvous-bl-corner -int 6
defaults write com.apple.dock wvous-bl-modifier -int 0

# Enable Require password to wake this computer from sleep or screen saver.
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0


###############################################################################
# Services                                                                    #
###############################################################################
if [[ $ADMIN ]]; then
  # Disable IR remote control.
  sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool no
  # Turn Bluetooth off.
  sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
  # Disable Remote Management.
  sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop -quiet
  # Disable Internet Sharing.
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict Enabled -int 0
  # Disable Captive Portal
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false
fi
# Disable Bluetooth Sharing.
sudo defaults write com.apple.bluetooth PrefKeyServicesEnabled 0

bad=("org.apache.httpd" "com.openssh.sshd" "com.apple.VoiceOver" "com.apple.ScreenReaderUIServer" "com.apple.scrod.plist")
loaded="$(launchctl list | awk 'NR>1 && $3 !~ /0x[0-9a-fA-F]+\.(anonymous|mach_init)/ {print $3}')"
bad_list=($(setcomp "${bad[*]}" "$loaded"))
if (( ${#bad_list[@]} > 0 )); then
  for rmv in "${bad_list[@]}"; do
    e_header "Unloading: $rmv"
    launchctl unload -wF "/System/Library/LaunchAgents/"$rmv".plist"
  done
fi


###############################################################################
# Spotlight                                                                   #
###############################################################################
#Disable Spotlight indexing from indexing /Volumes
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

#Change indexing order and disable some search results in Spotlight
sudo defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APPLICATIONS";}' \
    '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
    '{"enabled" = 1;"name" = "DIRECTORIES";}' \
    '{"enabled" = 1;"name" = "PDF";}' \
    '{"enabled" = 0;"name" = "FONTS";}' \
    '{"enabled" = 1;"name" = "DOCUMENTS";}' \
    '{"enabled" = 0;"name" = "MESSAGES";}' \
    '{"enabled" = 0;"name" = "CONTACT";}' \
    '{"enabled" = 0;"name" = "EVENT_TODO";}' \
    '{"enabled" = 0;"name" = "IMAGES";}' \
    '{"enabled" = 0;"name" = "BOOKMARKS";}' \
    '{"enabled" = 0;"name" = "MUSIC";}' \
    '{"enabled" = 0;"name" = "MOVIES";}' \
    '{"enabled" = 1;"name" = "PRESENTATIONS";}' \
    '{"enabled" = 1;"name" = "SPREADSHEETS";}' \
    '{"enabled" = 0;"name" = "SOURCE";}' \
    '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
    '{"enabled" = 0;"name" = "MENU_OTHER";}' \
    '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
    '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
    '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
    '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
sudo mdutil -E / > /dev/null


###############################################################################
# Safari/Web                                                                  #
###############################################################################
# Privacy: Don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2


###############################################################################
# Data Management                                                             #
###############################################################################
# I do not need my documents to be cloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true


if [[ $ADMIN ]]; then
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
