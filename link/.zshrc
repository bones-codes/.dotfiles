# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
# Path to oh-my-zsh custom folder
ZSH_CUSTOM=$HOME/.oh-my-zsh-custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="eastwood"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

# OSX
if [[ $(uname) == "Darwin" ]] ; then
	#plugins=(git osx github brew)
	plugins=(osx github brew)

# Linux
else
	plugins=(git github battery)
fi

source $ZSH/oh-my-zsh.sh

export LESSHISTFILE=/dev/null
export CLICOLOR=1
export GREP_OPTIONS=--color=auto

ZSH_COMPDUMP=$HOME/.zcompdump

rm -rf .zcompdump*
zmodload -i zsh/complist
compinit -u "${ZSH_COMPDUMP}"

export PATH="$HOME/.rbenv/bin:$PATH"
echo 'eval "$(rbenv init -)"'
