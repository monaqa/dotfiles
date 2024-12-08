local shorthand = require("monaqa").shorthand
local logic = require("monaqa").logic
local autocmd_vimrc = shorthand.autocmd_vimrc
local mapset = shorthand.mapset

-- autocmd_vimrc("FileType") {
--     pattern = "typst",
--     callback = function()
--         vim.lsp.start {
--             name = "tinymist",
--             cmd = { "tinymist", "lsp" },
--         }
--     end,
-- }

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

mapset.i("<Tab>") {
    desc = [[Neovim 本体の補完があったらそれを使う]],
    expr = true,
    function()
        if logic.to_bool(vim.fn.pumvisible()) then
            return "<C-n>"
        else
            return "<Tab>"
        end
    end,
}

mapset.i("<S-Tab>") {
    desc = [[Neovim 本体の補完があったらそれを使う]],
    expr = true,
    function()
        if logic.to_bool(vim.fn.pumvisible()) then
            return "<C-p>"
        else
            return "<S-Tab>"
        end
    end,
}

autocmd_vimrc("LspAttach") {
    callback = function(args)
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

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
    end,
}

autocmd_vimrc("BufWritePre") {
    callback = function()
        local ftypes = { "rust", "lua" }
        if vim.list_contains(ftypes, vim.bo.filetype) then
            -- vim.cmd.mkview()
            vim.lsp.buf.format { async = false }
            -- vim.cmd.loadview()
        end
    end,
}
