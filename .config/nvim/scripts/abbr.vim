" vim:fdm=marker:fmr=§§,■■

" 範囲保存したいときは write を使おう
cnoreabbrev <expr> w (getcmdtype() ==# ":" && getcmdline() ==# "'<,'>w") ? "\<C-u>w" : "w"

" typo の達人
function! s:modify_write_typo(typo)
  exec 'cnoreabbrev <expr> ' .. a:typo .. ' ((getcmdtype() ==# ":" && getcmdline() ==# "' .. a:typo .. '")? "w" : "' .. a:typo .. '")'
endfunction

call s:modify_write_typo("w2")
call s:modify_write_typo("w]")

" abbrev の自動生成を行う
" cnoreabbrev <expr> s ((getcmdtype() ==# ":" && getcmdline() ==# "CocCommand s")? "snippets.editSnippets" : "s")
function! s:make_abbrev_rule(rules)
  let keys = uniq(sort(map(copy(a:rules), "v:val['from']")))
  for key in keys
    let rules_with_key = filter(copy(a:rules), "v:val['from'] ==# '" .. key .. "'")
    let dict = {}
    for val in rules_with_key
      if has_key(val, 'prepose')
        let dict[val['prepose'] .. ' ' .. key] = (val['to'])
      else
        let dict[key] = val['to']
      endif
    endfor
    exec 'cnoreabbrev <expr> ' .. key .. ' '
    \ .. '(getcmdtype() !=# ":")? "' .. key .. '" : '
    \ .. 'get(' .. string(dict) .. ', getcmdline(), "' .. key .. '")'
  endfor
endfunction

call s:make_abbrev_rule([
\   {'from': 'bod', 'to': 'BufferOrderByDirectory'},
\   {'from': 'bol', 'to': 'BufferOrderByLanguage'},
\   {'from': 'c', 'to': 'CocCommand'},
\   {'from': 'cc', 'to': 'CocConfig'},
\   {'from': 'gb', 'to': 'Gina blame'},
\   {'from': 'gc', 'to': 'Gina commit'},
\   {'from': 'gp', 'to': 'Gina push'},
\   {'from': 'gs', 'to': 'Gina status -s --opener=split'},
\   {'from': 'gina', 'to': 'Gina'},
\   {'from': 'rs', 'to': 'RemoveUnwantedSpaces'},
\   {'from': 't', 'to': 'Telescope'},
\   {'prepose': 'CocCommand', 'from': 's', 'to': 'snippets.editSnippets'},
\   {'prepose': 'Gina commit', 'from': 'a', 'to': '--amend'},
\ ])

cnoreabbrev <expr> m (getcmdtype() ==# ":" && getcmdline() ==# "'<,'>m") ? "MakeTable" : "m"
