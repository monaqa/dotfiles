(type_definition
  type: (enum_specifier) @type
  declarator: (type_identifier) @name
  (#set! "kind" "Enum")
  ) @start

(type_definition
  type: (struct_specifier) @type
  declarator: (type_identifier) @name
  (#set! "kind" "Struct")
  ) @start

; (
;   (declaration) @root @start
;   .
;   (function_definition) @type @end
;   (#set! "kind" "Function")
; )

; (
;  (declaration)
;   (#set! "kind" "Function")
; ) @type

(function_definition
  declarator: ( function_declarator declarator: (_) @name)
  ; declarator: (_) @name
  (#set! "kind" "Function")
  ) @type @start

(function_definition
  declarator:
  (
   pointer_declarator
   declarator: (function_declarator declarator: (_) @name)
   ; declarator: (_) @name
   )
  (#set! "kind" "Function")
  ) @type @start
