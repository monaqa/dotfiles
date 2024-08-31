local util = require("rc.util")
local vec = require("rc.util.vec")
local mapset = require("monaqa").shorthand.mapset

local plugins = vec {}

plugins:push {
    "https://github.com/hrsh7th/nvim-insx",
    event = "InsertEnter",
    config = function()
        local standard = require("insx.preset.standard")
        local insx = require("insx")
        local esc = require("insx.helper.regex").esc

        -- standard.set_pair の中身を少し改変
        local function set_pair(mode, open, close)
            local option = { mode = mode }

            -- jump_out
            insx.add(
                close,
                insx.with(
                    require("insx.recipe.jump_next") {
                        jump_pat = {
                            [[\%#]] .. esc(close) .. [[\zs]],
                        },
                    },
                    {}
                ),
                option
            )

            -- auto_pair
            insx.add(
                open,
                insx.with(
                    require("insx.recipe.auto_pair") {
                        open = open,
                        close = close,
                    },
                    {}
                ),
                option
            )

            -- delete_pair
            insx.add(
                "<BS>",
                insx.with(
                    require("insx.recipe.delete_pair") {
                        open_pat = esc(open),
                        close_pat = esc(close),
                    },
                    {}
                ),
                option
            )

            -- spacing
            -- if kit.get(standard.config, { "spacing", "enabled" }, true) then
            --     insx.add(
            --         "<Space>",
            --         insx.with(
            --             require("insx.recipe.pair_spacing").increase {
            --                 open_pat = esc(open),
            --                 close_pat = esc(close),
            --             },
            --             withs
            --         ),
            --         option
            --     )
            --
            --     insx.add(
            --         "<BS>",
            --         insx.with(
            --             require("insx.recipe.pair_spacing").decrease {
            --                 open_pat = esc(open),
            --                 close_pat = esc(close),
            --             },
            --             withs
            --         ),
            --         option
            --     )
            -- end

            -- fast_break
            insx.add(
                "<CR>",
                insx.with(
                    require("insx.recipe.fast_break") {
                        open_pat = esc(open),
                        close_pat = esc(close),
                        split = nil,
                        html_attrs = true,
                        html_tags = true,
                        arguments = true,
                    },
                    {}
                ),
                option
            )

            -- fast_wrap
            insx.add(
                "<C-]>",
                insx.with(
                    require("insx.recipe.fast_wrap") {
                        close = close,
                    },
                    {}
                ),
                option
            )
        end

        -- standard.setup_insert_mode の中身を少し改変

        insx.add("`", {
            enabled = function(ctx)
                return ctx.match([[`\%#`]]) and vim.tbl_contains({ "markdown", "typst" }, ctx.filetype)
            end,
            action = function(ctx)
                if ctx.match([[```\%#```]]) then
                    return
                end
                ctx.send("``<Left>")
                ctx.send("``<Left>")
            end,
        })

        insx.add([["]], {
            enabled = function(ctx)
                return ctx.match([["\%#"]]) and ctx.filetype == "python"
            end,
            action = function(ctx)
                if ctx.match([["""\%#"""]]) then
                    return
                end
                ctx.send([[""<Left>]])
                ctx.send([[""<Left>]])
            end,
        })

        insx.add(
            "<CR>",
            insx.with(
                require("insx.recipe.fast_break") {
                    open_pat = [[```\w*]],
                    close_pat = "```",
                    indent = 0,
                },
                {
                    insx.with.filetype { "markdown", "typst" },
                }
            )
        )

        insx.add(
            "<CR>",
            insx.with(
                require("insx.recipe.fast_break") {
                    open_pat = [["""\w*]],
                    close_pat = [["""]],
                    indent = 0,
                },
                {
                    insx.with.filetype { "python" },
                }
            )
        )

        -- html tag like.
        insx.add(
            "<CR>",
            require("insx.recipe.fast_break") {
                open_pat = insx.helper.search.Tag.Open,
                close_pat = insx.helper.search.Tag.Close,
            }
        )

        -- quotes
        for _, quote in ipairs { '"', "'", "`" } do
            standard.set_quote("i", quote, {
                {
                    priority = 0,
                },
            })
        end

        insx.add("'", {
            enabled = function(ctx)
                return ctx.filetype == "rust"
            end,
            action = function(ctx)
                ctx.send(ctx.char)
            end,
            priority = 1,
        })

        -- pairs
        for open, close in pairs {
            ["("] = ")",
            ["["] = "]",
            ["{"] = "}",
        } do
            set_pair("i", open, close)
        end

        vim.keymap.set("i", "<CR>", function()
            if util.to_bool(vim.fn["coc#pum#visible"]()) then
                -- 補完候補をセレクトしていたときのみ、補完候補の内容で確定する
                -- （意図せず補完候補がセレクトされてしまうのを抑止）
                if vim.fn["coc#pum#info"]()["index"] >= 0 then
                    return vim.api.nvim_replace_termcodes(vim.fn["coc#pum#confirm"](), true, true, true)
                end
                return vim.fn.keytrans(vim.fn["insx#expand"]("<CR>"))
            end
            return vim.fn.keytrans(vim.fn["insx#expand"]("<CR>"))
        end, { expr = true, remap = true })
    end,
}

plugins:push {
    "https://github.com/machakann/vim-sandwich",
    keys = {
        { "sa", mode = { "n", "x" } },
        {
            "ds",
            "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)",
        },
        {
            "dsb",
            "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)",
        },
        {
            "cs",
            "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)",
        },
        {
            "csb",
            "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)",
        },
        { "ab", mode = { "x", "o" } },
        { "ib", mode = { "x", "o" } },
        {
            "m",
            "<Plug>(textobj-sandwich-literal-query-i)",
            mode = { "x", "o" },
        },
        {
            "M",
            "<Plug>(textobj-sandwich-literal-query-a)",
            mode = { "x", "o" },
        },
    },
    config = function()
        mapset.n("sr") { "<Nop>", nowait = true }
        mapset.n("srb") { "<Nop>", nowait = true }
        mapset.n("sd") { "<Nop>", nowait = true }
        mapset.n("sdb") { "<Nop>", nowait = true }

        -- 全体設定
        vim.fn["operator#sandwich#set"]("all", "all", "highlight", 0)

        -- レシピを作るための関数群
        function vim.g.SandwichMarkdownCodeSnippet()
            local lang_name = vim.fn.input("language: ", "")
            return "```" .. lang_name
        end

        -- 例外を throw する方法が分からないので Lua 化はお蔵入り
        -- function vim.g.SandwichGenericsName()
        --     -- local generics_name = vim.fn.input("generics name: ", "")
        --     local generics_name = vim.fn.input("generics name: ", "")
        --     if generics_name ~= "" then
        --         vim.cmd[[throw "OperatorSandwichCancel"]]
        --     end
        --     return generics_name .. "<"
        -- end
        --
        -- function vim.g.SandwichInlineCmdName()
        --     local cmd_name = vim.fn.input("inline-cmd name: ", "")
        --     if cmd_name ~= "" then
        --         vim.cmd[[throw "OperatorSandwichCancel"]]
        --     end
        --     return [[\]] .. cmd_name .. "{"
        -- end
        --
        -- function vim.g.SandwichBlockCmdName()
        --     local cmd_name = vim.fn.input("block-cmd name: ", "")
        --     if cmd_name ~= "" then
        --         vim.cmd[[throw "OperatorSandwichCancel"]]
        --     end
        --     return "+" .. cmd_name .. "<"
        -- end

        vim.cmd([[
            function! SandwichGenericsName() abort
              let genericsname = input('generics name: ', '')
              if genericsname ==# ''
                throw 'OperatorSandwichCancel'
              endif
              return genericsname . '<'
            endfunction

            function! SandwichInlineCmdName() abort
              let cmdname = input('inline-cmd name: ', '')
              if cmdname ==# ''
                throw 'OperatorSandwichCancel'
              endif
              return '\' . cmdname . '{'
            endfunction

            function! SandwichBlockCmdName() abort
              let cmdname = input('block-cmd name: ', '')
              if cmdname ==# ''
                throw 'OperatorSandwichCancel'
              endif
              return '+' . cmdname . '<'
            endfunction

            function! SandwichTypstCmdName() abort
              let cmdname = input('command name: ', '')
              if cmdname ==# ''
                throw 'OperatorSandwichCancel'
              endif
              return '#' . cmdname . '['
            endfunction

        ]])

        -- レシピ集
        local default_recipes = vim.g["sandwich#default_recipes"]

        -- dot repeat が効かないのでお蔵入り
        -- local custom_func = {
        --     {
        --         buns = { "(", ")" },
        --         kind = { "add" },
        --         action = { "add" },
        --         cursor = "head",
        --         command = { "startinsert" },
        --         input = { "f" },
        --     },
        -- }

        local recipe_general = {
            {
                input = { "(" },
                buns = { "(", ")" },
                nesting = 1,
                match_syntax = 1,
                kind = { "add", "replace" },
                action = { "add" },
            },
            {
                input = { "[" },
                buns = { "[", "]" },
                nesting = 1,
                match_syntax = 1,
                kind = { "add", "replace" },
                action = { "add" },
            },
            {
                buns = { "{", "}" },
                input = { "{" },
                nesting = 1,
                match_syntax = 1,
                kind = { "add", "replace" },
                action = { "add" },
            },
            {
                input = { "[" },
                buns = { [=[\s*[]=], [=[]\s*]=] },
                regex = 1,
                nesting = 1,
                match_syntax = 1,
                kind = { "delete", "replace", "textobj" },
                action = { "delete" },
            },
            {
                input = { "(" },
                buns = { [[\s*(]], [[)\s*]] },
                regex = 1,
                nesting = 1,
                match_syntax = 1,
                kind = { "delete", "replace", "textobj" },
                action = { "delete" },
            },
            {
                input = { "{" },
                buns = { [[\s*{]], [[}\s*]] },
                regex = 1,
                nesting = 1,
                match_syntax = 1,
                kind = { "delete", "replace", "textobj" },
                action = { "delete" },
            },
        }

        local recipe_japanese = {
            { input = { "j(", "j)", "jp" }, buns = { "（", "）" }, nesting = 1 },
            { input = { "j[", "j]", "jb" }, buns = { "「", "」" }, nesting = 1 },
            { input = { "j{", "j}", "jB" }, buns = { "『", "』" }, nesting = 1 },
            { input = { "j<", "j>", "jk" }, buns = { "【", "】" }, nesting = 1 },
            { input = { [[j"]] }, buns = { "“", "”" }, nesting = 1 },
            { input = { [[j']] }, buns = { "‘", "’" }, nesting = 1 },
        }

        local recipe_escaped = {
            { input = { [[\(]], [[\)]] }, buns = { [[\(]], [[\)]] }, nesting = 1 },
            { input = { [=[\[]=], [=[\]]=] }, buns = { [=[\[]=], [=[\]]=] }, nesting = 1 },
            { input = { [[\{]], [[\}]] }, buns = { [[\{]], [[\}]] }, nesting = 1 },
        }

        local recipe_link = vim.iter({
            { filetype = { "markdown" }, pattern = "[$body]($dest)" },
            { filetype = { "rst" }, pattern = "`$body <$dest>`_" },
            { filetype = { "typst" }, pattern = '#link("$dest")[$body]' },
        })
            :map(function(t)
                return {
                    {
                        -- $dest を空にして $body 部分で囲む
                        filetype = t.filetype,
                        input = { "l" },
                        buns = vim.split(t.pattern:gsub("$dest", ""), "$body"),
                        nesting = 0,
                    },
                    {
                        -- $body を空にして $dest 部分で囲む
                        filetype = t.filetype,
                        input = { "L" },
                        buns = vim.split(t.pattern:gsub("$body", ""), "$dest"),
                        nesting = 0,
                    },
                }
            end)
            :flatten()
            :totable()

        local recipe_codeblock = {
            {
                filetype = { "markdown", "obsidian", "typst" },
                input = { "c" },
                buns = { "```", "```" },
                kind = { "add" },
                linewise = 1,
                command = { [[']s/^\s*//]] },
            },
            {
                filetype = { "markdown", "obsidian", "typst" },
                input = { "C" },
                buns = { "SandwichMarkdownCodeSnippet()", [["```"]] },
                expr = 1,
                kind = { "add" },
                linewise = 1,
                command = { [[']s/^\s*//]] },
            },
            {
                filetype = { "norg" },
                input = { "c" },
                buns = { "@code", "@end" },
                expr = 1,
                kind = { "add" },
                linewise = 1,
                command = { [[']s/^\s*//]] },
            },
        }

        local recipe_generics = {
            {
                input = { "g" },
                buns = { "SandwichGenericsName()", [[">"]] },
                expr = 1,
                cursor = "inner_tail",
                kind = { "add", "replace" },
                action = { "add" },
            },
            {
                input = { "g" },
                external = { "i<", vim.api.nvim_eval([["\<Plug>(textobj-functioncall-generics-a)"]]) },
                noremap = 0,
                kind = { "delete", "replace", "query" },
            },
        }

        local recipe_lua = {
            { filetype = { "lua" }, buns = { "[[", "]]" }, nesting = 0, input = { "s" } },
            { filetype = { "lua" }, buns = { "[=[", "]=]" }, nesting = 0, input = { "S" } },
        }

        local recipe_satysfi_cmd = {
            {
                filetype = { "satysfi", "satysfi_v0_1_0" },
                input = { "c" },
                buns = { "SandwichInlineCmdName()", [["}"]] },
                expr = 1,
                cursor = "inner_tail",
                kind = { "add", "replace" },
                action = { "add" },
            },
            {
                filetype = { "satysfi", "satysfi_v0_1_0" },
                input = { "+" },
                buns = { "SandwichBlockCmdName()", [[">"]] },
                expr = 1,
                cursor = "inner_tail",
                kind = { "add", "replace" },
                action = { "add" },
            },
        }

        local recipe_typst_cmd = {
            {
                filetype = { "typst" },
                input = { "#" },
                buns = { "SandwichTypstCmdName()", [["]"]] },
                expr = 1,
                cursor = "inner_tail",
                kind = { "add", "replace" },
                action = { "add" },
            },
        }

        vim.g["sandwich#recipes"] = util.list_concat {
            default_recipes,
            recipe_general,
            recipe_japanese,
            recipe_escaped,
            recipe_lua,
            recipe_link,
            recipe_codeblock,
            recipe_generics,
            recipe_satysfi_cmd,
            recipe_typst_cmd,
        }
    end,
}

-- plugins:push {
--     "andymass/vim-matchup",
--     -- keys = {
--     --     { "<Space>m", "<Plug>(matchup-%)" },
--     -- },
--     config = function()
--         vim.g["matchup_matchparen_offscreen"] = {}
--     end,
-- }

return plugins:collect()
