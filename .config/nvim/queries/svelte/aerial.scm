((doctype) @name
  (#set! "kind" "Module")) @symbol

(_
  [
    (start_tag
      (tag_name) @name)
    (self_closing_tag
      (tag_name) @name)
  ]
  (#not-eq? @name "div")
  (#not-eq? @name "span")
  (#set! "kind" "Struct")) @symbol

(attribute
  (attribute_name) @name
  (#set! "kind" "Field")) @symbol
