local monaqa = require("monaqa")
local mapset = monaqa.shorthand.mapset
local logic = monaqa.logic
local vec = require("rc.util.vec")

local plugins = vec {}

plugins:push {
    "https://github.com/williamboman/mason.nvim",
    config = function()
        require("mason").setup {
            ui = {
                keymaps = {
                    apply_language_filter = "g/",
                },
            },
        }
    end,
}

plugins:push {
    "https://github.com/folke/lazydev.nvim",
    config = function()
        require("lazydev").setup {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                -- { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                "~/.config/nvim/",
            },
        }
        -- vim.notify("lazydev setup")
    end,
}

plugins:push {
    "https://github.com/ray-x/lsp_signature.nvim",
    config = function()
        require("lsp_signature").setup {}
    end,
}

plugins:push {
    "https://github.com/rachartier/tiny-code-action.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "folke/snacks.nvim" },
    },
    event = "LspAttach",
    config = function()
        require("tiny-code-action").setup {
            backend = "delta",
            picker = "snacks",
            backend_opts = {
                delta = {
                    args = {
                        "--line-numbers",
                    },
                },
            },
        }

        mapset.n("ta") {
            function()
                require("tiny-code-action").code_action {}
            end,
        }
    end,
}

plugins:push {
    "https://github.com/Saghen/blink.cmp",
    dependencies = {
        -- "https://github.com/rafamadriz/friendly-snippets",
        "https://github.com/echasnovski/mini.snippets",
    },
    version = "*",
    config = function()
        require("blink.cmp").setup {
            keymap = {
                ["<Tab>"] = {
                    function(cmp)
                        if #vim.trim(vim.fn.getline(".")) == 0 then
                            -- インデント以外なにもない場合はインデントの調整がしたい事が多い
                            return false
                        end
                        if logic.to_bool(vim.fn.pumvisible()) then
                            cmp.hide()
                            -- Neovim 本体の補完が出ていたらそちらを優先
                            return false
                        end
                        if cmp.is_visible() then
                            cmp.select_next()
                            return true
                        end
                        cmp.show()
                        return true
                    end,
                    -- "select_next",
                    "fallback",
                },
                ["<S-Tab>"] = {
                    function(cmp)
                        if logic.to_bool(vim.fn.pumvisible()) then
                            cmp.hide()
                            -- Neovim 本体の補完が出ていたらそちらを優先
                            return false
                        end
                        cmp.select_prev()
                        return true
                    end,
                    "fallback",
                },
                ["<CR>"] = { "accept", "fallback" },

                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },

                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                ["<C-y>"] = { "fallback" },

                -- cmdline = {},
                -- cmdline = {
                --     ["<Tab>"] = {
                --         "select_next",
                --         "show",
                --         "fallback",
                --     },
                --     ["<S-Tab>"] = { "select_prev", "fallback" },
                -- },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            snippets = { preset = "mini_snippets" },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = function()
                    return { "snippets", "path", "lsp", "buffer" }
                end,
                -- default = { "snippets", "path", "lsp" },
                providers = {
                    cmdline = {
                        -- ignores cmdline completions when executing shell commands
                        enabled = true,
                    },
                },
            },

            fuzzy = {
                -- implementation = "disabled",
                sorts = {
                    "exact",
                    function(a, b)
                        local source_priority = {
                            lsp = 4,
                            snippets = 3,
                            path = 2,
                            buffer = 1,
                        }
                        local a_priority = source_priority[a.source_id]
                        local b_priority = source_priority[b.source_id]
                        if a_priority ~= b_priority then
                            return a_priority > b_priority
                        end
                    end,
                    -- defaults
                    "score",
                    "sort_text",
                },
            },

            completion = {
                accept = {
                    dot_repeat = true,
                    auto_brackets = {
                        enabled = true,
                        override_brackets_for_filetypes = { "rust" },
                        force_allow_filetypes = { "rust" },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                },
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = true,
                    },
                },
                trigger = {
                    show_on_keyword = true,
                },
                menu = {
                    draw = {
                        columns = {
                            { "kind_icon" },
                            { "label", "label_description", gap = 1 },
                            { "kind" },
                        },
                        components = {
                            kind = {
                                ellipsis = false,
                                width = { fill = true },
                                text = function(ctx)
                                    return ctx.kind
                                    -- return ctx.kind:sub(1, 4)
                                end,
                                highlight = function(ctx)
                                    return "@comment"
                                end,
                            },
                        },
                    },
                },
            },

            cmdline = {
                enabled = false,
                -- sources = function()
                --     local type = vim.fn.getcmdtype()
                --     if type == "/" or type == "?" or type == "@" then
                --         return { "buffer" }
                --     end
                --     -- Commands
                --     if type == ":" then
                --         return { "cmdline" }
                --     end
                --     return {}
                -- end,
            },
        }

        mapset.i("<S-Tab>") {
            desc = [[pumvisible() なときは次の候補に移動。それ以外は <C-h>]],
            expr = true,
            function()
                if logic.to_bool(vim.fn.pumvisible()) then
                    return "<C-p>"
                else
                    return "<C-h>"
                end
            end,
        }
        mapset.i("<Tab>") {
            desc = [[pumvisible() なときは次の候補に移動。それ以外は <Tab>]],
            expr = true,
            function()
                if logic.to_bool(vim.fn.pumvisible()) then
                    return "<C-n>"
                else
                    return "<Tab>"
                end
            end,
        }
    end,
}

plugins:push {
    "https://github.com/echasnovski/mini.snippets",
    version = "*",
    config = function()
        local mini_snippets = require("mini.snippets")
        local gen_loader = mini_snippets.gen_loader
        require("mini.snippets").setup {
            snippets = {
                -- Load custom file with global snippets first (adjust for Windows)
                gen_loader.from_file("~/.config/nvim/snippets/global.lua"),

                -- Load snippets based on current language by reading files from
                -- "snippets/" subdirectories from 'runtimepath' directories.
                gen_loader.from_lang(),
            },
            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                -- Interact with default `expand.insert` session.
                -- Created for the duration of active session(s)
                jump_next = "<C-g><C-j>",
                jump_prev = "<C-g><C-k>",
                stop = "<C-c>",
            },
            expand = {
                insert = function(snippet, opts)
                    monaqa.edit.with_env {
                        TODAY = vim.fn.strftime("%Y/%m/%d"),
                    }(function()
                        mini_snippets.default_insert(snippet, opts)
                    end)
                end,
            },
        }
    end,
}

plugins:push {
    "https://github.com/b0o/SchemaStore.nvim",
}

plugins:push {
    "https://github.com/lewis6991/hover.nvim",
    config = function()
        require("hover").config {
            --- List of modules names to load as providers.
            --- @type (string|Hover.Config.Provider)[]
            providers = {
                "hover.providers.lsp",
                { module = "hover.providers.diagnostic", priority = 950 },
                -- "hover.providers.dap",
                "hover.providers.man",
                -- "hover.providers.dictionary",
                -- Optional, disabled by default:
                "hover.providers.gh",
                "hover.providers.gh_user",
                -- 'hover.providers.jira',
                "hover.providers.fold_preview",
                "hover.providers.highlight",
            },
            preview_opts = {
                border = "single",
            },
            -- Whether the contents of a currently open hover window should be moved
            -- to a :h preview-window when pressing the hover keymap.
            preview_window = false,
            title = true,
            mouse_providers = {
                "hover.providers.lsp",
            },
            mouse_delay = 100,
        }

        mapset.n("K") {
            desc = [[hover.nvim (open)]],
            function()
                require("hover").open {
                    providers = {
                        "hover.providers.lsp",
                        "hover.providers.diagnostic",
                        "hover.providers.man",
                        "hover.providers.gh",
                        "hover.providers.gh_user",
                        "hover.providers.fold_preview",
                    },
                }
            end,
        }
        mapset.n("gK") {
            desc = [[hover.nvim (enter)]],
            function()
                require("hover").enter()
            end,
        }
        mapset.n("ts") {
            desc = [[hover.nvim (open highlight)]],
            function()
                require("hover").open {
                    providers = { "hover.providers.highlight" },
                    title = false,
                }
            end,
        }
    end,
}

plugins:push {
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-mini/mini.icons",
    },
    config = function()
        require("render-markdown").setup {
            enabled = true,
            render_modes = { "n" },
            ignore = function(buf)
                local buftype = vim.bo[buf].buftype
                if buftype == "nofile" then
                    return false
                end
                return true
            end,
        }
    end,
}

return plugins
    :map(function(spec)
        spec.cond = function()
            return monaqa.lsp.choose_lsp() == "nvim-lsp"
        end
        return spec
    end)
    :collect()
