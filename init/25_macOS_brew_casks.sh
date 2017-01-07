$(get_os 'macOS') || return 1
[[ ! "$MIN" ]] || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

casks=(google-chrome gpgtools iterm2)

if [[ $HAFH ]]; then
  casks+=(logitech-myharmony)
fi

if [[ $HACK || $NET || $WAPT || $IOS || $BT || $MINHACK ]]; then
  casks+=(wireshark-chmodbpf)
fi

if [[ $HACK || $NET || $WAPT || $IOS || $MINHACK ]]; then
  casks+=(java firefox)
fi

if [[ $HACK || $NET ]]; then
  casks+=(transmit vlc vmware-fusion)
fi

if [[ $HACK || $REV ]]; then
  casks+=(hopper-disassembler)
fi

if [ "$LOCAL" ]; then
  casks+=(ricochet vagrant vagrant-manager mactex vmware-fusion little-snitch micro-snitch knockknock)
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
