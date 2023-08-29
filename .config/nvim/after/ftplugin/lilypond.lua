require("lazy").load { plugins = "dial.nvim" }

vim.b.did_ftplugin = 1
vim.opt_local.runtimepath:append {
    "/opt/homebrew/share/lilypond/2.24.1/vim",
}

vim.opt_local.shiftwidth = 2

vim.keymap.set("n", "@q", "<Cmd>!lilypond %<CR>", { buffer = true })
vim.keymap.set("n", "@o", ":!open %:r.pdf<CR>", { buffer = true })

vim.opt_local.commentstring = "% %s"

vim.keymap.set("n", "<Up>", function()
    require("dial.map").manipulate("increment", "normal", "lilypond_note")
end)

vim.keymap.set("n", "<Down>", function()
    require("dial.map").manipulate("decrement", "normal", "lilypond_note")
end)

vim.keymap.set("n", "gc", function()
    require("dial.map").manipulate("increment", "normal", "lilypond_ises")
end)
