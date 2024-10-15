-- Print a message to confirm this config is being loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set up keybindings
-- VSCode-specific keybindings
local vscode = require('vscode')

-- Map leader+w to save in VSCode
vim.keymap.set('n', '<leader>w', function()
	vscode.call('workbench.action.files.save')
	print("workbench.action.files.save")
end, { noremap = true, silent = true, desc = "Save file" })

-- Map leader+c to close buffer in VSCode
vim.keymap.set('n', '<leader>c', function()
	vscode.call('workbench.action.closeActiveEditor')
end, { noremap = true, silent = true, desc = "Close current buffer" })

-- Customize scrolling
vim.keymap.set('n', '<C-e>', function()
	vscode.call('scrollLineDown')
end, { noremap = true, silent = true, desc = "Scroll down" })

vim.keymap.set('n', '<C-z>', function()
	vscode.call('scrollLineUp')
end, { noremap = true, silent = true, desc = "Scroll up" })

-- Also add these for visual and operator-pending modes
vim.keymap.set({ 'v', 'x' }, '<C-e>', function()
	vscode.call('scrollLineDown')
end, { noremap = true, silent = true, desc = "Scroll down" })

vim.keymap.set({ 'v', 'x' }, '<C-z>', function()
	vscode.call('scrollLineUp')
end, { noremap = true, silent = true, desc = "Scroll up" })

-- Stage selection
vim.keymap.set('v', '<leader>gs', function()
	vscode.call('git.stageSelectedRanges')
end, { noremap = true, silent = true, desc = "Git Stage Selection" })

-- Unstage selection
vim.keymap.set('v', '<leader>gu', function()
	vscode.call('git.unstageSelectedRanges')
end, { noremap = true, silent = true, desc = "Git Unstage Selection" })

-- Stage current file
vim.keymap.set('n', '<leader>gf', function()
	vscode.call('git.stage')
end, { noremap = true, silent = true, desc = "Git Stage File" })

-- Unstage current file
vim.keymap.set('n', '<leader>gF', function()
	vscode.call('git.unstage')
end, { noremap = true, silent = true, desc = "Git Unstage File" })

-- Show Git changes in file
vim.keymap.set('n', '<leader>gd', function()
	vscode.call('git.openChange')
end, { noremap = true, silent = true, desc = "Show Git Changes" })

-- Revert current changes
vim.keymap.set('n', '<leader>gr', function()
	vscode.call('git.revertSelectedRanges')
end, { noremap = true, silent = true, desc = "Revert Selection" })


-- Common settings (will apply both in VSCode and regular Neovim)
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
