local util = require("rc.util")
local vec = require("rc.util.vec")

local plugins = vec {}

local function cond_dev(plug_path)
    if vim.fn.getcwd() == vim.fn.expand("~/ghq/github.com/") .. plug_path then
        util.print_error("WARNING: " .. plug_path .. " is not loaded.", "WarningMsg")
        return false
    end
    return true
end

plugins:push { "https://github.com/monaqa/colordinate.vim", enabled = false }

plugins:push {
    "https://github.com/monaqa/dial.nvim",
    cond = cond_dev("monaqa/dial.nvim"),
    keys = {
        {
            "<C-a>",
            function()
                require("dial.map").manipulate("increment", "normal")
            end,
        },
        {
            "<C-x>",
            function()
                require("dial.map").manipulate("decrement", "normal")
            end,
        },
        {
            "g<C-a>",
            function()
                require("dial.map").manipulate("increment", "gnormal")
            end,
        },
        {
            "g<C-x>",
            function()
                require("dial.map").manipulate("decrement", "gnormal")
            end,
        },
        {
            "<C-a>",
            function()
                require("dial.map").manipulate("increment", "visual")
            end,
            mode = "v",
        },
        {
            "<C-x>",
            function()
                require("dial.map").manipulate("decrement", "visual")
            end,
            mode = "v",
        },
        {
            "g<C-a>",
            function()
                require("dial.map").manipulate("increment", "gvisual")
            end,
            mode = "v",
        },
        {
            "g<C-x>",
            function()
                require("dial.map").manipulate("decrement", "gvisual")
            end,
            mode = "v",
        },
    },
    config = function()
        local augend = require("dial.augend")

        local function concat(tt)
            local v = {}
            for _, t in ipairs(tt) do
                vim.list_extend(v, t)
            end
            return v
        end

        ---@param tone string
        ---@return integer
        local function tone_to_number(tone)
            return ({
                cees = 10,
                ces = 11,
                c = 0,
                cis = 1,
                ciis = 2,

                dees = 0,
                des = 1,
                d = 2,
                dis = 3,
                diis = 4,

                eees = 2,
                ees = 3,
                e = 4,
                eis = 5,
                eiis = 6,

                fees = 3,
                fes = 4,
                f = 5,
                fis = 6,
                fiis = 7,

                gees = 5,
                ges = 6,
                g = 7,
                gis = 8,
                giis = 9,

                aees = 7,
                aes = 8,
                a = 9,
                ais = 10,
                aiis = 11,

                bees = 9,
                bes = 10,
                b = 11,
                bis = 0,
                biis = 1,
            })[tone]
        end

        local function octave_to_number(octave)
            return ({
                ["'''"] = 3,
                ["''"] = 2,
                ["'"] = 1,
                [""] = 0,
                [","] = -1,
                [",,"] = -2,
                [",,,"] = -3,
            })[octave]
        end

        local function number_to_octave(num)
            return ({
                [3] = "'''",
                [2] = "''",
                [1] = "'",
                [0] = "",
                [-1] = ",",
                [-2] = ",,",
                [-3] = ",,,",
            })[num]
        end

        local function number_to_tone(num)
            return ({
                "c",
                "cis",
                "d",
                "dis",
                "e",
                "f",
                "fis",
                "g",
                "gis",
                "a",
                "ais",
                "b",
            })[num + 1]
        end

        local lilypond_note = augend.user.new {
            find = require("dial.augend.common").find_pattern_regex([[\v\C[cdefgab](ees|es|is|iis)?[,']*]]),
            ---@param text string
            ---@param addend integer
            ---@param cursor integer
            ---@return { text?: string, cursor?: integer }
            add = function(text, addend, cursor)
                local tone_start, tone_end = text:find("[abcdefgis]+")
                if tone_start == nil or tone_end == nil then
                    return {}
                end
                local tone = text:sub(tone_start, tone_end)
                local octave = text:sub(tone_end + 1)
                local tone_num = tone_to_number(tone)
                local octave_num = octave_to_number(octave)
                local total_tone = tone_num + 12 * octave_num
                total_tone = total_tone + addend
                local new_tone_num = total_tone % 12
                local new_octave_num = math.floor(total_tone / 12)
                local new_tone = number_to_tone(new_tone_num)
                local new_octave = number_to_octave(new_octave_num)
                vim.print(text, tone, octave, new_tone, new_octave)
                text = new_tone .. new_octave
                return { text = text, cursor = #text }
            end,
        }

        local basic = {
            augend.integer.alias.decimal,
            augend.integer.alias.hex,
            augend.integer.alias.binary,
            augend.decimal_fraction.new { signed = true },
            augend.date.new {
                pattern = "%Y/%m/%d",
                default_kind = "day",
                clamp = true,
                end_sensitive = true,
            },
            augend.date.new {
                pattern = "%Y-%m-%d",
                default_kind = "day",
                clamp = true,
                end_sensitive = true,
            },
            augend.date.new {
                pattern = "%Y年%-m月%-d日",
                default_kind = "day",
                clamp = true,
                end_sensitive = true,
            },
            augend.date.new {
                pattern = "%-m月%-d日",
                default_kind = "day",
                clamp = true,
                end_sensitive = true,
            },
            augend.date.new {
                pattern = "%-m月%-d日(%J)",
                default_kind = "day",
                clamp = true,
                end_sensitive = true,
            },
            augend.date.new {
                pattern = "%-m月%-d日（%J）",
                default_kind = "day",
                clamp = true,
                end_sensitive = true,
            },
            augend.date.new {
                pattern = "%m/%d",
                default_kind = "day",
                only_valid = true,
                word = true,
                clamp = true,
                end_sensitive = true,
            },
            augend.date.new {
                pattern = "%Y/%m/%d (%J)",
                default_kind = "day",
                clamp = true,
                end_sensitive = true,
            },
            augend.date.new {
                pattern = "%Y/%m/%d（%J）",
                default_kind = "day",
                clamp = true,
                end_sensitive = true,
            },
            augend.date.new {
                pattern = "%a %b %-d %Y",
                default_kind = "day",
                clamp = true,
                end_sensitive = true,
            },
            augend.date.new {
                pattern = "%H:%M",
                default_kind = "min",
                only_valid = true,
                word = true,
            },
            augend.constant.new {
                elements = { "true", "false" },
                word = true,
                cyclic = true,
            },
            augend.constant.new {
                elements = { "True", "False" },
                word = true,
                cyclic = true,
            },
            augend.constant.alias.ja_weekday,
            augend.constant.alias.ja_weekday_full,
            augend.hexcolor.new { case = "lower" },
            augend.semver.alias.semver,
        }

        require("dial.config").augends:register_group {
            default = basic,
            lilypond_note = { lilypond_note },
            lilypond_ises = {
                augend.constant.new {
                    elements = { "cis", "des" },
                    word = false,
                    cyclic = true,
                },
                augend.constant.new {
                    elements = { "dis", "ees" },
                    word = false,
                    cyclic = true,
                },
                augend.constant.new {
                    elements = { "dis", "ees" },
                    word = false,
                    cyclic = true,
                },
                augend.constant.new {
                    elements = { "fis", "ges" },
                    word = false,
                    cyclic = true,
                },
                augend.constant.new {
                    elements = { "gis", "aes" },
                    word = false,
                    cyclic = true,
                },
                augend.constant.new {
                    elements = { "ais", "bes" },
                    word = false,
                    cyclic = true,
                },
            },
        }

        require("dial.config").augends:on_filetype {
            markdown = concat {
                basic,
                { augend.misc.alias.markdown_header },
            },
            -- lilypond = concat {
            --     basic,
            --     { lilypond_note },
            -- },
        }
    end,
}

plugins:push {
    "https://github.com/monaqa/modesearch.nvim",
    cond = cond_dev("monaqa/modesearch.nvim"),
    dependencies = {
        "https://github.com/lambdalisue/kensaku.vim",
    },
    keys = {
        {
            "/",
            function()
                return require("modesearch").keymap.prompt.show("rawstr")
            end,
            mode = { "n", "x", "o" },
            expr = true,
            silent = true,
            replace_keycodes = false,
        },
        {
            "<C-x>",
            function()
                return require("modesearch").keymap.mode.cycle { "rawstr", "migemo", "regexp" }
            end,
            mode = "c",
            expr = true,
        },
        { "_", "/" },
    },
    opts = {
        modes = {
            rawstr = {
                prompt = "[rawstr]/",
                converter = function(query)
                    local case_handler = (function()
                        if query:find("%u") ~= nil then
                            return [[\C]]
                        else
                            return [[\c]]
                        end
                    end)()
                    return case_handler .. [[\V]] .. vim.fn.escape(query, [[/\]])
                end,
            },
            regexp = {
                prompt = "[regexp]/",
                converter = function(query)
                    return [[\c\v]] .. vim.fn.escape(query, [[/]])
                end,
            },
            migemo = {
                prompt = "[migemo]/",
                converter = function(query)
                    return [[\c\v]] .. vim.fn["kensaku#query"](query)
                end,
            },
        },
    },
}

plugins:push { "https://github.com/monaqa/peridot.vim", lazy = true }

-- plugins:push {
--     "https://github.com/monaqa/pretty-fold.nvim",
--     branch = "for_stable_neovim",
--     opts = {
--         fill_char = "┄",
--         sections = {
--             left = {
--                 "content",
--             },
--             right = {
--                 " ",
--                 "number_of_folded_lines",
--                 ": ",
--                 "percentage",
--                 " ",
--                 function(config)
--                     return config.fill_char:rep(3)
--                 end,
--             },
--         },
--
--         remove_fold_markers = true,
--
--         -- Keep the indentation of the content of the fold string.
--         keep_indentation = true,
--
--         -- Possible values:
--         -- "delete" : Delete all comment signs from the fold string.
--         -- "spaces" : Replace all comment signs with equal number of spaces.
--         -- false    : Do nothing with comment signs.
--         comment_signs = "spaces",
--
--         -- List of patterns that will be removed from content foldtext section.
--         stop_words = {
--             "@brief%s*", -- (for cpp) Remove '@brief' and all spaces after.
--         },
--
--         add_close_pattern = true,
--         matchup_patterns = {
--             { "{", "}" },
--             { "%(", ")" }, -- % to escape lua pattern char
--             { "%[", "]" }, -- % to escape lua pattern char
--             { "if%s", "end" },
--             { "do%s", "end" },
--             { "for%s", "end" },
--         },
--     },
-- }

vim.g["smooth_scroll_no_default_key_mappings"] = 1

plugins:push {
    "https://github.com/monaqa/smooth-scroll.vim",
    keys = {
        { mode = { "n", "x" }, "zz" },
        { mode = { "n", "x" }, "zb" },
        { mode = { "n", "x" }, "z<CR>" },
        {
            "<C-d>",
            function()
                vim.fn["smooth_scroll#flick"](vim.v.count1 * vim.o.scroll, 15, "gj", "gk")
            end,
            mode = { "n", "x" },
        },
        {
            "<C-u>",
            function()
                vim.fn["smooth_scroll#flick"](-vim.v.count1 * vim.o.scroll, 15, "gj", "gk")
            end,
            mode = { "n", "x" },
        },
        {
            "<C-f>",
            function()
                vim.fn["smooth_scroll#flick"](vim.v.count1 * vim.fn.winheight(0), 25, "gj", "gk")
            end,
            mode = { "n", "x" },
        },
        {
            "<C-b>",
            function()
                vim.fn["smooth_scroll#flick"](-vim.v.count1 * vim.fn.winheight(0), 25, "gj", "gk")
            end,
            mode = { "n", "x" },
        },
        {
            "L",
            util.cmdcr([[call smooth_scroll#flick( v:count1 * winwidth(0) / 3, 10, "zl", "zh", v:true)]]),
            mode = { "n", "x" },
        },
        {
            "H",
            util.cmdcr([[call smooth_scroll#flick(-v:count1 * winwidth(0) / 3, 10, "zl", "zh", v:true)]]),
            mode = { "n", "x" },
        },
    },
    config = function()
        vim.g["smooth_scroll_interval"] = 1000.0 / 40.0
        vim.g["smooth_scroll_scrollkind"] = "quintic"
        vim.g["smooth_scroll_add_jumplist"] = true

        -- vim.keymap.set({"n", "v"}, "L", function () vim.fn["smooth_scroll#flick"]( vim.v.count1 * vim.fn.winwidth(0) / 3, 10, 'zl', 'zh', true) end)
        -- vim.keymap.set({"n", "v"}, "H", function () vim.fn["smooth_scroll#flick"](-vim.v.count1 * vim.fn.winwidth(0) / 3, 10, 'zl', 'zh', true) end)

        ---@param percent float
        local function set_line_specific_pos(percent)
            return function()
                local target_line = math.floor(1 + (vim.fn.winheight(0) - 1) * percent)
                local wrap = vim.opt.wrap:get()
                vim.opt.wrap = false
                vim.fn["smooth_scroll#flick"](
                    vim.fn.winline() - target_line,
                    10,
                    vim.api.nvim_replace_termcodes("<C-e>", true, true, true),
                    vim.api.nvim_replace_termcodes("<C-y>", true, true, true),
                    true
                )
                vim.opt.wrap = wrap
            end
        end

        vim.keymap.set({ "n", "x" }, "z<CR>", set_line_specific_pos(0.1))
        vim.keymap.set({ "n", "x" }, "zz", set_line_specific_pos(0.4))
        vim.keymap.set({ "n", "x" }, "zb", set_line_specific_pos(0.9))
    end,
}

plugins:push {
    "https://github.com/monaqa/vim-edgemotion",
    keys = {
        { mode = { "n", "x", "o" }, "<Space>j", "m`<Plug>(edgemotion-j)" },
        { mode = { "n", "x", "o" }, "<Space>k", "m`<Plug>(edgemotion-k)" },
        { mode = { "n", "x", "o" }, "<Space>j", "<Plug>(edgemotion-j)" },
        { mode = { "n", "x", "o" }, "<Space>k", "<Plug>(edgemotion-k)" },
    },
}

plugins:push {
    "https://github.com/monaqa/nvim-treesitter-clipping",
    dependencies = { "https://github.com/thinca/vim-partedit" },
    cond = cond_dev("monaqa/nvim-treesitter-clipping"),
    keys = {
        { "<Space>c", "<Plug>(ts-clipping-clip)" },
        { mode = { "x", "o" }, "<Space>c", "<Plug>(ts-clipping-select)" },
    },
}

plugins:push {
    "https://github.com/monaqa/general-converter.nvim",
    cond = cond_dev("monaqa/general-converter.nvim"),
    keys = {
        "gc",
        "gy",
    },
    config = function()
        local gc_util = require("general_converter.util")

        local function yank_pandoc_result(lang_from, lang_to)
            return function(s)
                local cmd = ("pandoc -f %s -t %s"):format(lang_from, lang_to)
                local result = vim.fn.system(cmd, s)
                vim.fn.setreg([["]], result)
                vim.fn.setreg([[0]], result)
                vim.fn.setreg([[+]], result)
                return s
            end
        end

        require("general_converter").setup {
            converters = {
                {
                    desc = "小文字を大文字にする (abc -> ABC)",
                    converter = gc_util.charwise_converter(function(c)
                        local codepoint = vim.fn.char2nr(c)
                        local start_codepoint = vim.fn.char2nr("a")
                        local end_codepoint = vim.fn.char2nr("z")
                        if start_codepoint <= codepoint and codepoint <= end_codepoint then
                            codepoint = codepoint - 0x20
                            return vim.fn.nr2char(codepoint)
                        end
                        return nil
                    end),
                },
                {
                    desc = "半角文字を全角文字に変換する (abcABC -> ａｂｃＡＢＣ)",
                    converter = gc_util.charwise_converter(function(c)
                        local codepoint = vim.fn.char2nr(c)
                        local start_codepoint = vim.fn.char2nr("A")
                        local end_codepoint = vim.fn.char2nr("z")
                        if start_codepoint <= codepoint and codepoint <= end_codepoint then
                            codepoint = codepoint + 0xfee0
                            return vim.fn.nr2char(codepoint)
                        end
                        return nil
                    end),
                },
                {
                    desc = "16進数を2進数に変換する (5A -> 10100101, 0xA5 -> 0b10100101)",
                    converter = function(text)
                        local prefix = ""
                        if text:sub(1, 2) == "0x" then
                            text = text:sub(3)
                            prefix = "0b"
                        end
                        local num = tonumber(text, 16)
                        return vim.fn.printf("%s%b", prefix, num)
                    end,
                },
                {
                    desc = "Vim script の式とみなして計算する (1 + 1 -> 2, 40 * 3 -> 120)",
                    converter = function(text)
                        return vim.fn.string(vim.api.nvim_eval(text))
                    end,
                },
                {
                    desc = "Title Case に変換する",
                    converter = function(text)
                        ---@param word string
                        ---@return string
                        local function capitalize(word)
                            local lower = word:lower()
                            local exception = {
                                "and",
                                "as",
                                "but",
                                "for",
                                "if",
                                "nor",
                                "or",
                                "so",
                                "yet",
                                "a",
                                "an",
                                "the",
                                "as",
                                "at",
                                "by",
                                "for",
                                "in",
                                "of",
                                "off",
                                "on",
                                "per",
                                "to",
                                "up",
                                "via",
                            }
                            if vim.list_contains(exception, lower) then
                                return lower
                            end
                            local new_word = lower:gsub("^.", function(c)
                                return c:upper()
                            end)
                            return new_word
                        end
                        local new_text = text:gsub("(%w+)", capitalize)
                        return new_text
                    end,
                },
                {
                    desc = "インデントを半分にする",
                    converter = gc_util.linewise_converter(function(line)
                        local _, indent = line:find("^[ ]*")
                        local indent_after = math.floor(indent / 2)
                        if indent_after >= 0 then
                            line = (" "):rep(indent_after) .. line:sub(indent + 1)
                        end
                        return line
                    end),
                },
                {
                    desc = "インデントを倍にする",
                    converter = gc_util.linewise_converter(function(line)
                        local _, indent = line:find("^[ ]*")
                        local indent_after = indent * 2
                        if indent_after >= 0 then
                            line = (" "):rep(indent_after) .. line:sub(indent + 1)
                        end
                        return line
                    end),
                },
                {
                    desc = "pandoc で変換し、クリップボードにいれる (typst -> markdown)",
                    converter = yank_pandoc_result("typst", "markdown+hard_line_breaks"),
                    labels = { "typst-pandoc" },
                },
            },
        }
        vim.keymap.set({ "n", "x" }, "gc", require("general_converter").operator_convert(), { expr = true })
    end,
}

plugins:push {
    dir = "~/ghq/github.com/monaqa/typscrap.nvim",
    config = function()
        require("typscrap").setup {
            root_dir = "~/ghq/github.com/monaqa/typscrap-contents/content",
        }
    end,
}

return plugins:collect()
