$(get_os 'osx') || return 1

if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  e_header "Installing Homebrew pks on first run"
fi

# Exit if, for some reason, Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Homebrew failed to install." && return 1

# Just incase we set the path again over here.
# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
PATH=/usr/local/bin:$(path_remove /usr/local/bin)
PATH=/usr/local/sbin:$(path_remove /usr/local/sbin)
export PATH

# Make sure we’re using the latest Homebrew
e_header "Brew update"
brew update

# Upgrade any already-installed formulae
e_header "Brew upgrade"
brew upgrade --all

e_header "Brew DR"
brew doctor

# Tap needed repo's
if [[ ! $MIN ]]; then
taps=("homebrew/dupes" "caskroom/cask" "caskroom/versions" "caskroom/fonts")
  if [[ $HACK || $NET ]]; then
    # Needed for Scapy
    taps+=("homebrew/python")
  fi

taps=($(setdiff "${taps[*]}" "$(brew tap)"))
if (( ${#taps[@]} > 0 )); then
  for a_tap in "${taps[@]}"; do
    e_header "Tapping Homebrew: $a_tap"
    brew tap $a_tap
  done
fi
fi

e_header "Running OSX Global Config"
# OSX Config. Can safely be run everytime.
source $DOTFILES_HOME/conf/osx/conf_osx_global.sh
