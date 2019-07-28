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
    \       'select-a': 'aP', 'select-i': 'iP'
    \  },
    \   'braces': {
    \       'pattern': ['「', '」'],
    \       'select-a': 'aB', 'select-i': 'iB'
    \  },
    \  'double-braces': {
    \       'pattern': ['『', '』'],
    \       'select-a': 'aD', 'select-i': 'iD'
    \  },
    \})

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
