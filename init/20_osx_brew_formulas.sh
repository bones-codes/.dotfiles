$(get_os 'osx') || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1


# Install Homebrew recipes.
if [ ! "$MIN" ]; then
recipes=(
  ack 
  "brew-cask"
  cmake
  coreutils 
  ctags 
  "curl --with-openssl"
  findutils 
  "gdbm --universal" 
  git 
  git-extras
  grep 
  htop-osx  
  "lesspipe --with-syntax-highlighting"
  "openssl --universal" 
  p7zip 
  pass
  "python --universal" 
  python3
  reattach-to-user-namespace
  rename 
  ssh-copy-id  
  tmux
  "vim --with-python3 --with-python --with-ruby --with-perl --enable-cscope 
  --enable-pythoninterp --override-system-vi"
  "wget --with-iri" 
  zsh 
)
fi

if [ "$LOCAL" ]; then
  recipes+=(
  keybase
  "mutt --with-confirm-attachment-patch --with-debug --with-gpgme 
  --with-ignore-thread-patch --with-pgp-verbose-mime-patch --with-trash-patch"
  "https://raw.github.com/tgray/homebrew-tgbrew/master/contacts2.rb"
  urlview
  offlineimap
  swig
  notmuch
  "profanity --with-terminal-notifier"
  w3m
  )

fi

if [[ $HACK || $IOS || $RUBY || $LOCAL ]]; then
  recipes+=(
  rbenv
  )
  
fi

if [[ $HACK || $MINHACK || $NET || $WAPT || $IOS || $BT ]]; then
  recipes+=(
  "wireshark --with-headers --with-libsmi --with-lua --with-qt --with-portaudio"
  testssl
  )
  
fi

if [[ $HACK || $NET ]]; then
  recipes+=(
  masscan
  nmap
  netcat
  "--with-python libdnet"
  scapy
  spoof-mac
  )
  
fi

if [[ $HACK || $IOS ]]; then
  recipes+=(
  qt 
  cmake 
  usbmuxd 
  libimobiledevice
  )
  
fi

if [[ $HACK || $BT ]]; then
  recipes+=(
  libusb 
  pkg-config 
  homebrew/dupes/libpcap
  )
  
fi

if [[ $MINHACK ]]; then
  recipes+=(
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

