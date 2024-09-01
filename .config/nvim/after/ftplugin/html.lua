local mapset = require("monaqa").shorthand.mapset_local

vim.opt_local.shiftwidth = 2

mapset.i("</") { "</<C-x><C-o>" }
