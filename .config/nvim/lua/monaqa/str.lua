local M = {}

---text の前後の空白を取り除く。
---@param text string
---@return string
function M.trim(text)
    local result = text:gsub("^%s*(.-)%s*$", "%1")
    return result
end

---`SomeCmd` という文字列を `<Cmd>SomeCmd<CR>` にする。
---@param text string
---@return string
function M.cmdcr(text)
    return "<Cmd>" .. text .. "<CR>"
end

---escape sequence を付与する。
function M.esc(text)
    return "\u{1b}" .. text
end

return M
