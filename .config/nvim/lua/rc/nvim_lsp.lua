-- vim:fdm=marker:fmr=--\ Section,■■

local shorthand = require("monaqa").shorthand
local logic = require("monaqa").logic
local autocmd_vimrc = shorthand.autocmd_vimrc
local mapset = shorthand.mapset

-- Section1 common config
vim.lsp.config("*", {})

vim.lsp.enable { "pyright", "ruff" }

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

-- Section1 options

-- Section1 keymaps
-- mapset.i("<Tab>") {
--     desc = [[補完の次を選択]],
--     expr = true,
--     function()
--         if vim.fn.pumvisible() then
--             return "<C-n>"
--         end
--         return "<Tab>"
--     end,
-- }
--
-- mapset.i("<S-Tab>") {
--     desc = [[補完の前を選択]],
--     expr = true,
--     function()
--         if vim.fn.pumvisible() then
--             return "<C-p>"
--         end
--         return "<S-Tab>"
--     end,
-- }

mapset.n("gd") {
    desc = [[LSP による定義ジャンプ]],
    function()
        vim.lsp.buf.definition()
    end,
}

mapset.n("t") { "<Nop>" }

mapset.n("tr") {
    desc = [[LSP による参照ジャンプ]],
    function()
        vim.lsp.buf.references()
    end,
}

mapset.n("ta") {
    desc = [[LSP によるコードアクション]],
    function()
        vim.lsp.buf.code_action()
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
                vim.diagnostic.jump { count = 1, float = true, severity = severity }
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
                vim.diagnostic.jump { count = -1, float = true, severity = severity }
                return
            end
        end
    end,
}

mapset.n("g)") {
    function()
        vim.diagnostic.jump { count = 1, float = true }
    end,
    desc = [[次の diagnostic に飛ぶ]],
}
mapset.n("g(") {
    function()
        vim.diagnostic.jump { count = -1, float = true }
    end,
    desc = [[前の diagnostic に飛ぶ]],
}

-- Section1 autocmds
autocmd_vimrc("LspAttach") {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end

        -- if client:supports_method("textDocument/completion") then
        --     -- Optional: trigger autocompletion on EVERY keypress. May be slow!
        --     local chars = {}
        --     for i = 32, 126 do -- from <Space> to ~
        --         table.insert(chars, string.char(i))
        --     end
        --     client.server_capabilities.completionProvider.triggerCharacters = chars
        --
        --     vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        -- end

        client.server_capabilities.semanticTokensProvider = nil
    end,
}

autocmd_vimrc("BufWritePre") {
    desc = [[フォーマットの実施]],
    callback = function()
        if vim.tbl_contains({ "json" }, vim.b.filetype) then
            return
        end

        local client = vim.iter(vim.lsp.get_clients { bufnr = 0 }):find(
            ---@param client vim.lsp.Client
            function(client)
                return client.supports_method("textDocument/formatting")
            end
        )
        if client == nil then
            return
        end

        vim.lsp.buf.format {
            async = false,
            timeout_ms = 2000,
        }
    end,
}
