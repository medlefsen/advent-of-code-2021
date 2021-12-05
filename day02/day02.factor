USING: aoc.shared splitting kernel sequences accessors
math.parser math locals memoize combinators ;
IN: aoc.day02

TUPLE: command dir distance ;
: <command> ( dir distance -- command ) command boa ;

TUPLE: position horiz depth aim ;
: <position> ( -- position ) 0 0 0 position boa ;
: mul-pos ( position -- mul ) [ horiz>> ] [ depth>> ] bi * ;

MEMO: commands ( -- seq ) INPUT-FILE read-lines 
 [ " " split first2 string>number <command> ] map
;

:: apply-command ( position command -- position )
  command distance>>
  position  
  command dir>>
  { 
    { "forward" [ [ + ] change-horiz ] }
    { "down" [ [ + ] change-depth ] }
    { "up" [ [ swap - ] change-depth ] }
  } case
;

:: apply-command-2 ( position command -- position )
  command distance>>
  position  
  command dir>>
  { 
    { "forward" [
        [ + ] change-horiz 
        command distance>> position aim>> * swap
        [ + ] change-depth
    ] }
    { "down" [ [ + ] change-aim ] }
    { "up" [ [ swap - ] change-aim ] }
  } case
;

: part1 ( -- result )
  commands <position> [ apply-command ] reduce mul-pos
;

: part2 ( -- result )
  commands <position> [ apply-command-2 ] reduce mul-pos
;
