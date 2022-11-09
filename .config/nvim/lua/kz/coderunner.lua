
CodeRunner = function()
 local wk = require("which-key")
 local bufnr = vim.api.nvim_get_current_buf()
 local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
 local fname = vim.fn.expand "%:p:t"
 local keymap_c = {}

 if ft == "python" then
   keymap_c = {
     name = "Code",
     r = { "<cmd>TermExec cmd='python main.py'<cr>", "Run" },
     --[[ r = { "<cmd>update<CR><cmd>exec '!python3' shellescape(@%, 1)<cr>", "Run" }, ]]
     m = { "<cmd>TermExec cmd='nodemon -e py %'<cr>", "Monitor" },
   }
 elseif ft == "rust" then
   keymap_c = {
     name = "Code",
     r = { "<cmd>TermExec cmd='cargo run'<cr>", "Run" },
     --[[ D = { "<cmd>RustDebuggables<cr>", "Debuggables" }, ]]
     --[[ h = { "<cmd>RustHoverActions<cr>", "Hover Actions" }, ]]
     --[[ R = { "<cmd>RustRunnables<cr>", "Runnables" }, ]]
   }
 elseif ft == "go" then
   keymap_c = {
     name = "Code",
     r = { "<cmd>TermExec cmd='go run cmd/main.go'<cr>", "go run cmd/main.go" },
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
