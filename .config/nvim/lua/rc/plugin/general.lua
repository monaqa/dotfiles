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

    vim.keymap.set("n", "l", "<Plug>(fern-open-or-expand)", {remap = true, buffer = true})
    vim.keymap.set("n", "<C-h>", "<Plug>(fern-action-leave)", {remap = true, buffer = true})
    vim.keymap.set("n", "<CR>", "<Plug>(fern-open-or-enter)", {remap = true, buffer = true, nowait = true})
    vim.keymap.set("n", "e", "<Plug>(fern-action-open)", {remap = true, buffer = true})
    vim.keymap.set("n", "<BS>", "<Plug>(fern-action-leave)", {remap = true, buffer = true})
    vim.keymap.set("n", "<Space>", "<Plug>(fern-action-mark)", {remap = true, buffer = true, nowait = true})

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
vim.cmd[[
nnoremap U :<C-u>UndotreeToggle<CR>
]]

-- §§1 Plugin settings for rhysd/rust-doc.vim
vim.g["rust_doc#define_map_K"] = 0

-- §§1 Plugin settings for rust-lang/rust.vim
vim.g["rustfmt_autosave"] = 1

-- §§1 Plugin settings for thinca/vim-submode
vim.cmd[[
call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

call submode#enter_with('vertjmp', 'n', '', '<Space>;', ':LineSameSearch<CR>')
call submode#enter_with('vertjmp', 'n', '', '<Space>,', ':LineBackSameSearch<CR>')
call submode#map('vertjmp', 'n', '', ';', ':LineSameSearch<CR>')
call submode#map('vertjmp', 'n', '', ',', ':LineBackSameSearch<CR>')
call submode#leave_with('vertjmp', 'n', '', '<Space>')
]]

-- §§1 Plugin settings for tpope/vim-capslock
vim.cmd[[
inoremap <C-l> <Nop>
]]

-- §§1 Plugin settings for tyru/caw.vim
vim.cmd[[
nmap , <Plug>(caw:hatpos:toggle:operator)
nmap ,, ,_
vmap , <Plug>(caw:hatpos:toggle)

augroup vimrc
  autocmd FileType pest let b:caw_oneline_comment = '//'
augroup END
]]

-- §§1 Plugin settings for tyru/open-browser
vim.cmd[[
nmap gb <Plug>(openbrowser-smart-search)
xmap gb <Plug>(openbrowser-smart-search)
]]

-- §§1 Plugin settings for tyru/open-browser
vim.cmd[[
let s:local_session_directory = xolox#misc#path#merge(getcwd(), '.vimsessions')
" 存在すれば
if isdirectory(s:local_session_directory)
  " session保存ディレクトリをそのディレクトリの設定
  let g:session_directory = s:local_session_directory
  " vimを辞める時に自動保存
  let g:session_autosave = 'yes'
  " 引数なしでvimを起動した時にsession保存ディレクトリのdefault.vimを開く
  let g:session_autoload = 'yes'
  " 1分間に1回自動保存
  " let g:session_autosave_periodic = 1
else
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'
endif
unlet s:local_session_directory
]]

-- §§1 Plugin settings for barbar.nvim
vim.cmd[[
nnoremap sp <Cmd>BufferPrevious<CR>
nnoremap sn <Cmd>BufferNext<CR>
nnoremap s1 <Cmd>BufferGoto 1<CR>
nnoremap s2 <Cmd>BufferGoto 2<CR>
nnoremap s3 <Cmd>BufferGoto 3<CR>
nnoremap s4 <Cmd>BufferGoto 4<CR>
nnoremap s5 <Cmd>BufferGoto 5<CR>
nnoremap s6 <Cmd>BufferGoto 6<CR>
nnoremap s7 <Cmd>BufferGoto 7<CR>
nnoremap s8 <Cmd>BufferGoto 8<CR>
nnoremap s9 <Cmd>BufferGoto 9<CR>
nnoremap sP <Cmd>BufferMovePrevious<CR>
nnoremap sN <Cmd>BufferMoveNext<CR>

nnoremap sw <Cmd>BufferClose<CR>
]]

-- §§1 Plugin settings for asterisk
vim.cmd[[
nmap *  <Plug>(asterisk-z*)
nmap #  <Plug>(asterisk-z#)
nmap g* <Plug>(asterisk-gz*)
nmap g# <Plug>(asterisk-gz*)
]]

-- §§1 Plugin settings for markdown-preview.nvim
vim.cmd[[
let g:mkdp_markdown_css = expand('~/.config/nvim/scripts/resource/github-markdown-light.css')
let g:mkdp_auto_close = 1
let g:mkdp_preview_options = {
    "\ 'mkit': {},
    "\ 'katex': {},
    "\ 'uml': {},
    "\ 'maid': {},
    \ 'disable_sync_scroll': 1,
    "\ 'sync_scroll_type': 'middle',
    "\ 'hide_yaml_meta': 1,
    "\ 'sequence_diagrams': {},
    "\ 'flowchart_diagrams': {},
    "\ 'content_editable': v:false,
    "\ 'disable_filename': 0
    \ }
]]

-- §§1 Plugin settings for altr

vim.keymap.set("n", "<Space>^", "<Plug>(altr-forward)", {remap = true})

-- §§1 Plugin settings for vista
vim.keymap.set("n", "sm", ":<C-u>Vista!!<CR>", {silent = true})

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
