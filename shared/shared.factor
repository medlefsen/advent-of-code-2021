USING: io.files io.pathnames io.encodings.utf8 splitting
sequences vocabs.loader vocabs.parser ;
IN: aoc.shared

: read-lines ( path -- seq )
   utf8 file-contents "\n" split but-last
;


SYNTAX: INPUT-FILE
current-vocab vocab-source-path
"../input.txt" append-path suffix
;
