---@type integer
local augroup = vim.api.nvim_create_augroup("vimrc", {clear = true})

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

require("rc.plugin_beforeload")
require("rc.jetpack")

-- load plugins/their settings
vim.cmd [[
  source ~/.config/nvim/scripts/plugin.vim
]]

require("rc.option")

vim.cmd [[
  " load other settings
  source ~/.config/nvim/scripts/keymap.vim
  source ~/.config/nvim/scripts/abbr.vim
  source ~/.config/nvim/scripts/autocmd.vim
  source ~/.config/nvim/scripts/command.vim

  source ~/.config/nvim/scripts/filetype.vim

  filetype plugin indent on
  syntax enable
]]
