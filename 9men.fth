#! /usr/bin/env gforth
\ 9 men morris prototype
\ 
\ Goal: Make a 10 lines version for Jupiter Ace
\ 

require ttester.fs
\ require extended_tester.fth

: var ( init-val -- ) CREATE , ;

24 constant gamecells
\ 0 var ~pos

\ create posx gamecells cells allot
\ create posy gamecells cells allot

\ : !pos 
\   ~pos @ gamecells < IF
\   ~pos @ 
\   1 ~pos +!
\   THEN
\ ;

: empty S" [ ]" ;
: .empty empty type  ;

: hline ( spacing -- ) 0 do [char] - emit loop ;

: 3line ( spacing -- ) dup .empty hline .empty hline .empty ; 

: .| [char] | emit ;
: |vline ( spacing -- ) space [char] | emit spaces ;
: vline| ( spacing -- ) spaces [char] | emit ;

: draw_board
\ top half of board
15 3line cr
space .| 17 spaces .| 17 spaces .| cr
space .| 3 spaces 10 3line 3 spaces .| cr
space .| 4 spaces .| 12 spaces  .| 12 spaces  .| 4 spaces .| cr
space .| 4 spaces .| 3 spaces 5 3line 3 spaces  .| 4 spaces .| cr

space .| 4 spaces .| 4 spaces .| 15 spaces  .| 4 spaces  .| 4 spaces .| cr
space .| 4 spaces .| 4 spaces .| 15 spaces  .| 4 spaces  .| 4 spaces .| cr

\ center
2 3line 13 spaces 2 3line cr

\ bottom half of board
space .| 4 spaces .| 4 spaces .| 15 spaces  .| 4 spaces  .| 4 spaces .| cr
space .| 4 spaces .| 4 spaces .| 15 spaces  .| 4 spaces  .| 4 spaces .| cr

space .| 4 spaces .| 3 spaces 5 3line 3 spaces  .| 4 spaces .| cr
space .| 4 spaces .| 12 spaces  .| 12 spaces  .| 4 spaces .| cr
space .| 3 spaces 10 3line 3 spaces .| cr
space .| 17 spaces .| 17 spaces .| cr
15 3line cr
;


create Xcolumns 1 , 6 , 11 , 19 , 27 , 32 , 37 ,
create Xrows    0 , 2 ,  4 ,  7 , 10 , 12 , 14 ,

\ 0 var GCrow

\ 0 constant Not_a_Gamecell
1 constant North
2 constant East
4 constant South
8 constant West
North East + South + West + constant Crossroads

t{ West -> 8 }t
\ t{ West . -> out: 8 t}
\ t{ West . /-> out: 7t}

\ : decode_1_gc C@ . 
\   dup [char] | = IF THEN
\   dup [char] ^ = IF THEN
\   dup [char] _ = IF THEN
\   dup [char] - = IF THEN
\   0 drop
\ ;


: GC, ( row column -- row column+1 ) , 2dup , , 1+ ;

( All these functions are compiling functions )
( row column -- row column+1 )
: |^  SOUTH EAST + GC, ;
: ^^ 1+ ; \ not a game cell
: ^|^ WEST SOUTH + EAST + GC, ;
: ^|  WEST SOUTH + GC, ; 
: | 1+ ; \ not a game cell
: -+-   Crossroads GC, ;
: _|_ WEST NORTH + EAST + GC, ;
: |_ EAST NORTH + GC, ;
: _| WEST NORTH + GC, ;
: __ 1+ ; \ not a game cell
: |- EAST NORTH + SOUTH + GC, ;
: -| WEST NORTH + SOUTH + GC, ;
 


\ : parse_connection parse-name 2dup type
\ 2dup S" +" str= IF 2drop Crossroads EXIT THEN
\ 2dup S" |^"
\ 2dup S" |"
\ S" ^|^"
\ S" 
\ \ all other ones we care about are 2 characters at least
\ 2 < IF 2 Not_a_GC EXIT THEN
\ \ options that we care about in first two characters
\ \ | ^ - _ 
\ dup decode_1_gc
\ swap 1+ decode_1_gc
\ \ game cell can't be both the same
\ 2dup = if 2drop Not_a_GC EXIT THEN
\  
\ ;


\ : parse_gamerow 
\   1 GCrow +!
\   cr ." Row" GCrow ? ." : "
\   7 0 do 
\      I . 
\    
\         ." stack<" .s ." >end" , I GC,
\   loop
\   . . . . . . . 
\ ;

create gamecells_data
0 0 |^  ^^  ^^ ^|^ ^^ ^^   ^| 2drop
1 0 |   |^  ^^ -+- ^^  ^|   | 2drop
2 0 |   |   |^ _|_ ^|   |   | 2drop
3 0 |- -+- -|   1+  |- -+- -| 2drop
4 0 |   |   |_ ^|^ _|   |   | 2drop
5 0 |   |_  __ -+- __  _|   | 2drop
6 0 |_  __  __ _|_ __ __   _| 2drop

: fetch_GC ( index -- directions row column )
  3 * cells gamecells_data + dup @ swap CELL+ dup @ swap CELL+ @ 
;

: .dir ( direction -- )
  dup 1 AND IF ." N" ELSE SPACE THEN
  dup 2 AND IF ." E" ELSE SPACE THEN
  dup 4 AND IF ." S" ELSE SPACE THEN
  dup 8 AND IF ." W" ELSE SPACE THEN
;
: list_GC
cr ." Raw Gamecell data" cr 
gamecells 0 do 
  I fetch_GC
  I . ." : " . . .dir cr
loop
;

\ variable lastline
\ : draw_GC
\   cr
\   0 lastline !
\   gamecells 0 do 
\     I fetch_GC
\     lastline @ <> IF cr 1 lastline +! THEN
\     .empty 
\ loop
\ ;


\ gamecells are 1-24
: gc->x ( gamecell -- x )
;
: gc->y ( gamecell -- y )
;

\ : black ( gamecell -- )
\ ;
\ : white ( gamecell -- )
\ ;

require ANSI.fth

: print_at ;

\ cls draw_board

: show_columns
  cls draw_board
  Xcolumns
  7 0 do
     I CELLS Xcolumns + @ 1+ 1  XY ." *" cr
  loop
;

: atGC ( GCx GCy -- )
   CELLS Xrows    + @ 1+ swap 
   CELLS Xcolumns + @ 1+ swap
   XY
;

: atGC+1 ( GCx GCy -- )
   CELLS Xrows    + @ 2 + swap 
   CELLS Xcolumns + @ 2 + swap
   XY
;

: show_mapping
  cls draw_board
  gamecells 0 do 
    I fetch_GC
    atGC ." *" drop \ . \ .dir
  loop

;

: show_cell#
    gamecells 0 do
        I fetch_GC
        atGC+1 I 1+ . drop
    loop
;

create map_data gamecells allot

: clear_map
    gamecells 0 do
        0 map_data c!
    loop
;

: draw_cell ( player cell# -- )
    fetch_GC atGC drop 1 = IF
        ." 1"
    ELSE
        ." 2"
    THEN
; 

: get_player ( cell# -- player )
    map_data + C@
;

: draw_map
    cls draw_board
    gamecells 0 do
        I get_player
        ?dup if 
            I draw_cell
        then
    loop
;

: set_player ( player cell# -- )
    map_data + !
;

: >status ( addr count -- )
    0 20 XY type
;

0 value game_phase
9 value spare_black
9 value spare_white

: inbounds ( position -- flag )
  dup 1 < swap gamecells > or  
;

: play_spare ( position -- success_ )
  dup inbounds if
    S" Invalid Position" >status
    drop
  else spare_black 0= IF
    S" No more spares left" >status
    drop
  else 
    spare_black 1- to spare_black
  then then
;

: 9men
  clear_map
  draw_map
  show_cell#
  cr cr
;

9men
\ bye


