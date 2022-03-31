require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.black,
        require("null-ls").builtins.diagnostics.yamllint,

        require("null-ls").builtins.diagnostics.pylint,
    },
})

