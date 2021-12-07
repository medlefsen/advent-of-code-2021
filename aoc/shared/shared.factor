USING: io.files io.pathnames io.encodings.utf8 splitting
sequences parser fry words effects lexer ;
IN: aoc.shared

SYNTAX: INPUTS:
  "input-dir-path" create-word-in
  location first ".." append-path '[ _ ]
  { } { "path" } <effect>
  define-declared
  ";" [| token |
     token "-path" append create-word-in
     token ".txt" append '[ input-dir-path _ append-path ]
     { } { "path" } <effect>  
     define-memoized

     token "-file" append create-word-in
     token ".txt" append
     '[ input-dir-path _ append-path read-file ]
     { } { "str" } <effect>  
     define-memoized

     token "-lines" append create-word-in
     token ".txt" append
     '[ input-dir-path _ append-path read-lines ]
     { } { "str" } <effect>  
     define-memoized
  ] each-token
;

: read-file ( path -- str ) utf8 file-contents ;
: read-lines ( path -- seq ) read-file "\n" split but-last ;

SYNTAX: INPUT-FILE
 location first "../input.txt" append-path suffix
;

SYNTAX: TEST-FILE
  location first "../test.txt" append-path suffix
;
