unit vars;

interface
uses crt,mouse;

const
Old_Int = $66;

maxpoc=80;
maxwrog=50;
maxsyf=300;
maxbon=30;
maxwyb=10;
maxnap=10;
maxgwi=250;

type
Ekran=array [0..199, 0..319] of byte;
fonty_tabl=array[0..63,1..8,1..7] of byte;
gdzie_menu_typ=record
           x,sz,y:integer;
           end;
GDRHeader=record
  naglowek:array[0..3] of char;
  RX,RY:word;
  pal:array[0..255,0..2] of byte;
end;

var
GDRHead:GDRHeader;
Scr,tlo1,tlo2:^Ekran;
scr_x1,scr_x2,scr_y1,scr_y2:word;
fonty:^fonty_tabl;
ikony:array[0..8,0..63] of byte;
ikony2:array[0..1899] of byte;
Save_Int : pointer;
Kl,klw : array[0..127] of boolean;
pal,pal_gl:array[0..255,0..2] of byte;

mmx,mmy,smmx,smmy,button:Integer;
guzik,Sguzik,klik:array[1..2] of boolean;

a:integer;
plik:file;
wyr:string;
b:byte;

szybkosc_lotu,zmszybkosc_lotu:single;
tokeny,teraz_grupa, kiedy_brawo, jeszcze_bossow,etap_nr:integer;
brawo,bonus_level,
jest_mysz:boolean;


gracz:array[1..2] of record
      x,y,dx,dy:single;
      punkty:longint;
      bron,temp:array[1..6] of byte;
      wybbron,anim,oslona,rodzoslony,iladdon:byte;
      wychodzi,skonczyl:boolean;
      zycia:shortint;
      addon:array[1..5] of record
            jest:boolean;
            x,y,dx,dy:single;
            temp:byte;
            end;
      end;
poc:array[1..maxpoc] of record
    jest:boolean;
    x,y,dx,dy:single;
    rodz,czyj:byte;
    ani,szani,dozmani,ilklatek:byte;
    end;
bon:array[1..maxbon] of record
    jest:boolean;
    x,y:single;
    rodz,
    ani,dozmani,szani,ilklatek:byte;
    kani:shortint;
    end;
wyb:array[1..maxwyb] of record
    jest:boolean;
    x,y:integer;
    rodz,
    ani,dozmani,szani,ilklatek:byte;
    end;
syf:array[1..maxsyf] of record
    jest:boolean;
    x,y,dx,dy:integer;
    sx,sy:array[0..3] of integer;
    kol,rodz:byte;
    dl:shortint;
    end;
wrog:array[1..maxwrog] of record
     jest:boolean;
     x,y,dx,dy,px,py:single;
     wygl,ruch,ani,szani,dozmani,ilklatek:byte;
     kani,bonus:shortint;
     sila,nr_w_grupie,grupa,
     rez1,rez2:integer;
     end;
boss:record
     jest,ginie:boolean;
     x,y,dx,dy,px:single;
     wygl,ruch,ani,szani,dozmani,ilklatek:byte;
     kani:shortint;
     sila,maxsila,
     rez1,rez2,umiera:integer;
     end;
grupy:array[1..10] of byte;
nap:array[1..maxnap] of record
    jest:boolean;
    x,y:integer;
    rodz,
    ani,dozmani,szani,ilklatek,czas:byte;
    end;
ilwrog:integer;
ustaw:record
    il_gr,  {1 - 2}
    detale, {0 - 5}
    myszka, {0-nikt, 1,2-gracz}
    rodzmysz, {0-jak ruch, tak gracz; 1-"za strzalka"}
    smx,smy {szybkosc myszy x i y}:byte;
    klaw:array[1..2,1..6] of byte;
    wsynchro:boolean;
    end;
napis:record
    t:string[80];
    k1,k2,czas:byte;
    end;
dod:record
    strzalka:record {strzalka pokazujaca wroga idacego od tylu}
       masz:boolean;
       y,czas:integer;
       end;
    boscan:record {skaner pokazujacy energie bosa i ilosc bosow}
       masz:boolean;
       end;
    radar:record {radar}
       masz:boolean;
       end;
    end;
ostatnie_tlo:record
     rys,poprz:byte;
     poz:integer;
     end;
gwi:array[1..maxgwi] of record {3d gwiazdki w bonus-lev}
    jest:boolean;
    x,y:integer;
    kol:byte;
    end;

rekord:array[1..2,1..6] of record {1:normalna gra,2:arena, 1..6: miejsca}
       imie:string[10];
       pkt:longint;
       end;

bomba_czas:byte;

zmiana:array[1..10] of integer;
offsett:longint;
offsety:array[1..8] of longint;
      {nic - gracz
         1 - wrogowie
         2 - pociski
         3 - teren
         4 - bonus
         5 - wybuchy
         6 - logo
         7 - boss
         8 - strzalka
      }

implementation


end.