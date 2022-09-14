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
set clipboard=unnamedplus

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
nmap <Leader>h :nohlsearch<cr>


"VSCode Shortcuts
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine


"Custom Shortcuts
imap jk <Esc>

"move lines around
function! MoveVisualSelection(direction)
     ": Summary: This calls the editor.action.moveLines and manually recalculates the new visual selection

    let markStartLine = "'<"                     " Special mark for the start line of the previous visual selection
    let markEndLine =   "'>"                     " Special mark for the end line of the previous visual selection
    let startLine = getpos(markStartLine)[1]     " Getpos(mark) => [?, lineNum, colNumber, ?]
    let endLine = getpos(markEndLine)[1]
    let removeVsCodeSelectionAfterCommand = 1    " We set the visual selection manually after this command as otherwise it will use the line numbers that correspond to the old positions
    call VSCodeCallRange('editor.action.moveLines'. a:direction . 'Action', startLine, endLine, removeVsCodeSelectionAfterCommand )

    if a:direction == "Up"                       " Calculate where the new visual selection lines should be
        let newStart = startLine - 1
        let newEnd = endLine - 1
    else ": == 'Down'
        let newStart = startLine + 1
        let newEnd = endLine + 1
    endif

    ": This command basically:
    ": 1. Jumps to the `newStart` line
    ": 2. Makes a linewise visual selection
    ": 3. Jumps to the `newEnd` line
    let newVis = "normal!" . newStart . "GV". newEnd . "G"
    ":                  │  └──────────────────── " The dot combines the strings together
    ":                  └─────────────────────── " ! means don't respect any remaps the user has made when executing
    execute newVis
endfunction

":        ┌───────────────────────────────────── " Exit visual mode otherwise our :call will be '<,'>call
vmap <A-j> <Esc>:call MoveVisualSelection("Down")<cr>
vmap <A-k> <Esc>:call MoveVisualSelection("Up")<cr>

