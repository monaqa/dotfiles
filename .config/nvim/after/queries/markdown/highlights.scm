; (html_block) @comment
; 
(inline_link) @attribute
(image) @attribute

(block_quote) @Quote

(atx_heading
 (atx_h1_marker)
 (heading_content) @text.underline
 )

(atx_heading
 [(atx_h3_marker) (atx_h4_marker) (atx_h5_marker) (atx_h6_marker)]
 (heading_content) @WeakTitle
 )

(fenced_code_block
 .
 (code_fence_content) @text.literal)
