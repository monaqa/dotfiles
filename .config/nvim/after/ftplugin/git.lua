local opt = vim.opt_local

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
