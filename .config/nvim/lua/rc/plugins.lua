local util = require "rc.util"

local disable_plugins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
}

for _, name in ipairs(disable_plugins) do
    vim.g["loaded_" .. name] = 1
end

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

local lazy_config = {
    dev = {
        -- directory where you store your local plugin projects
        path = "~/ghq/github.com/",
        ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
        patterns = { "monaqa" }, -- For example {"folke"}
        fallback = false, -- Fallback to git when local plugin doesn't exist
    },
}

local function cond_dev(plug_path)
    if vim.fn.getcwd() == vim.fn.expand "~/ghq/github.com/" .. plug_path then
        util.print_error("WARNING: " .. plug_path .. " is not loaded.", "WarningMsg")
        return false
    end
    return true
end

---@param conf LazyPluginSpec
local function add(conf)
    table.insert(lazy_config, conf)
end

-- add {
--     "glacambre/firenvim",
--     cond = not not vim.g.started_by_firenvim,
--     build = function()
--         require("lazy").load { plugins = "firenvim", wait = true }
--         vim.fn["firenvim#install"](0)
--     end,
-- }
add {
    "https://github.com/akinsho/bufferline.nvim",
    lazy = false,
    keys = {
        { "sN", "<Cmd>BufferLineMoveNext<CR>" },
        { "sP", "<Cmd>BufferLineMovePrev<CR>" },
        -- { "sw", "<Cmd>bp | sp | bn | bd<CR>" },
        { "sw", "<Cmd>bp | bd #<CR>" },
    },
    opts = {
        options = {
            diagnostics = "coc",
            -- separator_style = "thin",
            separator_style = "slant",
            indicator = {
                style = "none",
                -- style = "underline"
            },
            left_trunc_marker = "",
            right_trunc_marker = "",
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
                if level == "error" then
                    return "🚨" .. count
                elseif level == "warning" then
                    return "🐤" .. count
                end
                -- return "ℹ️ "
                return ""
            end,
            tab_size = 5,
            max_name_length = 30,
            show_close_icon = false,
            show_buffer_close_icons = false,
            custom_filter = function(buf_number, buf_numbers)
                -- filter out filetypes you don't want to see
                if vim.bo[buf_number].filetype ~= "oil" then
                    return true
                end
            end,
        },

        highlights = {
            background = { bg = "#666666", fg = "#bbbbbb" },
            tab = { bg = "#666666", fg = "#bbbbbb" },
            tab_selected = { bg = "None", fg = "#ebdbb2" },
            tab_close = { bg = "#666666", fg = "#bbbbbb" },
            close_button = { bg = "#666666", fg = "#bbbbbb" },
            close_button_visible = { bg = "#444444", fg = "#ebdbb2" },
            close_button_selected = { bg = "None", fg = "#ebdbb2" },
            buffer_visible = { bg = "#444444", fg = "#ebdbb2" },
            buffer_selected = { bg = "None", fg = "#ebdbb2" },
            numbers = { bg = "#666666", fg = "#bbbbbb" },
            numbers_visible = { bg = "#444444", fg = "#ebdbb2" },
            numbers_selected = { bg = "None", fg = "#ebdbb2" },
            diagnostic = { bg = "#666666" },
            diagnostic_visible = { bg = "#444444" },
            diagnostic_selected = { bg = "None" },
            hint = { bg = "#666666", fg = "#bbbbbb" },
            hint_visible = { bg = "#444444", fg = "#ebdbb2" },
            hint_selected = { bg = "None", fg = "#ebdbb2" },
            hint_diagnostic = { bg = "#666666", fg = "#bbbbbb" },
            hint_diagnostic_visible = { bg = "#444444", fg = "#ebdbb2" },
            hint_diagnostic_selected = { bg = "None", fg = "#ebdbb2" },
            info = { bg = "#666666", fg = "#bbbbbb" },
            info_visible = { bg = "#444444", fg = "#ebdbb2" },
            info_selected = { bg = "None", fg = "#ebdbb2" },
            info_diagnostic = { bg = "#666666", fg = "#bbbbbb" },
            info_diagnostic_visible = { bg = "#444444", fg = "#ebdbb2" },
            info_diagnostic_selected = { bg = "None", fg = "#ebdbb2" },
            warning = { bg = "#666666" },
            warning_visible = { bg = "#444444" },
            warning_selected = { bg = "None" },
            warning_diagnostic = { bg = "#666666" },
            warning_diagnostic_visible = { bg = "#444444" },
            warning_diagnostic_selected = { bg = "None" },
            error = { bg = "#666666", fg = "#dd7777" },
            error_visible = { bg = "#444444", fg = "#dd4444" },
            error_selected = { bg = "None" },
            error_diagnostic = { bg = "#666666", fg = "#dd7777" },
            error_diagnostic_visible = { bg = "#444444", fg = "#dd4444" },
            error_diagnostic_selected = { bg = "None" },
            modified = { bg = "#666666" },
            modified_visible = { bg = "#444444" },
            modified_selected = { bg = "None" },
            duplicate_selected = { bg = "None" },
            duplicate_visible = { bg = "#444444" },
            duplicate = { bg = "#666666" },
            indicator_selected = { bg = "None", fg = "#ebdbb2" },
            pick_selected = { bg = "None", fg = "#ebdbb2" },
            pick_visible = { bg = "#444444", fg = "#ebdbb2" },
            pick = { bg = "#666666", fg = "#bbbbbb" },
            offset_separator = { bg = "#666666", fg = "#ebdbb2" },

            fill = { bg = "#c8c8c8" },
            separator = { bg = "#666666", fg = "#c8c8c8" },
            separator_visible = { bg = "#444444", fg = "#c8c8c8" },
            separator_selected = { bg = "None", fg = "#c8c8c8" },
        },
    },
}
-- add { "https://github.com/glidenote/memolist.vim" }
add {
    "https://github.com/haya14busa/vim-asterisk",
    keys = {
        { "*", "<Plug>(asterisk-z*)" },
        { "#", "<Plug>(asterisk-z#)" },
        { "g*", "<Plug>(asterisk-gz*)" },
        { "g#", "<Plug>(asterisk-gz#)" },
    },
}
add {
    "https://github.com/iamcco/markdown-preview.nvim",
    ft = { "markdown", "mdx" },
    run = ":call mkdp#util#install()",
    config = function()
        vim.g.mkdp_markdown_css = vim.fn.expand "~/.config/nvim/resource/github-markdown-light.css"
        vim.g.mkdp_auto_close = 0
        vim.g.mkdp_preview_options = {
            disable_sync_scroll = 1,
        }
    end,
}
add { "https://github.com/itchyny/vim-qfedit", ft = { "qf" } }
add {
    "https://github.com/kana/vim-altr",
    keys = {
        { "<Space>^", "<Plug>(altr-forward)" },
        { "<Space>-", "<Plug>(altr-forward)" },
    },
}
-- add {
--     "kana/vim-smartword",
--     keys = {
--         { "w", "<Plug>(smartword-w)", mode = { "n", "x" } },
--         { "e", "<Plug>(smartword-e)", mode = { "n", "x" } },
--         { "b", "<Plug>(smartword-b)", mode = { "n", "x" } },
--         { "ge", "<Plug>(smartword-ge)", mode = { "n", "x" } },
--     },
-- }
add { "https://github.com/kkiyama117/zenn-vim", lazy = true }
add {
    "https://github.com/lambdalisue/fern.vim",
    branch = "main",
    dependencies = {
        "https://github.com/lambdalisue/fern-renderer-nerdfont.vim",
        "https://github.com/lambdalisue/fern-hijack.vim",
        "https://github.com/lambdalisue/fern-git-status.vim",
        "https://github.com/lambdalisue/nerdfont.vim",
    },
    keys = {
        -- { "sf", "<Cmd>Fern . -reveal=%:p<CR>" },
        { "sz", "<Cmd>Fern . -drawer -toggle<CR>" },
    },
    cmd = {
        "Fern",
    },
    config = function()
        vim.g["fern#disable_default_mappings"] = 1
        vim.g["fern#default_hidden"] = 1

        local exclude_files = {
            [[.*\.egg-info]],
            [[.*\.pyc]],
            [[\.DS_Store]],
            [[\.git]],
            [[\.mypy_cache]],
            [[\.ruff_cache]],
            [[\.pytest_cache]],
            [[\.vim]],
            [[\.vimsessions]],
            [[\.worktree]],
            [[__pycache__]],
            [[sumneko-lua-.*]],
        }

        vim.g["fern#default_exclude"] = [[^\%(]] .. table.concat(exclude_files, [[\|]]) .. [[\)$]]
        vim.g["fern#renderer"] = "nerdfont"
        vim.g["fern#renderer#nerdfont#indent_markers"] = 1

        -- vim.keymap.set("n", "sf", "<Cmd>Fern . -reveal=%:p<CR>")
        -- vim.keymap.set("n", "sz", "<Cmd>Fern . -drawer -toggle<CR>")

        local function fern_buffer_config()
            vim.opt_local.number = false
            vim.opt_local.signcolumn = "no"
            vim.opt_local.foldcolumn = "0"

            vim.cmd [[
            nmap <buffer><expr>
            \ <Plug>(fern-expand-or-enter)
            \ fern#smart#drawer(
            \   "\<Plug>(fern-action-expand)",
            \   "\<Plug>(fern-action-enter)",
            \ )
            nmap <buffer><expr>
            \ <Plug>(fern-open-or-enter)
            \ fern#smart#leaf(
            \   "\<Plug>(fern-action-open)",
            \   "\<Plug>(fern-action-enter)",
            \ )
            nmap <buffer><expr>
            \ <Plug>(fern-open-or-expand)
            \ fern#smart#leaf(
            \   "\<Plug>(fern-action-open)",
            \   "\<Plug>(fern-action-expand)",
            \ )
            nmap <silent><buffer><expr> <Plug>(fern-expand-or-collapse)
            \ fern#smart#leaf(
            \   "\<Plug>(fern-action-collapse)",
            \   "\<Plug>(fern-action-expand)",
            \   "\<Plug>(fern-action-collapse)",
            \ )
        ]]

            -- fern の関数には "\<Plug>" な文字列を入れないといけないためか、うまく動かない

            -- vim.keymap.set("n", "<Plug>(fern-expand-or-enter)", function ()
            --     vim.fn["fern#smart#drawer"]("<Plug>(fern-action-expand)", "<Plug>(fern-action-enter)")
            -- end, {expr = true, buffer = true})
            -- vim.keymap.set("n", "<Plug>(fern-open-or-enter)", function ()
            --     vim.fn["fern#smart#leaf"]("<Plug>(fern-action-open)", "<Plug>(fern-action-enter)")
            -- end, {expr = true, buffer = true})
            -- vim.keymap.set("n", "<Plug>(fern-expand-or-expand)", function ()
            --     vim.fn["fern#smart#leaf"]("<Plug>(fern-action-open)", "<Plug>(fern-action-expand)")
            -- end, {expr = true, buffer = true})
            -- vim.keymap.set("n", "<Plug>(fern-expand-or-collapse)", function ()
            --     vim.fn["fern#smart#leaf"]("<Plug>(fern-action-collapse)", "<Plug>(fern-action-expand)", "<Plug>(fern-action-collapse)")
            -- end, {expr = true, buffer = true})

            vim.keymap.set("n", "<C-h>", "<Plug>(fern-action-leave)", { remap = true, buffer = true })
            vim.keymap.set("n", "<CR>", "<Plug>(fern-open-or-enter)", { remap = true, buffer = true, nowait = true })
            vim.keymap.set("n", "<Space><CR>", "<Plug>(fern-action-open:system)", { remap = true, buffer = true })
            vim.keymap.set("n", "e", "<Plug>(fern-action-open)", { remap = true, buffer = true })
            vim.keymap.set("n", "<BS>", "<Plug>(fern-action-leave)", { remap = true, buffer = true })

            vim.keymap.set("n", ">>", "<Plug>(fern-action-mark:set)", { remap = true, buffer = true, nowait = true })
            -- なぜか unset のときファイル末尾にジャンプしてしまうので <C-o> を付けた
            vim.keymap.set(
                "n",
                "<<",
                "<Plug>(fern-action-mark:unset)<C-o>",
                { remap = true, buffer = true, nowait = true }
            )
            vim.keymap.set("x", ">", "<Plug>(fern-action-mark:set)", { remap = true, buffer = true, nowait = true })
            vim.keymap.set("x", "<", "<Plug>(fern-action-mark:unset)", { remap = true, buffer = true, nowait = true })

            vim.keymap.set("n", "t", "<Plug>(fern-expand-or-collapse)", { remap = true, buffer = true, nowait = true })
            vim.keymap.set("n", "T", "<Plug>(fern-action-collapse)", { remap = true, buffer = true, nowait = true })

            vim.keymap.set("n", "o", "<Plug>(fern-action-new-file)", { remap = true, buffer = true })
            vim.keymap.set("n", "O", "<Plug>(fern-action-new-dir)", { remap = true, buffer = true })

            vim.keymap.set("n", "d", "<Plug>(fern-action-trash)", { remap = true, buffer = true, nowait = true })
            vim.keymap.set("n", "r", "<Plug>(fern-action-rename)", { remap = true, buffer = true, nowait = true })
            vim.keymap.set("n", "c", "<Plug>(fern-action-copy)", { remap = true, buffer = true, nowait = true })
            vim.keymap.set("n", "m", "<Plug>(fern-action-move)", { remap = true, buffer = true, nowait = true })

            vim.keymap.set("n", "<C-l>", "<Plug>(fern-action-redraw)", { remap = true, buffer = true })

            vim.keymap.set("n", "u", function()
                vim.g["fern#renderer#nerdfont#indent_markers"] = 1 - vim.g["fern#renderer#nerdfont#indent_markers"]
                return "<Plug>(fern-action-redraw)"
            end, { buffer = true, expr = true })

            local fern_excluded = true

            vim.keymap.set("n", "<Plug>(fern-exclude-toggle)", function()
                if fern_excluded then
                    fern_excluded = false
                    return [[<Plug>(fern-action-exclude=)<C-u><CR>]]
                end
                fern_excluded = true
                return ([[<Plug>(fern-action-exclude=)<C-u>%s<CR>]]):format(vim.g["fern#default_exclude"])
            end, { expr = true, buffer = true })

            vim.keymap.set("n", "!", "<Plug>(fern-exclude-toggle)", { remap = true, buffer = true, nowait = true })

            vim.keymap.set("n", "sw", "<Cmd>bp<CR>", { buffer = true })
        end

        util.autocmd_vimrc "FileType" {
            pattern = "fern",
            callback = fern_buffer_config,
        }
    end,
}
add {
    "https://github.com/lambdalisue/gina.vim",
    cmd = {
        "Gina",
        "GinaBrowseYank",
        "GinaPrChanges",
    },
    config = function()
        util.autocmd_vimrc { "FileType" } {
            pattern = "gina-blame",
            callback = function()
                vim.opt_local.number = false
                vim.opt_local.signcolumn = "no"
                vim.opt_local.foldcolumn = "0"
            end,
        }

        util.autocmd_vimrc { "FileType" } {
            pattern = "gina-status",
            callback = function()
                vim.keymap.set("n", "<C-l>", "<Cmd>e<CR>", { buffer = true })
            end,
        }

        util.autocmd_vimrc { "FileType" } {
            pattern = "gina-log",
            callback = function()
                vim.keymap.set("n", "c", "<Plug>(gina-changes-between)", { buffer = true, nowait = true })
                vim.keymap.set("n", "C", "<Plug>(gina-commit-checkout)", { buffer = true, nowait = true })
                vim.keymap.set(
                    "n",
                    "}",
                    [[<Cmd>call search('\v%^<Bar>%$<Bar>^(.*\x{7})@!.*$', 'W')<CR>]],
                    { buffer = true, nowait = true }
                )
                vim.keymap.set(
                    "n",
                    "{",
                    [[<Cmd>call search('\v%^<Bar>%$<Bar>^(.*\x{7})@!.*$', 'Wb')<CR>]],
                    { buffer = true, nowait = true }
                )
            end,
        }

        vim.g["gina#command#blame#formatter#format"] = "%su%=|%au %ti %ma%in"

        vim.api.nvim_create_user_command("GinaBrowseYank", function(meta)
            vim.cmd(([[%d,%dGina browse --exact --yank :]]):format(meta.line1, meta.line2))
            vim.cmd [[
            let @+ = @"
            echo @+
        ]]
        end, { range = "%" })

        vim.api.nvim_create_user_command("GinaPrChanges", function(meta)
            local branch = meta.args
            if meta.args == "" then
                local base_ref = vim.trim(vim.fn.system "gh pr view --json baseRefName -q '.baseRefName'")
                if vim.startswith(base_ref, "no ") then
                    branch = vim.trim(vim.fn.system "git mom")
                else
                    branch = base_ref
                end
            end
            package.loaded.gitsigns.change_base(branch, true)
            vim.cmd(([[Gina changes %s...HEAD]]):format(branch))
        end, { nargs = "?" })
    end,
}
add { "https://github.com/lambdalisue/vim-protocol" }
-- add {
--     "lervag/vimtex",
--     config = function()
--         vim.g.tex_flavor = "latex"
--     end,
--     ft = { "tex" },
-- }
add {
    "https://github.com/lewis6991/gitsigns.nvim",
    lazy = false,
    config = function(_, opts)
        require("gitsigns").setup(opts)

        local function complete_branches(arglead, cmdline, cursorpos)
            local branches = vim.fn.systemlist { "git", "rev-parse", "--symbolic", "--branches", "--tags", "--remotes" }
            branches = vim.tbl_filter(function(cand)
                return vim.startswith(cand, arglead)
            end, branches)
            return branches
        end

        vim.api.nvim_create_user_command("GitsignsChangeBase", function(opts)
            local branch = "HEAD"
            if opts.fargs[1] ~= nil then
                branch = opts.fargs[1]
            else
                local branches = complete_branches ""
                for _, item in ipairs { "master", "main" } do
                    if vim.tbl_contains(branches, item) then
                        branch = item
                        break
                    end
                end
            end
            package.loaded.gitsigns.change_base(branch, true)
        end, {
            nargs = "*",
            complete = complete_branches,
        })
    end,
    opts = {
        signs = {
            add = { text = "║" },
            change = { text = "║" },
            delete = {},
            topdelete = {},
            changedelete = {
                text = "┋",
            },
        },
        signcolumn = false,
        numhl = true,
        linehl = false,
        word_diff = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "right_align",
            delay = 10,
            ignore_whitespace = true,
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "gj", function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return "<Ignore>"
            end, { expr = true })

            map("n", "gk", function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return "<Ignore>"
            end, { expr = true })

            -- Actions
            -- map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
            -- map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
            -- map("n", "<leader>hS", gs.stage_buffer)
            -- map("n", "<leader>hu", gs.undo_stage_hunk)
            -- map("n", "<leader>hR", gs.reset_buffer)

            map("n", "<Space>d", gs.preview_hunk)
            map("n", "@b", gs.toggle_current_line_blame)

            -- map("n", "<leader>hb", function()
            --     gs.blame_line { full = true }
            -- end)
            -- map("n", "<leader>tb", gs.toggle_current_line_blame)
            -- map("n", "<leader>hd", gs.diffthis)
            -- map("n", "<leader>hD", function()
            --     gs.diffthis "~"
            -- end)
            -- map("n", "<leader>td", gs.toggle_deleted)

            -- Text object
            -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
    },
}

add {
    "https://github.com/lifepillar/vim-colortemplate",
    cmd = { "Colortemplate" },
    ft = { "colortemplate" },
    config = function()
        vim.g.colortemplate_toolbar = 0
    end,
}
-- add {
--     "mattn/emmet-vim",
--     config = function()
--         vim.g["user_emmet_mode"] = "n"
--         vim.g["emmet_html5"] = 0
--         vim.g["user_emmet_install_global"] = 0
--     end,
-- }
add { "https://github.com/mattn/vim-maketable", cmd = { "MakeTable", "UnmakeTable" } }
add { "https://github.com/mbbill/undotree", keys = { { "U", "<Cmd>UndotreeToggle<CR>" } } }
add {
    "https://github.com/nvim-lualine/lualine.nvim",
    lazy = false,
    opts = {
        sections = {
            lualine_b = {
                function()
                    local bufname = vim.fn.bufname()
                    if bufname:find("oil://", 1, true) ~= nil then
                        local cwd = require("oil").get_current_dir()
                        local dir_rel = vim.fn.fnamemodify(cwd, ":.")
                        if vim.startswith(dir_rel, "/") then
                            return "[oil] " .. dir_rel
                        else
                            return "[oil] ./" .. dir_rel
                        end
                    end
                    local index = bufname:find("://", 1, true)
                    if index ~= nil then
                        return "[" .. bufname:sub(1, index - 1) .. "]"
                    end
                    return [[%f %m]]
                end,
            },
            lualine_c = {
                function()
                    -- table.insert(_G.debug_lualine, vim.fn["coc#status"]())
                    -- return vim.pesc(vim.fn["coc#status"]())
                    return (vim.fn["coc#status"]()):gsub("%%", "%%%%")
                end,
            },
            lualine_y = {
                function()
                    local branch = vim.fn["gina#component#repo#branch"]()
                    -- table.insert(_G.debug_lualine, branch)
                    local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                    if branch == "" then
                        return cwd
                    else
                        return cwd .. " │ " .. vim.fn["gina#component#repo#branch"]()
                    end
                end,
            },
            lualine_z = {
                function()
                    local n = #tostring(vim.fn.line "$")
                    n = math.max(n, 3)
                    return "%" .. n .. [[l/%-3L:%-2c]]
                end,
            },
        },
        -- winbar = {
        --     lualine_c = {'filename'},
        -- },
        -- inactive_winbar = {
        --     lualine_a = {},
        --     lualine_b = {},
        --     lualine_c = {'filename'},
        --     lualine_x = {},
        --     lualine_y = {},
        --     lualine_z = {}
        -- },
        options = {
            theme = "tomorrow",
            section_separators = { "", "" },
            component_separators = { "", "" },
            globalstatus = true,
            refresh = {
                statusline = 10000,
                -- statusline = 1000,
                tabline = 10000,
                winbar = 10000,
            },
        },
    },
}
add {
    "https://github.com/rhysd/rust-doc.vim",
    ft = "rust",
    config = function()
        vim.g["rust_doc#define_map_K"] = 0
    end,
}
add {
    "https://github.com/ryicoh/deepl.vim",
    keys = {
        {
            "@j",
            function()
                vim.fn["deepl#v"] "JA"
            end,
            mode = "x",
            desc = "DeepL translate to ja",
        },
        {
            "@e",
            function()
                vim.fn["deepl#v"] "EN"
            end,
            mode = "x",
            desc = "DeepL translate to en",
        },
    },
    enabled = function()
        return not (vim.fn.getenv "DEEPL_API_KEY" == vim.NIL)
    end,
    config = function()
        vim.g["deepl#endpoint"] = "https://api-free.deepl.com/v2/translate"
        vim.g["deepl#auth_key"] = vim.fn.getenv "DEEPL_API_KEY"
    end,
}

add {
    "https://github.com/numToStr/Comment.nvim",
    keys = {
        { ",", "<Plug>(comment_toggle_linewise)", mode = { "n" } },
        { ",", "<Plug>(comment_toggle_linewise_visual)", mode = { "x" } },
        { ",,", "<Plug>(comment_toggle_linewise)_", mode = { "n" } },
    },
    opts = {
        ---Add a space b/w comment and the line
        padding = true,
        -- ---Whether the cursor should stay at its position
        -- sticky = true,
        -- ---Lines to be ignored while (un)comment
        -- ignore = nil,
        mappings = {
            ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            basic = false,
            ---Extra mapping; `gco`, `gcO`, `gcA`
            extra = false,
        },
        -- ---Function to call before (un)comment
        -- pre_hook = nil,
        -- ---Function to call after (un)comment
        -- post_hook = nil,
    },
}

add { "https://github.com/thinca/vim-qfreplace", ft = { "qf" } }
-- add { "https://github.com/thinca/vim-quickrun" }
add { "https://github.com/tyru/capture.vim", cmd = { "Capture" } }
add {
    "https://github.com/tyru/open-browser.vim",
    keys = {
        { "gb", "<Plug>(openbrowser-smart-search)", mode = { "n", "x" } },
    },
}
add {
    "https://github.com/uga-rosa/ccc.nvim",
    cmd = { "CccHighlighterEnable" },
}
add {
    "https://github.com/stevearc/aerial.nvim",
    dependencies = { "https://github.com/kyazdani42/nvim-web-devicons" },
    lazy = false,
    keys = {
        {
            "<Space>t",
            function()
                local aerial = require "aerial"
                aerial.toggle { focus = false }
            end,
        },
        {
            "<Space>i",
            function()
                local aerial = require "aerial"
                -- aerial.open { focus = false }
                aerial.focus()
            end,
        },
    },
    opts = {
        -- Priority list of preferred backends for aerial.
        -- This can be a filetype map (see :help aerial-filetype-map)
        backends = {
            "treesitter",
            -- "lsp",
            "markdown",
            "man",
        },

        layout = {
            -- These control the width of the aerial window.
            -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- min_width and max_width can be a list of mixed types.
            -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
            max_width = { 40, 0.3 },
            width = nil,
            min_width = 20,

            -- key-value pairs of window-local options for aerial window (e.g. winhl)
            win_opts = {
                winblend = 30,
            },

            -- Determines the default direction to open the aerial window. The 'prefer'
            -- options will open the window in the other direction *if* there is a
            -- different buffer in the way of the preferred direction
            -- Enum: prefer_right, prefer_left, right, left, float
            default_direction = "float",

            -- Determines where the aerial window will be opened
            --   edge   - open aerial at the far right/left of the editor
            --   window - open aerial to the right/left of the current window
            placement = "window",
        },

        -- -- Determines how the aerial window decides which buffer to display symbols for
        -- --   window - aerial window will display symbols for the buffer in the window from which it was opened
        -- --   global - aerial window will display symbols for the current window
        attach_mode = "window",
        --
        -- -- List of enum values that configure when to auto-close the aerial window
        -- --   unfocus       - close aerial when you leave the original source window
        -- --   switch_buffer - close aerial when you change buffers in the source window
        -- --   unsupported   - close aerial when attaching to a buffer that has no symbol source
        -- close_automatic_events = {},
        close_automatic_events = {
            "unfocus",
            "switch_buffer",
            "unsupported",
        },
        --
        -- -- Keymaps in aerial window. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        -- -- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
        -- -- Additionally, if it is a string that matches "aerial.<name>",
        -- -- it will use the mapping at require("aerial.action").<name>
        -- -- Set to `false` to remove a keymap
        -- keymaps = {
        --     ["?"] = "actions.show_help",
        --     ["g?"] = "actions.show_help",
        --     ["<CR>"] = "actions.jump",
        --     ["<2-LeftMouse>"] = "actions.jump",
        --     ["<C-v>"] = "actions.jump_vsplit",
        --     ["<C-s>"] = "actions.jump_split",
        --     ["p"] = "actions.scroll",
        --     ["<C-j>"] = "actions.down_and_scroll",
        --     ["<C-k>"] = "actions.up_and_scroll",
        --     ["{"] = "actions.prev",
        --     ["}"] = "actions.next",
        --     ["[["] = "actions.prev_up",
        --     ["]]"] = "actions.next_up",
        --     ["q"] = "actions.close",
        --     ["o"] = "actions.tree_toggle",
        --     ["za"] = "actions.tree_toggle",
        --     ["O"] = "actions.tree_toggle_recursive",
        --     ["zA"] = "actions.tree_toggle_recursive",
        --     ["l"] = "actions.tree_open",
        --     ["zo"] = "actions.tree_open",
        --     ["L"] = "actions.tree_open_recursive",
        --     ["zO"] = "actions.tree_open_recursive",
        --     ["h"] = "actions.tree_close",
        --     ["zc"] = "actions.tree_close",
        --     ["H"] = "actions.tree_close_recursive",
        --     ["zC"] = "actions.tree_close_recursive",
        --     ["zr"] = "actions.tree_increase_fold_level",
        --     ["zR"] = "actions.tree_open_all",
        --     ["zm"] = "actions.tree_decrease_fold_level",
        --     ["zM"] = "actions.tree_close_all",
        --     ["zx"] = "actions.tree_sync_folds",
        --     ["zX"] = "actions.tree_sync_folds",
        -- },
        --
        -- -- When true, don't load aerial until a command or function is called
        -- -- Defaults to true, unless `on_attach` is provided, then it defaults to false
        -- lazy_load = true,

        -- Disable aerial on files with this many lines
        disable_max_lines = 100000,

        -- Disable aerial on files this size or larger (in bytes)
        disable_max_size = 2000000, -- Default 2MB

        -- A list of all symbols to display. Set to false to display all symbols.
        -- This can be a filetype map (see :help aerial-filetype-map)
        -- To see all available values, see :help SymbolKind
        filter_kind = {
            "Class",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Module",
            "Method",
            "Struct",
        },

        -- -- Determines line highlighting mode when multiple splits are visible.
        -- -- split_width   Each open window will have its cursor location marked in the
        -- --               aerial buffer. Each line will only be partially highlighted
        -- --               to indicate which window is at that location.
        -- -- full_width    Each open window will have its cursor location marked as a
        -- --               full-width highlight in the aerial buffer.
        -- -- last          Only the most-recently focused window will have its location
        -- --               marked in the aerial buffer.
        -- -- none          Do not show the cursor locations in the aerial window.
        highlight_mode = "last",

        -- -- Highlight the closest symbol if the cursor is not exactly on one.
        -- highlight_closest = true,
        --
        -- -- Highlight the symbol in the source buffer when cursor is in the aerial win
        -- highlight_on_hover = false,
        --
        -- -- When jumping to a symbol, highlight the line for this many ms.
        -- -- Set to false to disable
        -- highlight_on_jump = 300,
        --
        -- -- Define symbol icons. You can also specify "<Symbol>Collapsed" to change the
        -- -- icon when the tree is collapsed at that symbol, or "Collapsed" to specify a
        -- -- default collapsed icon. The default icon set is determined by the
        -- -- "nerd_font" option below.
        -- -- If you have lspkind-nvim installed, it will be the default icon set.
        -- -- This can be a filetype map (see :help aerial-filetype-map)
        -- icons = {},
        --
        -- -- Control which windows and buffers aerial should ignore.
        -- -- If attach_mode is "global", focusing an ignored window/buffer will
        -- -- not cause the aerial window to update.
        -- -- If open_automatic is true, focusing an ignored window/buffer will not
        -- -- cause an aerial window to open.
        -- -- If open_automatic is a function, ignore rules have no effect on aerial
        -- -- window opening behavior; it's entirely handled by the open_automatic
        -- -- function.
        -- ignore = {
        --     -- Ignore unlisted buffers. See :help buflisted
        --     unlisted_buffers = true,
        --
        --     -- List of filetypes to ignore.
        --     filetypes = {},
        --
        --     -- Ignored buftypes.
        --     -- Can be one of the following:
        --     -- false or nil - No buftypes are ignored.
        --     -- "special"    - All buffers other than normal buffers are ignored.
        --     -- table        - A list of buftypes to ignore. See :help buftype for the
        --     --                possible values.
        --     -- function     - A function that returns true if the buffer should be
        --     --                ignored or false if it should not be ignored.
        --     --                Takes two arguments, `bufnr` and `buftype`.
        --     buftypes = "special",
        --
        --     -- Ignored wintypes.
        --     -- Can be one of the following:
        --     -- false or nil - No wintypes are ignored.
        --     -- "special"    - All windows other than normal windows are ignored.
        --     -- table        - A list of wintypes to ignore. See :help win_gettype() for the
        --     --                possible values.
        --     -- function     - A function that returns true if the window should be
        --     --                ignored or false if it should not be ignored.
        --     --                Takes two arguments, `winid` and `wintype`.
        --     wintypes = "special",
        -- },

        -- Use symbol tree for folding. Set to true or false to enable/disable
        -- Set to "auto" to manage folds if your previous foldmethod was 'manual'
        -- This can be a filetype map (see :help aerial-filetype-map)
        -- manage_folds = "auto",
        manage_folds = false,

        -- When you fold code with za, zo, or zc, update the aerial tree as well.
        -- Only works when manage_folds = true
        link_folds_to_tree = false,

        -- Fold code when you open/collapse symbols in the tree.
        -- Only works when manage_folds = true
        link_tree_to_folds = true,

        -- -- Set default symbol icons to use patched font icons (see https://www.nerdfonts.com/)
        -- -- "auto" will set it to true if nvim-web-devicons or lspkind-nvim is installed.
        nerd_font = true,
        --
        -- -- Call this function when aerial attaches to a buffer.
        -- on_attach = function(bufnr) end,
        --
        -- -- Call this function when aerial first sets symbols on a buffer.
        -- on_first_symbols = function(bufnr) end,
        --
        -- -- Automatically open aerial when entering supported buffers.
        -- -- This can be a function (see :help aerial-open-automatic)
        -- open_automatic = false,
        open_automatic = function()
            local aerial = require "aerial"
            return aerial.num_symbols() > 1 and not aerial.was_closed()
        end,

        --
        -- -- Run this command after jumping to a symbol (false will disable)
        -- post_jump_cmd = "normal! zz",
        --
        -- -- When true, aerial will automatically close after jumping to a symbol
        close_on_select = false,
        --
        -- -- The autocmds that trigger symbols update (not used for LSP backend)
        -- update_events = "TextChanged,InsertLeave",
        --
        -- -- Show box drawing characters for the tree hierarchy
        show_guides = true,
        --
        -- -- Customize the characters used when show_guides = true
        -- guides = {
        --     -- When the child item has a sibling below it
        --     mid_item = "├─",
        --     -- When the child item is the last in the list
        --     last_item = "└─",
        --     -- When there are nested child guides to the right
        --     nested_top = "│ ",
        --     -- Raw indentation
        --     whitespace = "  ",
        -- },

        -- Options for opening aerial in a floating win
        float = {
            -- Controls border appearance. Passed to nvim_open_win
            border = "rounded",

            -- Determines location of floating window
            --   cursor - Opens float on top of the cursor
            --   editor - Opens float centered in the editor
            --   win    - Opens float centered in the window
            relative = "win",

            -- These control the height of the floating window.
            -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- min_height and max_height can be a list of mixed types.
            -- min_height = {8, 0.1} means "the greater of 8 rows or 10% of total"
            max_height = 0.4,
            height = nil,
            min_height = 8,

            override = function(conf, source_winid)
                -- This is the config that will be passed to nvim_open_win.
                -- Change values here to customize the layout

                -- vim.print { conf = conf, source_winid = source_winid }

                -- telescope の floating window の下に出るようにする
                conf.zindex = 49
                conf.anchor = "SE"
                conf.col = vim.fn.winwidth(source_winid)
                conf.row = vim.fn.winheight(source_winid)
                return conf
            end,
        },

        -- lsp = {
        --     -- Fetch document symbols when LSP diagnostics update.
        --     -- If false, will update on buffer changes.
        --     diagnostics_trigger_update = true,
        --
        --     -- Set to false to not update the symbols when there are LSP errors
        --     update_when_errors = true,
        --
        --     -- How long to wait (in ms) after a buffer change before updating
        --     -- Only used when diagnostics_trigger_update = false
        --     update_delay = 300,
        -- },
        --
        -- treesitter = {
        --     -- How long to wait (in ms) after a buffer change before updating
        --     update_delay = 300,
        -- },
        --
        -- markdown = {
        --     -- How long to wait (in ms) after a buffer change before updating
        --     update_delay = 300,
        -- },
        --
        -- man = {
        --     -- How long to wait (in ms) after a buffer change before updating
        --     update_delay = 300,
        -- },
    },
}
add {
    "https://github.com/stevearc/oil.nvim",
    keys = {
        { "gf" },
        {
            -- よしなに開く。
            "sf",
            function()
                local bufname = vim.api.nvim_buf_get_name(0)
                if bufname:find "://" then
                    -- 特殊なバッファなので cwd にする
                    require("oil").open(vim.fn.getcwd())
                else
                    local dir_rel = vim.fn.fnamemodify(bufname, ":.")
                    if vim.startswith(dir_rel, "/") then
                        require("oil").open(vim.fn.getcwd())
                    else
                        require("oil").open()
                    end
                end
            end,
        },
        {
            -- 開いているバッファのあるディレクトリを開く。
            "sF",
            function()
                local bufname = vim.api.nvim_buf_get_name(0)
                if bufname:find "://" then
                    -- 特殊なバッファなので cwd にする
                    require("oil").open(vim.fn.getcwd())
                else
                    -- デフォルトの挙動に fallback
                    require("oil").open()
                end
            end,
        },
        {
            -- カレントディレクトリを開く。
            "sc",
            function()
                require("oil").open(vim.fn.getcwd())
            end,
        },
    },
    cmd = {
        "Oil",
    },
    config = function()
        local oil = require "oil"

        local sort_rules = {
            {
                sort = {
                    { "type", "asc" },
                    { "name", "asc" },
                },
                columns = {
                    "icon",
                },
            },
            {
                sort = {
                    { "type", "asc" },
                    { "mtime", "desc" },
                    { "name", "asc" },
                },
                columns = {
                    { "mtime", format = "%Y-%m-%d %H:%M:%S", highlight = "@number" },
                    "icon",
                },
            },
        }
        local default_rule_idx = 1

        local function change_sort_by_rule()
            default_rule_idx = default_rule_idx % #sort_rules + 1
            local rule = sort_rules[default_rule_idx]
            oil.set_columns(rule.columns)
            oil.set_sort(rule.sort)
        end

        require("oil").setup {
            -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
            -- Set to false if you still want to use netrw.
            default_file_explorer = true,
            -- Id is automatically added at the beginning, and name at the end
            -- See :help oil-columns
            columns = {
                -- { "mtime", format = "%m/%d %H:%M", highlight = "@field" },
                "icon",
                -- "permissions",
                -- "size",
                -- "mtime",
            },
            -- Buffer-local options to use for oil buffers
            buf_options = {
                buflisted = true,
                bufhidden = "hide",
            },
            -- Window-local options to use for oil buffers
            win_options = {
                wrap = false,
                signcolumn = "no",
                cursorcolumn = false,
                foldcolumn = "0",
                spell = false,
                list = false,
                conceallevel = 3,
                concealcursor = "nvic",
            },
            -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
            delete_to_trash = true,
            -- Skip the confirmation popup for simple operations
            skip_confirm_for_simple_edits = false,
            -- Change this to customize the command used when deleting to trash
            trash_command = "trash-put",
            -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
            prompt_save_on_select_new_entry = true,
            -- Oil will automatically delete hidden buffers after this delay
            -- You can set the delay to false to disable cleanup entirely
            -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
            cleanup_delay_ms = 2000,
            -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
            -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
            -- Additionally, if it is a string that matches "actions.<name>",
            -- it will use the mapping at require("oil.actions").<name>
            -- Set to `false` to remove a keymap
            -- See :help oil-actions for a list of all available actions
            keymaps = {
                ["?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-p>"] = "actions.preview",
                ["M"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                -- ["<C-l>"] = "actions.refresh",
                ["H"] = "actions.parent",
                ["L"] = {
                    callback = function()
                        local actions = require "oil.actions"
                        local entry = require("oil").get_cursor_entry()
                        local preview_win = require("oil.util").get_preview_win()

                        if entry == nil then
                            return
                        end

                        local is_dir_or_dirlink = entry.type == "directory"
                            or (entry.type == "link" and entry.meta.link_stat.type == "directory")

                        if not is_dir_or_dirlink then
                            return
                        end

                        actions.select.callback()

                        if preview_win ~= nil then
                            -- actions.select の時点で preview が消えてしまうため、
                            -- preview が出ていたときは preview window を出しなおす
                            actions.preview.callback()
                        end
                    end,
                    desc = "Right move",
                },
                ["gs"] = {
                    callback = change_sort_by_rule,
                    desc = "Change sort by pre-defined rules",
                },
                ["gS"] = "actions.change_sort",
                ["<Space><CR>"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
            },
            -- Set to false to disable all of the above keymaps
            use_default_keymaps = false,
            view_options = {
                -- Show files and directories that start with "."
                show_hidden = false,
                -- This function defines what is considered a "hidden" file
                is_hidden_file = function(name, bufnr)
                    return vim.tbl_contains({
                        "__pycache__",
                        ".mypy_cache",
                        ".pytest_cache",
                        ".ruff_cache",
                        ".DS_Store",
                    }, name)
                end,
                -- This function defines what will never be shown, even when `show_hidden` is set
                is_always_hidden = function(name, bufnr)
                    return false
                end,
                sort = {
                    -- sort order can be "asc" or "desc"
                    -- see :help oil-columns to see which columns are sortable
                    { "type", "asc" },
                    { "name", "asc" },
                },
            },
            -- Configuration for the floating window in oil.open_float
            float = {
                -- Padding around the floating window
                padding = 2,
                max_width = 0,
                max_height = 0,
                border = "rounded",
                win_options = {
                    winblend = 0,
                },
                -- This is the config that will be passed to nvim_open_win.
                -- Change values here to customize the layout
                override = function(conf)
                    return conf
                end,
            },
            -- Configuration for the actions floating preview window
            preview = {
                -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                -- min_width and max_width can be a single value or a list of mixed integer/float types.
                -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
                max_width = 0.9,
                -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
                min_width = { 40, 0.4 },
                -- optionally define an integer/float for the exact width of the preview window
                width = nil,
                -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                -- min_height and max_height can be a single value or a list of mixed integer/float types.
                -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
                max_height = 0.9,
                -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
                min_height = { 5, 0.1 },
                -- optionally define an integer/float for the exact height of the preview window
                height = nil,
                border = "rounded",
                win_options = {
                    winblend = 0,
                },
            },
            -- Configuration for the floating progress window
            progress = {
                max_width = 0.9,
                min_width = { 40, 0.4 },
                width = nil,
                max_height = { 10, 0.9 },
                min_height = { 5, 0.1 },
                height = nil,
                border = "rounded",
                minimized_border = "none",
                win_options = {
                    winblend = 0,
                },
            },
        }
        -- vim.api.nvim_create_autocmd("User", {
        --     pattern = "OilEnter",
        --     callback = vim.schedule_wrap(function(args)
        --         local oil = require "oil"
        --         if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
        --             oil.select { preview = true }
        --         end
        --     end),
        -- })
    end,
}
add {
    "https://github.com/thinca/vim-partedit",
    cmd = {
        "ParteditCodeblock",
    },
    config = function()
        vim.g["partedit#opener"] = ":vsplit"
        vim.g["partedit#prefix_pattern"] = [[\v\s*]]

        util.create_cmd("ParteditCodeblock", function(meta)
            local line_codeblock_start = vim.fn.getline(meta.line1 - 1)
            local filetype = vim.fn.matchstr(line_codeblock_start, [[\v```\zs[-a-zA-Z0-9]+\ze]])
            local options = { filetype = filetype }
            vim.fn["partedit#start"](meta.line1, meta.line2, options)
        end, { range = true })
    end,
}

-- add { "https://github.com/atusy/tsnode-marker.nvim" }

-- colorscheme
add {
    "https://github.com/habamax/vim-gruvbit",
    lazy = false,
    config = function()
        vim.g.gruvbit_transp_bg = 0

        util.autocmd_vimrc { "ColorScheme" } {
            pattern = "gruvbit",
            callback = function()
                -- basic
                util.sethl "FoldColumn" { bg = "#303030" }
                util.sethl "NonText" { fg = "#496da9" }
                util.sethl "Todo" { bold = true, bg = "#444444", fg = "#c6b7a2" }

                util.sethl "VertSplit" { fg = "#c8c8c8", bg = "None", default = false }
                util.sethl "Visual" { bg = "#4d564e" }
                util.sethl "Pmenu" { bg = "#404064" }
                util.sethl "QuickFixLine" { bg = "#4d569e" }

                util.sethl "DiffChange" { bg = "#314a5c" }
                util.sethl "DiffDelete" { bg = "#5c3728", fg = "#968772" }
                util.sethl "MatchParen" { bg = "#51547d", fg = "#ebdbb2" }

                util.sethl "LineNr" { fg = "#968772", bg = "#2a2a2a" }

                vim.api.nvim_set_hl(0, "TSNodeMarker", { bg = "#243243" })

                -- coc.nvim
                util.sethl "CocInlayHint" { bg = "#444444", fg = "#90816c", italic = true }
                -- util.sethl "CocHintFloat" { bg = "#444444", fg = "#45daef" }
                util.sethl "CocRustChainingHint" { link = "CocInlayHint" }
                util.sethl "CocSearch" { fg = "#fabd2f" }
                util.sethl "CocMenuSel" { bg = "#604054" }

                -- custom highlight name
                util.sethl "WeakTitle" { fg = "#fad57f" }
                util.sethl "Quote" { fg = "#c6b7a2" }
                util.sethl "VisualBlue" { bg = "#4d569e" }
                util.sethl "FernIndentMarkers" { fg = "#707070" }

                -- gitsigns
                util.sethl "GitSignsAdd" { fg = "#98971a", bg = "None" }
                util.sethl "GitSignsChange" { fg = "#458588", bg = "None" }
                util.sethl "GitSignsDelete" { fg = "#cc241d", bg = "None" }
                -- util.sethl "GitSignsAddNr" { fg = "#88870a", bg = "None" }
                -- util.sethl "GitSignsChangeNr" { fg = "#357578", bg = "None" }
                -- util.sethl "GitSignsDeleteNr" { fg = "#bc140d", bg = "None" }
                util.sethl "GitSignsAddNr" { bg = "#3b5e48", fg = "#968772" }
                util.sethl "GitSignsChangeNr" { bg = "#314a5c", fg = "#968772" }
                util.sethl "GitSignsDeleteNr" { link = "DiffDelete" } -- #5c3728
                util.sethl "GitSignsChangeDeleteNr" { bg = "#5c3a5c", fg = "#968772" }
                util.sethl "GitSignsAddLn" { bg = "#122712" }
                util.sethl "GitSignsChangeLn" { bg = "#112030" }
                util.sethl "GitSignsDeleteLn" { bg = "#291308" }

                -- nvim-treesitter
                util.sethl "TSParameter" { fg = "#b3d5c8" }
                util.sethl "TSField" { fg = "#b3d5c8" }

                util.sethl "rustCommentLineDoc" { fg = "#9e8f7a", bold = true }

                util.sethl "@comment" { link = "Comment" }
                util.sethl "@comment.doccomment" { link = "rustCommentLineDoc" }

                util.sethl "@attribute" { link = "PreProc" }
                util.sethl "@boolean" { link = "Boolean" }
                util.sethl "@character" { link = "Character" }
                util.sethl "@character.special" { link = "SpecialChar" }
                util.sethl "@conditional" { link = "Conditional" }
                util.sethl "@constant" { link = "Constant" }
                util.sethl "@constant.builtin" { link = "Special" }
                util.sethl "@constant.macro" { link = "Define" }
                util.sethl "@constructor" { link = "Special" }
                util.sethl "@debug" { link = "Debug" }
                util.sethl "@define" { link = "Define" }
                util.sethl "@exception" { link = "Exception" }
                util.sethl "@field" { link = "TSField" }
                util.sethl "@float" { link = "Float" }
                util.sethl "@function" { link = "Function" }
                util.sethl "@function.builtin" { link = "Special" }
                util.sethl "@function.call" { link = "Function" }
                util.sethl "@function.macro" { link = "Macro" }
                util.sethl "@include" { link = "Include" }
                util.sethl "@keyword" { link = "Keyword" }
                util.sethl "@label" { link = "Label" }
                util.sethl "@method" { link = "Function" }
                util.sethl "@method.call" { link = "Function" }
                util.sethl "@namespace" { link = "Include" }
                util.sethl "@none" { bg = "NONE", fg = "NONE" }
                util.sethl "@number" { link = "Number" }
                util.sethl "@operator" { link = "Operator" }
                util.sethl "@parameter" { link = "TSParameter" }
                util.sethl "@preproc" { link = "PreProc" }
                util.sethl "@property" { link = "Function" }
                util.sethl "@punctuation" { link = "Delimiter" }
                util.sethl "@repeat" { link = "Repeat" }
                util.sethl "@storageclass" { link = "StorageClass" }
                util.sethl "@string" { link = "String" }
                util.sethl "@string.escape" { link = "SpecialChar" }
                util.sethl "@string.regex" { link = "String" }
                util.sethl "@string.special" { link = "SpecialChar" }
                util.sethl "@symbol" { link = "Identifier" }
                util.sethl "@tag" { link = "Tag" }
                util.sethl "@tag.attribute" { link = "Identifier" }
                util.sethl "@tag.delimiter" { link = "Delimiter" }
                util.sethl "@text" { link = "Normal" }
                util.sethl "@text.danger" { link = "ErrorMsg" }
                util.sethl "@text.diff.add" { link = "DiffAdd" }
                util.sethl "@text.diff.change" { link = "DiffChange" }
                util.sethl "@text.diff.delete" { link = "DiffDelete" }
                util.sethl "@text.diff.addsign" { link = "@string" }
                util.sethl "@text.diff.delsign" { link = "@type" }
                util.sethl "@text.emphasis" { italic = true }
                util.sethl "@text.environment" { link = "Macro" }
                util.sethl "@text.environment.name" { link = "Type" }
                util.sethl "@text.literal" { link = "String" }
                util.sethl "@text.math" { link = "Special" }
                util.sethl "@text.note" { link = "SpecialComment" }
                util.sethl "@text.quote" { link = "Quote" }
                util.sethl "@text.reference" { link = "Constant" }
                util.sethl "@text.strike" { strikethrough = true }
                util.sethl "@text.strong" { bold = true }
                util.sethl "@text.title" { link = "Title" }
                util.sethl "@text.title.weak" { link = "WeakTitle" }
                util.sethl "@text.todo" { link = "Todo" }
                util.sethl "@text.underline" { underline = true }
                util.sethl "@text.uri" { link = "Underlined" }
                util.sethl "@text.warning" { link = "WarningMsg" }
                util.sethl "@type" { link = "Type" }
                util.sethl "@type.builtin" { link = "Type" }
                util.sethl "@type.definition" { link = "Typedef" }
                util.sethl "@type.qualifier" { link = "Type" }
                util.sethl "@variable" { link = "Normal" }
                util.sethl "@variable.builtin" { link = "Special" }

                util.sethl "@text.diff.indicator" { bg = "#555555" }
            end,
        }
    end,
}
add { "https://github.com/yasukotelin/shirotelin", lazy = true }

-- paren
add {
    "https://github.com/cohama/lexima.vim",
    event = "InsertEnter",
    config = function()
        vim.g["lexima_no_default_rules"] = 1
        vim.g["lexima_enable_space_rules"] = 0
        vim.fn["lexima#set_default_rules"]()

        -- シングルクォート補完の無効化
        vim.fn["lexima#add_rule"] {
            filetype = { "latex", "tex", "satysfi" },
            char = "'",
            input = "'",
        }

        vim.fn["lexima#add_rule"] {
            char = "{",
            at = [=[\%#[-0-9a-zA-Z_]]=],
            input = "{",
        }

        -- TeX/LaTeX
        vim.fn["lexima#add_rule"] {
            filetype = { "latex", "tex" },
            char = "{",
            input = "{",
            at = [[\%#\\]],
        }
        vim.fn["lexima#add_rule"] {
            filetype = { "latex", "tex" },
            char = "$",
            input_after = "$",
        }
        vim.fn["lexima#add_rule"] {
            filetype = { "latex", "tex" },
            char = "$",
            at = [[$\%#\$]],
            leave = 1,
        }
        vim.fn["lexima#add_rule"] {
            filetype = { "latex", "tex" },
            char = "<BS>",
            at = [[\$\%#\$]],
            leave = 1,
        }

        -- SATySFi
        vim.fn["lexima#add_rule"] {
            filetype = { "satysfi" },
            char = "$",
            input = "${",
            input_after = "}",
        }
        vim.fn["lexima#add_rule"] {
            filetype = { "satysfi" },
            char = "$",
            at = [[\\\%#]],
            leave = 1,
        }

        -- reST
        vim.fn["lexima#add_rule"] {
            filetype = { "rst" },
            char = "``",
            input_after = "``",
        }

        -- なぜかうまくいかない
        -- vim.keymap.set("i", "<CR>", function ()
        --     if vim.fn.pumvisible() ~= 0 then
        --         return [[<C-y>]]
        --     else
        --         return [[<C-g>u]] .. vim.fn["lexima#expand"]("<CR>", "i")
        --     end
        -- end, {expr = true, silent = true})

        -- coc#_select_confirm などは Lua 上では動かないので、 <Plug> にマッピングして使えるようにする
        vim.cmd [[
            inoremap <expr> <Plug>(vimrc-coc-select-confirm) coc#_select_confirm()
            inoremap <expr> <Plug>(vimrc-lexima-expand-cr) lexima#expand('<LT>CR>', 'i')
        ]]

        vim.keymap.set("i", "<CR>", function()
            if util.to_bool(vim.fn["coc#pum#visible"]()) then
                -- 補完候補をセレクトしていたときのみ、補完候補の内容で確定する
                -- （意図せず補完候補がセレクトされてしまうのを抑止）
                if vim.fn["coc#pum#info"]()["index"] >= 0 then
                    return vim.api.nvim_replace_termcodes(vim.fn["coc#pum#confirm"](), true, true, true)
                end
                return vim.fn.keytrans(vim.fn["lexima#expand"]("<CR>", "i"))
            end
            return vim.fn.keytrans(vim.fn["lexima#expand"]("<CR>", "i"))
        end, { expr = true, remap = true })
    end,
}

add {
    "https://github.com/machakann/vim-sandwich",
    keys = {
        { "sa", mode = { "n", "x" } },
        { "ib", mode = { "x", "o" } },
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

        vim.cmd [[
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

        ]]

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

        local recipe_link = {
            { filetype = { "rst" }, input = { "l" }, buns = { "`", " <>`_" }, nesting = 0 },
            { filetype = { "rst" }, input = { "L" }, buns = { "` <", ">`_" }, nesting = 0 },
            { filetype = { "markdown", "obsidian" }, input = { "l" }, buns = { "[", "]()" }, nesting = 0 },
            { filetype = { "markdown", "obsidian" }, input = { "L" }, buns = { "[](", ")" }, nesting = 0 },
        }

        local recipe_codeblock = {
            {
                filetype = { "markdown", "obsidian" },
                input = { "c" },
                buns = { "```", "```" },
                kind = { "add" },
                linewise = 1,
                command = { [[']s/^\s*//]] },
            },
            {
                filetype = { "markdown", "obsidian" },
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
                external = { "i<", vim.api.nvim_eval [["\<Plug>(textobj-functioncall-generics-a)"]] },
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
                input = { "c" },
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
-- add {
--     "andymass/vim-matchup",
--     -- keys = {
--     --     { "<Space>m", "<Plug>(matchup-%)" },
--     -- },
--     config = function()
--         vim.g["matchup_matchparen_offscreen"] = {}
--     end,
-- }

-- textedit
add {
    "https://github.com/kana/vim-operator-replace",
    dependencies = { "https://github.com/kana/vim-operator-user" },
    keys = {
        { "R", "<Plug>(operator-replace)" },
        { "RR", "<Plug>(operator-replace)_" },
        { "<Space>R", [["+<Plug>(operator-replace)]] },
    },
}

add {
    "https://github.com/bps/vim-textobj-python",
    dependencies = { "https://github.com/kana/vim-textobj-user" },
    ft = { "python" },
}
add {
    "https://github.com/glts/vim-textobj-comment",
    dependencies = { "https://github.com/kana/vim-textobj-user" },
    keys = {
        { "im", "<Plug>(textobj-comment-i)", mode = { "x", "o" } },
        { "am", "<Plug>(textobj-comment-a)", mode = { "x", "o" } },
    },
    config = function()
        vim.g["textobj_comment_no_default_key_mappings"] = 1
    end,
}
add {
    "https://github.com/kana/vim-textobj-entire",
    dependencies = { "https://github.com/kana/vim-textobj-user" },
    keys = {
        { "ie", mode = { "x", "o" } },
        { "yie", "y<Plug>(textobj-entire-i)<C-o>" },
        { "yae", "y<Plug>(textobj-entire-a)<C-o>" },
        { "=ie", "=<Plug>(textobj-entire-i)<C-o>" },
        { "=ae", "=<Plug>(textobj-entire-a)<C-o>" },
        { "<ie", "<<Plug>(textobj-entire-i)<C-o>" },
        { "<ae", "<<Plug>(textobj-entire-a)<C-o>" },
        { ">ie", "><Plug>(textobj-entire-i)<C-o>" },
        { ">ae", "><Plug>(textobj-entire-a)<C-o>" },
    },
}
add {
    "https://github.com/machakann/vim-textobj-functioncall",
    dependencies = { "https://github.com/kana/vim-textobj-user" },
    keys = {
        {
            "<Plug>(textobj-functioncall-generics-i)",
            ":<C-u>call textobj#functioncall#ip('o', g:textobj_functioncall_generics_patterns)<CR>",
            mode = "o",
            silent = true,
        },
        {
            "<Plug>(textobj-functioncall-generics-i)",
            ":<C-u>call textobj#functioncall#ip('x', g:textobj_functioncall_generics_patterns)<CR>",
            mode = "x",
            silent = true,
        },
        {
            "<Plug>(textobj-functioncall-generics-a)",
            ":<C-u>call textobj#functioncall#i('o', g:textobj_functioncall_generics_patterns)<CR>",
            mode = "o",
            silent = true,
        },
        {
            "<Plug>(textobj-functioncall-generics-a)",
            ":<C-u>call textobj#functioncall#i('x', g:textobj_functioncall_generics_patterns)<CR>",
            mode = "x",
            silent = true,
        },
    },
    config = function()
        vim.g["textobj_functioncall_no_default_key_mappings"] = 1
        vim.g["textobj_functioncall_generics_patterns"] = {
            {
                header = [[\<\%(\h\k*\.\)*\h\k*]],
                bra = "<",
                ket = ">",
                footer = "",
            },
        }
    end,
}
add {
    "https://github.com/kana/vim-textobj-user",
    -- まあまあ面倒くさいからいいや
    -- keys = {
    --     {"il", mode = {"x", "o"}},
    --     {"al", mode = {"x", "o"}},
    -- },
    config = function()
        vim.fn["textobj#user#plugin"]("line", {
            ["-"] = {
                ["select-a-function"] = "CurrentLineA",
                ["select-a"] = "al",
                ["select-i-function"] = "CurrentLineI",
                ["select-i"] = "il",
            },
        })

        -- function vim.fn.CurrentLineA()
        --     vim.cmd [[ normal! 0 ]]
        --     local head_pos = vim.fn.getpos "."
        --     vim.cmd [[ normal! $ ]]
        --     local tail_pos = vim.fn.getpos "."
        --     return { "v", head_pos, tail_pos }
        -- end
        --
        -- function vim.fn.CurrentLineI()
        --     vim.cmd [[ normal! ^ ]]
        --     local head_pos = vim.fn.getpos "."
        --     vim.cmd [[ normal! g_ ]]
        --     local tail_pos = vim.fn.getpos "."
        --     return { "v", head_pos, tail_pos }
        -- end

        vim.cmd [[
            function! CurrentLineA()
              normal! 0
              let head_pos = getpos('.')
              normal! $
              let tail_pos = getpos('.')
              return ['v', head_pos, tail_pos]
            endfunction

            function! CurrentLineI()
              normal! ^
              let head_pos = getpos('.')
              normal! g_
              let tail_pos = getpos('.')
              let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
              return
              \ non_blank_char_exists_p
              \ ? ['v', head_pos, tail_pos]
              \ : 0
            endfunction
        ]]

        vim.fn["textobj#user#plugin"]("jbraces", {
            parens = {
                pattern = { "（", "）" },
                ["select-a"] = "aj)",
                ["select-i"] = "ij)",
            },
            braces = {
                pattern = { "「", "」" },
                ["select-a"] = "aj]",
                ["select-i"] = "ij]",
            },
            double_braces = {
                pattern = { "『", "』" },
                ["select-a"] = "aj}",
                ["select-i"] = "ij}",
            },
            lenticular_bracket = {
                pattern = { "【", "】" },
                ["select-a"] = "aj>",
                ["select-i"] = "ij>",
            },
        })

        util.autocmd_vimrc "FileType" {
            pattern = "tex",
            callback = function()
                vim.fn["textobj#user#plugin"]("texquote", {
                    single = {
                        pattern = { "`", "'" },
                        ["select-a"] = "aq",
                        ["select-i"] = "iq",
                    },
                    double = {
                        pattern = { "``", "''" },
                        ["select-a"] = "aQ",
                        ["select-i"] = "iQ",
                    },
                })
            end,
        }

        util.autocmd_vimrc "FileType" {
            pattern = "satysfi",
            callback = function()
                vim.fn["textobj#user#plugin"]("satyblock", {
                    block = {
                        pattern = { "<%", ">%" },
                        ["select-a"] = "a>",
                        ["select-i"] = "i>",
                    },
                })
            end,
        }
    end,
}

add {
    "https://github.com/machakann/vim-swap",
    keys = {
        "gs",
        { "i,", "<Plug>(swap-textobject-i)", mode = { "x", "o" } },
        { "a,", "<Plug>(swap-textobject-a)", mode = { "x", "o" } },
    },
}

-- coc
add {
    "https://github.com/neoclide/coc.nvim",
    branch = "release",
    config = function()
        local function coc_service_names(arglead, cmdline, cursorpos)
            return vim.tbl_map(function(service)
                return service["id"]
            end, vim.fn.CocAction "services")
        end

        util.create_cmd("CocToggleService", function(meta)
            vim.fn.CocAction("toggleService", meta.args)
        end, { nargs = 1, complete = coc_service_names })

        vim.opt.tagfunc = "CocTagFunc"

        vim.g["coc_global_extensions"] = {
            "coc-deno",
            "coc-json",
            "coc-marketplace",
            "coc-pyright",
            "coc-rust-analyzer",
            "coc-snippets",
            "coc-sumneko-lua",
            "coc-toml",
            -- "coc-tsserver",
            "coc-yaml",
        }

        vim.keymap.set("n", "gd", "<C-]>")

        vim.keymap.set("n", "t", "<Nop>")
        vim.keymap.set("n", "td", util.cmdcr "Telescope coc definitions")
        vim.keymap.set("n", "ti", util.cmdcr "Telescope coc implementations")
        vim.keymap.set("n", "tr", util.cmdcr "Telescope coc references")
        vim.keymap.set("n", "ty", util.cmdcr "Telescope coc type_definitions")
        vim.keymap.set("n", "tA", util.cmdcr "Telescope coc code_actions")
        vim.keymap.set("n", "tn", "<Plug>(coc-rename)")
        vim.keymap.set("n", "ta", "<Plug>(coc-codeaction-cursor)")
        vim.keymap.set("x", "ta", "<Plug>(coc-codeaction-selected)")
        vim.keymap.set("n", "tw", "<Plug>(coc-float-jump)")
        vim.keymap.set("n", "K", util.cmdcr "call CocActionAsync('doHover')")
        vim.keymap.set("n", "th", util.cmdcr "CocCommand document.toggleInlayHint")

        -- coc#_select_confirm などは Lua 上では動かないので、 <Plug> にマッピングして使えるようにする
        vim.cmd [[
            inoremap <expr> <Plug>(vimrc-coc-select-confirm) coc#_select_confirm()
            inoremap <expr> <Plug>(vimrc-lexima-expand-cr) lexima#expand('<LT>CR>', 'i')
        ]]

        vim.keymap.set("i", "<CR>", function()
            if util.to_bool(vim.fn["coc#pum#visible"]()) then
                -- 補完候補をセレクトしていたときのみ、補完候補の内容で確定する
                -- （意図せず補完候補がセレクトされてしまうのを抑止）
                if vim.fn["coc#pum#info"]()["index"] >= 0 then
                    return "<Plug>(vimrc-coc-select-confirm)"
                end
                return "<C-y><Plug>(vimrc-lexima-expand-cr)"
            end
            return "<Plug>(vimrc-lexima-expand-cr)"
        end, { expr = true, remap = true })

        -- coc#pum#next(1) などが Vim script 上でしか動かないっぽい

        -- local function coc_check_backspace()
        --     local col = vim.fn.col "." - 1
        --     if not util.to_bool(col) then
        --         return true
        --     end
        --     return vim.regex([[\s]]):match_str(vim.fn.getline(".")[col])
        -- end

        -- vim.keymap.set("i", "<Tab>", function ()
        --     -- if util.to_bool(vim.fn.pumvisible()) then
        --     --     return "<C-n>"
        --     -- end
        --     if util.to_bool(vim.fn["coc#pum#visible"]()) then
        --         return vim.fn["coc#pum#next"](1)
        --     end
        --     if coc_check_backspace() then
        --         return "<Tab>"
        --     end
        --     return vim.fn["coc#refresh"]()
        -- end, {expr = true, silent = true})
        --
        -- vim.keymap.set("i", "<S-Tab>", function ()
        --     -- if util.to_bool(vim.fn.pumvisible()) then
        --     --     return "<C-p>"
        --     -- end
        --     if util.to_bool(vim.fn["coc#pum#visible"]()) then
        --         return vim.fn["coc#pum#next"](-1)
        --     end
        --     return "<C-h>"
        -- end, {expr = true})

        vim.cmd [[
          function! s:check_back_space() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~ '\s'
          endfunction

          " Insert <tab> when previous text is space, refresh completion if not.
          inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1):
            \ pumvisible() ? "\<C-n>":
            \ <SID>check_back_space() ? "\<Tab>" :
            \ coc#refresh()
          inoremap <expr><S-TAB>
            \ coc#pum#visible() ? coc#pum#prev(1) :
            \ pumvisible() ? "\<C-p>":
            \ "\<C-h>"
        ]]

        vim.g.coc_snippet_next = "<C-g><C-j>"
        vim.g.coc_snippet_prev = "<C-g><C-k>"

        -- coc の diagnostics の内容を QuiciFix に流し込む。
        local function coc_diag_to_quickfix()
            local diags = vim.fn["CocAction"] "diagnosticList"
            ---@type any[]
            local entries = vim.tbl_map(function(diag)
                return {
                    filename = diag.file,
                    lnum = diag.lnum,
                    end_lnum = diag.end_lnum,
                    col = diag.col,
                    end_col = diag.end_col,
                    text = diag.message,
                    type = diag.severity:sub(1, 1),
                }
            end, diags)

            vim.fn.setqflist(entries)
            vim.fn.setqflist({}, "a", { title = "Coc diagnostics" })
        end

        util.create_cmd("CocQuickfix", function()
            coc_diag_to_quickfix()
            vim.cmd [[cwindow]]
        end)

        ---diagnostics のある位置にジャンプする。ただし種類に応じて優先順位を付ける。
        ---つまり、エラーがあればまずエラーにジャンプする。
        ---エラーがなく警告があれば、警告にジャンプする。みたいな。
        ---@param forward boolean
        local function jump_diag(forward)
            local action_name = util.ifexpr(forward, "diagnosticNext", "diagnosticPrevious")
            util.motion_autoselect {
                function()
                    vim.fn.CocAction(action_name, "error")
                end,
                function()
                    vim.fn.CocAction(action_name, "warning")
                end,
                function()
                    vim.fn.CocAction(action_name, "information")
                end,
                function()
                    vim.fn.CocAction(action_name, "hint")
                end,
            }
        end

        vim.keymap.set("n", ")", function()
            jump_diag(true)
        end)
        vim.keymap.set("n", "(", function()
            jump_diag(false)
        end)
    end,
}

-- nvim_lsp

-- add { "https://github.com/neovim/nvim-lspconfig", opt = 1, config = config.nvim_lsp }
-- add { "https://github.com/williamboman/mason.nvim", opt = 1 }
-- add { "https://github.com/williamboman/mason-lspconfig.nvim", opt = 1 }
-- add { "https://github.com/hrsh7th/nvim-cmp", opt = 1 }
-- add { "https://github.com/hrsh7th/cmp-nvim-lsp", opt = 1 }
-- add { "https://github.com/hrsh7th/cmp-vsnip", opt = 1 }
-- add { "https://github.com/hrsh7th/cmp-buffer", opt = 1 }
-- add { "https://github.com/hrsh7th/cmp-path", opt = 1 }
-- add { "https://github.com/hrsh7th/cmp-cmdline", opt = 1 }
-- add { "https://github.com/hrsh7th/vim-vsnip", opt = 1 }
-- add { "https://github.com/folke/neodev.nvim", opt = 1 }

-- telescope
add {
    "https://github.com/nvim-telescope/telescope.nvim",
    dependencies = {
        "https://github.com/fannheyward/telescope-coc.nvim",
        "https://github.com/nvim-telescope/telescope-smart-history.nvim",
        "https://github.com/kkharji/sqlite.lua",
        "https://github.com/fdschmidt93/telescope-egrepify.nvim",
    },
    cmd = { "Telescope" },
    keys = {
        {
            "so",
            function()
                local builtin = require "telescope.builtin"
                builtin.git_files { prompt_prefix = "𝝋" }
            end,
        },
        {
            "sO",
            function()
                local builtin = require "telescope.builtin"
                builtin.find_files { prompt_prefix = "𝝋" }
            end,
        },
        {
            "sb",
            function()
                local builtin = require "telescope.builtin"
                builtin.buffers { prompt_prefix = "𝜷" }
            end,
        },
        {
            "sg",
            function()
                -- local builtin = require "telescope.builtin"
                -- builtin.live_grep { prompt_prefix = "𝜸" }
                require("telescope").extensions.egrepify.egrepify {
                    prompt_prefix = "𝜸",
                }
            end,
        },
        {
            "tq",
            function()
                local builtin = require "telescope.builtin"
                builtin.quickfix { prompt_prefix = "𝝄" }
            end,
        },
        -- {
        --     "si",
        --     function()
        --         local extensions = require("telescope").extensions
        --         extensions.frecency.frecency { prompt_prefix = "𝑓", workspace = "CWD" }
        --     end,
        -- },
    },
    config = function()
        local actions = require "telescope.actions"

        require("telescope").load_extension "coc"
        require("telescope").load_extension "smart_history"
        require("telescope").load_extension "egrepify"
        -- require("telescope").load_extension "frecency"

        -- manage database history
        local db_dir = vim.fn.stdpath "data" .. "/databases"
        if not util.to_bool(vim.fn.isdirectory(db_dir)) then
            vim.fn.mkdir(db_dir, "p")
        end

        util.autocmd_vimrc "FileType" {
            pattern = "TelescopePrompt",
            callback = function()
                vim.b.lexima_disabled = 1
                -- なぜか lexima が <Esc><Esc> という mapping をはやしてしまうため
                -- それより優先度の高いマッピングを入れておく
                vim.keymap.set("i", "<Esc>", "<Esc>", { buffer = true, nowait = true })
            end,
        }

        -- Global remapping
        require("telescope").setup {
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "--line-number",
                    "--no-heading",
                    "--color=never",
                    "--hidden",
                    "--with-filename",
                    "--column",
                    "--smart-case",
                },
                prompt_prefix = "𝜻",
                find_command = {
                    "rg",
                    "--ignore",
                    "--hidden",
                    "--files",
                },
                mappings = {
                    n = {
                        ["<Esc>"] = actions.close,
                        -- ["<C-f>"] = function (prompt_buffer)
                        --     actions.move_selection_next(prompt_buffer)
                        -- end,
                    },
                    i = {
                        ["<C-n>"] = actions.cycle_history_next,
                        ["<C-p>"] = actions.cycle_history_prev,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-f>"] = false,
                    },
                },
                history = {
                    path = db_dir .. "/telescope_history.sqlite3",
                    limite = 100,
                },
                extensions = {
                    egrepify = {
                        prefixes = {
                            ["#"] = {
                                -- #$REMAINDER
                                -- # is caught prefix
                                -- `input` becomes $REMAINDER
                                -- in the above example #lua,md -> input: lua,md
                                flag = "glob",
                                cb = function(input)
                                    return string.format([[*.{%s}]], input)
                                end,
                            },
                            -- filter for (partial) folder names
                            -- example prompt: >conf $MY_PROMPT
                            -- searches with ripgrep prompt $MY_PROMPT in paths that have "conf" in folder
                            -- i.e. rg --glob="**/conf*/**" -- $MY_PROMPT
                            [">"] = {
                                flag = "glob",
                                cb = function(input)
                                    return string.format([[**/{%s}*/**]], input)
                                end,
                            },
                            -- filter for (partial) file names
                            -- example prompt: &egrep $MY_PROMPT
                            -- searches with ripgrep prompt $MY_PROMPT in paths that have "egrep" in file name
                            -- i.e. rg --glob="*egrep*" -- $MY_PROMPT
                            ["&"] = {
                                flag = "glob",
                                cb = function(input)
                                    return string.format([[*{%s}*]], input)
                                end,
                            },
                        },
                        mappings = {
                            ["<C-z>"] = false,
                            ["<C-a>"] = false,
                            ["<C-r>"] = false,
                        },
                    },
                },
            },
        }
    end,
}
add {
    "https://github.com/fannheyward/telescope-coc.nvim",
    cmd = { "Telescope" },
    dependencies = { "https://github.com/neoclide/coc.nvim" },
}
add {
    "https://github.com/fdschmidt93/telescope-egrepify.nvim",
    dependencies = { "https://github.com/nvim-lua/plenary.nvim" },
}

add { "https://github.com/nvim-lua/popup.nvim", lazy = true }
add { "https://github.com/nvim-lua/plenary.nvim", lazy = true }

-- denops
-- add {
--     "https://github.com/Shougo/ddu.vim",
--     dependencies = { "https://github.com/vim-denops/denops.vim" },
--     enabled = false,
--     config = function()
--         vim.keymap.set("n", "sm", function()
--             vim.fn["ddu#start"] {
--                 sources = {
--                     { name = "mr", params = { kind = "mru" } },
--                 },
--             }
--         end)
--
--         -- vim.keymap.set("n", "@o", function()
--         --     vim.fn["ddu#start"] {
--         --         sources = {
--         --             { name = "file_external", params = {} },
--         --         },
--         --     }
--         -- end)
--         --
--         -- vim.keymap.set("n", "@g", function()
--         --     vim.fn["ddu_rg#find"]()
--         -- end)
--
--         vim.fn["ddu#custom#patch_global"] {
--             ui = "ff",
--             uiParams = {
--                 ff = { split = "floating" },
--             },
--             sources = {
--                 { name = "file_rec", params = {} },
--             },
--             sourceOptions = {
--                 ["_"] = {
--                     matchers = { "matcher_substring" },
--                 },
--                 rg = {
--                     args = { "--column", "--no-heading", "--color", "never" },
--                 },
--             },
--             kindOptions = {
--                 file = { defaultAction = "open" },
--             },
--             sourceParams = {
--                 rg = {
--                     args = { "--column", "--no-heading", "--color", "--hidden" },
--                 },
--                 file_external = {
--                     cmd = { "fd", ".", "-H", "-E", "__pycache__", "-t", "f" },
--                 },
--             },
--         }
--
--         local function nmap_action(lhs, action)
--             vim.keymap.set(
--                 "n",
--                 lhs,
--                 [[<Cmd>call ddu#ui#ff#do_action(']] .. action .. [[')<CR>]],
--                 { buffer = true, silent = true }
--             )
--         end
--
--         util.autocmd_vimrc "FileType" {
--             pattern = "ddu-ff",
--             callback = function()
--                 nmap_action("<CR>", "itemAction")
--                 nmap_action("<Space>", "toggleSelectItem")
--                 nmap_action("i", "openFilterWindow")
--                 nmap_action("q", "quit")
--                 nmap_action("<Esc>", "quit")
--             end,
--         }
--
--         util.autocmd_vimrc "FileType" {
--             pattern = "ddu-ff-filter",
--             callback = function()
--                 vim.keymap.set("i", "<CR>", "<Esc><Cmd>close<CR>", { buffer = true, silent = true })
--                 vim.keymap.set("n", "<CR>", "<Cmd>close<CR>", { buffer = true, silent = true })
--                 vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = true, silent = true })
--                 vim.keymap.set("n", "<Esc>", "<Cmd>close<CR>", { buffer = true, silent = true })
--             end,
--         }
--     end,
-- }
-- add { "https://github.com/Shougo/ddu-filter-matcher_substring" }
-- add { "https://github.com/Shougo/ddu-kind-file" }
-- add { "https://github.com/Shougo/ddu-source-file_rec" }
-- add { "https://github.com/Shougo/ddu-ui-ff" }
-- add { "https://github.com/kuuote/ddu-source-mr" }
-- add { "https://github.com/lambdalisue/mr.vim", branch = "main" }
-- add { "https://github.com/matsui54/ddu-source-file_external" }
-- add { "https://github.com/shun/ddu-source-rg" }
add { "https://github.com/vim-denops/denops.vim", lazy = false }
add { "https://github.com/lambdalisue/guise.vim", lazy = false }
add {
    "https://github.com/4513ECHO/denops-gitter.vim",
    dependencies = { "https://github.com/vim-denops/denops.vim" },
    enabled = false,
    config = function()
        vim.g["gitter#token"] = vim.fn.getenv "GITTER_TOKEN"
    end,
}
add {
    "https://github.com/lambdalisue/kensaku.vim",
    lazy = false,
    dependencies = { "https://github.com/vim-denops/denops.vim" },
}
add {
    "https://github.com/gamoutatsumi/dps-ghosttext.vim",
    config = function()
        vim.g["dps_ghosttext#ftmap"] = {
            ["github.com"] = "markdown",
        }
    end,
}

-- tree-sitter
add {
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

        -- parser_config.typst = {
        --     install_info = {
        --         url = "~/ghq/github.com/frozolotl/tree-sitter-typst", -- local path or git repo
        --         revision = "main",
        --         files = { "src/parser.c", "src/scanner.cc" },
        --     },
        --     filetype = "typst", -- if filetype does not agrees with parser name
        -- }

        vim.treesitter.language.register("markdown", { "mdx", "obsidian" })
        vim.treesitter.language.register("gitcommit", { "gina-commit" })

        local parser_install_dir = vim.fn.stdpath "data" .. "/treesitter"
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
                    if vim.fn.line "$" > 20000 then
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
add { "https://github.com/nvim-treesitter/playground", cond = cond_dev "nvim-treesitter/playground", ft = { "query" } }
add {
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

-- filetype
-- julia-vim は遅延ロード負荷
-- add { "https://github.com/JuliaEditorSupport/julia-vim" }
-- add { "https://github.com/aklt/plantuml-syntax", ft = { "plantuml" } }
-- add { "https://github.com/Vimjas/vim-python-pep8-indent", ft = { "python" } }
add { "https://github.com/bfontaine/Brewfile.vim", ft = { "brewfile" } }
add { "https://github.com/cespare/vim-toml", ft = { "toml" } }
-- add { "https://github.com/chr4/nginx.vim", ft = { "nginx" } }
add { "https://github.com/ekalinin/Dockerfile.vim", ft = { "dockerfile" } }
add { "https://github.com/evanleck/vim-svelte", ft = { "svelte" } }
add { "https://github.com/justinmk/vim-syntax-extra", ft = { "vim" } }
-- add { "https://github.com/ocaml/vim-ocaml", ft = { "ocaml" } }
add { "https://github.com/othree/html5.vim", ft = { "html" } }
add { "https://github.com/pangloss/vim-javascript", ft = { "javascript" } }
-- add { "https://github.com/pest-parser/pest.vim", ft = { "pest" } }
add {
    "https://github.com/rust-lang/rust.vim",
    ft = { "rust" },
    config = function()
        -- なんかめちゃ重かった
        vim.g["rustfmt_autosave"] = 0
    end,
}
add {
    "https://github.com/vim-python/python-syntax",
    ft = { "python" },
    config = function()
        vim.g.python_highlight_all = 1
    end,
}
add { "https://github.com/vito-c/jq.vim", ft = { "jq" } }
add { "https://github.com/wlangstroth/vim-racket", ft = { "racket" } }
add { "https://github.com/terrastruct/d2-vim", ft = { "d2" } }
add {
    "https://github.com/kaarmu/typst.vim",
    ft = { "typst" },
    -- ひとまず以下の issue が解決するまでは
    -- https://github.com/kaarmu/typst.vim/issues/64
    commit = "65f9e78c11829a643d1539f3481c0ff875c83603",
}
add { "https://github.com/mityu/vim-applescript", ft = { "applescript" } }

-- monaqa
add { "https://github.com/monaqa/colordinate.vim", enabled = false }
add {
    "https://github.com/monaqa/dial.nvim",
    cond = cond_dev "monaqa/dial.nvim",
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
        local augend = require "dial.augend"

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
            find = require("dial.augend.common").find_pattern_regex [[\v\C[cdefgab](ees|es|is|iis)?[,']*]],
            ---@param text string
            ---@param addend integer
            ---@param cursor integer
            ---@return { text?: string, cursor?: integer }
            add = function(text, addend, cursor)
                local tone_start, tone_end = text:find "[abcdefgis]+"
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
add {
    "https://github.com/monaqa/modesearch.nvim",
    cond = cond_dev "monaqa/modesearch.nvim",
    dependencies = {
        "https://github.com/lambdalisue/kensaku.vim",
    },
    keys = {
        {
            "/",
            function()
                return require("modesearch").keymap.prompt.show "rawstr"
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
                        if query:find "%u" ~= nil then
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
add { "https://github.com/monaqa/peridot.vim", lazy = true }
add {
    "https://github.com/monaqa/pretty-fold.nvim",
    branch = "for_stable_neovim",
    opts = {
        fill_char = "┄",
        sections = {
            left = {
                "content",
            },
            right = {
                " ",
                "number_of_folded_lines",
                ": ",
                "percentage",
                " ",
                function(config)
                    return config.fill_char:rep(3)
                end,
            },
        },

        remove_fold_markers = true,

        -- Keep the indentation of the content of the fold string.
        keep_indentation = true,

        -- Possible values:
        -- "delete" : Delete all comment signs from the fold string.
        -- "spaces" : Replace all comment signs with equal number of spaces.
        -- false    : Do nothing with comment signs.
        comment_signs = "spaces",

        -- List of patterns that will be removed from content foldtext section.
        stop_words = {
            "@brief%s*", -- (for cpp) Remove '@brief' and all spaces after.
        },

        add_close_pattern = true,
        matchup_patterns = {
            { "{", "}" },
            { "%(", ")" }, -- % to escape lua pattern char
            { "%[", "]" }, -- % to escape lua pattern char
            { "if%s", "end" },
            { "do%s", "end" },
            { "for%s", "end" },
        },
    },
}

vim.g["smooth_scroll_no_default_key_mappings"] = 1
add {
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
            util.cmdcr [[call smooth_scroll#flick( v:count1 * winwidth(0) / 3, 10, "zl", "zh", v:true)]],
            mode = { "n", "x" },
        },
        {
            "H",
            util.cmdcr [[call smooth_scroll#flick(-v:count1 * winwidth(0) / 3, 10, "zl", "zh", v:true)]],
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
add {
    "https://github.com/monaqa/vim-edgemotion",
    keys = {
        { mode = { "n", "x", "o" }, "<Space>j", "m`<Plug>(edgemotion-j)" },
        { mode = { "n", "x", "o" }, "<Space>k", "m`<Plug>(edgemotion-k)" },
        { mode = { "n", "x", "o" }, "<Space>j", "<Plug>(edgemotion-j)" },
        { mode = { "n", "x", "o" }, "<Space>k", "<Plug>(edgemotion-k)" },
    },
}
add {
    "https://github.com/monaqa/nvim-treesitter-clipping",
    dependencies = { "https://github.com/thinca/vim-partedit" },
    cond = cond_dev "monaqa/nvim-treesitter-clipping",
    keys = {
        { "<Space>c", "<Plug>(ts-clipping-clip)" },
        { mode = { "x", "o" }, "<Space>c", "<Plug>(ts-clipping-select)" },
    },
}

require("lazy").setup(lazy_config)
