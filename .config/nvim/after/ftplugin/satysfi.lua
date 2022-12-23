vim.opt_local.path:append {
    "/usr/local/share/satysfi/dist/packages",
    "$HOME/.satysfi/dist/packages",
    "$HOME/.satysfi/local/packages",
}

vim.opt_local.shiftwidth = 2
vim.opt_local.suffixesadd:append {
    ".saty",
    ".satyh",
    ".satyg",
}

vim.opt_local.iskeyword:append { "43", "45", "92", "@-@" }

vim.opt_local.foldmethod = "indent"
vim.opt_local.foldnestmax = 4
vim.opt_local.foldminlines = 5
vim.opt_local.commentstring = "% %s"
