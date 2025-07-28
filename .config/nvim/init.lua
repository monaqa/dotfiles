---vimrc 専用の属性を格納するテーブル
_G.vimrc = {
    -- operator
    op = {},
    motion = {},
    omnifunc = {},
    state = {},
    debug = {},
    fn = {},
    plugin = {},
}

-- Workaround for bug in Neovim: https://github.com/neovim/neovim/issues/31675
-- TODO: 0.10.4 に update されたら削除
vim.hl = vim.highlight

-- vimrc 用の augroup を作成しておく（どこからでも参照しうるので最初に）
vim.api.nvim_create_augroup("vimrc", { clear = true })

-- filetype の検出、
-- 詳細は `:h :filetype` または `:e $VIMRUNTIME/filetype.lua`
-- vim.cmd.syntax("enable")

require("rc.lazy")

require("rc.autocmd")
require("rc.option")
require("rc.abbr")
require("rc.keymap")
require("rc.command")
require("rc.filetype")

if require("monaqa.lsp").choose_lsp() == "nvim-lsp" then
    vim.notify("Using nvim-lsp")
    require("rc.nvim_lsp")
end
