USING: kernel math sequences math.parser grouping
aoc.shared ;
IN: aoc.day01


: load-input ( -- seq )
  INPUT-FILE read-lines [ string>number ] map
;

: count-increases ( seq -- incr )
  2 <clumps> [ first2 < ] count
;

: sum-windows ( seq -- seq )
  3 <clumps> [ sum ] map
;

: part1 ( -- answer ) load-input count-increases ;
: part2 ( -- answer ) load-input sum-windows count-increases ;
  
