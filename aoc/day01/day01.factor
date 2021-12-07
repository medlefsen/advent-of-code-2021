USING: kernel math sequences math.parser grouping
aoc.shared ;
IN: aoc.day01
INPUTS: input ;

: >numbers ( lines -- seq ) [ string>number ] map

: count-increases ( seq -- incr )
  2 <clumps> [ first2 < ] count
;

: sum-windows ( seq -- seq )
  3 <clumps> [ sum ] map
;

: part1 ( -- answer ) input-lines >numbers count-increases ;
: part2 ( -- answer ) input-lines >number sum-windows count-increases ;
  
