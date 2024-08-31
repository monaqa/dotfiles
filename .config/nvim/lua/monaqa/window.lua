local M = {}

---横に広いウィンドウか、縦に広いウィンドウか判定する。
---ただし判定基準は割と適当。
---@param window_number number | string
---@return boolean
function M.is_wide(window_number)
    local wd = vim.fn.winwidth(window_number)
    local ht = vim.fn.winheight(window_number)
    return wd > 2.2 * ht
end

---横に広ければ鉛直に、縦に広ければ水平に分割する。
function M.wise_split()
    if M.is_wide(".") then
        vim.cmd([[vsplit]])
    else
        vim.cmd([[split]])
    end
end

return M
