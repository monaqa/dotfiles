;; extends
(
 (comment) @comment.doccomment
 (#match? @comment.doccomment "^---.*$")
 )

; (
;  (
;   chunk
;   [
;    (empty_statement)
;    (assignment_statement)
;    (function_call)
;    (label_statement)
;    (break_statement)
;    (goto_statement)
;    (do_statement)
;    (while_statement)
;    (repeat_statement)
;    (if_statement)
;    (for_statement)
;    (function_declaration)
;    (variable_declaration)
;    (return_statement)
;    ] @comment
;   )
;  (#cursor-not-at? @comment)
;  (#set! "priority" 101)
;  )
