local lsp = require("monaqa.lsp")

return {
    cmd = { lsp.mason_bin("ruff"), "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
    settings = {},
}
