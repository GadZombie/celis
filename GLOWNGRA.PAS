{$N+}
unit glowngra;

interface
uses crt,vars,glowne,dos,dzwieki,xms,wave,maskp,mouse;
const
sily_poc:array[0..12] of byte=
   { 0}  (1, {zwykle dzialko gracza}
   { 1}   1, {fioletowy pocisk wroga w lewo <-}
   { 2}   3, {kulka niebiesa gracza}
   { 3}   2, {potrojny pocisk gracza}
   { 4}   1, {obracajacy sie plomyk gracza}
   { 5}   3, {czerwona kula ognia gracza}
   { 6}   3, {zielona sciana gracza}
   { 7}   5, {rakiety male}
   { 8}   1, {fioletowy pocisk wroga w prawo ->}
   { 9}   1, {pomaranczowy pocisk wroga}
   {10}   1, {zielony, obracajacy sie pocisk wroga}
   {11}   1, {ognista kula gracza z addona}
   {12}   1  {dlugi laser gracza [pozny poziom pierwszej broni]}
          );
rozmpoc:array[0..12] of record
        rx,ry:byte;
        end=
        ((rx:3;ry:3),
         (rx:5;ry:5),
         (rx:7;ry:7),
         (rx:6;ry:11),
         (rx:7;ry:7),
         (rx:6;ry:5),
         (rx:8;ry:11),
         (rx:10;ry:3),

         (rx:5;ry:5),
         (rx:5;ry:5),
         (rx:5;ry:5),
         (rx:5;ry:5),
         (rx:11;ry:3)
         );
max_bronie:array[1..6] of byte=
         (7, {niebieska plazma}
          7, {potrojny pocisk}
          6, {ognie w 3 kierunki}
          5, {8-way}
          8, {sciana}
          5);{rakiety}

ilosc_wrogow_zwyklych  :byte=10;
ilosc_wrogow_wszystkich:byte=11;
wrognum:array[0..10] of record
        rx,ry,kolsyf1,kolsyf2:byte;
        ofs:longint;
        end=
        ((rx:20;ry:20;kolsyf1:20;kolsyf2:12;ofs:0),      {zielone kolko z kropka}
         (rx:30;ry:20;kolsyf1:36;kolsyf2:36;ofs:4000),   {zolty balonik}
         (rx:26;ry:26;kolsyf1:66;kolsyf2:122;ofs:7000),  {kolczasta kulka}
         (rx:27;ry:27;kolsyf1:66;kolsyf2:34;ofs:12000),  {koniczyna}
         (rx:26;ry:19;kolsyf1:27;kolsyf2:122;ofs:18000), {obrotowy z kolcami}
         (rx:18;ry:18;kolsyf1:27;kolsyf2:27;ofs:31000),  {niebieska pulsujaca kula}
         (rx:22;ry:23;kolsyf1:58;kolsyf2:27;ofs:33000),  {niebieskie kolko z kolcami}
         (rx:26;ry:26;kolsyf1:20;kolsyf2:75;ofs:37000),  {zielona kostka}
         (rx:20;ry:20;kolsyf1: 2;kolsyf2:123;ofs:50000), {blyszczace kolko}
         (rx:26;ry:21;kolsyf1:121;kolsyf2:200;ofs:56000),{zielona kolczasta mina}
      {-}(rx:52;ry:31;kolsyf1:20;kolsyf2:51;ofs:21000)); {fioletowa duza ryba}

bossnum:array[0..0] of record
        rx,ry,kolsyf1,kolsyf2:byte;
        end=
        ((rx:60;ry:100;kolsyf1:20;kolsyf2:12));      {}

var
  _byla_winieta,
  _wyjscie,
  _graN1,
  _graN2,
  _graA1,
  _graA2,
  _opcje,
  _rekordy,
  _wyjscie_z_gry,
  _gra_arena,
  _etap_ukonczony :boolean;
  wyborY:byte;
  obbuf:array[0..3599] of byte;

{*}PROCEDURE sprawdz_mysz;
{*}PROCEDURE zmiany;
{*}PROCEDURE nowa_grupa_wrogow(rruch,ry,rilosc,rwygl:byte; rrez1:real ;bonglut,bonbr1,bonbr2:byte);
{*}PROCEDURE losuj_wrogow_arena;
{*}PROCEDURE nowy_boss(rruch,rwygl, bonglut,bonbr1,bonbr2:byte);
{*}PROCEDURE nowa_gra(gracze:byte);
{*}PROCEDURE ustaw_gracza(gr:byte);
{*}PROCEDURE nowy_etap;
{*}PROCEDURE nowysyf(stx,sty,sdx,sdy:single;kolor,rodzaj:byte);
{*}PROCEDURE syfki;
{*}PROCEDURE strzel(sx,sy,sdx,sdy:single;rodzaj,czyje,dzw:byte;wysdzw:real);
{*}PROCEDURE nowybon(sx,sy:single;rodzaj:byte);
{*}PROCEDURE nowynap(sx,sy:integer;rodzaj,dlug:byte);
{*}PROCEDURE nowywyb(sx,sy:integer;rodzaj,szyb:byte);
{*}PROCEDURE zabij_gracza(gr:byte);
{*}PROCEDURE pociski;
{*}PROCEDURE bonusy;
{*}PROCEDURE napisy;
{*}PROCEDURE wybuchy;
{*}PROCEDURE wrogi;
{*}PROCEDURE bossy;
{*}PROCEDURE strzel_gracz(gr:byte);
{*}PROCEDURE pauza;
{*}PROCEDURE rysuj_ekran;
{*}PROCEDURE gwiazdki(zwykly:byte);
{*}PROCEDURE rysuj_radar;
{*}PROCEDURE gra;

implementation
{*}PROCEDURE sprawdz_mysz;
begin
smmx:=mmx;
smmy:=mmy;
GetMousePosition(button,mmx,mmy);
if button=0 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=false;guzik[2]:=false;end;
if button=1 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=true ;guzik[2]:=false;end;
if button=2 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=false;guzik[2]:=true ;end;
if button=3 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=true ;guzik[2]:=true ;end;
if (not Sguzik[1]) and (guzik[1]) then klik[1]:=true
                                  else klik[1]:=false;
if (not Sguzik[2]) and (guzik[2]) then klik[2]:=true
                                  else klik[2]:=false;
mmx:=mmx div 2;
end;


{*}PROCEDURE zmiany;
begin
inc(zmiana[1]); if zmiana[1]>=4 then zmiana[1]:=0;
inc(zmiana[3]); if zmiana[3]>=7 then zmiana[3]:=0;
if zmiana[3]=0 then begin
   inc(zmiana[2]); if zmiana[2]>=2 then zmiana[2]:=0;
   inc(zmiana[4]); if zmiana[4]>=50 then zmiana[4]:=0;
end;
inc(zmiana[5]); if zmiana[5]>=2 then zmiana[5]:=0;
if zmiana[5]=0 then begin
   inc(zmiana[6]); if zmiana[6]>=12 then zmiana[6]:=0;
end;
end;

{*}PROCEDURE nowa_grupa_wrogow(rruch,ry,rilosc,rwygl:byte; rrez1:real ;bonglut,bonbr1,bonbr2:byte);
var
a,b,bb,a1,b1,r2,r3:integer;
bbr1,bbr2:byte;
begin
b:=0;bb:=1;
r2:=random(200);
r3:=random(200);
grupy[teraz_grupa]:=0;
bbr1:=random(rilosc)+1;
if rilosc>1 then
   repeat
      bbr2:=random(rilosc)+1;
   until bbr2<>bbr1;
for a:=1 to rilosc do begin
    b1:=9999;
    for a1:=1 to maxwrog do if not wrog[a1].jest then begin b1:=a1;a1:=maxwrog;end;
    if b1<9999 then
      with wrog[b1] do begin
         ruch:=rruch;
         px:=340;
         py:=ry;
         dx:=0;
         dy:=0;
         case rruch of
            0:begin {banda rozrzuconych powoli w lewo}
              x:=px+20+sin(a)*random(40);
              y:=py+cos(a)*random(40);
              if trunc(rrez1)=0 then dx:=-0.3
                                else dx:=-0.3-random/3
              end;
            3:begin {ustawieni w pionie po chwili na gracza}
              x:=px;
              y:=py+(a-1)*22;
              end;
            4:begin {sinus-glizda}
              if rwygl<ilosc_wrogow_zwyklych then x:=px+a*10
                                             else x:=px+a*30;
              y:=py-cos(a)*5;
              end;
            5:begin {krecace koleczko, w lewo}
              px:=395;
              end;
            6:begin {waz za srodkiem, w lewo}
              x:=px+100+a*10;
              dx:=-2.5;
              if py>=100 then begin y:=py+a*10;dy:=-2.5; end
                         else begin y:=py-a*10;dy:=2.5;  end;
              end;
            7:begin {rozsypana sciana z prawej}
              x:=px;
              y:=py+a*15;
              dx:=-random*2-0.5;
              end;
            8:begin {kolejka z prawej}
              x:=px+a*20;
              y:=py-a*(rrez1*10);
              dx:=-2;
              dy:=rrez1;
              end;
            9:begin {sciana z prawej}
              x:=px;
              y:=py+a*20;
              end;
           10:begin {rozsypane z prawej}
              x:=px+random(trunc(rrez1));
              y:=random(200);
              dx:=-szybkosc_lotu;
              end;
           11:begin {przeplatajace sie ^v^v^v z prawej}
              if rwygl<ilosc_wrogow_zwyklych then x:=px+a*20
                                             else x:=px+a*40;
              end;
           12:begin {glizda z prawej}
              px:=470;
              rez1:=r2;
              rez2:=r3;
              end;
           13:begin {ustawieni w pionie i po kolei wyskakuja i wracaja}
              x:=px;
              y:=py+(a-1)*20;
              rez1:=rilosc;
              rez2:=0;
              end;
           14:begin {ustawieni w pionie i po kolei przesuwaja sie w prawa i zatrzymuja}
              x:=px;
              y:=py+(a-1)*20;
              end;
          100:begin {kolejka z lewej}
              x:=-120-a*20;
              y:=py-a*(rrez1*10);
              dx:=2;
              dy:=rrez1;
              end;
          101,102:begin {kolejka z lewej, co zakreca z prawej z powrotem}
                        {101-zakreca w dol, 102-zakreca w gore}
              x:=-100-a*20;
              y:=py;
              dx:=1.5;
              rez1:=0;
              rez2:=0;
              end;
          103:begin {kolejka z lewej, po dojsciu do prawej wyskakuje w gore i dol}
              x:=-100-a*20;
              y:=py;
              dx:=1;
              rez1:=0;
              rez2:=0;
              end;
          104:begin {naprzemian z gory i dolu, z lewej wychodza i schodza sie na srodku}
              if a mod 2=0 then y:=20
                           else y:=180;
              x:=-100-a*20;
              dx:=1;
              end;
            else begin
              x:=px;
              y:=py;
              end;
         end;
         wygl:=rwygl;
         case rwygl of
           0:begin {zielone kolko z czerwona kulka}
             ilklatek:=7;
             inc(b);if b>=ilklatek then b:=0;
             ani:=b;
             szani:=3;
             sila:=4;
             kani:=0;
             end;
           1:begin {zolty gluto-bonczek}
             ilklatek:=5;
             b:=b+bb;
             if b>=ilklatek-1 then bb:=-1;
             if b<=0 then bb:=1;
             ani:=b;
             szani:=4;
             sila:=5;
             kani:=1;
             end;
           2:begin {czerwona kula z kolcami}
             ilklatek:=6;
             inc(b);if b>=ilklatek then b:=0;
             ani:=b;
             szani:=4;
             sila:=6;
             kani:=0;
             end;
           3:begin {zolto-czerwona czterolistna koniczyna}
             ilklatek:=7;
             inc(b);if b>=ilklatek then b:=0;
             ani:=b;
             szani:=4;
             sila:=6;
             kani:=0;
             end;
           4:begin {niebiesko-szary obrotowy z kolcami}
             ilklatek:=6;
             inc(b);if b>=ilklatek then b:=0;
             ani:=b;
             szani:=3;
             sila:=7;
             kani:=0;
             end;
           5:begin {niebieska pulsujaca kula}
             ilklatek:=6;
             inc(b);if b>=ilklatek then b:=0;
             ani:=b;
             szani:=6;
             sila:=6;
             kani:=0;
             end;
           6:begin {niebieskie kolko z kolcami}
             ilklatek:=7;
             inc(b);if b>=ilklatek then b:=0;
             ani:=b;
             szani:=4;
             sila:=6;
             kani:=0;
             end;
           7:begin {zielona kostka}
             ilklatek:=19;
             inc(b);if b>=ilklatek then b:=0;
             ani:=b;
             szani:=3;
             sila:=7;
             kani:=0;
             end;
           8:begin {blyszczace kolko}
             ilklatek:=13;
             inc(b);if b>=ilklatek then b:=0;
             ani:=b;
             szani:=2;
             sila:=7;
             kani:=0;
             end;
           9:begin {zielona kolczasta mina}
             ilklatek:=15;
             inc(b);if b>=ilklatek then b:=0;
             ani:=b;
             szani:=1+random(4);
             sila:=5;
             kani:=0;
             end;
          10:begin {fioletowa duza ryba}
             ilklatek:=6;
             inc(b);if b>=ilklatek then b:=0;
             ani:=b;
             szani:=5;
             sila:=16;
             kani:=0;
             end;
         end;
         dozmani:=0;
         sila:=sila+etap_nr div 2;
         bonus:=-1;

         if (bonbr1>0) and (a=bbr1) then bonus:=bonbr1
            else
         if (bonbr2>0) and (a=bbr2) then bonus:=bonbr2
            else
         if (bonglut>0) and (a mod bonglut=0) then bonus:=0;

         jest:=true;
         nr_w_grupie:=a;
         grupa:=teraz_grupa;
         inc(grupy[teraz_grupa]);
      end;
end;
inc(teraz_grupa);if teraz_grupa>10 then teraz_grupa:=1;
end;

{*}PROCEDURE losuj_wrogow_arena;
var
r1:real;
ry,rilosc,rwygl:byte;
begin
b:=random(20);
ry:=0;rilosc:=1;rwygl:=1;
if b>={}15{} then b:=b+85; {liczba przy b musi byc 1 po ostatnim zestawie sprzed 100}
case b of
   0:begin{kupa, przesuwaja sie w lewo}
     ry:=random(160)+20;
     rilosc:=random(19)+1;
     rwygl:=random(ilosc_wrogow_zwyklych);
     r1:=random(2);
     end;
   1:begin{ruch w koleczku zmniejszajacym sie stale, przesuwaja sie w lewo}
     ry:=random(160)+20;
     rilosc:=random(19)+1;
     rwygl:=random(ilosc_wrogow_zwyklych);
     end;
   2:begin{sinusowy ogon, dosc zamieszany, przesuwaja sie w lewo}
     ry:=random(160)+20;
     rilosc:=random(20)+1;
     rwygl:=random(ilosc_wrogow_zwyklych);
     end;
   3:begin{ustawieni w pionie po chwili na gracza, odstepy co 22}
     ry:=random(150)+10;
     rilosc:=random(9-ry div 22)+1;
     if rilosc>=4 then rwygl:=random(ilosc_wrogow_zwyklych)
                  else rwygl:=random(ilosc_wrogow_wszystkich);
     end;
   4:begin{sinus-glizda, w lewo}
     ry:=random(160)+20;
     rilosc:=random(20)+1;
     if rilosc>=5 then rwygl:=random(ilosc_wrogow_zwyklych)
                  else rwygl:=random(ilosc_wrogow_wszystkich);
     end;
   5:begin{krecace koleczko, w lewo}
     ry:=random(160)+20;
     rilosc:=random(10)+1;
     rwygl:=random(ilosc_wrogow_zwyklych)
     end;
   6:begin{waz za srodkiem, w lewo}
     ry:=random(200);
     if (ry> 80) and (ry<100) then ry:=80 else
     if (ry<120) and (ry>=100) then ry:=120;
     rilosc:=random(20)+1;
     rwygl:=random(ilosc_wrogow_zwyklych)
     end;
   7:begin{rozsypana sciana z prawej, odstepy co 15}
     ry:=random(150)+10;
     rilosc:=random(12-ry div 15)+1;
     if rilosc>=4 then rwygl:=random(ilosc_wrogow_zwyklych)
                  else rwygl:=random(ilosc_wrogow_wszystkich);
     end;
   8,100:begin{kolejka w lewo/prawo}
     ry:=random(160)+20;
     rilosc:=random(30)+1;
     rwygl:=random(ilosc_wrogow_zwyklych);
     r1:=0;
     if (random(3)=0) then r1:=(integer(random(2))*2-1)*(random/3+0.1);
     end;
   9:begin{sciana z prawej, odstepy co 20}
     ry:=random(150)+10;
     rilosc:=random(9-ry div 20)+1;
     if rilosc>=4 then rwygl:=random(ilosc_wrogow_zwyklych)
                  else rwygl:=random(ilosc_wrogow_wszystkich);
     end;
  10:begin{rozsypane z prawej (sfera :P)}
     r1:=300+random(500);
     rilosc:=random(trunc(r1-300) div 17)+1;
     if rilosc>=7 then rwygl:=random(ilosc_wrogow_zwyklych)
                  else rwygl:=random(ilosc_wrogow_wszystkich);
     end;
  11:begin{przeplatajace sie ^v^v^v z prawej}
     rilosc:=random(25)+1;
     if rilosc>=6 then rwygl:=random(ilosc_wrogow_zwyklych)
                  else rwygl:=random(ilosc_wrogow_wszystkich);
     end;
  12:begin{glizda z prawej}
     rilosc:=random(19)+1;
     rwygl:=random(ilosc_wrogow_zwyklych);
     end;
  13:begin{ustawieni w pionie i po kolei wyskakuja i wracaja, odstepy co 20}
     ry:=random(150)+10;
     rilosc:=random(9-ry div 20)+1;
     rwygl:=random(ilosc_wrogow_zwyklych)
     end;
  14:begin{ustawieni w pionie i po kolei przesuwaja sie w prawa i zatrzymuja, odstepy co 20}
     ry:=random(150)+10;
     rilosc:=random(9-ry div 20)+1;
     if rilosc>=4 then rwygl:=random(ilosc_wrogow_zwyklych)
                  else rwygl:=random(ilosc_wrogow_wszystkich);
     end;
 101,102:begin{kolejka z lewej, co zakreca z prawej z powrotem: 101-zakreca w dol, 102-zakreca w gore}
     ry:=random(160)+20;
     rilosc:=random(19)+1;
     rwygl:=random(ilosc_wrogow_zwyklych)
     end;
 103:begin{kolejka z lewej, po dojsciu do prawej wyskakuje w gore i dol}
     ry:=random(140)+30;
     rilosc:=random(14)+1;
     rwygl:=random(ilosc_wrogow_zwyklych)
     end;
 104:begin{naprzemian z gory i dolu, z lewej wychodza i schodza sie na srodku}
     rilosc:=random(19)+1;
     rwygl:=random(ilosc_wrogow_zwyklych)
     end;
end;
dod.strzalka.czas:=0;
if b>=100 then dod.strzalka.czas:=200;
if dod.radar.masz then graj_dzwiek(voicedata[11],1,0);
{ rruch,ry,rilosc,rwygl:byte; rrez1:real ;bonglut,bonbr1,bonbr2:byte);}
nowa_grupa_wrogow(b,ry,rilosc,rwygl, r1,
                  random(5),random(16)-1,random(16)-1);
end;

{*}PROCEDURE nowy_boss(rruch,rwygl, bonglut,bonbr1,bonbr2:byte);
var
a,b,bb,r1,r2,r3:integer;
bbr1,bbr2:byte;
begin
b:=0;bb:=1;
r1:=300+random(500);
r2:=random(200);
r3:=random(200);
      with boss do begin
         ruch:=rruch;
         dx:=0;
         dy:=0;
         px:=340;
         x:=360;
         y:=70;
         wygl:=rwygl;
         ginie:=false;
         umiera:=0;
         case rwygl of
           0:begin {brazowy glutowaty z zielonym kolniezem}
             ilklatek:=10;
             inc(b);if b>=ilklatek then b:=0;
             ani:=b;
             szani:=4;
             sila:=240+(etap_nr div 2)*20;
             kani:=0;
             rez1:=0;
             rez2:=0;
             end;
         end;
         dozmani:=0;
         maxsila:=sila;
{         bonus:=-1;
         if (bonbr1>0) and (a=bbr1) then bonus:=bonbr1
            else
         if (bonbr2>0) and (a=bbr2) then bonus:=bonbr2
            else
         if (bonglut=1) or ((bonglut=2) and (a mod 2=0)) then bonus:=0;}

         jest:=true;
      end;
end;

{*}PROCEDURE nowa_gra(gracze:byte);
var a,gr:integer;
begin
ustaw.il_gr:=gracze;
for gr:=1 to ustaw.il_gr do
with gracz[gr] do begin
   for a:=2 to 6 do bron[a]:=0;
   bron[1]:=1;
   wybbron:=1;
   zycia:=5;
   punkty:=0;
   skonczyl:=false;
   for a:=1 to 5 do addon[a].jest:=false;
   iladdon:=0;
end;
dod.strzalka.masz:=false;
dod.boscan.masz:=false;
dod.radar.masz:=false;
etap_nr:=0;
if jest_mysz then begin
   if ustaw.rodzmysz=0 then SetMickeys(2,2)
                       else SetMickeys(ustaw.smx*2,ustaw.smy*2);
end;
end;

{*}PROCEDURE ustaw_gracza(gr:byte);
var a:integer;
begin
with gracz[gr] do begin
   for a:=1 to 6 do temp[a]:=0;
   x:=-30;
   if gr=1 then y:=70
           else y:=130;
   dx:=1;
   dy:=0;
   wychodzi:=true;
   oslona:=150;
   rodzoslony:=0; {zwykla}
   for a:=1 to 5 do begin
       addon[a].x:=x-5-a*5;
       addon[a].y:=y-2-a*3;
       addon[a].dx:=0;
       addon[a].dy:=0;
   end;
   if ustaw.myszka=gr then setmouseposition(50*2,trunc(y));
end;
end;

{*}PROCEDURE nowy_etap;
var a:integer;
begin
inc(etap_nr);
zmiana[1]:=0;
zmiana[2]:=0;
zmiana[3]:=0;
zmiana[4]:=0;
zmiana[5]:=0;
ustaw_gracza(1);
ustaw_gracza(2);
for a:=1 to maxwrog do wrog[a].jest:=false;
for a:=1 to maxpoc do poc[a].jest:=false;
for a:=1 to maxsyf do syf[a].jest:=false;
for a:=1 to maxbon do bon[a].jest:=false;
for a:=1 to maxwyb do wyb[a].jest:=false;
for a:=1 to maxnap do nap[a].jest:=false;
teraz_grupa:=1;
kiedy_brawo:=0;
brawo:=false;
tokeny:=80+(etap_nr-1)*10;
jeszcze_bossow:=etap_nr div 2+1;
szybkosc_lotu:=1;
_etap_ukonczony:=false;
dod.strzalka.czas:=0;
if etap_nr mod 2=0 then begin
   bonus_level:=true;
   with napis do begin
        czas:=100;
        t:='ETAP BONUSOWY!';
        k1:=60;
        k2:=58;
   end;
end
   else begin
   bonus_level:=false;
   with napis do begin
        czas:=50;
        t:='ARENA: ETAP '+l2t(etap_nr div 2+1,2);
        k1:=60;
        k2:=58;
   end;
end;
for a:=1 to maxgwi do
    with gwi[a] do begin
       jest:=true;
       x:=random(320*64);
       y:=random(200*64);
             if bonus_level then kol:=1+random(120)
                            else kol:=1+random(80);
    end;
boss.jest:=false;
bomba_czas:=0;
end;

{*}PROCEDURE nowysyf(stx,sty,sdx,sdy:single;kolor,rodzaj:byte);
var a,b,c:integer;
begin
b:=9999;
for a:=1 to maxsyf do if not syf[a].jest then begin b:=a;a:=maxsyf;end;
if b=9999 then b:=random(maxsyf)+1;
   with syf[b] do begin
      x:=trunc(stx*64);
      y:=trunc(sty*64);
      for c:=0 to 3 do begin
          sx[c]:=x;
          sy[c]:=y;
      end;
      dx:=trunc(sdx*64);
      dy:=trunc(sdy*64);
      kol:=kolor;
      dl:=3-random(3);
      rodz:=rodzaj;
      jest:=true;
   end;
end;

{*}PROCEDURE syfki;
var a,a1,c:integer;
begin
for a:=1 to maxsyf do begin
    if syf[a].jest then begin
       if syf[a].rodz=1 then begin
          for c:=syf[a].dl downto 1 do begin
              syf[a].sx[c]:=syf[a].sx[c-1]-trunc(szybkosc_lotu*64);
              syf[a].sy[c]:=syf[a].sy[c-1];
          end;
          syf[a].sx[0]:=syf[a].x-trunc(szybkosc_lotu*64);
          syf[a].sy[0]:=syf[a].y;
       end;
       if syf[a].rodz=2 then begin
          for c:=syf[a].dl downto 1 do begin
              syf[a].sx[c]:=syf[a].sx[c-1]-trunc(szybkosc_lotu*64+random*64-32);
              syf[a].sy[c]:=syf[a].sy[c-1]+trunc(random*64-32);
          end;
          syf[a].sx[0]:=syf[a].x-trunc(szybkosc_lotu*64+random*64-32);
          syf[a].sy[0]:=syf[a].y+trunc(random*64-32);
       end;
       syf[a].x:=syf[a].x+syf[a].dx-trunc(szybkosc_lotu*64);
       syf[a].y:=syf[a].y+syf[a].dy;
       if zmiana[1]=1 then begin
          if syf[a].dx>0 then syf[a].dx:=syf[a].dx-1;
          if syf[a].dx<0 then syf[a].dx:=syf[a].dx+1;
          if syf[a].dy>0 then syf[a].dy:=syf[a].dy-1;
          if syf[a].dy<0 then syf[a].dy:=syf[a].dy+1;
       end;
       if (syf[a].x<=0) or (syf[a].x>=20416{319 shl 6}) or
          (syf[a].y<=0) or (syf[a].y>=12736{199 shl 6}) or
          ((syf[a].dx>=-2) and (syf[a].dx<=2) and
           (syf[a].dy>=-2) and (syf[a].dy<=2)) then syf[a].jest:=false;

       if syf[a].rodz=1 then
          for c:=0 to syf[a].dl do putpix(syf[a].sx[c] shr 6,syf[a].sy[c] shr 6,syf[a].kol);
       if syf[a].rodz=2 then
          for c:=0 to syf[a].dl do
              putpix(syf[a].sx[c] shr 6,syf[a].sy[c] shr 6,syf[a].kol);

       putpix(syf[a].x shr 6,syf[a].y shr 6,syf[a].kol);
       if (random(20)=0) then dec(syf[a].dl);
       if syf[a].dl<0 then syf[a].jest:=false;
    end;
end;
end;

{*}PROCEDURE strzel(sx,sy,sdx,sdy:single;rodzaj,czyje,dzw:byte;wysdzw:real);
var a,b:byte;
begin
b:=255;
for a:=1 to maxpoc do if not poc[a].jest then begin b:=a;a:=maxpoc;end;
if b<255 then begin
   with poc[b] do begin
      x:=sx;
      y:=sy;
      dx:=sdx;
      dy:=sdy;
      jest:=true;
      czyj:=czyje;
      rodz:=rodzaj;
      case rodzaj of
         3:begin
           szani:=2;
           ilklatek:=4;
           ani:=random(4);
           dozmani:=random(3);
           end;
         4:begin
           szani:=2;
           ilklatek:=4;
           ani:=random(4);
           dozmani:=random(3);
           end;
         5:begin
           szani:=3;
           ilklatek:=2;
           ani:=random(2);
           dozmani:=random(3);
           end;
         6:begin
           szani:=2;
           ilklatek:=2;
           ani:=random(2);
           dozmani:=random(2);
           end;
         7:begin
           szani:=2;
           ilklatek:=2;
           ani:=random(2);
           dozmani:=random(2);
           end;
         8:begin
           szani:=3;
           ilklatek:=2;
           ani:=random(2);
           dozmani:=random(2);
           end;
         10:begin
           szani:=2;
           ilklatek:=4;
           ani:=random(2);
           dozmani:=random(2);
           end;
         11:begin
           szani:=3;
           ilklatek:=2;
           ani:=random(2);
           dozmani:=random(2);
           end;
         12:begin
           szani:=2;
           ilklatek:=2;
           ani:=random(2);
           dozmani:=random(2);
           end;
         else begin
           szani:=0;
           ilklatek:=0;
           ani:=0;
           dozmani:=0;
           end;
      end;
   end;
end;
if dzw>0 then graj_dzwiek(voicedata[dzw],wysdzw,0);
end;

{*}PROCEDURE nowybon(sx,sy:single;rodzaj:byte);
var a,b:byte;
begin
b:=255;
for a:=1 to maxbon do if not bon[a].jest then begin b:=a;a:=maxbon;end;
if b<255 then begin
   with bon[b] do begin
      x:=sx;
      y:=sy;
      jest:=true;
      rodz:=rodzaj;
      kani:=1;
      case rodzaj of
         0:begin
           szani:=4;
           ilklatek:=7;
           ani:=random(7);
           dozmani:=random(4);
           end;
         else begin
           szani:=0;
           ilklatek:=0;
           ani:=0;
           dozmani:=0;
           end;
      end;
   end;
end;
end;

{*}PROCEDURE nowynap(sx,sy:integer;rodzaj,dlug:byte);
var a,b:byte;
begin
b:=255;
for a:=1 to maxnap do if not nap[a].jest then begin b:=a;a:=maxnap;end;
if b<255 then begin
   with nap[b] do begin
      x:=sx;
      y:=sy;
      jest:=true;
      rodz:=rodzaj;
      czas:=dlug;
      case rodzaj of
         0:begin {100 pkt}
           szani:=7;
           ilklatek:=4;
           ani:=random(4);
           dozmani:=random(4);
           end;
      end;
   end;
end;
end;

{*}PROCEDURE nowywyb(sx,sy:integer;rodzaj,szyb:byte);
var a,b:byte;
begin
b:=255;
for a:=1 to maxwyb do if not wyb[a].jest then begin b:=a;a:=maxwyb;end;
if b<255 then begin
   with wyb[b] do begin
      x:=sx;
      y:=sy;
      jest:=true;
      rodz:=rodzaj;
      ani:=0;
      dozmani:=0;
      szani:=szyb;
      case rodzaj of
         0:ilklatek:=7;
         1:ilklatek:=8;
         2:ilklatek:=18;
         3:ilklatek:=14;
         else begin
           szani:=0;
           ilklatek:=0;
           ani:=0;
           dozmani:=0;
           end;
      end;
   end;
end;
end;

{*}PROCEDURE zabij_gracza(gr:byte);
var juz:boolean;
begin
for a:=0 to 4 do nowywyb(trunc(gracz[gr].x-10+random(20)),trunc(gracz[gr].y-10+random(20)),0,4+random(8));
for a:=1 to 5 do
if gracz[gr].addon[a].jest then
   nowywyb(trunc(gracz[gr].addon[a].x),trunc(gracz[gr].addon[a].y),1,5+random(7));
if ustaw.detale>0 then
   for b:=0 to ustaw.detale*10 do
       nowysyf(gracz[gr].x-5+random(10),gracz[gr].y-5+random(10),random*2-1,random*2-1,12+random(4),random(3));
   if gracz[gr].zycia>0 then begin
      dec(gracz[gr].zycia);
      ustaw_gracza(gr);
   end else gracz[gr].skonczyl:=true;
dec(gracz[gr].bron[gracz[gr].wybbron]);
if gracz[gr].bron[1]<=0 then gracz[gr].bron[1]:=1;
if gracz[gr].bron[gracz[gr].wybbron]<=0 then
   repeat
      inc(gracz[gr].wybbron);
      if gracz[gr].wybbron>6 then gracz[gr].wybbron:=1;
   until gracz[gr].bron[gracz[gr].wybbron]>0;
for a:=1 to 5 do gracz[gr].addon[a].jest:=false;
gracz[gr].iladdon:=0;
graj_dzwiek(voicedata[7],1+random/1.7,0);
juz:=false;
if (dod.strzalka.masz) or (dod.radar.masz) or (dod.boscan.masz) then
   repeat
      a:=random(3);
      if (a=0) and (dod.strzalka.masz) then begin dod.strzalka.masz:=false;juz:=true;end;
      if (a=1) and (dod.radar.masz) then begin dod.radar.masz:=false;juz:=true;end;
      if (a=2) and (dod.boscan.masz) then begin dod.boscan.masz:=false;juz:=true;end;
   until juz;
end;

{*}PROCEDURE pociski;
var a,a1,b,gr:byte;
const
pocnum:array[0..12] of longint=(0,1,2,3,7,11,13,15,17,19,20,24,26);
begin
for a:=1 to maxpoc do begin
    if poc[a].jest then begin
       poc[a].x:=poc[a].x+poc[a].dx;
       poc[a].y:=poc[a].y+poc[a].dy;
       if (poc[a].x<=-10) or (poc[a].x>=329) or (poc[a].y<=-10) or (poc[a].y>=209) then poc[a].jest:=false;
       inc(poc[a].dozmani);
       if poc[a].dozmani>=poc[a].szani then begin
          poc[a].dozmani:=0;
          inc(poc[a].ani);
          if poc[a].ani>=poc[a].ilklatek then poc[a].ani:=0;
       end;

       if poc[a].czyj<>0 then begin {rozwalanie pociskiem wrogow}
         for a1:=1 to maxwrog do
           if wrog[a1].jest then begin
              if (poc[a].jest) and
                 (poc[a].x+rozmpoc[poc[a].rodz].rx div 2>=wrog[a1].x-wrognum[wrog[a1].wygl].rx div 2+3) and
                 (poc[a].x-rozmpoc[poc[a].rodz].rx div 2<=wrog[a1].x+wrognum[wrog[a1].wygl].rx div 2-3) and
                 (poc[a].y+rozmpoc[poc[a].rodz].ry div 2>=wrog[a1].y-wrognum[wrog[a1].wygl].ry div 2+3) and
                 (poc[a].y-rozmpoc[poc[a].rodz].ry div 2<=wrog[a1].y+wrognum[wrog[a1].wygl].ry div 2-3) then begin
                 poc[a].jest:=false;
                 if wrog[a1].sila>=sily_poc[poc[a].rodz] then inc(gracz[poc[a].czyj].punkty,sily_poc[poc[a].rodz])
                    else inc(gracz[poc[a].czyj].punkty,wrog[a1].sila);
                 dec(wrog[a1].sila,sily_poc[poc[a].rodz]);
                 if ustaw.detale>0 then
                     for b:=0 to random(ustaw.detale) do
                         nowysyf(poc[a].x,poc[a].y,
                                 random-0.5,random-0.5,12+random(4),0);
                 end;
           end;
         if poc[a].jest then begin
           if boss.jest then begin {rozwalanie pociskiem bossow}
              if (poc[a].jest) and
                 (poc[a].x+rozmpoc[poc[a].rodz].rx div 2>=boss.x-bossnum[boss.wygl].rx div 2+8) and
                 (poc[a].x-rozmpoc[poc[a].rodz].rx div 2<=boss.x+bossnum[boss.wygl].rx div 2-8) and
                 (poc[a].y+rozmpoc[poc[a].rodz].ry div 2>=boss.y-bossnum[boss.wygl].ry div 2+8) and
                 (poc[a].y-rozmpoc[poc[a].rodz].ry div 2<=boss.y+bossnum[boss.wygl].ry div 2-8) then begin
                 poc[a].jest:=false;
                 if not boss.ginie then begin
                    if boss.sila>=sily_poc[poc[a].rodz] then inc(gracz[poc[a].czyj].punkty,sily_poc[poc[a].rodz])
                       else inc(gracz[poc[a].czyj].punkty,boss.sila);
                    dec(boss.sila,sily_poc[poc[a].rodz]);
                    if boss.sila<0 then boss.sila:=0;
                    if (zmiana[3]=0) and (random(30)=0) then graj_dzwiek(voicedata[15],0.75+random/2,0);
                 end;
                 if ustaw.detale>0 then
                     for b:=0 to random(ustaw.detale*2) do
                         nowysyf(poc[a].x,poc[a].y,
                                 random*1.5-0.75,random*1.5-0.75,12+random(4),0);
                 end;
           end;
         end;
       end;
       if poc[a].czyj=0 then {rozwalanie pociskiem graczy}
            for gr:=1 to ustaw.il_gr do
             if (not gracz[gr].skonczyl) and (gracz[gr].oslona=0) then begin
              if (poc[a].jest) and
                 (poc[a].x+rozmpoc[poc[a].rodz].rx div 2>=gracz[gr].x-10) and
                 (poc[a].x-rozmpoc[poc[a].rodz].rx div 2<=gracz[gr].x+10) and
                 (poc[a].y+rozmpoc[poc[a].rodz].ry div 2>=gracz[gr].y-5) and
                 (poc[a].y-rozmpoc[poc[a].rodz].ry div 2<=gracz[gr].y+5) then begin
                 poc[a].jest:=false;
                 zabij_gracza(gr);
              end;
             end;
       MaskPicXMS(trunc(poc[a].x-5),trunc(poc[a].y-5),11,11,0,offsety[2]+(pocnum[poc[a].rodz]+poc[a].ani)*121,@scr^);
    end;
end;
end;

{*}PROCEDURE bonusy;
var a,a1,b,gr:byte;
begin
for a:=1 to maxbon do begin
    if bon[a].jest then begin
       bon[a].x:=bon[a].x-szybkosc_lotu;
       if (bon[a].x<=-20) then bon[a].jest:=false;
       inc(bon[a].dozmani);
       if bon[a].dozmani>=bon[a].szani then begin
          bon[a].dozmani:=0;
          bon[a].ani:=bon[a].ani+bon[a].kani;
          if bon[a].ani>=bon[a].ilklatek-1 then bon[a].kani:=-1;
          if bon[a].ani<=0 then bon[a].kani:=1;
       end;

       for gr:=1 to ustaw.il_gr do
           if (bon[a].jest) and
              (gracz[gr].x>=bon[a].x-9) and
              (gracz[gr].x<=bon[a].x+9) and
              (gracz[gr].y>=bon[a].y-6) and
              (gracz[gr].y<=bon[a].y+7) then begin
              case bon[a].rodz of
                 0:begin inc(gracz[gr].punkty,50);dec(tokeny);end; {glut}
                 1..6: {bronie}
                   if gracz[gr].bron[bon[a].rodz]<max_bronie[bon[a].rodz] then
                      inc(gracz[gr].bron[bon[a].rodz]);
                 7:begin {oslona zwykla}
                   if (gracz[gr].oslona<=0) or (gracz[gr].rodzoslony=0) then begin
                      gracz[gr].oslona:=150;gracz[gr].rodzoslony:=0;end;
                   end;
                 8:begin gracz[gr].oslona:=150;gracz[gr].rodzoslony:=1;end;{oslona zlota}
                 9:inc(gracz[gr].zycia); {zycie}
                 10:if gracz[gr].iladdon<5 then begin {addon}
                       inc(gracz[gr].iladdon);
                       gracz[gr].addon[gracz[gr].iladdon].jest:=true;
                       gracz[gr].addon[gracz[gr].iladdon].x:=bon[a].x;
                       gracz[gr].addon[gracz[gr].iladdon].y:=bon[a].y;
                       if ustaw.detale>0 then
                         for b:=0 to 10+ustaw.detale*3 do
                           nowysyf(bon[a].x-5+random(10),bon[a].y-5+random(10),
                           random*2-1,random*2-1,58+random(3),random(3));

                    end;
                 11:begin {bomba}
                    for a1:=1 to maxwrog do wrog[a1].sila:=0;
                    bomba_czas:=63;
                    graj_dzwiek(voicedata[7],1.5,0);
                    end;
                 12:begin dod.strzalka.masz:=true;dod.strzalka.czas:=0;end; {strzalka z lewej}
                 13:dod.radar.masz:=true; {radar}
                 14:dod.boscan.masz:=true; {boss scaner}
              end;
              bon[a].jest:=false;
              graj_dzwiek(voicedata[4],1,0);
              end;

       case bon[a].rodz of
          0:MaskPicXMS(trunc(bon[a].x-9),trunc(bon[a].y-6),18,13,0,offsety[4]+(bon[a].ani)*234,@scr^);
          1..14:begin
            MaskPicXMS(trunc(bon[a].x-15),trunc(bon[a].y-15),30,30,0,
                       offsety[4]+2900+(bon[a].rodz)*900,@scr^);
            XMS2Mem(_xms[1].h,offsety[4]+2000+zmiana[2]*900,obbuf,900);
            MaskPicT(trunc(bon[a].x-15),trunc(bon[a].y-15),30,30, 0, @chmur^, @obbuf, @scr^);
            {MaskPicXMS(trunc(bon[a].x-15),trunc(bon[a].y-15),30,30,0,offsety[4]+2000+zmiana[2]*900,@scr^);}
            end;
       end;
    end;
end;
end;

{*}PROCEDURE napisy;
var a,a1,b,gr:byte;
begin
for a:=1 to maxnap do begin
    if nap[a].jest then begin
       dec(nap[a].czas);
       if (nap[a].czas<=0) then nap[a].jest:=false;
       inc(nap[a].dozmani);
       if nap[a].dozmani>=nap[a].szani then begin
          nap[a].dozmani:=0;
          inc(nap[a].ani);
          if nap[a].ani>=nap[a].ilklatek then nap[a].ani:=0;
       end;

       case nap[a].rodz of
          0:MaskPicXMS(trunc(nap[a].x-12),trunc(nap[a].y-5),25,11,0,offsety[4]+17000+(nap[a].ani)*275,@scr^);
       end;
    end;
end;
end;

{*}PROCEDURE wybuchy;
var a,a1,b,gr:byte;
const
wybklatki:array[0..3] of longint=(0,7,15,33);
begin
for a:=1 to maxwyb do begin
    if wyb[a].jest then begin
       wyb[a].x:=wyb[a].x-trunc(szybkosc_lotu);
       inc(wyb[a].dozmani);
       if wyb[a].dozmani>=wyb[a].szani then begin
          wyb[a].dozmani:=0;
          inc(wyb[a].ani);
          if wyb[a].ani>=wyb[a].ilklatek-1 then wyb[a].jest:=false;
       end;
       XMS2Mem(_xms[1].h,offsety[5]+(wybklatki[wyb[a].rodz]+wyb[a].ani)*2500,obbuf,2500);
       MaskPicT(trunc(wyb[a].x-25),trunc(wyb[a].y-25),50,50, 0, @chmur^, @obbuf, @scr^);
    end;
end;
end;

{*}PROCEDURE wrogi;
var
gr,a,b:byte;
begin
ilwrog:=0;
for a:=1 to maxwrog do begin
    if wrog[a].jest then begin
       inc(ilwrog);
       wrog[a].x:=wrog[a].x+wrog[a].dx;
       wrog[a].y:=wrog[a].y+wrog[a].dy;
       if (wrog[a].ruch>=100) and (wrog[a].nr_w_grupie=1) and (dod.strzalka.czas>=199) then
          dod.strzalka.y:=trunc(wrog[a].y);

       case wrog[a].ruch of
          0:begin
            wrog[a].px:=wrog[a].px-0.01;
            if (random(100)=0) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,-4,0,1,0,17,1);
            end;
          1:begin
            wrog[a].px:=wrog[a].px-0.01;
            wrog[a].dx:=cos((wrog[a].px)*4+(wrog[a].nr_w_grupie)/3)-0.2;
            wrog[a].dy:=sin((wrog[a].px)*4+(wrog[a].nr_w_grupie)/3);
            if (zmiana[4]=wrog[a].nr_w_grupie) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,-4,0,1,0,17,1);
            end;
          2:begin
            wrog[a].dx:=-0.2+cos(wrog[a].px+wrog[a].nr_w_grupie/15);
            wrog[a].px:=wrog[a].px-0.01;
            wrog[a].dy:=sin((wrog[a].px)*4+(wrog[a].nr_w_grupie)/3)+
                        cos((wrog[a].px)*6+(wrog[a].nr_w_grupie)/1.6);
            if (zmiana[4]=wrog[a].nr_w_grupie) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,-4,0,1,0,17,1);
            end;
          3:begin
            if (wrog[a].px>250) and (wrog[a].x>310) then wrog[a].dx:=-random*2
               else
            if wrog[a].px=150 then begin wrog[a].dx:=-random*3-1;wrog[a].rez1:=1+random(ustaw.il_gr);end
               else
            if wrog[a].px>150 then wrog[a].dx:=0;
            wrog[a].px:=wrog[a].px-1;
            if wrog[a].px<150 then begin
               if (wrog[a].y<gracz[wrog[a].rez1].y) and (wrog[a].dy<0.5) then wrog[a].dy:=wrog[a].dy+0.01
                  else
               if (wrog[a].y>gracz[wrog[a].rez1].y) and (wrog[a].dy>-0.5) then wrog[a].dy:=wrog[a].dy-0.01;
            end;
            if (zmiana[4]=wrog[a].nr_w_grupie) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,-4,0,1,0,17,1);
            end;
          4:begin
            wrog[a].dx:=-0.3;
            wrog[a].px:=wrog[a].px-0.01;
            wrog[a].dy:=cos(wrog[a].nr_w_grupie+wrog[a].px*10)/2;
            if (zmiana[4]=wrog[a].nr_w_grupie) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,-4,0,1,0,17,1);
            end;
          5:begin
            wrog[a].px:=wrog[a].px-0.5;
            wrog[a].x:=sin((wrog[a].nr_w_grupie/10)*6.28+wrog[a].px/40)*50+wrog[a].px;
            wrog[a].y:=cos((wrog[a].nr_w_grupie/10)*6.28+wrog[a].px/40)*50+wrog[a].py;
            if (zmiana[4]=wrog[a].nr_w_grupie) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,-4,0,1,0,17,1);
            end;
          6:begin
            wrog[a].px:=wrog[a].px-0.2;
            if (wrog[a].x<wrog[a].px) and (wrog[a].dx<2.5) then wrog[a].dx:=wrog[a].dx+0.05;
            if (wrog[a].x>wrog[a].px) and (wrog[a].dx>-2.5) then wrog[a].dx:=wrog[a].dx-0.05;
            if (wrog[a].y<100) and (wrog[a].dy<2.5) then wrog[a].dy:=wrog[a].dy+0.05;
            if (wrog[a].y>100) and (wrog[a].dy>-2.5) then wrog[a].dy:=wrog[a].dy-0.05;
            if (zmiana[4]=wrog[a].nr_w_grupie) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,-4,0,1,0,17,1);
            end;
          7:begin
            if (zmiana[4]=wrog[a].nr_w_grupie) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,-4,0,1,0,17,1);
            end;
      8,100:begin
            if wrog[a].y<=5 then wrog[a].dy:=abs(wrog[a].dy);
            if wrog[a].y>=195 then wrog[a].dy:=-abs(wrog[a].dy);
            end;
          9:begin
            wrog[a].dx:=wrog[a].dx-0.03;
            end;
         10:begin
            wrog[a].dx:=-szybkosc_lotu;
            if (random(100)=0) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,-4,0,1,0,17,1);
            end;
         11:begin
            wrog[a].px:=wrog[a].px-0.06;
            wrog[a].dx:=-0.4;
            if wrog[a].nr_w_grupie mod 2=0 then
               wrog[a].y:=sin((wrog[a].nr_w_grupie/3)+wrog[a].px)*30+80 else
               wrog[a].y:=120-sin((wrog[a].nr_w_grupie/3)+wrog[a].px)*30;
            if (zmiana[4]=wrog[a].nr_w_grupie) and (zmiana[3]=0) then begin
               if wrog[a].nr_w_grupie mod 2=0 then
                  strzel(wrog[a].x,wrog[a].y,0,3,8,0,17,1)
                  else
                  strzel(wrog[a].x,wrog[a].y,0,-3,8,0,17,1)
            end;
            end;
         12:begin
            wrog[a].px:=wrog[a].px-0.2;
            wrog[a].x:=sin((wrog[a].nr_w_grupie/15)+wrog[a].px/19+wrog[a].rez1)*130+wrog[a].px;
            wrog[a].y:=cos((wrog[a].nr_w_grupie/15)+wrog[a].px/37+wrog[a].rez2)*90+100;
            if (zmiana[4]=wrog[a].nr_w_grupie) and (zmiana[3]=0) then begin
               if wrog[a].nr_w_grupie mod 2=0 then strzel(wrog[a].x,wrog[a].y,-4,0,1,0,17,1)
                                              else strzel(wrog[a].x,wrog[a].y,4,0,9,0,17,1)
            end;
            end;
         13:begin
            if (wrog[a].px>330) and (wrog[a].x>310) then wrog[a].dx:=-random*2
               else
            if (wrog[a].px<=330) then begin
               if wrog[a].dx<5 then wrog[a].dx:=wrog[a].dx+0.08;
               if (trunc(wrog[a].px/4) mod wrog[a].rez1=wrog[a].nr_w_grupie-1)
                  and (wrog[a].rez2=0) then begin wrog[a].dx:=-6;wrog[a].rez2:=1;end;
               if wrog[a].x>310 then begin wrog[a].x:=310;wrog[a].rez2:=0;end;
            end
               else
            if wrog[a].px>310 then wrog[a].dx:=0;
            if (wrog[a].px<=260) and (wrog[a].dx>-2) then
               wrog[a].dx:=wrog[a].dx-0.1;
            wrog[a].px:=wrog[a].px-0.1;
            if (zmiana[4]=wrog[a].nr_w_grupie) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,-4,0,1,0,17,1);
            end;
         14:begin
            wrog[a].dx:=cos(wrog[a].nr_w_grupie+wrog[a].px/5);
            if wrog[a].dx>0 then wrog[a].dx:=0;
            wrog[a].px:=wrog[a].px-0.1;
            if (zmiana[4]=wrog[a].nr_w_grupie) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,-4,0,1,0,17,1);
            end;
        101,102:begin
            if wrog[a].x>=280 then wrog[a].rez1:=1;
            if wrog[a].rez1=1 then begin
               if wrog[a].dx>-1.5 then wrog[a].dx:=wrog[a].dx-0.05;
               if wrog[a].ruch=101 then begin
                  if (wrog[a].dy<1.1) and (wrog[a].rez2=0) then wrog[a].dy:=wrog[a].dy+0.03;
                  if wrog[a].dy>=1 then wrog[a].rez2:=1;
                  if (wrog[a].dy>0) and (wrog[a].rez2=1) then wrog[a].dy:=wrog[a].dy-0.03;
               end else begin
                  if (wrog[a].dy>-1.1) and (wrog[a].rez2=0) then wrog[a].dy:=wrog[a].dy-0.03;
                  if wrog[a].dy<=-1 then wrog[a].rez2:=1;
                  if (wrog[a].dy<0) and (wrog[a].rez2=1) then wrog[a].dy:=wrog[a].dy+0.03;
               end;
               if (wrog[a].x<=-40) then wrog[a].jest:=false;
            end;
            if (random(100)=0) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,-4,0,1,0,17,1);
            end;
        103:begin
            if (wrog[a].rez1=0) and (random(100)=0) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,3,0,8,0,17,1);
            if (wrog[a].x>=300) and (wrog[a].rez1=0) then wrog[a].rez1:=1;
            if wrog[a].rez1=1 then begin
               wrog[a].dx:=0;
               if wrog[a].nr_w_grupie mod 2=0 then wrog[a].dy:=-2
                                              else wrog[a].dy:=2;
               if (wrog[a].y<0) or (wrog[a].y>199) then wrog[a].rez1:=2;
            end;
            if wrog[a].rez1=2 then begin
               wrog[a].dx:=-1;
               if (wrog[a].y>101) and (wrog[a].dy>-1.5) then wrog[a].dy:=wrog[a].dy-0.1;
               if (wrog[a].y< 99) and (wrog[a].dy<1.5) then wrog[a].dy:=wrog[a].dy+0.1;
               if (trunc(wrog[a].y)=100) then wrog[a].dy:=wrog[a].dy*0.8;
               if (wrog[a].x<=-60) then begin wrog[a].dx:=2;wrog[a].rez1:=3;wrog[a].dy:=random-0.5;end;
               if (random(100)=0) and (zmiana[3]=0) then strzel(wrog[a].x,wrog[a].y,-2,0,8,0,17,1);
            end;
            end;
        104:begin
            if wrog[a].x>=40 then begin
               if (wrog[a].y< 99) and (wrog[a].dy<2)  then wrog[a].dy:=wrog[a].dy+0.03;
               if (wrog[a].y>101) and (wrog[a].dy>-2) then wrog[a].dy:=wrog[a].dy-0.03;

               if (wrog[a].y>=95) and (wrog[a].y<=105) then wrog[a].dy:=wrog[a].dy*0.9;
            end;
            if (zmiana[4]=wrog[a].nr_w_grupie) and (zmiana[3]=0) then
               strzel(wrog[a].x,wrog[a].y,
               2-wrog[a].nr_w_grupie/10,-((wrog[a].nr_w_grupie mod 2)*2-1),
               8,0,17,1);
            end;
       end;

       inc(wrog[a].dozmani);
       if wrog[a].dozmani>=wrog[a].szani then begin
          wrog[a].dozmani:=0;
          if wrog[a].kani=0 then begin
             inc(wrog[a].ani);
             if wrog[a].ani>=wrog[a].ilklatek then wrog[a].ani:=0;
          end
          else begin
             wrog[a].ani:=wrog[a].ani+wrog[a].kani;
             if wrog[a].ani>=wrog[a].ilklatek-1 then wrog[a].kani:=-1;
             if wrog[a].ani<=0 then wrog[a].kani:=1;
          end;
       end;

       if ((wrog[a].x<=-40) and (wrog[a].ruch<100)) or
          ((wrog[a].x>=360) and (wrog[a].ruch>=100)) then wrog[a].jest:=false;

       for gr:=1 to ustaw.il_gr do begin
          if (not gracz[gr].skonczyl) then begin
           if (gracz[gr].x+10>=wrog[a].x-wrognum[wrog[a].wygl].rx div 2+3) and
              (gracz[gr].x-10<=wrog[a].x+wrognum[wrog[a].wygl].rx div 2-3) and
              (gracz[gr].y+5 >=wrog[a].y-wrognum[wrog[a].wygl].ry div 2+3) and
              (gracz[gr].y-5 <=wrog[a].y+wrognum[wrog[a].wygl].ry div 2-3) then begin
              if (gracz[gr].rodzoslony=1) and (gracz[gr].oslona>0) then
                 dec(wrog[a].sila)
                 else if gracz[gr].oslona=0 then begin
                      zabij_gracza(gr);
                      wrog[a].sila:=0;
                      wrog[a].bonus:=-1;
                      end;
           end;
          end;
       end;
       if wrog[a].sila<=0 then begin
          wrog[a].jest:=false;
          if ustaw.detale>0 then
             for b:=0 to ustaw.detale*3 do begin
                 nowysyf(wrog[a].x-5+random(10),wrog[a].y-5+random(10),
                         random*2-1,random*2-1,wrognum[wrog[a].wygl].kolsyf1+random(4),random(3));
                 nowysyf(wrog[a].x-5+random(10),wrog[a].y-5+random(10),
                         random*2-1,random*2-1,wrognum[wrog[a].wygl].kolsyf2+random(4),random(3));
             end;
          if wrog[a].bonus>=0 then nowybon(wrog[a].x,wrog[a].y,wrog[a].bonus);
          nowywyb(trunc(wrog[a].x),trunc(wrog[a].y),random(4),4+random(3));
          dec(ilwrog);
          dec(grupy[wrog[a].grupa]);
          if (grupy[wrog[a].grupa]<=0) then begin
             nowynap(trunc(wrog[a].x),trunc(wrog[a].y),0,100);
             for gr:=1 to ustaw.il_gr do inc(gracz[gr].punkty,100);
          end;
          graj_dzwiek(voicedata[7],0.6+random,0);
       end;
       MaskPicXMS(trunc(wrog[a].x-(wrognum[wrog[a].wygl].rx div 2)),
                  trunc(wrog[a].y-(wrognum[wrog[a].wygl].ry div 2)),
                  wrognum[wrog[a].wygl].rx,wrognum[wrog[a].wygl].ry,0,
                  offsety[1]+
                   longint(wrog[a].ani)*
                   (longint(wrognum[wrog[a].wygl].rx)*
                   longint(wrognum[wrog[a].wygl].ry))+
                   wrognum[wrog[a].wygl].ofs,
                  @scr^);
{       XMS2Mem(_xms[1].h,
                  offsety[1]+
                   longint(wrog[a].ani)*
                   (longint(wrognum[wrog[a].wygl].rx)*
                   longint(wrognum[wrog[a].wygl].ry))+
                   wrognum[wrog[a].wygl].ofs,obbuf,wrognum[wrog[a].wygl].rx*wrognum[wrog[a].wygl].ry);
       MaskPicT(trunc(wrog[a].x-(wrognum[wrog[a].wygl].rx div 2)),
                  trunc(wrog[a].y-(wrognum[wrog[a].wygl].ry div 2)),
                  wrognum[wrog[a].wygl].rx,wrognum[wrog[a].wygl].ry, 0,
                  @chmur^, @obbuf, @scr^);}
    end;
end;
end;

{*}PROCEDURE bossy;
var
gr,a,b:byte;
begin
    if boss.jest then begin
       boss.x:=boss.x+boss.dx;
       boss.y:=boss.y+boss.dy;
       if boss.px>338 then boss.x:=boss.x-0.5;

       boss.dx:=cos((boss.px)*4);
       boss.dy:=sin((boss.px)*4);
       boss.px:=boss.px-0.01;

       if (not boss.ginie) then begin
         if boss.rez1=0 then begin
          if (zmiana[4] in [0,2,4,6,8,10,12]) and (zmiana[3]=0) then begin
             strzel(boss.x-10,boss.y-5,-4,0,10,0,16,1);
          end;
          if (zmiana[4] in [15,18,21,24,27,30]) and (zmiana[3] in [1,3]) then begin
             strzel(boss.x+3,boss.y-3,-3,-2,8,0,0,0);
             strzel(boss.x+3,boss.y-3,-3,2,8,0,16,1.2);
          end;
          if (zmiana[4]>34) and (zmiana[4]<44) and (zmiana[5]=0) then begin
             strzel(boss.x+3,boss.y-3,-3,(0.5-random)*(zmiana[4]/28),10,0,0,0);
             if random(3)=0 then graj_dzwiek(voicedata[16],0.5,0);
          end;
          if (zmiana[4]=46) and (zmiana[3]=0) then begin
             inc(boss.rez2);
             if boss.rez2>=3 then begin inc(boss.rez1);boss.rez2:=0;end;
          end;
         end;
         if boss.rez1=1 then begin
          if (zmiana[3]=0) then begin
             strzel(boss.x,boss.y-trunc(sin(boss.px*7)*15),-3,sin(boss.px*7)*1.5,1,0,16,1.1);
          end;

          if (zmiana[4]=29) and (zmiana[3]=0) then begin
             inc(boss.rez2);
             if boss.rez2>=2 then begin inc(boss.rez1);boss.rez2:=0;end;
          end;
         end;
         if boss.rez1=2 then begin
          if (zmiana[2]=0) and (zmiana[3]=0) then begin
             for b:=0 to 9 do
                 strzel(boss.x,boss.y,sin((b/9)*6.28)*2,cos((b/9)*6.28)*2,8,0,0,0);
             graj_dzwiek(voicedata[16],1.3,0);
          end;
          if (zmiana[4]=29) and (zmiana[3]=0) then begin
             inc(boss.rez2);
             if boss.rez2>=2 then begin boss.rez1:=0;boss.rez2:=0;end;
          end;
         end;
       end;

       inc(boss.dozmani);
       if boss.dozmani>=boss.szani then begin
          boss.dozmani:=0;
          if boss.kani=0 then begin
             inc(boss.ani);
             if boss.ani>=boss.ilklatek then boss.ani:=0;
          end
          else begin
             boss.ani:=boss.ani+boss.kani;
             if boss.ani>=boss.ilklatek-1 then boss.kani:=-1;
             if boss.ani<=0 then boss.kani:=1;
          end;
       end;

       for gr:=1 to ustaw.il_gr do begin
          if (not gracz[gr].skonczyl) then begin
           if (gracz[gr].x+10>=boss.x-bossnum[boss.wygl].rx div 2+3) and
              (gracz[gr].x-10<=boss.x+bossnum[boss.wygl].rx div 2-3) and
              (gracz[gr].y+5 >=boss.y-bossnum[boss.wygl].ry div 2+3) and
              (gracz[gr].y-5 <=boss.y+bossnum[boss.wygl].ry div 2-3) then begin
              if (gracz[gr].rodzoslony=1) and (gracz[gr].oslona>0) and (zmiana[3]=0) then
                 dec(boss.sila)
                 else if gracz[gr].oslona=0 then zabij_gracza(gr);
           end;
          end;
       end;
       if boss.sila<=0 then begin
          boss.sila:=0;
          if not boss.ginie then graj_dzwiek(voicedata[15],0.75+random/2,0);
          boss.ginie:=true;
       end;
       if (boss.ginie) and (zmiana[3]=0) then begin
          inc(boss.umiera);
          if ustaw.detale>0 then
             for b:=0 to ustaw.detale*2 do begin
                 nowysyf(boss.x-5+random(10),boss.y-5+random(10),
                         random*2-1,random*2-1,bossnum[boss.wygl].kolsyf1+random(4),random(3));
                 nowysyf(boss.x-5+random(10),boss.y-5+random(10),
                         random*2-1,random*2-1,bossnum[boss.wygl].kolsyf2+random(4),random(3));
             end;
          nowywyb(trunc(boss.x-25+random(50)),trunc(boss.y-25+random(50)),random(2),4+random(7));
          if random(2)=0 then graj_dzwiek(voicedata[7],0.6+random,0);
          if random(30)=0 then graj_dzwiek(voicedata[15],0.75+random/2,0);
       end;
       if boss.umiera>=40 then begin
          boss.jest:=false;
          if ustaw.detale>0 then
             for b:=0 to ustaw.detale*15 do begin
                 nowysyf(boss.x-5+random(10),boss.y-5+random(10),
                         random*3-1.5,random*3-1.5,bossnum[boss.wygl].kolsyf1+random(4),random(3));
                 nowysyf(boss.x-5+random(10),boss.y-5+random(10),
                         random*3-1.5,random*3-1.5,bossnum[boss.wygl].kolsyf2+random(4),random(3));
             end;
          graj_dzwiek(voicedata[7],1+random/2,0);
          graj_dzwiek(voicedata[7],1+random/2,0);
          graj_dzwiek(voicedata[15],1+random/2,0);
          for a:=1 to random(10) do nowybon(boss.x-30+random(60),boss.y-30+random(60),random(15));
          if jeszcze_bossow=0 then kiedy_brawo:=100;
       end;
       MaskPicXMS(trunc(boss.x-(bossnum[boss.wygl].rx div 2)),
                  trunc(boss.y-(bossnum[boss.wygl].ry div 2)),
                  bossnum[boss.wygl].rx,50,0,
                  offsety[7]+longint(boss.ani)*2*(longint(bossnum[boss.wygl].rx)*50),@scr^);
       MaskPicXMS(trunc(boss.x-(bossnum[boss.wygl].rx div 2)),
                  trunc(boss.y-(bossnum[boss.wygl].ry div 2))+50,
                  bossnum[boss.wygl].rx,50,0,
                  offsety[7]+longint(boss.ani)*2*(longint(bossnum[boss.wygl].rx)*50)+3000,@scr^);
    end;
end;

{*}PROCEDURE strzel_gracz(gr:byte);
var a:integer;
begin
{* strzel(sx,sy,sdx,sdy:single;rodzaj,czyje:byte); *}
case gracz[gr].wybbron of
   1:begin {7}
     if gracz[gr].bron[1]<=6 then begin
        strzel(gracz[gr].x+3,gracz[gr].y-1,6+gracz[gr].bron[1] div 2,0,0,gr,0,0);
        gracz[gr].temp[1]:=10-gracz[gr].bron[1];
        graj_dzwiek(voicedata[0],1.2-gracz[gr].bron[1]/10,0);
     end
        else begin
        strzel(gracz[gr].x+3,gracz[gr].y-1,9,0,12,gr,0,0);
        gracz[gr].temp[1]:=1;
        if zmiana[1]=0 then graj_dzwiek(voicedata[0],2,0);
        end;
     gracz[gr].anim:=2;
     end;
   2:begin {7}
     strzel(gracz[gr].x+1,gracz[gr].y,6+gracz[gr].bron[2] div 2,0,3,gr,0,0);
     gracz[gr].temp[2]:=10-gracz[gr].bron[2];
     gracz[gr].anim:=2;
     graj_dzwiek(voicedata[5],1,0);
     end;
   3:begin {6}
     strzel(gracz[gr].x+6,gracz[gr].y-1 ,7,0,5,gr,0,0);
     if gracz[gr].bron[3]>=2 then begin
        strzel(gracz[gr].x+1,gracz[gr].y-6,5,-2,4,gr,0,0);
        if gracz[gr].bron[3]>=3 then begin
           strzel(gracz[gr].x+1,gracz[gr].y+5,5,2,4,gr,0,0);
           if gracz[gr].bron[3]>=4 then begin
              strzel(gracz[gr].x+1,gracz[gr].y-6,6,-2,4,gr,0,0);
              if gracz[gr].bron[3]>=5 then begin
                 strzel(gracz[gr].x+1,gracz[gr].y+5,6,2,4,gr,0,0);
                 if gracz[gr].bron[3]>=6 then begin
                    strzel(gracz[gr].x-5,gracz[gr].y-1 ,-4,0,2,gr,0,0);
                 end;
              end;
           end;
        end;
     end;
     gracz[gr].temp[3]:=10-gracz[gr].bron[3] div 2;
     gracz[gr].anim:=2;
     graj_dzwiek(voicedata[3],1,0);
     end;
   4:begin {5}
     strzel(gracz[gr].x-1,gracz[gr].y+1, 0,5, 2,gr,0,0);
     strzel(gracz[gr].x-1,gracz[gr].y-1, 0,-5, 2,gr,0,0);
     if gracz[gr].bron[4]>1 then begin
        if gracz[gr].bron[4]<=3 then
           strzel(gracz[gr].x,gracz[gr].y, 5,0, 2,gr,0,0);
        strzel(gracz[gr].x-2,gracz[gr].y, -5,0, 2,gr,0,0);
     end;
     if gracz[gr].bron[4]>2 then begin
        strzel(gracz[gr].x,gracz[gr].y-1, 4,-4, 2,gr,0,0);
        strzel(gracz[gr].x,gracz[gr].y+1, 4,4, 2,gr,0,0);
     end;
     if gracz[gr].bron[4]>3 then begin
        strzel(gracz[gr].x-2,gracz[gr].y-1, -4,-4, 2,gr,0,0);
        strzel(gracz[gr].x-2,gracz[gr].y+1, -4,4, 2,gr,0,0);
        if gracz[gr].bron[4]<=4 then
           strzel(gracz[gr].x,gracz[gr].y, 6,0, 5,gr,0,0);
     end;
     if gracz[gr].bron[4]>4 then begin
        strzel(gracz[gr].x,gracz[gr].y-3, 6,0, 5,gr,0,0);
        strzel(gracz[gr].x,gracz[gr].y+3, 6,0, 5,gr,0,0);
     end;
     gracz[gr].temp[4]:=18-gracz[gr].bron[4];
     gracz[gr].anim:=2;
     graj_dzwiek(voicedata[2],1,0);
     end;
   5:begin {8}
     for a:=1 to gracz[gr].bron[5] do
         strzel(gracz[gr].x+6,gracz[gr].y-gracz[gr].bron[5]*5+a*10-5,
                6+gracz[gr].bron[5] div 2,0,6,gr,0,0);
     gracz[gr].temp[5]:=40-gracz[gr].bron[5];
     gracz[gr].anim:=2;
     graj_dzwiek(voicedata[1],1,0);
     end;
   6:begin {5}
     strzel(gracz[gr].x+11,gracz[gr].y-1,3+gracz[gr].bron[6] div 2,0,7,gr,0,0);
     gracz[gr].temp[6]:=18-gracz[gr].bron[6];
     gracz[gr].anim:=2;
     graj_dzwiek(voicedata[6],1,0);
     end;
end;
end;

{*}PROCEDURE pauza;
var
kll:char;
kont:boolean;
x,y:word;
begin
while keypressed do readkey;
kll:=#255;
kont:=false;

barT(0,0,319,199, 254, scr^,chmur^);
repeat
   MaskPicxms(108,72,52,56, 0, offsety[6], @scr^);
   MaskPicxms(160,72,52,56, 0, offsety[6]+52*56, @scr^);
   piszc(160,80,'PAUZA',39,36,0);
   piszc(160,105,'F10 - WYJsCIE Z GRY',78,75,0);
   piszc(160,115,'INNY KLAWISZ - KONTYNUACJA',78,75,0);

   if keypressed then begin
      kll:=readkey;
      if kll=#0 then begin
         kll:=readkey;
         if kll=#68 then _wyjscie_z_gry:=true;
      end
         else kont:=true;
   end;
   if ustaw.wsynchro then synchro;
   move2(Scr^,mem[$A000:0000]);
until (kont) or (_wyjscie_z_gry);
repeat
   if kl[1] then klw[1]:=true
            else klw[1]:=false;
   while keypressed do readkey;
until not klw[1];
end;

{*}PROCEDURE rysuj_ekran;
const
ter:array[1..12] of byte=(3,4,5,6,7,8,10,11,13,14,18,19);
var
rr:byte;rx:integer;

 {+}PROCEDURE dorysuj; {dorysowywanie elementow nad, w pionie}
 begin
    case rr of
      13:MaskPicXMS(rx,80,60,60,0,offsety[3]+64000+longint(12)*3600,@tlo2^);
      18:begin
         MaskPicXMS(rx,20,60,60,0,offsety[3]+64000+longint(16)*3600,@tlo2^);
         MaskPicXMS(rx,80,60,60,0,offsety[3]+64000+longint(17)*3600,@tlo2^);
         end;
    end;
 end;

begin
move2(tlo2^,tlo1^);
{XMS2Mem(_xms[1].h,offsety[3],tlo2^,64000);}
fillchar2(tlo2^,64000,0);
rx:=ostatnie_tlo.poz;
rr:=ostatnie_tlo.rys;
MaskPicXMS(rx,140,60,60,0,offsety[3]+64000+longint(rr)*3600,@tlo2^);
dorysuj; {dorysowywanie elementow nad, w pionie}
while rx<=260{320-60} do begin
    inc(rx,60);
    case ostatnie_tlo.poprz of {kolejny element w poziomie -+-+- ...}
      8:rr:=9;
      14:rr:=15;
      19:rr:=20;
      else begin
       if random(10)<=4 then rr:=ter[random(12)+1]
                        else rr:=random(3);
      end;
    end;
    ostatnie_tlo.poprz:=rr;
    MaskPicXMS(rx,140,60,60,0,offsety[3]+64000+longint(rr)*3600,@tlo2^);
    dorysuj; {dorysowywanie elementow nad, w pionie}
end;
ostatnie_tlo.rys:=rr;
ostatnie_tlo.poz:=rx-320;
end;

{*}PROCEDURE gwiazdki(zwykly:byte); {0-zwyczajnie rysuj, 1-rysuje "pod" tlem}
const
koll:array[0..15] of byte=
    (32,1,120,2,121,3,123,4,124,125,5,126,127,6,63,7);
begin
for a:=1 to maxgwi do
    if gwi[a].jest then
       with gwi[a] do begin
          x:=x-trunc((kol/150)*szybkosc_lotu*64);
          if x<0 then jest:=false;
          if (zwykly=0) or ((zwykly=1) and (getpix(x shr 6,y shr 6)=0)) then
          putpix(x shr 6,y shr 6,koll[kol shr 3]);
       end
       else
          if random(10)=0 then with gwi[a] do begin
             jest:=true;
             x:=20416{320*64};
             y:=random(12736{200*64});
             if bonus_level then kol:=1+random(120)
                            else kol:=1+random(80);
          end;
end;

{*}PROCEDURE rysuj_radar;
var
a:integer;
begin
MaskPicT(294,8,26,14, 0, @chmur^, @ikony2[1280], @scr^);
bar(295,9+zmiana[6],318,9+zmiana[6],20);
scr_x1:=296;scr_x2:=318;scr_y1:=9;scr_y2:=20;
for a:=1 to maxwrog do begin
    if wrog[a].jest then putpix(299+trunc(wrog[a].x/20),10+trunc(wrog[a].y/20),21);
end;
if boss.jest then putpix(299+trunc(boss.x/20),10+trunc(boss.y/20),22);
for a:=1 to ustaw.il_gr do
    if not gracz[a].skonczyl then
       putpix(299+trunc(gracz[a].x/20),10+trunc(gracz[a].y/20),23);
scr_x1:=0;scr_x2:=319;scr_y1:=0;scr_y2:=199;
end;

{*}PROCEDURE gra;
const
bonus_lev_bon:array[0..10] of byte=
    (1,2,3,4,5,6,9,10,12,13,14);
var
q1,q2,q3:integer;
gr:byte;
s1:single;
miejsce:real;
begin
_wyjscie_z_gry:=false;
ostatnie_tlo.poz:=0;
ostatnie_tlo.rys:=0;
miejsce:=320;
if not bonus_level then begin
   rysuj_ekran;
   for a:=0 to 199 do begin
       move3(tlo1^[a,trunc(miejsce)],scr^[a,0],320-trunc(miejsce));
       move3(tlo2^[a],scr^[a,320-trunc(miejsce)],trunc(miejsce));
   end;
   gwiazdki(1);
end else begin
    fillchar2(scr^,64000,0);
    gwiazdki(0);
end;
move2(Scr^,mem[$A000:0000]);
fadein(2,0,255);
if bonus_level then begin
   kiedy_brawo:=1000;
   szybkosc_lotu:=2;
end;
zmszybkosc_lotu:=szybkosc_lotu;
repeat
if (jest_mysz) and (ustaw.myszka>0) then sprawdz_mysz;

if (kl[59]) and (not klw[59]) then begin {zmiana detali F1}
   klw[59]:=true;
   inc(ustaw.detale);
   if ustaw.detale>=6 then begin
      ustaw.detale:=0;
      for a:=1 to maxsyf do syf[a].jest:=false;
   end;
   with napis do begin
        czas:=10;
        t:='POZIOM DETALI: ';
        for a:=0 to ustaw.detale do t:=t+'*';
        for a:=ustaw.detale to 4 do t:=t+'^';
        k1:=76;
        k2:=74;
   end;
end
   else if not kl[59] then klw[59]:=false;
if (kl[60]) and (not klw[60]) then begin {wl/wyl synchro F2}
   klw[60]:=true;
   ustaw.wsynchro:=not ustaw.wsynchro;
   with napis do begin
        czas:=10;
        if ustaw.wsynchro then begin
           t:='SYNCHRO WlaCZONE';
           k1:=76;
           k2:=74;
        end
           else begin
           t:='SYNCHRO WYlaCZONE';
           k1:=68;
           k2:=66;
        end;
   end;
end
   else if not kl[60] then klw[60]:=false;
if (kl[61]) and (not klw[61]) then begin {wl/wyl dzwieku F3}
   klw[61]:=true;
   jest_dzwiek:=not jest_dzwiek;
   with napis do begin
        czas:=10;
        if jest_dzwiek then begin
           t:='DxWIeK WlaCZONY';
           k1:=76;
           k2:=74;
        end
           else begin
           t:='DxWIeK WYlaCZONY';
           k1:=68;
           k2:=66;
        end;
   end;
end
   else if not kl[61] then klw[61]:=false;


if (kl[1]) and
   (((ustaw.il_gr=1) and (not gracz[1].skonczyl)) or
   ((ustaw.il_gr=2) and ((not gracz[1].skonczyl) or (not gracz[2].skonczyl)))) then pauza;

if (kiedy_brawo>0) and (zmiana[2]=0) then dec(kiedy_brawo);
if (kiedy_brawo=1) then brawo:=true;

if (not bonus_level) and (ilwrog=0) then begin
   if (tokeny=0) and (not boss.jest) and (jeszcze_bossow>0) then begin
      nowy_boss(0,0, 0,0,0);
      if dod.radar.masz then graj_dzwiek(voicedata[11],1.7,0);
      dec(jeszcze_bossow);
   end;
   if (not boss.jest) and (not brawo) and (kiedy_brawo=0) then begin
      losuj_wrogow_arena;
      if random(15-trunc(zmszybkosc_lotu*2))=0 then {zmiana predkosci}
         zmszybkosc_lotu:=1+(random(13)/2);
   end
      else zmszybkosc_lotu:=2; {jak jest boss to predkosc jest zawsze 2}
end;
if bonus_level then zmszybkosc_lotu:=zmszybkosc_lotu+0.001;
if (brawo) then zmszybkosc_lotu:=10;
if szybkosc_lotu>zmszybkosc_lotu then szybkosc_lotu:=szybkosc_lotu-0.02;
if szybkosc_lotu<zmszybkosc_lotu then szybkosc_lotu:=szybkosc_lotu+0.02;
zmiany;
miejsce:=miejsce+szybkosc_lotu;
if miejsce>=320 then begin
   if not bonus_level then rysuj_ekran;
   miejsce:=0;
end;
if not bonus_level then begin
   for a:=0 to 199 do begin
       move3(tlo1^[a,trunc(miejsce)],scr^[a,0],320-trunc(miejsce));
       move3(tlo2^[a],scr^[a,320-trunc(miejsce)],trunc(miejsce));
   end;
   gwiazdki(1);
end
    else begin
         fillchar2(scr^,64000,0);
         gwiazdki(0);
         end;
for gr:=1 to ustaw.il_gr do begin
  if ustaw.myszka=gr then begin
   IF ustaw.rodzmysz=1 then begin
   if (gracz[gr].x<mmx) and (gracz[gr].dx<1.5) then gracz[gr].dx:=gracz[gr].dx+0.4;
   if (gracz[gr].x>mmx) and (gracz[gr].dx>-1.5) then gracz[gr].dx:=gracz[gr].dx-0.4;
   if (gracz[gr].y<mmy) and (gracz[gr].dy<1.5) then gracz[gr].dy:=gracz[gr].dy+0.4;
   if (gracz[gr].y>mmy) and (gracz[gr].dy>-1.5) then gracz[gr].dy:=gracz[gr].dy-0.4;
   if (trunc(gracz[gr].x)=mmx) then gracz[gr].dx:=0;
   if (trunc(gracz[gr].y)=mmy) then gracz[gr].dy:=0;
   END
     ELSE BEGIN
   if (smmx<mmx) then begin
      if abs(mmx-smmx)/ustaw.smx>gracz[gr].dx then gracz[gr].dx:=abs(mmx-smmx)/ustaw.smx;
      mmx:=159;
   end;
   if (smmx>mmx) then begin
      if -abs(mmx-smmx)/ustaw.smx<gracz[gr].dx then gracz[gr].dx:=-abs(mmx-smmx)/ustaw.smx;
      mmx:=159;
   end;
   if (smmy<mmy) then begin
      if abs(mmy-smmy)/ustaw.smy>gracz[gr].dy then gracz[gr].dy:=abs(mmy-smmy)/ustaw.smy;
      mmy:=100;
   end;
   if (smmy>mmy) then begin
      if -abs(mmy-smmy)/ustaw.smy<gracz[gr].dy then gracz[gr].dy:=-abs(mmy-smmy)/ustaw.smy;
      mmy:=100;
   end;
   setmouseposition(mmx*2,mmy);
   if (gracz[gr].dx>1.5) then gracz[gr].dx:=1.5;
   if (gracz[gr].dx<-1.5) then gracz[gr].dx:=-1.5;
   if (gracz[gr].dy>1.5) then gracz[gr].dy:=1.5;
   if (gracz[gr].dy<-1.5) then gracz[gr].dy:=-1.5;
   END;
  end;
end;
if not gracz[1].skonczyl then begin
   if ustaw.myszka<>1 then begin
      if (kl[ustaw.klaw[1,1]]) and (gracz[1].dx<1.5) then gracz[1].dx:=gracz[1].dx+0.4;
      if (kl[ustaw.klaw[1,3]]) and (gracz[1].dx>-1.5) then gracz[1].dx:=gracz[1].dx-0.4;
      if (kl[ustaw.klaw[1,2]]) and (gracz[1].dy<1.5) then gracz[1].dy:=gracz[1].dy+0.4;
      if (kl[ustaw.klaw[1,4]]) and (gracz[1].dy>-1.5) then gracz[1].dy:=gracz[1].dy-0.4;
   end;

   if ((ustaw.myszka<>1) and (kl[ustaw.klaw[1,5]])) or ((ustaw.myszka=1) and (guzik[1])) then begin
      if (gracz[1].temp[gracz[1].wybbron]=0) then strzel_gracz(1);
      for a:=1 to 5 do
         if (gracz[1].addon[a].jest) and (gracz[1].addon[a].temp=0) then begin
            strzel(gracz[1].addon[a].x+8,gracz[1].addon[a].y-1,5,0,11,1,0,0);
            gracz[1].addon[a].temp:=12;
         end;
   end;
   if ((ustaw.myszka<>1) and (kl[ustaw.klaw[1,6]]) and (not klw[ustaw.klaw[1,6]])) or ((ustaw.myszka=1) and (klik[2])) then
      begin
      repeat
         inc(gracz[1].wybbron);
         if gracz[1].wybbron>6 then gracz[1].wybbron:=1;
      until gracz[1].bron[gracz[1].wybbron]>0;
      graj_dzwiek(voicedata[12],1,0);
   klw[ustaw.klaw[1,6]]:=true;
   end
      else if not kl[ustaw.klaw[1,6]] then klw[ustaw.klaw[1,6]]:=false;
end;
if (ustaw.il_gr=2) and (not gracz[2].skonczyl) then begin
   if ustaw.myszka<>2 then begin
      if (kl[ustaw.klaw[2,1]]) and (gracz[2].dx<1.5) then gracz[2].dx:=gracz[2].dx+0.4;
      if (kl[ustaw.klaw[2,3]]) and (gracz[2].dx>-1.5) then gracz[2].dx:=gracz[2].dx-0.4;
      if (kl[ustaw.klaw[2,2]]) and (gracz[2].dy<1.5) then gracz[2].dy:=gracz[2].dy+0.4;
      if (kl[ustaw.klaw[2,4]]) and (gracz[2].dy>-1.5) then gracz[2].dy:=gracz[2].dy-0.4;
   end;
   if ((ustaw.myszka<>2) and (kl[ustaw.klaw[2,5]])) or ((ustaw.myszka=2) and (guzik[1])) then begin
      if (gracz[2].temp[gracz[2].wybbron]=0) then strzel_gracz(2);
      for a:=1 to 5 do
         if (gracz[2].addon[a].jest) and (gracz[2].addon[a].temp=0) then begin
            strzel(gracz[2].addon[a].x+8,gracz[2].addon[a].y-1,5,0,11,2,0,0);
            gracz[2].addon[a].temp:=12;
         end;
   end;
   if ((ustaw.myszka<>2) and (kl[ustaw.klaw[2,6]]) and (not klw[ustaw.klaw[2,6]])) or ((ustaw.myszka=2) and (klik[2])) then
      begin
      repeat
         inc(gracz[2].wybbron);
         if gracz[2].wybbron>6 then gracz[2].wybbron:=1;
      until gracz[2].bron[gracz[2].wybbron]>0;
      graj_dzwiek(voicedata[12],1,0);
      klw[ustaw.klaw[2,6]]:=true;
   end
      else if not kl[ustaw.klaw[2,6]] then klw[ustaw.klaw[2,6]]:=false;
end;

FOR gr:=1 to ustaw.il_gr DO BEGIN
   if not gracz[gr].skonczyl then begin
    if (gracz[gr].oslona>0) and (zmiana[1]=0) then dec(gracz[gr].oslona);
    if (not gracz[gr].wychodzi) and (gracz[gr].x<=10) and (gracz[gr].dx<0) then gracz[gr].dx:=0;
    if (gracz[gr].x>=310) and (gracz[gr].dx>0) then gracz[gr].dx:=0;
    if (gracz[gr].y<=10) and (gracz[gr].dy<0) then gracz[gr].dy:=0;
    if (gracz[gr].y>=190) and (gracz[gr].dy>0) then gracz[gr].dy:=0;

    if (gracz[gr].wychodzi) then begin
       gracz[gr].dx:=1;
       if gracz[gr].x>=50 then gracz[gr].wychodzi:=false;
    end;
    if brawo then gracz[gr].dx:=1;

    gracz[gr].x:=gracz[gr].x+gracz[gr].dx;
    gracz[gr].y:=gracz[gr].y+gracz[gr].dy;

    if gracz[gr].dx>0 then gracz[gr].dx:=gracz[gr].dx-0.2;
    if gracz[gr].dx<0 then gracz[gr].dx:=gracz[gr].dx+0.2;
    if gracz[gr].dy>0 then gracz[gr].dy:=gracz[gr].dy-0.2;
    if gracz[gr].dy<0 then gracz[gr].dy:=gracz[gr].dy+0.2;

    if (gracz[gr].dx>=-0.2) and (gracz[gr].dx<=0.2) then gracz[gr].dx:=0;
    if (gracz[gr].dy>=-0.2) and (gracz[gr].dy<=0.2) then gracz[gr].dy:=0;

    for a:=1 to 5 do
    with gracz[gr].addon[a] do begin
       if a mod 2=0 then begin
          if (y<gracz[gr].y-5-(a-1)*4) and (dy<1.5) then dy:=dy+0.2;
          if (y>gracz[gr].y-(a-1)*4) and (dy>-1.5) then dy:=dy-0.2;
       end else begin
          if (y<gracz[gr].y+(a-1)*4) and (dy<1.5) then dy:=dy+0.2;
          if (y>gracz[gr].y+5+(a-1)*4) and (dy>-1.5) then dy:=dy-0.2;
       end;
       if (x<gracz[gr].x-20-a*5) and (dx<1.5) then dx:=dx+0.2;
       if (x>gracz[gr].x-10-a*3) and (dx>-1.5) then dx:=dx-0.2;

       if dx>0 then dx:=dx-0.1;
       if dx<0 then dx:=dx+0.1;
       if dy>0 then dy:=dy-0.1;
       if dy<0 then dy:=dy+0.1;
       if (dx>=-0.1) and (dx<=0.1) then dx:=0;
       if (dy>=-0.1) and (dy<=0.1) then dy:=0;

       x:=x+dx;
       y:=y+dy;
       if temp>0 then dec(temp);
    end;
    for a:=1 to 6 do if gracz[gr].temp[a]>0 then dec(gracz[gr].temp[a]);
   end
    else begin
         gracz[gr].x:=500;
         gracz[gr].y:=100;
    end;
END;

for gr:=1 to ustaw.il_gr do begin
   if not gracz[gr].skonczyl then begin
    a:=0;s1:=0;q1:=0;q2:=0;q3:=0;
    if (gracz[gr].dy>=0.2) and (gracz[gr].dy<0.9) then begin a:=1;s1:=-0.3;q1:=-1;q2:=0;q3:=0 end
       else
    if (gracz[gr].dy>=0.9) then begin a:=2;s1:=-0.5;q1:=-3;q2:=1;q3:=0 end
       else
    if (gracz[gr].dy<=-0.2) and (gracz[gr].dy>-0.9) then begin a:=3;s1:=0.3;q1:=2;q2:=0;q3:=1 end
       else
    if (gracz[gr].dy<=-0.9) then begin a:=4;s1:=0.5;q1:=3;q2:=0;q3:=2 end;
    MaskPicXMS(trunc(gracz[gr].x-15),trunc(gracz[gr].y-10),30,20,0,(a+(gr-1)*24)*600,@scr^);
    MaskPicXMS(trunc(gracz[gr].x-15),trunc(gracz[gr].y-10),30,20,0,(5+gracz[gr].anim+gracz[gr].wybbron*3-3)*600,@scr^);
    for a:=1 to 5 do
    if gracz[gr].addon[a].jest then
       MaskPicXMS(trunc(gracz[gr].addon[a].x-15),trunc(gracz[gr].addon[a].y-10),30,20,0,23*600,@scr^);
    if (gracz[gr].oslona>40) or ((gracz[gr].oslona>20) and (zmiana[2]=0))
       or ((gracz[gr].oslona>0) and (gracz[gr].oslona<=20) and (zmiana[1]=0)) then begin
       case gracz[gr].rodzoslony of
          0:begin
            XMS2Mem(_xms[1].h,18000,obbuf,578);
            MaskPicT(trunc(gracz[gr].x-17),trunc(gracz[gr].y-9),34,17, 0, @chmur^, @obbuf, @scr^);
            end;
          1:MaskPicXMS(trunc(gracz[gr].x-17),trunc(gracz[gr].y-9),34,17,0,18578,@scr^);
       end;
    end;
    if (ustaw.detale>=3) then begin
    if zmiana[1]<1 then nowysyf(trunc(gracz[gr].x)-11+q2,trunc(gracz[gr].y)-3+q1,
                                -random/3,random/5-0.1+s1,96+random(8),0)
                   else nowysyf(trunc(gracz[gr].x)-12+q3,trunc(gracz[gr].y)+2+q1,
                                -random/3,random/5-0.1+s1,96+random(8),0);
    for a:=1 to 5 do
    if (gracz[gr].addon[a].jest) and (zmiana[1]<=1) then
                        nowysyf(trunc(gracz[gr].addon[a].x)-9,trunc(gracz[gr].addon[a].y),
                                -random/3,random/5-0.1,96+random(8),0)
    end else
    if (ustaw.detale>0) and (ustaw.detale<3) then begin
    if zmiana[1]=0 then nowysyf(trunc(gracz[gr].x)-11+q2,trunc(gracz[gr].y)-3+q1,
                                -random/3,random/5-0.1+s1,96+random(8),0)
                   else if zmiana[1]=2 then nowysyf(trunc(gracz[gr].x)-12+q3,trunc(gracz[gr].y)+2+q1,
                                -random/3,random/5-0.1+s1,96+random(8),0);
    for a:=1 to 5 do
    if (gracz[gr].addon[a].jest) and (zmiana[1]=1) then
                        nowysyf(trunc(gracz[gr].addon[a].x)-9,trunc(gracz[gr].addon[a].y),
                                -random/3,random/5-0.1,96+random(8),0)
    end;
    if (zmiana[5]=0) and (gracz[gr].anim>0) then dec(gracz[gr].anim);
   end;
end;

if ustaw.detale>0 then syfki;
bonusy;
wrogi;
bossy;
pociski;
wybuchy;
napisy;

if dod.strzalka.masz then begin
   if dod.strzalka.czas>0 then begin
      if zmiana[2]=0 then begin
         XMS2Mem(_xms[1].h,offsety[8],obbuf,612);
         MaskPicT(3,dod.strzalka.y-8,36,17, 0, @chmur^, @obbuf, @scr^);
      end;
      dec(dod.strzalka.czas);
   end;
end;

if tokeny<0 then tokeny:=0;
if not bonus_level then begin
   maskpic(0,8,8,8,0,@ikony[8],@scr^);
   pisz(10,9,l2t(tokeny,3),14,11,0);
end;
if dod.strzalka.masz then maskpic(60,8,25,8,0,@ikony2[400],@scr^);
if dod.boscan.masz then begin
   maskpic(198,8,25,8,0,@ikony2[600],@scr^);
   maskpic(223,8,60,8,0,@ikony2[800],@scr^);
   if boss.jest then
      for b:=1 to trunc(56*(boss.sila/boss.maxsila)) do
          bar(224+b,10,224+b,13,104+trunc(b/7.1));
   pisz(208,8,l2t(jeszcze_bossow,2),110,105,0);
end;
if dod.radar.masz then rysuj_radar;
for gr:=1 to ustaw.il_gr do begin
   pisz(0,(gr-1)*193,l2t(gracz[gr].punkty,8),14,11,0);
   if not gracz[gr].skonczyl then begin
    maskpic(65,(gr-1)*192,8,8,0,@ikony[0],@scr^);
    pisz(75,(gr-1)*193,l2t(gracz[gr].zycia,2),14,10,0);
    for a:=1 to 6 do
        if gracz[gr].bron[a]>0 then begin
           if gracz[gr].wybbron=a then maskpic(74+a*35,(gr-1)*192,8,8,0,@ikony[7],@scr^);
           maskpic(74+a*35,(gr-1)*192,8,8,0,@ikony[a],@scr^);
           if gracz[gr].wybbron=a then maskpic(83+a*35,(gr-1)*192,25,8,0,@ikony2[200],@scr^)
                                  else maskpic(83+a*35,(gr-1)*192,25,8,0,@ikony2[0],@scr^);
           for b:=1 to trunc(21*(gracz[gr].bron[a]/max_bronie[a])) do
           bar(84+a*35+b,2+(gr-1)*192,84+a*35+b,5+(gr-1)*192,96+trunc(b/2.8));
        end;
   end else begin
       pisz(100,(gr-1)*193,'KONIEC GRY!',53,10,0);
   end;
end;
{for a:=1 to 10 do pisz(0,20+a*9,l2t(a,2)+'.'+l2t(grupy[a],3),4,3,0);
pisz(50,20+teraz_grupa*9,'-',4,3,0);}
{pisz(250,190,'RAM:'+l2t(memavail,6),4,3,0);}

if (brawo) and
   (((ustaw.il_gr=1) and (gracz[1].x>340)) or
   ((ustaw.il_gr=2) and ((gracz[1].x>340) or (gracz[1].skonczyl)) and
                        ((gracz[2].x>340) or (gracz[2].skonczyl)))) then
   _etap_ukonczony:=true;

if ((ustaw.il_gr=1) and (gracz[1].skonczyl)) or
   ((ustaw.il_gr=2) and (gracz[1].skonczyl) and (gracz[2].skonczyl)) then begin
   XMS2Mem(_xms[1].h,offsety[6],obbuf,2912);
   MaskPicT(108,72,52,56, 0, @chmur^, @obbuf, @scr^);
   XMS2Mem(_xms[1].h,offsety[6]+2912,obbuf,2912);
   MaskPicT(160,72,52,56, 0, @chmur^, @obbuf, @scr^);
   piszc(160,96,'KONIEC GRY!',53,10,0);
   if (kl[1]) then _wyjscie_z_gry:=true;
   _etap_ukonczony:=false;
end;

if napis.czas>0 then begin
   piszc(160,96,napis.t,napis.k1,napis.k2,0);
   if zmiana[3]=0 then dec(napis.czas);
end;
if bonus_level then begin
   piszc(160,106,l2t(kiedy_brawo div 10,2),69,66,0);
   if random(50)=0 then
      if random(10)<7 then nowybon(340,10+random(180),0)
                      else nowybon(340,10+random(180),bonus_lev_bon[random(11)]);
   if kiedy_brawo mod 20=1 then graj_dzwiek(voicedata[14],1,0);
end;

if bomba_czas>1 then begin
   if zmiana[5]=1 then begin
      for a:=0 to 255 do begin
          pal[a,0]:=pal_gl[a,0]+trunc(bomba_czas/(pal_gl[a,0]/63+1));if pal[a,0]>63 then pal[a,0]:=63;
          pal[a,2]:=pal_gl[a,2]-trunc(bomba_czas/(pal_gl[a,2]/63+1));if pal[a,2]>63 then pal[a,2]:=0;
      end;
      cala_paleta(false);
   end
      else dec(bomba_czas);
end
   else
   if bomba_czas=1 then begin
      for a:=0 to 255 do begin
          pal[a,0]:=pal_gl[a,0];
          pal[a,1]:=pal_gl[a,1];
          pal[a,2]:=pal_gl[a,2];
      end;
      cala_paleta(false);
      bomba_czas:=0;
   end;

if ustaw.wsynchro then synchro;
move2(Scr^,mem[$A000:0000]);
while keypressed do readkey;
until (_wyjscie_z_gry) or (_etap_ukonczony);
fadeout(2,0,255);
end;



end.