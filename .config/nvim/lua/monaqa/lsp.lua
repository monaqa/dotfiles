local to_bool = require("monaqa.logic").to_bool
local M = {}

---@return '"coc"' | '"nvim-lsp"'
function M.choose_lsp()
    if to_bool(vim.fn.filereadable(vim.fn.getcwd() .. "/.use_nvim_lsp")) then
        return "nvim-lsp"
    end
    if to_bool(vim.fn.filereadable(vim.fn.getcwd() .. "/.use_coc")) then
        return "coc"
    end
    return "coc"
end

return M
