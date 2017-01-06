# Path to bash configuration.
export BASH=$HOME/.bash
export LESSHISTFILE="/dev/null"
export CLICOLOR=1
export GREP_OPTIONS='--color=auto'
export DOTFILES="$HOME/.dotfiles"
export GPG_TTY=`tty` 

if [[ "$OSTYPE" =~ ^darwin ]]; then
  # APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
  # Add binaries into the path
  export PATH=/Users/huesos/.rbenv/shims:/Users/huesos/.rbenv/bin:$DOTFILES/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin:/Library/TeX/texbin

  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_INSECURE_REDIRECT=1
  export HOMEBREW_CASK_OPTS=--require-sha
fi

# To get rbenv running...
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

source $BASH/aliases.sh
source $BASH/macOS.sh
source $BASH/colors.sh

parse_git_dirty () {
  my_string=$(git status 2> /dev/null | tail -n1)
  substring="nothing to commit"
  if [[ "${my_string/$substring}" == $my_string ]] ; then
    echo "*"
  else
    echo ""
  fi
}

parse_git_branch () {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/$RESET$RED$(parse_git_dirty)$GREEN[\1]/"
}

last_two_dirs () {
  pwd |rev| awk -F / '{print $1,$2}' | rev | sed s_\ _/_
}

PS1="\u@\h\[$CYAN\][\$(last_two_dirs)]\$([[ -n \$(git branch 2> /dev/null) ]])\[\$(parse_git_branch)$BASE0$RESET\]\$ "

# use vim
set -o vi
shopt -s checkwinsize

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
