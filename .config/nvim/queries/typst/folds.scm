; 結局 section 折りたたむのと一緒だわ
; (
;  (heading
;    ; [
;    ;  ;2 ~ 5 を折りたためば実用には十分だろう
;    ;  "="
;    ;  "=="
;    ;  "==="
;    ;  "===="
;    ;  ]
;    )
;  .
;  (content) @fold
;  (#offset! @fold 0 0 -1 0)
;  )

(
 (section) @fold
 (#offset! @fold 0 0 -1 0)
 )

; (call
;   item: (builtin) @_builtin
;   (content) @fold
;
;   (#eq? @_builtin "quote")
;   )

(raw_blck
  (blob) @fold
  (#offset! @fold 1 0 0 0)
  )
