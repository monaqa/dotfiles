---@type integer
local augroup = vim.api.nvim_create_augroup("vimrc", { clear = true })
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

-- 正直このあたりよくわかってません
-- https://wiredool.hatenadiary.org/entry/20120618/1340019962
vim.cmd [[
  filetype plugin indent on
  syntax enable
]]

require "rc.plugins"

require("rc.diary").setup()

require "rc.autocmd"
require "rc.option"
require "rc.abbr"
require "rc.keymap"
require "rc.command"
require "rc.filetype"
