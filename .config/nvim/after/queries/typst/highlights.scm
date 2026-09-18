;; extends

; #strike[...] cmd
(call
  item: (ident) @fname
  (content (text) @text.strike)

  (#eq? @fname "strike")
  )

(text) @spell

(term
  term: (text) @text.strong
 )

; cheq 形式の TODO `- [ ]`
(
  (item
    . (text) @bra @text.strong @keyword
    . (text) @cket @text.strong @keyword
    (#eq? @bra "[")
    (#eq? @cket "]")
    ) @todo

  (#match? @todo "^-[ ][ ]*[[] []]")
 )

; cheq 形式の DONE `- [x]`
(
  (item) @comment.documentation @todo

  (#match? @todo "^-[ ][ ]*[[]x[]]")
 )
