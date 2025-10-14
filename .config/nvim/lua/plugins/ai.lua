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
        local provider = ({
            coc = "coc",
            ["nvim-lsp"] = "blink",
        })[monaqa.lsp.choose_lsp()]

        local http_adapters = {}

        if _G.vimrc.plugin.codecompanion ~= nil then
            http_adapters = _G.vimrc.plugin.codecompanion.adapters
        end

        if vim.env["GEMINI_API_KEY"] ~= nil then
            http_adapters.gemini = function()
                return require("codecompanion.adapters").extend("gemini", {
                    schema = {
                        model = {
                            default = "gemini-2.5-flash-preview-05-20",
                        },
                    },
                    env = {
                        api_key = "GEMINI_API_KEY",
                    },
                })
            end
        end

        http_adapters.gemma = function()
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
                    opts = {
                        completion_provider = "blink",
                    },
                },
                inline = { adapter = "gemini" },
            },
            adapters = { http = http_adapters },
            -- display = {
            --     diff = {
            --         provider = "mini_diff",
            --     },
            -- },
        }

        mapset.n("@a") { "<Cmd>CodeCompanionChat Toggle<CR>" }
    end,
}

return plugins:collect()
