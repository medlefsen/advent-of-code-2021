USING: kernel aoc.shared locals accessors memoize arrays
math.parser sequences splitting math assocs ;
IN: aoc.day06

: <fishes> ( seq -- fishes )
  V{ } clone [ over inc-at ] reduce 
;
: read-fish ( path -- seq )
  read-lines first "," split [ string>number ] map <fishes>
;

MEMO: test-fish ( -- fishes ) TEST-FILE read-fish ;
MEMO: input-fish ( -- fishes ) INPUT-FILE read-fish ;

:: process-fishes ( fishes -- fishes )
  fishes [| age num |
    age 0 = [ 8 ] [ age 1 - ] if
    num
  ] assoc-map :> new-fishes
  8 new-fishes at 0 or 6 new-fishes at+
  new-fishes
;

: fishes-size ( fishes -- n ) values sum ;

: count-after-days ( fishes days -- n ) 
  [ process-fishes ] times fishes-size
;

: part1 ( -- n ) input-fish 80 count-after-days ;
: part2 ( -- n ) input-fish 256 count-after-days ;
