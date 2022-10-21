\ ASCII Sequences based on Peter Jakacki's Tachyon Extensions for Mecrisp
\ MIT License

: >> RSHIFT ;
: << LSHIFT ; 

(  *** ANSI ***  )

7 variable ~pen
0 variable ~paper
: PEN@ ~pen @ ;
: PAPER@ ~paper @ ;


\ ANSI COLORS
0 constant black
1 constant red
2 constant green
3 constant yellow
4 constant blue
5 constant magenta
6 constant cyan
7 constant white


: ESC ( ch -- )  $1B EMIT EMIT ;
\ ESC[ is defined by gForth (see esc[ )
\ : ESC[ [char] [ ESC_n ;

\ ESC [ ch
: CSI ( ch -- ) ESC[ EMIT ; 
: HOME [char] H CSI ;

: COL ( col fg/bg -- ) CSI [char] 0 + EMIT [char] m EMIT ;
: PEN! ( col -- )  dup ~pen ! 7 AND [char] 3 COL ; \ 1B 5B 33 m
: PEN ( col -- )  DUP ~pen C@ <> IF PEN! ELSE DROP THEN ;

: PAPER! ( col -- )  dup ~paper ! [char] 4 COL ;
: PAPER ( col -- )  DUP ~paper C@ <> IF PAPER! ELSE DROP THEN ;


: .PAR ( n ch -- )  SWAP 0 <# #S #> TYPE EMIT ;
: CUR ( cmd n -- )  ESC[ SWAP .PAR ;
: XY ( x y -- )  [char] ; SWAP CUR [char] H .PAR ;


\ Erase the screen from the current location
: ERSCN  [char] 2 CSI [char] J EMIT ;
\ Erase the current line
: ERLINE  [char] 2 CSI [char] K EMIT ;
: CLS   ERSCN HOME ; \ $0C EMIT ;

: asw  IF [char] h ELSE [char] l THEN EMIT ;
: CURSOR ( on/off -- ) [char] ? CSI ." 25" asw ;

\ 0 plain 1 bold 2 dim 3 rev 4 uline
: ATR ( ch -- )  CSI [char] m EMIT ;
: PLAIN  white ~pen ! 0 ~paper ! [char] 0 ATR ;

: REVERSE  [char] 7 ATR ;
: BOLD     [char] 1 ATR ;
: UL       [char] 4 ATR ;
: BLINK    [char] 5 ATR ;

: WRAP ( on/off -- )  [char] ? CSI [char] 7 EMIT asw ;


\ E2 96 88
: UTF8 ( code -- )  $E2 EMIT DUP 6 >> $80 + EMIT $3F AND $80 + EMIT  ;


