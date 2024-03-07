-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
local utils = require "astronvim.utils"

return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map

    -- navigate buffer tabs with `H` and `L`
    -- L = {
    --   function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
    --   desc = "Next buffer",
    -- },
    -- H = {
    --   function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
    --   desc = "Previous buffer",
    -- },

    -- mappings seen under group name "Buffer"
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus

    -- lsp
    ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "LSP Hover" },

    -- code runner
    ["<leader>k"] = { "<cmd>2TermExec cmd='go run cmd/main/main.go'<CR>", desc = "Run Go Main" },

    -- Buffer handling
    ["<leader>b"] = { name = "Buffers" },
    ["<S-h>"] = { ":bprevious<cr>" },
    ["<S-l>"] = { ":bnext<cr>" },
    ["<leader>x"] = { "<cmd>q!<CR>", desc = "Quit (Force)" },
    ["<leader>q"] = { "<cmd>q<CR>", desc = "Quit" },

    ["<leader>h"] = { "<cmd>nohlsearch<CR>", desc = "No Highlight" },

    ["<leader>4"] = { "<cmd>YAMLYank *<CR>", desc = "YANK Yaml" },
    ["<leader>5"] = { "<cmd>YAMLView<CR>", desc = "YANK Yaml" },

    -- navigation
    ["<C-A-l>"] = {
      function()
        local worktree = require("astronvim.utils.git").file_worktree()
        local flags = worktree and (" --work-tree=%s --git-dir=%s"):format(worktree.toplevel, worktree.gitdir) or ""
        utils.toggle_term_cmd("lazygit " .. flags)
      end,
      desc = "ToggleTerm lazygit",
    },
    ["<C-A-m>"] = { "<cmd>lua require('trouble').toggle()<cr>" },
    ["<C-A-h>"] = { "<cmd>Neotree toggle<CR>" },
    ["<C-A-j>"] = { "<cmd>ToggleTerm<CR>" },

    -- telescope
    ["<leader>F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find Text" },
    ["<C-p>"] = { "<cmd>Telescope find_files<CR>" },
    ["<leader>T"] = { "<cmd>Telescope<CR>", desc = "Telescope" },
    ["<C-f>"] = { ":Telescope current_buffer_fuzzy_find<CR>" },

    -- primeagen remaps
    ["<C-u>"] = { "<C-u>zz" },
    ["<C-d>"] = { "<C-d>zz" },
    ["n"] = { "nzz" },
    ["N"] = { "Nzz" },
    ["Q"] = { "<nop>" },
    ["<leader>s"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = "replace word under cursor" },

    ["<A-down>"] = { ":resize -2<CR>" },
    ["<A-up>"] = { ":resize +2<CR>" },
    ["<A-right>"] = { ":vertical resize -2<CR>" },
    ["<A-left>"] = { ":vertical resize +2<CR>" },

    -- harpoon
    ["<leader>j"] = { name = "Harpoon" },
    ["<leader>jj"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Quick Menu" },
    ["<leader>ja"] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Add File" },
    ["<leader>jf"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = " File 1" },
    ["<leader>jd"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "File 2" },
    ["<leader>js"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "File 3" },
    ["<leader>je"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "File 4" },
    ["<leader>jr"] = { "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", desc = "File 5" },

    -- git
    ["<leader>gH"] = { "<cmd>Gitsigns toggle_linehl<cr>", desc = "Toggle LineHL" },
    ["<leader>gd"] = { "<cmd>DiffviewToggle<cr>", desc = "Diffview" },
  },
  t = {
    -- setting a mapping to false will disable it
    ["<esc>"] = false,
    ["<C-k>"] = false,
    ["<C-j>"] = false,
  },
  v = {
    -- Move text up and down
    ["J"] = { ":move '>+1<CR>gv-gv" },
    ["K"] = { ":move '<-2<CR>gv-gv" },
    ["<A-j>"] = { ":move '>+1<CR>gv-gv" },
    ["<A-k>"] = { ":move '<-2<CR>gv-gv" },
    ["<A-p>"] = { '"_dP' },
  },
}
