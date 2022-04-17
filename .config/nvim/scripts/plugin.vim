" vim:fdm=marker:fmr=§§,■■
" Package を load した後に設定するもの．

" Lua の設定の読み込み
call execute('luafile ' .. expand("<sfile>:p:h") .. '/plugin.lua')

" §§1 Plugin settings for cohama/lexima.vim

let g:lexima_no_default_rules = 1
call lexima#set_default_rules()
call lexima#add_rule({'at': '\%#[-0-9a-zA-Z_]', 'char': '{', 'input': '{'})
call lexima#add_rule({'at': '\%#\\', 'char': '{', 'input': '{', 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '$', 'input_after': '$', 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '$', 'at': '\%#\$', 'leave': 1, 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '$', 'input': '${', 'input_after': '}', 'filetype': ['satysfi']})
call lexima#add_rule({'char': '$', 'at': '\\\%#', 'leave': 1, 'filetype': ['satysfi']})
call lexima#add_rule({'char': '<BS>', 'at': '\$\%#\$', 'delete': 1, 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': "'", 'input':  "'", 'filetype': ['latex', 'tex', 'satysfi']})
call lexima#add_rule({'char': '``', 'input_after': '``', 'filetype': ['rst']})

inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u" . lexima#expand('<LT>CR>', 'i')

" §§1 Plugin settings for glts/vim-textobj-comment

let g:textobj_comment_no_default_key_mappings = 1
xmap am <Plug>(textobj-comment-a)
omap am <Plug>(textobj-comment-a)
xmap im <Plug>(textobj-comment-i)
omap im <Plug>(textobj-comment-i)

" §§1 Plugin settings for habamax/vim-gruvbit

augroup vimrc_colorscheme
  autocmd!
  autocmd ColorScheme gruvbit call s:setting_gruvbit()
  autocmd ColorScheme gruvbox-material call s:setting_gruvbox_material()
augroup END

function! s:setting_gruvbit() abort
  hi! FoldColumn guibg=#303030
  hi! NonText    guifg=#496da9
  hi! CocHintFloat guibg=#444444 guifg=#45daef
  hi! link CocRustChainingHint CocHintFloat
  " Diff に関しては前のバージョン
  " (https://github.com/habamax/vim-gruvbit/commit/a19259a1f02bbfff37d72eebef6b5d5d22f22248)
  " のほうが好みだったので。
  hi! DiffChange guifg=NONE guibg=#314a5c gui=NONE cterm=NONE
  hi! DiffDelete guifg=#968772 guibg=#5c3728 gui=NONE cterm=NONE
  hi! MatchParen guifg=#ebdbb2 guibg=#51547d gui=NONE cterm=NONE

  " hi! WeakTitle  cterm=bold ctermfg=225 gui=bold guifg=#fabd2f
  " hi! WeakTitle  gui=nocombine,NONE guifg=#e69393
  hi! WeakTitle  guifg=#fad57f
  hi! Quote      guifg=#c6b7a2

  hi! VertSplit  guifg=#c8c8c8 guibg=None    gui=NONE cterm=NONE
  hi! Visual     guifg=NONE    guibg=#4d564e gui=NONE cterm=NONE
  hi! VisualBlue guifg=NONE    guibg=#4d569e gui=NONE cterm=NONE
  hi! Pmenu      guibg=#505064

  hi! CursorLine           guifg=NONE    guibg=#535657
  hi! CursorColumn         guifg=NONE    guibg=#535657
  hi! QuickFixLine         guifg=NONE    guibg=#4d569e

  hi! BufferCurrent        guifg=#ebdbb2 guibg=#444444 gui=bold
  hi! BufferCurrentMod     guifg=#dc9656 guibg=#444444 gui=bold
  hi! BufferCurrentSign    guifg=#e9593d guibg=#444444 gui=bold
  hi! BufferCurrentTarget  guifg=red     guibg=#444444 gui=bold
  hi! BufferInactive       guifg=#bbbbbb guibg=#777777
  hi! BufferInactiveMod    guifg=#dc9656 guibg=#777777
  hi! BufferInactiveSign   guifg=#444444 guibg=#777777
  hi! BufferInactiveTarget guifg=red     guibg=#777777
  hi! BufferVisible        guifg=#888888 guibg=#444444
  hi! BufferVisibleMod     guifg=#dc9656 guibg=#444444
  hi! BufferVisibleSign    guifg=#888888 guibg=#444444
  hi! BufferVisibleTarget  guifg=red     guibg=#444444
  hi! BufferTabpages       guifg=#e9593d guibg=#444444 gui=bold
  hi! BufferTabpageFill    guifg=#888888 guibg=#c8c8c8
  hi! TabLineFill          guibg=#c8c8c8

  " nvim-treesitter
  hi! TSParameter ctermfg=14 guifg=#b3d5c8
  hi! TSField     ctermfg=14 guifg=#b3d5c8

  " Rust
  hi! rustCommentLineDoc   guifg=#a6a182

  " hi TypeBuiltin guifg=#fe8019 guibg=NONE gui=NONE cterm=NONE gui=bold
  " 
  " hi! link TSStrong    NONE
  " hi! link TSEmphasis  NONE
  " hi! link TSUnderline NONE
  " hi! link TSNote      NONE
  " hi! link TSWarning   WarningMsg
  " hi! link TSDanger    ErrorMsg
  " 
  " hi! link TSAnnotation Constant
  " hi! link TSAttribute Constant
  " hi! link TSBoolean Constant
  " hi! link TSCharacter String
  " hi! link TSComment Comment
  " hi! link TSConditional Statement
  " hi! link TSConstBuiltin Constant
  " hi! link TSConstMacro Constant
  " hi! link TSConstant Constant
  " hi! link TSConstructor Normal
  " hi! link TSException Statement
  " hi! link TSField Normal
  " hi! link TSFloat Constant
  " hi! link TSFuncBuiltin Normal
  " hi! link TSFuncMacro Normal
  " hi! link TSFunction Normal
  " hi! link TSInclude Statement
  " hi! link TSKeyword Statement
  " hi! link TSKeywordFunction Statement
  " hi! link TSKeywordOperator SpellRare
  " hi! link TSLabel SpellRare
  " hi! link TSMethod Normal
  " hi! link TSNamespace Type
  " hi! link TSNone Normal
  " hi! link TSNumber Constant
  " hi! link TSOperator SpellRare
  " hi! link TSParameterReference Normal
  " hi! link TSProperty String
  " hi! link TSPunctBracket Normal
  " hi! link TSPunctDelimiter Comment
  " hi! link TSPunctSpecial Special
  " hi! link TSRepeat Statement
  " hi! link TSString String
  " hi! link TSStringEscape String
  " hi! link TSStringRegex String
  " hi! link TSStructure BlueItalic
  " hi! link TSSymbol Normal
  " hi! link TSTag SpellRare
  " hi! link TSTagDelimiter String
  " hi! link TSText String
  " hi! link TSStrike Comment
  " hi! link TSMath String
  " hi! link TSType Type
  " hi! link TSTypeBuiltin TypeBuiltin
  " hi! link TSURI String
  " hi! link TSVariable Normal
  " hi! link TSVariableBuiltin Identifier

endfunction

function! s:setting_gruvbox_material() abort
  hi! BufferCurrent        guifg=#ebdbb2 guibg=#444444 gui=bold
  hi! BufferCurrentMod     guifg=#dc9656 guibg=#444444 gui=bold
  hi! BufferCurrentSign    guifg=#e9593d guibg=#444444 gui=bold
  hi! BufferCurrentTarget  guifg=red     guibg=#444444 gui=bold
  hi! BufferInactive       guifg=#bbbbbb guibg=#777777
  hi! BufferInactiveMod    guifg=#dc9656 guibg=#777777
  hi! BufferInactiveSign   guifg=#444444 guibg=#777777
  hi! BufferInactiveTarget guifg=red     guibg=#777777
  hi! BufferVisible        guifg=#888888 guibg=#444444
  hi! BufferVisibleMod     guifg=#dc9656 guibg=#444444
  hi! BufferVisibleSign    guifg=#888888 guibg=#444444
  hi! BufferVisibleTarget  guifg=red     guibg=#444444
  hi! BufferTabpages       guifg=#e9593d guibg=#444444 gui=bold
  hi! BufferTabpageFill    guifg=#888888 guibg=#c8c8c8
  hi! TabLineFill          guibg=#c8c8c8

  hi! LineNr       guifg=#888888
  hi! CursorLineNr guifg=#ebdbb2 guibg=#535657    gui=bold
  hi! CursorLine   guifg=NONE    guibg=#535657
  hi! CursorColumn guifg=NONE    guibg=#535657
  hi! QuickFixLine guifg=NONE    guibg=#4d569e
  hi! NonText      guifg=#496da9
  hi! WhiteSpace   guifg=#496da9
  hi! SpecialKey   guifg=#496da9
  hi! Folded       guifg=#9e8f7a guibg=#535657 gui=NONE cterm=NONE
  hi! VertSplit    guifg=#c8c8c8 guibg=None    gui=NONE cterm=NONE
  hi! MatchParen   guifg=#ebdbb2 guibg=#51547d gui=NONE cterm=NONE

  hi! Visual       guifg=NONE    guibg=#4d564e gui=NONE cterm=NONE
  hi! VisualBlue   guifg=NONE    guibg=#4d569e gui=NONE cterm=NONE

  hi! link IncSearch Search
  " hi! IncSearch    ctermfg=234 ctermbg=142 guifg=#1d2021 guibg=#a9b665
  " hi! link Search VisualBlue

  hi! Pmenu            guibg=#505064
  hi! NormalFloat      guibg=#505064
  hi! CocRustHintFloat guibg=#444444 guifg=#258aaf
  hi! link CocRustChainingHint CocRustHintFloat
  hi! link CocRustTypeHint     CocRustHintFloat

  hi! link TSField Normal
endfunction



" §§1 Plugin settings for kana/vim-altr

nmap <Space>^ <Plug>(altr-forward)

" §§1 Plugin settings for kana/vim-textobj-user

call textobj#user#plugin('line', {
\   '-': {
\     'select-a-function': 'CurrentLineA',
\     'select-a': 'al',
\     'select-i-function': 'CurrentLineI',
\     'select-i': 'il',
\   },
\ })

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

call textobj#user#plugin('jbraces', {
      \   'parens': {
      \       'pattern': ['（', '）'],
      \       'select-a': 'aj)', 'select-i': 'ij)'
      \  },
      \   'braces': {
      \       'pattern': ['「', '」'],
      \       'select-a': 'aj[', 'select-i': 'ij]'
      \  },
      \  'double-braces': {
      \       'pattern': ['『', '』'],
      \       'select-a': 'aj{', 'select-i': 'ij}'
      \  },
      \  'lenticular-bracket': {
      \       'pattern': ['【', '】'],
      \       'select-a': 'aj<', 'select-i': 'ij>'
      \  },
      \})

augroup rc_textobj_user
  autocmd!
  autocmd filetype tex call textobj#user#plugin('texquote', {
        \   'signle': {
        \     'pattern': ['`', "'"],
        \     'select-a': 'aq', 'select-i': 'iq'
        \   },
        \   'double': {
        \     'pattern': ['``', "''"],
        \     'select-a': 'aQ', 'select-i': 'iQ'
        \   },
        \ })
  autocmd filetype satysfi call textobj#user#plugin('satyblock', {
        \   'block': {
        \     'pattern': ['<%', '>%'],
        \     'select-a': 'a>', 'select-i': 'i>',
        \   },
        \ })
augroup END

" §§1 Plugin settings for lambdalisue/fern.vim

let s:exclude_files = [
\   '.*\.egg-info',
\   '.*\.pyc',
\   '\.DS_Store',
\   '\.git',
\   '\.mypy_cache',
\   '\.pytest_cache',
\   '\.vim',
\   '\.vimsessions',
\   '\.worktree',
\   '__pycache__',
\   'sumneko-lua-.*',
\   'Cargo.lock',
\   'poetry.lock',
\ ]

let g:fern#default_exclude = '^\%(' .. join(s:exclude_files, '\|') .. '\)$'

let g:fern#renderer = 'nerdfont'
nnoremap sf <Cmd>Fern . -reveal=%:p<CR>
nnoremap sz <Cmd>Fern . -drawer -toggle<CR>

augroup rc_fern
  autocmd!
  autocmd FileType fern setlocal nonumber
  autocmd FileType fern setlocal signcolumn=no
  autocmd FileType fern setlocal foldcolumn=0
  autocmd FileType fern call s:fern_settings()
augroup END

function s:fern_settings()
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

  " move cwd, open file
  nmap <buffer> l <Plug>(fern-open-or-expand)
  nmap <buffer> <C-h> <Plug>(fern-action-leave)
  nmap <nowait><buffer> <CR> <Plug>(fern-open-or-enter)
  nmap <buffer> e <Plug>(fern-action-open)
  nmap <buffer> <BS> <Plug>(fern-action-leave)
  nmap <nowait><buffer> <Space> <Plug>(fern-action-mark)

  " expand/collapse tree
  nmap <nowait><buffer> t <Plug>(fern-expand-or-collapse)
  nmap <nowait><buffer> T <Plug>(fern-action-collapse)

  " new
  nmap <buffer> o <Plug>(fern-action-new-file)
  nmap <buffer> O <Plug>(fern-action-new-dir)

  " move, remove, copy...
  nmap <nowait><buffer> d <Plug>(fern-action-trash)
  nmap <nowait><buffer> r <Plug>(fern-action-rename)
  nmap <nowait><buffer> c <Plug>(fern-action-copy)
  nmap <nowait><buffer> m <Plug>(fern-action-move)

  " other
  nmap <buffer> <C-l> <Plug>(fern-action-redraw)

  " toggle exclusion
  " nmap <nowait><buffer> ! <Plug>(fern-action-hidden-toggle)
  let s:fern_excluded = v:true

  function! s:fern_exclude_toggle()
    if s:fern_excluded
      let s:fern_excluded = v:false
      return "\<Plug>(fern-action-exclude=)\<C-u>\<CR>"
    endif
    let s:fern_excluded = v:true
    return "\<Plug>(fern-action-exclude=)\<C-u>" .. g:fern#default_exclude .. "\<CR>"
  endfunction
  nmap <expr><buffer> <Plug>(fern-exclude-toggle) <SID>fern_exclude_toggle()

  nmap <nowait><buffer> ! <Plug>(fern-exclude-toggle)

endfunction

" §§1 Plugin settings for lambdalisue/gina.vim

augroup rc_gina
  autocmd!
  autocmd FileType gina-blame setlocal nonumber
  autocmd FileType gina-blame setlocal signcolumn=no
  autocmd FileType gina-blame setlocal foldcolumn=0
  autocmd FileType gina-status nnoremap <buffer> <C-l> <Cmd>e<CR>

  autocmd FileType gina-log nmap <buffer><nowait> c <Plug>(gina-changes-between)

  autocmd FileType gina-log nmap <buffer><nowait> } <Cmd>call search('\v%^<Bar>%$<Bar>^(.*\x{7})@!.*$', 'W')<CR>
  autocmd FileType gina-log nmap <buffer><nowait> { <Cmd>call search('\v%^<Bar>%$<Bar>^(.*\x{7})@!.*$', 'Wb')<CR>
augroup END

let g:gina#command#blame#formatter#format = '%su%=|%au %ti %ma%in'

let s:gina_custom_translation_patterns = [
\   [
\     '\vhttps?://(%domain)/(.{-})/(.{-})%(\.git)?$',
\     '\vgit://(%domain)/(.{-})/(.{-})%(\.git)?$',
\     '\vgit\@(%domain):(.{-})/(.{-})%(\.git)?$',
\     '\vssh://git\@(%domain)/(.{-})/(.{-})%(\.git)?$',
\   ], {
\     'root':  'https://\1/\2/\3/tree/%r1/',
\     '_':     'https://\1/\2/\3/blob/%r1/%pt%{#L|}ls%{-L}le',
\     'exact': 'https://\1/\2/\3/blob/%h1/%pt%{#L|}ls%{-L}le',
\   },
\ ]

command! -range=% GinaBrowseYank call s:gina_browse_yank(<line1>, <line2>)

function! s:gina_browse_yank(line1, line2)
  execute a:line1 .. ',' .. a:line2 .. 'Gina browse --exact --yank :'
  let @+ = @"
  echo @+
endfunction

" §§1 Plugin settings for lervag/vimtex

let g:vimtex_compiler_latexmk = {'callback' : 0}
let g:tex_flavor = "latex"
let g:vimtex_fold_enabled = 1
let g:vimtex_indent_ignored_envs = ['document', 'frame']
let g:vimtex_imaps_leader = "@"


" §§1 Plugin settings for liuchengxu/vista.vim

nnoremap <silent> sm :<C-u>Vista!!<CR>

augroup vimrc
  autocmd filetype vista nnoremap <buffer> <C-]> <Cmd>call vista#cursor#FoldOrJump()<CR>
  autocmd filetype vista nnoremap <buffer><nowait> <CR> <Cmd>call vista#cursor#FoldOrJump()<CR>
augroup END

" §§1 Plugin settings for machakann/vim-textobj-functioncall

let g:textobj_functioncall_no_default_key_mappings = 1
" ジェネリクスも関数呼び出しとして扱う
let g:textobj_functioncall_patterns = [
  \ {
  \   'header' : '\<\%(\h\k*\.\)*\h\k*',
  \   'bra'    : '(',
  \   'ket'    : ')',
  \   'footer' : '',
  \ },
  \ {
  \   'header' : '\<\h\k*',
  \   'bra'    : '<',
  \   'ket'    : '>',
  \   'footer' : '',
  \ },
  \ ]

" §§1 Plugin settings for machakann/vim-sandwich

call operator#sandwich#set('all', 'all', 'highlight', 0)

" 従来のキーマッピングを保存
nmap ds <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap dsb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
nmap cs <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap csb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
" runtime macros/sandwich/keymap/surround.vim

" 開きカッコを指定したときの挙動を自分好みに
let g:sandwich#recipes += [
\   {'buns': [' {', '} '], 'nesting': 1, 'match_syntax': 1,
\    'kind': ['add', 'replace'], 'action': ['add'], 'input': ['{']},
\
\   {'buns': [' [', '] '], 'nesting': 1, 'match_syntax': 1,
\    'kind': ['add', 'replace'], 'action': ['add'], 'input': ['[']},
\
\   {'buns': [' (', ') '], 'nesting': 1, 'match_syntax': 1,
\    'kind': ['add', 'replace'], 'action': ['add'], 'input': ['(']},
\
\   {'buns': ['\s*{', '}\s*'],   'nesting': 1, 'regex': 1,
\    'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
\    'action': ['delete'], 'input': ['{']},
\
\   {'buns': ['\s*\[', '\]\s*'], 'nesting': 1, 'regex': 1,
\    'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
\    'action': ['delete'], 'input': ['[']},
\
\   {'buns': ['\s*(', ')\s*'],   'nesting': 1, 'regex': 1,
\    'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
\    'action': ['delete'], 'input': ['(']},
\ ]

" 日本語のカッコ
let g:sandwich#recipes += [
\   {'buns': ['（', '）'], 'nesting': 1, 'input': ['j(', 'j)', 'jp']},
\   {'buns': ['「', '」'], 'nesting': 1, 'input': ['j[', 'j]', 'jb']},
\   {'buns': ['『', '』'], 'nesting': 1, 'input': ['j{', 'j}', 'jB']},
\   {'buns': ['【', '】'], 'nesting': 1, 'input': ['j<', 'j>', 'jk']},
\   {'buns': ['“', '”'], 'nesting': 1, 'input': ['j"' ]},
\   {'buns': ['‘', '’'], 'nesting': 1, 'input': ["j'" ]},
\ ]

" Escaped parens
let g:sandwich#recipes += [
\   {'buns': ['\{', '\}'], 'nesting': 1, 'input': ['\{', '\}']},
\   {'buns': ['\(', '\)'], 'nesting': 1, 'input': ['\(', '\)']},
\   {'buns': ['\[', '\]'], 'nesting': 1, 'input': ['\[', '\]']},
\ ]

" リンク記法
let g:sandwich#recipes += [
\   {'buns': ['`', ' <>`_'], 'nesting': 0, 'input': ['l'], 'filetype': ['rst']},
\   {'buns': ['` <', '>`_'], 'nesting': 0, 'input': ['L'], 'filetype': ['rst']},
\   {'buns': ['[', ']()'], 'nesting': 0, 'input': ['l'], 'filetype': ['markdown']},
\   {'buns': ['[](', ')'], 'nesting': 0, 'input': ['L'], 'filetype': ['markdown']},
\ ]

" Markdown のコードブロック
let g:sandwich#recipes += [
\ {
\   'filetype' : ['markdown'],
\   'buns'     : ['SandwichMarkdownCodeSnippet()', '"```"' ],
\   'expr'     : 1,
\   'input'    : ['C', ],
\   'kind'     : ['add'],
\   'linewise' : 1,
\   'command'  : ["']s/^\\s*//"],
\ },
\ {
\   'filetype' : ['markdown'],
\   'buns'     : ['```', '```' ],
\   'input'    : ['c', ],
\   'kind'     : ['add'],
\   'linewise' : 1,
\   'command'  : ["']s/^\\s*//"],
\ },
\ ]

function! SandwichMarkdownCodeSnippet() abort
  let lang_name = input('language: ', '')
  return '```' .. lang_name
endfunction

" generics
let g:textobj_functioncall_generics_patterns = [
\ {
\   'header' : '\<\%(\h\k*\.\)*\h\k*',
\   'bra'    : '<',
\   'ket'    : '>',
\   'footer' : '',
\ },
\ ]

onoremap <silent> <Plug>(textobj-functioncall-generics-i) :<C-u>call textobj#functioncall#ip('o', g:textobj_functioncall_generics_patterns)<CR>
xnoremap <silent> <Plug>(textobj-functioncall-generics-i) :<C-u>call textobj#functioncall#ip('x', g:textobj_functioncall_generics_patterns)<CR>
onoremap <silent> <Plug>(textobj-functioncall-generics-a) :<C-u>call textobj#functioncall#i('o', g:textobj_functioncall_generics_patterns)<CR>
xnoremap <silent> <Plug>(textobj-functioncall-generics-a) :<C-u>call textobj#functioncall#i('x', g:textobj_functioncall_generics_patterns)<CR>

let g:sandwich#recipes += [
\ {
\   'buns': ['SandwichGenericsName()', '">"'],
\   'expr': 1,
\   'cursor': 'inner_tail',
\   'kind': ['add', 'replace'],
\   'action': ['add'],
\   'input': ['g']
\ },
\ {
\   'external': ['i<', "\<Plug>(textobj-functioncall-generics-a)"],
\   'noremap': 0,
\   'kind': ['delete', 'replace', 'query'],
\   'input': ['g']
\ },
\ ]

function! SandwichGenericsName() abort
  let genericsname = input('generics name: ', '')
  if genericsname ==# ''
    throw 'OperatorSandwichCancel'
  endif
  return genericsname . '<'
endfunction

let g:sandwich#recipes += [
\ {
\   'buns': ['InlineCommandName()', '"}"'],
\   'expr': 1,
\   'cursor': 'inner_tail',
\   'kind': ['add', 'replace'],
\   'action': ['add'],
\   'input': ['c'],
\   'filetype': ['satysfi']
\ },
\ {
\   'buns': ['BlockCommandName()', '">"'],
\   'expr': 1,
\   'linewise' : 1,
\   'cursor': 'inner_tail',
\   'kind': ['add', 'replace'],
\   'action': ['add'],
\   'input': ['+'],
\   'filetype': ['satysfi']
\ },
\ ]

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

" §§2 between mappings
omap m <Plug>(textobj-sandwich-literal-query-i)
vmap m <Plug>(textobj-sandwich-literal-query-i)
omap M <Plug>(textobj-sandwich-literal-query-a)
vmap M <Plug>(textobj-sandwich-literal-query-a)

" §§1 Plugin settings for machakann/vim-swap

omap i, <Plug>(swap-textobject-i)
xmap i, <Plug>(swap-textobject-i)
omap a, <Plug>(swap-textobject-a)
xmap a, <Plug>(swap-textobject-a)

" §§1 Plugin settings for mbbill/undotree

nnoremap U :<C-u>UndotreeToggle<CR>

" §§1 Plugin settings for monaqa/smooth-scroll.vim

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
" §§1 Plugin settings for monaqa/vim-edgemotion

nmap <C-n> m`<Plug>(edgemotion-j)
nmap <C-p> m`<Plug>(edgemotion-k)
vmap <C-n> <Plug>(edgemotion-j)
vmap <C-p> <Plug>(edgemotion-k)

" §§1 Plugin settings for neoclide/coc.nvim

set tagfunc=CocTagFunc

let g:coc_global_extensions = [
\ 'coc-snippets',
\ 'coc-marketplace',
\ 'coc-actions',
\ 'coc-rust-analyzer',
\ 'coc-pyright',
\ 'coc-json',
\ 'coc-deno',
\]

nnoremap t <Nop>
" t を prefix にする
nmap <silent> td <Cmd>Telescope coc definitions<CR>
" nmap <silent> gd <Cmd>Telescope coc definitions<CR>
nmap <silent> gd <C-]>
nmap <silent> ti <Cmd>Telescope coc implementations<CR>
nmap <silent> ty <Cmd>Telescope coc type_definitions<CR>
nmap <silent> tr <Cmd>Telescope coc references<CR>
" nmap <silent> td <Plug>(coc-definition)
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> ti <Plug>(coc-implementation)
" nmap <silent> ty <Plug>(coc-type-definition)
" nmap <silent> tr <Plug>(coc-references)
nmap <silent> tn <Plug>(coc-rename)
nnoremap <silent> K :call CocAction('doHover')<CR>
nnoremap <silent> <Space>j :call CocAction('diagnosticNext')<CR>
nnoremap <silent> <Space>k :call CocAction('diagnosticPrevious')<CR>

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
" let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<C-g><C-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<C-g><C-k>'

" Remap for do codeAction of selected region
" function! s:cocActionsOpenFromSelected(type) abort
"   execute 'CocCommand actions.open ' . a:type
" endfunction
" xnoremap <silent> ma :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
" nnoremap <silent> ma :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@l
xmap <silent> ta <Plug>(coc-codeaction-selected)
nmap <silent> ta <Plug>(coc-codeaction-selected)l

function! CocServiceNames(ArgLead, CmdLine, CursorPos)
  let actions = map(CocAction('services'), {idx, d -> d['id']})
  return actions
endfunction

command! -nargs=1 -complete=customlist,CocServiceNames CocToggleService call CocAction('toggleService', <q-args>)

" §§2 fzf-preview
" let g:fzf_preview_floating_window_rate = 0.8
" let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --color=never --hidden'
" nnoremap sb :<C-u>CocCommand fzf-preview.AllBuffers<CR>
" nnoremap sg :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
" nnoremap so :<C-u>CocCommand fzf-preview.DirectoryFiles <CR>
" ■■

" §§1 Plugin settings for previm/previm

let g:previm_open_cmd = "open -a 'Vivaldi'"
let g:previm_custom_css_path = "~/.config/nvim/scripts/resource/markdown.css"


" §§1 Plugin settings for rhysd/rust-doc.vim
let g:rust_doc#define_map_K = 0

" §§1 Plugin settings for rust-lang/rust.vim
let g:rustfmt_autosave = 1

" §§1 Plugin settings for sheerun/vim-polyglot

let g:rst_fold_enabled = 1

" §§1 Plugin settings for thinca/vim-quickrun

let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
\ 'runner': 'vimproc',
\ 'runner/vimproc/updatetime': 40,
\ 'outputter': 'error',
\ 'outputter/error/success': 'buffer',
\ 'outputter/error/error': 'quickfix',
\ 'hook/close_quickfix/enable_exit': 1,
\ 'hook/shebang/enable': 0,
\ }

let quickrun_config['jupytext'] = {
\ 'command': 'jupytext',
\ 'exec': '%c %o %a',
\ 'cmdopt': '--update --to notebook',
\ 'outputter/error/success': 'null',
\ 'outputter/error/error': 'buffer',
\ }

let quickrun_config['satysfi'] = {
\ 'command': 'satysfi',
\ 'exec': '%c %a',
\ 'outputter/error/success': 'null',
\ 'outputter/error/error': 'buffer',
\ }

let quickrun_config['satysfi-debug'] = {
\ 'command': 'satysfi',
\ 'exec': '%c %a %o',
\ 'cmdopt': '--debug-show-bbox --debug-show-space --debug-show-block-bbox --debug-show-block-space',
\ 'outputter/error/success': 'null',
\ 'outputter/error/error': 'buffer',
\ }

" example; :QuickRun rsync -args /Users/mogami/work/path-of-project remote:work/sync-mac
let g:quickrun_config['rsync'] = {
\ 'command': 'rsync',
\ 'cmdopt': '-C --filter=":- .gitignore" --exclude ".git" -acvz --delete -e ssh',
\ 'exec': '%c %o %a',
\ 'outputter/error/success': 'null',
\ }


augroup rc_quickrun
  autocmd!
  " autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>q :QuickRun satysfi -args %{expand("%")}<CR>
  " autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>Q :QuickRun satysfi-debug -args %{expand("%")}<CR>
  " autocmd FileType python nnoremap <buffer> <CR>q :QuickRun jupytext -args %{expand("%")}<CR>
augroup END

" §§1 Plugin settings for thinca/vim-submode

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

" §§1 Plugin settings for tpope/vim-capslock

inoremap <C-l> <Nop>

" §§1 Plugin settings for tyru/caw.vim
" toggle comment を , に割り当てる。
nmap , <Plug>(caw:hatpos:toggle:operator)
nmap ,, ,_
vmap , <Plug>(caw:hatpos:toggle)

augroup vimrc
  autocmd FileType pest let b:caw_oneline_comment = '//'
  autocmd FileType todo6 let b:caw_oneline_comment = 'x'
augroup END

" §§1 Plugin settings for open-browser
nmap gb <Plug>(openbrowser-smart-search)
xmap gb <Plug>(openbrowser-smart-search)

" §§1 Plugin settings for xolox/vim-session

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

" §§1 Plugin settings for ghost.vim
augroup vimrc
  autocmd BufNewFile,BufRead *ghost-github.com* setlocal filetype=markdown
augroup END

" §§1 Plugin settings for barbar.nvim

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

" §§1 Plugin settings for dial.nvim

" function! DialConfig()
"   nmap  <C-a>  <Plug>(dps-dial-increment)
"   nmap  <C-x>  <Plug>(dps-dial-decrement)
"   vmap  <C-a>  <Plug>(dps-dial-increment)
"   vmap  <C-x>  <Plug>(dps-dial-decrement)
"   vmap g<C-a> g<Plug>(dps-dial-increment)
"   vmap g<C-x> g<Plug>(dps-dial-decrement)
"   nnoremap  <Up>    <C-a>
"   nnoremap  <Down>  <C-x>
"   vnoremap  <Up>    <C-a>
"   vnoremap  <Down>  <C-x>
"   vnoremap g<Up>   g<C-a>
"   vnoremap g<Down> g<C-x>
" 
"   function! MarkdownHeaderFind(line, cursor)
"     let match = matchstr(a:line, '^#\+')
"     if match !=# ''
"       return {"from": 0, "to": strlen(match)}
"     endif
"     return v:null
"   endfunction
" 
"   function! MarkdownHeaderAdd(text, addend, cursor)
"     let n_header = strlen(a:text)
"     let n_header = min([6, max([1, n_header + a:addend])])
"     let text = repeat('#', n_header)
"     let cursor = 1
"     return {'text': text, 'cursor': cursor}
"   endfunction
" 
"   let s:id_find = dps_dial#register_callback(function("MarkdownHeaderFind"))
"   let s:id_add = dps_dial#register_callback(function("MarkdownHeaderAdd"))
" 
"   autocmd FileType markdown let b:dps_dial_augends_register_h = [
"  \  {'kind': 'user', 'opts': {'find': s:id_find, 'add': s:id_add}}
"  \ ]
"   autocmd FileType markdown nmap <buffer> <Space>a "h<Plug>(dps-dial-increment)
"   autocmd FileType markdown nmap <buffer> <Space>x "h<Plug>(dps-dial-decrement)
"   autocmd FileType markdown vmap <buffer> <Space>a "h<Plug>(dps-dial-increment)
"   autocmd FileType markdown vmap <buffer> <Space>x "h<Plug>(dps-dial-decrement)
" 
"   autocmd FileType typescript let b:dps_dial_augends = g:dps_dial#augends + [
"  \   {
"  \     'kind': 'constant', 'opts': {
"  \       'elements': ['let', 'const'],
"  \       'cyclic': v:true,
"  \       'word': v:true,
"  \   }}
"  \ ]
" 
"   let g:dps_dial#augends = [
"  \   'decimal',
"  \   'hex',
"  \   'date-hyphen',
"  \   'date-slash',
"  \   'color',
"  \ ]
" 
"   let g:dps_dial#augends#register#d = [
"  \   {'kind': 'date', 'opts': {'format': 'yyyy/MM/dd'}},
"  \   {'kind': 'date', 'opts': {'format': 'yyyy-MM-dd'}},
"  \   {'kind': 'date', 'opts': {'format': 'MM/dd', 'only_valid': v:true}},
"  \   {'kind': 'date', 'opts': {'format': 'HH:mm', 'only_valid': v:true}},
"  \   {'kind': 'date', 'opts': {'format': 'M/d', 'only_valid': v:true}},
"  \ ]
" 
"   let g:dps_dial#aliases = {}
" 
"   let g:dps_dial#augends#register#c = [ 'case' ]
"   nmap gc "c<Plug>(dps-dial-increment)
" endfunction

function! DialConfig()
  packadd dial.nvim
lua <<EOL

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
EOL

  augroup vimrc
    autocmd FileType markdown lua vim.api.nvim_set_keymap("n", "<C-a>",   require("dial.map").inc_normal("markdown"), {noremap = true})
    autocmd FileType markdown lua vim.api.nvim_set_keymap("n", "<C-x>",   require("dial.map").dec_normal("markdown"), {noremap = true})
    autocmd FileType markdown lua vim.api.nvim_set_keymap("v", "<C-a>",   require("dial.map").inc_visual("markdown"), {noremap = true})
    autocmd FileType markdown lua vim.api.nvim_set_keymap("v", "<C-x>",   require("dial.map").dec_visual("markdown"), {noremap = true})
    autocmd FileType markdown lua vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual("markdown"), {noremap = true})
    autocmd FileType markdown lua vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual("markdown"), {noremap = true})
  augroup END

endfunction

if (getcwd() !=# '/Users/monaqa/ghq/github.com/monaqa/dial.nvim')
  call DialConfig()
  echom 'general config of dial.vim is loaded.'
endif

" §§1 Plugin settings for telescope.nvim
nnoremap so <Cmd>Telescope git_files prompt_prefix=𝝋<CR>
nnoremap sg <Cmd>Telescope live_grep prompt_prefix=𝜸<CR>
nnoremap sb <Cmd>Telescope buffers prompt_prefix=𝜷<CR>
nnoremap sO <Cmd>Telescope find_files prompt_prefix=𝝋<CR>

" §§1 Plugin settings for nvim-treesitter
nnoremap ts <Cmd> TSHighlightCapturesUnderCursor<CR>

let s:query_dir = expand("<sfile>:p:h:h") .. '/after/queries/'

function! s:override_query(filetype, query_type)
  let query_file = s:query_dir .. a:filetype .. '/' .. a:query_type .. '.scm'
  let query = join(readfile(query_file), "\n")
  call luaeval('require("vim.treesitter.query").set_query(_A[1], _A[2], _A[3])', [a:filetype, a:query_type, query])
endfunction

call s:override_query('bash', 'highlights')
call s:override_query('markdown', 'highlights')

" tree-sitter の fold を有効にしたい場合

" augroup vimrc
"   autocmd FileType rust,lua setlocal foldmethod=expr
"   autocmd FileType rust,lua setlocal foldexpr=nvim_treesitter#foldexpr()
" augroup END

" §§1 Plugin settings for nvim-hlslens
" noremap <silent> n n<Cmd>lua require('hlslens').start()<CR>
" noremap <silent> N N<Cmd>lua require('hlslens').start()<CR>
nmap *  <Plug>(asterisk-z*)
nmap #  <Plug>(asterisk-z#)
nmap g* <Plug>(asterisk-gz*)
nmap g# <Plug>(asterisk-gz*)

" §§1 Plugin settings for modesearch
nmap / <Plug>(modesearch-slash-rawstr)
nmap ? <Plug>(modesearch-slash-regexp)
cmap <C-x> <Plug>(modesearch-toggle-mode)
nnoremap _ /

" §§1 Plugin settings for partedit
let g:partedit#opener = ":vsplit"
let g:partedit#prefix_pattern = '\v\s*'

command! -range ParteditCodeblock call s:partedit_code_block(<line1>, <line2>)
function! s:partedit_code_block(line1, line2)
  let line_codeblock_start = getline(a:line1 - 1)
  let filetype = matchstr(line_codeblock_start, '\v```\zs[-a-zA-Z0-9]+\ze')
  let options = { "filetype": filetype }
  call partedit#start(a:line1, a:line2, options)
endfunction

" §§1 Plugin settings for colordinate
let g:colordinate_save_path = expand("~/.config/nvim/colors")

" §§1 Plugin settings for ddu.vim
call ddu#custom#patch_global({
    \   'ui': 'ff',
    \   'uiParams': {
    \     'ff': {
    \       'split': 'floating',
    \     }
    \   },
    \   'sources': [
    \      {'name': 'file_rec', 'params': {}},
    \   ],
    \   'sourceOptions': {
    \     '_': {
    \       'matchers': ['matcher_substring'],
    \     },
    \     'rg' : {
    \       'args': ['--column', '--no-heading', '--color', 'never'],
    \     },
    \   },
    \   'kindOptions': {
    \     'file': {
    \       'defaultAction': 'open',
    \     },
    \   }
    \ })

call ddu#custom#patch_global({
    \   'sourceParams' : {
    \     'rg' : {
    \       'args': ['--column', '--no-heading', '--color=never', '--hidden'],
    \     },
    \   },
    \ })

call ddu#custom#patch_global('sourceParams', {
      \ 'file_external': {'cmd': ['fd', '.', '-H', '-E', '__pycache__', '-t', 'f']}
      \ })

nnoremap @o <Cmd>call ddu#start({'sources': [{'name': 'file_external', 'params': {}}]})<CR>
nnoremap @m <Cmd>call ddu#start({'sources': [{'name': 'mr', 'params': {'kind': 'mru'}}]})<CR>
nnoremap @g <Cmd>call ddu_rg#find()<CR>

autocmd FileType ddu-ff call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>    <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> <Space> <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> i       <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> q       <Cmd>call ddu#ui#ff#do_action('quit')<CR>
  nnoremap <buffer><silent> <Esc>   <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
function! s:ddu_filter_my_settings() abort
  inoremap <buffer><silent> <CR> <Esc><Cmd>close<CR>

  nnoremap <buffer><silent> <CR>  <Cmd>close<CR>
  nnoremap <buffer><silent> q     <Cmd>close<CR>
  nnoremap <buffer><silent> <Esc> <Cmd>close<CR>
endfunction

" §§1 Plugin settings for markdown-preview.nvim
let g:mkdp_markdown_css = expand('~/.config/nvim/scripts/resource/github-markdown-light.css')
let g:mkdp_highlight_css = expand('~/.config/nvim/scripts/resource/github-markdown-light.css')
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
