if exists('b:current_syntax')
    finish
endif
syntax match todo6Memo /#.*/
syntax match todo6CategoryName /\[.\+\]/
syntax match todo6PriorityA /(A)/
syntax match todo6PriorityB /(B)/
syntax match todo6PriorityC /(C)/
syntax match todo6ToBeDetermined /\.\.\./
syntax match todo6Date /{\d\d\d\d-\d\d-\d\d}/
syntax match todo6Done /^\s*[xc]\s\+.*/
highlight default link todo6CategoryName Identifier
highlight default link todo6PriorityA Special
highlight default link todo6PriorityB Label
highlight default link todo6PriorityC Operator
highlight default link todo6ToBeDetermined Constant
highlight default link todo6Memo String
highlight default link todo6Date Constant
highlight default link todo6Done Comment
let b:current_syntax = 'todo6'
