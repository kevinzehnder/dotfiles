require("null-ls").setup({
    sources = {
        -- python
        require("null-ls").builtins.formatting.black,
        -- require("null-ls").builtins.diagnostics.pylint,

        -- yaml
        require("null-ls").builtins.diagnostics.yamllint,

        -- javascript
        require("null-ls").builtins.formatting.prettier,
    },
})

