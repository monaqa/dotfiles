((command_name (word) @function.builtin)
 (#any-of? @function.builtin
  "cp" "mkdir" "cat" "rm" "sort"))

(variable_name) @function

(test_operator) @operator

(command
 argument: [
 (word) @operator
 (concatenation (word) @operator)
 ]
 (#match? @operator "^-.+$")
)

[
    ">>"
] @operator
