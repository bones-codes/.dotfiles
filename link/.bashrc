# Path to bash configuration.
export BASH=$HOME/.bash
export LESSHISTFILE="/dev/null"
export CLICOLOR=1
export GREP_OPTIONS='--color=auto'
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

source $BASH/aliases.sh
source $BASH/osx.sh
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

PS1="\u@\h\[$CYAN\][\w]\$([[ -n \$(git branch 2> /dev/null) ]])\$(parse_git_branch)\[$BASE0\]\[$RESET\]\$ "

# use vim
set -o vi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
