" basics -------------------------------------------
syntax on
set background=dark
let g:solarized_termtrans=1
let s:back = "NONE"
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
"setlocal fo+=aw

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

" custom vim colorscheme ---------------------------
function! s:SetOption(name,default)
    if type(a:default) == type(0)
        let l:wrap=''
        let l:ewrap=''
    else
        let l:wrap='"'
        let l:ewrap='\"'
    endif
    if !exists("g:solarized_".a:name) || g:solarized_{a:name}==a:default
        exe 'let g:solarized_'.a:name.'='.l:wrap.a:default.l:wrap.'"'
    endif
endfunction

if ($TERM_PROGRAM ==? "apple_terminal" && &t_Co < 256)
    let s:solarized_termtrans_default = 1
else
    let s:solarized_termtrans_default = 0
endif
call s:SetOption("termtrans",s:solarized_termtrans_default)
call s:SetOption("degrade",0)
call s:SetOption("bold",1)
call s:SetOption("underline",1)
call s:SetOption("italic",1) " note that we need to override this later if the terminal doesn't support
call s:SetOption("termcolors",16)
call s:SetOption("contrast","normal")
call s:SetOption("visibility","normal")
call s:SetOption("diffmode","normal")
call s:SetOption("hitrail",0)
call s:SetOption("menu",1)

"}}}
" GUI & CSApprox hexadecimal palettes"{{{
" ---------------------------------------------------------------------
"
" Set both gui and terminal color values in separate conditional statements
" Due to possibility that CSApprox is running (though I suppose we could just
" leave the hex values out entirely in that case and include only cterm colors)
" We also check to see if user has set solarized (force use of the
" neutral gray monotone palette component)
if g:solarized_termcolors != 256 && &t_Co >= 16
    let s:vmode       = "cterm"
    let s:base03      = "8"
    let s:base02      = "0"
    let s:base01      = "10"
    let s:base00      = "11"
    let s:base0       = "12"
    let s:base1       = "14"
    let s:base2       = "7"
    let s:base3       = "15"
    let s:yellow      = "3"
    let s:orange      = "9"
    let s:red         = "1"
    let s:magenta     = "5"
    let s:violet      = "13"
    let s:blue        = "4"
    let s:cyan        = "6"
    let s:green       = "2"
else
    let s:vmode       = "cterm"
    let s:base03      = "234"
    let s:base02      = "235"
    let s:base01      = "239"
    let s:base00      = "240"
    let s:base0       = "244"
    let s:base1       = "245"
    let s:base2       = "187"
    let s:base3       = "230"
    let s:yellow      = "136"
    let s:orange      = "166"
    let s:red         = "124"
    let s:magenta     = "125"
    let s:violet      = "61"
    let s:blue        = "33"
    let s:cyan        = "37"
    let s:green       = "64"
endif
"}}}
" Formatting options and null values for passthrough effect "{{{
" ---------------------------------------------------------------------
    let s:none            = "NONE"
    let s:none            = "NONE"
    let s:t_none          = "NONE"
    let s:n               = "NONE"
    let s:c               = ",undercurl"
    let s:r               = ",reverse"
    let s:s               = ",standout"
    let s:ou              = ""
    let s:ob              = ""
"}}}
" Alternate light scheme "{{{
" ---------------------------------------------------------------------
if &background == "light"
    let s:temp03      = s:base03
    let s:temp02      = s:base02
    let s:temp01      = s:base01
    let s:temp00      = s:base00
    let s:base03      = s:base3
    let s:base02      = s:base2
    let s:base01      = s:base1
    let s:base00      = s:base0
    let s:base0       = s:temp00
    let s:base1       = s:temp01
    let s:base2       = s:temp02
    let s:base3       = s:temp03
    if (s:back != "NONE")
        let s:back    = s:base03
    endif
endif
"}}}
" Optional contrast schemes "{{{
" ---------------------------------------------------------------------
if g:solarized_contrast == "high"
    let s:base01      = s:base00
    let s:base00      = s:base0
    let s:base0       = s:base1
    let s:base1       = s:base2
    let s:base2       = s:base3
    let s:back        = s:back
endif
if g:solarized_contrast == "low"
    let s:back        = s:base02
    let s:ou          = ",underline"
endif
"}}}
" Overrides dependent on user specified values and environment "{{{
" ---------------------------------------------------------------------
if (g:solarized_bold == 0 || &t_Co == 8 )
    let s:b           = ""
    let s:bb          = ",bold"
else
    let s:b           = ",bold"
    let s:bb          = ""
endif

if g:solarized_underline == 0
    let s:u           = ""
else
    let s:u           = ",underline"
endif

"}}}
" Highlighting primitives"{{{
" ---------------------------------------------------------------------

exe "let s:bg_none      = ' ".s:vmode."bg=".s:none   ."'"
exe "let s:bg_back      = ' ".s:vmode."bg=".s:back   ."'"
exe "let s:bg_base03    = ' ".s:vmode."bg=".s:base03 ."'"
exe "let s:bg_base02    = ' ".s:vmode."bg=".s:base02 ."'"
exe "let s:bg_base01    = ' ".s:vmode."bg=".s:base01 ."'"
exe "let s:bg_base00    = ' ".s:vmode."bg=".s:base00 ."'"
exe "let s:bg_base0     = ' ".s:vmode."bg=".s:base0  ."'"
exe "let s:bg_base1     = ' ".s:vmode."bg=".s:base1  ."'"
exe "let s:bg_base2     = ' ".s:vmode."bg=".s:base2  ."'"
exe "let s:bg_base3     = ' ".s:vmode."bg=".s:base3  ."'"
exe "let s:bg_green     = ' ".s:vmode."bg=".s:green  ."'"
exe "let s:bg_yellow    = ' ".s:vmode."bg=".s:yellow ."'"
exe "let s:bg_orange    = ' ".s:vmode."bg=".s:orange ."'"
exe "let s:bg_red       = ' ".s:vmode."bg=".s:red    ."'"
exe "let s:bg_magenta   = ' ".s:vmode."bg=".s:magenta."'"
exe "let s:bg_violet    = ' ".s:vmode."bg=".s:violet ."'"
exe "let s:bg_blue      = ' ".s:vmode."bg=".s:blue   ."'"
exe "let s:bg_cyan      = ' ".s:vmode."bg=".s:cyan   ."'"

exe "let s:fg_none      = ' ".s:vmode."fg=".s:none   ."'"
exe "let s:fg_back      = ' ".s:vmode."fg=".s:back   ."'"
exe "let s:fg_base03    = ' ".s:vmode."fg=".s:base03 ."'"
exe "let s:fg_base02    = ' ".s:vmode."fg=".s:base02 ."'"
exe "let s:fg_base01    = ' ".s:vmode."fg=".s:base01 ."'"
exe "let s:fg_base00    = ' ".s:vmode."fg=".s:base00 ."'"
exe "let s:fg_base0     = ' ".s:vmode."fg=".s:base0  ."'"
exe "let s:fg_base1     = ' ".s:vmode."fg=".s:base1  ."'"
exe "let s:fg_base2     = ' ".s:vmode."fg=".s:base2  ."'"
exe "let s:fg_base3     = ' ".s:vmode."fg=".s:base3  ."'"
exe "let s:fg_green     = ' ".s:vmode."fg=".s:green  ."'"
exe "let s:fg_yellow    = ' ".s:vmode."fg=".s:yellow ."'"
exe "let s:fg_orange    = ' ".s:vmode."fg=".s:orange ."'"
exe "let s:fg_red       = ' ".s:vmode."fg=".s:red    ."'"
exe "let s:fg_magenta   = ' ".s:vmode."fg=".s:magenta."'"
exe "let s:fg_violet    = ' ".s:vmode."fg=".s:violet ."'"
exe "let s:fg_blue      = ' ".s:vmode."fg=".s:blue   ."'"
exe "let s:fg_cyan      = ' ".s:vmode."fg=".s:cyan   ."'"

exe "let s:fmt_none     = ' ".s:vmode."=NONE".          " term=NONE".    "'"
exe "let s:fmt_bold     = ' ".s:vmode."=NONE".s:b.      " term=NONE".s:b."'"
exe "let s:fmt_bldi     = ' ".s:vmode."=NONE".s:b.      " term=NONE".s:b."'"
exe "let s:fmt_undr     = ' ".s:vmode."=NONE".s:u.      " term=NONE".s:u."'"
exe "let s:fmt_undb     = ' ".s:vmode."=NONE".s:u.s:b.  " term=NONE".s:u.s:b."'"
exe "let s:fmt_undi     = ' ".s:vmode."=NONE".s:u.      " term=NONE".s:u."'"
exe "let s:fmt_uopt     = ' ".s:vmode."=NONE".s:ou.     " term=NONE".s:ou."'"
exe "let s:fmt_curl     = ' ".s:vmode."=NONE".s:c.      " term=NONE".s:c."'"
exe "let s:fmt_stnd     = ' ".s:vmode."=NONE".s:s.      " term=NONE".s:s."'"
exe "let s:fmt_revr     = ' ".s:vmode."=NONE".s:r.      " term=NONE".s:r."'"
exe "let s:fmt_revb     = ' ".s:vmode."=NONE".s:r.s:b.  " term=NONE".s:r.s:b."'"
" revbb (reverse bold for bright colors) is only set to actual bold in low 
" color terminals (t_co=8, such as OS X Terminal.app) and should only be used 
" with colors 8-15.
exe "let s:fmt_revbb    = ' ".s:vmode."=NONE".s:r.s:bb.   " term=NONE".s:r.s:bb."'"
exe "let s:fmt_revbbu   = ' ".s:vmode."=NONE".s:r.s:bb.s:u." term=NONE".s:r.s:bb.s:u."'"

if has("gui_running")
    exe "let s:sp_none      = ' guisp=".s:none   ."'"
    exe "let s:sp_back      = ' guisp=".s:back   ."'"
    exe "let s:sp_base03    = ' guisp=".s:base03 ."'"
    exe "let s:sp_base02    = ' guisp=".s:base02 ."'"
    exe "let s:sp_base01    = ' guisp=".s:base01 ."'"
    exe "let s:sp_base00    = ' guisp=".s:base00 ."'"
    exe "let s:sp_base0     = ' guisp=".s:base0  ."'"
    exe "let s:sp_base1     = ' guisp=".s:base1  ."'"
    exe "let s:sp_base2     = ' guisp=".s:base2  ."'"
    exe "let s:sp_base3     = ' guisp=".s:base3  ."'"
    exe "let s:sp_green     = ' guisp=".s:green  ."'"
    exe "let s:sp_yellow    = ' guisp=".s:yellow ."'"
    exe "let s:sp_orange    = ' guisp=".s:orange ."'"
    exe "let s:sp_red       = ' guisp=".s:red    ."'"
    exe "let s:sp_magenta   = ' guisp=".s:magenta."'"
    exe "let s:sp_violet    = ' guisp=".s:violet ."'"
    exe "let s:sp_blue      = ' guisp=".s:blue   ."'"
    exe "let s:sp_cyan      = ' guisp=".s:cyan   ."'"
else
    let s:sp_none      = ""
    let s:sp_back      = ""
    let s:sp_base03    = ""
    let s:sp_base02    = ""
    let s:sp_base01    = ""
    let s:sp_base00    = ""
    let s:sp_base0     = ""
    let s:sp_base1     = ""
    let s:sp_base2     = ""
    let s:sp_base3     = ""
    let s:sp_green     = ""
    let s:sp_yellow    = ""
    let s:sp_orange    = ""
    let s:sp_red       = ""
    let s:sp_magenta   = ""
    let s:sp_violet    = ""
    let s:sp_blue      = ""
    let s:sp_cyan      = ""
endif

"}}}
" Basic highlighting"{{{
" ---------------------------------------------------------------------
" note that link syntax to avoid duplicate configuration doesn't work with the
" exe compiled formats

exe "hi! Normal"         .s:fmt_none   .s:fg_base0  .s:bg_back

"       *Comment         any comment

exe "hi! Constant"       .s:fmt_none   .s:fg_cyan   .s:bg_none
"       *Constant        any constant
"        String          a string constant: "this is a string"
"        Character       a character constant: 'c', '\n'
"        Number          a number constant: 234, 0xff
"        Boolean         a boolean constant: TRUE, false
"        Float           a floating point constant: 2.3e10

exe "hi! Identifier"     .s:fmt_none   .s:fg_blue   .s:bg_none
"       *Identifier      any variable name
"        Function        function name (also: methods for classes)
"
exe "hi! Statement"      .s:fmt_none   .s:fg_green  .s:bg_none
"       *Statement       any statement
"        Conditional     if, then, else, endif, switch, etc.
"        Repeat          for, do, while, etc.
"        Label           case, default, etc.
"        Operator        "sizeof", "+", "*", etc.
"        Keyword         any other keyword
"        Exception       try, catch, throw

exe "hi! PreProc"        .s:fmt_none   .s:fg_orange .s:bg_none
"       *PreProc         generic Preprocessor
"        Include         preprocessor #include
"        Define          preprocessor #define
"        Macro           same as Define
"        PreCondit       preprocessor #if, #else, #endif, etc.

exe "hi! Type"           .s:fmt_none   .s:fg_yellow .s:bg_none
"       *Type            int, long, char, etc.
"        StorageClass    static, register, volatile, etc.
"        Structure       struct, union, enum, etc.
"        Typedef         A typedef

exe "hi! Special"        .s:fmt_none   .s:fg_red    .s:bg_none
"       *Special         any special symbol
"        SpecialChar     special character in a constant
"        Tag             you can use CTRL-] on this
"        Delimiter       character that needs attention
"        SpecialComment  special things inside a comment
"        Debug           debugging statements

exe "hi! Underlined"     .s:fmt_none   .s:fg_violet .s:bg_none
"       *Underlined      text that stands out, HTML links

exe "hi! Ignore"         .s:fmt_none   .s:fg_none   .s:bg_none
"       *Ignore          left blank, hidden  |hl-Ignore|

exe "hi! Error"          .s:fmt_bold   .s:fg_red    .s:bg_none
"       *Error           any erroneous construct

exe "hi! Todo"           .s:fmt_bold   .s:fg_magenta.s:bg_none
"       *Todo            anything that needs extra attention; mostly the
"                        keywords TODO FIXME and XXX
"
"}}}
" Extended highlighting "{{{
" ---------------------------------------------------------------------
if      (g:solarized_visibility=="high")
    exe "hi! SpecialKey" .s:fmt_revr   .s:fg_red    .s:bg_none
    exe "hi! NonText"    .s:fmt_bold   .s:fg_red    .s:bg_none
elseif  (g:solarized_visibility=="low")
    exe "hi! SpecialKey" .s:fmt_bold   .s:fg_base02 .s:bg_none
    exe "hi! NonText"    .s:fmt_bold   .s:fg_base02 .s:bg_none
else
    exe "hi! SpecialKey" .s:fmt_bold   .s:fg_base00 .s:bg_base02
    exe "hi! NonText"    .s:fmt_bold   .s:fg_base00 .s:bg_none
endif
exe "hi! StatusLine"     .s:fmt_none   .s:fg_base1  .s:bg_base02 .s:fmt_revbb
exe "hi! StatusLineNC"   .s:fmt_none   .s:fg_base00 .s:bg_base02 .s:fmt_revbb
exe "hi! Visual"         .s:fmt_none   .s:fg_base01 .s:bg_base03 .s:fmt_revbb
exe "hi! Directory"      .s:fmt_none   .s:fg_blue   .s:bg_none
exe "hi! ErrorMsg"       .s:fmt_revr   .s:fg_red    .s:bg_none
exe "hi! IncSearch"      .s:fmt_stnd   .s:fg_orange .s:bg_none
exe "hi! Search"         .s:fmt_revr   .s:fg_yellow .s:bg_none
exe "hi! MoreMsg"        .s:fmt_none   .s:fg_blue   .s:bg_none
exe "hi! ModeMsg"        .s:fmt_none   .s:fg_blue   .s:bg_none
exe "hi! LineNr"         .s:fmt_none   .s:fg_base01 .s:bg_base02
exe "hi! Question"       .s:fmt_bold   .s:fg_cyan   .s:bg_none
if ( has("gui_running") || &t_Co > 8 )
    exe "hi! VertSplit"  .s:fmt_none   .s:fg_base00 .s:bg_base00
else
    exe "hi! VertSplit"  .s:fmt_revbb  .s:fg_base00 .s:bg_base02
endif
exe "hi! Title"          .s:fmt_bold   .s:fg_orange .s:bg_none
exe "hi! VisualNOS"      .s:fmt_stnd   .s:fg_none   .s:bg_base02 .s:fmt_revbb
exe "hi! WarningMsg"     .s:fmt_bold   .s:fg_red    .s:bg_none
exe "hi! WildMenu"       .s:fmt_none   .s:fg_base2  .s:bg_base02 .s:fmt_revbb
exe "hi! Folded"         .s:fmt_undb   .s:fg_base0  .s:bg_base02  .s:sp_base03
exe "hi! FoldColumn"     .s:fmt_none   .s:fg_base0  .s:bg_base02
if      (g:solarized_diffmode=="high")
exe "hi! DiffAdd"        .s:fmt_revr   .s:fg_green  .s:bg_none
exe "hi! DiffChange"     .s:fmt_revr   .s:fg_yellow .s:bg_none
exe "hi! DiffDelete"     .s:fmt_revr   .s:fg_red    .s:bg_none
exe "hi! DiffText"       .s:fmt_revr   .s:fg_blue   .s:bg_none
elseif  (g:solarized_diffmode=="low")
exe "hi! DiffAdd"        .s:fmt_undr   .s:fg_green  .s:bg_none   .s:sp_green
exe "hi! DiffChange"     .s:fmt_undr   .s:fg_yellow .s:bg_none   .s:sp_yellow
exe "hi! DiffDelete"     .s:fmt_bold   .s:fg_red    .s:bg_none
exe "hi! DiffText"       .s:fmt_undr   .s:fg_blue   .s:bg_none   .s:sp_blue
else " normal
    if has("gui_running")
exe "hi! DiffAdd"        .s:fmt_bold   .s:fg_green  .s:bg_base02 .s:sp_green
exe "hi! DiffChange"     .s:fmt_bold   .s:fg_yellow .s:bg_base02 .s:sp_yellow
exe "hi! DiffDelete"     .s:fmt_bold   .s:fg_red    .s:bg_base02
exe "hi! DiffText"       .s:fmt_bold   .s:fg_blue   .s:bg_base02 .s:sp_blue
    else
exe "hi! DiffAdd"        .s:fmt_none   .s:fg_green  .s:bg_base02 .s:sp_green
exe "hi! DiffChange"     .s:fmt_none   .s:fg_yellow .s:bg_base02 .s:sp_yellow
exe "hi! DiffDelete"     .s:fmt_none   .s:fg_red    .s:bg_base02
exe "hi! DiffText"       .s:fmt_none   .s:fg_blue   .s:bg_base02 .s:sp_blue
    endif
endif
exe "hi! SignColumn"     .s:fmt_none   .s:fg_base0
exe "hi! Conceal"        .s:fmt_none   .s:fg_blue   .s:bg_none
exe "hi! SpellBad"       .s:fmt_curl   .s:fg_none   .s:bg_none    .s:sp_red
exe "hi! SpellCap"       .s:fmt_curl   .s:fg_none   .s:bg_none    .s:sp_violet
exe "hi! SpellRare"      .s:fmt_curl   .s:fg_none   .s:bg_none    .s:sp_cyan
exe "hi! SpellLocal"     .s:fmt_curl   .s:fg_none   .s:bg_none    .s:sp_yellow
exe "hi! Pmenu"          .s:fmt_none   .s:fg_base0  .s:bg_base02  .s:fmt_revbb
exe "hi! PmenuSel"       .s:fmt_none   .s:fg_base01 .s:bg_base2   .s:fmt_revbb
exe "hi! PmenuSbar"      .s:fmt_none   .s:fg_base2  .s:bg_base0   .s:fmt_revbb
exe "hi! PmenuThumb"     .s:fmt_none   .s:fg_base0  .s:bg_base03  .s:fmt_revbb
exe "hi! TabLine"        .s:fmt_undr   .s:fg_base0  .s:bg_base02  .s:sp_base0
exe "hi! TabLineFill"    .s:fmt_undr   .s:fg_base0  .s:bg_base02  .s:sp_base0
exe "hi! TabLineSel"     .s:fmt_undr   .s:fg_base01 .s:bg_base2   .s:sp_base0  .s:fmt_revbbu
exe "hi! CursorColumn"   .s:fmt_none   .s:fg_none   .s:bg_base02
exe "hi! CursorLine"     .s:fmt_uopt   .s:fg_none   .s:bg_base02  .s:sp_base1
exe "hi! ColorColumn"    .s:fmt_none   .s:fg_none   .s:bg_base02
exe "hi! Cursor"         .s:fmt_none   .s:fg_base03 .s:bg_base0
hi! link lCursor Cursor
exe "hi! MatchParen"     .s:fmt_bold   .s:fg_red    .s:bg_base01

"}}}
" vim syntax highlighting "{{{
" ---------------------------------------------------------------------
"hi! link vimComment Comment
"hi! link vimLineComment Comment
hi! link vimVar Identifier
hi! link vimFunc Function
hi! link vimUserFunc Function
hi! link helpSpecial Special
hi! link vimSet Normal
hi! link vimSetEqual Normal
exe "hi! vimCommentString"  .s:fmt_none    .s:fg_violet .s:bg_none
exe "hi! vimCommand"        .s:fmt_none    .s:fg_yellow .s:bg_none
exe "hi! vimCmdSep"         .s:fmt_bold    .s:fg_blue   .s:bg_none
exe "hi! helpExample"       .s:fmt_none    .s:fg_base1  .s:bg_none
exe "hi! helpOption"        .s:fmt_none    .s:fg_cyan   .s:bg_none
exe "hi! helpNote"          .s:fmt_none    .s:fg_magenta.s:bg_none
exe "hi! helpVim"           .s:fmt_none    .s:fg_magenta.s:bg_none
exe "hi! helpHyperTextJump" .s:fmt_undr    .s:fg_blue   .s:bg_none
exe "hi! helpHyperTextEntry".s:fmt_none    .s:fg_green  .s:bg_none
exe "hi! vimIsCommand"      .s:fmt_none    .s:fg_base00 .s:bg_none
exe "hi! vimSynMtchOpt"     .s:fmt_none    .s:fg_yellow .s:bg_none
exe "hi! vimSynType"        .s:fmt_none    .s:fg_cyan   .s:bg_none
exe "hi! vimHiLink"         .s:fmt_none    .s:fg_blue   .s:bg_none
exe "hi! vimHiGroup"        .s:fmt_none    .s:fg_blue   .s:bg_none
exe "hi! vimGroup"          .s:fmt_undb    .s:fg_blue   .s:bg_none
"}}}
