---@type vim.lsp.Config
return {
    cmd = { require("monaqa.lsp").mason_bin("vscode-json-language-server"), "--stdio" },
    filetypes = { "json", "jsonc" },
    init_options = {
        provideFormatter = true,
    },
    root_markers = { ".git" },
}
