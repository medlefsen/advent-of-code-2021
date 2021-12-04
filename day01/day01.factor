USING: kernel io.files io.pathnames io.encodings.utf8 splitting
math sequences math.parser grouping ;
IN: aoc.day01

: parse-numbers ( path -- seq )
  utf8 file-contents "\n" split
  [ string>number ] map [ >boolean ] filter
;

: load-input ( -- seq )
  "vocab:aoc/day01/input.txt" parse-numbers
;

: count-increases ( seq -- incr )
  2 <clumps> [ first2 < ] count
;

: sum-windows ( seq -- seq )
  3 <clumps> [ sum ] map
;

: part1 ( -- answer ) load-input count-increases ;
: part2 ( -- answer ) load-input sum-windows count-increases ;
  
