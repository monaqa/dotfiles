local shorthand = require("monaqa").shorthand
local autocmd_vimrc = shorthand.autocmd_vimrc
local create_cmd = shorthand.create_cmd
local mapset = shorthand.mapset
local vec = require("rc.util.vec")

-- local t = vim.treesitter

local plugins = vec {}

local function cond_dev(plug_path)
    if vim.fn.getcwd() == vim.fn.expand("~/ghq/github.com/") .. plug_path then
        vim.notify("WARNING: " .. plug_path .. " is not loaded.", vim.log.levels.WARN)
        return false
    end
    return true
end

-- tree-sitter
plugins:push {
    "https://github.com/nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    keys = {
        { "v", mode = "x" },
        { "<C-o>", mode = "x" },
        { "<C-i>", mode = "x" },
    },
    config = function()
        ---@param value boolean | fun(buf): boolean
        ---@param defaults boolean
        ---@returns value fun(buf): boolean
        local function unwrap_bool_func(value, defaults)
            if value == nil then
                return function()
                    return defaults
                end
            end
            if type(value) == "boolean" then
                return function()
                    return value
                end
            end
            return value
        end

        ---@class monaqa.TSConfig
        ---@field custom_installer? ParserInfo
        ---@field filetype? string[]
        ---@field highlight? boolean | fun(buf): boolean
        ---@field indent? boolean | fun(buf): boolean
        ---@field folds? boolean | fun(buf): boolean

        -- setup で install_dir などの値が確定する。
        -- nvim-treesitter の他の関数に触るより前に呼ぶべき。
        require("nvim-treesitter").setup {}

        ---@type table<string, monaqa.TSConfig>
        local parser_configs = {
            -- standard parsers
            astro = {},
            bash = {},
            css = {},
            d2 = {},
            dot = {},
            html = {},
            javascript = {},
            json = { indent = true },
            lua = {},
            markdown = { indent = true, filetype = { "mdx", "obsidian" } },
            markdown_inline = {},
            mermaid = {},
            python = { indent = true },
            query = {},
            rust = { indent = true },
            svelte = { indent = true },
            swift = { indent = true },
            toml = {},
            tsx = {},
            typescript = {},
            typst = {},
            vim = {},
            yaml = {},

            -- custom parsers
            koka = {
                custom_installer = {
                    tier = 2,
                    install_info = {
                        url = "https://github.com/koka-community/tree-sitter-koka",
                        revision = "main",
                    },
                },
                filetype = { "koka" },
                indent = true,
            },

            -- monaqa parsers
            jsonl = {
                custom_installer = {
                    tier = 2,
                    install_info = {
                        url = "https://github.com/monaqa/tree-sitter-jsonl",
                        revision = "master",
                    },
                },
                filetype = { "jsonl" },
            },
            unifieddiff = {
                custom_installer = {
                    tier = 2,
                    install_info = {
                        url = "https://github.com/monaqa/tree-sitter-unifieddiff",
                        revision = "master",
                    },
                },
                filetype = { "diff", "gin-diff", "git" },
            },
        }

        if vim.uv.fs_stat("/Users/monaqa/ghq/github.com/monaqa/tree-sitter-lilypond") then
            parser_configs.lilypond = {
                custom_installer = {
                    tier = 2,
                    install_info = {
                        path = "~/ghq/github.com/monaqa/tree-sitter-lilypond",
                    },
                },
                filetype = { "lilypond" },
            }
        end

        -- parser の install （custom parser は事前に情報を詰めておく）
        autocmd_vimrc("User") {
            pattern = "TSUpdate",
            callback = function()
                vim.iter(parser_configs):each(function(key, value)
                    if value.custom_installer ~= nil then
                        require("nvim-treesitter.parsers")[key] = value.custom_installer
                    end
                end)
            end,
        }
        require("nvim-treesitter").install(vim.tbl_keys(parser_configs))

        -- ハイライト、インデント、fold の設定
        for lang, config in pairs(parser_configs) do
            local enables_highlight = unwrap_bool_func(config.highlight, true)
            local enables_indent = unwrap_bool_func(config.indent, false)
            local enables_folds = unwrap_bool_func(config.folds, false)
            if config.filetype ~= nil then
                vim.treesitter.language.register(lang, config.filetype)
            end
            autocmd_vimrc("FileType") {
                pattern = vim.treesitter.language.get_filetypes(lang),
                callback = function(buf)
                    if enables_highlight(buf) then
                        vim.treesitter.start()
                    end
                    if enables_indent(buf) then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                    if enables_folds(buf) then
                        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    end
                end,
            }
        end

        create_cmd("TSEditQuery") {
            nargs = "*",
            function(args)
                local query_name = args.fargs[1]
                if query_name == nil then
                    query_name = "highlights"
                end

                local lang = args.fargs[2]
                if lang == nil then
                    local filetype = vim.bo.filetype
                    lang = vim.treesitter.language.get_lang(filetype)
                    if lang == nil then
                        error("failed to get treesitter language from current buffer.")
                    end
                end
                local files = vim.treesitter.query.get_files(lang, query_name)
                if #files == 0 then
                    vim.cmd.edit(vim.fs.joinpath(vim.fn.stdpath("config"), "queries", lang, query_name .. ".scm"))
                elseif #files == 1 then
                    vim.cmd.edit(files[1])
                else
                    vim.ui.select(files, {
                        prompt = "Choose one file to open",
                    }, function(choice)
                        vim.cmd.edit(choice)
                    end)
                end
            end,
            complete = function(arglead, cmdline, cursorpos)
                local success, result = pcall(vim.api.nvim_parse_cmd, cmdline, {})
                if success then
                    if #result.args == 0 then
                        return {
                            "highlights",
                            "folds",
                            "indents",
                            "injections",
                            "aerial",
                            "clipping",
                        }
                    end
                end
            end,
        }

        -- mapset.x("v") {
        --     desc = [[treesitter の構文をもとに範囲を拡張する]],
        --     expr = true,
        --     function()
        --         if vim.fn.mode() == "v" then
        --             return "<Plug>(vimrc-treesitter-increment-select)"
        --         else
        --             return "v"
        --         end
        --     end,
        -- }
        -- mapset.x("<C-i>") { "<Plug>(vimrc-treesitter-increment-select)" }
        -- mapset.x("<C-o>") { "<Plug>(vimrc-treesitter-decrement-select)" }
        -- mapset.x("<Plug>(vimrc-treesitter-increment-select)") {
        --     desc = [[構文に従って選択範囲を拡張する]],
        --     function()
        --         require("nvim-treesitter.incremental_selection").node_incremental()
        --     end,
        -- }
        -- mapset.x("<Plug>(vimrc-treesitter-decrement-select)") {
        --     desc = [[構文に従って選択範囲を拡張する]],
        --     function()
        --         require("nvim-treesitter.incremental_selection").node_decremental()
        --     end,
        -- }
    end,
}

-- plugins:push {
--     "https://github.com/nvim-treesitter/playground",
--     cond = cond_dev("nvim-treesitter/playground"),
--     ft = { "query" },
-- }

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

-- plugins:push {
--     "https://github.com/Wansmer/treesj",
--     dependencies = { "nvim-treesitter/nvim-treesitter" },
--     keys = {
--         {
--             "<space>s",
--             function()
--                 require("treesj").toggle()
--             end,
--         },
--     },
--     config = function()
--         require("treesj").setup {
--             use_default_keymaps = false,
--             max_join_length = 99999,
--         }
--     end,
-- }

return plugins:collect()
