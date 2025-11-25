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

        if vim.env["GEMINI_API_KEY"] ~= nil then
            adapters.acp.gemini_cli = function()
                return require("codecompanion.adapters").extend("gemini_cli", {
                    defaults = {
                        auth_method = "oauth-personal", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
                    },
                })
            end
        end

        if vim.env["OPENAI_API_KEY"] ~= nil then
            adapters.acp.codex = function()
                return require("codecompanion.adapters").extend("codex", {
                    defaults = {
                        auth_method = "openai-api-key",
                    },
                    env = {
                        OPENAI_API_KEY = vim.env["OPENAI_API_KEY"],
                    },
                })
            end
        end

        adapters.http.gemma = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "gemma",
                schema = {
                    model = {
                        default = "gemma3n:e2b",
                    },
                },
            })
        end

        require("codecompanion").setup {
            opts = {
                language = "Japanese",
            },
            strategies = {
                chat = {
                    adapter = "gemini",
                    opts = { completion_provider = completion_provider },
                },
                inline = { adapter = "gemini" },
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
