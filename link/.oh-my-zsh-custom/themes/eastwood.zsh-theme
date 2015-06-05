# RVM settings
#if [[ -s ~/.rvm/scripts/rvm ]] ; then 
#  RPS1="%{$fg[yellow]%}rvm:%{$reset_color%}%{$fg[red]%}\$(~/.rvm/bin/rvm-prompt)%{$reset_color%} $EPS1"
#else
#  if which rbenv &> /dev/null; then
#    RPS1="%{$fg[yellow]%}rbenv:%{$reset_color%}%{$fg[red]%}\$(rbenv version | sed -e 's/ (set.*$//')%{$reset_color%} $EPS1"
#  fi
#fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown
# Customized git status
git_custom_status() {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

battery() {
    ~/.dotfiles/bin/bat_charge
}

PROMPT='%n@%m%{$fg[cyan]%}[%2~]$(git_custom_status)%{$reset_color%}%B$%b '
RPROMPT='%{$fg[blue]%}$(battery)% %{$reset_color%}'
