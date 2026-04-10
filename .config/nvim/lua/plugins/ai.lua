local vec = require("rc.util.vec")
local monaqa = require("monaqa")
local mapset = monaqa.shorthand.mapset
local create_cmd = monaqa.shorthand.create_cmd

local plugins = vec {}

plugins:push {
    "https://github.com/olimorris/codecompanion.nvim",
    cmd = {
        "CodeCompanion",
        "CodeCompanionActions",
        "CodeCompanionChat",
        "CodeCompanionCmd",
        "CodeCompanionLoad",
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
                    commands = {
                        -- pro が使えなくて動作が止まるので書いておく
                        default = {
                            "gemini",
                            "--acp",
                            "--model",
                            "gemini-3-flash-preview",
                        },
                    },
                    defaults = {
                        auth_method = "oauth-personal", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
                    },
                    env = {
                        GEMINI_API_KEY = "GEMINI_API_KEY",
                    },
                })
            end
        end

        adapters.http.ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "ollama",
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
            interactions = {
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

        -- thanks to https://gist.github.com/itsfrank/942780f88472a14c9cbb3169012a3328
        -- create a folder to store our chats
        local Path = require("plenary.path")
        local data_path = vim.fn.stdpath("data")
        local save_folder = Path:new(data_path, "cc_saves")
        if not save_folder:exists() then
            save_folder:mkdir { parents = true }
        end

        -- telescope picker for our saved chats
        create_cmd("CodeCompanionLoad") {
            function()
                local t_builtin = require("telescope.builtin")
                local t_actions = require("telescope.actions")
                local t_action_state = require("telescope.actions.state")

                local function start_picker()
                    t_builtin.find_files {
                        prompt_title = "Saved CodeCompanion Chats | <c-d>: delete",
                        cwd = save_folder:absolute(),
                        attach_mappings = function(_, map)
                            map("i", "<c-d>", function(prompt_bufnr)
                                local selection = t_action_state.get_selected_entry()
                                local filepath = selection.path or selection.filename
                                os.remove(filepath)
                                t_actions.close(prompt_bufnr)
                                start_picker()
                            end)
                            return true
                        end,
                    }
                end
                start_picker()
            end,
        }
    end,
}

return plugins:collect()
