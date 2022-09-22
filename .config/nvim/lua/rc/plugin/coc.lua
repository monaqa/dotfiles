-- vim:fdm=marker:fmr=§§,■■

local util = require "rc.util"

-- §§1 Plugin settings for neoclide/coc.nvim

vim.cmd[[
function! CocServiceNames(ArgLead, CmdLine, CursorPos)
  let actions = map(CocAction('services'), {idx, d -> d['id']})
  return actions
endfunction

command! -nargs=1 -complete=customlist,CocServiceNames CocToggleService call CocAction('toggleService', <q-args>)
]]

vim.o.tagfunc="CocTagFunc"

vim.g["coc_global_extensions"] = {
    "coc-snippets",
    "coc-marketplace",
    "coc-rust-analyzer",
    "coc-pyright",
    "coc-json",
    "coc-deno",
}

vim.keymap.set("n", "gd", "<C-]>")

vim.keymap.set("n", "t", "<Nop>")
vim.keymap.set("n", "td", "<Cmd>Telescope coc definitions<CR>")
vim.keymap.set("n", "ti", "<Cmd>Telescope coc implementations<CR>")
vim.keymap.set("n", "tr", "<Cmd>Telescope coc references<CR>")
vim.keymap.set("n", "ty", "<Cmd>Telescope coc type_definitions<CR>")
vim.keymap.set("n", "tn", "<Plug>(coc-rename)", {remap = true})
vim.keymap.set("n", "K", "<Cmd>call CocActionAsync('doHover')<CR>")
vim.keymap.set("n", "<C-n>", "<Plug>(coc-diagnostic-next-error)")
vim.keymap.set("n", "<C-p>", "<Plug>(coc-diagnostic-prev-error)")
vim.keymap.set("n", "ta", "<Plug>(coc-codeaction-cursor)", {remap = true})
vim.keymap.set("x", "ta", "<Plug>(coc-codeaction-selected)", {remap = true})

-- coc#_select_confirm などは Lua 上では動かないので、 <Plug> にマッピングして使えるようにする
vim.cmd[[
    inoremap <expr> <Plug>(vimrc-coc-select-confirm) coc#_select_confirm()
    inoremap <expr> <Plug>(vimrc-lexima-expand-cr) lexima#expand('<LT>CR>', 'i')
]]

vim.keymap.set("i", "<CR>", function ()
    if util.to_bool(vim.fn["coc#pum#visible"]()) then
        -- 補完候補をセレクトしていたときのみ、補完候補の内容で確定する
        -- （意図せず補完候補がセレクトされてしまうのを抑止）
        if (vim.fn["coc#pum#info"]()["index"] >= 0) then
            return "<Plug>(vimrc-coc-select-confirm)"
        end
        return "<C-y><Plug>(vimrc-lexima-expand-cr)"
    end
    return "<Plug>(vimrc-lexima-expand-cr)"
end, {expr = true, remap = true})

local function coc_check_backspace()
    local col = vim.fn.col(".") - 1
    if not util.to_bool(col) then
        return true
    end
    return vim.regex([[\s]]):match_str(vim.fn.getline(".")[col])
end

-- coc#pum#next(1) などが Vim script 上でしか動かないっぽい

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

vim.cmd[[
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

