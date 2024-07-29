local util = require("rc.util")
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

        util.autocmd_vimrc("BufWritePost") {
            pattern = vim.env.HOME .. "/ghq/github.com/monaqa/colorimetry.nvim/*.lua",
            callback = function()
                vim.cmd.colorscheme("colorimetry")
            end,
        }
    end,
}

plugins:push {
    "https://github.com/akinsho/bufferline.nvim",
    dependencies = { "colorimetry.nvim" },
    tag = "v4.6.1",
    lazy = false,
    keys = {
        { "sN", "<Cmd>BufferLineMoveNext<CR>" },
        { "sP", "<Cmd>BufferLineMovePrev<CR>" },
        { "sw", "<Cmd>bp | bd #<CR>" },
    },
    config = function()
        local palette = require("colorimetry.palette")
        local fg = palette.fg
        local bg = palette.bg

        local hl = {
            fill = { bg = fg.w3 },
            sep = { fg = fg.w4 },
            buf0 = { bg = "None", fg = fg.w0 }, -- selected
            buf1 = { bg = bg.w1, fg = fg.w1 }, -- visible
            buf2 = { bg = bg.w4, fg = fg.w4 }, -- inactive (background)

            diag0 = { fg = fg.r2 },
            diag1 = { fg = fg.y2 },
            diag2 = { fg = fg.b1 },
            diag3 = { fg = fg.e0 },

            mod = { fg = fg.o3 },
            dup0 = { fg = fg.w2 },
            dup1 = { fg = fg.w3 },
            dup2 = { fg = fg.w5 },
        }

        require("bufferline").setup {
            options = {
                diagnostics = "coc",
                -- separator_style = "thin",
                separator_style = "slant",
                indicator = {
                    style = "none",
                    -- style = "underline"
                },
                left_trunc_marker = "",
                right_trunc_marker = "",
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    if level == "error" then
                        return "🚨" .. count
                    elseif level == "warning" then
                        return "🐤" .. count
                    end
                    -- return "ℹ️ "
                    return ""
                end,
                tab_size = 5,
                max_name_length = 30,
                show_close_icon = false,
                show_buffer_close_icons = false,
                ---@param buf {name: string, path: string, bufnr: integer, buffers: integer[], tabnr: integer}
                name_formatter = function(buf) -- buf contains:
                    local filetype = vim.bo[buf.bufnr].filetype
                    if filetype == "oil" then
                        return vim.iter(vim.split(buf.path, "/", { trimempty = true })):last()
                    end
                    if filetype == "gin-diff" then
                        local _, _, inner = buf.path:find("%%22(.+)%%22")
                        return inner
                    end
                    if filetype == "gin-status" then
                        return "«gin status»"
                    end
                    return buf.name
                end,
                get_element_icon = function(element)
                    -- element consists of {filetype: string, path: string, extension: string, directory: string}
                    if element.filetype == "" then
                        return "", "Normal"
                    end
                    if element.filetype == "oil" then
                        return "", "Directory"
                    end
                    if element.filetype == "gin-diff" then
                        return "𝜕", "DiffChange"
                    end
                    -- fallback to default
                    local icon, hl =
                        require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
                    return icon, hl
                end,
                custom_filter = function(buf_number, buf_numbers)
                    local filetype = vim.bo[buf_number].filetype
                    local ignore_filetypes = {
                        -- "gin-status",
                        "oil",
                    }

                    for _, ignore_filetype in ipairs(ignore_filetypes) do
                        if filetype == ignore_filetype then
                            return false
                        end
                    end
                    return true
                end,
            },

            highlights = {
                fill = hl.fill,
                separator = { bg = hl.buf2.bg, fg = hl.sep.fg },
                separator_visible = { bg = hl.buf1.bg, fg = hl.sep.fg },
                separator_selected = { bg = hl.buf0.bg, fg = hl.sep.fg },

                tab = hl.buf2,
                tab_selected = hl.buf1,
                tab_close = hl.buf0,

                background = hl.buf2,
                buffer_visible = hl.buf1,
                buffer_selected = hl.buf0,

                diagnostic = { bg = hl.buf2.bg, fg = hl.diag3.fg },
                diagnostic_visible = { bg = hl.buf1.bg, fg = hl.diag3.fg },
                diagnostic_selected = { bg = hl.buf0.bg, fg = hl.diag3.fg },
                hint = { bg = hl.buf2.bg, fg = hl.diag3.fg },
                hint_visible = { bg = hl.buf1.bg, fg = hl.diag3.fg },
                hint_selected = { bg = hl.buf0.bg, fg = hl.diag3.fg },
                hint_diagnostic = { bg = hl.buf2.bg, fg = hl.diag3.fg },
                hint_diagnostic_visible = { bg = hl.buf1.bg, fg = hl.diag3.fg },
                hint_diagnostic_selected = { bg = hl.buf0.bg, fg = hl.diag3.fg },
                info = { bg = hl.buf2.bg, fg = hl.diag2.fg },
                info_visible = { bg = hl.buf1.bg, fg = hl.diag2.fg },
                info_selected = { bg = hl.buf0.bg, fg = hl.diag2.fg },
                info_diagnostic = { bg = hl.buf2.bg, fg = hl.diag2.fg },
                info_diagnostic_visible = { bg = hl.buf1.bg, fg = hl.diag2.fg },
                info_diagnostic_selected = { bg = hl.buf0.bg, fg = hl.diag2.fg },
                warning = { bg = hl.buf2.bg, fg = hl.diag1.fg },
                warning_visible = { bg = hl.buf1.bg, fg = hl.diag1.fg },
                warning_selected = { bg = hl.buf0.bg, fg = hl.diag1.fg },
                warning_diagnostic = { bg = hl.buf2.bg, fg = hl.diag1.fg },
                warning_diagnostic_visible = { bg = hl.buf1.bg, fg = hl.diag1.fg },
                warning_diagnostic_selected = { bg = hl.buf0.bg, fg = hl.diag1.fg },
                error = { bg = hl.buf2.bg, fg = hl.diag0.fg },
                error_visible = { bg = hl.buf1.bg, fg = hl.diag0.fg },
                error_selected = { bg = hl.buf0.bg, fg = hl.diag0.fg },
                error_diagnostic = { bg = hl.buf2.bg, fg = hl.diag0.fg },
                error_diagnostic_visible = { bg = hl.buf1.bg, fg = hl.diag0.fg },
                error_diagnostic_selected = { bg = hl.buf0.bg, fg = hl.diag0.fg },
                modified = { bg = hl.buf2.bg, fg = hl.mod.fg },
                modified_visible = { bg = hl.buf1.bg, fg = hl.mod.fg },
                modified_selected = { bg = hl.buf0.bg, fg = hl.mod.fg },
                duplicate = { bg = hl.buf2.bg, fg = hl.dup2.fg },
                duplicate_visible = { bg = hl.buf1.bg, fg = hl.dup1.fg },
                duplicate_selected = { bg = hl.buf0.bg, fg = hl.dup0.fg },
                indicator_selected = { bg = hl.buf0.bg },
                pick_selected = { bg = hl.buf0.bg },
                pick_visible = { bg = hl.buf1.bg },
                pick = { bg = hl.buf2.bg },

                -- offset_separator = { bg = bg.w4, fg = fg.o0 },
                -- close_button = { bg = bg.w4, fg = fg.f3 },
                -- close_button_visible = { bg = "#444444", fg = fg.o0 },
                -- close_button_selected = { bg = "None", fg = fg.o0 },
                -- numbers = { bg = bg.w4, fg = fg.f3 },
                -- numbers_visible = { bg = bg.w2, fg = fg.o0 },
                -- numbers_selected = { bg = "None", fg = fg.o0 },
            },
        }
    end,
}

plugins:push {
    "https://github.com/nvim-lualine/lualine.nvim",
    lazy = false,
    config = function()
        local palette = require("colorimetry.palette")
        local fg = palette.fg
        local bg = palette.bg

        local theme_colorimetry = {
            command = {
                a = { bg = fg.v5, fg = fg.w0, gui = "bold" },
                b = { bg = fg.v1, fg = bg.w0 },
                c = { bg = fg.v0, fg = bg.w0 },
            },
            inactive = {
                a = { bg = fg.w5, fg = fg.w0, gui = "bold" },
                b = { bg = fg.w2, fg = bg.w4 },
                c = { bg = fg.w1, fg = bg.w4 },
            },
            insert = {
                a = { bg = fg.e5, fg = fg.w0, gui = "bold" },
                b = { bg = fg.e1, fg = bg.w0 },
                c = { bg = fg.e0, fg = bg.w0 },
            },
            normal = {
                a = { bg = fg.b5, fg = fg.w0, gui = "bold" },
                b = { bg = fg.b1, fg = bg.w0 },
                c = { bg = fg.b0, fg = bg.w1 },
            },
            replace = {
                a = { bg = fg.o5, fg = fg.w0, gui = "bold" },
                b = { bg = fg.o1, fg = bg.w0 },
                c = { bg = fg.o0, fg = bg.w0 },
            },
            visual = {
                a = { bg = fg.p5, fg = fg.w0, gui = "bold" },
                b = { bg = fg.p1, fg = bg.w0 },
                c = { bg = fg.p0, fg = bg.w0 },
            },
            terminal = {
                a = { bg = fg.r5, fg = fg.w0, gui = "bold" },
                b = { bg = fg.r1, fg = bg.w0 },
                c = { bg = fg.r0, fg = bg.w0 },
            },
        }

        require("lualine").setup {
            sections = {
                lualine_b = {
                    function()
                        local bufname = vim.fn.bufname()
                        if bufname:find("oil://", 1, true) ~= nil then
                            local cwd = require("oil").get_current_dir()
                            local dir_rel = vim.fn.fnamemodify(cwd, ":.")
                            if vim.startswith(dir_rel, "/") then
                                return "[oil] " .. dir_rel
                            else
                                return "[oil] ./" .. dir_rel
                            end
                        end
                        local index = bufname:find("://", 1, true)
                        if index ~= nil then
                            return "[" .. bufname:sub(1, index - 1) .. "]"
                        end
                        return [[%f %m]]
                    end,
                },
                lualine_c = {
                    function()
                        -- table.insert(_G.debug_lualine, vim.fn["coc#status"]())
                        -- return vim.pesc(vim.fn["coc#status"]())
                        return (vim.fn["coc#status"]()):gsub("%%", "%%%%")
                    end,
                },
                lualine_y = {
                    function()
                        local branch = vim.fn["gina#component#repo#branch"]()
                        -- table.insert(_G.debug_lualine, branch)
                        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                        if branch == "" then
                            return cwd
                        else
                            return cwd .. " │ " .. vim.fn["gina#component#repo#branch"]()
                        end
                    end,
                },
                lualine_z = {
                    function()
                        local n = #tostring(vim.fn.line("$"))
                        n = math.max(n, 3)
                        return "%" .. n .. [[l/%-3L:%-2c]]
                    end,
                },
            },
            -- winbar = {
            --     lualine_c = {'filename'},
            -- },
            -- inactive_winbar = {
            --     lualine_a = {},
            --     lualine_b = {},
            --     lualine_c = {'filename'},
            --     lualine_x = {},
            --     lualine_y = {},
            --     lualine_z = {}
            -- },
            options = {
                theme = theme_colorimetry,
                section_separators = { "", "" },
                component_separators = { "", "" },
                globalstatus = true,
                refresh = {
                    statusline = 10000,
                    -- statusline = 1000,
                    tabline = 10000,
                    winbar = 10000,
                },
            },
        }
    end,
}

-- plugins:push {
--     "https://github.com/uga-rosa/ccc.nvim",
--     cmd = { "CccHighlighterEnable" },
-- }

-- plugins:push {
--     "https://github.com/kevinhwang91/nvim-ufo",
--     -- commit = "a15944ff8e3d570f504f743d55209275ed1169c4",
--     dependencies = {
--         "https://github.com/kevinhwang91/promise-async",
--     },
--     config = function()
--         vim.keymap.set("n", "zR", require("ufo").openAllFolds)
--         vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
--
--         local handler = function(virtText, lnum, endLnum, width, truncate)
--             local newVirtText = {}
--             local suffix = (" … 󰁂 %d "):format(endLnum - lnum)
--             local sufWidth = vim.fn.strdisplaywidth(suffix)
--             local targetWidth = width - sufWidth
--             local curWidth = 0
--             for _, chunk in ipairs(virtText) do
--                 local chunkText = chunk[1]
--                 local chunkWidth = vim.fn.strdisplaywidth(chunkText)
--                 if targetWidth > curWidth + chunkWidth then
--                     table.insert(newVirtText, chunk)
--                 else
--                     chunkText = truncate(chunkText, targetWidth - curWidth)
--                     local hlGroup = chunk[2]
--                     table.insert(newVirtText, { chunkText, hlGroup })
--                     chunkWidth = vim.fn.strdisplaywidth(chunkText)
--                     -- str width returned from truncate() may less than 2nd argument, need padding
--                     if curWidth + chunkWidth < targetWidth then
--                         suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
--                     end
--                     break
--                 end
--                 curWidth = curWidth + chunkWidth
--             end
--             table.insert(newVirtText, { suffix, "NonText" })
--             return newVirtText
--         end
--
--         require("ufo").setup {
--             fold_virt_text_handler = handler,
--
--             provider_selector = function(bufnr, filetype, buftype)
--                 if filetype == "python" then
--                     return { "treesitter" }
--                 end
--                 return { "treesitter", "indent" }
--             end,
--         }
--     end,
-- }

plugins:push {
    "https://github.com/rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
        vim.notify = require("notify")
    end,
}

-- plugins:push {
--     "https://github.com/shellRaining/hlchunk.nvim",
--     event = { "UIEnter" },
--     config = function()
--         local ft = require("hlchunk.utils.filetype")
--         require("hlchunk").setup {
--             chunk = {
--                 enable = true,
--                 notify = true,
--                 use_treesitter = true,
--                 -- details about support_filetypes and exclude_filetypes in https://github.com/shellRaining/hlchunk.nvim/blob/main/lua/hlchunk/utils/filetype.lua
--                 support_filetypes = ft.support_filetypes,
--                 exclude_filetypes = ft.exclude_filetypes,
--                 chars = {
--                     horizontal_line = "─",
--                     vertical_line = "│",
--                     left_top = "╭",
--                     left_bottom = "╰",
--                     right_arrow = ">",
--                 },
--                 style = {
--                     { fg = "#806d9c" },
--                     { fg = "#c21f30" }, -- this fg is used to highlight wrong chunk
--                 },
--                 textobject = "",
--                 max_file_size = 1024 * 1024,
--                 error_sign = true,
--             },
--             indent = {
--                 enable = false,
--             },
--             line_num = {
--                 enable = false,
--             },
--             blank = {
--                 enable = false,
--             },
--         }
--     end,
-- }

-- plugins:push {
--     "https://github.com/lewis6991/satellite.nvim",
--     config = function()
--         require("satellite").setup {
--             handlers = {
--                 gitsigns = { enable = false },
--                 diagnostic = { enable = false },
--                 marks = { enable = false },
--             },
--         }
--     end,
-- }

return plugins:collect()
