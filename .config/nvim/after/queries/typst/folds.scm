(
 (heading
   [
    ;2 ~ 5 を折りたためば実用には十分だろう
    "="
    "=="
    "==="
    "===="
    ])
 .
 (section) @fold
 (#offset! @fold 0 0 -1 0)
 )

(call
  item: (builtin) @_builtin
  (content) @fold

  (#eq? @_builtin "quote")
  )
