" Leeraste als <leader>
let mapleader="\<Space>"
let maplocalleader="\\"

" YAML fix
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Indentation
set autoindent
set smartindent
let g:indentLine_char = '⦙'
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab"

" Layout Options
set termguicolors
let g:airline_theme='base16'
let g:airline_powerline_fonts = 1
set background=dark

" general settings
syntax on
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
highlight Comment cterm=italic
set colorcolumn=+1

" Remap arrow keys to resize window
nnoremap <A-Up>    :resize -2<CR>
nnoremap <A-Down>  :resize +2<CR>
nnoremap <A-Right>  :vertical resize -2<CR>
nnoremap <A-Left> :vertical resize +2<CR>

" Scrolling
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

"Custom Leader Shortcuts
nmap <Leader>x :q!<cr>
nmap <Leader>w :w<cr>
nmap <Leader>q :q<cr>

"Custom Shortcuts
imap jk <Esc>
