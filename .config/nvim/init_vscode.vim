" Leeraste als <leader>
let mapleader="\<Space>"
let maplocalleader="\\"

set inccommand=nosplit

set termguicolors

" general settings
set nocompatible
set nowrap
set linebreak
set encoding=utf8
set number
set relativenumber
set numberwidth=2
set cursorline
set hlsearch
set splitright
set textwidth=120
set clipboard=unnamedplus

"Custom Leader Shortcuts
nmap <Leader>x :q!<cr>
nmap <Leader>w :w<cr>
nmap <Leader>q :q<cr>
nmap <Leader>h :nohlsearch<cr>

"VSCode Shortcuts
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

"Paste without replacing Buffer 
vnoremap p "_dP

