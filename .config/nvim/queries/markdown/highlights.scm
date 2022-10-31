; [
;  (inline_link)
;  (image)
; ] @attribute


(block_quote) @text.quote
; 
; (atx_heading
;  (atx_h1_marker)
;  (heading_content) @text.underline
;  )
; 
(fenced_code_block
 (fenced_code_block_delimiter) @text.literal
 .
 (block_continuation)
 (code_fence_content) @text.literal
 (fenced_code_block_delimiter) @text.literal
 )

(fenced_code_block
 (fenced_code_block_delimiter) @punctuation.delimiter
 (info_string) @punctuation.delimiter
 (fenced_code_block_delimiter) @punctuation.delimiter
 )

(atx_heading
  (atx_h1_marker)
  heading_content: (_) @text.underline @text.title
  )

(atx_heading
  (atx_h2_marker)
  heading_content: (_) @text.title
  )

(atx_heading
 [(atx_h3_marker) (atx_h4_marker) (atx_h5_marker) (atx_h6_marker)]
 heading_content: (_) @text.title.weak
 )

; 
; (uri_autolink) @text.uri
; 

;From MDeiml/tree-sitter-markdown
(atx_heading (inline) @text.title)
(setext_heading (paragraph) @text.title)

[
  (atx_h1_marker)
  (atx_h2_marker)
  (atx_h3_marker)
  (atx_h4_marker)
  (atx_h5_marker)
  (atx_h6_marker)
  (setext_h1_underline)
  (setext_h2_underline)
] @punctuation.special

[
  (link_title)
  (indented_code_block)
  ; (fenced_code_block)
] @text.literal

; [
;   (fenced_code_block_delimiter)
; ] @punctuation.delimiter

; (code_fence_content) @none

[
  (link_destination)
] @text.uri

[
  (link_label)
] @text.reference

[
  (list_marker_plus)
  (list_marker_minus)
  (list_marker_star)
  (list_marker_dot)
  (list_marker_parenthesis)
  (thematic_break)
] @punctuation.special

[
  (block_continuation)
  (block_quote_marker)
] @punctuation.special

[
  (backslash_escape)
] @string.escape

; ([
;   (info_string)
;   (fenced_code_block_delimiter)
; ] @conceal
; (#set! conceal ""))

(inline) @spell
