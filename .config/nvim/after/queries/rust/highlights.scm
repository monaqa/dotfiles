;; extends

(
 (line_comment) @comment.doccomment

 (#match? @comment.doccomment "^///.*$")
 )
