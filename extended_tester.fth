\ extend tester.fs for output specifications using OUT: uh 2022-10-06
2Variable actual-output

: till-> ( -- c-addr len )
  source >in @ /string 2dup
  BEGIN ( c-addr1 len1 c-addr2 len2 )
    '>' scan ( c-addr1 len1 c-addr3 len3 )
    dup
  WHILE ( c-addr1 len1 c-addr3 len3 )
    over 1- c@ '-' -

  WHILE ( c-addr1 len1 c-addr3 len3 )
    1 /string
  REPEAT THEN ( c-addr1 len1 c-addr3 len3 )

drop nip 1- over - dup >in +! ;

: { ( i*x -- )
till-> ['] evaluate >string-execute actual-output 2! ;

: out: ( ccc} -- )
  '}' parse actual-output 2@ compare
  IF s" UNEXPECTED OUTPUT " error
  ." Actual output: " '"' emit actual-output 2@ type '"' emit cr THEN
} ; 


