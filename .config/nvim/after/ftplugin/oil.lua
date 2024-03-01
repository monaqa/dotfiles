vim.cmd.lcd(vim.fn.bufname():sub(7))
vim.fn.system "git rev-parse"
if vim.v.shell_error ~= 0 then
    vim.b["oil_git_status_started"] = true
end
