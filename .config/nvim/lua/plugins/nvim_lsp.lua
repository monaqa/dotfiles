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
    "https://github.com/williamboman/mason-lspconfig.nvim",
    dependencies = {
        "https://github.com/neovim/nvim-lspconfig",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local function is_node_dir()
            return lspconfig.util.root_pattern("package.json")(vim.fn.getcwd())
        end
        require("mason-lspconfig").setup {
            ensure_installed = {
                "denols",
                "jsonls",
                "lua_ls",
                "pyright",
                "ruff",
                "rust_analyzer",
                "svelte",
                "tinymist",
                "ts_ls",
                "yamlls",
            },
            automatic_installation = true,
        }
        require("mason-lspconfig").setup_handlers {
            function(server_name) -- default handler (optional)
                lspconfig[server_name].setup {}
            end,
            ts_ls = function()
                lspconfig.ts_ls.setup {
                    on_attach = function(client)
                        if not is_node_dir() then
                            client.stop()
                        end
                    end,
                }
            end,
            denols = function()
                lspconfig.denols.setup {
                    on_attach = function(client)
                        if is_node_dir() then
                            client.stop()
                        end
                    end,
                }
            end,
            rust_analyzer = function()
                lspconfig.rust_analyzer.setup {
                    settings = {
                        ["rust-analyzer"] = {
                            check = {
                                command = "clippy",
                            },
                            completion = {
                                privateEditable = {
                                    enable = true,
                                },
                                callable = {
                                    snippets = "fill_arguments",
                                },
                            },
                        },
                    },
                }
            end,
        }
    end,
}

-- plugins:push {
--     "https://github.com/j-hui/fidget.nvim",
-- }

-- nvim_lsp
plugins:push {
    "https://github.com/neovim/nvim-lspconfig",
    -- config = function()
    --     for _, ls in ipairs(ensure_installed) do
    --         require("lspconfig")[ls].setup {}
    --     end
    -- end,
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

-- plugins:push {
--     "https://github.com/Bekaboo/dropbar.nvim",
--     config = function()
--         require("dropbar").setup {
--             icons = {
--                 enable = true,
--             },
--             ui = {
--                 bar = {
--                     separator = " ",
--                     extends = "…",
--                 },
--                 menu = {
--                     separator = " ",
--                     indicator = " ",
--                 },
--             },
--         }
--     end,
-- }

plugins:push {
    "https://github.com/ray-x/lsp_signature.nvim",
    config = function()
        require("lsp_signature").setup {}
    end,
}

-- plugins:push {
--     "https://github.com/nvimdev/lspsaga.nvim",
--     config = function()
--         require("lspsaga").setup {
--             breadcrumb = { enable = false },
--             code_action = {
--                 keys = { quit = "<Esc>" },
--             },
--             lightbulb = {
--                 sign = false,
--                 enable_in_insert = false,
--             },
--         }
--
--         mapset.n("ta") {
--             desc = [[Code action using lspsaga]],
--             "<Cmd>Lspsaga code_action<CR>",
--         }
--     end,
-- }

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
                    "select_next",
                    function(cmp)
                        if #vim.trim(vim.fn.getline(".")) == 0 then
                            -- インデント以外なにもない場合はインデントの調整がしたい事が多い
                            return false
                        end
                        if logic.to_bool(vim.fn.pumvisible()) then
                            -- Neovim 本体の補完も選べるようにしたい
                            return false
                        end
                        cmp.show()
                        return true
                    end,
                    "fallback",
                },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<CR>"] = { "accept", "fallback" },

                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },

                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },

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
                        -- enabled = function()
                        --     if (vim.fn.getcmdtype() .. vim.fn.getcmdline()):match("^:=") then
                        --         return false
                        --     end
                        --     if vim.fn.getcmdtype() == "@" then
                        --         return false
                        --     end
                        --     -- range 指定が消えてしまう不具合あり
                        --     if (vim.fn.getcmdtype() .. vim.fn.getcmdline()):match("'") then
                        --         return false
                        --     end
                        --     if (vim.fn.getcmdtype() .. vim.fn.getcmdline()):match("^:[%%0-9,'<>%-]*!") then
                        --         return false
                        --     end
                        --     return true
                        -- end,
                    },
                },
            },

            fuzzy = {
                sorts = {
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
            },

            cmdline = {
                sources = function()
                    local type = vim.fn.getcmdtype()
                    -- if vim.startswith(type .. vim.fn.getcmdline(), ":=") then
                    --     return {}
                    -- end
                    -- Search forward and backward
                    if type == "/" or type == "?" or type == "@" then
                        return { "buffer" }
                    end
                    -- Commands
                    if type == ":" then
                        return { "cmdline" }
                    end
                    return {}
                end,
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

return plugins
    :map(function(spec)
        spec.cond = function()
            return monaqa.lsp.choose_lsp() == "nvim-lsp"
        end
        return spec
    end)
    :collect()
