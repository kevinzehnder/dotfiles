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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

" tmux
Plug 'christoomey/vim-tmux-navigator'
call plug#end()

" Layout Options
set termguicolors
let g:airline_theme='base16'
let g:airline_powerline_fonts = 1
set background=dark
colorscheme gruvbox

" Base16
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

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

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" FZF
map <C-p> :Files<CR>
map <Leader>f :Files<CR>

" let g:fzf_preview_window = 'right:50%' 
" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" macros

" Remap arrow keys to resize window
nnoremap <A-Up>    :resize -2<CR>
nnoremap <A-Down>  :resize +2<CR>
nnoremap <A-Right>  :vertical resize -2<CR>
nnoremap <A-Left> :vertical resize +2<CR>

" Scrolling
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" vim fugitive
nnoremap <Leader>gs :G<CR>
nnoremap <Leader>gl :G log<CR>

" Buffer handling
nmap <Leader>h :bprevious<cr>
nmap <Leader>l :bnext<cr>
nmap <leader>bq :bp <BAR> bd #<cr>
nmap <leader>o :Buffers<cr>

"Custom Leader Shortcuts
nnoremap <Leader>x :q!<cr>
nnoremap <Leader>w :w<cr>
nnoremap <Leader>q :q<cr>
nnoremap <Leader>g :Rg <cr>

"Custom Shortcuts
imap jk <Esc>
