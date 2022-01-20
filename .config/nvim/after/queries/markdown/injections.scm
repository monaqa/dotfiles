(fenced_code_block
 (info_string) @lang
 (code_fence_content) @content
 (#vim-match? @lang "^(py|python)(:.*)?$")
 (#set! language "python")
)

(fenced_code_block
 (info_string) @lang
 (code_fence_content) @content
 (#vim-match? @lang "^(yaml|yml)(:.*)?$")
 (#set! language "yaml")
)

(fenced_code_block
 (info_string) @lang
 (code_fence_content) @content
 (#vim-match? @lang "^(json)(:.*)?$")
 (#set! language "json")
)
