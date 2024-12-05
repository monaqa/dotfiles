local shorthand = require("monaqa").shorthand
local autocmd_vimrc = shorthand.autocmd_vimrc
local mapset = shorthand.mapset

autocmd_vimrc("FileType") {
    pattern = "typst",
    callback = function()
        vim.lsp.start {
            name = "tinymist",
            cmd = { "tinymist", "lsp" },
        }
    end,
}

vim.fn.sign_define(
    "DiagnosticSignError",
    { text = "🚨", numhl = "DiagnosticSignError", texthl = "DiagnosticSignError" }
)
vim.fn.sign_define("DiagnosticSignWarn", { text = "" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "" })
vim.fn.sign_define("DiagnosticSignHint", { text = "" })

vim.diagnostic.config {
    virtual_text = {
        prefix = "", -- Could be '●', '▎', 'x'
    },
}

autocmd_vimrc("LspAttach") {
    callback = function()
        mapset.n("gd") {
            desc = [[LSP による定義ジャンプ]],
            function()
                vim.lsp.buf.definition()
            end,
        }

        mapset.n("tr") {
            desc = [[LSP による参照ジャンプ]],
            function()
                vim.lsp.buf.references()
            end,
        }

        mapset.n("tn") {
            desc = [[LSP によるリネーム]],
            function()
                vim.lsp.buf.rename()
            end,
        }

        mapset.n(")") {
            desc = [[最も深刻な次の diagnostic に飛ぶ]],
            function()
                for _, severity in ipairs { "ERROR", "WARN", "INFO", "HINT" } do
                    local diag = vim.diagnostic.get_next { severity = severity }
                    if diag ~= nil then
                        vim.diagnostic.goto_next { severity = severity }
                        return
                    end
                end
            end,
        }
        mapset.n("(") {
            desc = [[最も深刻な前の diagnostic に飛ぶ]],
            function()
                for _, severity in ipairs { "ERROR", "WARN", "INFO", "HINT" } do
                    local diag = vim.diagnostic.get_prev { severity = severity }
                    if diag ~= nil then
                        vim.diagnostic.goto_prev { severity = severity }
                        return
                    end
                end
            end,
        }

        mapset.n("g)") { vim.diagnostic.goto_next, desc = [[次の diagnostic に飛ぶ]] }
        mapset.n("g(") { vim.diagnostic.goto_prev, desc = [[前の diagnostic に飛ぶ]] }
    end,
}
