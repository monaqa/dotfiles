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
        return "" .. vim.fn["gina#component#repo#branch"]()
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
vim.g["fern#rendered"] = "nerdfont"

vim.keymap.set("n", "sf", "<Cmd>Fern . -reveal=%:p<CR>")
vim.keymap.set("n", "sz", "<Cmd>Fern . -drawer -toggle<CR>")

local function fern_buffer_config()
    vim.wo.number = false
    vim.wo.signcolumn = "no"
    vim.wo.foldcolumn = "0"

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

    vim.keymap.set("n", "l", "<Plug>(fern-open-or-expand)", {remap = true, buffer = true})
    vim.keymap.set("n", "<C-h>", "<Plug>(fern-action-leave)", {remap = true, buffer = true})
    vim.keymap.set("n", "<CR>", "<Plug>(fern-open-or-enter)", {remap = true, buffer = true, nowait = true})
    vim.keymap.set("n", "e", "<Plug>(fern-action-open)", {remap = true, buffer = true})
    vim.keymap.set("n", "<BS>", "<Plug>(fern-action-leave)", {remap = true, buffer = true})
    vim.keymap.set("n", "<Space>", "<Plug>(fern-open-mark)", {remap = true, buffer = true, nowait = true})

    vim.keymap.set("n", "t", "<Plug>(fern-expand-or-collapse)", {remap = true, buffer = true, nowait = true})
    vim.keymap.set("n", "T", "<Plug>(fern-action-collapse)", {remap = true, buffer = true, nowait = true})

    vim.keymap.set("n", "o", "<Plug>(fern-action-new-file)", {remap = true, buffer = true})
    vim.keymap.set("n", "O", "<Plug>(fern-action-new-dir)", {remap = true, buffer = true})

    vim.keymap.set("n", "d", "<Plug>(fern-action-trash)", {remap = true, buffer = true})
    vim.keymap.set("n", "r", "<Plug>(fern-action-rename)", {remap = true, buffer = true})
    vim.keymap.set("n", "c", "<Plug>(fern-action-copy)", {remap = true, buffer = true})
    vim.keymap.set("n", "m", "<Plug>(fern-action-move)", {remap = true, buffer = true})

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
