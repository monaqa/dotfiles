vim.opt_local.shiftwidth = 2

vim.opt_local.commentstring = "// %s"
vim.keymap.set("n", "@o", ":!open %:r.pdf<CR>", { buffer = true })
