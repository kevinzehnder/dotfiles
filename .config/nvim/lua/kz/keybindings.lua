-- space as <Leader>
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local status_ok, wk = pcall(require, "which-key")
if not status_ok then
    return
end

local opts = {
    mode = "n",   -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
    ["f"] = { "<cmd>lua vim.lsp.buf.format({async=True})<CR>", "Format" },

    ["w"] = { "<cmd>up<CR>", "Save" },
    ["x"] = { "<cmd>q!<CR>", "Quit (Force)" },
    ["q"] = { "<cmd>q<CR>", "Quit" },
    ["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
    ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
    ["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
    ["P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
    ["?"] = { "<cmd>WhichKey<CR>", "WhichKey" },
    ["<F2>"] = { "<cmd>Alpha<CR>", "Alpha" },

    ["T"] = { "<cmd>Telescope<CR>", "Telescope" },
    ["M"] = { "<cmd>Telescope marks<CR>", "Marks" },
    ["S"] = { "<cmd>Telescope lsp_document_symbols<CR>", "Symbols" },
    ["o"] = { "<cmd>Telescope buffers<CR>", "Buffers" },

    -- buffer handling
    b = {
        name = "Buffer Handling",
        q = { "<cmd>bp <BAR> confirm bd #<CR>", "Close Buffer" },
        Q = { "<cmd>%bd|e#|confirm bd #<CR>", "Close All Buffers" },
    },

    -- harpoon
    --[[ nmap("<Leader>m", ":lua require('harpoon.ui').toggle_quick_menu()<cr>") ]]
    --[[ nmap("<Leader>n", ":lua require('harpoon.mark').add_file()<cr>") ]]
    --[[ nmap("<Leader>lf", ":lua require('harpoon.ui').nav_file(1)<cr>") ]]
    --[[ nmap("<Leader>ld", ":lua require('harpoon.ui').nav_file(2)<cr>") ]]
    --[[ nmap("<Leader>ls", ":lua require('harpoon.ui').nav_file(3)<cr>") ]]
    --[[ nmap("<Leader>la", ":lua require('harpoon.ui').nav_file(4)<cr>") ]]

    -- DAP
    --[[ map("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>") ]]
    --[[ map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>") ]]
    --[[ map("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>") ]]
    --[[ map("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>") ]]
    --[[ map("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>") ]]
    --[[ map("n", "<leader>dr", "<cmd>lua require'dapui'.float_element('repl')<cr>") ]]
    --[[ map("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>") ]]
    --[[ map("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>") ]]
    --[[ map("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>") ]]
    --[[ map("n", "<leader>dp", "<cmd>lua require'dapui'.float_element('console', {width=200, height=200})<cr>") ]]
    --[[ map("n", "<leader>dk", "<cmd>lua require'dapui'.eval()<cr>") ]]

    -- Packer
    p = {
        name = "Packer",
        c = { "<cmd>PackerCompile<cr>", "Compile" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        s = { "<cmd>PackerSync<cr>", "Sync" },
        S = { "<cmd>PackerStatus<cr>", "Status" },
        u = { "<cmd>PackerUpdate<cr>", "Update" },
    },

    -- Git
    g = {
        name = "Git",
        g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
        j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
        k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
        l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
        p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
        r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
        R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
        s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
        u = {
            "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
            "Undo Stage Hunk",
        },
        o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        d = {
            "<cmd>Gitsigns diffthis HEAD<cr>",
            "Diff",
        },
    },

    -- Language Server Protocol (LSP)
    l = {
        name = "LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        d = {
            "<cmd>Telescope diagnostics bufnr=0<cr>",
            "Document Diagnostics",
        },
        w = {
            "<cmd>Telescope diagnostics<cr>",
            "Workspace Diagnostics",
        },
        f = { "<cmd>lua vim.lsp.buf.format{async=true}<cr>", "Format" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
        j = {
            "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
            "Next Diagnostic",
        },
        k = {
            "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
            "Prev Diagnostic",
        },
        l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
        q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
        S = {
            "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
            "Workspace Symbols",
        },
    },

    --Telescope
    s = {
        name = "Search",
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
        h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
        M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        C = { "<cmd>Telescope commands<cr>", "Commands" },
    },

    -- Terminal
    t = {
        name = "Terminal",
        n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
        u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
        t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
        p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
        f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
        h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
        v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
    },

    -- Configs
    v = {
        name = "Configs",
        c = { "<cmd>lua require('kz.telescope').search_dotfiles()<CR>", "Edit VIMRC" },
    },

}

wk.setup(setup)
wk.register(mappings, opts)


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

-- completion in command mode
vim.api.nvim_set_keymap('c', '<C-j>', '<C-n>', {})
vim.api.nvim_set_keymap('c', '<C-k>', '<C-p>', {})

-- primeagen remaps
map("x", "<Leader>p", "\"_dP")
nmap("<C-u>", "<C-u>zz")
nmap("<C-d>", "<C-d>zz")
nmap("n", "nzz")
nmap("N", "Nzz")
nmap("Q", "<nop>")
nmap("<Leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- telescope
nmap("<C-t>", ":Telescope projects<CR>")
nmap("<C-p>", ":lua require('kz.telescope').project_files()<CR>")
nmap("<C-A-p>", ":Telescope find_files<CR>")
nmap("<C-b>", ":Telescope buffers<CR>")
nmap("<C-f>", ":Telescope current_buffer_fuzzy_find<CR>")
nmap("<C-g>", ":Telescope live_grep<CR>")
nmap("<F12>", ":WhichKey<CR>")

-- Remap arrow keys to resize window
nmap("<A-down>", ":resize -2<CR>")
nmap("<A-up>", ":resize +2<CR>")
nmap("<A-right>", ":vertical resize -2<CR>")
nmap("<A-left>", ":vertical resize +2<CR>")

-- LazyGit
nmap("<C-A-l>", ":LazyGit<CR>")

-- Buffer handling
nmap("<S-h>", ":bprevious<cr>")
nmap("<S-l>", ":bnext<cr>")

-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Visual --
-- Move text up and down
map("v", "<A-k>", ":m .-2<CR>==")
map("v", "<A-j>", ":m .+1<cr>==")

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv")
map("x", "K", ":move '<-2<CR>gv-gv")
map("x", "<A-j>", ":move '>+1<CR>gv-gv")
map("x", "<A-k>", ":move '<-2<CR>gv-gv")

-- Custom Shortcuts
imap("jk", "<Esc>")
