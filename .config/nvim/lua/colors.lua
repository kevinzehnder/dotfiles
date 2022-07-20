--- helper functions
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

-- improve split visibility
vim.cmd( [[
function! AdaptColors() abort
    if g:colors_name ==# 'solarized'
      if &background ==# 'light'
        "highlight InactiveWindow guibg=#eee8d5
        "highlight lualine_buffer_a guifg=#fdfdfd guibg=#ababab
        highlight CursorLine guibg=#ffd8cb"
      else
        "highlight InactiveWindow guibg=#073642
      endif
    else
      "highlight InactiveWindow guibg=#333333
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

-- adaptive colorscheme
if exists(os.getenv("HOME") .. "/.lightmode") then
  vim.o.background = "light"
  vim.cmd "colorscheme solarized"
else
  vim.o.background = "dark"
  vim.cmd "colorscheme solarized"
end

if vim.env.BASE16_THEME == "gruvbox-dark-medium" then
  vim.cmd "colorscheme gruvbox"
end

vim.cmd "highlight TSFunction gui=bold"
