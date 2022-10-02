local util = require "rc.util"

-- §§1 Plugin settings for ddu.vim
vim.keymap.set("n", "sm", function()
    vim.fn["ddu#start"] {
        sources = {
            { name = "mr", params = { kind = "mru" } },
        },
    }
end)

vim.keymap.set("n", "@o", function()
    vim.fn["ddu#start"] {
        sources = {
            { name = "file_external", params = {} },
        },
    }
end)

vim.keymap.set("n", "@g", function()
    vim.fn["ddu_rg#find"]()
end)

vim.fn["ddu#custom#patch_global"] {
    ui = "ff",
    uiParams = {
        ff = { split = "floating" },
    },
    sources = {
        { name = "file_rec", params = {} },
    },
    sourceOptions = {
        ["_"] = {
            matchers = { "matcher_substring" },
        },
        rg = {
            args = { "--column", "--no-heading", "--color", "never" },
        },
    },
    kindOptions = {
        file = { defaultAction = "open" },
    },
    sourceParams = {
        rg = {
            args = { "--column", "--no-heading", "--color", "--hidden" },
        },
        file_external = {
            cmd = { "fd", ".", "-H", "-E", "__pycache__", "-t", "f" },
        },
    },
}

local function nmap_action(lhs, action)
    vim.keymap.set(
        "n",
        lhs,
        [[<Cmd>call ddu#ui#ff#do_action(']] .. action .. [[')<CR>]],
        { buffer = true, silent = true }
    )
end

util.autocmd_vimrc "FileType" {
    pattern = "ddu-ff",
    callback = function()
        nmap_action("<CR>", "itemAction")
        nmap_action("<Space>", "toggleSelectItem")
        nmap_action("i", "openFilterWindow")
        nmap_action("q", "quit")
        nmap_action("<Esc>", "quit")
    end,
}

util.autocmd_vimrc "FileType" {
    pattern = "ddu-ff-filter",
    callback = function()
        vim.keymap.set("i", "<CR>", "<Esc><Cmd>close<CR>", { buffer = true, silent = true })
        vim.keymap.set("n", "<CR>", "<Cmd>close<CR>", { buffer = true, silent = true })
        vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = true, silent = true })
        vim.keymap.set("n", "<Esc>", "<Cmd>close<CR>", { buffer = true, silent = true })
    end,
}
