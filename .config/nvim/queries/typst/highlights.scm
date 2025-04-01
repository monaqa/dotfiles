(call
  item: (ident) @function)
(call
  item: (field field: (ident) @function.method))
(comment) @comment

(field field: (ident) @field)
; 隣接を使い出すと重くなる説がある
; ((field field: (ident) @method) . (group))

(tagged field: (_) @field)

"#" @punctuation.delimiter
; (content ["[" "]"] @punctuation.delimiter)

; (content "#" @field . (ident) @field)
; (content "#" @field [(import) (let)] @field)

; CONTROL
(let "let" @keyword.storage.type)
(let "=" @operator)
(assign "assign" @operator)

(branch ["if" "else"] @keyword.control.conditional)
(while "while" @keyword.control.repeat)
(for ["for" "in"] @keyword.control.repeat)
(import "import" @keyword.control.import)
(as "as" @keyword.operator)
(include "include" @keyword.control.import)
(show "show" @keyword.control)
(set "set" @keyword.control)
(return "return" @keyword.control)
(flow ["break" "continue"] @keyword.control)

; OPERATOR
(in ["in" "not"] @keyword.operator)
(and "and" @keyword.operator)
(or "or" @keyword.operator)
(not "not" @keyword.operator)
(sign ["+" "-"] @operator)
(add "+" @operator)
(sub "-" @operator)
(mul "*" @operator)
(div "/" @operator)
(cmp ["==" "<=" ">=" "!=" "<" ">"] @operator)
(fraction "/" @operator)
(fac "!" @operator)
(attach ["^" "_"] @operator)
(wildcard) @operator

; VALUE
(raw_blck
  "```" @punctuation.delimiter
  .
  (blob) @text.literal
  "```" @punctuation.delimiter
  )

(raw_span "`" @punctuation.delimiter "`" @punctuation.delimiter) @text.literal
(raw_blck
  "```" @punctuation.delimiter
  lang: (ident) @tag
  "```" @punctuation.delimiter
  )

(label) @tag
(ref) @tag
(number) @constant.numeric
(string) @string
(bool) @constant.builtin.boolean
; (builtin) @constant.builtin
(none) @constant.builtin
(auto) @constant.builtin
; (ident) @variable
; (call
;   item: (builtin) @function.builtin)

; MARKUP
(item "-" @punctuation.special)
(term ["/" ":"] @punctuation.special)
(heading "=" (_) @text.underline ) @markup.heading
(heading "==" ) @markup.heading
(heading "===" ) @markup.heading
(heading "====" ) @markup.heading.weak
(heading "=====" ) @markup.heading.weak
(heading "======" ) @markup.heading.weak
(url) @text.uri
(emph) @text.underline
(strong) @text.strong
(symbol) @constant.character
(shorthand) @constant.builtin
; (quote) @markup.quote
(align) @operator
(letter) @constant.character
(linebreak) @constant.builtin

(math "$" @operator)
; "#" @operator
"end" @punctuation.delimiter

(escape) @constant.character.escape
["(" ")" "{" "}" "[" "]"] @punctuation.bracket
["," ";" ".." ":" "sep"] @punctuation.delimiter
(field "." @punctuation)

(lambda "=>" @punctuation.delimiter)

(call
  item:
  (call
    item: (ident) @_cmd_name
    (group (string) @text.uri)
    )
  (content (_) @text.reference (#set! priority 99))
  (#eq? @_cmd_name "link")
  )

(call
  item: (ident) @_cmd_name
  (content) @text.quote
  (#eq? @_cmd_name "quote")
  )
