;; extends
(
 (
  function_call
  name: (method_index_expression) @funcname
  arguments:
  (arguments
    (table_constructor
      (field
        value: (string) @name
        ) @start
      )
    )
  ) @type
 (#match? @funcname "plugins:push")
 (#bufname-vim-match? "\\vplugins/.*\\.lua$")
 (#offset! @name 0 20 0 -1)
 (#set! "kind" "Function")
 )
