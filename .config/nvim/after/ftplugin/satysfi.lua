local mapset = require("monaqa").shorthand.mapset_local

vim.opt_local.path:append {
    ".",
    "/usr/local/share/satysfi/dist/packages",
    vim.fn.expand("~/.satysfi/dist/packages"),
    vim.fn.expand("~/.satysfi/local/packages"),
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
vim.opt_local.indentkeys:append {
    "0*",
}

mapset.n("@o") { ":!open %:r.pdf<CR>" }
mapset.n("@q") { ":!satysfi %<CR>" }
mapset.n("@Q") {
    ":!satysfi --debug-show-bbox --debug-show-space --debug-show-block-bbox --debug-show-block-space --debug-show-overfull %<CR>",
}
