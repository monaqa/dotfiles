local shorthand = require("monaqa.shorthand")
local autocmd_vimrc = shorthand.autocmd_vimrc
local mapset = shorthand.mapset
local vec = require("rc.util.vec")

local plugins = vec {}

plugins:push {
    dir = "~/ghq/github.com/monaqa/colorimetry.nvim",
    dependencies = {
        "lreload.nvim",
    },
    lazy = false,
    keys = {
        {
            "@z",
            function()
                vim.cmd.edit("~/ghq/github.com/monaqa/colorimetry.nvim/lua/colorimetry/init.lua")
            end,
        },
    },
    config = function()
        vim.cmd.colorscheme("colorimetry")

        -- hot reload config
        require("lreload").enable("colorimetry")

        ---@param name string
        local function sethl(name)
            ---@param val vim.api.keyset.highlight
            return function(val)
                vim.api.nvim_set_hl(0, name, val)
            end
        end

        local fg = require("colorimetry.palette").fg
        local bg = require("colorimetry.palette").bg

        sethl("VisualMatch") { bg = bg.g4 }

        autocmd_vimrc("BufWritePost") {
            pattern = vim.env.HOME .. "/ghq/github.com/monaqa/colorimetry.nvim/*.lua",
            callback = function()
                vim.cmd.colorscheme("colorimetry")
            end,
        }
    end,
}
plugins:push {
    "https://github.com/echasnovski/mini.statusline",
    dependencies = {
        "https://github.com/echasnovski/mini.icons",
        "colorimetry.nvim",
    },
    version = "*",
    config = function()
        local palette = require("colorimetry.palette")
        local fg = palette.fg
        local bg = palette.bg

        ---@param name string
        local function sethl(name)
            ---@param val vim.api.keyset.highlight
            return function(val)
                vim.api.nvim_set_hl(0, name, val)
            end
        end

        sethl("MiniStatuslineModeNormal") { bg = fg.b5, fg = fg.w0, bold = true }
        sethl("MiniStatuslineModeInsert") { bg = fg.e5, fg = fg.w0, bold = true }
        sethl("MiniStatuslineModeVisual") { bg = fg.p5, fg = fg.w0, bold = true }
        sethl("MiniStatuslineModeReplace") { bg = fg.o5, fg = fg.w0, bold = true }
        sethl("MiniStatuslineModeCommand") { bg = fg.v5, fg = fg.w0, bold = true }
        sethl("MiniStatuslineModeOther") { bg = fg.w5, fg = fg.w0, bold = true }

        sethl("MiniStatuslineDevinfo") { bg = fg.g1, fg = bg.g3, bold = true }

        sethl("MiniStatuslineFilename") { bg = fg.e1, fg = bg.b2, bold = true }
        sethl("MiniStatuslineContents") { bg = fg.e0, fg = bg.w0, bold = true }
        sethl("MiniStatuslineFileinfo") { bg = fg.e2, fg = bg.b2, bold = true }

        require("mini.statusline").setup {
            content = {
                active = function()
                    local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 90 }
                    local filename = MiniStatusline.section_filename { trunc_width = 140 }
                    local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }

                    local desc = vim.system({
                        "jj",
                        "log",
                        "-r",
                        "@",
                        "-T",
                        "description.first_line()",
                        "--no-graph",
                    }):wait()

                    local jj_info = ""
                    if desc.code == 0 then
                        jj_info = "🤞" .. desc.stdout
                    end

                    -- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
                    -- correct padding with spaces between groups (accounts for 'missing'
                    -- sections, etc.)
                    return MiniStatusline.combine_groups {
                        { hl = mode_hl, strings = { mode } },
                        -- { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
                        "%<", -- Mark general truncate point
                        { hl = "MiniStatuslineFilename", strings = { filename } },
                        { hl = "MiniStatuslineContents", strings = { jj_info } },
                        "%=", -- End left alignment
                        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
                        -- { hl = mode_hl, strings = { search, location } },
                    }
                end,
            },
        }
    end,
}

plugins:push {
    "https://github.com/b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
        local palette = require("colorimetry.palette")
        local fg = require("colorimetry.palette").fg
        local bg = require("colorimetry.palette").bg

        local devicons = require("nvim-web-devicons")
        require("incline").setup {
            window = {
                padding = 0,
                overlap = {
                    borders = true,
                    statusline = false,
                    tabline = false,
                    winbar = false,
                },
                margin = {
                    horizontal = 0,
                    vertical = 1,
                },
                placement = {
                    vertical = "bottom",
                    horizontal = "right",
                },
            },
            render = function(props)
                local bufname = vim.api.nvim_buf_get_name(props.buf)
                local filename = vim.fn.fnamemodify(bufname, ":t")
                local ft_icon, ft_color = devicons.get_icon_color(filename)

                -- oil buffer は特別扱い
                if vim.startswith(bufname, "oil://") then
                    filename = vim.fn.fnamemodify(bufname:sub(7), ":.")
                    if not vim.startswith(filename, "/") then
                        -- 絶対パス表示でない → 相対パス表示のはず
                        filename = "./" .. filename
                    end
                    if not vim.endswith(filename, "/") then
                        filename = filename .. "/"
                    end
                    ft_icon = ""
                end

                if filename == "" then
                    filename = "[No Name]"
                end

                local function get_git_diff()
                    local v = {
                        { icon = "  ", name = "removed", group = "DiffDelete" },
                        { icon = "  ", name = "changed", group = "DiffChange" },
                        { icon = "  ", name = "added", group = "DiffAdd" },
                    }
                    local signs = vim.b[props.buf].gitsigns_status_dict
                    local labels = {}
                    if signs == nil then
                        return labels
                    end
                    for _, elem in ipairs(v) do
                        if tonumber(signs[elem.name]) and signs[elem.name] > 0 then
                            table.insert(labels, { elem.icon .. signs[elem.name], group = elem.group })
                        end
                    end
                    if #labels > 0 then
                        table.insert(labels, 1, { "┊" })
                    end
                    return labels
                end

                local function get_diagnostic_label()
                    local icons = { error = "🚨", warn = "🐤" }
                    local label = {}

                    for severity, icon in pairs(icons) do
                        local n = #vim.diagnostic.get(
                            props.buf,
                            { severity = vim.diagnostic.severity[string.upper(severity)] }
                        )
                        if n > 0 then
                            table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
                        end
                    end
                    if #label > 0 then
                        table.insert(label, { "┊ " })
                    end
                    return label
                end

                return {
                    {
                        "",
                        guifg = fg.p0,
                        guibg = "none",
                    },
                    {
                        (ft_icon or "") .. " ",
                        guifg = ft_color,
                        guibg = fg.p0,
                    },
                    {
                        filename .. " ",
                        gui = vim.bo[props.buf].modified and "bold,italic" or "bold",
                        guibg = fg.p0,
                        guifg = bg.w0,
                    },
                    { get_diagnostic_label() },
                    { get_git_diff() },
                }
            end,
        }
    end,
}

-- plugins:push {
--     "https://github.com/akinsho/bufferline.nvim",
--     dependencies = { "colorimetry.nvim" },
--     tag = "v4.6.1",
--     lazy = false,
--     keys = {
--         { "sw", "<Cmd>bp | bd #<CR>" },
--     },
--     config = function()
--         local palette = require("colorimetry.palette")
--         local fg = palette.fg
--         local bg = palette.bg
--
--         local hl = {
--             fill = { bg = fg.w3 },
--             sep = { fg = fg.w4 },
--             buf0 = { bg = "None", fg = fg.w0 }, -- selected
--             buf1 = { bg = bg.w1, fg = fg.w1 }, -- visible
--             buf2 = { bg = bg.w4, fg = fg.w4 }, -- inactive (background)
--
--             diag0 = { fg = fg.r2 },
--             diag1 = { fg = fg.y2 },
--             diag2 = { fg = fg.b1 },
--             diag3 = { fg = fg.e0 },
--
--             mod = { fg = fg.o3 },
--             dup0 = { fg = fg.w2 },
--             dup1 = { fg = fg.w3 },
--             dup2 = { fg = fg.w5 },
--         }
--
--         require("bufferline").setup {
--             options = {
--                 diagnostics = "nvim_lsp",
--                 -- diagnostics = "coc",
--                 -- separator_style = "thin",
--                 separator_style = "slant",
--                 indicator = {
--                     style = "none",
--                     -- style = "underline"
--                 },
--                 left_trunc_marker = "",
--                 right_trunc_marker = "",
--                 diagnostics_indicator = function(count, level, diagnostics_dict, context)
--                     if level == "error" then
--                         return "🚨" .. count
--                     elseif level == "warning" then
--                         return "🐤" .. count
--                     end
--                     -- return "ℹ️ "
--                     return ""
--                 end,
--                 tab_size = 5,
--                 max_name_length = 30,
--                 show_close_icon = false,
--                 show_buffer_close_icons = false,
--                 ---@param buf {name: string, path: string, bufnr: integer, buffers: integer[], tabnr: integer}
--                 name_formatter = function(buf) -- buf contains:
--                     local filetype = vim.bo[buf.bufnr].filetype
--                     if filetype == "oil" then
--                         return vim.iter(vim.split(buf.path, "/", { trimempty = true })):last()
--                     end
--                     if filetype == "gin-diff" then
--                         local _, _, inner = buf.path:find("%%22(.+)%%22")
--                         return inner
--                     end
--                     if filetype == "gin-status" then
--                         return "«gin status»"
--                     end
--                     if filetype == "typst" and buf.name == "index.typ" then
--                         return "(" .. vim.iter(vim.split(buf.path, "/", { trimempty = true })):nth(-2) .. ")"
--                     end
--                     return buf.name
--                 end,
--                 get_element_icon = function(element)
--                     -- element consists of {filetype: string, path: string, extension: string, directory: string}
--                     if element.filetype == "" then
--                         return "", "Normal"
--                     end
--                     if element.filetype == "oil" then
--                         return "", "Directory"
--                     end
--                     if element.filetype == "gin-diff" then
--                         return "𝜕", "DiffChange"
--                     end
--                     if element.filetype == "typst" then
--                         return "𝐓", "@string"
--                     end
--                     -- fallback to default
--                     local icon, hl_default =
--                         require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
--                     return icon, hl_default
--                 end,
--                 custom_filter = function(buf_number, buf_numbers)
--                     local filetype = vim.bo[buf_number].filetype
--                     local ignore_filetypes = {
--                         -- "gin-status",
--                         "oil",
--                     }
--
--                     for _, ignore_filetype in ipairs(ignore_filetypes) do
--                         if filetype == ignore_filetype then
--                             return false
--                         end
--                     end
--                     return true
--                 end,
--             },
--
--             highlights = {
--                 fill = hl.fill,
--                 separator = { bg = hl.buf2.bg, fg = hl.sep.fg },
--                 separator_visible = { bg = hl.buf1.bg, fg = hl.sep.fg },
--                 separator_selected = { bg = hl.buf0.bg, fg = hl.sep.fg },
--
--                 tab = hl.buf2,
--                 tab_selected = hl.buf1,
--                 tab_close = hl.buf0,
--
--                 background = hl.buf2,
--                 buffer_visible = hl.buf1,
--                 buffer_selected = hl.buf0,
--
--                 diagnostic = { bg = hl.buf2.bg, fg = hl.diag3.fg },
--                 diagnostic_visible = { bg = hl.buf1.bg, fg = hl.diag3.fg },
--                 diagnostic_selected = { bg = hl.buf0.bg, fg = hl.diag3.fg },
--                 hint = { bg = hl.buf2.bg, fg = hl.diag3.fg },
--                 hint_visible = { bg = hl.buf1.bg, fg = hl.diag3.fg },
--                 hint_selected = { bg = hl.buf0.bg, fg = hl.diag3.fg },
--                 hint_diagnostic = { bg = hl.buf2.bg, fg = hl.diag3.fg },
--                 hint_diagnostic_visible = { bg = hl.buf1.bg, fg = hl.diag3.fg },
--                 hint_diagnostic_selected = { bg = hl.buf0.bg, fg = hl.diag3.fg },
--                 info = { bg = hl.buf2.bg, fg = hl.diag2.fg },
--                 info_visible = { bg = hl.buf1.bg, fg = hl.diag2.fg },
--                 info_selected = { bg = hl.buf0.bg, fg = hl.diag2.fg },
--                 info_diagnostic = { bg = hl.buf2.bg, fg = hl.diag2.fg },
--                 info_diagnostic_visible = { bg = hl.buf1.bg, fg = hl.diag2.fg },
--                 info_diagnostic_selected = { bg = hl.buf0.bg, fg = hl.diag2.fg },
--                 warning = { bg = hl.buf2.bg, fg = hl.diag1.fg },
--                 warning_visible = { bg = hl.buf1.bg, fg = hl.diag1.fg },
--                 warning_selected = { bg = hl.buf0.bg, fg = hl.diag1.fg },
--                 warning_diagnostic = { bg = hl.buf2.bg, fg = hl.diag1.fg },
--                 warning_diagnostic_visible = { bg = hl.buf1.bg, fg = hl.diag1.fg },
--                 warning_diagnostic_selected = { bg = hl.buf0.bg, fg = hl.diag1.fg },
--                 error = { bg = hl.buf2.bg, fg = hl.diag0.fg },
--                 error_visible = { bg = hl.buf1.bg, fg = hl.diag0.fg },
--                 error_selected = { bg = hl.buf0.bg, fg = hl.diag0.fg },
--                 error_diagnostic = { bg = hl.buf2.bg, fg = hl.diag0.fg },
--                 error_diagnostic_visible = { bg = hl.buf1.bg, fg = hl.diag0.fg },
--                 error_diagnostic_selected = { bg = hl.buf0.bg, fg = hl.diag0.fg },
--                 modified = { bg = hl.buf2.bg, fg = hl.mod.fg },
--                 modified_visible = { bg = hl.buf1.bg, fg = hl.mod.fg },
--                 modified_selected = { bg = hl.buf0.bg, fg = hl.mod.fg },
--                 duplicate = { bg = hl.buf2.bg, fg = hl.dup2.fg },
--                 duplicate_visible = { bg = hl.buf1.bg, fg = hl.dup1.fg },
--                 duplicate_selected = { bg = hl.buf0.bg, fg = hl.dup0.fg },
--                 indicator_selected = { bg = hl.buf0.bg },
--                 pick_selected = { bg = hl.buf0.bg },
--                 pick_visible = { bg = hl.buf1.bg },
--                 pick = { bg = hl.buf2.bg },
--
--                 -- offset_separator = { bg = bg.w4, fg = fg.o0 },
--                 -- close_button = { bg = bg.w4, fg = fg.f3 },
--                 -- close_button_visible = { bg = "#444444", fg = fg.o0 },
--                 -- close_button_selected = { bg = "None", fg = fg.o0 },
--                 -- numbers = { bg = bg.w4, fg = fg.f3 },
--                 -- numbers_visible = { bg = bg.w2, fg = fg.o0 },
--                 -- numbers_selected = { bg = "None", fg = fg.o0 },
--             },
--         }
--     end,
-- }

return plugins:collect()
