require("null-ls").setup({
    sources = {
        -- python
        require("null-ls").builtins.formatting.isort,
        require("null-ls").builtins.formatting.black.with({ extra_args = { "--fast"}}),
        -- require("null-ls").builtins.diagnostics.pylint,

        -- go
        require("null-ls").builtins.formatting.gofmt,
        require("null-ls").builtins.formatting.goimports,
        
        -- yaml
        require("null-ls").builtins.diagnostics.yamllint,

        -- javascript
        require("null-ls").builtins.formatting.prettier,
    },
})

