(command) @function

(comment) @comment

(string_literal) @string

; (note_item) @field
(rest_item) @comment
; [(pitch) (rest)] @field

(number) @number
(string_number) @punctuation.delimiter

[
 "{"
 "}"
 ] @punctuation.bracket

[
 "#"
 ] @punctuation.delimiter

[
 "="
 ] @operator

(scheme_code_block) @string

(accent) @punctuation.delimiter
(accent) @text.strong

