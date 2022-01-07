(
  [
    (block_comment)
    (line_comment)
    (attribute_item)
  ] @_start
  . (attribute_item)*
  (function_item) @_end
  (#make-range! "function_block" @_start @_end)
)

(
  (line_comment)+
) @multiline_comment
