null_ls = require("null-ls")
null_ls.setup({
    sources = {
        -- python
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.black.with({ extra_args = { "--fast"}}),
        null_ls.builtins.diagnostics.pylint.with({
              diagnostics_postprocess = function(diagnostic)
                diagnostic.code = diagnostic.message_id
              end,
            }),
        null_ls.builtins.diagnostics.mypy,

        -- go
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.golines,
        
        -- yaml
        null_ls.builtins.diagnostics.yamllint,

        -- javascript
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.eslint,

        -- rust
        null_ls.builtins.formatting.rustfmt,
    },



})

