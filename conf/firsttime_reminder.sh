#!/usr/bin/env bash

# OSX
if get_os 'osx'; then
  open -a Safari
  sleep 1
  #google-chrome
  open https://www.google.com/chrome
  #vimium
  open https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb
  #vimperator
  open https://addons.mozilla.org/en-us/firefox/addon/vimfx/ 
  #Paragon
  #open https://www.paragon-software.com/home/ntfs-mac/
  #VB box
  #open https://www.virtualbox.org/wiki/Downloads
  #xPRA
  #open https://www.xpra.org/

# Ubuntu.
elif get_os 'ubuntu'; then
	e_header "TODO!! "
fi
