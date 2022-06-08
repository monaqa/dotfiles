" vim:fdm=marker:fmr=§§,■■

" " 範囲保存したいときは write を使おう
" cnoreabbrev <expr> w (getcmdtype() ==# ":" && getcmdline() ==# "'<,'>w") ? "\<C-u>w" : "w"
" 
" " typo の達人
" function! s:modify_write_typo(typo)
"   exec 'cnoreabbrev <expr> ' .. a:typo .. ' ((getcmdtype() ==# ":" && getcmdline() ==# "' .. a:typo .. '")? "w" : "' .. a:typo .. '")'
" endfunction
" 
" call s:modify_write_typo("w2")
" call s:modify_write_typo("w]")

" abbrev の自動生成を行う
" cnoreabbrev <expr> s ((getcmdtype() ==# ":" && getcmdline() ==# "CocCommand s")? "snippets.editSnippets" : "s")
" function! s:make_abbrev_rule(rules)
"   let keys = uniq(sort(map(copy(a:rules), "v:val['from']")))
"   for key in keys
"     let rules_with_key = filter(copy(a:rules), "v:val['from'] ==# '" .. key .. "'")
"     let dict = {}
"     for val in rules_with_key
"       if has_key(val, 'prepose')
"         let dict[val['prepose'] .. ' ' .. key] = (val['to'])
"       elseif has_key(val, 'prepose_nospace')
"         let dict[val['prepose_nospace'] .. key] = (val['to'])
"       else
"         let dict[key] = val['to']
"       endif
"     endfor
"     exec 'cnoreabbrev <expr> ' .. key .. ' '
"    \ .. '(getcmdtype() !=# ":")? "' .. key .. '" : '
"    \ .. 'get(' .. string(dict) .. ', getcmdline(), "' .. key .. '")'
"   endfor
" endfunction
" 
" call s:make_abbrev_rule([
"\   {'from': 'bod', 'to': 'BufferOrderByDirectory'},
"\   {'from': 'bol', 'to': 'BufferOrderByLanguage'},
"\   {'from': 'c', 'to': 'CocCommand'},
"\   {'from': 'cc', 'to': 'CocConfig'},
"\   {'from': 'cl', 'to': 'CocList'},
"\   {'from': 'clc', 'to': 'CocLocalConfig'},
"\   {'from': 'cr', 'to': 'CocRestart'},
"\   {'from': 'gbl', 'to': 'Gina blame'},
"\   {'from': 'gbr', 'to': 'GinaBrowseYank'},
"\   {'from': 'gby', 'to': 'GinaBrowseYank'},
"\   {'from': 'gc', 'to': 'Gina commit'},
"\   {'from': 'gl', 'to': 'Gina log --all --graph'},
"\   {'from': 'gp', 'to': 'Gina push'},
"\   {'from': 'gs', 'to': 'Gina status -s --opener=split'},
"\   {'from': 'git', 'to': 'Gina'},
"\   {'from': 'gina', 'to': 'Gina'},
"\   {'from': 'mn', 'to': 'MemoNew'},
"\   {'from': 'mf', 'to': 'MemoFind'},
"\   {'from': 'mg', 'to': 'MemoLiveGrep'},
"\   {'from': 'open', 'to': '!open'},
"\   {'from': 'rg', 'to': 'silent grep'},
"\   {'from': 'rs', 'to': 'RemoveUnwantedSpaces'},
"\   {'from': 't', 'to': 'Telescope'},
"\   {'from': 'tc', 'to': 'Telescope coc'},
"\   {'from': 'tcc', 'to': 'Telescope coc commands'},
"\   {'from': 'tcd', 'to': 'Telescope coc diagnostics'},
"\   {'from': 'tcw', 'to': 'Telescope coc workspace_diagnostics'},
"\   {'from': 'tf', 'to': 'Telescope find_files'},
"\   {'from': 'tg', 'to': 'Telescope live_grep'},
"\   {'from': 'tmp', 'to': 'Template'},
"\   {'from': 'ssf', 'to': 'syntax sync fromstart'},
"\   {'prepose': 'CocCommand', 'from': 's', 'to': 'snippets.editSnippets'},
"\   {'prepose': 'CocCommand', 'from': 'r', 'to': 'rust-analyzer.reload'},
"\   {'prepose': 'CocList', 'from': 'e', 'to': 'extensions'},
"\   {'prepose': 'Gina', 'from': 'lag', 'to': 'log --all --graph'},
"\   {'prepose': 'Gina commit', 'from': 'a', 'to': '--amend'},
"\   {'prepose': 'Gina commit', 'from': 'e', 'to': '--allow-empty'},
"\   {'prepose': 'Gina log', 'from': 'a', 'to': '--all'},
"\   {'prepose': 'Telescope find_files', 'from': 'm', 'to': 'cwd=~/memo'},
"\   {'prepose': 'Telescope live_grep', 'from': 'm', 'to': 'cwd=~/memo'},
"\   {'prepose': 'Telescope find_files', 'from': 'l', 'to': 'cwd=.local_ignore*'},
"\   {'prepose': 'Telescope live_grep', 'from': 'l', 'to': 'cwd=.local_ignore*'},
"\   {'prepose_nospace': "'<,'>", 'from': 'm', 'to': 'MakeTable'},
"\   {'prepose_nospace': "'<,'>", 'from': 'gbr', 'to': 'GinaBrowseYank'},
"\   {'prepose_nospace': "'<,'>", 'from': 'gby', 'to': 'GinaBrowseYank'},
"\   {'prepose_nospace': "'<,'>", 'from': 'p', 'to': 'Partedit'},
"\   {'prepose_nospace': "'<,'>", 'from': 'pc', 'to': 'ParteditCodeblock'},
"\ ])
