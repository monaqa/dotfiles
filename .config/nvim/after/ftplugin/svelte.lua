local monaqa = require("monaqa")
local mapset = monaqa.shorthand.mapset_local
local opt = vim.opt_local

vim.opt_local.shiftwidth = 2
vim.opt_local.omnifunc = "htmlcomplete#CompleteTags"

mapset.i("</") { "</<C-x><C-o>" }

opt.comments:remove("n:>")
