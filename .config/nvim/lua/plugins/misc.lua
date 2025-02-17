local monaqa = require("monaqa")
local mapset = monaqa.shorthand.mapset
local create_cmd = monaqa.shorthand.create_cmd
local vec = require("rc.util.vec")

local plugins = vec {}

plugins:push {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        require("snacks").setup {
            picker = { enabled = true },
            notifier = { enabled = true },
            input = { enabled = true },
            lazygit = { enabled = true },
        }
    end,
}

-- plugins:push {
--     "https://github.com/lambdalisue/vim-guise",
--     config = function()
--         vim.g.guise_edit_opener = "split"
--     end,
-- }

-- plugins:push {
--     "https://github.com/nvim-neotest/neotest",
--     dependencies = {
--         "https://github.com/nvim-neotest/nvim-nio",
--         "https://github.com/nvim-lua/plenary.nvim",
--         "https://github.com/antoinemadec/FixCursorHold.nvim",
--         "https://github.com/nvim-treesitter/nvim-treesitter",
--         "https://github.com/rouge8/neotest-rust",
--     },
--     config = function()
--         require("neotest").setup {
--             adapters = {
--                 require("neotest-rust"),
--             },
--         }
--     end,
-- }

plugins:push {
    "https://github.com/4513ECHO/nvim-keycastr",
    cmd = { "KeyCastr" },
    config = function()
        local keycastr = require("keycastr")

        keycastr.config.set {
            ignore_mouse = true,
            position = "SE",
            win_config = {
                border = "rounded",
                width = 60,
            },
        }

        local active = false

        create_cmd("KeyCastr") {
            function()
                if active then
                    keycastr.disable()
                    active = false
                else
                    keycastr.enable()
                    active = true
                    vim.print(" ") -- cmdline を clear する
                end
            end,
        }

        mapset.nxo("<C-s>") {
            function()
                keycastr.disable()
                keycastr.enable()
            end,
        }
        mapset.ic("<C-s>") {
            function()
                keycastr.disable()
                keycastr.enable()
            end,
        }
    end,
}

-- plugins:push {
--     "https://github.com/notomo/waitevent.nvim",
--     config = function()
--         -- all default options
--         local default = {
--             open = function(ctx, ...)
--                 local paths = { ... }
--                 for _, path in ipairs(paths) do
--                     vim.cmd.tabedit(path)
--                     ctx.tcd()
--                     vim.bo.bufhidden = "wipe"
--                 end
--                 if #paths == 0 then
--                     vim.cmd.new()
--                     ctx.tcd()
--                     vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(ctx.stdin, "\n", { plain = true }))
--                     vim.bo.modified = false
--                     vim.bo.bufhidden = "wipe"
--                 end
--                 if ctx.row then
--                     local row = math.min(ctx.row, vim.api.nvim_buf_line_count(0))
--                     vim.api.nvim_win_set_cursor(0, { row, 0 })
--                 end
--             end,
--
--             done_events = {
--                 "BufWritePost",
--             },
--             on_done = function(ctx)
--                 if vim.api.nvim_win_is_valid(ctx.window_id_after_open) and #vim.api.nvim_list_wins() > 1 then
--                     vim.api.nvim_win_close(ctx.window_id_after_open, true)
--                 end
--                 if not vim.api.nvim_win_is_valid(ctx.window_id_before_open) then
--                     return
--                 end
--                 vim.api.nvim_set_current_win(ctx.window_id_before_open)
--             end,
--
--             cancel_events = {
--                 "BufUnload",
--                 "BufDelete",
--                 "BufWipeout",
--             },
--             on_canceled = function(ctx)
--                 if not vim.api.nvim_win_is_valid(ctx.window_id_before_open) then
--                     return
--                 end
--                 vim.api.nvim_set_current_win(ctx.window_id_before_open)
--             end,
--         }
--
--         -- Use for git command editor.
--         -- This editor finishes the process on save or close.
--         vim.env.GIT_EDITOR = require("waitevent").editor {
--             open = function(ctx, path)
--                 vim.cmd.split(path)
--                 ctx.lcd()
--                 vim.bo.bufhidden = "wipe"
--             end,
--         }
--
--         -- Use for `nvim {file_path}` in :terminal.
--         -- This editor finishes the process as soon as open.
--         -- The fowllowing shell settings is convinient (optional).
--         -- `export EDITOR=nvim` in .bash_profile
--         -- `alias nvim="${EDITOR}"` in .bashrc
--         vim.env.EDITOR = require("waitevent").editor {
--             open = default.open,
--             done_events = {},
--             cancel_events = {},
--         }
--
--         require("waitevent").editor(default)
--     end,
-- }

plugins:push { "https://github.com/notomo/lreload.nvim" }

plugins:push {
    "https://github.com/haya14busa/vim-asterisk",
    keys = {
        { "*", "<Plug>(asterisk-z*)" },
        { "#", "<Plug>(asterisk-z#)" },
        { "g*", "<Plug>(asterisk-gz*)" },
        { "g#", "<Plug>(asterisk-gz#)" },
    },
}

plugins:push {
    "https://github.com/iamcco/markdown-preview.nvim",
    ft = { "markdown", "mdx" },
    run = ":call mkdp#util#install()",
    config = function()
        vim.g.mkdp_markdown_css = vim.fn.expand("~/.config/nvim/resource/github-markdown-light.css")
        vim.g.mkdp_auto_close = 0
        vim.g.mkdp_preview_options = {
            disable_sync_scroll = 1,
        }
    end,
}

plugins:push { "https://github.com/itchyny/vim-qfedit", ft = { "qf" } }

plugins:push {
    "https://github.com/kana/vim-altr",
    keys = {
        { "<Space>^", "<Plug>(altr-forward)" },
        { "<Space>-", "<Plug>(altr-forward)" },
    },
}

plugins:push { "https://github.com/kkiyama117/zenn-vim", lazy = true }

plugins:push { "https://github.com/lambdalisue/vim-protocol" }

plugins:push { "https://github.com/mattn/vim-maketable", cmd = { "MakeTable", "UnmakeTable" } }

plugins:push { "https://github.com/mbbill/undotree", keys = { { "U", "<Cmd>UndotreeToggle<CR>" } } }

plugins:push {
    "https://github.com/rhysd/rust-doc.vim",
    ft = "rust",
    config = function()
        vim.g["rust_doc#define_map_K"] = 0
    end,
}

plugins:push {
    "https://github.com/ryicoh/deepl.vim",
    dependencies = {
        "https://github.com/monaqa/general-converter.nvim",
    },
    keys = {
        { "@j", mode = { "n", "x" } },
        { "@e", mode = { "n", "x" } },
    },
    enabled = function()
        return not (vim.fn.getenv("DEEPL_API_KEY") == vim.NIL)
    end,
    config = function()
        vim.g["deepl#endpoint"] = "https://api-free.deepl.com/v2/translate"
        vim.g["deepl#auth_key"] = vim.fn.getenv("DEEPL_API_KEY")

        mapset.n("@j") {
            desc = [[DeepL を用いて日本語に翻訳する]],
            expr = true,
            function()
                return require("general_converter").operator_convert(function(s)
                    local translate_result = vim.fn["deepl#translate"](s, "ja")
                    return s .. "\n" .. translate_result
                end)()
            end,
        }
        mapset.x("@j") {
            desc = [[DeepL を用いて日本語に翻訳する]],
            function()
                vim.fn["deepl#v"]("JA")
            end,
        }
        mapset.n("@e") {
            desc = [[DeepL を用いて英語に翻訳する]],
            expr = true,
            function()
                return require("general_converter").operator_convert(function(s)
                    local translate_result = vim.fn["deepl#translate"](s, "en")
                    return s .. "\n" .. translate_result
                end)()
            end,
        }
        mapset.x("@e") {
            desc = [[DeepL を用いて英語に翻訳する]],
            function()
                vim.fn["deepl#v"]("EN")
            end,
        }
    end,
}

-- plugins:push {
--     "https://github.com/numToStr/Comment.nvim",
--     dependencies = {
--         "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
--     },
--     keys = {
--         { ",", "<Plug>(comment_toggle_linewise)", mode = { "n" } },
--         { ",", "<Plug>(comment_toggle_linewise_visual)", mode = { "x" } },
--         { ",,", "<Plug>(comment_toggle_linewise)_", mode = { "n" } },
--     },
--     config = function()
--         require("Comment").setup {
--             ---Add a space b/w comment and the line
--             padding = true,
--             -- ---Whether the cursor should stay at its position
--             -- sticky = true,
--             -- ---Lines to be ignored while (un)comment
--             -- ignore = nil,
--             mappings = {
--                 ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
--                 basic = false,
--                 ---Extra mapping; `gco`, `gcO`, `gcA`
--                 extra = false,
--             },
--             -- ---Function to call before (un)comment
--             pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
--             -- ---Function to call after (un)comment
--             -- post_hook = nil,
--         }
--     end,
-- }

plugins:push { "https://github.com/thinca/vim-qfreplace", ft = { "qf" } }

plugins:push { "https://github.com/tyru/capture.vim", cmd = { "Capture" } }

plugins:push {
    "https://github.com/tyru/open-browser.vim",
    keys = {
        { "gb", "<Plug>(openbrowser-smart-search)", mode = { "n", "x" } },
    },
}

plugins:push {
    "https://github.com/thinca/vim-partedit",
    cmd = {
        "ParteditCodeblock",
    },
    config = function()
        vim.g["partedit#opener"] = ":vsplit"
        vim.g["partedit#prefix_pattern"] = [[\v\s*]]

        create_cmd("ParteditCodeblock") {
            desc = [[Markdown のコードブロックを選択し、filetype をよしなに設定して partedit を開く。]],
            range = true,
            function(meta)
                local line_codeblock_start = vim.fn.getline(meta.line1 - 1)
                local filetype = vim.fn.matchstr(line_codeblock_start, [[\v```\zs[-a-zA-Z0-9]+\ze]])
                local options = { filetype = filetype }
                vim.fn["partedit#start"](meta.line1, meta.line2, options)
            end,
        }
    end,
}

return plugins:collect()
