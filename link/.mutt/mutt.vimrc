syntax on
hi SpellBad ctermfg=015 ctermbg=000

set nocompatible
set backspace=indent,eol,start
set nobackup
set history=20
set ruler
set number
set numberwidth=3
set showcmd
set incsearch
set ignorecase
set smartcase
set hlsearch
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set nomodeline
set tags=tags

" key mappings -------------------------------------
xnoremap p pgvy
map ** gwap
map -s :call ToggleSpellCheck()         

" custom functions ---------------------------------
set spell spelllang=
function! ToggleSpellCheck()
    if &spelllang == 'en_us'
        set spell spelllang=
        echo "Spell check disabled"
    else
        set spell spelllang=en_us
        echo "Spell check enabled"
    endif
endfunction
