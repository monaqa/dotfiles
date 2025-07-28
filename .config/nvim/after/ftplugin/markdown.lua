local monaqa = require("monaqa")
local create_cmd = monaqa.shorthand.create_cmd
local mapset = monaqa.shorthand.mapset_local

vim.cmd([[
    let g:vim_markdown_frontmatter = 1

    " マークダウンのタイトルのパターンにマッチしたらそのタイトルの深さを返す。
    " マッチしなかったら -1 を返す。
    function! s:markdown_title_pattern(text)
      let mch = matchlist(a:text, '\v^(#{1,6}) ')
      if mch[0] !=# ''
        return strlen(mch[1])
      endif
      return -1
    endfunction

    function! MarkdownLevel(lnum)
      let initial_depth = s:markdown_title_pattern(getline(1))
      if initial_depth < 0
        let initial_depth = 0
      endif

      let syntax_name = synIDattr(synIDtrans(synID(a:lnum, 1, 0)), "name")
      if syntax_name =~# 'Comment\|String'
        return "="
      endif

      let lnum_depth = s:markdown_title_pattern(getline(a:lnum))
      if lnum_depth < 0
        " タイトル行でなかったら問答無用で前の行の継続
        return "="
      endif

      " タイトル行なら initial_depth のオフセットを
      " 差し引いたものを見出しレベルとする
      return ">" .. max([0, lnum_depth - initial_depth])
    endfunction

    " 行頭にて - ] と打つと Checkbox list となる
    inoreabbrev <buffer><expr> ] (getline('.') =~# '\s*[-*] ]') ? '[ ]' : ']'

    " 選択テキストをハイパーリンク化
    xnoremap <buffer> L "lc[<C-r>=substitute(getreg("l"), '\n', '', 'g')<CR>](<C-r>=substitute(getreg("+"), '\n', '', 'g')<CR>)<Esc>
]])

vim.opt_local.shiftwidth = 4
vim.opt_local.spell = true
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "MarkdownLevel(v:lnum)"
vim.opt_local.suffixesadd:append(".md")
-- vim.opt_local.conceallevel = 2

vim.opt_local.comments = {
    "nb:>",
    "b:* [x]",
    "b:* [ ]",
    "b:*",
    "b:- [x]",
    "b:- [ ]",
    "b:-",
    "b:1. ",
}

vim.opt_local.formatoptions:remove("c")
vim.opt_local.formatoptions:append("j")
vim.opt_local.formatoptions:append("r")

mapset.n("@o") { "<Cmd>MarkdownPreview<CR>" }

create_cmd("CorrectLinks") {
    desc = [[Typst 形式のリンクを Markdown 形式に直す]],
    range = "%",
    function(meta)
        vim.cmd.substitute {
            [[/\c\v#link\("(.*)"\)\[(.*)\]/[\2](\1)/g]],
            range = { meta.line1, meta.line2 },
            mods = { keeppatterns = true },
        }
    end,
}
