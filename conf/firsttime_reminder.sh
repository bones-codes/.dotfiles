#!/bin/bash

# macOS
if [[ "$OSTYPE" =~ ^darwin ]]; then
  open -a Safari

  # https everywhere
  open https://www.eff.org/https-everywhere
  # adblock plus
  open https://adblockplus.org/
  #vimium
  open https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb
  #vimperator
  open https://addons.mozilla.org/en-us/firefox/addon/vimfx/ 
  #autochrome
  open https://gitlab.na.nccgroup.com/ryan/autochrome

  if [[ $LOCAL ]]; then
    open https://tunnelblick.net/downloads.html
    open -a /usr/local/Caskroom/little-snitch/*/Little Snitch Installer.app
    open -a Micro\ Snitch.app
  fi

# Ubuntu.
elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
	e_header "TODO!! "
fi

if [[ -e "$HOME/.profile" ]]; then
  e_header "Removing .profile"
  rm -rf "$HOME/.profile"
fi
