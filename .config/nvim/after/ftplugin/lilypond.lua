vim.b.did_ftplugin = 1
vim.opt_local.runtimepath:append {
    "/opt/homebrew/share/lilypond/2.24.0/vim",
}

vim.opt_local.shiftwidth = 2

vim.keymap.set("n", "@q", "<Cmd>!lilypond %<CR>", { buffer = true })
vim.keymap.set("n", "@o", ":!open %:r.pdf<CR>", { buffer = true })

vim.opt_local.commentstring = "% %s"
