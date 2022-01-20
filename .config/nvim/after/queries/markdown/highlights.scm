[
 (inline_link)
 (image)
] @attribute

[
 (indented_code_block)
 (fenced_code_block)
 ] @text.literal

(block_quote) @comment

(atx_heading
 (atx_h1_marker)
 (heading_content) @text.underline
 )

(fenced_code_block
 .
 (code_fence_content) @text.literal)

(html_block) @comment

(atx_heading
 [(atx_h3_marker) (atx_h4_marker) (atx_h5_marker) (atx_h6_marker)]
 (heading_content) @WeakTitle
 )

