export DOTFILES="$HOME/.dotfiles"

# Run dotfiles script, then source.
function dotfiles() {
  ~/.dotfiles/bin/dotfiles "$@"
}
alias dot="cd $HOME/.dotfiles/"
alias edot="vim $HOME/.dotfiles/"

# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

alias ls='ls -apG'
alias l='ls -F'
alias ll='ls -ltrh'
alias lla='ls -altrh'
alias la='ls -lhA'
alias l='ls -apG'
alias c='clear'
alias x='exit'
alias q='exit'

# Show line numbers and search recursively by default 
alias grep='grep -nr'

# File size
alias fs="stat -f '%z bytes'"
alias df="df -h"

# Use stronger encryption with hdiutil
alias hdc="hdiutil create -size 1g -encryption AES-256 -type SPARSE -fs HFS+" 
alias hda="hdiutil attach"
alias hdd="hdiutil detach"
alias hdr="diskutil rename"

# Aliasing eachdir like this allows you to use aliases/functions as commands.
alias eachdir=". eachdir"

# Create a new directory and enter it
function md() {
  mkdir -p "$@" && cd "$@"
}

# IP addresses
alias wanip="dig +short myip.opendns.com @resolver1.opendns.com"
alias whois="whois -h whois-servers.net"

# View HTTP traffic
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

alias top=htop
alias tmx='tmux -u attach'
alias dirbuster-ng="$HOME/.dotfiles/bin/dirbuster-ng/build/dirbuster-ng"
alias vi='vim'
