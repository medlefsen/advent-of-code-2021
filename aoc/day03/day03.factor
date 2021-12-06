USING: aoc.shared kernel sequences bit-arrays math locals
accessors memoize ;
IN: aoc.day03

TUPLE: counts zero one ;
: <counts> ( -- pos ) 0 0 counts boa ;
: extract-counts ( pos-counts -- zero one ) 
  [ zero>> ] [ one>> ] bi ;

MEMO: inputs ( -- seq ) INPUT-FILE read-lines ;

: input-rows ( -- rows )
  inputs [ [ CHAR: 1 = ] [ ] map-as ] map
;

: num-cols ( -- size ) input-rows first length ;

:: col ( rows col -- seq )
rows [ col swap nth ] map
;

MEMO: input-cols ( -- cols ) input-rows flip ;

: count-col ( col -- counts ) 
  <counts>
  [ 
    [ [ 1 + ] change-one ] [ [ 1 + ] change-zero ] if
  ] reduce
;

:: filter-rows ( rows i quot: ( counts -- ? ) -- rows )
  rows i col count-col quot call( c -- ? ) :> value
  rows [| row | i row nth value = ] filter
;

:: iterative-apply ( rows quot: ( counts -- ? ) -- row )
num-cols <iota> rows [| rows i |
  rows length 1 >
  [ rows i quot filter-rows ]
  [ rows ]
  if
] reduce
;

! zeros > ones -> f, zeroes < ones -> t, zeroes = ones -> t
: most-common ( counts -- ? ) extract-counts <= ;

! zeros > ones -> t, zeroes < ones -> f, zeroes = ones -> f
: least-common ( counts -- ? ) extract-counts > ;

: map-as-int ( ... seq f: ( ... elt -- ... ? ) -- ... int )
  ?{ } map-as reverse bit-array>integer
; inline
 
: gamma ( -- result )
  input-cols [ count-col most-common ] map-as-int
;

: epsilon ( -- result ) 
  input-cols [ count-col least-common ] map-as-int
;

: oxygen-rating ( -- result )
  input-rows [ most-common ] iterative-apply
  first [ ] map-as-int
;

: scrubber-rating ( -- result )
  input-rows [ least-common ] iterative-apply
  first [ ] map-as-int
;

: part1 ( -- result ) gamma epsilon * ;

: part2 ( -- result ) oxygen-rating scrubber-rating * ;
