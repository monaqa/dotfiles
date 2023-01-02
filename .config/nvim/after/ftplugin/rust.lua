vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.formatoptions:remove { "r", "o" }

vim.keymap.set("n", "tk", "<Cmd>CocCommand rust-analyzer.openDocs<CR>")
vim.keymap.set("n", ";", "m`A;<Esc>``")
