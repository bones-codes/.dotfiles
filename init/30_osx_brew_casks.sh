$(get_os 'osx') || return 1
[[ ! "$MIN" ]] || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

# Exit if, for some reason, cask is not installed.
[[ ! "$(brew ls --versions brew-cask)" ]] && e_error "Brew-cask failed to install." && return 1

casks=(iterm2-nightly firefox karabiner seil)

if [[ $HACK || $NET || $IOS || $WAPT ]]; then
  casks+=(java)
fi

if [[ $HACK || $NET ]]; then
  casks+=(transmit vlc razorsql transmit)
fi

if [[ $HACK || $IOS ]]; then
  casks+=(hopper-disassembler)
fi

if [ "$LOCAL" ]; then
  casks+=(1password adium vagrant mactex)
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
