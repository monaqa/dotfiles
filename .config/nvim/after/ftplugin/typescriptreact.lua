local mapset = require("monaqa.shorthand").mapset_local
vim.opt_local.shiftwidth = 2

mapset.ia("if") {
    desc = [[JS の if のカッコを忘れがちなので]],
    expr = true,
    function()
        vim.fn.getchar()
        return "if ()<Left>"
    end,
}
