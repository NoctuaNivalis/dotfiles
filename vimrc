
"  Vundle plugins {{{
" ============================================================================ "

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/vimshell.vim'
Plugin 'tpope/vim-markdown'
Plugin 'altercation/vim-colors-solarized'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" Put your non-Plugin stuff after this line

" Configuring NerdTree
noremap <C-t> :NERDTreeToggle<CR><CR>
let NERDTreeIgnore=[
            \ ".*\\.class$",
            \ ".*\\.o$",
            \ ".*\\.hi$",
            \ ".*\\.pyc$"
            \ ]

" Configuring ctrlp
noremap <C-p> :CtrlP<CR>
noremap <C-o> :CtrlPBuffer<CR>

" Configuring Airline
let g:airline_powerline_fonts=1

" Configuring YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

" Configuring VimShell
noremap <C-s> :VimShell -split<CR>

" Loading Solarized
set t_Co=256
let g:solarized_termcolors=256
let g:solarized_contrast="normal"
let g:solarized_underline=0
let g:solarized_termtrans=0
syntax enable
set background=dark
colorscheme solarized

" }}}

"  General Options {{{
" ============================================================================ "

set number          " line numbers on the right side
set showcmd         " show the commands while typing
set splitright      " open new splits on the right
set splitbelow      " open new splits below
set autoread        " autoreload file on change
set scrolloff=8     " keep the cursor 8 lines away from the top/bottom
set ruler           " show the lines/% bottomright
set encoding=utf-8  " set default encoding
set laststatus=2    " always show the status line

" wrap lines at 80 characters
set formatprg=par\ -w80
set formatoptions=t
set textwidth=80

" indentation
set tabstop=4       " tab is 4 width
set softtabstop=4   " tab is 4 width
set shiftwidth=4    " for use with > and <
set expandtab       " tab key puts spaces
set autoindent      " in case filetype indent is wrong
filetype plugin indent on
set list            " if tabs, show them with 2 spaces
set listchars=tab:\·\ ,trail:·
                    " display tabs with a leading \cdot
                    " trailing whitespace looks like \cdot

" Don't save tmp/swap files in the current directory.
set directory=~/.vim/tmp/swap/
set backupdir=~/.vim/tmp/backup/

" Learning to use decent vim.
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Keep selection after indenting
vnoremap > >gv
vnoremap < <gv

" some shortcuts
" go to start of line
noremap H ^
" go to end of line
noremap L g_
" fuck you K
noremap K <nop>
" center screen with <space>
noremap <space> zz
" rewrite file with sudo
cmap w!! w !sudo tee % >/dev/null
" paste the clipboard
noremap <C-b> :r!xclip -sel c -o<CR><CR>

" }}}

"  Filetype specific configuration. {{{
" ============================================================================ "

"  Haskell {{{
" ---------------------------------------------------------------------------- "

autocmd FileType haskell call HaskellHook()
autocmd BufRead,BufNewFile *.lhs call HaskellHook()
autocmd BufRead,BufNewFile *.hsc set filetype=haskell

function HaskellHook()
    " Ghci shortcut
    noremap <C-i> :!ghci -Wall '%'<CR><CR>

    " Haskell Styling
    noremap <C-c> :%!stylish-haskell<CR>
    noremap <C-x> :!hlint %<CR>

    " Vim-hoogle
    noremap <C-h> :Hoogle 
    noremap <C-j> :HoogleClose<CR>
endfunction

" }}}

"  Java {{{
" ---------------------------------------------------------------------------- "

autocmd FileType java call JavaHook()

function JavaHook()
    " Javac shortcut
    noremap <C-c> :!javac %<CR>

    " Java shortcut
    noremap <C-i> :!java %:r<CR>
endfunction

" }}}

"  C {{{
" ---------------------------------------------------------------------------- "

autocmd FileType c call CHook()

function CHook()
    " gcc shortcut
    noremap <C-c> :!gcc % -o %:r<CR>

    " execute
    noremap <C-i> :!./%:r<CR>
endfunction

" }}}

"  Ruby {{{
" ---------------------------------------------------------------------------- "

autocmd FileType ruby call RubyHook()
autocmd FileType eruby call RubyHook()

function RubyHook()
    setlocal tabstop=2
    setlocal shiftwidth=2
    set softtabstop=2
    noremap <C-i> :!irb -Ilib -r ./%<CR><CR>

    " Use rake as makeprogram
    set makeprg=rake

    " Folding
    set foldmethod=syntax
endfunction

" }}}

"  R {{{
" ---------------------------------------------------------------------------- "

autocmd FileType r call RHook()

function RHook()
    " Interactive shortcut
    noremap <C-i> :'<,'>w !R --no-save --interactive<CR><CR>
endfunction

" }}}

"  Latex {{{
" ---------------------------------------------------------------------------- "

autocmd FileType tex call TexHook()

function TexHook()
    setlocal tabstop=2
    setlocal shiftwidth=2
    set softtabstop=2
    " Make a pdf
    noremap <C-c> :!pdflatex '%'<CR><CR>
    noremap <C-i> :!spawn zathura '%:p:r.pdf'<CR><CR>
endfunction

" }}}

"  Markdown {{{
" ---------------------------------------------------------------------------- "

autocmd Filetype markdown call MarkdownHook()

function MarkdownHook()
    " Making and showing html
    noremap <C-c> :!markdown '%:p' > '%:p:r.html'<CR><CR>
    noremap <C-i> :!spawn firefox '%:p:r.html'<CR><CR>
endfunction

" }}}

"  Python {{{
" ---------------------------------------------------------------------------- "

autocmd FileType python call PythonHook()

function Pylint()
    silent !pylint --reports=n --output-format=parseable '%' > errors.err 2> /dev/null
    cfile
    silent !rm errors.err
    redraw!
    copen
endfunction

function PythonFold(lnum)
    if getline(a:lnum-1) =~ '^\s*def\s' || getline(a:lnum-1) =~ '^\s*class\s'
        return indent(a:lnum-1) / 4 + 1
    endif
    if getline(a:lnum) =~ '^\s*def\s' || getline(a:lnum) =~ '^\s*class\s'
        return indent(a:lnum) / 4
    endif
    if getline(a:lnum+1) =~ '^\s*def\s' || getline(a:lnum+1) =~ '^\s*class\s'
        return indent(a:lnum + 1) / 4
    endif
    if getline(a:lnum+1) =~ '^\S.*$'
        return '0'
    endif
    return '='
endfunction

function PythonFoldText()
    return repeat(' ', indent(v:foldstart - 1) + 4) . '+'
endfunction

function PythonHook()
    set formatoptions+=rq
    noremap <C-i> :!python -i '%'<CR><CR>
    noremap <C-x> :call Pylint()<CR>
    " Uncomment to fold. Slows down SuperTab extremely
    set foldmethod=expr
    set foldexpr=PythonFold(v:lnum)
    set foldtext=PythonFoldText()
endfunction

" }}}

" }}}

" vim: foldmethod=marker