---@type LazySpec
return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "nvim-dap" },
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      handlers = {},
      ensure_installed = { "python", "delve" },
    },
  },
}
