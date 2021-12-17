USING: aoc.shared aoc.matrix kernel splitting sequences locals
accessors math sets heaps slots.syntax refs math.vectors arrays
assocs sequences.extras combinators.short-circuit.smart io ui
curses math.parser heaps.private formatting ;
IN: aoc.day15

TUPLE: pos risk visited cost ; final
: <pos> ( risk -- pos ) f f pos boa ;

TUPLE: search goal open min-cost ;
: <search> ( goal -- search )
  H{ } clone <min-heap> clone search boa
;

: dist ( from to -- n )
 [ get[ x y ] 2array ] bi@ v- vabs first2 +
;

: dist-to-goal ( iter search -- dist ) get[ goal ] dist ;

: visited? ( iter -- ? ) get-ref visited>> ;
: visited! ( iter -- ) get-ref t swap visited<< ;

: set-cost ( cost iter -- ) get-ref cost<< ;
: get-cost ( iter -- cost ) get-ref get[ cost ] ;
: get-risk ( iter -- risk ) get-ref get[ risk ] ;

: update-cost ( cur nei -- )
  [ get-cost ] dip [ + ] change-cost drop
;

: closer? ( cost iter -- ? ) get-cost [ < ] [ drop t ] if* ;

: search-push ( iter search -- )
  over visited? [ 2drop ] [
   get[ min-cost ] [ dup get-cost ] dip heap-push
  ] if
;

:: search-neigh ( cur nei search -- )
  cur get-cost nei get-risk + :> cost
  cost nei closer? [ cost nei set-cost ] when
  nei search search-push
;

:: search-pop ( search -- iter )
  search get[ min-cost ] heap-pop drop
;

:: dijkstra ( from to -- cost )
  to <search> :> search
  0 from set-cost

  from
  [ dup to = ]
  [| cur |
    cur visited!
    cur neigh [| iter |
      cur iter search search-neigh
    ] each
    search search-pop
  ] until
  get-cost
; 

: from-to ( matrix -- from to )
  [ [ 0 0 ] dip <matrix-iter> ]
  [ [ [ width 1 - ] [ height 1 - ] bi ] keep <matrix-iter> ]
  bi
;

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
PART1: from-to dijkstra ;
PART2: 5 expand-matrix from-to dijkstra ;
