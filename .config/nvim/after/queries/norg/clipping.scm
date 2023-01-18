(
 ranged_verbatim_tag
 name: (tag_name) @tag_name
 (tag_parameters) @filetype
 content: (_) @clip
 (#eq? @tag_name "code")
 (#set! "exclude_bounds" "end")
 (#set! "prefix_pattern" "\\s*")
 )
