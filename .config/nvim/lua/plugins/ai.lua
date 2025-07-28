local vec = require("rc.util.vec")
local monaqa = require("monaqa")

local plugins = vec {}

plugins:push {
    "https://github.com/olimorris/codecompanion.nvim",
    cmd = {
        "CodeCompanion",
        "CodeCompanionActions",
        "CodeCompanionChat",
        "CodeCompanionCmd",
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

        local adapters = {}

        if _G.vimrc.plugin.codecompanion ~= nil then
            adapters = _G.vimrc.plugin.codecompanion.adapters
        end

        if vim.env["GEMINI_API_KEY"] ~= nil then
            adapters.gemini = function()
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

        require("codecompanion").setup {
            strategies = {
                chat = {
                    adapter = "gemini",
                    opts = {
                        completion_provider = "blink",
                    },
                },
                inline = {
                    adapter = "gemini",
                },
            },
            adapters = adapters,
            -- display = {
            --     diff = {
            --         provider = "mini_diff",
            --     },
            -- },
        }
    end,
}

return plugins:collect()
