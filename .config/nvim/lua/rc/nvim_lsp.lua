-- vim:fdm=marker:fmr=--\ Section,■■

local shorthand = require("monaqa").shorthand
local logic = require("monaqa").logic
local create_cmd = shorthand.create_cmd
local autocmd_vimrc = shorthand.autocmd_vimrc
local mapset = shorthand.mapset

local lsp_logdir = vim.fs.joinpath(vim.fn.stdpath("log"), "lsp")
if not vim.uv.fs_stat(lsp_logdir) then
    vim.fn.mkdir(lsp_logdir, "p")
end
vim.lsp.log._set_filename(vim.fs.joinpath(lsp_logdir, vim.fn.strftime("%Y-%m-%d") .. ".log"))

-- Section1 common config
vim.lsp.config("*", {
    -- on_attach = function(client, bufnr)
    --     vim.lsp.completion.enable(true, client.id, bufnr, {
    --         autotrigger = true,
    --     })
    -- end,
})

vim.lsp.enable {
    "astro",
    "basedpyright",
    "biome",
    -- "deno",  -- 複雑なので autocmd で制御
    "fish",
    "jsonls",
    "lua_ls",
    "loon",
    "ruff",
    "rust_analyzer",
    "svelte",
    "taplo",
    "tinymist",
    -- "ts_ls",  -- 複雑なので autocmd で制御
    "yamlls",
}

-- Thanks to Atusy
-- https://blog.atusy.net/2025/09/03/node-deno-decision-with-monorepo-support/
autocmd_vimrc("FileType") {
    pattern = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    callback = function()
        local server_name
        if vim.fn.findfile("package.json", ".;") == "" then
            server_name = "deno"
        else
            server_name = "ts_ls"
        end
        vim.lsp.start(vim.lsp.config[server_name])
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

-- Section1 options

-- vim.opt.completeopt = {
--     "longest",
--     "menuone",
--     "noselect",
--     "popup",
--     "preview",
-- }

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

-- 標準の signature help は使わない
vim.keymap.del("i", "<C-s>")

mapset.n("t") { "<Nop>" }

mapset.n("tr") {
    desc = [[LSP による参照ジャンプ]],
    function()
        vim.lsp.buf.references()
    end,
}

mapset.n("ty") {
    desc = [[LSP による型定義ジャンプ]],
    function()
        vim.lsp.buf.type_definition()
    end,
}

mapset.nx("ta") {
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

---@param focusable boolean
local function float_opts(focusable)
    if focusable == nil then
        focusable = false
    end
    return {
        focusable = focusable,
        focus = true,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
    }
end

-- mapset.n("K") {
--     desc = [[nvim-lsp による hover]],
--     function()
--         vim.lsp.buf.hover(float_opts(true))
--     end,
-- }

mapset.n(")") {
    desc = [[最も深刻な次の diagnostic に飛ぶ]],
    function()
        for _, severity in ipairs { "ERROR", "WARN", "INFO", "HINT" } do
            local diag = vim.diagnostic.get_next { severity = severity }
            if diag ~= nil then
                vim.diagnostic.jump { count = 1, float = float_opts(false), severity = severity }
                return
            end
        end

        vim.cmd.normal("]S")
    end,
}
mapset.n("(") {
    desc = [[最も深刻な前の diagnostic に飛ぶ]],
    function()
        for _, severity in ipairs { "ERROR", "WARN", "INFO", "HINT" } do
            local diag = vim.diagnostic.get_prev { severity = severity }
            if diag ~= nil then
                vim.diagnostic.jump { count = -1, float = float_opts(false), severity = severity }
                return
            end
        end

        vim.cmd.normal("[S")
    end,
}

mapset.n("g)") {
    function()
        vim.diagnostic.jump { count = 1, float = float_opts(false) }
    end,
    desc = [[次の diagnostic に飛ぶ]],
}
mapset.n("g(") {
    function()
        vim.diagnostic.jump { count = -1, float = float_opts(false) }
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
        if
            vim.tbl_contains({
                "json",
                "oil",
                "toml",
                "yaml",
            }, vim.bo.filetype)
        then
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

-- autocmd_vimrc("CursorHold") {
--     desc = [[カーソル下に diagnostics があれば表示する]],
--     callback = function()
--         vim.diagnostic.open_float(float_opts(false))
--     end,
-- }

create_cmd("LspInfo") {
    desc = [[Alias to `:checkhealth vim.lsp`.]],
    "checkhealth vim.lsp",
}

create_cmd("LspLog") {
    desc = [[Opens the Nvim LSP client log.]],
    function()
        vim.cmd(string.format("tabnew %s", vim.lsp.log.get_filename()))
    end,
}

create_cmd("LspFormat") {
    desc = [[Format current buffer with LSP.]],
    function()
        vim.lsp.buf.format {
            async = false,
            timeout_ms = 2000,
        }
    end,
}

local complete_client = function(arg)
    return vim.iter(vim.lsp.get_clients())
        :map(function(client)
            return client.name
        end)
        :filter(function(name)
            return name:sub(1, #arg) == arg
        end)
        :totable()
end

create_cmd("LspRestart") {
    desc = "Restart the given client",
    nargs = "?",
    complete = complete_client,
    function(info)
        local clients = info.fargs

        -- Default to restarting all active servers
        if #clients == 0 then
            clients = vim.iter(vim.lsp.get_clients())
                :map(function(client)
                    return client.name
                end)
                :totable()
        end

        for _, name in ipairs(clients) do
            if vim.lsp.config[name] == nil then
                vim.notify(("Invalid server name '%s'"):format(name))
            else
                vim.lsp.enable(name, false)
            end
        end

        local timer = assert(vim.uv.new_timer())
        timer:start(500, 0, function()
            for _, name in ipairs(clients) do
                vim.schedule_wrap(function(x)
                    vim.lsp.enable(x)
                end)(name)
            end
        end)
    end,
}
