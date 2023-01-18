local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
  return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
  return
end

local dap_install_status_ok, dap_install = pcall(require, "dap-install")
if not dap_install_status_ok then
  return
end

require("dap-python").setup("python", {})

dap_install.setup {}

dap_install.config("python", {})
-- add other configs here

dapui.setup {
  sidebar = {

    elements = {
      {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
      { id = "breakpoints", size = 0.25 },
    },
    size = 40,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = {
            --[[ "console", ]]
            --[[ "repl" ]]
        },
    size = 40,
    width = 100,
    position = "bottom"
  },
  floating = { max_width = 0.9, max_height = 0.5, border = vim.g.border_chars },
}

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["dapui_config"] = function()
  --[[ dapui.open() ]]
  dapui.float_element("console", {width = 200, height = 200})
end

--[[ dap.listeners.before.event_terminated["dapui_config"] = function() ]]
--[[   dapui.close() ]]
--[[ end ]]

--[[ dap.listeners.before.event_exited["dapui_config"] = function() ]]
--[[   dapui.close() ]]
--[[ end ]]
