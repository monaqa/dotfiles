-- vim:fdm=marker:fmr=§§,■■
local util = require("rc.util")
local obsidian = require("rc.obsidian")

-- §§1 ftdetect
util.link_filetype { pattern = "Satyristes", filetype = "lisp" }
util.link_filetype {
    extension = { "saty", "satyh", "satyh-*", "satyg" },
    filetype = function()
        if vim.fn.getline(1) == "%SATySFi v0.1.0" then
            return "satysfi_v0_1_0"
        else
            return "satysfi"
        end
    end,
}

util.link_filetype { extension = "fish", filetype = "fish" }
util.link_filetype { extension = "mmd", filetype = "mermaid" }
util.link_filetype { extension = "todome", filetype = "todome" }
util.link_filetype { extension = "nim", filetype = "nim" }
util.link_filetype { extension = "jison", filetype = "yacc" }
util.link_filetype { extension = "jsonl", filetype = "jsonl" }
util.link_filetype { extension = "d2", filetype = "d2" }
util.link_filetype { extension = "mdx", filetype = "markdown" }
util.link_filetype { extension = "nu", filetype = "nu" }
util.link_filetype { extension = "typ", filetype = "typst" }
util.link_filetype { extension = "sus", filetype = "sus" }
util.link_filetype { extension = "mbt", filetype = "moonbit" }

util.link_filetype { pattern = "LICENSE", filetype = "license" }
util.link_filetype { pattern = ".init.lua.local", filetype = "lua" }
util.link_filetype { pattern = "*/queries/*/*.scm", filetype = "query" }

-- obsidian
-- util.autocmd_vimrc { "BufEnter", "BufNewFile" } {
--     pattern = vim.tbl_map(function(s)
--         return obsidian.root_dir .. s
--     end, obsidian.file_pattern),
--     callback = function()
--         vim.opt_local.filetype = "obsidian"
--     end,
-- }

-- §§1 other scripts

util.autocmd_vimrc { "BufRead", "BufNewFile" } {
    pattern = "*.saty",
    callback = function()
        vim.keymap.set("n", "@o", ":!open %:r.pdf<CR>", { buffer = true })
        vim.keymap.set("n", "@q", ":!satysfi %<CR>", { buffer = true })
        vim.keymap.set(
            "n",
            "@Q",
            ":!satysfi --debug-show-bbox --debug-show-space --debug-show-block-bbox --debug-show-block-space --debug-show-overfull %<CR>",
            { buffer = true }
        )
    end,
}

-- §§1 quickfix
util.autocmd_vimrc("FileType") {
    pattern = "qf",
    callback = function()
        vim.keymap.set("n", "<CR>", "<CR>", { buffer = true })
        vim.keymap.set("n", "j", "j", { buffer = true })
        vim.keymap.set("n", "k", "k", { buffer = true })
    end,
}

-- §§1 html
util.autocmd_vimrc { "BufRead", "BufNewFile" } {
    pattern = "*.html",
    callback = function()
        vim.keymap.set("i", "</", "</<C-x><C-o>", { buffer = true })
        vim.bo.shiftwidth = 2
    end,
}
