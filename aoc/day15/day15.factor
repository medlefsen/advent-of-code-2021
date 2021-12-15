USING: aoc.shared aoc.matrix kernel splitting sequences locals
accessors math sets heaps slots.syntax refs math.vectors arrays
assocs sequences.extras combinators.short-circuit.smart io ui
curses math.parser heaps.private ;
IN: aoc.day15

TUPLE: score parent cost dist ;
C: <score> score

TUPLE: search goal open min-cost scores ;
: <search> ( goal -- search )
  H{ } clone <min-heap> H{ } clone search boa
;

: dist ( from to -- n )
 [ get[ x y ] 2array ] bi@ v- vabs first2 +
;

: dist-to-goal ( iter search -- dist ) get[ goal ] dist ;

: get-score ( iter search -- iter ) get[ scores ] at ;

:: set-score ( cost parent iter search -- ) 
  iter search get-score
  [ cost parent set[ cost parent ] drop ]
  [
    parent cost iter search dist-to-goal <score>
    iter search get[ scores ] set-at
  ]
  if*
;

:: node-cost ( cur nei search -- cost ) 
  cur search get-score get[ cost ]
  nei get-ref
  +
;

: closer? ( cost iter search -- ? )
  get-score [ get[ cost ] < ] [ drop t ] if*
;

:: total-cost ( iter search -- n )
  iter search get-score get[ dist cost ] +
;

:: update-heap-item ( heap-item search -- )
  heap-item get[ value ] search total-cost :> new-cost
  heap-item new-cost set[ key ] drop
  heap-item get[ heap index ] 0 swap sift-down
;

:: search-push ( iter search -- )
  iter search get[ open ] at
  [ search update-heap-item ]
  [
    iter iter search total-cost search get[ min-cost ]
    heap-push* iter search get[ open ] set-at
  ] if*
;

:: search-neigh ( cur nei search -- )
  cur nei search node-cost :> cost

  cost nei search closer?
  [
    cost cur nei search set-score
    nei search search-push
  ] when
;

:: search-pop ( search -- iter )
  search get[ min-cost ] heap-pop drop :> iter
  iter search get[ open ] delete-at
  iter
;

:: search-path ( cur search -- path )
  cur [ search get-score get[ parent ] dup ]
  [ dup ] produce nip reverse rest cur suffix
;

:: a* ( from to -- path )
  to <search> :> search
  0 f from search set-score

  from
  [ dup to = ]
  [| cur |
    cur neigh [| iter |
      cur iter search search-neigh
    ] each

    search search-pop
  ] until
  search search-path
; 

: from-to ( matrix -- from to )
  [ [ 0 0 ] dip <matrix-iter> ]
  [ [ [ width 1 - ] [ height 1 - ] bi ] keep <matrix-iter> ]
  bi
;

: path-score ( path -- score ) [ get-ref ] map sum ;

:: shift-matrix ( matrix n -- matrix )
  matrix [
    [ 
      n + dup 9 > [ 9 - ] when
    ] map
  ] map
;

:: expand-matrix ( matrix n -- matrix )
  n <iota> [| y |
    n <iota> [| x |
       matrix x y + shift-matrix
    ] map
    unclip [ [ append ] 2map ] reduce
  ] map-concat
;

: show-matrix ( matrix -- str )
  [ [ number>string ] map-concat CHAR: \n suffix ] map-concat
;

INPUT: [ [ 48 - ] { } map-as ] map ;
PART1: from-to a* path-score ;
PART2: 5 expand-matrix from-to a* path-score ;
