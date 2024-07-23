vim.opt_local.number = false

vim.fn.system(([[cd "%s";git rev-parse]]):format(vim.fn.bufname():sub(7)))
if vim.v.shell_error ~= 0 then
    vim.b["oil_git_status_started"] = true
end

vim.keymap.set("n", "<C-l>", "<C-l><Cmd>e<CR>", { buffer = true })
