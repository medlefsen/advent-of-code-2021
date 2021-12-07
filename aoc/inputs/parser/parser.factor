USING: io.files io.pathnames io.encodings.utf8 splitting
sequences parser fry words effects lexer memoize ;
IN: aoc.inputs.parser

:: define-input-dir-path ( location -- )
  "input-dir-path" create-word-in
  location first ".." append-path '[ _ ]
  { } { "path" } <effect>
  define-declared
;

: input-path ( name -- path )
  location first ".." name ".txt" append 3append-path 
;

:: define-input-word ( name suffix quot: ( -- x ) -- )
  name "-" suffix 3array concat
  quot name input-path '[ _ @ ]
  { } suffix 1array <effect>
  define-memoized
;

:: define-input-path ( name -- )
  name "path" name []
  define-input-word
;


:: define-input-contents ( name file -- )
  name "path" name '[  ]
  define-input-word
;
