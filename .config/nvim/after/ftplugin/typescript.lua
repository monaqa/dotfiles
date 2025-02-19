local mapset = require("monaqa.shorthand").mapset_local
local opt = vim.opt_local

opt.shiftwidth = 2
opt.commentstring = "// %s"

mapset.ia("if") {
    desc = [[JS の if のカッコを忘れがちなので]],
    expr = true,
    function()
        vim.fn.getchar()
        return "if ()<Left>"
    end,
}
