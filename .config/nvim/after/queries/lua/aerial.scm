;; extends
(
 (
  function_call
  name: (identifier) @funcname
  arguments:
  (arguments
    (table_constructor
      (field
        value: (string) @name
        ) @start
      )
    )
  ) @type
 (#match? @funcname "add")
 (#bufname-vim-match? "\\v.*plugin_loader\\.lua$")
 (#set! "kind" "Function")
 )
