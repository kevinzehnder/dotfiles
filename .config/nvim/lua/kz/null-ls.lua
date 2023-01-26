require("null-ls").setup({
    sources = {
        -- python
        require("null-ls").builtins.formatting.isort,
        require("null-ls").builtins.formatting.black.with({ extra_args = { "--fast"}}),
        require("null-ls").builtins.diagnostics.pylint,
        require("null-ls").builtins.diagnostics.mypy,

        -- go
        require("null-ls").builtins.formatting.gofmt,
        require("null-ls").builtins.formatting.goimports,
        require("null-ls").builtins.formatting.golines,
        
        -- yaml
        require("null-ls").builtins.diagnostics.yamllint,

        -- javascript
        require("null-ls").builtins.formatting.prettier,
        require("null-ls").builtins.formatting.eslint,

        -- rust
        require("null-ls").builtins.formatting.rustfmt,
    },
})

