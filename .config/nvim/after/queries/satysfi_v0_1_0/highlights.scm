;; keywords
[
 "mod"
 "module"
 "fun"
 "struct"
 "end"
 "val"
 "type"
 "signature"
 "include"
 "rec"
 "mutable"
 "and"
 "math"
 "inline"
 "block"
 "of"
 "with"
 "sig"
 "let"
 "in"
 "open"
 "match"
 "if"
 "then"
 "else"
 "not"
 "command"
 "@stage:"
 "@require:"
 "@import:"
 ] @keyword

[
 "true"
 "false"
 ] @constant.boolean

[
  (comment)
] @comment

[
"{"
"${"
"}"

; ".("
"("
")"

"(|"
"|)"

"["
"]"
 ] @punctuation.bracket

(block_text
  ["<" "'<"] @punctuation.bracket
  ">"  @punctuation.bracket
  )

[
 ";"
 ":"
 ","
 "."
 (inline_text_bullet_star)
 "#"
 ]  @punctuation.delimiter

[
 "?:"
 ; "?->"
 "->"
 "<-"
 "="
 "!"
 "::"
 ]  @operator.special

;; literals

[
  (literal_int)
  (literal_float)
  (literal_length)
] @number

[
  (literal_string)
] @string

;; modules

(pkgname) @namespace

(module_name) @namespace
; (label_name) @field

;; type

(type_name) @type
(type_var) @parameter
(type_product "*") @operator.special
; (type_record
;   (label_name) @field
;   )
(bind_type_single "|" @operator.special)

;; expr
(expr_match "|" @operator.special)

(bind_val_variable
  (var_name) @function
  (bind_val_parameter)
  )
; (bind_val_inline_cmd
;   (bind_val_parameter) @parameter
;   )
; (bind_val_block_cmd
;   (bind_val_parameter) @parameter
;   )
; (bind_val_math_cmd
;   (bind_val_parameter) @parameter
;   )
; (expr_lambda
;   (bind_val_parameter) @parameter
;   )
(parameter [(var_name) (pattern_ignore)]) @parameter

(bind_val_inline_cmd context:(var_name) @parameter)
(bind_val_block_cmd context:(var_name) @parameter)
(bind_val_math_cmd context:(var_name) @parameter)

(expr_application
  function: (expr_var_path (var_name)@function) 
  )

(binary_operator) @operator

(variant_name) @type

(label_name) @field



; (bind_val_single
;   . (var_name) @function
;   (bind_val_parameter)+
;   )

;; inline/block/math mode

(inline_text_list "|" @punctuation.delimiter)
(math_list "|" @punctuation.delimiter)
(math_token
  [
   "^"
   "_"
   ] @operator
  )

(inline_cmd_name) @function.special
(block_cmd_name) @function.special
; inline_cmd_name と見分け付かないので一旦 parameter にしておく
(math_cmd_name) @parameter

[
 (inline_text_embedding)
 (block_text_embedding)
 (math_embedding)
 ] @function.special

(inline_literal_escaped) @string.escape
