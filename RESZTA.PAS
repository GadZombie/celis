unit reszta;

interface
uses crt,vars,glowne,dos,dzwieki,xms,wave,maskp,mouse,glowngra,dat_file;

{*}PROCEDURE opcje;
{*}PROCEDURE skrol(poz:longint;offst:integer;wys:byte);
{*}PROCEDURE winieta;
{*}PROCEDURE wpis_lista_najlepszych(gracz:byte;var jimie:string);
{*}PROCEDURE lista_najlepszych(pocz:byte);
{*}PROCEDURE ustaw_liste;
{*}PROCEDURE wpisy_na_liste(ilgraczy,gra:byte);
{*}FUNCTION zapisz_konfig:boolean;
{*}PROCEDURE wczytaj_konfig;
{*}PROCEDURE znajdz_kolor(rr,gg,bb:byte;var nr:byte;od_kol:byte);
{*}PROCEDURE intro;
{*}PROCEDURE gameuower;
{*}PROCEDURE introetap;

implementation
{*}PROCEDURE opcje;
const
podp:array[1..9,1..3] of string[40]=
   (('ZMIENIA USTAWIENIA STEROWANIA GRACZA 1','STRZAlKI-WYBoR SPOSOBU STEROWANIA','ENTER-USTAWIANIE KLAWISZY'),
    ('ZMIENIA USTAWIENIA STEROWANIA GRACZA 2','STRZAlKI-WYBoR SPOSOBU STEROWANIA','ENTER-USTAWIANIE KLAWISZY'),
    ('WYBoR SPOSOBU PORUSZANIA SIe MYSZa:','1) PODOBNIE DO RUCHU KURSOREM',
                                           '2) POJAZD LECI ZA NIEWIDZIALNYM KURSOREM'),
    ('USTAWIENIE SZYBKOsCI RUCHU','MYSZY W POZIOMIE',''),
    ('USTAWIENIE SZYBKOsCI RUCHU','MYSZY W PIONIE',''),
    ('ZMIANA ILOsCI DETALI W GRZE','',''),
    ('SYNCHRONIZACJA SZYBKOsCI GRY Z','POWROTEM PLAMKI NA MONITORZE','(NA WOLNYM KOMPUTERZE MOzE ZWALNIAc GRe)'),
    ('WlaCZANIE I WYlaCZANIE DxWIeKU','',''),
    ('WYJsCIE DO MENU','(KLAWISZ ESC)',''));
var
x,y,z,px,py,
zk,zkk,zks:integer;
kol1,kol2,
wkol1,wkol2,
pk1,pk2:byte;
kll:char;
wybY,wyb,
corobi,zmkl:byte;
begin
wczytaj_pal('etap1.pal');
fadeout(255,0,255);
fillchar2(scr^,64000,0);
fillchar2(tlo1^,64000,0);
maskpicxms(108,0,52,56,0,offsety[6],@scr^);
maskpicxms(160,0,52,56,0,offsety[6]+52*56,@scr^);
move2(Scr^,mem[$A000:0000]);
fadein(2,0,255);
kol1:=77;  kol2:=75;
wybY:=1; wyb:=0;
zk:=0;zkk:=1;zks:=0;
px:=0;
py:=199;
corobi:=0;
repeat
   inc(zks);if zks>=4 then begin zks:=0;zk:=zk+zkk;end;
   if zk>=5 then zkk:=-1;
   if zk<=0 then zkk:=1;
   Wkol1:=66+zk; Wkol2:=64+zk;
   for y:=0 to 199 do begin
       x:=160-px;
       while x<=160+px do begin
          a:=20;
          if x+a>=160+px then a:=(160+px)-x;
          fillchar2(tlo1^[y,x],a,random(4)+120);
          if (y>=py-5) and (y<=py+5) then inc(x,random(2)+1)
                                     else inc(x,random(20)+1);
       end;
   end;
   if px<159 then inc(px);
   dec(py,random(8)+1);if py<0 then py:=199;
   move2(tlo1^,scr^);
   z:=0;
   if random(50)=0 then z:=random(3);
   maskpicxms(108,z,52,56,0,offsety[6],@scr^);
   maskpicxms(160,z,52,56,0,offsety[6]+52*56,@scr^);
  if corobi=0 then begin
   if keypressed then begin
      kll:=readkey;
      if kll=#0 then begin
         kll:=readkey;
         if (kll=#72) then begin
            if (wybY>1) then dec(wybY)
                        else wybY:=9;
         end;
         if (kll=#80) then begin
            if (wybY<9) then inc(wybY)
                        else wybY:=1;
         end;
         if (kll in [#75,#77]) and (wybY=1) then begin
            if ustaw.myszka=1 then ustaw.myszka:=0
                              else ustaw.myszka:=1;
         end;
         if (kll in [#75,#77]) and (wybY=2) then begin
            if ustaw.myszka=2 then ustaw.myszka:=0
                              else ustaw.myszka:=2;
         end;

         if (kll=#75) and (wybY=4) and (ustaw.smx<15) then inc(ustaw.smx);
         if (kll=#77) and (wybY=4) and (ustaw.smx>1) then dec(ustaw.smx);
         if (kll=#75) and (wybY=5) and (ustaw.smy<15) then inc(ustaw.smy);
         if (kll=#77) and (wybY=5) and (ustaw.smy>1) then dec(ustaw.smy);
         if (kll=#77) and (wybY=6) and (ustaw.detale<5) then inc(ustaw.detale);
         if (kll=#75) and (wybY=6) and (ustaw.detale>0) then dec(ustaw.detale);
      end;
      if kll in [#13,#32] then wyb:=wybY;
   end;
   if wyb=1 then begin zmkl:=1;corobi:=1;wyb:=0;repeat until (not kl[28]) and (not kl[57]);end;
   if wyb=2 then begin zmkl:=1;corobi:=2;wyb:=0;repeat until (not kl[28]) and (not kl[57]);end;
   if wyb=3 then begin wyb:=0;inc(ustaw.rodzmysz);if ustaw.rodzmysz>1 then ustaw.rodzmysz:=0;end;
   if wyb=7 then begin ustaw.wsynchro:=not ustaw.wsynchro;wyb:=0;end;
   if wyb=8 then begin jest_dzwiek:=not jest_dzwiek;wyb:=0;end;

   pisz(143,25+z,'OPCJE',38,35,0);
   if wybY=1 then begin pk1:=wkol1;pk2:=wkol2;end
             else begin pk1:=kol1;pk2:=kol2;end;
   pisz(50,60+z,'STEROWANIE 1 PILOTA:',pk1,pk2,0);
   if ustaw.myszka=1 then pisz(197,60+z,'MYSZ',pk1,pk2,0)
                     else pisz(197,60+z,'KLAWIATURA',pk1,pk2,0);
   if wybY=2 then begin pk1:=wkol1;pk2:=wkol2;end
             else begin pk1:=kol1;pk2:=kol2;end;
   pisz(50,70+z,'STEROWANIE 2 PILOTA:',pk1,pk2,0);
   if ustaw.myszka=2 then pisz(197,70+z,'MYSZ',pk1,pk2,0)
                     else pisz(197,70+z,'KLAWIATURA',pk1,pk2,0);
   if wybY=3 then begin pk1:=wkol1;pk2:=wkol2;end
             else begin pk1:=kol1;pk2:=kol2;end;
   pisz(50,80+z,'SPOSoB RUCHU MYSZa:',pk1,pk2,0);
   if ustaw.rodzmysz=0 then pisz(190,80+z,'JAK KURSOR',pk1,pk2,0)
                       else pisz(190,80+z,'ZA KURSOREM',pk1,pk2,0);
   if wybY=4 then begin pk1:=wkol1;pk2:=wkol2;end
             else begin pk1:=kol1;pk2:=kol2;end;
   pisz(50,90+z,'CZUlOsc MYSZY W POZIOMIE:',pk1,pk2,0);
   wyr:='';
   for a:=0 to 7-ustaw.smx div 2 do wyr:=wyr+'*';
   if ustaw.smx mod 2=0 then wyr:=wyr+'`';
   for a:=9-ustaw.smx div 2-(ustaw.smx mod 2) to 7 do wyr:=wyr+'^';
   pisz(232,90+z,wyr,pk1,pk2,0);
   if wybY=5 then begin pk1:=wkol1;pk2:=wkol2;end
             else begin pk1:=kol1;pk2:=kol2;end;
   pisz(50,100+z,'CZUlOsc MYSZY W PIONIE:',pk1,pk2,0);
   wyr:='';
   for a:=0 to 7-ustaw.smy div 2 do wyr:=wyr+'*';
   if ustaw.smy mod 2=0 then wyr:=wyr+'`';
   for a:=9-ustaw.smy div 2-(ustaw.smy mod 2) to 7 do wyr:=wyr+'^';
   pisz(218,100+z,wyr,pk1,pk2,0);

   if wybY=6 then begin pk1:=wkol1;pk2:=wkol2;end
             else begin pk1:=kol1;pk2:=kol2;end;
   pisz(50,110+z,'POZIOM DETALI:',pk1,pk2,0);
   pisz(220,110+z,'(F1)',pk1,pk2,0);
   wyr:='';
   for a:=0 to ustaw.detale do wyr:=wyr+'*';
   for a:=ustaw.detale to 4 do wyr:=wyr+'^';
   pisz(154,110+z,wyr,pk1,pk2,0);
   if wybY=7 then begin pk1:=wkol1;pk2:=wkol2;end
             else begin pk1:=kol1;pk2:=kol2;end;
   pisz(50,120+z,'SYNCHRO:',pk1,pk2,0);
   pisz(220,120+z,'(F2)',pk1,pk2,0);
   if ustaw.wsynchro then pisz(112,120+z,'WlaCZONE',pk1,pk2,0)
                     else pisz(112,120+z,'WYlaCZONE',pk1,pk2,0);
   if wybY=8 then begin pk1:=wkol1;pk2:=wkol2;end
             else begin pk1:=kol1;pk2:=kol2;end;
   pisz(50,130+z,'DxWIeK:',pk1,pk2,0);
   pisz(220,130+z,'(F3)',pk1,pk2,0);
   if jest_dzwiek then pisz(104,130+z,'WlaCZONY',pk1,pk2,0)
                  else pisz(104,130+z,'WYlaCZONY',pk1,pk2,0);
   if wybY=9 then begin pk1:=wkol1;pk2:=wkol2;end
             else begin pk1:=kol1;pk2:=kol2;end;
   pisz(50,140+z,'WRoc',pk1,pk2,0);

   piszc(160,160+z,podp[wybY,1],61,59,0);
   piszc(160,170+z,podp[wybY,2],61,59,0);
   piszc(160,180+z,podp[wybY,3],61,59,0);
  end
  else begin
   piszc(160,25+z,'STEROWANIE '+l2t(corobi,1)+' PILOTA',38,35,0);
   piszc(160,80+z,'WCIsNIJ WYBRANY KLAWISZ',kol1,kol2,0);
   case zmkl of
      1:piszc(160,96+z,'PRAWO',wkol1,wkol2,0);
      2:piszc(160,96+z,'Dol',wkol1,wkol2,0);
      3:piszc(160,96+z,'LEWO',wkol1,wkol2,0);
      4:piszc(160,96+z,'GoRA',wkol1,wkol2,0);
      5:piszc(160,96+z,'STRZAl',wkol1,wkol2,0);
      6:piszc(160,96+z,'ZMIANA BRONI',wkol1,wkol2,0);
   end;
   b:=port[$60];
   if b<$80 then begin ustaw.klaw[corobi,zmkl]:=b;repeat until not kl[ustaw.klaw[corobi,zmkl]];inc(zmkl);end;
   if zmkl>=7 then corobi:=0;
   while keypressed do readkey;
  end;


   y:=random(195);x:=random(5)-2;z:=random(3);
   for a:=0 to z do move(scr^[y+a,0],scr^[y+a,x],320);
   if ustaw.wsynchro then synchro;
   move2(Scr^,mem[$A000:0000]);
until (kll=#27) or (wyb=9);

{wyjscie z opcji}
if not jest_mysz then ustaw.myszka:=0;
x:=0;
repeat
   for a:=0 to 9 do ebar(x+a,x div 2+a,319-x-a,199-(x div 2)-a,0);
   inc(x,10);
   if ustaw.wsynchro then synchro;
   move2(Scr^,mem[$A000:0000]);
until x>=160;

putpix(160,100,7);
putpix(161,100,4);
putpix(159,100,4);
putpix(160, 99,4);
putpix(160,101,4);
move2(Scr^,mem[$A000:0000]);
fadeout(1,0,255);
fillchar2(scr^,64000,0);
end;

{*}PROCEDURE skrol(poz:longint;offst:integer;wys:byte);
var buff:string[55];
begin
XMS2Mem(_xms[1].h,offsett+poz,buff[1],50);
buff[0]:=#50;
pisz(0-offst,wys,buff,198,149,0);
end;

{*}PROCEDURE winieta;
var
kll:char;
kol1,kol2,
wkol1,wkol2,
wybor,sky,skx:byte;
l,skpoz,sko:longint;
begin
fadeout(255,0,255);
while keypressed do readkey;
datAssign (plik,'celis.dat','winieta.gdr',0);
filemode:=0;

fillchar2(scr^,64000,0);
blockread(plik,GDRHead,sizeof(GDRHead));

for a:=0 to 255 do begin
    pal_gl[a,0]:=GDRHead.pal[a,0];
    pal_gl[a,1]:=GDRHead.pal[a,1];
    pal_gl[a,2]:=GDRHead.pal[a,2];
end;
for a:=0 to GDRHead.RY-1 do begin
    blockread(plik,tlo1^[a],GDRHead.RX);
end;
close(plik);
if not _byla_winieta then begin
   fadein(255,0,255);
   for a:=0 to 99 do begin
    move3(tlo1^[a*2],scr^[a*2],320);
    move3(tlo1^[199-a*2],scr^[199-a*2],320);
    move2(scr^,mem[$A000:0000]);
    if ustaw.wsynchro then synchro;
    while keypressed do readkey;
   end;
end else begin
    move2(tlo1^,scr^);
    move2(scr^,mem[$A000:0000]);
    fadein(2,0,255);
end;
while keypressed do readkey;

 kol1:=33;  kol2:=25;
wkol1:=245;wkol2:=249;
l:=-2147483646;
wybor:=0;
skpoz:=0;sko:=0;skx:=0;
if not _byla_winieta then sky:=96 else sky:=190;
graj_dzwiek(voicedata[8],0.8,0);
repeat
   if keypressed then begin
      kll:=readkey;
      if kll=#0 then begin
         kll:=readkey;
         if (kll=#72) then begin
            if (wyborY>1) then dec(wyborY)
                          else wyborY:=7;
         end;
         if (kll=#80) then begin
            if (wyborY<7) then inc(wyborY)
                          else wyborY:=1;
         end;
         if (kll=#68) then _wyjscie:=true;
      end;
      if (_byla_winieta) and (kll in [#13,#32]) then wybor:=wyborY;
      _byla_winieta:=true;
   end;
   inc(l);
   move2(tlo1^,scr^);
   piszc(160,170,'DIMOU WERSZYN'{'WERSJA DEMONSTRACYJNA'},251,250,0);
   inc(sko);
   if sko>=7 then begin
      sko:=0;
      inc(skpoz);
      if skpoz>=1080 then skpoz:=0;
   end;
   scr_x1:=skx;
   scr_x2:=319-skx;
   skrol(skpoz,sko,sky);
   scr_x1:=0;
   scr_x2:=319;

  if _byla_winieta then begin
   if sky<190 then inc(sky);
   if skx<30 then inc(skx);
   for a:=ustaw.detale downto 0 do begin
       if a=0 then
          piszc(160+trunc(cos(l/40-a/2)*20),30-trunc(cos(l/25-a/2)*5),'MENU',221,201,0)
       else
          piszc(160+trunc(cos(l/40-a/2)*20),30-trunc(cos(l/25-a/2)*5),'MENU',217,190,0);
   end;
   if wyborY=1 then piszc(160+trunc(cos(  l/15)*6), 50+trunc(sin(  l/15)*6),'ZWYKlA GRA - 1 PILOT',wkol1,wkol2,0)
               else piszc(160, 50+trunc(sin(l/15)*3),  'ZWYKlA GRA - 1 PILOT',kol1,kol2,0);
   if wyborY=2 then piszc(160+trunc(cos(1+l/15)*6), 66+trunc(sin(1+l/15)*6),'ZWYKlA GRA - 2 PILOToW',wkol1,wkol2,0)
               else piszc(160, 66+trunc(sin(1+l/15)*3),'ZWYKlA GRA - 2 PILOToW',kol1,kol2,0);
   if wyborY=3 then piszc(160+trunc(cos(2+l/15)*6), 82+trunc(sin(2+l/15)*6),'ARENA - 1 PILOT',wkol1,wkol2,0)
               else piszc(160, 82+trunc(sin(2+l/15)*3),'ARENA - 1 PILOT',kol1,kol2,0);
   if wyborY=4 then piszc(160+trunc(cos(3+l/15)*6), 98+trunc(sin(3+l/15)*6),'ARENA - 2 PILOToW',wkol1,wkol2,0)
               else piszc(160, 98+trunc(sin(3+l/15)*3),'ARENA - 2 PILOToW',kol1,kol2,0);
   if wyborY=5 then piszc(160+trunc(cos(4+l/15)*6),114+trunc(sin(4+l/15)*6),'LISTA NAJLEPSZYCH',wkol1,wkol2,0)
               else piszc(160,114+trunc(sin(4+l/15)*3),'LISTA NAJLEPSZYCH',kol1,kol2,0);
   if wyborY=6 then piszc(160+trunc(cos(5+l/15)*6),130+trunc(sin(5+l/15)*6),'USTAWIENIA GRY',wkol1,wkol2,0)
               else piszc(160,130+trunc(sin(5+l/15)*3),'USTAWIENIA GRY',kol1,kol2,0);
   if wyborY=7 then piszc(160+trunc(cos(6+l/15)*6),146+trunc(sin(6+l/15)*6),'WYJsCIE DO SYSTEMU',wkol1,wkol2,0)
               else piszc(160,146+trunc(sin(6+l/15)*3),'WYJsCIE DO SYSTEMU',kol1,kol2,0);
  end;

   if ustaw.wsynchro then synchro;
   move2(scr^,mem[$A000:0000]);
until (wybor>0) or (_wyjscie);
case wybor of
   3:_graA1:=true;
   4:_graA2:=true;
   5:_rekordy:=true;
   6:_opcje:=true;
   7:_wyjscie:=true;
end;
_byla_winieta:=true;
fadeout(3,0,255);
fillchar2(mem[$A000:0],64000,0);
end;

{*}PROCEDURE wpis_lista_najlepszych(gracz:byte;var jimie:string);
var
kol1,kol2,
wkol1,wkol2,mig:byte;
kll:char;
wimie:string[10];
wyjdz:boolean;
l:longint;
begin
fadeout(255,0,255);
while keypressed do readkey;
datAssign (plik,'celis.dat','rekordy.gdr',0);
filemode:=0;

fillchar2(scr^,64000,0);
blockread(plik,GDRHead,sizeof(GDRHead));

for a:=0 to 255 do begin
    pal_gl[a,0]:=GDRHead.pal[a,0];
    pal_gl[a,1]:=GDRHead.pal[a,1];
    pal_gl[a,2]:=GDRHead.pal[a,2];
end;
for a:=0 to GDRHead.RY-1 do begin
    blockread(plik,tlo1^[a],GDRHead.RX);
end;
close(plik);
move2(tlo1^,scr^);
move2(scr^,mem[$A000:0000]);
fadein(2,0,255);
while keypressed do readkey;

kol1:=180; kol2:=150;
kll:=#255;
wimie:='';
wyjdz:=false;
l:=2147483646;
mig:=0;
repeat
   dec(l);
   if keypressed then begin
      mig:=3;
      kll:=readkey;
      if length(wimie)<10 then begin
         if (kll in [#65..#90]) and (not kl[54]) and (not kl[42]) then wimie:=wimie+kll;
         if (kll in [#65,#67,#69,#76,#78,#79,#83,#88,#90]) and ((kl[54]) or (kl[42])) then wimie:=wimie+chr(ord(kll)+32);
         if (kll in [#97,#99,#101,#108,#110,#111,#115,#120,#122]) and ((kl[54]) or (kl[42])) then wimie:=wimie+kll;
         if (kll in [#97..#122]) and (not kl[54]) and (not kl[42]) then wimie:=wimie+chr(ord(kll)-32);
         if kll in [#32,#39..#57,#37,#33,#34,#64] then wimie:=wimie+kll;
      end;
      if (kll=#8) and (length(wimie)>0) then delete(wimie,length(wimie),1);
      if kll in [#13] then wyjdz:=true;
      if kll=#0 then kll:=readkey;
   end;
   move2(tlo1^,scr^);

   if mig=0 then begin wkol1:=31;wkol2:=60;end
      else begin
      wkol1:=253;wkol2:=250;
      dec(mig);
   end;
   piszc(160+trunc(cos(  l/15)*5),60+trunc(sin(  l/15)*5),'PILOT '+l2t(gracz,1),kol1,kol2,0);
   piszc(160+trunc(cos(0.5+l/15)*5),70+trunc(sin(0.5+l/15)*5),'WPISZ SWOJE IMIe',164,150,0);
   for a:=1 to length(wimie) do
       pisz(115+a*8+trunc(sin(a/2+l/13)*4),
            96+trunc(cos(a/2+l/13)*4),
            wimie[a],wkol1,wkol2,0);

   if ustaw.wsynchro then synchro;
   move2(scr^,mem[$A000:0000]);
until wyjdz;
fadeout(2,0,255);
fillchar2(mem[$A000:0],64000,0);
jimie:=wimie;
end;

{*}PROCEDURE lista_najlepszych(pocz:byte);
const
cien1:array[1..2,1..6] of byte=
      ((200,196,221,204,217,186),
       (217,186,216,215,212,214));
var
kol1,kol2,
wkol1,wkol2,
ktore,corobi:byte;
wyjdz,dalej:boolean;
l:longint;
kll:char;
czas:integer;
ruch:array[1..6] of integer;
begin
fadeout(255,0,255);
while keypressed do readkey;
datAssign (plik,'celis.dat','rekordy.gdr',0);
filemode:=0;

fillchar2(scr^,64000,0);
blockread(plik,GDRHead,sizeof(GDRHead));

for a:=0 to 255 do begin
    pal_gl[a,0]:=GDRHead.pal[a,0];
    pal_gl[a,1]:=GDRHead.pal[a,1];
    pal_gl[a,2]:=GDRHead.pal[a,2];
end;
for a:=0 to GDRHead.RY-1 do begin
    blockread(plik,tlo1^[a],GDRHead.RX);
end;
close(plik);
move2(tlo1^,scr^);
move2(scr^,mem[$A000:0000]);
fadein(2,0,255);
while keypressed do readkey;

kol1:=180; kol2:=150;
l:=-2147483646;
kll:=#255;
wyjdz:=false;
ktore:=pocz;
czas:=0;
corobi:=1; {0-stoi, 1-wjezdza, 2-wyjezdza}
for a:=1 to 6 do ruch[a]:=150;
repeat
   dalej:=false;
   if keypressed then begin
      kll:=readkey;
      if kll=#27 then wyjdz:=true;
      if kll in [#13,#32] then dalej:=true;
      if kll=#0 then kll:=readkey;
   end;
   inc(l);
   move2(tlo1^,scr^);

   case ktore of
      1:piszc(160,20-ruch[5] div 5,'ZWYKlA GRA',kol1,kol2,0);
      2:piszc(160,20-ruch[5] div 5,'ARENA',kol1,kol2,0);
   end;
   for a:=1 to 6 do begin
       wkol1:=cien1[1,a];
       wkol2:=cien1[2,a];
       if abs((l div 2) mod 40)=a then begin
          wkol1:=kol1;
          wkol2:=kol2;
       end;
       pisz(70+trunc(cos(a+l/15)*5)-ruch[a],50+a*13+ruch[a],rekord[ktore,a].imie,wkol1,wkol2,0);
       pisz(196-trunc(cos(a+l/15)*5)+ruch[a],50+a*13+ruch[a],l2t(rekord[ktore,a].pkt,7),wkol1,wkol2,0);
   end;
   case corobi of
    0:begin {stoi}
      if dalej then czas:=400;
      inc(czas);
      if czas>=400 then corobi:=2;
      end;
    1:begin {wjezdza}
      for a:=1 to 6 do begin
          if ((a=1) or (ruch[a-1]<=120)) and (ruch[a]>0) then dec(ruch[a],3);
      end;
      if ruch[6]<=0 then begin
         for a:=1 to 6 do ruch[a]:=0;
         corobi:=0;
      end;
      end;
    2:begin {wyjezdza}
      for a:=1 to 6 do begin
          if ((a=6) or (ruch[a+1]>=30)) and (ruch[a]<150) then inc(ruch[a],3);
      end;
      if ruch[1]>=150 then begin
         for a:=1 to 6 do ruch[a]:=150;
         corobi:=1;
         czas:=0;
         inc(ktore);
         if ktore>=3 then ktore:=1;
      end;
      end;
   end;

   if ustaw.wsynchro then synchro;
   move2(scr^,mem[$A000:0000]);
until wyjdz;
fadeout(2,0,255);
fillchar2(mem[$A000:0],64000,0);
end;

{*}PROCEDURE ustaw_liste;
var a,gg:byte;
juz:boolean;
s:string[10];
p:longint;
begin
for gg:=1 to 2 do
  repeat
  juz:=true;
  for a:=1 to 5 do begin
    if rekord[gg,a].pkt<rekord[gg,a+1].pkt then begin
       s:=rekord[gg,a].imie;
       p:=rekord[gg,a].pkt;
       rekord[gg,a].imie:=rekord[gg,a+1].imie;
       rekord[gg,a].pkt:=rekord[gg,a+1].pkt;
       rekord[gg,a+1].imie:=s;
       rekord[gg,a+1].pkt:=p;
       juz:=false;
    end;
  end;
  until juz;
end;

{*}PROCEDURE wpisy_na_liste(ilgraczy,gra:byte);
var jimie:string;
pok:boolean;
begin
pok:=false;
if (ilgraczy=1) and (gracz[1].punkty>rekord[gra,6].pkt) then begin
   wpis_lista_najlepszych(1,jimie);
   rekord[gra,6].imie:=jimie;
   rekord[gra,6].pkt:=gracz[1].punkty;
   ustaw_liste;
   pok:=true;
end;
if (ilgraczy=2) then begin
   if (gracz[1].punkty>=gracz[2].punkty) and (gracz[1].punkty>rekord[gra,6].pkt) then begin
      wpis_lista_najlepszych(1,jimie);
      rekord[gra,6].imie:=jimie;
      rekord[gra,6].pkt:=gracz[1].punkty;
      ustaw_liste;
      if (gracz[2].punkty>rekord[gra,6].pkt) then begin
         wpis_lista_najlepszych(2,jimie);
         rekord[gra,6].imie:=jimie;
         rekord[gra,6].pkt:=gracz[2].punkty;
         ustaw_liste;
      end;
      pok:=true;
   end;
   if (gracz[1].punkty<gracz[2].punkty) and (gracz[2].punkty>rekord[gra,6].pkt) then begin
      wpis_lista_najlepszych(2,jimie);
      rekord[gra,6].imie:=jimie;
      rekord[gra,6].pkt:=gracz[2].punkty;
      ustaw_liste;
      if (gracz[1].punkty>rekord[gra,6].pkt) then begin
         wpis_lista_najlepszych(1,jimie);
         rekord[gra,6].imie:=jimie;
         rekord[gra,6].pkt:=gracz[1].punkty;
         ustaw_liste;
      end;
      pok:=true;
   end;
end;
ustaw_liste;
if pok then lista_najlepszych(gra);
end;

{*}FUNCTION zapisz_konfig:boolean;
begin
zapisz_konfig:=false;
assign(plik,'celis.cfg');
a:=IOResult;
{$I-}
rewrite(plik,1);
blockwrite(plik,ustaw,sizeof(ustaw));
blockwrite(plik,jest_dzwiek,1);
blockwrite(plik,rekord,sizeof(rekord));
close(plik);
if IOResult=0 then zapisz_konfig:=true;
end;

{*}PROCEDURE wczytaj_konfig;
begin
with ustaw do begin
     wsynchro:=true;
     detale:=3;
     {gracz 1}
     klaw[1,1]:= 77;        {prawo}
     klaw[1,2]:= 80;        {dol}
     klaw[1,3]:= 75;        {lewo}
     klaw[1,4]:= 72;        {gora}
     klaw[1,5]:= 29;        {strzal}
     klaw[1,6]:= 56;        {zm.broni}
     {gracz 2}
     klaw[2,1]:= 32;        {prawo}
     klaw[2,2]:= 31;        {dol}
     klaw[2,3]:= 30;        {lewo}
     klaw[2,4]:= 17;        {gora}
     klaw[2,5]:= 15;        {strzal}
     klaw[2,6]:= 41;        {zm.broni}
     myszka:=1;
     smx:=5;
     smy:=5;
     rodzmysz:=0;
end;
for a:=1 to 6 do  {normalna}
    with rekord[1,a] do begin
         imie:='GAD'+l2t(a,1);
         pkt:=7000-a*900;
    end;
for a:=1 to 6 do  {arena}
    with rekord[2,a] do begin
         imie:='GAD '+l2t(a,1);
         pkt:=20000-a*1800;
    end;
jest_dzwiek:=true;

assign(plik,'celis.cfg');
{$I-}
reset(plik,1);
if ioresult=0 then begin
   blockread(plik,ustaw,sizeof(ustaw));
   blockread(plik,jest_dzwiek,1);
   blockread(plik,rekord,sizeof(rekord));
   close(plik);
end;
{$I+}
end;

{*}PROCEDURE znajdz_kolor(rr,gg,bb:byte;var nr:byte;od_kol:byte);
var a:byte;roznica,pom:word;
begin
roznica:=50000; {jakas duza wartosc}
for a:=od_kol to 255 do begin
    pom:=abs(pal[a,0]-rr) + abs(pal[a,1]-gg) + abs(pal[a,2]-bb);
    if pom<roznica then begin
       roznica:=pom;
       nr:=a;
       if roznica=0 then a:=255;
    end;{if}
end;{for}
end;{procedure}

{*}PROCEDURE intro;
var
zm:boolean;
l:longint;
pal_zm:array [0..255] of byte;
begin
fadeout(255,0,255);
while keypressed do readkey;
wczytaj_pal('etap1.pal');
fillchar2(scr^,64000,0);
for a:=1 to maxgwi do
    with gwi[a] do begin
       jest:=true;
       x:=random(320*64);
       y:=random(200*64);
       kol:=1+random(6);
       putpix(x shr 6,y shr 6,kol);
    end;

move2(scr^,mem[$A000:0000]);
fadein(1,0,255);
graj_dzwiek(voicedata[8],1,0);

for a:=199 downto 0 do begin
    if keypressed then a:=0;

    fillchar2(scr^,64000,0);
for b:=1 to maxgwi do
    if gwi[b].jest then
       with gwi[b] do begin
          y:=y+trunc((kol/8)*64);
          if y>12736 then jest:=false;
          putpix(x shr 6,y shr 6,kol);
       end
       else
          if random(10)=0 then with gwi[b] do begin
             jest:=true;
             x:=random(20416){320*64};
             y:=0{200*64};
             kol:=1+random(6)
          end;

    piszc(160,110-a,'GRZEGORZ "GAD" DROZD',62,58,0);
    piszc(160, 90-a,'E GREJT GEJM BAJ',93,90,0);
    if ustaw.wsynchro then synchro;
    move2(scr^,mem[$A000:0000]);
end;
    while keypressed do readkey;
graj_dzwiek(voicedata[10],1.3,0);
for b:=0 to 63 do begin
    for a:=0 to 255 do begin
        pal[a,0]:=pal_gl[a,0]+trunc(b/(pal_gl[a,0]/63+1));if pal[a,0]>63 then pal[a,0]:=63;
        pal[a,1]:=pal_gl[a,1]+trunc(b/(pal_gl[a,1]/63+1));if pal[a,1]>63 then pal[a,1]:=63;
        pal[a,2]:=pal_gl[a,2]+trunc(b/(pal_gl[a,2]/63+1));if pal[a,2]>63 then pal[a,2]:=63;
    end;
    cala_paleta(true);
    while keypressed do readkey;
end;

datAssign (plik,'celis.dat','gadlogo.gdr',0);
filemode:=0;

fillchar2(scr^,64000,0);
blockread(plik,GDRHead,sizeof(GDRHead));

for a:=0 to 255 do begin
    pal_gl[a,0]:=GDRHead.pal[a,0];
    pal_gl[a,1]:=GDRHead.pal[a,1];
    pal_gl[a,2]:=GDRHead.pal[a,2];
end;
for a:=0 to GDRHead.RY-1 do begin
    blockread(plik,tlo1^[a],GDRHead.RX);
end;
close(plik);
move2(tlo1^,scr^);
move2(scr^,mem[$A000:0000]);
fadein2(0,255,1,0,false);
graj_dzwiek(voicedata[9],1,0);
    while keypressed do readkey;

l:=0;
repeat
   inc(l);
   synchro;
until (keypressed) or (l>=40000);

move2(tlo1^,tlo2^);
    while keypressed do readkey;

{zwijanie}
for a:=0 to 255 do
    znajdz_kolor(pal_gl[a,0] div 2,pal_gl[a,1] div 2,pal_gl[a,2] div 2,pal_zm[a],0);
for b:=0 to 199 do
    for a:=0 to 319 do
        tlo2^[b,a]:=pal_zm[tlo2^[b,a]];

for a:=0 to 250 do begin
    if keypressed then a:=250;
    for b:=a div 6 downto 0 do
        if (a+a div 6-b<=199) and (a+a div 6-b>=0) then
           move3(tlo1^[a+b],scr^[a+a div 6-b],320);

    if (a>=0) and (a<=199) then move3(tlo2^[a],scr^[a],320);
    {-}
    for b:=(a-50) div 6 downto 0 do
        if (a-50+(a-50) div 6-b<=199) and (a-50+(a-50) div 6-b>=0) then
           move3(tlo2^[a+b-50],scr^[a-50+(a-50) div 6-b],320);

    move2(scr^,mem[$A000:0000]);
    if (a-50>=0) and (a-50<=199) then fillchar2(scr^[a-50],320,0);

    if ustaw.wsynchro then synchro;
end;
    while keypressed do readkey;

{E zwijanie}
fadeout(255,0,255);
fillchar2(scr^,64000,0);
graj_dzwiek(voicedata[10],0.7,0);
piszc(160,96,'PREZENTUJE',7,4,0);
move2(scr^,mem[$A000:0000]);
wczytaj_pal('etap1.pal');
fadein(2,0,255);
fadeout(2,0,255);
fillchar2(mem[$a000:0],64000,0);
end;

{*}PROCEDURE gameuower;
var
zm:boolean;
l:longint;
begin
fadeout(255,0,255);
datAssign (plik,'celis.dat','ryskonic.gdr',0);
filemode:=0;

fillchar2(scr^,64000,0);
blockread(plik,GDRHead,sizeof(GDRHead));

for a:=0 to 255 do begin
    pal_gl[a,0]:=GDRHead.pal[a,0];
    pal_gl[a,1]:=GDRHead.pal[a,1];
    pal_gl[a,2]:=GDRHead.pal[a,2];
end;
for a:=0 to GDRHead.RY-1 do begin
    blockread(plik,tlo1^[a],GDRHead.RX);
end;
close(plik);
move3(pal_gl,pal,sizeof(pal));
cala_paleta(false);

{rozwijanie}
for a:=0 to 199 do begin
    for b:=(199-a) div 6 downto 0 do
        if (a+(199-a) div 6-b<=199) and (a+(199-a) div 6-b>=0) then
           move3(tlo1^[a+b],scr^[a+(199-a) div 6-b],320);

    if (a>=0) and (a<=199) then move3(tlo1^[a],scr^[a],320);
    move2(scr^,mem[$A000:0000]);
    if ustaw.wsynchro then synchro;
    if keypressed then begin move2(tlo1^,scr^);a:=199;end;
end;
{E rozwijanie}

l:=0;
while keypressed do readkey;
move2(scr^,mem[$A000:0000]);

graj_dzwiek(voicedata[9],1.2,0);
repeat
   inc(l);
   synchro;
until (keypressed) or (l>=30000);
while keypressed do readkey;

{zwijanie}
for a:=0 to 199 do begin
    for b:=a div 6 downto 0 do
        if (a+a div 6-b<=199) and (a+a div 6-b>=0) then
           move3(tlo1^[a+b],scr^[a+a div 6-b],320);
    move2(scr^,mem[$A000:0000]);
    fillchar2(scr^[a],320,0);
    if ustaw.wsynchro then synchro;
    if keypressed then begin fillchar2(scr^,64000,0);a:=199;end;
end;
{E zwijanie}
move2(scr^,mem[$A000:0000]);

fillchar2(mem[$a000:0],64000,0);
end;

{*}PROCEDURE introetap;
var
czas:integer;
begin
fadeout(255,0,255);
while keypressed do readkey;
datAssign (plik,'celis.dat','rysetap.gdr',0);
filemode:=0;

fillchar2(scr^,64000,0);
blockread(plik,GDRHead,sizeof(GDRHead));

for a:=0 to 255 do begin
    pal_gl[a,0]:=GDRHead.pal[a,0];
    pal_gl[a,1]:=GDRHead.pal[a,1];
    pal_gl[a,2]:=GDRHead.pal[a,2];
end;
for a:=0 to GDRHead.RY-1 do begin
    blockread(plik,tlo1^[a],GDRHead.RX);
end;
close(plik);
move2(tlo1^,scr^);

if _gra_arena then wyr:='ARENA'
              else wyr:='ZWYKlA GRA';
piszc(160,80,wyr,213,209,0);
if ustaw.il_gr=1 then wyr:='JEDEN PILOT'
                 else wyr:='DWoCH PILOToW';
piszc(160,96,wyr,225,221,0);
if etap_nr mod 2=0 then piszc(160,112,'ETAP BONUSOWY',223,234,0)
                   else piszc(160,112,'ETAP '+l2t(etap_nr div 2+1,2),223,234,0);

if not gracz[1].skonczyl then piszc(50,110,l2t(gracz[1].punkty,8),65,51,0)
                         else piszc(50,110,'KONIEC GRY',65,51,0);
if ustaw.il_gr=2 then begin
   if (not gracz[2].skonczyl) then piszc(270,110,l2t(gracz[2].punkty,8),160,149,0)
                              else piszc(270,110,'KONIEC GRY',160,149,0);
end;


move2(scr^,mem[$A000:0000]);
graj_dzwiek(voicedata[13],1,0);
b:=1;
while b<63 do begin
    for a:=0 to 255 do begin
        pal[a,0]:=trunc(pal_gl[a,0]*3*(b/64));if pal[a,0]>63 then pal[a,0]:=63;
        pal[a,1]:=trunc(pal_gl[a,1]*3*(b/64));if pal[a,1]>63 then pal[a,1]:=63;
        pal[a,2]:=trunc(pal_gl[a,2]*3*(b/64));if pal[a,2]>63 then pal[a,2]:=63;
    end;
    cala_paleta(true);
    while keypressed do readkey;
    inc(b,10);
end;

for b:=60 downto 20 do begin
    for a:=0 to 255 do begin
        pal[a,0]:=trunc(pal_gl[a,0]*(b/20));if pal[a,0]>63 then pal[a,0]:=63;
        pal[a,1]:=trunc(pal_gl[a,1]*(b/20));if pal[a,1]>63 then pal[a,1]:=63;
        pal[a,2]:=trunc(pal_gl[a,2]*(b/20));if pal[a,2]>63 then pal[a,2]:=63;
    end;
    cala_paleta(true);
    while keypressed do readkey;
end;

while keypressed do readkey;
czas:=0;
repeat
   inc(czas);
   synchro;
   move2(scr^,mem[$A000:0000]);
until (czas>=140) or (keypressed);
fadeout(2,0,255);
fillchar2(mem[$A000:0],64000,0);

wczytaj_pal('etap1.pal');
while keypressed do readkey;
end;



end.