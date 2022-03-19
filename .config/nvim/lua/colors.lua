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

-- adaptive colorscheme
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


