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
  return exists(path .. "/")
end

-- adaptive colorscheme
if exists(os.getenv "HOME" .. "/.lightmode") then
  vim.o.background = "light"
  vim.cmd "colorscheme solarized"
else
  vim.o.background = "dark"
  vim.cmd "colorscheme tokyonight"
end

if vim.env.BASE16_THEME == "gruvbox-dark-medium" then vim.cmd "colorscheme gruvbox" end

vim.cmd "highlight TSFunction gui=bold"
