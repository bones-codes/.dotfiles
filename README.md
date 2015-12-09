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
```sh
bash -c "$(curl -fsSL http://bit.ly/bones--dots)"
```

If, for some reason, [bit.ly](https://bit.ly/) is down, you can use the canonical URL.

```sh
bash -c "$(curl -fsSL https://raw.github.com/bones-codes/.dotfiles/master/bin/dotfiles)"
```

Use the following to install with options.
```sh
curl -fsSL http://bit.ly/bones--dots | bash -s [ARG]
```

### Standalone user support
On my main machine, and in general, I tend to run as a non-privileged user. As such I make use of targetpw and runaspw see [man sudoers](http://www.sudo.ws/sudoers.man.html). Therefore even if the current account is compromised the attacker still needs to know either the root user or adminsitator user's password to run as a privileged user. This is a defense-in-depth mechanism only but is highly effective in many situations.  

### Setup
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

### On First Run
  * On OSX you will be prompted if you need to run as a standard user. Saying Yes will cause the script to run the brew install as `sudo` and anything that needs root access as `sudo -u root` but will otherwise default to current user allowing you to customize user current preferences. 
  * On systems where u do know the root password no special steps are needed. The script just runs sudo as always, making use of root's actual password. 

