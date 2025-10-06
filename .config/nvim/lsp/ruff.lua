local lsp = require("monaqa.lsp")

---@type vim.lsp.ClientConfig
return {
    cmd = { lsp.mason_bin("ruff"), "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
    settings = {},
    -- ruff で hover 見ることないから
    on_attach = function(client)
        client.server_capabilities.hoverProvider = nil
    end,
}
