export PS1="\h:\W \u\$ "
export LESSHISTFILE="/dev/null"
export CLICOLOR=1
export GREP_OPTIONS='--color=auto'

# yea, I'm lazy
alias ls='ls -apG'
alias grep='grep -nr'
alias vi='vim'
alias rm='srm'

# use vim
set -o vi

# locks down a thumb drive so that Mac OS X will not write any metadata to it.
macosx_lockdown_drive() {
	srm -r -s -v .Trashes
	touch .Trashes
	srm -r -s -v .fseventsd
	touch .fseventsd
	srm -r -s -v .Spotlight-V100
	touch .Spotlight-V100
	touch .metadata_never_index
}

