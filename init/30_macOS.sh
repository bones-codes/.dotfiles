$(get_os 'macOS') || return 1
[[ ! $MIN ]] || return 1

# BASH
if [[ "$(type -P $binroot/bash)" ]]; then
  if ! grep -q "$binroot/bash" "/etc/shells"; then
    e_header "Adding $binroot/bash to the list of acceptable shells"
    echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
    chsh -s $binroot/bash
  fi
fi

# htop
if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
  e_header "Updating htop permissions"
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

# usbkill
e_header 'Installing usbkill'
if [[ -e "$DOTFILES_HOME/bin/usbkill" ]]; then
  cd "$DOTFILES_HOME/bin/usbkill"
  git pull
  sudo python setup.py install
else
  cd "$HOME/.dotfiles/bin"
  git clone https://github.com/hephaest0s/usbkill.git
  cd usbkill
  sudo python setup.py install
fi

if [[ "$(type -P pip)" ]]; then
  e_header "Install and/or Upgrade PIP"
  pip -q install --upgrade pip
  pip -q install --upgrade setuptools
  pip -q install --upgrade distribute

  e_header "Install VirualEnv + VirtualEnvWrapper"
  pip -q install --upgrade virtualenv 
  pip -q install --upgrade virtualenvwrapper

  if [[ $HACK || $NET ]]; then
    e_header "Installing PyCrypto"
    # For Scapy
    sudo pip -q install --upgrade pycrypto
  fi

  if [[ $LOCAL || $HACK || $IOS ]]; then
    e_header "Installing PyObjC"
    # Cause Homebrew's Python is missing the CoreFoundation module
    sudo pip -q install --upgrade pyobjc
  fi

  e_header "Installing peewee (for pct-vim)"
  # https://github.com/d0c-s4vage/pct-vim
  sudo pip3 -q install --upgrade peewee

fi

if [[ $LOCAL || $HACK|| $IOS || $RUBY  ]]; then 
  # Install Ruby -- using rbenv to manage Ruby versions
  # https://gorails.com/setup/osx/10.11-el-capitan
  e_header "Installing ruby 2.1.0"
  if [[ $STANDARD_USER ]]; then
    sudo -H -u $STANDARD_USER CONFIGURE_OPTS=--enable-shared rbenv install 2.1.10
    sudo su $STANDARD_USER <<'EOF'
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
rbenv global 2.1.10
ruby -v
EOF
  else
    CONFIGURE_OPTS=--enable-shared rbenv install 2.1.10
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    rbenv global 2.1.10
    ruby -v
  fi
fi

if [[ $LOCAL ]]; then 
  e_header "Installing icalendar gem (mutt)"
  sudo su $STANDARD_USER <<'EOF'
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
rbenv global 2.1.10
gem install -v 1.5.4 icalendar
EOF
fi

if [[ $HACK || $IOS ]]; then
  # Setup tools/env for iOS hacking
  # https://github.com/NitinJami/keychaineditor.git (iDevice)
  # https://github.com/kasketis/netfox (iDevice)
  # https://github.com/nabla-c0d3/ssl-kill-switch2 (iDevice)
  # https://code.google.com/p/ccl-bplist/
  # http://www.crypticbit.com/zen/products/iphoneanalyzer
  # https://github.com/maciekish/iReSign.git

  rbenv global 2.1.10
  ruby -v
  e_header "Installing idb (iOS)"
  gem install idb
fi

if [[ ! $LOCAL ]]; then
  sudo -u $STANDARD_USER mkdir -p $USER_HOME/tools
fi
