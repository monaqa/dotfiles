; Comments
(comment) @comment

; Literals
(string) @string
(number) @number
(float_literal) @number.float
(boolean) @boolean
(keyword) @label
(symbol) @variable

; Function definitions: symbol after defn
(list . (symbol) @keyword (symbol) @function
  (#eq? @keyword "defn"))

; Type definitions: symbol after type
(list . (symbol) @keyword (symbol) @type
  (#eq? @keyword "type"))

; Effect definitions
(list . (symbol) @keyword (symbol) @type
  (#eq? @keyword "effect"))

; Trait definitions
(list . (symbol) @keyword (symbol) @type
  (#eq? @keyword "trait"))

; Fat arrow and operators
(
 (symbol) @operator
 (#match? @operator "^(\\=>|->|\\+|-|\\*|/|\\%|>|<|>\\=|<\\=|\\=|not|and|or)$")
 )

; 関数定義には特別な対応を
(list
  .
  (symbol) @_fn
  .
  (symbol) @function
  .
  (list
    "[" @variable.parameter
    (symbol) @variable.parameter
    "]" @variable.parameter)
  (_)

  (#eq? @_fn "fn")
  (#set! priority 110)
)

(list
  .
  (symbol) @_pub
  .
  (symbol) @_fn
  .
  (symbol) @function
  .
  (list
    "[" @variable.parameter
    (symbol) @variable.parameter
    "]" @variable.parameter)
  (_)

  (#eq? @_pub "pub")
  (#eq? @_fn "fn")
  (#set! priority 110)
)

; 無名関数
(list
  .
  (symbol) @_fn
  .
  (list
    "[" @variable.parameter
    (_) @variable.parameter
    "]" @variable.parameter)
  (_)

  (#eq? @_fn "fn")
  (#set! priority 110)
)

; Function calls: first symbol in list (when not a keyword)
(list
  "[" @function.call
  . (symbol) @function.call
  (_)
  "]" @function.call
  (#set! priority 110)
  )

; Keywords: first symbol in list matching known forms
(list
  "[" @keyword
  .
  (symbol) @_symbol @keyword
  "]" @keyword
  (#match? @_symbol "^(defn|fn|let|if|match|pipe|type|use|effect|handle|do|when|sig|trait|impl|test|try|mut|str|fmt)$")
  (#set! priority 120)
  )

; public function
(list
  "[" @keyword
  .
  (symbol) @_pub @keyword
  .
  (symbol) @_symbol @keyword
  "]" @keyword
  (#eq? @_pub "pub")
  (#match? @_symbol "^(defn|fn|let|if|match|pipe|type|use|effect|handle|do|when|sig|trait|impl|test|try|mut|str|fmt)$")
  (#set! priority 130)
  )

(list
  "[" @operator
  .
  (symbol) @_op @operator
  "]" @operator
  (#match? @_op "^(\\=>|->|\\+|-|\\*|/|\\%|>|<|>\\=|<\\=|\\=|not|and|or)$")
  (#set! priority 125)
  )

[
 "["
 "]"
 ] @punctuation.bracket.block

[
 "("
 ")"
 "{"
 "#{"
 "}"
 ] @punctuation.bracket

(vector
  ["#[" "]"] @punctuation.bracket
 )
