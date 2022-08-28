[
 (block_text)
 (inline_text)
 (inline_text_list)
 (inline_text_bullet_list)
 (inline_text_bullet_item)
 (cmd_expr_arg)
 (cmd_expr_option)

 (expr_match)
 (expr_parened)
 (expr_list)
 (expr_record)
 (expr_tuple)

 (expr_application)
 (expr_binary_operation)

 (signature_structure)
 (module_structure)

 (bind_val_variable)
 (bind_val_math_cmd)
 (bind_val_inline_cmd)
 (bind_val_block_cmd)
 (bind_val_mutable)

 (match_arm)

 ] @indent

; (match_arm expr: (_) @indent)

(expr_if
  ; cond:(_) @indent
  "then" @branch
  "else" @branch
  ; true_clause:(_) @indent
  ; false_clause:(_) @indent
  ) @indent

; (let_stmt expr:(_) @indent)
; (let_inline_stmt expr:(_) @indent)
; (let_block_stmt expr:(_) @indent)
; (let_math_stmt expr:(_) @indent)

(block_text ">" @indent_end)
(inline_text "}" @indent_end)
(inline_text_list "}" @indent_end)
(inline_text_bullet_list "}" @indent_end)
(expr_parened ")" @indent_end)
(cmd_expr_arg ")" @indent_end)
(cmd_expr_option ")" @indent_end)

(expr_list "]" @indent_end)
(expr_record "|)" @indent_end)
(expr_tuple ")" @indent_end)

[
  ")"
  "]"
  "}"
  "|)"
  "end"
] @branch
(block_text ">" @branch)

(literal_string) @auto

; (match_arm "|" @branch)

; (
;  (binary_expr
;    (binary_operator) @binop
;    ) @aligned_indent
;  (#set! "delimiter" "|")
;  (#matches! @binop "|>")
;  )
