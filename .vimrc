set ruler
set cursorline
set number
syntax on

filetype plugin indent on

" Set to auto read when a file is changed from the outside
set autoread

" Turn on the wild menu
set wildmenu

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Incremental Search
set incsearch

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" Enable syntax highlighting
syntax enable

" COLORS AND FONTS

set guifont=Inconsolata-dz-Powerline
let g:Powerline_symbols = 'fancy'

colorscheme desert
set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Be smart when using tabs
set smarttab
set tabstop=4
set shiftwidth=4
set expandtab

" Disable vi-compatibility
set nocompatible

" Always show the status line
set laststatus=2

set t_Co=256

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

map <C-n> :NERDTreeToggle<CR>

set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim

if has("gui_running")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        set guifont=Inconsolata-dz\ for\ Powerline
    endif
endif

let g:Powerline_colorscheme="solarized"

execute pathogen#infect()

