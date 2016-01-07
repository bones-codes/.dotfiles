$(get_os 'osx') || return 1

e_header "Running OSX Config"
# OSX Config. Can safely be run everytime.
source $DOTFILES_HOME/conf/osx/conf_osx.sh

if [[ $MIN ]]; then 
  e_header "Installing dot gists (MIN only)"
  cd ~
  curl -o .ackrc https://gist.githubusercontent.com/bones-codes/05d8bb86e2b7309cb769/raw/29dd74ff3a083c971c52669fd160533310d7696e/.ackrc
  rm .bashrc; curl -o .bashrc https://gist.githubusercontent.com/bones-codes/fa90062beaf08ff67f82/raw/cf6b89d44908c171d2e840a7d5371ab7e6c9636b/.bashrc 
  curl -o .tmux.conf https://gist.githubusercontent.com/bones-codes/c66c5974aa507f3ab6f9/raw/873a3e26fb17387ea3be30357de3f0489625090f/.tmux.conf
  curl -o .vimrc https://gist.githubusercontent.com/bones-codes/8a0b86468e9f7f226f94/raw/35df943415b5aa67484f397115446f5388fda4ce/.vimrc 
  return
fi

## iTerm
# If iTerm has never been run this wont exist. 
# We then run iTerm so we can config it.
if [[ ! -e ~/Library/Preferences/com.googlecode.iterm2.plist ]]; then
  open -a iTerm
  sleep 1
  killall iTerm2
fi

# Now for iTerm to load its setting from an external location.
defaults write  ~/Library/Preferences/com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
defaults write  ~/Library/Preferences/com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iTerm/";
    
# Download all the needed themes.
# Theme URL array
themes_array=(
      "https://raw.githubusercontent.com/tomislav/osx-terminal.app-colors-solarized/master/Solarized%20Dark.terminal"
      "https://raw.githubusercontent.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors"
      )
for i in "${themes_array[@]}"
do
# Strip https:/ and leave /
url_name="$(echo $i | sed 's~http[s]*:/~~g')"
# Pick last group in the path
filename=${url_name##/*/}
if [[ "${filename##*.}" == "itermcolors" &&
  "$(defaults read com.googlecode.iterm2 | grep -i -c "${filename%.*}")" != "0" ]]; then
  continue
elif [[ "${filename##*.}" == "terminal" &&
  "$(defaults read com.apple.terminal | grep -i -c "${filename%.*}")" != "0" ]]; then
  continue
fi
e_header "Installing theme: $filename"
# Get the File
curl -fsSL $i -o $filename
# Open file so it get init and sleep 1 to give it time
open $filename
sleep 1
# Delete the no longer needed file.
rm $filename
done

killall iTerm2

if [[ $HACK || $MINHACK || $NET || $WAPT || $IOS || $BT ]]; then
  e_header 'Installing dirbuster-ng'
  if [[ -e "$HOME/.dotfiles/bin/dirbuster-ng" ]]; then
    cd "$HOME/.dotfiles/bin/dirbuster-ng"
    git pull
    cd build
    cmake ..
    make install
  else
    cd "$HOME/.dotfiles/bin"
    git clone https://github.com/digination/dirbuster-ng.git
    cd dirbuster-ng; mkdir build; cd build
    cmake ..
    make install
  fi

  e_header "Installing Burp Suite"
  mkdir -p $USER_HOME/tools/burp/{backup,logs,tmp}
  if [[ -e "$DOTFILES_HOME/conf/local/" && ! $MIN && ! $LOCAL ]]; then
    ln -s $DOTFILES/conf/local/tools/burpsuite_pro_v*.jar $USER_HOME/tools/burp/
    cp $DOTFILES_HOME/conf/local/licenses/burp.txt $USER_HOME/tools/burp/burp-license.txt
  elif [[ $HACK || $NET || $IOS || $WAPT ]]; then
    cd $USER_HOME/tools/burp/
    curl -fsSL "https://portswigger.net/DownloadUpdate.ashx?Product=Free" -o burp.jar
  fi

  e_header "Installing fuzzdb"
  cd $USER_HOME/tools/burp
  git clone https://github.com/fuzzdb-project/fuzzdb.git fuzzdb
fi

#if [[ $HACK || $IOS || $REV ]]; then
  #TODO
  #  install from levine's site
  #  include https://code.google.com/p/iphone-dataprotection/source/browse/usbmuxd-python-client/tcprelay.py?r=1eae3bba5cd2713a372f6eff64e2778ba9d864e4 (move python scripts to gists)
  # script up the debugserver install (including sending to idevice)
  #nsxpc.d ---> gist
  #install xvim
  #ioregistryexplorer
  #open http://www.hackintoshosx.com/files/file/3600-ioregistryexplorer/
#fi

if [[ $HACK || $IOS ]]; then
  # Setup tools/env for iOS hacking
  # https://github.com/NitinJami/keychaineditor.git (iDevice)
  # https://github.com/nabla-c0d3/ssl-kill-switch2 (iDevice)
  # https://nabla-c0d3.github.io/blog/2013/08/20/intercepting-the-app-stores-traffic-on-ios/
  # https://github.com/kasketis/netfox (iDevice)
  # https://code.google.com/p/ccl-bplist/
  # http://www.crypticbit.com/zen/products/iphoneanalyzer
  e_header "Installing iReSign (iOS)"
  git clone https://github.com/maciekish/iReSign.git
  mv iReSign/iReSign.app /Applications/
  rm -rf iReSign/
fi
