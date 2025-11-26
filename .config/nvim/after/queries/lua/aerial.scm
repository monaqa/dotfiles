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

(
(function_call
  name: (function_call
          name: (identifier) @funcname
          arguments: (arguments
                       (string
                         content: (string_content) @name))) @start
  arguments: (arguments)
  ) @type

(#match? @funcname "register")
 (#bufname-vim-match? "\\vsnippets/.*\\.lua$")
 (#set! "kind" "Function")
)
