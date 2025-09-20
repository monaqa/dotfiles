---@type vim.lsp.Config
return {
    cmd = { require("monaqa.lsp").mason_bin("tombi"), "lsp" },
    filetypes = { "toml" },
    root_markers = { "tombi.toml", "pyproject.toml", ".git" },
}
