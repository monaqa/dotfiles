vim.g.vim_indent_cont = 0

vim.opt_local.shiftwidth = 2
vim.opt_local.keywordprg = ":help"
vim.opt_local.formatoptions:remove { "r", "o" }

vim.keymap.set("n", "K", "K", { buffer = true })
