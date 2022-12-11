(git_comment) @type
(git_index) @preproc

(from_file_line) @text.diff.delsign
(to_file_line) @text.diff.addsign

"@@" @keyword

(hunk_info) @keyword @text.underline
(hunk_comment) @text.emphasis @text.quote

(line_nochange) @comment
(line_nochange " " @text.diff.indicator)

(line_deleted "-" @text.diff.delsign @text.diff.indicator)
(line_deleted (body) @text.diff.delete)

(line_added "+" @text.diff.addsign @text.diff.indicator)
(line_added (body) @text.diff.add)
