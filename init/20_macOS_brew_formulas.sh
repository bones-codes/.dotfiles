$(get_os 'macOS') || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1


# Install Homebrew recipes.
if [ ! "$MIN" ]; then
recipes=(
  ag
  bash
  bash-completion2
  cmake
  coreutils 
  ctags 
  "curl --with-openssl"
  duti
  findutils 
  "gdbm --universal" 
  git 
  git-extras
  grep 
  htop-osx  
  homebrew/completions/brew-cask-completion
  homebrew/completions/pip-completion
  mtr
  nmap
  netcat
  spoof-mac
  sqlite
  "openssl --universal" 
  p7zip 
  pass
  python 
  python3
  rename 
  reattach-to-user-namespace
  tmux
  "vim --with-python3 --with-override-system-vi"
  "wget --with-iri" 
)
fi

if [ "$LOCAL" ]; then
  recipes+=(
  keybase
  "mutt --with-debug --with-gpgme"
  "https://raw.github.com/tgray/homebrew-tgbrew/master/contacts2.rb"
  urlview
  offlineimap
  notmuch
  rbenv
  "profanity --with-terminal-notifier"
  homebrew/completions/vagrant-completion
  w3m
  )

fi

if [[ $HACK || $MINHACK || $NET || $WAPT || $IOS || $BT || $RESEARCH ]]; then
  recipes+=(
  rbenv
  homebrew/completions/gem-completion
  testssl
  "wireshark --with-headers --with-libsmi --with-lua --with-qt5 --with-portaudio"
  "gdb --with-all-targets --with-python"
  cgdb
  jython
  )
  
fi

if [[ $HACK || $NET ]]; then
  recipes+=(
  masscan
  nikto
  nmap
  netcat
  scapy
  spoof-mac
  )
  
fi

if [[ $HACK || $IOS ]]; then
  recipes+=(
  #qt
  #cmake 
  https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
  libxml2
  usbmuxd 
  #libimobiledevice
  )
  
fi

if [[ $HACK || $BT ]]; then
  recipes+=(
  libusb 
  pkg-config 
  cmake
  wget
  )
  
fi

if [[ $MINHACK ]]; then
  recipes+=(
  masscan
  nmap
  netcat
  )
  
fi

if [[ $MIN ]]; then
  recipes+=(
  pass
  tmux
  reattach-to-user-namespace
  "wget --with-iri" 
  )

fi

unset setdiffA setdiffB setdiffC;
setdiffA=("${recipes[@]}"); setdiffB=( $(brew list) ); setdiff
# Because brew hard fails incase one application fails.
# We call each install one by one.
for recipe in "${setdiffC[@]}"
do
  e_header "Installing Homebrew recipe: $recipe"
  brew install $recipe
done 

# This is where brew stores its binary symlinks
brewroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"
binroot=$brewroot/bin
cellarroot=$brewroot/Cellar
 
e_header "Brew cleanup"
# Remove outdated versions from the cellar
brew cleanup

e_header "Linking brewed apps"
##link all the apps 
brew linkapps > /dev/null
##force curl to use openssl
brew link --force curl

