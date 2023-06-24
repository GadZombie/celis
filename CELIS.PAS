uses crt,vars,glowne,dos,dzwieki,xms,wave,maskp,mouse,glowngra,reszta,dat_file;

{*}PROCEDURE celis_os(ktore:byte);
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
    port[$3C9]:=0;
    port[$3C9]:=0;
    port[$3C9]:=0;
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
textcolor(15);gotoxy(17,3);write('CELIS wersja demonstracyjna 0.667 (c)SK GAD 2000');
for a:=1 to 10 do begin
    textcolor(a+3);gotoxy(6+a,3);write('˛');gotoxy(75-a,3);write('˛');
end;

IF ktore=0 then begin {-poczatek programu-}
okienko(10,5,35,8,6,1);
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
for a:=1 to 56 do begin textcolor(1);gotoxy(12+a,17);write('˛');end;
okienko(10,20,71,22,6,1);
END
ELSE BEGIN {-koniec programu-}
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
END;
{readkey;}
for b:=1 to 64 do begin
for a:=1 to 15 do begin
    port[$3C8]:=numkol[a];
    port[$3C9]:=trunc((24+trunc(a*2.5))/(64/b));
    port[$3C9]:=trunc((a*4)/(64/b));
    port[$3C9]:=trunc((a)/(64/b));
end;
delay(10);
end;
end;

{*}PROCEDURE pierwsze_sprawy;
const
numkol:array[1..15] of byte=(1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
begin
filemode:=0;
assign(plik,'celis.dat');
{$I-}
reset(plik,1);
{$I+}
if ioresult<>0 then begin
   writeln('Chyba nie ma pliku CELIS.DAT lub jest uszkodzony!!!');
   halt(0);
end
   else close(plik);
assign(plik,'dzwiek.cfg');
{$I-}
Reset(plik,1);
{$I+}
if ioresult<>0 then begin
   writeln('Uruchom najpierw konfiguracje karty muzycznej!');
   halt(0);
end
   else close(plik);

celis_os(0);
randomize;
textcolor(13);gotoxy(12,6);write('Rezerwacja pamieci XMS');
textcolor(15);
if rozpoczecie_xms then begin gotoxy(14,7);write('[ OK ]');end
                   else begin gotoxy(24,7);write('[ BLAD ]');gotoxy(1,24);halt(1);end;

textcolor(13);gotoxy(40,6);write('Rezerwacja pamieci podstawowej');
textcolor(15);
if MaxAvail>=sizeof(costam^) then getmem(costam,sizeof(costam^))
                            else begin gotoxy(56,7);write('[ BLAD ]');gotoxy(1,24);halt(1);end;
if MaxAvail>=sizeof(scr^)    then getmem(scr,sizeof(scr^))
                            else begin gotoxy(56,7);write('[ BLAD ]');gotoxy(1,24);halt(1);end;
if MaxAvail>=sizeof(tlo1^)   then getmem(tlo1,sizeof(tlo1^))
                            else begin gotoxy(56,7);write('[ BLAD ]');gotoxy(1,24);halt(1);end;
if MaxAvail>=sizeof(tlo2^)   then getmem(tlo2,sizeof(tlo2^))
                            else begin gotoxy(56,7);write('[ BLAD ]');gotoxy(1,24);halt(1);end;
if MaxAvail>=sizeof(fonty^)  then getmem(fonty,sizeof(fonty^))
                            else begin gotoxy(56,7);write('[ BLAD ]');gotoxy(1,24);halt(1);end;
if MaxAvail>=sizeof(chmur^)  then getmem(chmur,sizeof(chmur^))
                            else begin gotoxy(56,7);write('[ BLAD ]');gotoxy(1,24);halt(1);end;
fillchar2(scr^,64000,0);
fillchar2(tlo1^,64000,0);
fillchar2(tlo2^,64000,0);
gotoxy(46,7);write('[ OK ]');

textcolor(13);gotoxy(15,11);write('Przejmowanie przerwan');
GetIntVec($9,Save_Int);SetIntVec(Old_Int,Save_Int);fillchar(Kl,SizeOf(Kl),0);SetIntVec($9,@Get_Keyb_Int);
scr_x1:=0;scr_x2:=319;scr_y1:=0;scr_y2:=199;
textcolor(15);gotoxy(17,12);write('[ OK ]');

textcolor(13);gotoxy(50,11);write('Wykrywanie myszy');
textcolor(15);
if mousepresent then begin gotoxy(49,12);write('[ JEST ]');jest_mysz:=true;end
                else begin gotoxy(59,12);write('[ BRAK ]');jest_mysz:=false;end;
if jest_mysz then begin
   mousewindow(0,0,319,199);
   setmouseposition(159,100);
end
   else ustaw.myszka:=0;

textcolor(13);gotoxy(32,16);write('Wczytywanie danych');
wstep;for a:=1 to 12 do begin textcolor(8+a div 8);gotoxy(12+a,17);write('˛');end;
wczytaj_fonty;for a:=13 to 24 do begin textcolor(8+a div 8);gotoxy(12+a,17);write('˛');end;
obrazki;for a:=25 to 36 do begin textcolor(8+a div 8);gotoxy(12+a,17);write('˛');end;
_byla_winieta:=false;
wyborY:=1;
datassign(plik,'celis.dat','transtab.dat',0);
blockread(plik, chmur^,sizeof(chmur^));
close(plik);
for a:=37 to 47 do begin textcolor(8+a div 8);gotoxy(12+a,17);write('˛');end;
wczytaj_konfig;
for a:=48 to 56 do begin textcolor(8+a div 8);gotoxy(12+a,17);write('˛');end;
if paramstr(1)='-bezintro' then begin
   _byla_winieta:=true;
   textcolor(15);gotoxy(33,21);write('INTRO POMINIETE');
end;

for b:=64 downto 1 do begin
for a:=1 to 15 do begin
    port[$3C8]:=numkol[a];
    port[$3C9]:=trunc((24+trunc(a*2.5))/(64/b));
    port[$3C9]:=trunc((a*4)/(64/b));
    port[$3C9]:=trunc((a)/(64/b));
end;
delay(10);
end;
trybgraf;
end;

{*}PROCEDURE ostatnie_sprawy;
const
numkol:array[1..15] of byte=(1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
begin
trybtext;
celis_os(1);
textcolor(13);gotoxy(17,6);write('Zapis ustawien');
textcolor(15);
if zapisz_konfig then begin gotoxy(15,7);write('[ OK ]');end
                 else begin gotoxy(25,7);write('[ BLAD ]');end;
textcolor(13);gotoxy(46,6);write('Zwalnianie przerwan');
SetIntVec($9,Save_Int);
textcolor(15);gotoxy(47,7);write('[ OK ]');
textcolor(13);gotoxy(12,11);write('Zwalnianie pamieci XMS');
zamknij;
textcolor(15);gotoxy(14,12);write('[ OK ]');
textcolor(13);gotoxy(40,11);write('Zwalnianie pamieci podstawowej');
freemem(costam,sizeof(costam^));
freemem(tlo1,sizeof(tlo1^));
freemem(tlo2,sizeof(tlo2^));
freemem(scr,sizeof(scr^));
freemem(fonty,sizeof(fonty^));
freemem(chmur,sizeof(chmur^));
textcolor(15);gotoxy(46,12);write('[ OK ]');

textcolor(12);
gotoxy(22,15);writeln('Odwiedz strone http://gad.koti.com.pl/');
gotoxy(15,16);writeln('Mozesz tez napisac maila na adres gad@gad.koti.com.pl');

{demo}
textcolor(15);
gotoxy(8,18);write('To jest tylko wersja demonstracyjna!');
textcolor(14);
gotoxy(8,19);write('Pelna wersja bedzie zawierac m.in.:');
textcolor(13);
gotoxy(8,20);write('˛ znacznie wiecej przeciwnikow i ich sposobow poruszania');
textcolor(12);
gotoxy(8,21);write('˛ wiecej bossow i bonusow');
textcolor(11);
gotoxy(8,22);write('˛ zwykla gre, w ktorej beda ustalone etapy wraz z zakonczeniem gry');
textcolor(10);
gotoxy(8,23);write('Oczekuj jej jeszcze w tym roku.');
{demo}
{readkey;--------------------------}
for b:=64 downto 1 do begin
for a:=1 to 15 do begin
    port[$3C8]:=numkol[a];
    port[$3C9]:=trunc((24+trunc(a*2.5))/(64/b));
    port[$3C9]:=trunc((a*4)/(64/b));
    port[$3C9]:=trunc((a)/(64/b));
end;
delay(10);
end;
trybtext;
textbackground(0);
textcolor(7);
writeln('-<Celis>---<(c)2000 SK GAD>---<http://gad.koti.com.pl/>---<gad@gad.koti.com.pl>-');
end;

{*}PROCEDURE glowna_struktura_gry;
begin
if not _byla_winieta then intro;
repeat
  _wyjscie:=false;
  _graN1:=false;
  _graN2:=false;
  _graA1:=false;
  _graA2:=false;
  _opcje:=false;
  _rekordy:=false;
  winieta;
{  if _graN1 then ;
  if _graN2 then ;}
  if _graA1 then begin
     _gra_arena:=true;
     nowa_gra(1);
     repeat
        nowy_etap;
        introetap;
        gra;
     until _wyjscie_z_gry;
     gameuower;
     wpisy_na_liste(1,2);
  end;
  if _graA2 then begin
     _gra_arena:=true;
     nowa_gra(2);
     repeat
        nowy_etap;
        introetap;
        gra;
     until _wyjscie_z_gry;
     gameuower;
     wpisy_na_liste(2,2);
  end;
  if _opcje then opcje;
  if _rekordy then lista_najlepszych(1);
until _wyjscie;
end;

{*}BEGIN
pierwsze_sprawy;
glowna_struktura_gry;
(*--- KUIK GEJM ---
   nowa_gra(1);
   nowy_etap;
   wczytaj_pal('etap1.pal');
   gra;
(*--- KUIK GEJM ---*)
ostatnie_sprawy;
end.