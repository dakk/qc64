05 rem r* are real parts and i* are imagenary parts of the sv
10 r0 = 1 : i0 = 0 : r1 = 0 : i1 = 0
15 r2 = 0 : i2 = 0 : r3 = 0 : i3 = 0
20 a0 = 0
25 shots = 28
30 print chr$(147)
40 print "c64 quantum simulator"
45 print "created by davide gessa (dakk)"
50 print "enter gate seq (x0,x1,y0,y1,z0,z1,h0,h1,cx,sw)"
60 input g$
65 print "calculating the statevector...";
70 for i = 1 to len(g$) step 2
80  gate$ = mid$(g$, i, 2)
90  gosub 200
91  print ".";
100 next i
101 print

102 sq = r0*r0 + i0*i0 + r1*r1 + i1*i1 + r2*r2 + i2*i2 + r3*r3 + i3*i3
103 if abs(sq - 1) > 0.00001 then gosub 600

105 print "running" shots "iterations..."
110 z0 = 0 : z1 = 0 : z2 = 0 : z3 = 0
115 p0 = (r0 * r0 + i0 * i0)
120 p1 = (r1 * r1 + i1 * i1) + p0
125 p2 = (r2 * r2 + i2 * i2) + p1
130 p3 = (r3 * r3 + i3 * i3) + p2

135 for i = 1 to shots
140  r = rnd(0)
141  if r < p0 then z0 = z0 + 1
142  if r >= p0 and r < p1 then z1 = z1 + 1
143  if r >= p1 and r < p2 then z2 = z2 + 1
144  if r >= p2 and r < p3 then z3 = z3 + 1
146 next i

150 print "results:"
155 print "00: ["z0"] "; : for i = 1 to z0 : print "Q"; : next i : print
165 print "01: ["z2"] "; : for i = 1 to z2 : print "Q"; : next i : print 
160 print "10: ["z1"] "; : for i = 1 to z1 : print "Q"; : next i : print
170 print "11: ["z3"] "; : for i = 1 to z3 : print "Q"; : next i : print
175 goto 1000

200 rem simulate gate operation
210 if gate$ = "x0" then gosub 400
220 if gate$ = "x1" then gosub 420
230 if gate$ = "y0" then gosub 440
240 if gate$ = "y1" then gosub 460
250 if gate$ = "z0" then gosub 480
260 if gate$ = "z1" then gosub 500
270 if gate$ = "h0" then gosub 520
280 if gate$ = "h1" then gosub 540
290 if gate$ = "cx" then gosub 560
300 if gate$ = "sw" then gosub 580
310 return

400 rem x0 gate
410 a0 = r0 : r0 = r1 : r1 = a0
411 a0 = i0 : i0 = i1 : i1 = a0
412 a0 = r2 : r2 = r3 : r3 = a0
413 a0 = i2 : i2 = i3 : i3 = a0
416 return

420 rem x1 gate
425 a0 = r1 : r1 = r3 : r3 = a0
426 a0 = i1 : i1 = i3 : i3 = a0
427 a0 = r0 : r0 = r2 : r2 = a0
428 a0 = i0 : i0 = i2 : i2 = a0

440 rem y0 gate
446 a0 = i0 : i0 = -r0 : r0 = a0
447 a0 = i1 : i1 = -r1 : r1 = a0
448 a0 = i2 : i2 = -r2 : r2 = a0
449 a0 = i3 : i3 = -r3 : r3 = a0
450 return

460 rem y1 gate
466 a0 = i1 : i1 = -r1 : r1 = a0
467 a0 = i3 : i3 = -r3 : r3 = a0
468 return

480 rem z0 gate
482 i2 = -i2 : i3 = -i3
483 return

500 rem z1 gate
502 i1 = -i1 : i3 = -i3
503 return

520 rem h0 gate
521 a0 = (r0 + r1) / sqr(2) : a1 = (i0 + i1) / sqr(2)
522 b0 = (r0 - r1) / sqr(2) : b1 = (i0 - i1) / sqr(2)
523 r0 = a0 : i0 = a1 : r1 = b0 : i1 = b1
525 a0 = (r2 + r3) / sqr(2) : a1 = (i2 + i3) / sqr(2)
526 b0 = (r2 - r3) / sqr(2) : b1 = (i2 - i3) / sqr(2)
527 r2 = a0 : i2 = a1 : r3 = b0 : i3 = b1
528 return

540 rem h1 gate
541 a0 = (r0 + r2) / sqr(2) : a1 = (i0 + i2) / sqr(2)
542 b0 = (r0 - r2) / sqr(2) : b1 = (i0 - i2) / sqr(2)
543 r0 = a0 : i0 = a1 : r2 = b0 : i2 = b1
545 a0 = (r1 + r3) / sqr(2) : a1 = (i1 + i3) / sqr(2)
546 b0 = (r1 - r3) / sqr(2) : b1 = (i1 - i3) / sqr(2)
547 r1 = a0 : i1 = a1 : r3 = b0 : i3 = b1
548 return

560 rem cx gate
561 a0 = r1 : r1 = r3 : r3 = a0
562 a0 = i1 : i1 = i3 : i3 = a0
579 return 

580 rem sw gate
581 a0 = r1 : r1 = r2 : r2 = a0
582 a0 = i1 : i1 = i2 : i2 = a0
590 return

600 rem statevcector normalization
601 nf = sqr(1 / sq)
602 r0 = r0 * nf
603 i0 = i0 * nf
604 r1 = r1 * nf
605 i1 = i1 * nf
606 r2 = r2 * nf
607 i2 = i2 * nf
608 r3 = r3 * nf
609 i3 = i3 * nf
610 return

1000 end