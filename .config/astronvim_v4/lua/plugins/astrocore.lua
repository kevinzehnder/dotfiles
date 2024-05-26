-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        background = "light",
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
        cmdheight = 0,
        showtabline = 1,

        list = true, -- show whitespace characters
        listchars = {
          tab = "→ ",
          extends = "⟩",
          precedes = "⟨",
          trail = "·",
          nbsp = "␣",
          space = "·",
          -- eol = "↲",
        },

        undofile = true,
        numberwidth = 3,
        statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s",
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs with `H` and `L`
        -- L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        -- H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- lsp
        ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "LSP Hover" },

        -- buffers
        ["<Leader>b"] = { desc = "Buffers" },
        ["<S-h>"] = { ":bprevious<cr>" },
        ["<S-l>"] = { ":bnext<cr>" },

        ["<leader>x"] = { "<cmd>q!<CR>", desc = "Quit (Force)" },
        ["<leader>q"] = { "<cmd>q<CR>", desc = "Quit" },

        ["<leader>h"] = { "<cmd>nohlsearch<CR>", desc = "No Highlight" },

        -- yaml
        ["<leader>4"] = { "<cmd>YAMLYank *<CR>", desc = "YANK Yaml" },
        ["<leader>5"] = { "<cmd>YAMLView<CR>", desc = "YANK Yaml" },

        -- panels
        ["<A-M>"] = { "<cmd>lua require('trouble').toggle()<cr>" },
        ["<A-H>"] = { "<cmd>Neotree toggle<CR>" },
        ["<A-J>"] = { "<cmd>ToggleTerm<CR>" },

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
        ["<leader>P"] = { "<cmd>:put +<CR>" , desc = "paste without overwriting buffer" },

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
    },
  },
}
