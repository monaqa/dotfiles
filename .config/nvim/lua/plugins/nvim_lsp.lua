local monaqa = require("monaqa")
local mapset = monaqa.shorthand.mapset
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

local ensure_installed = {
    "jsonls",
    "lua_ls",
    "pyright",
    "rust_analyzer",
    "svelte",
    "tinymist",
    "ts_ls",
    "yamlls",
}

plugins:push {
    "https://github.com/williamboman/mason-lspconfig.nvim",
    config = function()
        require("mason-lspconfig").setup {
            ensure_installed = ensure_installed,
        }
    end,
}

-- plugins:push {
--     "https://github.com/j-hui/fidget.nvim",
-- }

-- nvim_lsp
plugins:push {
    "https://github.com/neovim/nvim-lspconfig",
    config = function()
        for _, ls in ipairs(ensure_installed) do
            require("lspconfig")[ls].setup {}
        end
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
    version = "v0.11.0",
    config = function()
        require("blink.cmp").setup {
            keymap = {
                ["<Tab>"] = {
                    -- ---@param cmp blink.cmp.CompletionWindow
                    -- function(cmp)
                    --     -- _G.memo = { cmp = cmp, items = cmp.windows.autocomplete.items }
                    --     local n_items = #cmp.windows.autocomplete.items
                    --     if n_items == 1 then
                    --         cmp.accept()
                    --     end
                    -- end,
                    "select_next",
                    function(cmp)
                        if #vim.trim(vim.fn.getline(".")) == 0 then
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

                cmdline = {
                    ["<Tab>"] = {
                        "select_next",
                        "show",
                        "fallback",
                    },
                    ["<S-Tab>"] = { "select_prev", "fallback" },
                },
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
                default = { "lsp", "path", "snippets", "buffer" },
            },

            completion = {
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
            },
        }

        mapset.i("<S-Tab>") { "<C-h>" }
    end,
}

plugins:push {
    "https://github.com/echasnovski/mini.snippets",
    version = "*",
    config = function()
        local gen_loader = require("mini.snippets").gen_loader
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

-- return {}
