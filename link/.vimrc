filetype plugin indent on	         " filetype detection

call plug#begin('~/.vim/plugged')
Plug 'https://github.com/LaTeX-Box-Team/LaTeX-Box.git'
Plug 'https://github.com/Raimondi/delimitMate.git'
Plug 'https://github.com/scrooloose/syntastic.git'
Plug 'https://github.com/nelstrom/vim-markdown-folding.git'
Plug 'https://github.com/terryma/vim-multiple-cursors.git'
Plug 'https://github.com/will133/vim-dirdiff.git'
Plug 'https://github.com/d0c-s4vage/pct-vim.git'
Plug 'https://github.com/keith/swift.vim.git'
Plug 'https://github.com/guns/xterm-color-table.vim.git'
Plug 'https://github.com/altercation/vim-colors-solarized.git'
" Add plugins to &runtimepath
call plug#end()

" syntax and custom colorization -------------------

syntax on
let g:solarized_termtrans=1
let g:solarized_menu=0
colorscheme solarized

set hlsearch		                " highlight all search matches
highlight LineNr ctermfg=10 ctermbg=NONE
hi SpellBad ctermfg=015 ctermbg=000
hi VertSplit ctermbg=0 ctermfg=0
hi StatusLine ctermbg=0 ctermfg=6
hi StatusLineNC ctermbg=6 ctermfg=0

let g:netrw_liststyle=0             " use tree-mode as default view
let g:netrw_preview=1               " preview window shown in a vertically split
let g:netrw_dirhistmax=0            " no .netrwhist
let g:netrw_dirhist_cnt=0

set number
set numberwidth=3
set clipboard=unnamed
set hidden		                    " allow invisible buffers
set ignorecase		                " case-insensitive search
set smartcase		                " but be smart about it
set incsearch		                " search incrementally
"set tags=./tags		             " ctags
set tags=tags;/		                " ctags
set nocompatible
set backspace=2
set history=10000
set guioptions=aAegiM	            " turn off the GUI
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set cursorline                      " cursorcolumn
set wildchar=<TAB>
set wildmode=longest,list,full
set wildmenu

autocmd BufNewFile,BufRead *.md set filetype=markdown

" statusline ---------------------------------------
" format markers:
" %t File name (tail) of file in the buffer
" %m Modified flag, text is " [+]"; " [-]" if 'modifiable' is off.
" %r Readonly flag, text is " [RO]".
" %y Type of file in the buffer, e.g., " [vim]".
" %= Separation point between left and right aligned items.
" %l Line number.
" %L Number of lines in buffer.
" %c Column number.
" %P percentage through buffer
set statusline=\ %t\ %m%r%y%=(%l/%L,%c)\ (%P)\ 
set laststatus=2

" key mappings -------------------------------------
xnoremap p pgvy
map ** gwap
map ~~ :w<CR> :!make<CR>
map ww :w !sudo tee %
map -s :call ToggleSpellCheck()         
map ++ :call ToggleSolarLight()         
map -- :call ToggleSolarDark()         

" custom functions ---------------------------------
set spell spelllang=
function! ToggleSpellCheck()
    if &spelllang == 'en_us'
        set spell spelllang=
        echo "Spell check disabled"
    else
        !iconv -f UTF-16 -t ASCII//TRANSLIT ~/.vim/spell/spellcheck-word-list.dic > ~/.vim/spell/spellcheck-word-list.ascii
        mkspell! ~/.vim/spell/en.utf-8.add
        set spell spelllang=en_us
        echo "Spell check enabled"
    endif
endfunction

function! ToggleSolarLight()
    hi CursorLine   cterm=NONE ctermbg=6 ctermfg=0
endfunction

function! ToggleSolarDark()
    hi CursorLine   cterm=NONE ctermbg=0 ctermfg=NONE
endfunction
