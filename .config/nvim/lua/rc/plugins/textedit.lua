local util = require("rc.util")
local vec = require("rc.util.vec")

local plugins = vec {}
-- textedit
plugins:push {
    "https://github.com/kana/vim-operator-replace",
    dependencies = { "https://github.com/kana/vim-operator-user" },
    keys = {
        { "R", "<Plug>(operator-replace)" },
        { "RR", "<Plug>(operator-replace)_" },
        { "<Space>R", [["+<Plug>(operator-replace)]] },
    },
}

-- plugins:push {
--     "https://github.com/bps/vim-textobj-python",
--     dependencies = { "https://github.com/kana/vim-textobj-user" },
--     ft = { "python" },
-- }

plugins:push {
    "https://github.com/glts/vim-textobj-comment",
    dependencies = { "https://github.com/kana/vim-textobj-user" },
    keys = {
        { "im", "<Plug>(textobj-comment-i)", mode = { "x", "o" } },
        { "am", "<Plug>(textobj-comment-a)", mode = { "x", "o" } },
    },
    config = function()
        vim.g["textobj_comment_no_default_key_mappings"] = 1
    end,
}

plugins:push {
    "https://github.com/kana/vim-textobj-entire",
    dependencies = { "https://github.com/kana/vim-textobj-user" },
    keys = {
        { "ie", mode = { "x", "o" } },
        { "yie", "y<Plug>(textobj-entire-i)<C-o>" },
        { "yae", "y<Plug>(textobj-entire-a)<C-o>" },
        { "=ie", "=<Plug>(textobj-entire-i)<C-o>" },
        { "=ae", "=<Plug>(textobj-entire-a)<C-o>" },
        { "<ie", "<<Plug>(textobj-entire-i)<C-o>" },
        { "<ae", "<<Plug>(textobj-entire-a)<C-o>" },
        { ">ie", "><Plug>(textobj-entire-i)<C-o>" },
        { ">ae", "><Plug>(textobj-entire-a)<C-o>" },
    },
}

plugins:push {
    "https://github.com/machakann/vim-textobj-functioncall",
    dependencies = { "https://github.com/kana/vim-textobj-user" },
    keys = {
        {
            "<Plug>(textobj-functioncall-generics-i)",
            ":<C-u>call textobj#functioncall#ip('o', g:textobj_functioncall_generics_patterns)<CR>",
            mode = "o",
            silent = true,
        },
        {
            "<Plug>(textobj-functioncall-generics-i)",
            ":<C-u>call textobj#functioncall#ip('x', g:textobj_functioncall_generics_patterns)<CR>",
            mode = "x",
            silent = true,
        },
        {
            "<Plug>(textobj-functioncall-generics-a)",
            ":<C-u>call textobj#functioncall#i('o', g:textobj_functioncall_generics_patterns)<CR>",
            mode = "o",
            silent = true,
        },
        {
            "<Plug>(textobj-functioncall-generics-a)",
            ":<C-u>call textobj#functioncall#i('x', g:textobj_functioncall_generics_patterns)<CR>",
            mode = "x",
            silent = true,
        },
    },
    config = function()
        vim.g["textobj_functioncall_no_default_key_mappings"] = 1
        vim.g["textobj_functioncall_generics_patterns"] = {
            {
                header = [[\<\%(\h\k*\.\)*\h\k*]],
                bra = "<",
                ket = ">",
                footer = "",
            },
        }
    end,
}

plugins:push {
    "https://github.com/kana/vim-textobj-user",
    -- まあまあ面倒くさいからいいや
    -- keys = {
    --     {"il", mode = {"x", "o"}},
    --     {"al", mode = {"x", "o"}},
    -- },
    config = function()
        vim.fn["textobj#user#plugin"]("line", {
            ["-"] = {
                ["select-a-function"] = "CurrentLineA",
                ["select-a"] = "al",
                ["select-i-function"] = "CurrentLineI",
                ["select-i"] = "il",
            },
        })

        -- function vim.fn.CurrentLineA()
        --     vim.cmd [[ normal! 0 ]]
        --     local head_pos = vim.fn.getpos "."
        --     vim.cmd [[ normal! $ ]]
        --     local tail_pos = vim.fn.getpos "."
        --     return { "v", head_pos, tail_pos }
        -- end
        --
        -- function vim.fn.CurrentLineI()
        --     vim.cmd [[ normal! ^ ]]
        --     local head_pos = vim.fn.getpos "."
        --     vim.cmd [[ normal! g_ ]]
        --     local tail_pos = vim.fn.getpos "."
        --     return { "v", head_pos, tail_pos }
        -- end

        vim.cmd([[
            function! CurrentLineA()
              normal! 0
              let head_pos = getpos('.')
              normal! $
              let tail_pos = getpos('.')
              return ['v', head_pos, tail_pos]
            endfunction

            function! CurrentLineI()
              normal! ^
              let head_pos = getpos('.')
              normal! g_
              let tail_pos = getpos('.')
              let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
              return
              \ non_blank_char_exists_p
              \ ? ['v', head_pos, tail_pos]
              \ : 0
            endfunction
        ]])

        vim.fn["textobj#user#plugin"]("jbraces", {
            parens = {
                pattern = { "（", "）" },
                ["select-a"] = "aj)",
                ["select-i"] = "ij)",
            },
            braces = {
                pattern = { "「", "」" },
                ["select-a"] = "aj]",
                ["select-i"] = "ij]",
            },
            double_braces = {
                pattern = { "『", "』" },
                ["select-a"] = "aj}",
                ["select-i"] = "ij}",
            },
            lenticular_bracket = {
                pattern = { "【", "】" },
                ["select-a"] = "aj>",
                ["select-i"] = "ij>",
            },
        })

        util.autocmd_vimrc("FileType") {
            pattern = "tex",
            callback = function()
                vim.fn["textobj#user#plugin"]("texquote", {
                    single = {
                        pattern = { "`", "'" },
                        ["select-a"] = "aq",
                        ["select-i"] = "iq",
                    },
                    double = {
                        pattern = { "``", "''" },
                        ["select-a"] = "aQ",
                        ["select-i"] = "iQ",
                    },
                })
            end,
        }

        util.autocmd_vimrc("FileType") {
            pattern = "satysfi",
            callback = function()
                vim.fn["textobj#user#plugin"]("satyblock", {
                    block = {
                        pattern = { "<%", ">%" },
                        ["select-a"] = "a>",
                        ["select-i"] = "i>",
                    },
                })
            end,
        }
    end,
}

plugins:push {
    "https://github.com/machakann/vim-swap",
    keys = {
        "gs",
        { "i,", "<Plug>(swap-textobject-i)", mode = { "x", "o" } },
        { "a,", "<Plug>(swap-textobject-a)", mode = { "x", "o" } },
    },
}

return plugins:collect()
