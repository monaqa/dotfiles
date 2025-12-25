local vec = require("rc.util.vec")
local monaqa = require("monaqa")
local mapset = monaqa.shorthand.mapset

local plugins = vec {}

plugins:push {
    "https://github.com/olimorris/codecompanion.nvim",
    cmd = {
        "CodeCompanion",
        "CodeCompanionActions",
        "CodeCompanionChat",
        "CodeCompanionCmd",
    },
    keys = {
        "@a",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        local completion_provider = ({
            coc = "coc",
            ["nvim-lsp"] = "blink",
        })[monaqa.lsp.choose_lsp()]

        local adapters = { http = {}, acp = {} }
        local default_adapter = "codex"

        if vim.env["GEMINI_API_KEY"] ~= nil then
            default_adapter = "gemini_cli"
            adapters.acp.gemini_cli = function()
                return require("codecompanion.adapters").extend("gemini_cli", {
                    defaults = {
                        auth_method = "oauth-personal", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
                    },
                    env = {
                        GEMINI_API_KEY = "GEMINI_API_KEY",
                    },
                })
            end
        end

        adapters.http.gpt_oss = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "gpt-oss",
                schema = {
                    model = {
                        default = "gpt-oss:20b",
                    },
                },
            })
        end

        adapters.acp.codex = function()
            return require("codecompanion.adapters").extend("codex", {})
        end

        require("codecompanion").setup {
            opts = {
                language = "Japanese",
            },
            strategies = {
                chat = {
                    adapter = default_adapter,
                    opts = { completion_provider = completion_provider },
                },
                inline = { adapter = default_adapter },
            },
            adapters = adapters,
            display = {
                chat = {
                    window = {
                        opts = {
                            linebreak = false,
                        },
                    },
                },
                -- diff = {
                --     provider = "mini_diff",
                -- },
            },
        }

        mapset.n("@a") { "<Cmd>CodeCompanionChat Toggle<CR>" }
    end,
}

return plugins:collect()
