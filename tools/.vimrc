set nocompatible                " be iMproved
filetype off                    " required!
"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"let Vundle manage Vundle
Bundle 'VundleVim/Vundle.vim'

"my Bundle here:
"
" original repos on github
Bundle 'kien/ctrlp.vim'
Bundle 'sukima/xmledit'
Bundle 'sjl/gundo.vim'
Bundle 'tpope/vim-surround'
Bundle 'jiangmiao/auto-pairs'
Bundle 'klen/python-mode'
Bundle 'Valloric/ListToggle'
Bundle 'Valloric/YouCompleteMe'
Bundle 'SirVer/ultisnips'
Bundle 'honza/vim-snippets'
Bundle 'scrooloose/syntastic'
Bundle 't9md/vim-quickhl'
Bundle 'Lokaltog/vim-powerline'
Bundle 'powerline/powerline'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'Yggdroot/indentLine'
Bundle 'godlygeek/tabular'
"..................................
" vim-scripts repos
"Bundle 'YankRing.vim'
"Bundle 'vcscommand.vim'
"Bundle 'ShowPairs'
"Bundle 'SudoEdit.vim'
"Bundle 'EasyGrep'
"Bundle 'VOoM'
"Bundle 'VimIM'
"..................................
" non github repos
" Bundle 'git://git.wincent.com/command-t.git'
"......................................
call vundle#end()            " required
filetype plugin indent on


"configure YCM 
let g:ycm_show_diagnostics_ui = 0
let g:ycm_global_ycm_extra_conf = '/home/lhearen/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_error_symbol='>>'  
let g:ycm_warning_symbol='>*' 
let g:ycm_complete_in_comments = 1 
let g:ycm_seed_identifiers_with_syntax = 1 
let g:ycm_collect_identifiers_from_comments_and_strings = 1 
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

"configure SirVer/ultisnips
set runtimepath+=~/.vim/bundle
" use different snippets dir
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

"configure python-mode
let g:pymode_indent = 1
let g:pymode_folding = 1
let g:pymode_lint_message = 1
let g:pymode_rope_completion = 1
let g:pymode_rope_completion_bind = '<C-Space>'
let g:pymode_repo_autoimport = 0
let g:pymode_repo_goto_definition_bind = '<c-c>g'
let g:pymode_repo_goto_definition_cmd = 'e'
let g:pymode_breakpoint = 1
let g:pymode_lint_ignore = "E402,F401,F841,E302,E231,W"
let g:pymode_quickfix_minheight = 3
let g:pymode_quickfix_maxheight = 3
nnoremap prnp :PymodeRopeNewProject<cr>

"configure indentLine
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#09AA08'
let g:indentLine_char = '│'

"configure solarized
syntax enable
set background=dark
colorscheme molokai

"configure nerdtree
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"autocmd vimenter * NERDTree

"make sure the nerdcommenter works right
let mapleader=","
set timeout timeoutlen=1500


"configure Powerline
set laststatus=2
let g:Powerline_symbols = 'unicode'
let g:Powerline_theme = 'solarized256'
let g:Powerline_stl_path_style = 'full'

"configure syntastic for newie
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_quiet_messages = {"!level": "errors",
                \"type": "style"  }
nnoremap en :lnext<cr>
nnoremap ep :lprevious<cr>

"configure ctrlP
let g:ctrlp_working_path_mode = 'c'

"configure NerdTree
nnoremap nt :NERDTree<cr>


"basic mapping test here
inoremap jk <esc>
nnoremap <c-u> vaw~<esc>
nnoremap <leader>ev :vsplit $MYVIMRC <cr>
nnoremap <leader>sv :source $MYVIMRC <cr>
nnoremap wl <c-w>l
nnoremap wh <c-w>h
nnoremap wj <c-w>j
nnoremap wk <c-w>k
nnoremap zC mmggVGzc`m
nnoremap zO mmggVGzo`m

iabbrev LH@ E-mail: LHearen@126.com
iabbrev author@ Author: LHearen

set history=500		" keep 50 lines of command line history
" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set number
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set hidden		" Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif


setlocal foldlevel=1        
set foldlevelstart=99       
set foldmethod=indent
set foldnestmax=2
nnoremap <Space> za
