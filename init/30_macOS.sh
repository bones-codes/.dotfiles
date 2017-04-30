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
  rm -rf "$DOTFILES_HOME/bin/usbkill"
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

if [[ $LOCAL || $HACK|| $IOS || $RUBY ]]; then 
  # Install Ruby -- using rbenv to manage Ruby versions
  # https://gorails.com/setup/osx/10.11-el-capitan
  e_header "Installing ruby 2.1.10"
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

  # For needle.py
  # https://github.com/mwrlabs/needle
  e_header "Installing needle (iOS)"
  cd "$HOME/.dotfiles/bin"
  git clone https://github.com/mwrlabs/needle.git

  e_header "Installing needle dependencies (iOS)"
  pip install readline
  pip install paramiko
  pip install sshtunnel
  pip install biplist

  # mitmproxy
  wget https://github.com/mitmproxy/mitmproxy/releases/download/v0.17.1/mitmproxy-0.17.1-osx.tar.gz
  tar -xvzf mitmproxy-0.17.1-osx.tar.gz
  sudo cp mitmproxy-0.17.1-osx/mitm* /usr/local/bin/
  rm mitmproxy-0.17.1-osx.tar.gz

  # https://www.frida.re/
  e_header "Installing Frida (iOS)"
  pip install frida

  # https://github.com/Nightbringer21/fridump
  e_header "Installing Fridump (iOS)"
  cd "$HOME/.dotfiles/bin"
  git clone https://github.com/Nightbringer21/fridump.git
fi

if [[ $HACK || $BT ]]; then
  e_header "Installing libbtbb (Ubertooth)"
  cd "$HOME/.dotfiles/bin"
  wget https://github.com/greatscottgadgets/libbtbb/archive/2015-10-R1.tar.gz -O libbtbb-2015-10-R1.tar.gz
  tar xf libbtbb-2015-10-R1.tar.gz
  cd libbtbb-2015-10-R1
  mkdir build
  cd build
  cmake ..
  make
  sudo make install
  # cleaning up
  cd "$HOME/.dotfiles/bin"
  rm -rf libbtbb-2015-10-R1.tar.gz 

  e_header "Installing various python modules (ubertooth-specan-ui)"
  pip install pyside numpy
  export DYLD_LIBRARY_PATH=/usr/local/lib/python2.7/site-packages/PySide

  e_header "Installing Ubertooth tools"
  cd "$HOME/.dotfiles/bin"
  wget https://github.com/greatscottgadgets/ubertooth/releases/download/2015-10-R1/ubertooth-2015-10-R1.tar.xz -O ubertooth-2015-10-R1.tar.xz
  tar xf ubertooth-2015-10-R1.tar.xz
  cd ubertooth-2015-10-R1/host
  mkdir build
  cd build
  cmake ..
  make
  sudo make install

  cd ../ubertooth-tools/
  mkdir build
  cd build
  cmake ..
  make
  sudo make install

  e_header "Installing crackle (Ubertooth)"
  cd "$HOME/.dotfiles/bin"
  git clone https://github.com/mikeryan/crackle.git
  cd crackle/
  make
  sudo make install
fi

if [[ ! $LOCAL ]]; then
  sudo -u $STANDARD_USER mkdir -p $USER_HOME/tools
fi
