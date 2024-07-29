local util = require("rc.util")
local vec = require("rc.util.vec")

local plugins = vec {}

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
-- plugins:push {
--     "kana/vim-smartword",
--     keys = {
--         { "w", "<Plug>(smartword-w)", mode = { "n", "x" } },
--         { "e", "<Plug>(smartword-e)", mode = { "n", "x" } },
--         { "b", "<Plug>(smartword-b)", mode = { "n", "x" } },
--         { "ge", "<Plug>(smartword-ge)", mode = { "n", "x" } },
--     },
-- }

plugins:push { "https://github.com/kkiyama117/zenn-vim", lazy = true }

plugins:push { "https://github.com/lambdalisue/vim-protocol" }

plugins:push {
    "https://github.com/lifepillar/vim-colortemplate",
    cmd = { "Colortemplate" },
    ft = { "colortemplate" },
    config = function()
        vim.g.colortemplate_toolbar = 0
    end,
}

-- plugins:push {
--     "mattn/emmet-vim",
--     config = function()
--         vim.g["user_emmet_mode"] = "n"
--         vim.g["emmet_html5"] = 0
--         vim.g["user_emmet_install_global"] = 0
--     end,
-- }

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
        {
            "@j",
            function()
                return require("general_converter").operator_convert(function(s)
                    local translate_result = vim.fn["deepl#translate"](s, "ja")
                    return s .. "\n" .. translate_result
                end)()
            end,
            expr = true,
            mode = "n",
            desc = "DeepL translate to ja",
        },
        {
            "@j",
            function()
                vim.fn["deepl#v"]("JA")
            end,
            mode = "x",
            desc = "DeepL translate to ja",
        },
        {
            "@e",
            function()
                return require("general_converter").operator_convert(function(s)
                    local translate_result = vim.fn["deepl#translate"](s, "en")
                    return s .. "\n" .. translate_result
                end)()
            end,
            expr = true,
            mode = "n",
            desc = "DeepL translate to en",
        },
        {
            "@e",
            function()
                vim.fn["deepl#v"]("EN")
            end,
            mode = "x",
            desc = "DeepL translate to en",
        },
    },
    enabled = function()
        return not (vim.fn.getenv("DEEPL_API_KEY") == vim.NIL)
    end,
    config = function()
        vim.g["deepl#endpoint"] = "https://api-free.deepl.com/v2/translate"
        vim.g["deepl#auth_key"] = vim.fn.getenv("DEEPL_API_KEY")
    end,
}

plugins:push {
    "https://github.com/numToStr/Comment.nvim",
    dependencies = {
        "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
    },
    keys = {
        { ",", "<Plug>(comment_toggle_linewise)", mode = { "n" } },
        { ",", "<Plug>(comment_toggle_linewise_visual)", mode = { "x" } },
        { ",,", "<Plug>(comment_toggle_linewise)_", mode = { "n" } },
    },
    config = function()
        require("Comment").setup {
            ---Add a space b/w comment and the line
            padding = true,
            -- ---Whether the cursor should stay at its position
            -- sticky = true,
            -- ---Lines to be ignored while (un)comment
            -- ignore = nil,
            mappings = {
                ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
                basic = false,
                ---Extra mapping; `gco`, `gcO`, `gcA`
                extra = false,
            },
            -- ---Function to call before (un)comment
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            -- ---Function to call after (un)comment
            -- post_hook = nil,
        }
    end,
}

plugins:push { "https://github.com/thinca/vim-qfreplace", ft = { "qf" } }
-- plugins:push { "https://github.com/thinca/vim-quickrun" }

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

        util.create_cmd("ParteditCodeblock", function(meta)
            local line_codeblock_start = vim.fn.getline(meta.line1 - 1)
            local filetype = vim.fn.matchstr(line_codeblock_start, [[\v```\zs[-a-zA-Z0-9]+\ze]])
            local options = { filetype = filetype }
            vim.fn["partedit#start"](meta.line1, meta.line2, options)
        end, { range = true })
    end,
}

return plugins:collect()
