local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
    return
end

null_ls.setup({
    sources = {
        -- python
        null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
        null_ls.builtins.diagnostics.mypy,
        null_ls.builtins.diagnostics.ruff,

        null_ls.builtins.formatting.prettierd.with({
            filetypes = {
                "json", "yaml", "markdown", "graphql", "md", "txt",
            },
        }),

        -- go
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.golines,

        -- yaml
        null_ls.builtins.diagnostics.yamllint,

        -- rust
        null_ls.builtins.formatting.rustfmt,
    },

})
