"VIM configuration file

" The first thing we do is setup Vundle.
" The parts marked with 'required' are required
" for Vundle to work.
" https://github.com/VundleVim/Vundle.vim

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Solarized color theme
Plugin 'altercation/vim-colors-solarized'

" Vim git-gutter
Plugin 'airblade/vim-gitgutter'

" Airline status bar
Plugin 'vim-airline/vim-airline'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Enable solarized color theme
set term=xterm-256color
syntax enable
set background=dark
colorscheme solarized

" Needed for airline
" You also need to remember to install the powerline fonts.
" Instructions for this are in setup new machine.
" The font I like to use is 'Meslo LG S DZ'.
set laststatus=2
let g:airline_powerline_fonts=1


