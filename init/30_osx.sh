$(get_os 'osx') || return 1
[[ ! $MIN ]] || return 1

# htop
if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
  e_header "Updating htop permissions"
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

# ZSH
if [[ "$(type -P $binroot/zsh)" ]]; then
  if ! grep -q "$binroot/zsh" "/etc/shells"; then
    e_header "Adding $binroot/zsh to the list of acceptable shells"
    echo "$binroot/zsh" | sudo tee -a /etc/shells >/dev/null
  fi
fi

if [[ $HACK || $NET || $WAPT || $IOS || $BT || $BHACK]]; then
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
  wget https://github.com/greatscottgadgets/libbtbb/archive/2015-10-R1.tar.gz -O libbtbb-2015-10-R1.tar.gz
  tar xf libbtbb-2015-10-R1.tar.gz
  cd libbtbb-2015-10-R1
  mkdir build
  cd build
  cmake ..
  make
  sudo make install

  e_header "Installing Ubertooth tools"
  wget https://github.com/greatscottgadgets/ubertooth/releases/download/2015-10-R1/ubertooth-2015-10-R1.tar.xz -O ubertooth-2015-10-R1.tar.xz
  tar xf ubertooth-2015-10-R1.tar.xz
  cd ubertooth-2015-10-R1/host
  mkdir build
  cd build
  cmake ..
  make
  sudo make install

fi

# Install Slate
if [[ $LOCAL ]]; then
  if [[ ! -e "/Applications/Slate.app" ]]; then
    e_header "Installing Slate"
    cd /Applications && curl https://www.ninjamonkeysoftware.com/slate/versions/slate-latest.tar.gz | tar -xz
  fi
fi

e_header "Installing Karabiner and Seil sets"
open -a karabiner
sleep 10
pkill Karabiner
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" 'UPDATE access SET allowed = "1";'
sh $DOTFILES_HOME/conf/osx/key-bindings/karabiner-import.sh
sh $DOTFILES_HOME/conf/osx/key-bindings/seil-import.sh

if [[ "$(type -P pip)" ]]; then
  e_header "Install and/or Upgrade PIP"
  pip -q install --upgrade pip
  pip -q install --upgrade setuptools
  pip -q install --upgrade distribute

  e_header "Install VirualEnv + VirtualEnvWrapper"
  pip -q install --upgrade virtualenv 
  pip -q install --upgrade virtualenvwrapper

fi

if [[ $LOCAL || $IOS || $RUBY ]]; then 
  # Install Ruby -- using rbenv to manage Ruby versions
  # https://gorails.com/setup/osx/10.11-el-capitan
  e_header "Installing rbenv"
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
  source $USER_HOME/.bashrc
  CONFIGURE_OPTS=--enable-shared rbenv install 2.2.3
  rbenv shell 2.2.3
  ruby -v
fi
