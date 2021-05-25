if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Leeraste als <leader>
let mapleader="\<Space>"
let maplocalleader="\\"

"" Plugins
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'

" Themes
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'morhetz/gruvbox'

" Git
Plug 'tpope/vim-fugitive'

" File handling
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

" tmux
Plug 'christoomey/vim-tmux-navigator'
call plug#end()

" Layout Options
set termguicolors
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
set background=dark
colorscheme gruvbox

" Base16
" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   source ~/.vimrc_background
" endif

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
set textwidth=100
set colorcolumn=+1

" AirLine settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" Scrolling
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" Buffer handling
nmap <Leader>h :bprevious<cr>
nmap <Leader>l :bnext<cr>
nmap <leader>bq :bp <BAR> bd #<cr>
nmap <leader>bl :ls<cr>
nmap <leader>b :CtrlPBuffer<cr>

"Custom Leader Shortcuts
nnoremap <Leader>x :q!<cr>
nnoremap <Leader>w :w<cr>
nnoremap <Leader>q :q<cr>

"Custom Shortcuts
imap jk <Esc>
