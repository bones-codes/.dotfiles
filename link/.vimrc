call pathogen#infect()
call pathogen#helptags()

filetype plugin indent on	        " filetype detection

" syntax and custom colorization -------------------
syntax on
set background=dark
let g:solarized_termtrans=1
colorscheme solarized
set hlsearch		                " highlight all search matches
highlight LineNr ctermfg=10 ctermbg=NONE
hi SpellBad ctermfg=015 ctermbg=000
hi CursorLine   cterm=NONE ctermbg=0 ctermfg=NONE
hi VertSplit ctermbg=0 ctermfg=0
hi StatusLine ctermbg=0 ctermfg=6
hi StatusLineNC ctermbg=6 ctermfg=0


" lets, sets, and status ---------------------------
let g:netrw_liststyle=0             " use tree-mode as default view
let g:netrw_preview=1               " preview window shown in a vertically split
let g:netrw_dirhistmax=0            " no .netrwhist
let g:netrw_dirhist_cnt=0

set number
set numberwidth=3
set hidden		                    " allow invisible buffers
set ignorecase		                " case-insensitive search
set smartcase		                " but be smart about it
set incsearch		                " search incrementally
set et			                    " expand tabs to spaces
"set tags=./tags		                " ctags
set tags=tags;/		                " ctags
set guioptions=aAegiM	            " turn off the GUI
set nocompatible
set history=10000
set tabstop=4
set shiftwidth=4
set expandtab
set cursorline                      " cursorcolumn
set wildchar=<TAB>
set wildmode=longest,list,full
set wildmenu

autocmd BufNewFile,BufRead *.md set filetype=markdown

" statusline
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
so ~/.vimrc-local
