#!/usr/bin/env bash

# OSX
if get_os 'osx'; then
  open -a Safari

  #google-chrome
  open https://www.google.com/chrome
  #vimium
  open https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb
  #vimperator
  open https://addons.mozilla.org/en-us/firefox/addon/vimfx/ 
  #wifi-signal
  open "https://itunes.apple.com/us/app/wifi-signal/id525912054?mt=12"
  #Paragon
  #open https://www.paragon-software.com/home/ntfs-mac/
  #VB box
  #open https://www.virtualbox.org/wiki/Downloads
  #xPRA
  #open https://www.xpra.org/

  if [[ $HACK || $NET ]]; then
    open http://www.adriangranados.com/apps/airtool
  fi

  if [[ $LOCAL ]]; then
    #tunnelblick
    open https://tunnelblick.net/downloads.html
  fi

# Ubuntu.
elif get_os 'ubuntu'; then
	e_header "TODO!! "
fi
