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
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command

    -- Buffer handling
    ["<S-h>"] = { ":bprevious<cr>" },
    ["<S-l>"] = { ":bnext<cr>" },
    -- ["<leader>c"] = { "<cmd>Bdelete!<CR>", desc = "Close Buffer" },
    -- ["<leader>bq"] = { "<cmd>bp <BAR> confirm bd #<CR>", desc = "Close Buffer" },
    -- ["<leader>bQ"] = { "<cmd>%bd|e#|confirm bd #<CR>", desc = "Close All Buffers" },

    -- ["<leader>f"] = { "<cmd>lua vim.lsp.buf.format({async=True})<CR>", desc = "Format" },

    ["<leader>x"] = { "<cmd>q!<CR>", desc = "Quit (Force)" },
    ["<leader>q"] = { "<cmd>q<CR>", desc = "Quit" },

    ["<leader>h"] = { "<cmd>nohlsearch<CR>", desc = "No Highlight" },

    ["<C-A-l>"] = {
      function()
        local worktree = require("astronvim.utils.git").file_worktree()
        local flags = worktree and (" --work-tree=%s --git-dir=%s"):format(worktree.toplevel, worktree.gitdir) or ""
        utils.toggle_term_cmd("lazygit " .. flags)
      end,
      desc = "ToggleTerm lazygit",
    },
    ["<C-A-m>"] = { "<cmd>TroubleToggle<CR>" },
    ["<C-A-j>"] = { "<cmd>ToggleTerm<CR>" },

    -- telescope
    ["<leader>F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find Text" },
    -- ["<leader>P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects" },
    -- ["<C-p>"] = { ":lua require('kz.telescope').project_files()<CR>" },
    ["<C-p>"] = { "<cmd>Telescope find_files<CR>" },
    ["<leader>T"] = { "<cmd>Telescope<CR>", desc = "Telescope" },
    -- ["<leader>M"] = { "<cmd>Telescope marks<CR>", desc = "Marks" },
    -- ["<leader>S"] = { "<cmd>Telescope lsp_document_symbols<CR>", desc = "Symbols" },
    -- ["<leader>o"] = { "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    -- ["<C-t>"] = { ":Telescope projects<CR>" },
    -- ["<C-A-p>"] = { ":Telescope find_files<CR>" },
    -- ["<C-A-h>"] = { ":Telescope file_browser<CR>" },
    -- ["<C-b>"] = { ":Telescope buffers<CR>" },
    ["<C-f>"] = { ":Telescope current_buffer_fuzzy_find<CR>" },
    -- ["<C-g>"] = { ":Telescope live_grep<CR>" },

    -- primeagen remaps
    ["<leader>p"] = { '"_dP' },
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
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
  v = {
    -- Move text up and down
    ["J"] = { ":move '>+1<CR>gv-gv" },
    ["K"] = { ":move '<-2<CR>gv-gv" },
    ["<A-j>"] = { ":move '>+1<CR>gv-gv" },
    ["<A-k>"] = { ":move '<-2<CR>gv-gv" },
  },
}
