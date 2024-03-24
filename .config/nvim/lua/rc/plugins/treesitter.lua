local util = require("rc.util")
local vec = require("rc.util.vec")

-- local t = vim.treesitter

local plugins = vec {}

local function cond_dev(plug_path)
    if vim.fn.getcwd() == vim.fn.expand("~/ghq/github.com/") .. plug_path then
        util.print_error("WARNING: " .. plug_path .. " is not loaded.", "WarningMsg")
        return false
    end
    return true
end

-- tree-sitter
plugins:push {
    "https://github.com/nvim-treesitter/nvim-treesitter",
    lazy = false,
    keys = {
        {
            "v",
            function()
                if vim.fn.mode() == "v" then
                    return ":lua require'nvim-treesitter.incremental_selection'.node_incremental()<CR>"
                else
                    return "v"
                end
            end,
            mode = "x",
            expr = true,
        },
        {
            "<C-o>",
            function()
                return ":lua require'nvim-treesitter.incremental_selection'.node_decremental()<CR>"
            end,
            mode = "x",
            expr = true,
        },
    },
    config = function()
        -- require("nvim-treesitter.install").compilers = { "gcc-12" }
        -- require("nvim-treesitter.install").compilers = { "gcc-11" }

        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.todome = {
            install_info = {
                url = "~/ghq/github.com/monaqa/tree-sitter-todome", -- local path or git repo
                files = { "src/parser.c", "src/scanner.cc" },
            },
            filetype = "todome", -- if filetype does not agrees with parser name
        }
        parser_config.mermaid = {
            install_info = {
                url = "~/ghq/github.com/monaqa/tree-sitter-mermaid", -- local path or git repo
                files = { "src/parser.c" },
            },
            filetype = "mermaid", -- if filetype does not agrees with parser name
        }
        parser_config.satysfi = {
            install_info = {
                url = "https://github.com/monaqa/tree-sitter-satysfi", -- local path or git repo
                files = { "src/parser.c", "src/scanner.c" },
                branch = "master",
            },
            filetype = "satysfi", -- if filetype does not agrees with parser name
        }
        parser_config.satysfi_v0_1_0 = {
            install_info = {
                url = "~/ghq/github.com/monaqa/tree-sitter-satysfi", -- local path or git repo
                files = { "src/parser.c", "src/scanner.c" },
            },
            filetype = "satysfi_v0_1_0", -- if filetype does not agrees with parser name
        }
        parser_config.jsonl = {
            install_info = {
                url = "https://github.com/monaqa/tree-sitter-jsonl", -- local path or git repo
                files = { "src/parser.c" },
            },
            filetype = "jsonl", -- if filetype does not agrees with parser name
        }

        parser_config.nu = {
            install_info = {
                url = "https://github.com/nushell/tree-sitter-nu", -- local path or git repo
                revision = "main",
                files = { "src/parser.c" },
            },
            filetype = "nu", -- if filetype does not agrees with parser name
        }

        parser_config.denops_gitter = {
            install_info = {
                url = "~/ghq/github.com/monaqa/tree-sitter-denops-gitter", -- local path or git repo
                files = { "src/parser.c" },
            },
            filetype = "gitter", -- if filetype does not agrees with parser name
        }

        parser_config.unifieddiff = {
            install_info = {
                url = "https://github.com/monaqa/tree-sitter-unifieddiff",
                -- url = "~/ghq/github.com/monaqa/tree-sitter-unifieddiff",
                files = { "src/parser.c", "src/scanner.c" },
            },
            filetype = "diff", -- if filetype does not agrees with parser name
        }

        parser_config.d2 = {
            install_info = {
                url = "https://github.com/pleshevskiy/tree-sitter-d2", -- local path or git repo
                revision = "main",
                files = { "src/parser.c", "src/scanner.cc" },
            },
            filetype = "d2", -- if filetype does not agrees with parser name
        }

        vim.treesitter.language.register("markdown", { "mdx", "obsidian" })
        vim.treesitter.language.register("gitcommit", { "gina-commit" })

        local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter"
        vim.opt.runtimepath:prepend(parser_install_dir)

        require("nvim-treesitter.configs").setup {
            parser_install_dir = parser_install_dir,
            ensure_installed = {
                "bash",
                "css",
                -- "diff",
                "dot",
                "html",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "rust",
                "svelte",
                "toml",
                "typescript",
                "yaml",

                -- custom grammar
                "mermaid",
                "satysfi",
                "satysfi_v0_1_0",
                "todome",
            },
            highlight = {
                enable = true,
                -- disable = { "help" },
                disable = function(lang, buf)
                    if lang == "vimdoc" then
                        return true
                    end
                    local max_filesize = 1024 * 1024 -- 1 MB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        util.print_error("File too large: tree-sitter disabled.", "WarningMsg")
                        return true
                    end
                    if vim.fn.line("$") > 20000 then
                        util.print_error("Buffer has too many lines: tree-sitter disabled.", "WarningMsg")
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
                disable = {
                    "bash",
                    "css",
                    "html",
                    -- "json",
                    "lua",
                    -- 'markdown',
                    -- "python",
                    "query",
                    -- 'rust',
                    -- 'svelte',
                    "toml",
                    "typescript",
                    "yaml",

                    -- custom grammar
                    "mermaid",
                    -- 'satysfi',
                    -- 'satysfi_v0_1_0',
                    "todome",
                },
            },
            incremental_selection = {
                enable = true,
            },
            textobjects = {
                select = {
                    enable = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",

                        -- Or you can define your own textobjects like this

                        -- ["iF"] = {
                        --   python = "(function_definition) @function",
                        --   cpp = "(function_definition) @function",
                        --   c = "(function_definition) @function",
                        --   java = "(method_declaration) @function",
                        -- },
                    },
                },
            },
            -- matchup との連携はなんかうまくいかんかった（理由は忘れた）
            matchup = {
                enable = false, -- mandatory, false will disable the whole extension
                -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
            },
            query_linter = {
                enable = true,
                use_virtual_text = true,
                lint_events = { "BufWrite", "CursorHold", "InsertLeave" },
            },
        }
    end,
}

plugins:push {
    "https://github.com/nvim-treesitter/playground",
    cond = cond_dev("nvim-treesitter/playground"),
    ft = { "query" },
}

plugins:push {
    "https://github.com/mfussenegger/nvim-treehopper",
    keys = {
        {
            "q",
            ":<C-U>lua require('tsht').nodes()<CR>",
            mode = "o",
        },
        {
            "q",
            ":lua require('tsht').nodes()<CR>",
            mode = "x",
        },
    },
}

return plugins:collect()
