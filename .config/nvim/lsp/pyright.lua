local lsp = require("monaqa.lsp")
return {
    cmd = { lsp.mason_bin("pyright-langserver"), "--stdio" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
    },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
            },
        },
    },
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
            client:exec_cmd {
                command = "pyright.organizeimports",
                arguments = { vim.uri_from_bufnr(bufnr) },
            }
        end, {
            desc = "Organize Imports",
        })
    end,
}
