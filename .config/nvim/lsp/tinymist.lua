---@brief
---
--- https://github.com/Myriad-Dreamin/tinymist

local lsp = require("monaqa.lsp")

---@type vim.lsp.Config
return {
    cmd = { lsp.mason_bin("tinymist") },
    -- cmd = { "tinymist" },
    filetypes = { "typst" },
    root_markers = { ".git" },
}
