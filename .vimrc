" Run as Vim and not compatible with Vi
set nocompatible

" Each time we edit a new or existing file the type of the file is recognized
" and the filetype option is set. The FileType event is sent. This event can
" be used to enable file specific syntax highlighting or loading of options 
" specific to that file type.
filetype on

" When you edit a file vim will load the plugin file if there is a plugin file
" for the detected file type. The plugin file is where you can have options
" that are specific to a certain file type.
filetype plugin on

" Show line numbers
set number

" Enable syntax highlighting
syntax enable

" Use the goodwolf colorscheme found in ~/.vim.d/colors/goodwolf.vim
" This theme was downloaded from here. 
" https://github.com/sjl/badwolf/blob/master/colors/goodwolf.vim
colorscheme goodwolf

" Set the maximum text width. The purpose is to wrap lines automatically.
set textwidth=80

" Make backspace behave in a more sane manner.
set backspace=indent,eol,start

" Disable the bell.
set belloff=all

" No backup files
set nobackup

" No swap files. We have enough memory
set noswapfile

" Turn off the startup message.
set shortmess+=I

" Open new splits on the right or below.
set splitbelow
set splitright

" Make it so that files that are opened are fully unfolded.
set foldlevelstart=99
