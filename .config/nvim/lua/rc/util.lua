local M = {}

local monaqa = require("monaqa")

---@deprecated
M.trim = monaqa.str.trim
---@deprecated
M.cmdcr = monaqa.str.cmdcr
---@deprecated
M.esc = monaqa.str.esc
---@deprecated
M.to_bool = monaqa.logic.to_bool
---@deprecated
M.ifexpr = monaqa.logic.ifexpr
---@deprecated
M.unwrap_or = monaqa.logic.unwrap_or
---@deprecated
M.autocmd_vimrc = monaqa.shorthand.autocmd_vimrc
---@deprecated
M.link_filetype = monaqa.shorthand.link_filetype
---@deprecated
M.sethl = monaqa.shorthand.sethl
---@deprecated
M.load_cwd_as_plugin = monaqa.shorthand.load_cwd_as_plugin
---@deprecated
M.is_wide_window = monaqa.window.is_wide
---@deprecated
M.split_window = monaqa.window.wise_split
---@deprecated
M.motion_autoselect = monaqa.edit.motion_autoselect

return M
