-- Leeraste als <leader>
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- helper functions
function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

--- Check if a file or directory exists in this path
function exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

--- Check if a directory exists in this path
function isdir(path)
   -- "/" works on both Unix and Windows
   return exists(path.."/")
end


-- Plugins
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'vim-airline/vim-airline'

-- themes
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'morhetz/gruvbox'
Plug 'lifepillar/vim-solarized8'
Plug 'yggdroot/indentline'

-- git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

-- file handling
Plug 'scrooloose/nerdtree'
Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})
Plug 'junegunn/fzf.vim'

-- treesitter
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ":TSUpdate"})

-- lint and fix and complete
Plug 'w0rp/ale'
Plug('ms-jpq/coq_nvim', {['branch'] = 'coq'})

vim.call('plug#end')

require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}



-- Layout Options
vim.o.termguicolors = true
 vim.g["airline_theme"] = "atomic"
 vim.g["airline_powerline_fonts"] = 1

-- YAML fix
-- autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

-- Indentation
vim.opt.autoindent=true
vim.opt.smartindent = true
vim.g.indentLine_char = '⦙'
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true


vim.cmd( [[
" split visibility
function! AdaptColors() abort
    if g:colors_name ==# 'solarized8'
      if &background ==# 'light'
        highlight InactiveWindow guibg=#eee8d5
      else
        highlight InactiveWindow guibg=#073642
      endif
    else
      highlight InactiveWindow guibg=#181818
    endif
endfunction

function! Handle_Win_Enter() abort
  setlocal winhighlight=Normal:Normal,NormalNC:InactiveWindow
endfunction

augroup BgHighlight
  autocmd!
  autocmd ColorScheme * call AdaptColors()
  autocmd WinEnter,BufWinEnter * call Handle_Win_Enter()
augroup END
]])

-- colorscheme
if exists(os.getenv("HOME") .. "/.lightmode") then
  vim.o.background = "light"
  vim.cmd "colorscheme solarized8"
  vim.env.BAT_THEME = "Solarized (light)"
else
  vim.o.background = "dark"
  vim.cmd "colorscheme solarized8"
  vim.env.BAT_THEME = "Solarized (dark)"
end

if vim.env.BASE16_THEME == "gruvbox-dark-medium" then
  vim.cmd "colorscheme gruvbox"
  vim.g["airline_theme"] = "gruvbox"
  vim.env.BAT_THEME = "gruvbox-dark"
end

-- general settings
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.encoding = "utf8"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.textwidth = 120
-- vim.opt.ttimeoutlen=0

vim.cmd([[ highlight Comment cterm=italic ]])
vim.opt.colorcolumn = "+1"
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.backspace = indent,eol,start
vim.opt.clipboard = unnamedplus

-- undo
vim.opt.undodir = "$HOME/.nvim/undo"  --directory where the undo files will be stored
vim.opt.undofile = true

-- AirLine settings
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#tabline#buffer_nr_show"] = 0
vim.g["airline#extensions#whitespace#enabled"] = 0

-- NERDTree
nmap("<C-n>", ":NERDTreeToggle<CR>")

-- FZF
nmap("<C-p>", ":Files<CR>")
nmap("<C-p>", ":Files<CR>")
nmap("<Leader>f", ":Files<CR>")
nmap("<C-f>", ":BLines<CR>")
nmap("<C-b>", ":Buffers<CR>")
nmap("<C-g>", ":RG<CR>")

-- let g:fzf_preview_window = 'right:50
-- vim.g["fzf_layout"] = { window: { 'width': 0.9, 'height': 0.6  }  }

vim.cmd([[
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
]])


vim.env.FZF_DEFAULT_OPTS = "--ansi --preview-window 'right:60%' --layout=reverse --margin=1,4 --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
vim.env.FZF_DEFAULT_COMMAND ='rg --files --ignore-case --hidden -g "!{.git,node_modules,vendor}/*"'


vim.cmd([[
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* BLines
    \ call fzf#vim#grep(
    \   'rg --with-filename --column --line-number --no-heading --smart-case . '.fnameescape(expand('%:p')), 1,
    \   fzf#vim#with_preview({'options': '--layout reverse --query '.shellescape(<q-args>).' --with-nth=4.. --delimiter=":"'}, 'right:50%'))
    " \   fzf#vim#with_preview({'options': '--layout reverse  --with-nth=-1.. --delimiter="/"'}, 'right:50%'))

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
]])

-- ALE
nmap("<C-e>", ":ALENext<CR>")
vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'
vim.g.ale_sign_error = '✘'
vim.g.ale_sign_warning = '⚠'

-- highlight ALEErrorSign ctermbg=NONE ctermfg=red
-- highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
-- vim.g.ale_fixers = 
	-- {'yaml': ['prettier', 'yamlfix'],}

nmap("<F8>", "<Plug>(ale_fix)")

-- Remap arrow keys to resize window
nmap("<A-down>", ":resize -2<CR>")
nmap("<A-up>", ":resize +2<CR>")
nmap("<A-right>", ":vertical resize -2<CR>")
nmap("<A-left>", ":vertical resize +2<CR>")

-- Scrolling
vim.o.scrolloff = 8  -- Start scrolling when we're 8 lines away from margins
vim.o.sidescrolloff = 15
vim.o.sidescroll = 1

-- vim fugitive
nmap("<Leader>gs", ":G<CR>")
nmap("<Leader>gl", ":G log<CR>")

-- gitgutter
vim.g.gitgutter_map_keys = 0

-- Buffer handling
nmap("<Leader>h", ":bprevious<cr>")
nmap("<Leader>l", ":bnext<cr>")
nmap("<leader>bq", ":bp <BAR> bd #<cr>")
nmap("<leader>bl", ":ls<cr>")
nmap("<leader>o", ":Buffers<cr>")

-- Better window navigation
map("n", "<C-h>", "<C-w>h" )
map("n", "<C-j>", "<C-w>j" )
map("n", "<C-k>", "<C-w>k" )
map("n", "<C-l>", "<C-w>l" )

-- Visual --
-- Move text up and down
map("v", "<A-k>", ":m .-2<CR>==" )
map("v", "<A-j>", ":m .+1<cr>==" )

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv" )
map("x", "K", ":move '<-2<CR>gv-gv" )
map("x", "<A-j>", ":move '>+1<CR>gv-gv" )
map("x", "<A-k>", ":move '<-2<CR>gv-gv" )

-- Custom Leader Shortcuts
nmap("<Leader>x", ":q!<cr>")
nmap("<Leader>w", ":w<cr>")
nmap("<Leader>q", ":q<cr>")

-- Custom Shortcuts
imap("jk", "<Esc>")
