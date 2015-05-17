# Dotfiles

My OS X / Linux dotfiles --- a shameless rip-off of Raviv Cohen's brilliant dotfiles (https://github.com/ravivcohen/dotfiles) with just a few modifications.

## What, exactly, does the "dotfiles" command do?

It's really not very complicated. When [dotfiles][dotfiles] is run, it does a few things:

1. Git is installed if necessary (on Ubuntu, via APT. OSX is assumed to have Git installed).
2. This repo is cloned into the `~/.dotfiles` directory (or updated if it already exists / quits if dirty).
2. Files in `init` are executed:
    * In alphanumeric order, hence the "50_" names 
    * With permission constraints, files < "50_" are run as sudo.
3. Files in `copy` are copied into `~/`.
4. Files in `link` are linked into `~/`.

Note:

* The `backups` folder only gets created when necessary. Any files in `~/` that would have been overwritten by `copy` or `link` get backed up there.
* Files in `bin` are executable shell scripts (Eg. [~/.dotfiles/bin][bin] is added into the path).
* Files in `conf` just sit there. If a config file doesn't _need_ to go in `~/`, put it in there.

[dotfiles]: bin/dotfiles
[bin]: https://github.com/bones-codes/.dotfiles/tree/master/bin

## Installation
### Standalone user support
On my main machine, and in general, I tend to run as a non-privileged user. As such I make use of targetpw and runaspw see [man sudoers](http://www.sudo.ws/sudoers.man.html). Therefore even if the current account is compromised the attacker still needs to know either the root user or adminsitator user's password to run as a privileged user. Indeed this is a defense-in-depth mechanism only but is highly effective in many situations.  

#### Setup
On OSX:
   We can enable the root user and then follow Root enabled below. I choose to not enable the root user and instead make use of runaspw, in combination with setting the runas_default variable to a user who is an Administrator. This allows me to run sudo commands under the Admin user and also allows my user to run `sudo -u root` for root commands. The latter works because what `sudo -u root` with runaspw set really means is sudo sudo.
   * Create a group, for ex non_admin
   * Add standard users you want to have sudo access to this group
   * Add the following to /etc/sudoers
   
     ```
     Defaults:%non_admin runas_default=*user name*, runaspw
     
     %non_admin ALL=(ALL) ALL
     ```
Root enabled:
   We already have a root account that is either enabled or disabled and we know the password. We set all users in wheel, for example, to use the targetpw as follows:
   ```
    Defaults:%wheel targetpw
     
    %wheel ALL=(ALL) ALL
   ```
#### On First Run
  * On OSX you will be prompted if you need to run as a standard user. Saying Yes will cause the script to run the brew install as `sudo` and anything that needs root access as `sudo -u root` but will otherwise default to current user allowing you to customize user current preferences. 
  * On systems where u do know the root password no special steps are needed. The script just runs sudo as always, making use of roots actual password. 

### General Notes
* In order to run init scripts files that have an alphanumeric value < "50_" `sudo` privileges are required.
   * __You can skip the entire "init" step when prompted.__
   * The reason it is all or nothing for the "init" step is because the sudo steps install necessary software needed by the rest of the script. 
   * If you skip the "init" step, only copy/link will be executed.  

### Actual Installation 
```sh
bash -c "$(curl -fsSL http://bit.ly/bones-dots)"
```

If, for some reason, [bit.ly](https://bit.ly/) is down, you can use the canonical URL.

```sh
bash -c "$(curl -fsSL https://raw.github.com/bones-codes/.dotfiles/master/bin/dotfiles)"
```

### OS X
* Hombrew taps
   * homebrew/dupes 
   * caskroom/cask 
   * caskroom/fonts
   * caskroom/versions 

* Homebrew recipes
   * brew-cask 
   * ctags
   * readline --universal
   * sqlite --universal
   * gdbm --universal
   * openssl --universal
   * zsh 
   * duplicity
   * wget --with-iri
   * grep 
   * git 
   * ssh-copy-id  
   * git-extras
   * htop-osx 
   * coreutils 
   * findutils 
   * ack 
   * rename 
   * p7zip 
   * tmux
   * reattach-to-user-namespace
   * lesspipe --syntax-highlighting
   * python --universal
   * vim --with-python --with-ruby --with-perl --enable-cscope --enable-pythoninterp --override-system-vi
   * pass
   * keybase
   * apple-gcc42
   * dvtm
   * awscli
   * sslyze
   * masscan
   * nmap 
   * youtube-dl 
   * pkg-config 
   * mutt --with-confirm-attachement-patch --with-gpgme --with-pgp-verbose-mime-patch --with-trash-patch --with-ignore-thread-patch
   * contacts2 (https://raw.github.com/tgray/homebrew-tgbrew/master/contacts2.rb)
   * urlview
   * offlineimap
   * notmuch
   * "wireshark --with-headers --with-libpcap --with-libsmi --with-lua --with-qt --devel"

* Homebrew Casks
   * iterm2-nightly
   * java6 
   * firefox
   * karabiner
   * seil
   * vlc
   * transmit
   * adium 
   * vagrant 
   * mactex
   * wkhtmltopdf
   * razorsql
   * remote-desktop-connection

* Fonts
   * font-source-code-pro
   * font-source-sans-pro 

* OSX config script

### Ubuntu
(Outdated)
* APT packages
  * build-essential
  * libssl-dev
  * git-core
  * tree
  * sl
  * id3tool
  * cowsay
  * nmap
  * telnet
  * htop

### Global
Runs on all installs
* Initial directory setup
* Terminal themes are installed
* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)


## The ~/ "copy" step
Any file in the `copy` subdirectory will be copied into `~/`. Any file that _needs_ to be modified with personal information (like [.gitconfig](copy/.gitconfig) which contains an email address and private key) should be _copied_ into `~/`. Because the file you'll be editing is no longer in `~/.dotfiles`, it's less likely to be accidentally committed into your public dotfiles repo.

## The ~/ "link" step
Any file in the `link` subdirectory gets symbolically linked with `ln -s` into `~/`. Edit these, and you change the file in the repo. Don't link files containing sensitive data, or you might accidentally commit that data!

### Aliases and Functions
To keep things easy, I make use of Robby Russell's [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh). A custom .zshrc file is linked over and all my custom aliases functions go into [.oh-my-zsh-custom](link/.oh-my-zsh-custom) folder. All .zsh files in there will get sourced. 

## Scripts 
On top of the scripts in [.oh-my-zsh-custom](link/.oh-my-zsh-custom), there are some custom scripts in the bin folder I use all the time: 
   * burp_download - downloads and installs latest burp
   * checksum - OpenSSL checksum wrapper
   * cleanup - removes all copied/linked files (including .dotfiles) from ~/ 
   * multi_firefox - app-named profiles for firefox
   * scan - wrapper around nmap
   * update - simple script to update vim plugins, brews, and dotfiles
   * vimman - vim man page viewer
