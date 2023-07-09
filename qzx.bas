5 REM r* are real parts and i* are imagenary parts of the sv
7 RANDOMIZE
10 LET r0=1:LET i0=0:LET r1=0:LET i1=0
15 LET r2=0:LET i2=0:LET r3=0:LET i3=0
20 LET a0=0
25 LET shots=28
30 CLS
40 PRINT "C64 quantum simulator"
45 PRINT "created by davide gessa (dakk)"
46 PRINT "ZX Spectrum version by TheShich"
50 PRINT "enter gate sequence (x0,x1,y0,y1,z0,z1,h0,h1,cx,sw)"
60 INPUT i$
65 PRINT "calculating the statevector...";
70 FOR i=1 TO LEN i$-1 STEP 2
80 LET g$=i$(i TO i+1)
90 GO SUB 200
91 PRINT ".";
100 NEXT i
101 PRINT
102 LET sq=r0*r0+i0*i0+r1*r1+i1*i1+r2*r2+i2*i2+r3*r3+i3*i3
103 IF ABS(sq-1)> 0.00001 THEN GO SUB 600
105 PRINT "running ";shots;" iterations..."
110 LET z0=0:LET z1=0:LET z2=0:LET z3=0
115 LET p0=(r0*r0+i0*i0)
120 LET p1=(r1*r1+i1*i1)+p0
125 LET p2=(r2*r2+i2*i2)+p1
130 LET p3=(r3*r3+i3*i3)+p2
135 FOR i=1 TO SHOTS
140 LET r=RND: REM RND(0) - CLOCK!
141 IF r < p0 THEN LET z0=z0+1
142 IF r >= p0 AND r < p1 THEN LET z1=z1+1
143 IF r >= p1 AND r < p2 THEN LET z2=z2+1
144 IF r >= p2 AND r < p3 THEN LET z3=z3+1
146 NEXT i
150 PRINT "RESULTS:"
155 PRINT "00:[";Z0;"]"; : FOR i = 1 TO z0 : PRINT "#"; : NEXT i : PRINT
160 PRINT "01:[";Z2;"]"; : FOR i = 1 TO z2 : PRINT "#"; : NEXT i : PRINT 
165 PRINT "10:[";Z1;"]"; : FOR i = 1 TO z1 : PRINT "#"; : NEXT i : PRINT
170 PRINT "11:[";Z3;"]"; : FOR i = 1 TO z3 : PRINT "#"; : NEXT i : PRINT
175 GO TO 1000
200 REM simulate gate operation
210 IF g$ = "x0" THEN GO SUB 400
220 IF g$ = "x1" THEN GO SUB 420
230 IF g$ = "x0" THEN GO SUB 440
240 IF g$ = "x1" THEN GO SUB 460
250 IF g$ = "z0" THEN GO SUB 480
260 IF g$ = "z1" THEN GO SUB 500
270 IF g$ = "h0" THEN GO SUB 520
280 IF g$ = "h1" THEN GO SUB 540
290 IF g$ = "cx" THEN GO SUB 560
300 IF g$ = "sw" THEN GO SUB 580
310 RETURN
400 REM x0 gate
410 LET a0=r0:LET r0=r1:LET r1=a0
411 LET a0=i0:LET i0=i1:LET i1=a0
412 LET a0=r2:LET r2=r3:LET r3=a0
413 LET a0=i2:LET i2=i3:LET i3=a0
416 RETURN
420 REM x1 gate
425 LET a0=r1:LET r1=r3:LET r3=a0
426 LET a0=i1:LET i1=i3:LET i3=a0
427 LET a0=r0:LET r0=r2:LET r2=a0
428 LET a0=i0:LET i0=i2:LET i2=a0
440 REM y0 gate
446 LET a0=i0:LET i0=-r0:LET r0=a0
447 LET a0=i1:LET i1=-r1:LET r1=a0
448 LET a0=i2:LET i2=-r2:LET r2=a0
449 LET a0=i3:LET i3=-r3:LET r3=a0
450 RETURN
460 REM y1 gate
466 LET a0=i1:LET i1=-r1:LET r1=a0
467 LET a0=i3:LET i3=-r3:LET r3=a0
468 RETURN
480 REM z0 gate
482 LET i2=-i2:LET i3=-i3
483 RETURN
500 REM z1 gate
502 LET i1=-i1:LET i3=-i3
503 RETURN
520 REM h0 gate
521 LET a0 = (r0 + r1) / SQR(2) : LET a1 = (i0 + i1) / SQR(2)
522 LET b0 = (r0 - r1) / SQR(2) : LET b1 = (i0 - i1) / SQR(2)
523 LET r0=a0:LET i0=a1:LET r1=b0:LET i1=b1
525 LET a0 = (r2 + r3) / SQR(2) : LET a1 = (i2 + i3) / SQR(2)
526 LET b0 = (r2 - r3) / SQR(2) : LET b1 = (i2 - i3) / SQR(2)
527 LET r2=a0:LET i2=a1:LET r3=b0:LET i3=b1
528 RETURN
540 REM h1 gate
541 LET a0 = (r0 + r2) / SQR(2) : LET a1 = (i0 + i2) / SQR(2)
542 LET b0 = (r0 - r2) / SQR(2) : LET b1 = (i0 - i2) / SQR(2)
543 LET r0=a0:LET i0=a1:LET r2=b0:LET i2=b1
545 LET a0 = (r1 + r3) / SQR(2) : LET a1 = (i1 + i3) / SQR(2)
546 LET b0 = (r1 - r3) / SQR(2) : LET b1 = (i1 - i3) / SQR(2)
547 LET r1=a0:LET i1=a1:LET r3=b0:LET i3=b1
548 RETURN
560 REM cx gate
561 LET a0=r1:LET r1=r3:LET r3=a0
562 LET a0=i1:LET i1=i3:LET i3=a0
579 RETURN
580 REM sw gate
581 LET a0=r1:LET r1=r2:LET r2=a0
582 LET a0=i1:LET i1=i2:LET i2=a0
590 RETURN
600 REM statevcector normalization
601 LET nf = SQR(1 / sq)
602 LET r0=r0*nf
603 LET i0=i0*nf
604 LET r1=r1*nf
605 LET i1=i1*nf
606 LET r2=r2*nf
607 LET i2=i2*nf
608 LET r3=r3*nf
609 LET i3=i3*nf
610 RETURN
1000 STOP
