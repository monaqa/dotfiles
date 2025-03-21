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
