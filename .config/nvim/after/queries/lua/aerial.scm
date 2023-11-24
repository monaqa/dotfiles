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
 (#bufname-vim-match? "\\v.*plugins\\.lua$")
 (#offset! @name 0 20 0 -1)
 (#set! "kind" "Function")
 )
