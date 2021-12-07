USING: kernel locals aoc.shared splitting math.parser sequences
memoize math.statistics math math.ranges ;
IN: aoc.day07

: read-crabs ( path -- seq ) 
  read-lines first "," split [ string>number ] map
;

MEMO: test-crabs ( -- seq ) TEST-FILE read-crabs ;
MEMO: input-crabs ( -- seq ) INPUT-FILE read-crabs ;

:: linear-alignment-fuel ( pos crabs -- n )
  crabs [ pos - abs ] map sum
;

:: linear-alignment-options ( crabs -- seq )
  crabs minmax 1 <range>
  [ crabs linear-alignment-fuel ] map
;

: lowest-linear-alignment-fuel ( crabs -- n )
 linear-alignment-options minmax drop
;
! 1 2 3 4 5
! 1 3 6 10 15
! 1 1.5 2 2.5 3
! 1^1 2^1.5 3^2 4^2.5 5^3 6^3.3 7^4

:: exp-alignment-fuel ( pos crabs -- n )
  crabs [ pos - abs dup 2 / 1/2 + * ] map sum
;

:: exp-alignment-options ( crabs -- seq )
  crabs minmax 1 <range>
  [ crabs exp-alignment-fuel ] map
;

: lowest-exp-alignment-fuel ( crabs -- n )
 exp-alignment-options minmax drop
;

: part1 ( -- n ) input-crabs lowest-linear-alignment-fuel ;
: part2 ( -- n ) input-crabs lowest-exp-alignment-fuel ;
