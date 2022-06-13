-- vim:fdm=marker:fmr=§§,■■

-- §§1 Plugin settings for dial.nvim
vim.fn["DialConfig"] = function ()
    vim.cmd[[packadd dial.nvim]]

    local augend = require("dial.augend")
    require("dial.config").augends:register_group{
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
            augend.hexcolor.new {case = "lower"},
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
            augend.hexcolor.new {case = "lower"},
            augend.semver.alias.semver,
            augend.misc.alias.markdown_header,
        },
    }

    vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), {noremap = true})
    vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), {noremap = true})
    vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), {noremap = true})
    vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), {noremap = true})
    vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), {noremap = true})
    vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), {noremap = true})

    vim.cmd[[
  augroup vimrc
    autocmd FileType markdown lua vim.api.nvim_set_keymap("n", "<C-a>",   require("dial.map").inc_normal("markdown"), {noremap = true})
    autocmd FileType markdown lua vim.api.nvim_set_keymap("n", "<C-x>",   require("dial.map").dec_normal("markdown"), {noremap = true})
    autocmd FileType markdown lua vim.api.nvim_set_keymap("v", "<C-a>",   require("dial.map").inc_visual("markdown"), {noremap = true})
    autocmd FileType markdown lua vim.api.nvim_set_keymap("v", "<C-x>",   require("dial.map").dec_visual("markdown"), {noremap = true})
    autocmd FileType markdown lua vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual("markdown"), {noremap = true})
    autocmd FileType markdown lua vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual("markdown"), {noremap = true})
  augroup END
    ]]
end

if vim.fn.getcwd() ~= '/Users/monaqa/ghq/github.com/monaqa/dial.nvim' then
    vim.fn["DialConfig"]()
    vim.cmd[[echom 'general config of dial.vim is loaded.']]
end

-- §§1 Plugin settings for monaqa/smooth-scroll.vim

vim.cmd[[
let g:smooth_scroll_no_default_key_mappings = 1
let g:smooth_scroll_interval = 1000.0 / 40
let g:smooth_scroll_scrollkind = "quintic"
let g:smooth_scroll_add_jumplist = v:true

nnoremap <C-d> <Cmd>call smooth_scroll#flick( v:count1 * &scroll     , 15, 'j', 'k')<CR>
nnoremap <C-u> <Cmd>call smooth_scroll#flick(-v:count1 * &scroll     , 15, 'j', 'k')<CR>
nnoremap <C-f> <Cmd>call smooth_scroll#flick( v:count1 * winheight(0), 25, 'j', 'k')<CR>
nnoremap <C-b> <Cmd>call smooth_scroll#flick(-v:count1 * winheight(0), 25, 'j', 'k')<CR>
vnoremap <C-d> <Cmd>call smooth_scroll#flick( v:count1 * &scroll     , 15, 'j', 'k')<CR>
vnoremap <C-u> <Cmd>call smooth_scroll#flick(-v:count1 * &scroll     , 15, 'j', 'k')<CR>
vnoremap <C-f> <Cmd>call smooth_scroll#flick( v:count1 * winheight(0), 25, 'j', 'k')<CR>
vnoremap <C-b> <Cmd>call smooth_scroll#flick(-v:count1 * winheight(0), 25, 'j', 'k')<CR>

nnoremap zz    <Cmd>call smooth_scroll#flick(winline() - winheight(0) / 2, 10, "\<C-e>", "\<C-y>", v:true)<CR>
nnoremap z<CR> <Cmd>call smooth_scroll#flick(winline() - 1               , 10, "\<C-e>", "\<C-y>", v:true)<CR>
nnoremap zb    <Cmd>call smooth_scroll#flick(winline() - winheight(0)    , 10, "\<C-e>", "\<C-y>", v:true)<CR>
]]


-- §§1 Plugin settings for monaqa/vim-edgemotion

vim.cmd[[
nmap <C-n> m`<Plug>(edgemotion-j)
nmap <C-p> m`<Plug>(edgemotion-k)
vmap <C-n> <Plug>(edgemotion-j)
vmap <C-p> <Plug>(edgemotion-k)
]]

-- §§1 Plugin settings for modesearch.vim
vim.cmd[[
nmap / <Plug>(modesearch-slash-rawstr)
nmap ? <Plug>(modesearch-slash-regexp)
cmap <C-x> <Plug>(modesearch-toggle-mode)
nnoremap _ /
]]

-- §§1 Plugin settings for partedit
vim.cmd[[
let g:partedit#opener = ":vsplit"
let g:partedit#prefix_pattern = '\v\s*'

command! -range ParteditCodeblock call s:partedit_code_block(<line1>, <line2>)
function! s:partedit_code_block(line1, line2)
  let line_codeblock_start = getline(a:line1 - 1)
  let filetype = matchstr(line_codeblock_start, '\v```\zs[-a-zA-Z0-9]+\ze')
  let options = { "filetype": filetype }
  call partedit#start(a:line1, a:line2, options)
endfunction
]]
