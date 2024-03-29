-- CodeRunner
local CodeRunner = require("kz.coderunner")

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
end

if vim.fn.has "nvim-0.7" then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    command = "lua CodeRunner()",
  })
else
  vim.cmd "autocmd FileType * lua CodeRunner()"
end



CodeRunner = function()
 local wk = require("which-key")
 local bufnr = vim.api.nvim_get_current_buf()
 local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
 local fname = vim.fn.expand "%:p:t"
 local keymap_c = {}

 if ft == "python" then
   keymap_c = {
     name = "Code",
     j = { "<cmd>TermExec cmd='python main.py' direction=float go_back=0<cr>", "Run" },
     p = { "<cmd>TermExec cmd='pytest tests -v' direction=float go_back=0<cr>", "Pytest" },
     k = { "<cmd>TermExec cmd='pytest --doctest-modules main.py' direction=float go_back=0<cr>", "Doctests" },
     m = { "<cmd>TermExec cmd='nodemon -e py %'<cr>", "nodemon" },
   }
 elseif ft == "rust" then
   keymap_c = {
     name = "Code",
     j = { "<cmd>TermExec cmd='cargo run' direction=float go_back=0<cr>" , "Run" },
     --[[ D = { "<cmd>RustDebuggables<cr>", "Debuggables" }, ]]
     --[[ h = { "<cmd>RustHoverActions<cr>", "Hover Actions" }, ]]
     --[[ R = { "<cmd>RustRunnables<cr>", "Runnables" }, ]]
   }
 elseif ft == "go" then
   keymap_c = {
     name = "Code",
     j = { "<cmd>TermExec cmd='go run cmd/main/main.go' direction=float go_back=0<cr>", "go run cmd/main/main.go" },
   }
 elseif ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
   keymap_c = {
     name = "Code",
     o = { "<cmd>TSLspOrganize<cr>", "Organize" },
     r = { "<cmd>TSLspRenameFile<cr>", "Rename File" },
     i = { "<cmd>TSLspImportAll<cr>", "Import All" },
     R = { "<cmd>lua require('config.test').javascript_runner()<cr>", "Choose Test Runner" },
     s = { "<cmd>2TermExec cmd='yarn start'<cr>", "Yarn Start" },
     t = { "<cmd>2TermExec cmd='yarn test'<cr>", "Yarn Test" },
   }
 end

 if fname == "package.json" then
   keymap_c.v = { "<cmd>lua require('package-info').show()<cr>", "Show Version" }
   keymap_c.c = { "<cmd>lua require('package-info').change_version()<cr>", "Change Version" }
   keymap_c.s = { "<cmd>2TermExec cmd='yarn start'<cr>", "Yarn Start" }
   keymap_c.t = { "<cmd>2TermExec cmd='yarn test'<cr>", "Yarn Test" }
 end

 if next(keymap_c) ~= nil then
   wk.register(
     { c = keymap_c },
     { mode = "n", silent = true, noremap = true, buffer = bufnr, prefix = "<leader>" }
   )
 end
end
