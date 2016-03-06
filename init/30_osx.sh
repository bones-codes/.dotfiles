$(get_os 'osx') || return 1
[[ ! $MIN ]] || return 1

# htop
if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
  e_header "Updating htop permissions"
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

# BASH
if [[ "$(type -P $binroot/bash)" ]]; then
  if ! grep -q "$binroot/bash" "/etc/shells"; then
    e_header "Adding $binroot/bash to the list of acceptable shells"
    echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
    chsh -s $binroot/bash
  fi
fi

if [[ $HACK || $NET || $WAPT || $IOS || $BT || $MINHACK ]]; then
  # Temp fix for wireshark interfaces
  # -rw-r--r-- 1 root wheel
  if [[ "$(stat -L -f "%Sp:%Su:%Sg" /Library/LaunchDaemons/org.wireshark.ChmodBPF.plist)" != "-rw-r--r--:root:wheel" ]]; then
    curl "https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373" -o /tmp/ChmodBPF.tar.gz
    tar zxvf /tmp/ChmodBPF.tar.gz -C /tmp
    open /tmp/ChmodBPF/Install\ ChmodBPF.app
  fi
fi

if [[ $HACK || $BT ]]; then
  # Setup tools/env for Ubertooth hacking
  # Install Bluetooth baseband library (libbtbb) needs to be built for the
  # Ubertooth tools to decode Bluetooth packets:
  e_header "Bluetooth baseband library (libbtbb)"
  cd /tmp
  wget https://github.com/greatscottgadgets/libbtbb/archive/2015-10-R1.tar.gz -O libbtbb-2015-10-R1.tar.gz
  tar xf libbtbb-2015-10-R1.tar.gz
  cd libbtbb-2015-10-R1
  mkdir build
  cd build
  cmake ..
  make
  sudo make install

  e_header "Installing Ubertooth tools"
  cd /tmp
  wget https://github.com/greatscottgadgets/ubertooth/releases/download/2015-10-R1/ubertooth-2015-10-R1.tar.xz -O ubertooth-2015-10-R1.tar.xz
  tar xf ubertooth-2015-10-R1.tar.xz
  cd ubertooth-2015-10-R1/host
  mkdir build
  cd build
  cmake ..
  make
  sudo make install

fi

e_header "Installing Karabiner and Seil sets"
sudo -u $STANDARD_USER open -a karabiner
sleep 10
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" 'UPDATE access SET allowed = "1";'
sh $DOTFILES_HOME/conf/osx/key-bindings/karabiner-import.sh
sudo -u $STANDARD_USER pkill Karabiner
sudo -u $STANDARD_USER open -a Seil
sh $DOTFILES_HOME/conf/osx/key-bindings/seil-import.sh
sudo -u $STANDARD_USER pkill Seil

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
  e_header "Installing rbenv"
  sudo -H -u $STANDARD_USER CONFIGURE_OPTS=--enable-shared rbenv install 2.2.3
  sudo su $STANDARD_USER <<'EOF'
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
rbenv global 2.2.3
ruby -v
EOF
fi

if [[ $LOCAL ]]; then 
  e_header "Installing icalendar gem (mutt)"
  sudo su $STANDARD_USER <<'EOF'
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
gem install -v 1.5.4 icalendar
EOF

  e_header "Set TeXLive distribution"
  sudo texdist --setcurrent=TeXLive-2015
fi

if [[ $HACK || $IOS ]]; then
  # Setup tools/env for iOS hacking
  # https://github.com/NitinJami/keychaineditor.git (iDevice)
  # https://github.com/kasketis/netfox (iDevice)
  # https://github.com/nabla-c0d3/ssl-kill-switch2 (iDevice)
  # https://code.google.com/p/ccl-bplist/
  # http://www.crypticbit.com/zen/products/iphoneanalyzer
  # https://github.com/maciekish/iReSign.git

  e_header "Installing idb (iOS)"
  gem install idb
fi

if [[ ! $LOCAL ]]; then
  sudo -u $STANDARD_USER mkdir -p $USER_HOME/dev
  sudo -u $STANDARD_USER mkdir -p $USER_HOME/tools
fi
