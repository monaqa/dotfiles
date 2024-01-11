(function_declaration) @fold


(
 function_call
 name: (method_index_expression) @_funcname
 arguments: (arguments) @fold
 (#match? @_funcname "plugins:push")
 (#offset! @fold 1 0 -1 0)
 (#bufname-vim-match? "\\vplugins/.*\\.lua$")
 )

