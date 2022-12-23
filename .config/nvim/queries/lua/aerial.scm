(function_declaration
  name: [(identifier) (dot_index_expression) (method_index_expression)] @name
  (#set! "kind" "Function")
  ) @type

(variable_declaration
  (assignment_statement
    (variable_list
      name: [(identifier) (dot_index_expression)] @name)
    (expression_list
      value: (function_definition) @type))
  (#set! "kind" "Function")
  ) @start

(assignment_statement
  (variable_list
    name: [(identifier) (dot_index_expression) (bracket_index_expression)] @name)
  (expression_list
    value: (function_definition) @type)
  (#set! "kind" "Function")
  ) @start

(field
  name: (identifier) @name
  value: (function_definition) @type
  (#set! "kind" "Function")
  ) @start

(function_call
  name: (identifier) @method @name (#any-of? @method "describe" "it" "before_each" "after_each" "setup" "teardown")
  arguments: (arguments
    (string)? @name
    (function_definition) @type)
  (#set! "kind" "Function")
) @start

(function_call
  name: (dot_index_expression
          table: (identifier) @tbl (#match? @tbl "^a")
          field: (identifier) @method @name (#any-of? @method "describe" "it" "before_each" "after_each")
  )
  arguments: (arguments
    (string)? @name
    (function_definition) @type)
  (#set! "kind" "Function")
) @start

; (function_definition
;   (#set! "kind" "Function")
;   ) @type

; ; util.autocmd_vimrc
; (function_call
;   name: (_)@method @name
;   ; (#eq? @name "util.autocmd_vimrc")
;   (#set! "kind" "Function")
;   ) @start

(
 (function_call name: (_) @name) @type
 (#eq? @name "vim.keymap.set")
 (#set! "kind" "Enum")
 ) @start

(
 (function_call name: (_) @name) @type
 (#eq? @name "util.autocmd_vimrc")
 (#set! "kind" "Class")
 ) @start

(
 (comment) @name @type
 (#contains? @name "---@class " )
 (#set! "kind" "Class")
 )@start
