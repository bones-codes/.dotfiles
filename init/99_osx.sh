$(get_os 'osx') || return 1

e_header "Running OSX Config"
# OSX Config. Can safely be run everytime.
source $DOTFILES_HOME/conf/osx/conf_osx.sh

if [[ $MIN ]]; then 
  rcs_array=(.ackrc
    .bashrc
    .bash_profile
    )

  for i in "${rcs_array[@]}"
  do
    ln -s $DOTFILES_HOME/link/$i $USER_HOME/$i 
  done

  cd ~
  curl https://gist.githubusercontent.com/bones-codes/c66c5974aa507f3ab6f9/raw/873a3e26fb17387ea3be30357de3f0489625090f/.tmux.conf   
  curl https://gist.githubusercontent.com/bones-codes/8a0b86468e9f7f226f94/raw/abefed4fb30891d485170e30ac3d677eee261cbb/.vimrc 

  return 1
fi

## iTerm
# If iTerm has never been run this wont exist. 
# We then run iTerm so we can config it.
if [[ ! -e ~/Library/Preferences/com.googlecode.iterm2.plist ]]; then
    open -a iTerm
    sleep 1
    killall iTerm
fi

## Karabiner & Seil
# Install keybinding settings TODO does this work?!?
e_header "Installing Karabiner and Seil sets"
sh $DOTFILES_HOME/conf/osx/key-bindings/karabiner-import.sh
sh $DOTFILES_HOME/conf/osx/key-bindings/seil-import.sh

# Now for iTerm to load its setting from an external location.
defaults write  ~/Library/Preferences/com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool TRUE
defaults write  ~/Library/Preferences/com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iTerm/";
    
# Download all the needed themes.
# Theme URL array
themes_array=("https://raw.githubusercontent.com/tomislav/osx-terminal.app-colors-solarized/master/Solarized%20Dark.terminal"
      "https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/OS%20X%20Terminal/Tomorrow%20Night.terminal"
      "https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/OS%20X%20Terminal/Tomorrow%20Night%20Eighties.terminal"
      "https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/iTerm2/Tomorrow%20Night.itermcolors"
      "https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/iTerm2/Tomorrow%20Night%20Eighties.itermcolors"
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

if [[ $HACK || $IOS ]]; then
  # Setup tools/env for iOS hacking
  e_header "Installing idb (iOS)"
  gem install idb
  # TODO need pentest-dev flag / isec flag
  # gem install brakeman bundler-audit
fi

if [[ $HACK || $NET ]]; then
  # Link RazorSQL profiles.txt
  e_header "Installing RazorSQL connection profiles"
  # If RazorSQL has never been run this wont exist. 
  # We then run RazorSQL so we can config it.
  if [[ ! -e ~/Library/RazorSQL/data/profiles.txt ]]; then
      open -a RazorSQL
      sleep 1
      killall RazorSQL
  fi
  ln -s $DOTFILES_HOME/conf/local/profiles.txt $USER_HOME/Library/RazorSQL/data/
fi

mkdir -p $USER_HOME/dev
mkdir -p $USER_HOME/tools
