ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function current_branch() {
  local ref
  # Query/use custom command for `git`.
  local git_cmd
  zstyle -s ":vcs_info:git:*:-all-" "command" git_cmd
  : ${git_cmd:=git}

  ref=$($git_cmd symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$($git_cmd rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

battery() {
    ~/.dotfiles/bin/bat_charge
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown
# Customized git status
git_custom_status() {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

PROMPT='%n@%m%{$fg[cyan]%}[%2~]$(git_custom_status)%{$reset_color%}%B$%b '
RPROMPT='%{$fg[blue]%}$(battery)% %{$reset_color%}'
