call lexima#add_rule({'at': '\%#[-0-9a-zA-Z_]', 'char': '{', 'input': '{'})
call lexima#add_rule({'at': '\%#\\', 'char': '{', 'input': '{', 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '$', 'input_after': '$', 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '$', 'at': '\%#\$', 'leave': 1, 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '<BS>', 'at': '\$\%#\$', 'delete': 1, 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '\{', 'input_after': '\}', 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '}', 'at': '\\\%#}', 'leave': 1, 'filetype': ['latex', 'tex']})
" call lexima#add_rule({'char': '<BS>', 'at': '\\\{\%#\\\}', 'input': '<BS><BS><DEL><DEL>', 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': "'", 'input':  "'", 'filetype': ['latex', 'tex', 'satysfi']})
call lexima#add_rule({'input_after': '>', 'char': '<', 'filetype': ['satysfi']})
call lexima#add_rule({'char': '<', 'at': '\\\%#', 'filetype': ['satysfi']})
call lexima#add_rule({'char': '>', 'leave': 1, 'at': '\%#>', 'filetype': ['satysfi']})
call lexima#add_rule({'char': '<BS>', 'at': '<\%#>', 'delete': 1, 'filetype': ['satysfi']})
call lexima#add_rule({'char': '``', 'input_after': '``', 'filetype': ['rst']})
" call lexima#add_rule({'char': "（", 'input_after': "）"})
" call lexima#add_rule({'char': "）", 'at': "\%#）", 'leave': 1})
" call lexima#add_rule({'char': '<BS>', 'at': '（\%#）', 'delete': 1})