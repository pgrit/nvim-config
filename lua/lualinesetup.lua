local auto_theme = require("lualine.themes.auto")

local function get_modified_buffers()
    local list = {}
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].modified then
            local filename = vim.api.nvim_buf_get_name(bufnr)
            table.insert(list,
                vim.fn.fnamemodify(filename, ':.')
            )
        end
    end
    return list
end

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = auto_theme,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = {
                "dapui_scopes",
                "dapui_breakpoints",
                "dapui_stacks",
                "dapui_watches",
                "dap-repl",
                "dapui_console",
                "trouble",
                "snacks_picker_list",
                "snacks_dashboard",
            },
            winbar = {
                "dapui_scopes",
                "dapui_breakpoints",
                "dapui_stacks",
                "dapui_watches",
                "dap-repl",
                "dapui_console",
                "trouble",
                "snacks_picker_list",
                "snacks_dashboard",
            },
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = false,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
                "WinEnter",
                "BufEnter",
                "BufWritePost",
                "SessionLoadPost",
                "FileChangedShellPost",
                "VimResized",
                "Filetype",
                "CursorMoved",
                "CursorMovedI",
                "ModeChanged",
            },
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
            {
                function(section)
                    local modbufs = get_modified_buffers()
                    if #modbufs > 0 then
                        return "Unsaved changes in " .. table.concat(modbufs, ", ")
                    else
                        return ""
                    end
                end,
                color = function(section)
                    local modbufs = get_modified_buffers()
                    if #modbufs > 0 then
                        return {
                            bg = "#FFD166",
                            fg = "#000000"
                        }
                    else
                        return {
                            bg = "#323742",
                            fg = nil,
                        }
                    end
                end,
            }
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = {},
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            {
                "filename",
                color = function(section)
                    return {
                        bg = vim.bo.modified and "#FFD166" or "#323742",
                        fg = vim.bo.modified and "#000000" or nil,
                    }
                end,
                path = 1,
            },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            {
                "filename",
                color = function(section)
                    return {
                        bg = vim.bo.modified and "#FFD166" or "#323742",
                        fg = vim.bo.modified and "#000000" or nil,
                    }
                end,
                path = 1,
            },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    extensions = {},
})
