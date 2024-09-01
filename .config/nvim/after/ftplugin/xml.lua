local mapset = require("monaqa").shorthand.mapset_local
local create_cmd = require("monaqa").shorthand.create_cmd_local

vim.opt_local.shiftwidth = 2

mapset.i("</") { "</<C-x><C-o>" }

create_cmd("Tidy") {
    desc = [[tidy コマンドによる整形を適用する]],
    function()
        vim.cmd([[
        %!tidy --indent-cdata true -xml -utf8 2>/dev/null
        ]])
    end,
}
