---@type vim.lsp.Config
return {
    cmd = { require("monaqa.lsp").mason_bin("taplo"), "lsp", "stdio" },
    filetypes = { "toml" },
    root_markers = { ".taplo.toml", "taplo.toml", ".git" },
}
