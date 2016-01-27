# Path to bash configuration.
BASH=$HOME/.bash
LESSHISTFILE="/dev/null"
CLICOLOR=1
GREP_OPTIONS='--color=auto'
#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"

source $BASH/aliases.sh
source $BASH/osx.sh
source $BASH/colors.sh

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

parse_git_dirty () {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

parse_git_branch () {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/$RESET$RED$(parse_git_dirty)$GREEN[\1]/"
}

PS1="\[${BOLD}${CYAN}\]\u\[$BASE0\]@\[$CYAN\]\h\[$RESET\]\[$CYAN\][\w\[$BASE0\]]\$([[ -n \$(git branch 2> /dev/null) ]])\$(parse_git_branch)\[$BASE0\]\[$RESET\]\$ "

# use vim
set -o vi
