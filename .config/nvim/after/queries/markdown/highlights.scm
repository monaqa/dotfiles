[
 (inline_link)
 (image)
] @attribute

[
 (indented_code_block)
 (fenced_code_block)
 ] @text.literal

(block_quote) @Quote

(atx_heading
 (atx_h1_marker)
 (heading_content) @text.underline
 )

(fenced_code_block
 (fenced_code_block_delimiter) @text.literal
 .
 (code_fence_content) @text.literal
 (fenced_code_block_delimiter) @text.literal
 )

(fenced_code_block
 (fenced_code_block_delimiter) @punctuation.delimiter
 (info_string) @punctuation.delimiter
 (fenced_code_block_delimiter) @punctuation.delimiter
 )

(html_block) @comment

(atx_heading
 [(atx_h3_marker) (atx_h4_marker) (atx_h5_marker) (atx_h6_marker)]
 (heading_content) @WeakTitle
 )

(uri_autolink) @text.uri
