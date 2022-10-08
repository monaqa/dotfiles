local M = {}

local util = require "rc.util"
local submode = require "rc.submode"

-- §§1 general

function M.bufferline()
    require("bufferline").setup {
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
    }

    vim.keymap.set("n", "sn", "<Cmd>BufferLineCycleNext<CR>")
    vim.keymap.set("n", "sp", "<Cmd>BufferLineCyclePrev<CR>")
    vim.keymap.set("n", "sN", "<Cmd>BufferLineMoveNext<CR>")
    vim.keymap.set("n", "sP", "<Cmd>BufferLineMovePrev<CR>")

    -- https://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window
    vim.keymap.set("n", "sw", "<Cmd>bp | sp | bn | bd<CR>")
end

function M.asterisk()
    vim.keymap.set("n", "*", "<Plug>(asterisk-z*)")
    vim.keymap.set("n", "#", "<Plug>(asterisk-z#)")
    vim.keymap.set("n", "g*", "<Plug>(asterisk-gz*)")
    vim.keymap.set("n", "g#", "<Plug>(asterisk-gz#)")
end

function M.markdown_preview()
    vim.g.mkdp_markdown_css = vim.fn.expand "~/.config/nvim/resource/github-markdown-light.css"
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_preview_options = {
        disable_sync_scroll = 1,
    }
end

function M.altr()
    vim.keymap.set("n", "<Space>^", "<Plug>(altr-forward)", { remap = true })
    vim.keymap.set("n", "<Space>-", "<Plug>(altr-forward)", { remap = true })
end

function M.fern()
    vim.g["fern#disable_default_mappings"] = 1
    vim.g["fern#default_hidden"] = 1

    local exclude_files = {
        [[.*\.egg-info]],
        [[.*\.pyc]],
        [[\.DS_Store]],
        [[\.git]],
        [[\.mypy_cache]],
        [[\.pytest_cache]],
        [[\.vim]],
        [[\.vimsessions]],
        [[\.worktree]],
        [[__pycache__]],
        [[sumneko-lua-.*]],
        [[Cargo.lock]],
        [[poetry.lock]],
    }

    vim.g["fern#default_exclude"] = [[^\%(]] .. table.concat(exclude_files, [[\|]]) .. [[\)$]]
    vim.g["fern#renderer"] = "nerdfont"

    vim.keymap.set("n", "sf", "<Cmd>Fern . -reveal=%:p<CR>")
    vim.keymap.set("n", "sz", "<Cmd>Fern . -drawer -toggle<CR>")

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
        vim.keymap.set("n", "e", "<Plug>(fern-action-open)", { remap = true, buffer = true })
        vim.keymap.set("n", "<BS>", "<Plug>(fern-action-leave)", { remap = true, buffer = true })

        vim.keymap.set("n", ">>", "<Plug>(fern-action-mark:set)", { remap = true, buffer = true, nowait = true })
        -- なぜか unset のときファイル末尾にジャンプしてしまうので <C-o> を付けた
        vim.keymap.set("n", "<<", "<Plug>(fern-action-mark:unset)<C-o>", { remap = true, buffer = true, nowait = true })
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
end

function M.gina()
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
end

function M.vimtex()
    vim.g.tex_flavor = "latex"
end

function M.emmet()
    vim.g["user_emmet_mode"] = "n"
    vim.g["emmet_html5"] = 0
    vim.g["user_emmet_install_global"] = 0
end

function M.undotree()
    vim.keymap.set("n", "U", "<Cmd>UndotreeToggle<CR>")
end

function M.lualine()
    _G.debug_lualine = {}
    require("lualine").setup {
        sections = {
            lualine_b = {
                function()
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
                -- statusline = 10000,
                statusline = 1000,
                tabline = 10000,
                winbar = 10000,
            },
        },
    }
    -- vim.opt.fillchars = {
    --   horiz = '━',
    --   horizup = '┻',
    --   horizdown = '┳',
    --   vert = '┃',
    --   vertleft  = '┫',
    --   vertright = '┣',
    --   verthoriz = '╋',
    -- }
end

function M.capslock()
    vim.keymap.set("i", "<C-l>", "<Nop>")
end

function M.caw()
    vim.keymap.set("n", ",", "<Plug>(caw:hatpos:toggle:operator)")
    vim.keymap.set("n", ",,", ",_", { remap = true })
    vim.keymap.set("x", ",", "<Plug>(caw:hatpos:toggle)")
end

function M.open_browser()
    vim.keymap.set({ "n", "x" }, "gb", "<Plug>(openbrowser-smart-search)")
end

function M.rust_doc()
    vim.g["rust_doc#define_map_K"] = 0
end

function M.session()
    local session_dir = vim.fn["xolox#misc#path#merge"](vim.fn.getcwd(), ".vimsessions")
    if util.to_bool(vim.fn.isdirectory(session_dir)) then
        vim.g.session_directory = session_dir
        vim.g.session_autosave = "yes"
        vim.g.session_autoload = "yes"
    else
        vim.g.session_autosave = "no"
        vim.g.session_autoload = "no"
    end
end

-- §§1 colorscheme

function M.gruvbit()
    ---@alias tbl_hl {name: string, gui?: string, guifg?: string, guibg?: string, cterm?: string, ctermbg?: string, ctermfg?: string}
    ---@alias tbl_link {name: string, link: string}

    ---@param tbl tbl_hl | tbl_link
    local function sethl(tbl)
        if tbl.link ~= nil then
            vim.cmd(table.concat({
                "highlight!",
                "link",
                tbl.name,
                tbl.link,
            }, " "))
        else
            local opts = {}
            for _, key in ipairs { "gui", "guifg", "guibg", "cterm", "ctermfg", "ctermbg" } do
                if tbl[key] ~= nil then
                    table.insert(opts, key .. "=" .. tbl[key])
                end
            end
            local opts_str = table.concat(opts, " ")
            vim.cmd(table.concat({
                "highlight!",
                tbl.name,
                opts_str,
            }, " "))
        end
    end

    vim.g.gruvbit_transp_bg = 1

    -- TODO: foo
    util.autocmd_vimrc { "ColorScheme" } {
        pattern = "gruvbit",
        callback = function()
            -- basic
            sethl { name = "FoldColumn", guibg = "#303030" }
            sethl { name = "NonText", guifg = "#496da9" }
            sethl { name = "Todo", gui = "bold", guibg = "#444444", guifg = "#c6b7a2" }

            sethl {
                name = "VertSplit",
                guifg = "#c8c8c8",
                guibg = "None",
                -- gui="bold",
            }
            sethl { name = "Visual", guibg = "#4d564e" }
            sethl { name = "Pmenu", guibg = "#404064" }
            sethl { name = "QuickFixLine", guibg = "#4d569e" }

            sethl { name = "DiffChange", guibg = "#314a5c" }
            sethl { name = "DiffDelete", guibg = "#5c3728", guifg = "#968772" }
            sethl { name = "MatchParen", guibg = "#51547d", guifg = "#ebdbb2" }

            -- coc.nvim
            sethl { name = "CocHintFloat", guibg = "#444444", guifg = "#45daef" }
            sethl { name = "CocRustChainingHint", link = "CocHintFloat" }
            sethl { name = "CocSearch", guifg = "#fabd2f" }
            sethl { name = "CocMenuSel", guibg = "#303054" }

            -- custom highlight name
            sethl { name = "WeakTitle", guifg = "#fad57f" }
            sethl { name = "Quote", guifg = "#c6b7a2" }
            sethl { name = "VisualBlue", guibg = "#4d569e" }

            -- nvim-treesitter
            sethl { name = "TSParameter", guifg = "#b3d5c8" }
            sethl { name = "TSField", guifg = "#b3d5c8" }

            -- misc
            sethl { name = "rustCommentLineDoc", guifg = "#a6a182" }
        end,
    }
end

-- §§1 paren

function M.lexima()
    vim.g["lexima_no_default_rules"] = 1
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
end

function M.sandwich()
    -- 全体設定
    vim.fn["operator#sandwich#set"]("all", "all", "highlight", 0)

    -- sandwich.vim を使うためのマッピング
    vim.keymap.set(
        "n",
        "ds",
        "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)",
        { remap = true }
    )
    vim.keymap.set(
        "n",
        "dsb",
        "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)",
        { remap = true }
    )
    vim.keymap.set(
        "n",
        "cs",
        "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)",
        { remap = true }
    )
    vim.keymap.set(
        "n",
        "csb",
        "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)",
        { remap = true }
    )

    -- textobj-between と同じことを sandwich.vim でやる
    vim.keymap.set({ "x", "o" }, "m", "<Plug>(textobj-sandwich-literal-query-i)", { remap = true })
    vim.keymap.set({ "x", "o" }, "M", "<Plug>(textobj-sandwich-literal-query-a)", { remap = true })

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

        function! InlineCommandName() abort
          let cmdname = input('inline-cmd name: ', '')
          if cmdname ==# ''
            throw 'OperatorSandwichCancel'
          endif
          return '\' . cmdname . '{'
        endfunction

        function! BlockCommandName() abort
          let cmdname = input('block-cmd name: ', '')
          if cmdname ==# ''
            throw 'OperatorSandwichCancel'
          endif
          return '+' . cmdname . '<'
        endfunction
    ]]

    -- レシピ集
    local default_recipes = vim.g["sandwich#default_recipes"]

    local recipe_general = {
        {
            input = { "(" },
            buns = { "(", ")" },
            nesting = 1,
            match_syntax = 1,
            kind = { "add", "replace" },
            action = {
                "add",
            },
        },
        {
            input = { "[" },
            buns = { "[", "]" },
            nesting = 1,
            match_syntax = 1,
            kind = { "add", "replace" },
            action = {
                "add",
            },
        },
        {
            buns = { "{", "}" },
            input = { "{" },
            nesting = 1,
            match_syntax = 1,
            kind = { "add", "replace" },
            action = {
                "add",
            },
        },
        {
            input = { "(" },
            buns = { [=[\s*[]=], [=[]\s*]=] },
            regex = 1,
            nesting = 1,
            match_syntax = 1,
            kind = { "delete", "replace", "textobj" },
            action = { "delete" },
        },
        {
            input = { "[" },
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
    }
end

function M.matchup()
    vim.g["matchup_matchparen_offscreen"] = {}
end

-- §§1 textedit

function M.textobj_comment()
    vim.g["textobj_comment_no_default_key_mappings"] = 1
    vim.keymap.set({ "x", "o" }, "im", "<Plug>(textobj-comment-i)", { remap = true })
    vim.keymap.set({ "x", "o" }, "am", "<Plug>(textobj-comment-a)", { remap = true })
end

function M.textobj_entire()
    for _, op in ipairs {
        "y",
        "=",
        "<",
        ">",
    } do
        vim.keymap.set("n", op .. "ie", op .. "<Plug>(textobj-entire-i)<C-o>", { remap = true })
        vim.keymap.set("n", op .. "ae", op .. "<Plug>(textobj-entire-a)<C-o>", { remap = true })
    end
end

function M.textobj_user()
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
end

function M.swap()
    vim.keymap.set({ "o", "x" }, "i,", "<Plug>(swap-textobject-i)")
    vim.keymap.set({ "o", "x" }, "a,", "<Plug>(swap-textobject-a)")
end

function M.textobj_functioncall()
    vim.g["textobj_functioncall_no_default_key_mappings"] = 1
    vim.g["textobj_functioncall_generics_patterns"] = {
        {
            header = [[\<\%(\h\k*\.\)*\h\k*]],
            bra = "<",
            ket = ">",
            footer = "",
        },
    }
    vim.keymap.set(
        "o",
        "<Plug>(textobj-functioncall-generics-i)",
        ":<C-u>call textobj#functioncall#ip('o', g:textobj_functioncall_generics_patterns)<CR>",
        { silent = true }
    )
    vim.keymap.set(
        "x",
        "<Plug>(textobj-functioncall-generics-i)",
        ":<C-u>call textobj#functioncall#ip('x', g:textobj_functioncall_generics_patterns)<CR>",
        { silent = true }
    )
    vim.keymap.set(
        "o",
        "<Plug>(textobj-functioncall-generics-a)",
        ":<C-u>call textobj#functioncall#i('o', g:textobj_functioncall_generics_patterns)<CR>",
        { silent = true }
    )
    vim.keymap.set(
        "x",
        "<Plug>(textobj-functioncall-generics-a)",
        ":<C-u>call textobj#functioncall#i('x', g:textobj_functioncall_generics_patterns)<CR>",
        { silent = true }
    )
end

-- §§1 coc
function M.coc()
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
    vim.keymap.set("n", "tn", "<Plug>(coc-rename)")
    vim.keymap.set("n", "ta", "<Plug>(coc-codeaction-cursor)")
    vim.keymap.set("x", "ta", "<Plug>(coc-codeaction-selected)")
    vim.keymap.set("n", "tw", "<Plug>(coc-float-jump)")
    vim.keymap.set("n", "K", util.cmdcr "call CocActionAsync('doHover')")

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
end

-- §§1 telescope

function M.telescope()
    local actions = require "telescope.actions"
    local builtin = require "telescope.builtin"
    require("telescope").load_extension "coc"

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
                -- '--smart-case'
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
                },
            },
        },
    }

    vim.keymap.set("n", "so", function()
        builtin.git_files { prompt_prefix = "𝝋" }
    end)
    vim.keymap.set("n", "sO", function()
        builtin.find_files { prompt_prefix = "𝝋" }
    end)
    vim.keymap.set("n", "sb", function()
        builtin.buffers { prompt_prefix = "𝜷" }
    end)
    vim.keymap.set("n", "sg", function()
        builtin.live_grep { prompt_prefix = "𝜸" }
    end)
    vim.keymap.set("n", "tq", function()
        builtin.quickfix { prompt_prefix = "𝝄" }
    end)
end

-- §§1 denops

function M.ddu()
    vim.keymap.set("n", "sm", function()
        vim.fn["ddu#start"] {
            sources = {
                { name = "mr", params = { kind = "mru" } },
            },
        }
    end)

    vim.keymap.set("n", "@o", function()
        vim.fn["ddu#start"] {
            sources = {
                { name = "file_external", params = {} },
            },
        }
    end)

    vim.keymap.set("n", "@g", function()
        vim.fn["ddu_rg#find"]()
    end)

    vim.fn["ddu#custom#patch_global"] {
        ui = "ff",
        uiParams = {
            ff = { split = "floating" },
        },
        sources = {
            { name = "file_rec", params = {} },
        },
        sourceOptions = {
            ["_"] = {
                matchers = { "matcher_substring" },
            },
            rg = {
                args = { "--column", "--no-heading", "--color", "never" },
            },
        },
        kindOptions = {
            file = { defaultAction = "open" },
        },
        sourceParams = {
            rg = {
                args = { "--column", "--no-heading", "--color", "--hidden" },
            },
            file_external = {
                cmd = { "fd", ".", "-H", "-E", "__pycache__", "-t", "f" },
            },
        },
    }

    local function nmap_action(lhs, action)
        vim.keymap.set(
            "n",
            lhs,
            [[<Cmd>call ddu#ui#ff#do_action(']] .. action .. [[')<CR>]],
            { buffer = true, silent = true }
        )
    end

    util.autocmd_vimrc "FileType" {
        pattern = "ddu-ff",
        callback = function()
            nmap_action("<CR>", "itemAction")
            nmap_action("<Space>", "toggleSelectItem")
            nmap_action("i", "openFilterWindow")
            nmap_action("q", "quit")
            nmap_action("<Esc>", "quit")
        end,
    }

    util.autocmd_vimrc "FileType" {
        pattern = "ddu-ff-filter",
        callback = function()
            vim.keymap.set("i", "<CR>", "<Esc><Cmd>close<CR>", { buffer = true, silent = true })
            vim.keymap.set("n", "<CR>", "<Cmd>close<CR>", { buffer = true, silent = true })
            vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = true, silent = true })
            vim.keymap.set("n", "<Esc>", "<Cmd>close<CR>", { buffer = true, silent = true })
        end,
    }
end

-- §§1 tree-sitter

function M.treesitter()
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

    local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername

    ft_to_parser["obsidian"] = "markdown"

    local parser_install_dir = vim.fn.stdpath "data" .. "/treesitter"
    vim.opt.runtimepath:append(parser_install_dir)

    require("nvim-treesitter.configs").setup {
        parser_install_dir = parser_install_dir,
        ensure_installed = {
            "bash",
            "css",
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
            -- disable = {"rust",},
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
            disable = {
                "bash",
                "css",
                "html",
                "json",
                "lua",
                -- 'markdown',
                "python",
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

    vim.keymap.set("n", "ts", "<Cmd>TSHighlightCapturesUnderCursor<CR>")
    local query_dir = vim.fn.expand("~/.config/nvim/after/queries", nil, nil)

    local function override_query(filetype, query_type)
        local query_file = ("%s/%s/%s.scm"):format(query_dir, filetype, query_type)
        local query = vim.fn.join(vim.fn.readfile(query_file), "\n")
        require("vim.treesitter.query").set_query(filetype, query_type, query)
    end

    -- 本体でサポートされたので、たぶんもうじき消える
    override_query("bash", "highlights")
    override_query("markdown", "highlights")
    override_query("markdown_inline", "highlights")
    override_query("lua", "folds")
end

function M.treehopper()
    vim.keymap.set("o", "q", ":<C-U>lua require('tsht').nodes()<CR>")
    vim.keymap.set("x", "q", ":lua require('tsht').nodes()<CR>")
end

-- §§1 filetype

function M.rust()
    -- なんかめちゃ重かった
    vim.g["rustfmt_autosave"] = 0
end

function M.python()
    vim.g.python_highlight_all = 1
end

function M.markdown()
    vim.g.vim_markdown_new_list_item_indent = 4
end

-- §§1 monaqa

function M.dial()
    local function dial_config()
        vim.cmd [[packadd dial.nvim]]

        local augend = require "dial.augend"
        require("dial.config").augends:register_group {
            default = {
                augend.integer.alias.decimal,
                augend.integer.alias.hex,
                augend.integer.alias.binary,
                augend.date.alias["%Y/%m/%d"],
                augend.date.alias["%Y-%m-%d"],
                augend.date.alias["%Y年%-m月%-d日(%ja)"],
                augend.date.alias["%H:%M:%S"],
                augend.date.alias["%-m/%-d"],
                augend.constant.alias.ja_weekday,
                augend.constant.alias.ja_weekday_full,
                augend.hexcolor.new { case = "lower" },
                augend.semver.alias.semver,
            },
            markdown = {
                augend.integer.alias.decimal,
                augend.integer.alias.hex,
                augend.integer.alias.binary,
                augend.date.alias["%Y/%m/%d"],
                augend.date.alias["%Y-%m-%d"],
                augend.date.alias["%Y年%-m月%-d日(%ja)"],
                augend.date.alias["%H:%M:%S"],
                augend.date.alias["%-m/%-d"],
                augend.constant.alias.ja_weekday,
                augend.constant.alias.ja_weekday_full,
                augend.hexcolor.new { case = "lower" },
                augend.semver.alias.semver,
                augend.misc.alias.markdown_header,
            },
        }

        vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
        vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
        vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
        vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
        vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
        vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })

        util.autocmd_vimrc { "FileType" } {
            pattern = "markdown",
            callback = function()
                vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal "markdown", { noremap = true })
                vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal "markdown", { noremap = true })
                vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual "markdown", { noremap = true })
                vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual "markdown", { noremap = true })
                vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual "markdown", { noremap = true })
                vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual "markdown", { noremap = true })
            end,
        }
    end

    if vim.fn.getcwd() ~= "/Users/monaqa/ghq/github.com/monaqa/dial.nvim" then
        dial_config()
    end
end

function M.smooth_scroll()
    vim.g["smooth_scroll_no_default_key_mappings"] = 1
    vim.g["smooth_scroll_interval"] = 1000.0 / 40.0
    vim.g["smooth_scroll_scrollkind"] = "quintic"
    vim.g["smooth_scroll_add_jumplist"] = true

    vim.keymap.set({ "n", "x" }, "<C-d>", function()
        vim.fn["smooth_scroll#flick"](vim.v.count1 * vim.o.scroll, 15, "j", "k")
    end)
    vim.keymap.set({ "n", "x" }, "<C-u>", function()
        vim.fn["smooth_scroll#flick"](-vim.v.count1 * vim.o.scroll, 15, "j", "k")
    end)
    vim.keymap.set({ "n", "x" }, "<C-f>", function()
        vim.fn["smooth_scroll#flick"](vim.v.count1 * vim.fn.winheight(0), 25, "j", "k")
    end)
    vim.keymap.set({ "n", "x" }, "<C-b>", function()
        vim.fn["smooth_scroll#flick"](-vim.v.count1 * vim.fn.winheight(0), 25, "j", "k")
    end)

    -- vim.keymap.set({"n", "v"}, "L", function () vim.fn["smooth_scroll#flick"]( vim.v.count1 * vim.fn.winwidth(0) / 3, 10, 'zl', 'zh', true) end)
    -- vim.keymap.set({"n", "v"}, "H", function () vim.fn["smooth_scroll#flick"](-vim.v.count1 * vim.fn.winwidth(0) / 3, 10, 'zl', 'zh', true) end)

    vim.cmd [[
        nnoremap zz    <Cmd>call smooth_scroll#flick(winline() - winheight(0) / 2, 10, "\<C-e>", "\<C-y>", v:true)<CR>
        nnoremap z<CR> <Cmd>call smooth_scroll#flick(winline() - 1               , 10, "\<C-e>", "\<C-y>", v:true)<CR>
        nnoremap zb    <Cmd>call smooth_scroll#flick(winline() - winheight(0)    , 10, "\<C-e>", "\<C-y>", v:true)<CR>
        xnoremap zz    <Cmd>call smooth_scroll#flick(winline() - winheight(0) / 2, 10, "\<C-e>", "\<C-y>", v:true)<CR>
        xnoremap z<CR> <Cmd>call smooth_scroll#flick(winline() - 1               , 10, "\<C-e>", "\<C-y>", v:true)<CR>
        xnoremap zb    <Cmd>call smooth_scroll#flick(winline() - winheight(0)    , 10, "\<C-e>", "\<C-y>", v:true)<CR>
    ]]

    vim.keymap.set(
        { "n", "x" },
        "L",
        util.cmdcr [[call smooth_scroll#flick( v:count1 * winwidth(0) / 3, 10, "zl", "zh", v:true)]]
    )
    vim.keymap.set(
        { "n", "x" },
        "H",
        util.cmdcr [[call smooth_scroll#flick(-v:count1 * winwidth(0) / 3, 10, "zl", "zh", v:true)]]
    )

    -- §§1 Plugin settings for monaqa/vim-edgemotion
    vim.keymap.set("n", "<Space>j", "m`<Plug>(edgemotion-j)")
    vim.keymap.set("n", "<Space>k", "m`<Plug>(edgemotion-k)")
    vim.keymap.set("x", "<Space>j", "<Plug>(edgemotion-j)")
    vim.keymap.set("x", "<Space>k", "<Plug>(edgemotion-k)")
end

function M.modesearch()
    vim.keymap.set({ "n", "x", "o" }, "/", "<Plug>(modesearch-slash-rawstr)")
    vim.keymap.set({ "n", "x", "o" }, "?", "<Plug>(modesearch-slash-regexp)")
    vim.keymap.set("c", "<C-x>", "<Plug>(modesearch-toggle-mode)")
    vim.keymap.set("n", "_", "/")
end

function M.partedit()
    vim.g["partedit#opener"] = ":vsplit"
    vim.g["partedit#prefix_pattern"] = [[\v\s*]]

    util.create_cmd("ParteditCodeblock", function(meta)
        local line_codeblock_start = vim.fn.getline(meta.line1 - 1)
        local filetype = vim.fn.matchstr(line_codeblock_start, [[\v```\zs[-a-zA-Z0-9]+\ze]])
        local options = { filetype = filetype }
        vim.fn["partedit#start"](meta.line1, meta.line2, options)
    end, { range = true })
end

function M.pretty_fold()
    require("pretty-fold").setup {
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
    }
end

return M
