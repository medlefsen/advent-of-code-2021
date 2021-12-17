USING: aoc.shared aoc.matrix kernel splitting sequences locals
accessors math sets heaps slots.syntax refs math.vectors arrays
assocs sequences.extras combinators.short-circuit.smart io ui
curses math.parser heaps.private ;
IN: aoc.day15

TUPLE: pos risk parent cost dist ; final
: <pos> ( risk -- pos ) f f f pos boa ;

TUPLE: search goal open min-cost ;
: <search> ( goal -- search )
  H{ } clone <min-heap> clone search boa
;

: dist ( from to -- n )
 [ get[ x y ] 2array ] bi@ v- vabs first2 +
;

: dist-to-goal ( iter search -- dist ) get[ goal ] dist ;

: get-score ( iter search -- score )
  drop get-ref dup get[ cost ] [ drop f ] unless
  ;

:: set-score ( cost parent iter search -- ) 
  iter get-ref :> pos
  pos cost parent set[ cost parent ] drop
  pos [ [ iter search dist-to-goal ] unless* ] change-dist drop
  ! pos iter set-ref
;

:: node-cost ( cur nei search -- cost ) 
  cur search get-score get[ cost ]
  nei get-ref get[ risk ]
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

: path-score ( path -- score ) [ get-ref get[ risk ] ] map sum ;

:: shift-matrix ( matrix n -- matrix )
  matrix [
    [ 
      get[ risk ] n + dup 9 > [ 9 - ] when <pos>
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

INPUT: [ [ 48 - <pos> ] { } map-as ] map ;
PART1: from-to a* path-score ;
PART2: 5 expand-matrix from-to a* path-score ;
