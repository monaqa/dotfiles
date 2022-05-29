---@type integer
local augroup = vim.api.nvim_create_augroup("vimrc", {clear = true})
---vimrc 専用の属性を格納するテーブル
_G.vimrc = {
    -- operator
    op = {}
}

local function register_autocmd(event, opts)
    opts["augroup"] = augroup
    local id = vim.api.nvim_create_autocmd(event, opts)
end


-- 正直このあたりよくわかってません
-- https://wiredool.hatenadiary.org/entry/20120618/1340019962
vim.cmd [[
  filetype off
  filetype plugin indent off
]]

require("rc.plugin")

-- load plugins/their settings
vim.cmd [[
  source ~/.config/nvim/scripts/plugin.vim
]]

require("rc.autocmd")
require("rc.option")
require("rc.abbr")
require("rc.keymap")
require("rc.command")
require("rc.filetype")

vim.cmd [[
  " load other settings
  source ~/.config/nvim/scripts/abbr.vim

  filetype plugin indent on
  syntax enable
]]
