local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    return
end

lualine.setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = false,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = {
            {
                function()
                    local lsps = vim.lsp.get_active_clients({ bufnr = vim.fn.bufnr() })
                    local icon = require("nvim-web-devicons").get_icon_by_filetype(
                        vim.api.nvim_buf_get_option(0, "filetype")
                    )
                    if lsps and #lsps > 0 then
                        local names = {}
                        for _, lsp in ipairs(lsps) do
                            table.insert(names, lsp.name)
                        end
                        return string.format("%s %s", table.concat(names, ", "), icon or '')
                    else
                        return icon or ""
                    end
                end,
                on_click = function()
                    vim.api.nvim_command("LspInfo")
                end,
                color = function()
                    local _, color = require("nvim-web-devicons").get_icon_cterm_color_by_filetype(
                        vim.api.nvim_buf_get_option(0, "filetype")
                    )
                    return { fg = color }
                end,
            },
            "encoding",
            "progress",
        },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {
            'buffers',
        },
    },
    extensions = {}
}
