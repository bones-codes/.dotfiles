# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

#Some Sudo related stuff if your a STD user.
if [[ $(groups | grep -q -e '\badmin\b')$? -ne 0 ]]; then
    alias sudo="sudo -H -E TMPDIR=/tmp"
    alias rodo="sudo -u root"
fi

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Start ScreenSaver. This will lock the screen if locking is enabled.
alias ss="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"

if which gls &> /dev/null; then
	alias ls='gls --color=auto'
else
	alias ls='ls -apG'
fi

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

# Recursively delete `.DS_Store` files
alias dsstore="find . -name '*.DS_Store' -type f -ls -delete"

# Locks down a thumb drive so that Mac OS X will not write any metadata to it.
macosx_lockdown_drive() {
	srm -r -s -v .Trashes
	touch .Trashes
	srm -r -s -v .fseventsd
	touch .fseventsd
	srm -r -s -v .Spotlight-V100
	touch .Spotlight-V100
	touch .metadata_never_index
}

# burp
burpdirectory="$HOME/tools/burp/"
logfilename="$(date +%F_%H-%M-%S)"
alias burp='nohup java -jar -Xmx1024m ${burpdirectory}burp.jar >>${burpdirectory}/logs/${logfilename}_stdout.log 2>>${burpdirectory}/logs/${logfilename}_stderr.log &'

# firefox
alias firefox='nohup /Applications/Firefox.app/Contents/MacOS/firefox-bin -p > /dev/null 2>&1 &'

# google chrome
alias ggl="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir=/Users/huesos/.google/chrome/rc > /dev/null 2>&1 &"
alias chrome=ggl
alias google=ggl

