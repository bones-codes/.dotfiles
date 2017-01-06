$(get_os 'macOS') || return 1

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

# Opt out of brew analytics ---
# https://github.com/Homebrew/brew/blob/master/docs/Analytics.md
e_header "Disabling Homebrew analytics. insecure redirects, and casks without SHAs"
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha

# Make sure we’re using the latest Homebrew
e_header "Brew update"
brew update

# Upgrade any already-installed formulae
e_header "Brew upgrade"
brew upgrade

e_header "Brew DR"
brew doctor

# Tap needed repo's
if [[ ! $MIN ]]; then
taps=("homebrew/dupes" "caskroom/cask" "caskroom/versions" "caskroom/fonts" "homebrew/completions")
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

if [ "$LOCAL" ]; then
  e_header "Running macOS Global Config"
  # macOS Config. Can safely be run everytime.
  source $DOTFILES_HOME/conf/macOS/conf_macOS_global.sh
fi
