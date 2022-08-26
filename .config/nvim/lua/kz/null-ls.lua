require("null-ls").setup({
    sources = {
        -- python
        require("null-ls").builtins.formatting.isort,
        require("null-ls").builtins.formatting.black,
        -- require("null-ls").builtins.diagnostics.pylint,

        -- go
        require("null-ls").builtins.formatting.gofmt,
        --
        -- yaml
        require("null-ls").builtins.diagnostics.yamllint,

        -- javascript
        require("null-ls").builtins.formatting.prettier,
    },
})

