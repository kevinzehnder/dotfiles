-- lsp
local lsp_installer = require("nvim-lsp-installer")
local opts = { noremap = true, silent = true }


vim.api.nvim_set_keymap('n', '<Leader>e', ":lua vim.diagnostic.open_float()<CR>", opts)
vim.api.nvim_set_keymap('n', '[d', ":lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap('n', ']d', ":lua vim.diagnostic.goto_next()<CR>", opts)
vim.api.nvim_set_keymap('n', '<Leader>q', ":lua vim.diagnostic.setloclist()<CR>", opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  --[[ -nvim_buf_set_keymap(buffer, mode, lhs, rhs, *opts) ]]

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', ":lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', ":lua vim.lsp.buf.definition()<CR>", opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>f', ":lua vim.lsp.buf.format({async=True})<CR>", opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local enhance_server_opts = {
  ["eslintls"] = function(opts)
    opts.settings = {
    }
  end,

  ["yamlls"] = function(opts)
    opts.settings = {
      yaml = {
        format = { enable = true },
        schemas = {
          ["https://raw.githubusercontent.com/quantumblacklabs/kedro/develop/static/jsonschema/kedro-catalog-0.17.json"] = "conf/**/*catalog*",
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["kubernetes"] = "/*.yml",
        },
        schemaStore = {
          url = "https://www.schemastore.org/api/json/catalog.json",
          enable = true,
        }
      },
    }
  end,

  ["sumneko_lua"] = function(opts)
    opts.settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      },
    }
  end,
}

lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if enhance_server_opts[server.name] then
    enhance_server_opts[server.name](opts)

  end
  server:setup(opts)
end)

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
