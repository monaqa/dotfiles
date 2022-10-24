;; extends

(
 (line_comment) @comment.doccomment
 (#match? @comment.doccomment "^///.*$"))

(
 (line_comment) @comment.doccomment
 (#match? @comment.doccomment "^//!.*$"))
