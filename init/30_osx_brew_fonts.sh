$(get_os 'osx') || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

# Exit if, for some reason, cask is not installed.
[[ ! "$(brew ls --versions brew-cask)" ]] && e_error "Brew-cask failed to install." && return 1

# Install fonts.
fonts=(font-source-code-pro font-source-sans-pro)
fonts=($(setdiff "${fonts[*]}" "$(brew cask list 2>/dev/null)"))
if (( ${#fonts[@]} > 0 )); then
  for font in "${fonts[@]}"; do
    e_header "Installing Homebrew recipe: $font"
    brew cask install --fontdir=/Library/Fonts "$font"
  done
  brew cask cleanup
fi

osx_conf_dir=$DOTFILES_HOME/.dotfiles/conf/osx
msft_fonts_dir=$osx_conf_dir/msft_fonts/*

for font in $msft_fonts_dir
do
echo "Installing font: $font"
cp "$font" $USER_HOME/Library/Fonts/
done
