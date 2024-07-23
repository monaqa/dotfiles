local util = require("rc.util")
local vec = require("rc.util.vec")

local plugins = vec {}

local fg = require("monaqa.colorimetry").fg
local bg = require("monaqa.colorimetry").bg

-- colorscheme
plugins:push {
    "https://github.com/habamax/vim-gruvbit",
    keys = {
        {
            "@c",
            function()
                vim.cmd.colorscheme("colorimetry")
            end,
        },
        {
            "@x",
            function()
                vim.cmd.colorscheme("gruvbit")
            end,
        },
        {
            "@z",
            function()
                vim.cmd.edit("~/.config/nvim/colors/colorimetry.lua")
                local bufnr = vim.fn.bufnr()
                util.autocmd_vimrc("BufWritePost") {
                    buffer = bufnr,
                    callback = function()
                        vim.cmd.colorscheme("colorimetry")
                    end,
                }
            end,
        },
    },
    config = function()
        vim.g.gruvbit_transp_bg = 0

        util.autocmd_vimrc { "ColorScheme" } {
            pattern = "gruvbit",
            callback = function()
                -- basic
                util.sethl("FoldColumn") { bg = "#303030" }
                util.sethl("NonText") { fg = "#496da9" }
                util.sethl("Todo") { bold = true, bg = "#444444", fg = "#c6b7a2" }
                util.sethl("CursorLine") { bg = "#3d4041" }
                util.sethl("CursorColumn") { bg = "#3d4041" }
                util.sethl("Folded") { bg = "#303030", bold = true, italic = true }

                util.sethl("VertSplit") { fg = "#c8c8c8", bg = "None", default = false }
                util.sethl("Visual") { bg = "#4d564e" }
                util.sethl("Pmenu") { bg = "#404064" }
                util.sethl("NormalFloat") { link = "Pmenu" }
                util.sethl("CurSearch") { link = "Search" }
                util.sethl("QuickFixLine") { bg = "#4d569e" }

                util.sethl("DiffChange") { bg = "#314a5c" }
                util.sethl("DiffDelete") { bg = "#5c3728", fg = "#968772" }
                util.sethl("MatchParen") { bg = "#51547d", fg = "#ebdbb2" }

                util.sethl("LineNr") { fg = "#968772", bg = "#2a2a2a" }

                vim.api.nvim_set_hl(0, "TSNodeMarker", { bg = "#243243" })

                -- coc.nvim
                util.sethl("CocInlayHint") { bg = "#444444", fg = "#90816c", italic = true }
                -- util.sethl "CocHintFloat" { bg = "#444444", fg = "#45daef" }
                util.sethl("CocRustChainingHint") { link = "CocInlayHint" }
                util.sethl("CocSearch") { fg = "#fabd2f" }
                util.sethl("CocMenuSel") { bg = "#604054" }

                -- custom highlight name
                util.sethl("WeakTitle") { fg = "#fad57f" }
                util.sethl("Quote") { fg = "#c6b7a2" }
                util.sethl("VisualBlue") { bg = "#4d569e" }
                util.sethl("FernIndentMarkers") { fg = "#707070" }

                -- gitsigns
                util.sethl("GitSignsAdd") { fg = "#98971a", bg = "None" }
                util.sethl("GitSignsChange") { fg = "#458588", bg = "None" }
                util.sethl("GitSignsDelete") { fg = "#cc241d", bg = "None" }
                -- util.sethl "GitSignsAddNr" { fg = "#88870a", bg = "None" }
                -- util.sethl "GitSignsChangeNr" { fg = "#357578", bg = "None" }
                -- util.sethl "GitSignsDeleteNr" { fg = "#bc140d", bg = "None" }
                util.sethl("GitSignsAddNr") { bg = "#3b5e48", fg = "#968772" }
                util.sethl("GitSignsChangeNr") { bg = "#314a5c", fg = "#968772" }
                util.sethl("GitSignsDeleteNr") { link = "DiffDelete" } -- #5c3728
                util.sethl("GitSignsChangeDeleteNr") { bg = "#5c3a5c", fg = "#968772" }
                util.sethl("GitSignsAddLn") { bg = "#122712" }
                util.sethl("GitSignsChangeLn") { bg = "#112030" }
                util.sethl("GitSignsDeleteLn") { bg = "#291308" }

                -- nvim-treesitter
                util.sethl("TSParameter") { fg = "#b3d5c8" }
                util.sethl("TSField") { fg = "#b3d5c8" }

                util.sethl("Function") { link = "Identifier" }

                util.sethl("rustCommentLineDoc") { fg = "#9e8f7a", bold = true }

                util.sethl("@comment") { link = "Comment" }
                util.sethl("@comment.doccomment") { link = "rustCommentLineDoc" }

                util.sethl("@attribute") { link = "PreProc" }
                util.sethl("@boolean") { link = "Boolean" }
                util.sethl("@character") { link = "Character" }
                util.sethl("@character.special") { link = "SpecialChar" }
                util.sethl("@conditional") { link = "Conditional" }
                util.sethl("@constant") { link = "Constant" }
                util.sethl("@constant.builtin") { link = "Special" }
                util.sethl("@constant.macro") { link = "Define" }
                util.sethl("@constructor") { link = "Special" }
                util.sethl("@debug") { link = "Debug" }
                util.sethl("@define") { link = "Define" }
                util.sethl("@exception") { link = "Exception" }
                util.sethl("@field") { link = "TSField" }
                util.sethl("@float") { link = "Float" }
                util.sethl("@function") { link = "Function" }
                util.sethl("@function.builtin") { link = "Special" }
                util.sethl("@function.call") { link = "Function" }
                util.sethl("@function.macro") { link = "Macro" }
                util.sethl("@include") { link = "Include" }
                util.sethl("@keyword") { link = "Keyword" }
                util.sethl("@label") { link = "Label" }
                util.sethl("@method") { link = "Function" }
                util.sethl("@method.call") { link = "Function" }
                util.sethl("@namespace") { link = "Include" }
                util.sethl("@none") { bg = "NONE", fg = "NONE" }
                util.sethl("@number") { link = "Number" }
                util.sethl("@operator") { link = "Operator" }
                util.sethl("@parameter") { link = "TSParameter" }
                util.sethl("@preproc") { link = "PreProc" }
                util.sethl("@property") { link = "Function" }
                util.sethl("@punctuation") { link = "Delimiter" }
                util.sethl("@repeat") { link = "Repeat" }
                util.sethl("@storageclass") { link = "StorageClass" }
                util.sethl("@string") { link = "String" }
                util.sethl("@string.escape") { link = "SpecialChar" }
                util.sethl("@string.regex") { link = "String" }
                util.sethl("@string.special") { link = "SpecialChar" }
                util.sethl("@symbol") { link = "Identifier" }
                util.sethl("@tag") { link = "Tag" }
                util.sethl("@tag.attribute") { link = "Identifier" }
                util.sethl("@tag.delimiter") { link = "Delimiter" }
                util.sethl("@text") { link = "Normal" }
                util.sethl("@text.danger") { link = "ErrorMsg" }
                util.sethl("@text.diff.add") { link = "DiffAdd" }
                util.sethl("@text.diff.change") { link = "DiffChange" }
                util.sethl("@text.diff.delete") { link = "DiffDelete" }
                util.sethl("@text.diff.addsign") { link = "@string" }
                util.sethl("@text.diff.delsign") { link = "@type" }
                util.sethl("@text.emphasis") { italic = true }
                util.sethl("@text.environment") { link = "Macro" }
                util.sethl("@text.environment.name") { link = "Type" }
                util.sethl("@text.literal") { link = "String" }
                util.sethl("@text.math") { link = "Special" }
                util.sethl("@text.note") { link = "SpecialComment" }
                util.sethl("@text.quote") { link = "Quote" }
                util.sethl("@text.reference") { link = "Constant" }
                util.sethl("@text.strike") { strikethrough = true }
                util.sethl("@text.strong") { bold = true }
                util.sethl("@text.title") { link = "Title" }
                util.sethl("@text.title.weak") { link = "WeakTitle" }
                util.sethl("@text.todo") { link = "Todo" }
                util.sethl("@text.underline") { underline = true }
                util.sethl("@text.uri") { link = "Underlined" }
                util.sethl("@text.warning") { link = "WarningMsg" }
                util.sethl("@type") { link = "Type" }
                util.sethl("@type.builtin") { link = "Type" }
                util.sethl("@type.definition") { link = "Typedef" }
                util.sethl("@type.qualifier") { link = "Type" }
                util.sethl("@variable") { link = "Normal" }
                util.sethl("@variable.builtin") { link = "Special" }

                util.sethl("@text.diff.indicator") { bg = "#555555" }
            end,
        }
    end,
}

plugins:push {
    "https://github.com/akinsho/bufferline.nvim",
    tag = "v4.6.1",
    lazy = false,
    keys = {
        { "sN", "<Cmd>BufferLineMoveNext<CR>" },
        { "sP", "<Cmd>BufferLineMovePrev<CR>" },
        { "sw", "<Cmd>bp | bd #<CR>" },
    },
    config = function()
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
                background = { bg = bg.w4, fg = fg.w3 },
                tab = { bg = bg.w4, fg = fg.w0 },
                tab_selected = { bg = "None", fg = fg.o0 },
                tab_close = { bg = bg.w4, fg = fg.f3 },
                -- close_button = { bg = bg.w4, fg = fg.f3 },
                -- close_button_visible = { bg = "#444444", fg = fg.o0 },
                -- close_button_selected = { bg = "None", fg = fg.o0 },
                buffer_visible = { bg = bg.y4, fg = fg.y0 },
                buffer_selected = { bg = "None", fg = fg.w0 },
                numbers = { bg = bg.w4, fg = fg.f3 },
                numbers_visible = { bg = bg.w2, fg = fg.o0 },
                numbers_selected = { bg = "None", fg = fg.o0 },
                diagnostic = { bg = bg.w4 },
                diagnostic_visible = { bg = bg.w2 },
                diagnostic_selected = { bg = "None" },
                hint = { bg = bg.w4, fg = fg.f3 },
                hint_visible = { bg = bg.w2, fg = fg.o0 },
                hint_selected = { bg = "None", fg = fg.o0 },
                hint_diagnostic = { bg = bg.w4, fg = fg.f3 },
                hint_diagnostic_visible = { bg = bg.w2, fg = fg.o0 },
                hint_diagnostic_selected = { bg = "None", fg = fg.o0 },
                info = { bg = bg.w4, fg = fg.f3 },
                info_visible = { bg = bg.w2, fg = fg.o0 },
                info_selected = { bg = "None", fg = fg.o0 },
                info_diagnostic = { bg = bg.w4, fg = fg.f3 },
                info_diagnostic_visible = { bg = bg.w2, fg = fg.o0 },
                info_diagnostic_selected = { bg = "None", fg = fg.o0 },
                warning = { bg = bg.w4 },
                warning_visible = { bg = bg.w2 },
                warning_selected = { bg = "None" },
                warning_diagnostic = { bg = bg.w4 },
                warning_diagnostic_visible = { bg = bg.w2 },
                warning_diagnostic_selected = { bg = "None" },
                error = { bg = bg.w4, fg = fg.r5 },
                error_visible = { bg = bg.w2, fg = fg.r1 },
                error_selected = { bg = "None" },
                error_diagnostic = { bg = bg.w4, fg = fg.r5 },
                error_diagnostic_visible = { bg = bg.w2, fg = fg.r1 },
                error_diagnostic_selected = { bg = "None" },
                modified = { bg = bg.w4 },
                modified_visible = { bg = bg.w2 },
                modified_selected = { bg = "None" },
                duplicate_selected = { bg = "None" },
                duplicate_visible = { bg = bg.w2 },
                duplicate = { bg = bg.w4 },
                indicator_selected = { bg = "None", fg = fg.o0 },
                pick_selected = { bg = "None", fg = fg.o0 },
                pick_visible = { bg = bg.w2, fg = fg.o0 },
                pick = { bg = bg.w4, fg = fg.f3 },
                offset_separator = { bg = bg.w4, fg = fg.o0 },

                fill = { bg = fg.w3 },
                separator = { bg = bg.w4, fg = fg.w4 },
                separator_visible = { bg = bg.y4, fg = fg.w4 },
                separator_selected = { bg = "None", fg = fg.w4 },
            },
        }
    end,
}

plugins:push {
    "https://github.com/nvim-lualine/lualine.nvim",
    lazy = false,
    config = function()
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
