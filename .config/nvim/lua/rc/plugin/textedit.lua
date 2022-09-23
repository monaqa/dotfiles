-- vim:fdm=marker:fmr=§§,■■
-- operator や motion、 text object など。

local util = require("rc.util")

-- §§1 Plugin settings for glts/vim-textobj-comment

vim.g["textobj_comment_no_default_key_mappings"] = 1
vim.keymap.set({"x", "o"}, "im", "<Plug>(textobj-comment-i)", {remap = true})
vim.keymap.set({"x", "o"}, "am", "<Plug>(textobj-comment-a)", {remap = true})

-- §§1 Plugin settings for kana/vim-textobj-user

vim.fn["textobj#user#plugin"]("line", {
    ["-"] = {
        ["select-a-function"] = "CurrentLineA",
        ['select-a'] = 'al',
        ['select-i-function'] = 'CurrentLineI',
        ['select-i'] = 'il',
    }
})

vim.cmd[[
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
]]

vim.fn["textobj#user#plugin"]("jbraces", {
    parens = {
        pattern = {"（", "）"},
        ["select-a"] = "aj)",
        ["select-i"] = "ij)",
    },
    braces = {
        pattern = {"「", "」"},
        ["select-a"] = "aj]",
        ["select-i"] = "ij]",
    },
    double_braces = {
        pattern = {"『", "』"},
        ["select-a"] = "aj}",
        ["select-i"] = "ij}",
    },
    lenticular_bracket = {
        pattern = {"【", "】"},
        ["select-a"] = "aj>",
        ["select-i"] = "ij>",
    },
})

util.autocmd_vimrc("FileType"){
    pattern = "tex",
    callback = function ()
        vim.fn["textobj#user#plugin"]("texquote", {
            single = {
                pattern = {"`", "'"},
                ["select-a"] = "aq",
                ["select-i"] = "iq",
            },
            double = {
                pattern = {"``", "''"},
                ["select-a"] = "aQ",
                ["select-i"] = "iQ",
            },
        })
    end
}

util.autocmd_vimrc("FileType"){
    pattern = "satysfi",
    callback = function ()
        vim.fn["textobj#user#plugin"]("satyblock", {
            block = {
                pattern = {"<%", ">%"},
                ["select-a"] = "a>",
                ["select-i"] = "i>",
            },
        })
    end
}

-- §§1 Plugin settings for machakann/vim-swap
vim.keymap.set({"o", "x"}, "i,", "<Plug>(swap-textobject-i)")
vim.keymap.set({"o", "x"}, "a,", "<Plug>(swap-textobject-a)")

-- §§1 Plugin settings for textobje-entire
for _, op in ipairs({
    "y",
    "=",
    "<",
    ">",
}) do
    vim.keymap.set("n", op .. "ie", op .. "<Plug>(textobj-entire-i)<C-o>", {remap = true})
    vim.keymap.set("n", op .. "ae", op .. "<Plug>(textobj-entire-a)<C-o>", {remap = true})
end
