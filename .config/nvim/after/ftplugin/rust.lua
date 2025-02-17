local mapset = require("monaqa.shorthand").mapset_local
local opt = vim.opt_local

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.formatoptions:remove { "r", "o" }

mapset.n(";") { "m`A;<Esc>``" }
