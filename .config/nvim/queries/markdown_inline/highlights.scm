;; From MDeiml/tree-sitter-markdown
[
  (code_span)
  (link_title)
] @text.literal

[
  (emphasis_delimiter)
  (code_span_delimiter)
] @punctuation.delimiter

(emphasis) @text.emphasis

(strong_emphasis) @text.strong

(
 (emphasis_delimiter) @conceal
 (#set! conceal "")
 )

[
  (link_destination)
  (uri_autolink)
] @text.uri

[
  (link_label)
  (link_text)
  (image_description)
] @text.reference

[
  (backslash_escape)
  (hard_line_break)
] @string.escape

; "(" not part of query because of
; https://github.com/nvim-treesitter/nvim-treesitter/issues/2206
; TODO: Find better fix for this
; (image ["!" "[" "]" "("] @punctuation.delimiter)
; (inline_link ["[" "]" "("] @punctuation.delimiter)
; (shortcut_link ["[" "]"] @punctuation.delimiter)

(inline_link) @punctuation.delimiter

; Conceal inline links
(inline_link
  (link_destination) @conceal
  (#set! conceal "…"))

; Conceal image links
(image
  (link_destination) @conceal
  (#set! conceal "…"))

; Conceal full reference links
(full_reference_link
  [
    "["
    "]"
    (link_label) @conceal
  ]
  (#set! conceal "🖼"
  ))

; skip checking spell
(code_span) @nospell
(uri_autolink) @nospell
(link_destination) @nospell
