#!/usr/bin/env bash

# OSX
if get_os 'osx'; then
  open -a Safari
  sleep 1
  #tunnelblick-beta
  open https://code.google.com/p/tunnelblick/wiki/DownloadsEntry#Tunnelblick_Beta_Release
  #gpgtools
  open https://gpgtools.org/
  #vmware-fusion
  open https://my.vmware.com/web/vmware/login
  #Little-Snitch
  open https://www.obdev.at/products/littlesnitch/download.html
  #google-chrome
  open https://www.google.com/chrome
  #xcode
  open http://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12
  #keepassx
  open https://www.keepassx.org/dev/projects/keepassx/files
  #Paragon
  open https://www.paragon-software.com/home/ntfs-mac/
  #VB box
  open https://www.virtualbox.org/wiki/Downloads
  #xPRA
  open https://www.xpra.org/

# Ubuntu.
elif get_os 'ubuntu'; then
	e_header "TO DO!! "
fi
