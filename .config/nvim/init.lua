---vimrc 専用の属性を格納するテーブル
_G.vimrc = {
    -- operator
    op = {},
    motion = {},
    omnifunc = {},
    state = {},
    debug = {},
    fn = {},
}

-- vimrc 用の augroup を作成しておく（どこからでも参照しうるので最初に）
vim.api.nvim_create_augroup("vimrc", { clear = true })

-- filetype の検出、
-- 詳細は `:h :filetype` または `:e $VIMRUNTIME/filetype.lua`
vim.cmd.filetype { "plugin", "indent", "on" }
vim.cmd.syntax("enable")

require("rc.plugins")

require("rc.autocmd")
require("rc.option")
require("rc.abbr")
require("rc.keymap")
require("rc.command")
require("rc.filetype")
