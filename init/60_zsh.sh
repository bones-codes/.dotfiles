# Setup OH-MY-ZSH  
if [[ ! -e $USER_HOME/.oh-my-zsh ]]; then
    e_header "Setup oh-my-zsh"
    curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
fi

if get_os 'arch'; then
    if [[ $(whoami) == "vagrant" ]]; then
        sudo chsh -s "$(which zsh)" vagrant
    fi
fi
