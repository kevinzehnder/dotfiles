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
      { id = "watches", size = 0.25 },
    },
    size = 40,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = {
            { id = "console", size = 1,}
        },
    size = 30,
    position = "bottom"
  },
  floating = { max_width = 0.9, max_height = 0.5, border = vim.g.border_chars },
  expand_lines = 1,
}

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
  --[[ dapui.float_element("console", {width = 200, height = 200}) ]]
end

--[[ dap.listeners.before.event_terminated["dapui_config"] = function() ]]
--[[   dapui.close() ]]
--[[ end ]]

--[[ dap.listeners.before.event_exited["dapui_config"] = function() ]]
--[[   dapui.close() ]]
--[[ end ]]

local dapvt_status_ok, dapvt = pcall(require, "nvim-dap-virtual-text")
if not dapvt_status_ok then
  return
end

dapvt.setup {
    enabled = true,                        -- enable this plugin (the default)
    enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,               -- show stop reason when stopped for exceptions
    commented = false,                     -- prefix virtual text with comment string
    only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)

    -- experimental features:
    virt_text_pos = 'eol',                 -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
      
}
