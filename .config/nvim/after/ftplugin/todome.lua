vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.foldmethod = "indent"
vim.opt_local.commentstring = "- %s"

vim.keymap.set("n", "@d", function()
    return "<Cmd>normal! I(" .. vim.fn.strftime("%Y-%m-%d", vim.fn.localtime() + 86400 * vim.v.count) .. ") <CR>"
end, { buffer = true, expr = true })

vim.b.partedit_prefix_pattern = [[\v\t+#\|]]
vim.b.partedit_filetype = "markdown"
