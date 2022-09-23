-- vim:fdm=marker:fmr=§§,■■

local util = require("rc.util")

-- §§1 Plugin settings for lualine.nvim

require('lualine').setup {
  sections = {
    lualine_b = {
      function ()
        return [[%f %m]]
      end
    },
    lualine_c = {
      function()
        return vim.fn["coc#status"]()
      end
    },
    lualine_y = {
      function()
          local branch = vim.fn["gina#component#repo#branch"]()
          local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          if branch == "" then
              return cwd
          else
              return cwd .. " │ " .. vim.fn["gina#component#repo#branch"]()
          end
      end
    },
    lualine_z = {
      function()
        local n = #tostring(vim.fn.line("$"))
        n = math.max(n, 3)
        return "%" .. n .. [[l/%-3L:%-2c]]
      end
    }
  },
  options = {
    theme = 'tomorrow',
    section_separators = {'', ''},
    component_separators = {'', ''},
    globalstatus = true,
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

-- §§1 Plugin settings for pretty-fold.nvim

require('pretty-fold').setup{
    fill_char = '┄',
    sections = {
        left = {
            'content',
        },
        right = {
            ' ', 'number_of_folded_lines', ': ', 'percentage', ' ',
            function(config) return config.fill_char:rep(3) end
        }
    },

    remove_fold_markers = true,

    -- Keep the indentation of the content of the fold string.
    keep_indentation = true,

    -- Possible values:
    -- "delete" : Delete all comment signs from the fold string.
    -- "spaces" : Replace all comment signs with equal number of spaces.
    -- false    : Do nothing with comment signs.
    comment_signs = 'spaces',

    -- List of patterns that will be removed from content foldtext section.
    stop_words = {
        '@brief%s*', -- (for cpp) Remove '@brief' and all spaces after.
    },

    add_close_pattern = true,
    matchup_patterns = {
        { '{', '}' },
        { '%(', ')' }, -- % to escape lua pattern char
        { '%[', ']' }, -- % to escape lua pattern char
        { 'if%s', 'end' },
        { 'do%s', 'end' },
        { 'for%s', 'end' },
    },
}
-- require('pretty-fold.preview').setup_keybinding()

-- §§1 Plugin settings for neorg.nvim
require('neorg').setup {
    load = {
        ["core.defaults"] = {}
    }
}

-- §§1 Plugin settings for lambdalisue/fern.vim

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

    vim.cmd[[
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

    -- vim.keymap.set("n", "l", "<Plug>(fern-open-or-expand)", {remap = true, buffer = true})
    vim.keymap.set("n", "<C-h>", "<Plug>(fern-action-leave)", {remap = true, buffer = true})
    vim.keymap.set("n", "<CR>", "<Plug>(fern-open-or-enter)", {remap = true, buffer = true, nowait = true})
    vim.keymap.set("n", "e", "<Plug>(fern-action-open)", {remap = true, buffer = true})
    vim.keymap.set("n", "<BS>", "<Plug>(fern-action-leave)", {remap = true, buffer = true})

    -- vim.keymap.set("n", "<Space>", "<Plug>(fern-action-mark)", {remap = true, buffer = true, nowait = true})

    vim.keymap.set("n", ">>", "<Plug>(fern-action-mark:set)", {remap = true, buffer = true, nowait = true})
    -- なぜか unset のときファイル末尾にジャンプしてしまうので <C-o> を付けた
    vim.keymap.set("n", "<<", "<Plug>(fern-action-mark:unset)<C-o>", {remap = true, buffer = true, nowait = true})
    vim.keymap.set("x", ">", "<Plug>(fern-action-mark:set)", {remap = true, buffer = true, nowait = true})
    vim.keymap.set("x", "<", "<Plug>(fern-action-mark:unset)", {remap = true, buffer = true, nowait = true})

    vim.keymap.set("n", "t", "<Plug>(fern-expand-or-collapse)", {remap = true, buffer = true, nowait = true})
    vim.keymap.set("n", "T", "<Plug>(fern-action-collapse)", {remap = true, buffer = true, nowait = true})

    vim.keymap.set("n", "o", "<Plug>(fern-action-new-file)", {remap = true, buffer = true})
    vim.keymap.set("n", "O", "<Plug>(fern-action-new-dir)", {remap = true, buffer = true})

    vim.keymap.set("n", "d", "<Plug>(fern-action-trash)", {remap = true, buffer = true, nowait = true})
    vim.keymap.set("n", "r", "<Plug>(fern-action-rename)", {remap = true, buffer = true, nowait = true})
    vim.keymap.set("n", "c", "<Plug>(fern-action-copy)", {remap = true, buffer = true, nowait = true})
    vim.keymap.set("n", "m", "<Plug>(fern-action-move)", {remap = true, buffer = true, nowait = true})

    vim.keymap.set("n", "<C-l>", "<Plug>(fern-action-redraw)", {remap = true, buffer = true})

    local fern_excluded = true

    vim.keymap.set("n", "<Plug>(fern-exclude-toggle)", function ()
        if fern_excluded then
            fern_excluded = false
            return [[<Plug>(fern-action-exclude=)<C-u><CR>]]
        end
        fern_excluded = true
        return ([[<Plug>(fern-action-exclude=)<C-u>%s<CR>]]):format(vim.g["fern#default_exclude"])
    end, {expr = true, buffer = true})

    vim.keymap.set("n", "!", "<Plug>(fern-exclude-toggle)", {remap = true, buffer = true, nowait = true})
end

util.autocmd_vimrc("FileType"){
    pattern = "fern",
    callback = fern_buffer_config
}

-- §§1 Plugin settings for gina.vim

util.autocmd_vimrc{"FileType"}{
    pattern = "gina-blame",
    callback = function ()
        vim.opt_local.number = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.foldcolumn = "0"
    end
}

util.autocmd_vimrc{"FileType"}{
    pattern = "gina-status",
    callback = function ()
        vim.keymap.set("n", "<C-l>", "<Cmd>e<CR>", {buffer = true})
    end
}

util.autocmd_vimrc{"FileType"}{
    pattern = "gina-log",
    callback = function ()
        vim.keymap.set("n", "c", "<Plug>(gina-changes-between)", {buffer = true, nowait = true})
        vim.keymap.set("n", "C", "<Plug>(gina-commit-checkout)", {buffer = true, nowait = true})
        vim.keymap.set("n", "}", [[<Cmd>call search('\v%^<Bar>%$<Bar>^(.*\x{7})@!.*$', 'W')<CR>]], {buffer = true, nowait = true})
        vim.keymap.set("n", "{", [[<Cmd>call search('\v%^<Bar>%$<Bar>^(.*\x{7})@!.*$', 'Wb')<CR>]], {buffer = true, nowait = true})
    end
}

vim.g["gina#command#blame#formatter#format"] = '%su%=|%au %ti %ma%in'

vim.api.nvim_create_user_command("GinaBrowseYank", function (meta)
    vim.cmd(([[%d,%dGina browse --exact --yank :]]):format(meta.line1, meta.line2))
    vim.cmd[[
      let @+ = @"
      echo @+
    ]]
end, {range = "%"})

-- §§1 Plugin settings for lualine.nvim
vim.keymap.set("n", "U", "<Cmd>UndotreeToggle<CR>")
-- vim.cmd[[
-- nnoremap U :<C-u>UndotreeToggle<CR>
-- ]]

-- §§1 Plugin settings for rhysd/rust-doc.vim
vim.g["rust_doc#define_map_K"] = 0

-- §§1 Plugin settings for rust-lang/rust.vim
vim.g["rustfmt_autosave"] = 1

-- §§1 Plugin settings for tpope/vim-capslock
vim.keymap.set("i", "<C-l>", "<Nop>")

-- §§1 Plugin settings for tyru/caw.vim
vim.keymap.set("n", ",", "<Plug>(caw:hatpos:toggle:operator)")
vim.keymap.set("n", ",,", ",_", {remap = true})
vim.keymap.set("x", ",", "<Plug>(caw:hatpos:toggle)")

-- §§1 Plugin settings for tyru/open-browser
vim.keymap.set({"n", "x"}, "gb", "<Plug>(openbrowser-smart-search)")

-- §§1 Plugin settings for vim-session

local session_dir = vim.fn["xolox#misc#path#merge"](vim.fn.getcwd(), ".vimsessions")

if util.to_bool(vim.fn.isdirectory(session_dir)) then
    vim.g.session_directory = session_dir
    vim.g.session_autosave = "yes"
    vim.g.session_autoload = "yes"
else
    vim.g.session_autosave = "no"
    vim.g.session_autoload = "no"
end

-- §§1 Plugin settings for bufferline.nvim
require("bufferline").setup{
    options = {
        diagnostics = "coc",
        -- separator_style = "thin",
        separator_style = "slant",
        indicator = {
            style = "none"
            -- style = "underline"
        },
        left_trunc_marker = '',
        right_trunc_marker = '',
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
        background                  = { bg = "#666666", fg = "#bbbbbb" },
        tab                         = { bg = "#666666", fg = "#bbbbbb" },
        tab_selected                = { bg = "None"   , fg = "#ebdbb2" },
        tab_close                   = { bg = "#666666", fg = "#bbbbbb" },
        close_button                = { bg = "#666666", fg = "#bbbbbb" },
        close_button_visible        = { bg = "#444444", fg = "#ebdbb2" },
        close_button_selected       = { bg = "None"   , fg = "#ebdbb2" },
        buffer_visible              = { bg = "#444444", fg = "#ebdbb2" },
        buffer_selected             = { bg = "None"   , fg = "#ebdbb2" },
        numbers                     = { bg = "#666666", fg = "#bbbbbb" },
        numbers_visible             = { bg = "#444444", fg = "#ebdbb2" },
        numbers_selected            = { bg = "None"   , fg = "#ebdbb2" },
        diagnostic                  = { bg = "#666666",                },
        diagnostic_visible          = { bg = "#444444",                },
        diagnostic_selected         = { bg = "None"   ,                },
        hint                        = { bg = "#666666", fg = "#bbbbbb" },
        hint_visible                = { bg = "#444444", fg = "#ebdbb2" },
        hint_selected               = { bg = "None"   , fg = "#ebdbb2" },
        hint_diagnostic             = { bg = "#666666", fg = "#bbbbbb" },
        hint_diagnostic_visible     = { bg = "#444444", fg = "#ebdbb2" },
        hint_diagnostic_selected    = { bg = "None"   , fg = "#ebdbb2" },
        info                        = { bg = "#666666", fg = "#bbbbbb" },
        info_visible                = { bg = "#444444", fg = "#ebdbb2" },
        info_selected               = { bg = "None"   , fg = "#ebdbb2" },
        info_diagnostic             = { bg = "#666666", fg = "#bbbbbb" },
        info_diagnostic_visible     = { bg = "#444444", fg = "#ebdbb2" },
        info_diagnostic_selected    = { bg = "None"   , fg = "#ebdbb2" },
        warning                     = { bg = "#666666",                },
        warning_visible             = { bg = "#444444",                },
        warning_selected            = { bg = "None"   ,                },
        warning_diagnostic          = { bg = "#666666",                },
        warning_diagnostic_visible  = { bg = "#444444",                },
        warning_diagnostic_selected = { bg = "None"   ,                },
        error                       = { bg = "#666666", fg = "#dd7777" },
        error_visible               = { bg = "#444444", fg = "#dd4444" },
        error_selected              = { bg = "None"   ,                },
        error_diagnostic            = { bg = "#666666", fg = "#dd7777" },
        error_diagnostic_visible    = { bg = "#444444", fg = "#dd4444" },
        error_diagnostic_selected   = { bg = "None"   ,                },
        modified                    = { bg = "#666666",                },
        modified_visible            = { bg = "#444444",                },
        modified_selected           = { bg = "None"   ,                },
        duplicate_selected          = { bg = "None"   ,                },
        duplicate_visible           = { bg = "#444444",                },
        duplicate                   = { bg = "#666666",                },
        indicator_selected          = { bg = "None"   , fg = "#ebdbb2" },
        pick_selected               = { bg = "None"   , fg = "#ebdbb2" },
        pick_visible                = { bg = "#444444", fg = "#ebdbb2" },
        pick                        = { bg = "#666666", fg = "#bbbbbb" },
        offset_separator            = { bg = "#666666", fg = "#ebdbb2" },

        fill                        = { bg = "#c8c8c8" },
        separator                   = { bg = "#666666", fg = "#c8c8c8" },
        separator_visible           = { bg = "#444444", fg = "#c8c8c8" },
        separator_selected          = { bg = "None"   , fg = "#c8c8c8" },
    }

}

vim.keymap.set("n", "sn", "<Cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "sp", "<Cmd>BufferLineCyclePrev<CR>")
vim.keymap.set("n", "sN", "<Cmd>BufferLineMoveNext<CR>")
vim.keymap.set("n", "sP", "<Cmd>BufferLineMovePrev<CR>")
vim.keymap.set("n", "sw", "<Cmd>BufferLineCyclePrev<CR><Cmd>bd! #<CR>")

-- §§1 Plugin settings for asterisk
vim.keymap.set("n", "*", "<Plug>(asterisk-z*)")
vim.keymap.set("n", "#", "<Plug>(asterisk-z#)")
vim.keymap.set("n", "g*", "<Plug>(asterisk-gz*)")
vim.keymap.set("n", "g#", "<Plug>(asterisk-gz#)")

-- §§1 Plugin settings for markdown-preview.nvim

vim.g.mkdp_markdown_css = vim.fn.expand("~/.config/nvim/scripts/resource/github-markdown-light.css")
vim.g.mkdp_auto_close = 0
vim.g.mkdp_preview_options = {
    disable_sync_scroll = 1,
}

-- §§1 Plugin settings for altr

vim.keymap.set("n", "<Space>^", "<Plug>(altr-forward)", {remap = true})
vim.keymap.set("n", "<Space>-", "<Plug>(altr-forward)", {remap = true})

-- §§1 Plugin settings for vista
-- vim.keymap.set("n", "sm", ":<C-u>Vista!!<CR>", {silent = true})

util.autocmd_vimrc{"FileType"}{
    pattern = "vista",
    callback = function ()
        vim.keymap.set("n", "<C-]>", "<Cmd>call vista#cursor#FoldOrJump()<CR>", {buffer = true, nowait = true})
        vim.keymap.set("n", "<CR>", "<Cmd>call vista#cursor#FoldOrJump()<CR>", {buffer = true, nowait = true})
    end
}

-- §§1 Plugin settings for emmet.vim

vim.g["user_emmet_mode"] = "n"
vim.g["emmet_html5"] = 0
vim.g["user_emmet_install_global"] = 0
-- util.autocmd_vimrc{"FileType"}{
    --     pattern = {
        --         "html",
        --         "css",
        --         "svelte",
        --     },
        --     command = "EmmetInstall",
        -- }

        -- §§1 Plugin settings for scrollbar
        -- require("scrollbar").setup()
