;; extends

(item
  (shorthand) @shorthand
  (text) @comment

  (#eq? @shorthand "~")
  )

(call
  item: (ident) @fname
  (content (text) @text.strike)

  (#eq? @fname "strike")
  )

(item
  (code (ident) @done)
  (#eq? @done "DONE")
 ) @comment.documentation

(item
  (code (ident) @todo @keyword) @text.strong
  (#eq? @todo "TODO")
 )
