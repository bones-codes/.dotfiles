###############################################################################
# UI                                                                          #
###############################################################################

# It's my library. Let me see it.
sudo chflags nohidden ~/Library/
sudo chflags nohidden /tmp
sudo chflags nohidden /usr

#Disable Spotlight indexing from indexing /Volumes
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

#Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Disable fast user switching 
sudo defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool NO

# Disable username list in login
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME 0

# Enable dark menu bar and Dock hot key (^⌥⌘t), and Graphite appearance 
sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
sudo defaults write -g AppleAquaColorVariant -int 6

## EXTRAA
# Link to the airport command
sudo ln -sf /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/sbin/airport


###############################################################################
# Screen                                                                      #
###############################################################################

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true


###############################################################################
# Spotlight                                                                   #
###############################################################################

if [[ ! $MIN ]]; then 
  #Disable Spotlight indexing from indexing /volume
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
fi

###############################################################################
# Time Machine                                                                #
###############################################################################

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal

[[ ! $LOCAL ]] || return 1

###############################################################################
# Security                                                                    #
###############################################################################
# Enable Firewall.
# Replace value with
# 0 = off
# 1 = on for specific services
# 2 = on for essential services
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2
# Enable Stealth mode.
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled 1
# Enable Firewall Logging.
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled 1
# Allow signed APPS
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -int 1

# Enable Require password to wake this computer from sleep or screen saver.
sudo defaults -currentHost write com.apple.screensaver askForPassword -int 1
# Disable Automatic login.
sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.userspref.DisableAutoLogin -bool yes
sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay -int 0
# Disable Guest login.
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

# Require password to unlock each System Preference pane.
# Edit the /etc/authorization file using a text editor.
# Find <key>system.preferences<key>.
# Then find <key>shared<key>.
# Then replace <true/> with <false/>.
security -q authorizationdb read system.preferences > /tmp/system.preferences.plist
defaults write /tmp/system.preferences.plist shared -bool false
sudo security -q authorizationdb write system.preferences < /tmp/system.preferences.plist
sudo rm -rf /tmp/system.preferences.plist

# Disable IR remote control.
sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool no
# Turn Bluetooth off.
sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
# Disable Remote Management.
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop -quiet
# Disable Internet Sharing.
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict Enabled -int 0
# Disable Bluetooth Sharing.
sudo defaults -currentHost write com.apple.bluetooth PrefKeyServicesEnabled 0

#TODO
#Need to look at bad services in the future right now disabling some service
#removed functinlity needs more testing.
# Remove BAD services. In the future look at unloading these as well
# # com.apple.smb.preferences.plist $d
# # aosnotifyd -- Find My Mac daemon
# com.apple.AOSNotificationOSX.plist com.apple.locationd.plist com.apple.cmio.AVCAssistant.plist
# com.apple.cmio.VDCAssistant.plist com.apple.iCloudStats.plist com.apple.wwand.plist
# com.apple.AirPlayXPCHelper.plist
# # blued
# com.apple.blued.plist com.apple.bluetoothaudiod.plist com.apple.IOBluetoothUSBDFU.plist 
# com.apple.rpcbind.plist org.postfix.master.plist com.apple.spindump.plist
# com.apple.spindump_symbolicator.plist
# # metadata
# com.apple.metadata.mds.index.plist com.apple.metadata.mds.spindump.plist com.apple.metadata.mds.scan.plist
# com.apple.metadata.mds.plist com.apple.lockd.plist com.apple.nis.ypbind.plist com.apple.mbicloudsetupd.plist
# com.apple.gssd.plist com.apple.findmymac.plist com.apple.findmymacmessenger.plist 
# com.apple.cmio.IIDCVideoAssistant.plist com.apple.afpfs_checkafp.plist com.apple.afpfs_afpLoad.plist
# # Apple Push Notification service daemon
# com.apple.apsd.plist
# # awacsd -- Apple Wide Area Connectivity Service daemon
# com.apple.awacsd.plist
# # share service
# com.apple.RFBEventHelper.plist com.apple.cmio.AppleCameraAssistant.plist
# com.apple.revisiond.plist
# Turn off AirPort Services using the following commands. Run the last
# command as the current user.
#sudo launchctl unload -wF /System/Library/LaunchDaemons/com.apple.airportPrefsUpdater.plist
#sudo launchctl unload -wF /System/Library/LaunchDaemons/com.apple.AirPort.wps.plist
# Another way to reomve is
# home=$HOME
# d=$home/backup-unload-daemon
# sudo mv /System/Library/LaunchDaemons/com.apple.mdmclient.daemon.plist $d
#"com.apple.eppc" "com.apple.InternetSharing" "com.apple.RFBEventHelper" 
#    "com.apple.screensharing" "com.apple.screensharing.MessagesAgent" 
#    "com.apple.screensharing.agent" "com.apple.RemoteDesktop.PrivilegeProxy" 
#    "com.apple.RemoteDesktop.agent" "com.apple.blued"

#"com.apple.locationd" 
bad=("org.apache.httpd" "com.openssh.sshd")
loaded="$(sudo launchctl list | awk 'NR>1 && $3 !~ /0x[0-9a-fA-F]+\.(anonymous|mach_init)/ {print $3}')"

bad_list=($(setcomp "${bad[*]}" "$loaded"))
if (( ${#bad_list[@]} > 0 )); then
  for rmv in "${bad_list[@]}"; do
    e_header "Unloading: $rmv"
    launchctl unload -wF "/System/Library/LaunchAgents/"$rmv".plist"
  done
fi

# Destroy File Vault Key when going to standby
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

# Remove the Java browser Plugin.
# Apple by default disables this in http://support.apple.com/kb/dl1572
#java_plugin="/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin"
#sudo rm -rf $java_plugin
#sudo touch $java_plugin
#sudo chmod 000 $java_plugin
#sudo chflags uchg $java_plugin
