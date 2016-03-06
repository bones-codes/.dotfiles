$(get_os 'osx') || return 1
[[ ! "$MIN" ]] || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

# Exit if, for some reason, cask is not installed.
[[ ! "$(brew ls --versions brew-cask)" ]] && e_error "Brew-cask failed to install." && return 1

casks=(spectacle gpgtools iterm2-nightly karabiner seil)

if [[ $HAFH ]]; then
  casks+=(logitech-myharmony)
fi

if [[ $HACK || $NET ]]; then
  casks+=(transmit vlc razorsql vmware-fusion java firefox)
fi

if [[ $HACK || $REV ]]; then
  casks+=(hopper-disassembler)
fi

if [ "$LOCAL" ]; then
  casks+=(ricochet 1password vagrant mactex vmware-fusion little-snitch knockknock)
fi

# Install Homebrew casks.
casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
if (( ${#casks[@]} > 0 )); then
  for cask in "${casks[@]}"; do
    e_header "Installing Homebrew recipe: $cask"
    brew cask install --appdir="/Applications" $cask
  done
  brew cask cleanup
fi
