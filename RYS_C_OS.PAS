uses crt;

const
numkol:array[1..15] of byte=(1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
var
a:integer;

{+}PROCEDURE okienko(x1,y1,x2,y2,k1,k2:byte);
var b:byte;
begin
textcolor(k1);
for b:=x1 to x2 do begin gotoxy(b,y1);write('‹');end;
for b:=y1+1 to y2-1 do begin gotoxy(x1,b);write('€');end;
gotoxy(x1,y2);write('ﬂ');
textcolor(k2);
for b:=x1+1 to x2 do begin gotoxy(b,y2);write('ﬂ');end;
for b:=y1+1 to y2-1 do begin gotoxy(x2,b);write('€');end;
end;

begin
textbackground(0);
clrscr;
for a:=1 to 15 do begin
    port[$3C8]:=numkol[a];
    port[$3C9]:=24+trunc(a*2.5);
    port[$3C9]:=a*4;
    port[$3C9]:=a;
end;

textbackground(3);
for a:=2 to 24 do begin
    textcolor(5);
    gotoxy(6,a);write('€                                                                    ');
    textcolor(1);
    write('€');
end;
gotoxy(7,24);write('‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹');
textcolor(5);
gotoxy(7,2);write('ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ');
textcolor(15);gotoxy(17,3);write('CELIS wersja demonstracyjna 0.666 (c)SK GAD 2000');
for a:=1 to 10 do begin
    textcolor(a+3);gotoxy(6+a,3);write('˛');gotoxy(75-a,3);write('˛');
end;

{-poczatek programu-}
(*okienko(10,5,35,8,6,1);
textcolor(6);gotoxy(12,6);write('Rezerwacja pamieci XMS');
gotoxy(14,7);write('[ OK ]    [ BLAD ]');
okienko(38,5,71,8,6,1);
textcolor(6);gotoxy(40,6);write('Rezerwacja pamieci podstawowej');
gotoxy(46,7);write('[ OK ]    [ BLAD ]');

okienko(10,10,40,13,6,1);
textcolor(6);gotoxy(15,11);write('Przejmowanie przerwan');
gotoxy(17,12);write('[ OK ]   [ BLAD ]');
okienko(43,10,71,13,6,1);
textcolor(6);gotoxy(50,11);write('Wykrywanie myszy');
             gotoxy(49,12);write('[ JEST ]  [ BRAK ]');
okienko(10,15,71,18,6,1);
textcolor(6);gotoxy(32,16);write('Wczytywanie danych');
for a:=1 to 56 do begin
    textcolor(1);gotoxy(12+a,17);write('˛'); {a div 8}
end;*)

{-koniec programu-}
okienko(10,5,37,8,6,1);
textcolor(6);gotoxy(17,6);write('Zapis ustawien');
             gotoxy(15,7);write('[ OK ]    [ BLAD ]');
okienko(40,5,71,8,6,1);
textcolor(6);gotoxy(46,6);write('Zwalnianie przerwan');
             gotoxy(47,7);write('[ OK ]   [ BLAD ]');

okienko(10,10,35,13,6,1);
textcolor(6);gotoxy(12,11);write('Zwalnianie pamieci XMS');
gotoxy(14,12);write('[ OK ]    [ BLAD ]');
okienko(38,10,71,13,6,1);
textcolor(6);gotoxy(40,11);write('Zwalnianie pamieci podstawowej');
gotoxy(46,12);write('[ OK ]    [ BLAD ]');
okienko(10,14,71,17,6,1);

readkey;
end.