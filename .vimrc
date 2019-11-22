if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree'

Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'

call plug#end()


" Layout Options
set background=dark
colorscheme gruvbox

syntax on
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


" NERDTree
map <C-n> :NERDTreeToggle<CR>

" Navigate using ALT
noremap <A-h> <C-w>h
noremap <A-j> <C-w>j
noremap <A-k> <C-w>k
noremap <A-l> <C-w>l

" Auto resize Vim splits to active split
"set winwidth=104
"set winheight=5
"set winminheight=5
"set winheight=999

" Scrolling
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

"Map Ctrl + S to save in any mode
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>

"Custom Leader Shortcuts
nnoremap <Leader>x :q!<cr>


