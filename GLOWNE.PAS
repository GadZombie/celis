unit glowne;
{$G+}
interface
uses crt,vars,maskp,xms,dat_file;

{*}PROCEDURE trybgraf;
{*}PROCEDURE trybtext;
{*}PROCEDURE Putpix(x, y : word; Kolor : byte);
{*}FUNCTION Getpix(x, y : word):byte;
{*}PROCEDURE Putpixt(x, y : word; Kolor : byte);
{*}FUNCTION Getpixt(x, y : word):byte;
{*}PROCEDURE DrawLine (x1, y1, x2, y2 : Integer; c : Byte);
{*}PROCEDURE bar(x1,y1,x2,y2:word;kolor:byte);
{*}PROCEDURE Ebar(x1,y1,x2,y2:word;kolor:byte);
{*}PROCEDURE pisz(xobr,yobr:integer;tekst:string;kolor1,kolor2:integer;tlo:byte);
{*}PROCEDURE piszc(xobr,yobr:integer;tekst:string;kolor1,kolor2:integer;tlo:byte);
{*}PROCEDURE wczytaj_fonty;
{*}PROCEDURE Get_Keyb_Int;interrupt;
{*}PROCEDURE cala_paleta(z_czekaniem:boolean);
{*}PROCEDURE Fadein(szybkosc,_od,_do:byte);
{*}PROCEDURE Fadeout(szybkosc,_od,_do:byte);
{*}PROCEDURE Fadeout2(r,g,b,sz,szybkosc:byte);
{*}PROCEDURE Fadein2(_od,_do,szybkosc,szyb:byte;zerowanie:boolean);
{*}PROCEDURE wczytaj_pal(nazwa:string);
{*}PROCEDURE FillChar2(var X; Count: Word; Value:Byte);
{*}PROCEDURE move2(var Source,Dest);
{*}PROCEDURE Move3(var source, dest; count: word);
{*}PROCEDURE move5(var Source,Dest);
{*}PROCEDURE synchro;
{*}FUNCTION l2t(liczba:longint;ilosc_lit:byte):string;
{*}PROCEDURE obrazki;

implementation

{*}PROCEDURE trybgraf;
begin
asm
  mov ax, $13
  int $10
end;
end;

{*}PROCEDURE trybtext;
begin
asm
  mov ax, $3
  int $10
end;
end;

{*}PROCEDURE Putpix(x, y : word; Kolor : byte);
begin
  if (x>=scr_x1) and (x<=scr_x2) and (y>=scr_y1) and (y<=scr_y2) then Scr^[y,x]:=Kolor;;
end;

{*}FUNCTION Getpix(x, y : word):byte;
begin
  if (x>=scr_x1) and (x<=scr_x2) and (y>=scr_y1) and (y<=scr_y2) then getpix:=Scr^[y,x]
     else getpix:=0;
end;

{*}PROCEDURE Putpixt(x, y : word; Kolor : byte);
begin
  if (x>=scr_x1) and (x<=scr_x2) and (y>=scr_y1) and (y<=scr_y2) then tlo1^[y,x]:=Kolor;;
end;

{*}FUNCTION Getpixt(x, y : word):byte;
begin
  if (x>=scr_x1) and (x<=scr_x2) and (y>=scr_y1) and (y<=scr_y2) then getpixt:=tlo1^[y,x]
     else getpixt:=0;
end;

{*}PROCEDURE DrawLine (x1, y1, x2, y2 : Integer; c : Byte);
var
  DeltaX, DeltaY, NumPixels, Counter,
  D, Dinc1, Dinc2,
  X, Xinc1, Xinc2,
  Y, Yinc1, Yinc2 : Integer;

begin
  DeltaX := abs (x2 - x1);
  DeltaY := abs (y2 - y1);
  if (DeltaX >= DeltaY) then begin
    NumPixels := Deltax + 1;
    D := (DeltaY shl 1) - DeltaX;
    Dinc1 := DeltaY shl 1;
    Dinc2 := (DeltaY - DeltaX) shl 1;
    Xinc1 := 1;
    Xinc2 := 1;
    Yinc1 := 0;
    Yinc2 := 1;
  end else begin
    NumPixels := DeltaY + 1;
    D := (DeltaX shl 1) - DeltaY;
    Dinc1 := DeltaX shl 1;
    Dinc2 := (DeltaX - DeltaY) shl 1;
    Xinc1 := 0;
    Xinc2 := 1;
    Yinc1 := 1;
    Yinc2 := 1;
  end;
  if x1 > x2 then begin
    Xinc1 := -Xinc1;
    Xinc2 := -Xinc2;
  end;
  if y1 > y2 then begin
    Yinc1 := -Yinc1;
    Yinc2 := -Yinc2;
  end;
  X := x1;
  Y := y1;
  for Counter := 1 to NumPixels do begin
    PutPix (X, Y, c);
    if (D < 0) then begin
      inc (D, Dinc1);
      inc (X, Xinc1);
      inc (Y, Yinc1);
    end else begin
      inc (D, Dinc2);
      inc (X, Xinc2);
      inc (Y, Yinc2);
    end;
  end;
end;

{*}PROCEDURE bar(x1,y1,x2,y2:word;kolor:byte);
var
  y : word;
begin
  for y := y1 to y2 do FillChar(Scr^[y, x1], x2-x1+1, kolor);
end;

{*}PROCEDURE Ebar(x1,y1,x2,y2:word;kolor:byte);
begin
  drawline(x1,y1,x1,y2,kolor);
  drawline(x2,y1,x2,y2,kolor);
  FillChar(Scr^[y1, x1], x2-x1+1, kolor);
  FillChar(Scr^[y2, x1], x2-x1+1, kolor);
end;

{*}PROCEDURE MaskPic3(X,Y,Width,Height:integer; Maskcolor,color1,color2:byte; var Sprite,Dest);
Begin
  If (x <= -width) or (x >= 320) or (y <= -height) or (y >= 200) then exit;
Asm
   PUSH  DS
   LDS   SI,Sprite
   LES   DI,DEST
   MOV   AX,WIDTH
   MOV   DX,AX
   PUSH  DX
   ADD   AX,X
   PUSH  Width
   CMP   AX,320
   JG    @RightCut
   SUB   AX,X
   JC    @LeftCut
   JMP   @CheckBottom
 @RightCut:
   SUB   AX,Width
   SUB   AX,320
   NEG   AX
   MOV   Width,AX
   JMP   @CheckBottom
 @LeftCut:
   ADD   AX,X
   MOV   Width,AX
   SUB   DX,AX
   ADD   SI,DX
   XOR   BX,BX
   MOV   X,BX
 @CheckBottom:
   MOV   AX,Height
   ADD   AX,Y
   CMP   AX,200
   JG    @BottomCut
   SUB   AX,Y
   JC    @TopCut
   POP   BX
   JMP   @Display
 @BottomCut:
   POP   BX
   SUB   AX,Height
   SUB   AX,200
   NEG   AX
   MOV   Height,AX
   JMP   @Display
 @TopCut:
  ADD   AX,Y
  POP   BX
  PUSH  AX
  MOV   AX,Y
  NEG   AX
  IMUL  BX
  ADD   SI,AX
  POP   AX
  MOV   Height,AX
  MOV   BX,0
  MOV   Y,BX
 @Display:
   MOV   AX,320
   IMUL  [Y]
   MOV   DI,AX
   ADD   DI,X
{}   ADD   DI,8
   POP   DX
   MOV   BX,Width
   MOV   CX,Height
  @HeightLoop:
   PUSH  SI
   PUSH  DI
   PUSH  CX
   MOV   CX,BX
  @WidthLoop:
   MOV   AL,Byte Ptr [DS:SI]
   CMP   AL,Maskcolor
   JZ   @Skipped
   cmp   al,1
   JNZ   @kol2
   MOV	 AL,color1
   jmp   @rysuj
  @kol2:
   MOV	 AL,color2
  @rysuj:
   MOV   Byte Ptr [ES:DI],AL
  @Skipped:
   INC   SI
   INC   DI
   DEC   CX
   JNZ  @WidthLoop
   POP   CX
   POP   DI
   POP   SI
   ADD   DI,320
   ADD   SI,DX
   DEC   CX
   JNZ  @HeightLoop
   POP   DS
 End;
End;


{*}PROCEDURE pisz(xobr,yobr:integer;tekst:string;kolor1,kolor2:integer;tlo:byte);
var xf,yf,numer,a:byte;
begin
for a:=1 to length(tekst) do begin
    case tekst[a] of
         'A'..'Z':numer:=ord(tekst[a])-65;
         '1'..'9':numer:=ord(tekst[a])-23;
         '0':numer:=35;
         'a':numer:=36;
         'c':numer:=37;
         'e':numer:=38;
         'l':numer:=39;
         'n':numer:=40;
         'o':numer:=41;
         's':numer:=42;
         'x':numer:=43;
         'z':numer:=44;
         '.':numer:=45;
         ',':numer:=46;
         ':':numer:=47;
         '!':numer:=48;
         '"':numer:=49;
         '-':numer:=50;
         '?':numer:=51;
        '''':numer:=52;
         '(':numer:=53;
         ')':numer:=54;
         '/':numer:=55;
         '+':numer:=56;
         '@':numer:=57;
         '_':numer:=58;
         '%':numer:=59;
         '*':numer:=60;
         '#':numer:=61;
         '^':numer:=62;
         '`':numer:=63;
    end;
{    if xobr+(a-1)*7>scr_x2 then a:=length(tekst) else begin
      for yf:=0 to 7 do begin
        for xf:=0 to 6 do begin
            if (tlo=1) and ((fonty^[numer,yf+1,xf+1]=0) or (tekst[a]=' ')) then
               putpix(xobr+xf+(a-1)*7,yobr+yf,0);
            if (fonty^[numer,yf+1,xf+1]>0) and (tekst[a]<>' ') then begin
               if fonty^[numer,yf+1,xf+1]=1 then putpix(xobr+xf+(a-1)*7,yobr+yf,kolor1) else
                  putpix(xobr+xf+(a-1)*7,yobr+yf,kolor2);
            end;
        end;
      end;
    end;}
    if xobr+(a-1)*5>scr_x2 then a:=length(tekst) else begin
     if (tekst[a]<>' ') then
        maskpic3(xobr+(a-1)*7,yobr,7,7,0,kolor1,kolor2,fonty^[numer],scr^);
{      for yf:=0 to 5 do
        for xf:=0 to 4 do begin
            if (tlo=1) and ((fonty^[numer,yf,xf]=0) or (tekst[a]=' ')) then
               putpix(xobr+xf+(a-1)*5,yobr+yf,0);
            if (tekst[a]<>' ') and (fonty^[numer,yf,xf]=1) then
               putpix(xobr+xf+(a-1)*5,yobr+yf,kolor1);
        end;}
    end;
end;
end;

{*}PROCEDURE piszc(xobr,yobr:integer;tekst:string;kolor1,kolor2:integer;tlo:byte);
begin
pisz(xobr-trunc(length(tekst)*3.5),yobr,tekst,kolor1,kolor2,tlo);
end;

{*}PROCEDURE wczytaj_fonty;
begin
datassign(plik,'celis.dat','fonty.obr',2);
blockread(plik,fonty^,3584);close(plik);
end;

{*}PROCEDURE Get_Keyb_Int;
begin
asm
  in al,$60;
  xor cx,cx
  xor bx,bx
  mov bl,al
  and bl,$7F;
  test al,$80;
  jnz @@set
  inc cl;
  @@set:
  mov byte ptr[bx+Kl],cl;
  int Old_Int;
end;
end;

{*}PROCEDURE cala_paleta(z_czekaniem:boolean);
var
count:byte;
begin
if z_czekaniem then begin
   count:=port[$3DA];
   while $8 and count<>0 do count:=port[$3DA];
   while $8 and count=0 do count:=port[$3DA];
end;
port[$3C8]:=0;
for count:=0 to 255 do begin
    port[$3C9]:=pal[count,0];
    port[$3C9]:=pal[count,1];
    port[$3C9]:=pal[count,2];
end;
end;

{*}PROCEDURE Fadein(szybkosc,_od,_do:byte);
var
a,b:byte;
zm:boolean;
begin
for a:=_od to _do do begin
    pal[a,0]:=0;
    pal[a,1]:=0;
    pal[a,2]:=0;
end;
b:=0;
while b<=63 do begin
    inc(b,szybkosc);
    if b>64 then b:=64;
    for a:=0 to 255 do begin
        pal[a,0]:=trunc(pal_gl[a,0]*(b/64));if pal[a,0]>63 then pal[a,0]:=63;
        pal[a,1]:=trunc(pal_gl[a,1]*(b/64));if pal[a,1]>63 then pal[a,1]:=63;
        pal[a,2]:=trunc(pal_gl[a,2]*(b/64));if pal[a,2]>63 then pal[a,2]:=63;
    end;
    cala_paleta(true);
    while keypressed do readkey;
end;
end;

{*}PROCEDURE Fadeout(szybkosc,_od,_do:byte);
var
a:byte;
b:integer;
zm:boolean;
begin
{repeat
zm:=false;
for a:=_od to _do do begin
    for b:=1 to szybkosc do if pal[a,0]>0 then begin zm:=true;dec(pal[a,0]);end;
    for b:=1 to szybkosc do if pal[a,1]>0 then begin zm:=true;dec(pal[a,1]);end;
    for b:=1 to szybkosc do if pal[a,2]>0 then begin zm:=true;dec(pal[a,2]);end;
end;
cala_paleta(true);
while keypressed do readkey;
until not zm;}
b:=63;
while b>0 do begin
    dec(b,szybkosc);
    if b<0 then b:=0;
    for a:=0 to 255 do begin
        pal[a,0]:=trunc(pal_gl[a,0]*(b/64));
        pal[a,1]:=trunc(pal_gl[a,1]*(b/64));
        pal[a,2]:=trunc(pal_gl[a,2]*(b/64));
    end;
    cala_paleta(true);
    while keypressed do readkey;
end;

end;

{*}PROCEDURE Fadeout2(r,g,b,sz,szybkosc:byte);
var
a,c:byte;
zm:boolean;
begin
pal:=pal_gl;
repeat
zm:=false;
for a:=0 to 255 do begin
    for c:=1 to szybkosc do begin
    if pal[a,0]>r then begin zm:=true;dec(pal[a,0]);end;
    if pal[a,0]<r then begin zm:=true;inc(pal[a,0]);end;
    end;
    for c:=1 to szybkosc do begin
    if pal[a,1]>g then begin zm:=true;dec(pal[a,1]);end;
    if pal[a,1]<g then begin zm:=true;inc(pal[a,1]);end;
    end;
    for c:=1 to szybkosc do begin
    if pal[a,2]>b then begin zm:=true;dec(pal[a,2]);end;
    if pal[a,2]<b then begin zm:=true;inc(pal[a,2]);end;
    end;
end;
cala_paleta(true);
while keypressed do readkey;
delay(sz);
until not zm;
end;

{*}PROCEDURE Fadein2(_od,_do,szybkosc,szyb:byte;zerowanie:boolean);
var
a,b:byte;
zm:boolean;
begin
repeat
zm:=false;
for a:=_od to _do do begin
    for b:=1 to szybkosc do begin
        if pal[a,0]<pal_gl[a,0] then begin zm:=true;inc(pal[a,0]);end;
        if pal[a,0]>pal_gl[a,0] then begin zm:=true;dec(pal[a,0]);end;
    end;
    for b:=1 to szybkosc do begin
        if pal[a,1]<pal_gl[a,1] then begin zm:=true;inc(pal[a,1]);end;
        if pal[a,1]>pal_gl[a,1] then begin zm:=true;dec(pal[a,1]);end;
    end;
    for b:=1 to szybkosc do begin
        if pal[a,2]<pal_gl[a,2] then begin zm:=true;inc(pal[a,2]);end;
        if pal[a,2]>pal_gl[a,2] then begin zm:=true;dec(pal[a,2]);end;
    end;
end;
cala_paleta(true);
while keypressed do readkey;
delay(szyb);
until not zm;
end;

{*}PROCEDURE wczytaj_pal(nazwa:string);
begin
datassign(plik,'celis.dat',nazwa,0);
blockread(plik,pal_gl,768);
close(plik);
end;

{*}PROCEDURE FillChar2(Var X; Count: Word; Value:Byte); Assembler;
Asm
  les di,x
  mov cx,Count
  shr cx,1
  mov al,value
  mov ah,al
  rep StoSW
  test count,1
  jz @end
  StoSB
@end:
end;

{*}PROCEDURE move2(var Source,Dest); assembler;
asm
  push       ds
  les        di,Dest
  lds        si,Source
  mov        cx,16000
  db 66h;    rep movsw
  pop        ds
end;

{*}PROCEDURE Move3(var source, dest; count: word); assembler;
  asm
   push ds
   lds  si,source
   les  di,dest
   mov  cx,count
   mov  ax,cx
   cld
   shr  cx,2
   db   66h
   rep  movsw
   mov  cl,al
   and  cl,3
   rep  movsb
   pop  ds
end;

{*}PROCEDURE move5(var Source,Dest); assembler;
asm
  push       ds
  les        di,Dest
  lds        si,Source
  mov        cx,80
  db 66h;    rep movsw
  pop        ds
end;

{*}PROCEDURE synchro; assembler;
asm
  mov dx,3dah
  @wait:
  in al,dx
  test al,8
  je @wait
end;

{*}FUNCTION l2t(liczba:longint;ilosc_lit:byte):string;
var ww:string;
begin
str(liczba,ww);
if ilosc_lit>0 then
   while length(ww)<ilosc_lit do insert('0',ww,1);
l2t:=ww;
end;

{*}PROCEDURE obrazki;
var
buf:array[0..999] of byte;
a:longint;
begin
datassign(plik,'celis.dat','gracz.obr',2);
for a:=0 to 17 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, a*1000, 1000);
end;
close(plik);

datassign(plik,'celis.dat','oslona.obr',2);
for a:=0 to 1 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, 18000+a*1000, 1000);
end;
close(plik);

datassign(plik,'celis.dat','wrogi1.obr',2);
offsety[1]:=20000;
for a:=0 to 3 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[1]+a*1000, 1000);
end;
close(plik);
datassign(plik,'celis.dat','wrogi2.obr',2);
for a:=0 to 2 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[1]+4000+a*1000, 1000);
end;
close(plik);
datassign(plik,'celis.dat','wrogi3.obr',2);
for a:=0 to 4 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[1]+7000+a*1000, 1000);
end;
close(plik);
datassign(plik,'celis.dat','wrogi4.obr',2);
for a:=0 to 5 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[1]+12000+a*1000, 1000);
end;
close(plik);
datassign(plik,'celis.dat','wrogi5.obr',2);
for a:=0 to 2 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[1]+18000+a*1000, 1000);
end;
close(plik);
datassign(plik,'celis.dat','wrogi6.obr',2);
for a:=0 to 9 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[1]+21000+a*1000, 1000);
end;
close(plik);
datassign(plik,'celis.dat','wrogi7.obr',2);
for a:=0 to 1 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[1]+31000+a*1000, 1000);
end;
close(plik);
datassign(plik,'celis.dat','wrogi8.obr',2);
for a:=0 to 3 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[1]+33000+a*1000, 1000);
end;
close(plik);
datassign(plik,'celis.dat','wrogi9.obr',2);
for a:=0 to 12 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[1]+37000+a*1000, 1000);
end;
close(plik);
datassign(plik,'celis.dat','wrogi10.obr',2);
for a:=0 to 5 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[1]+50000+a*1000, 1000);
end;
close(plik);
datassign(plik,'celis.dat','wrogi11.obr',2);
for a:=0 to 8 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[1]+56000+a*1000, 1000);
end;
close(plik);

datassign(plik,'celis.dat','pociski.obr',2);
offsety[2]:=offsety[1]+65000;
for a:=0 to 3 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[2]+a*1000, 1000);
end;
close(plik);

datassign(plik,'celis.dat','tlo1.gdr',0);
offsety[3]:=offsety[2]+4000;
blockread(plik,GDRHead,sizeof(GDRHead));
blockread(plik,scr^,64000);
close(plik);
mem2xms(scr^, _xms[1].h, offsety[3], 64000);

datassign(plik,'celis.dat','teren1.obr',2);
for a:=0 to 89 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[3]+a*1000+64000, 1000);
end;
close(plik);


datassign(plik,'celis.dat','bonus.obr',2);
offsety[4]:=offsety[3]+90000+64000;
for a:=0 to 1 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[4]+longint(a)*1000, 1000);
end;
close(plik);

datassign(plik,'celis.dat','bonus2.obr',2);
for a:=0 to 14 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[4]+2000+a*1000, 1000);
end;
close(plik);

datassign(plik,'celis.dat','bon100.obr',2);
for a:=0 to 1 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[4]+17000+a*1000, 1000);
end;
close(plik);

datassign(plik,'celis.dat','wybuchy.obr',2);
offsety[5]:=offsety[4]+19000;
for a:=0 to 124 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[5]+a*1000, 1000);
end;
close(plik);

datassign(plik,'celis.dat','logo.obr',2);
offsety[6]:=offsety[5]+125000;
for a:=0 to 6 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[6]+a*1000, 1000);
end;
close(plik);

datassign(plik,'celis.dat','boss1.obr',2);
offsety[7]:=offsety[6]+7000;
for a:=0 to 59 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[7]+a*1000, 1000);
end;
close(plik);

datassign(plik,'celis.dat','strzalka.obr',2);
offsety[8]:=offsety[7]+60000;
for a:=0 to 0 do begin
    blockread(plik,buf,1000);
    mem2xms(buf, _xms[1].h, offsety[8]+a*1000, 1000);
end;
close(plik);

fillchar2(buf,1000,32); {scroll}
datassign(plik,'celis.dat','scroll.kod',0);
offsett:=offsety[8]+1000;   {!}

blockread(plik,buf[50],900);
for a:=50 to 900+50 do buf[a]:=buf[a] xor 93;
mem2xms(buf, _xms[1].h, offsett, 1000);

fillchar2(buf,1000,32);
blockread(plik,buf,1028-900);
for a:=0 to 1028-900 do buf[a]:=buf[a] xor 93;
mem2xms(buf, _xms[1].h, offsett+950, 1000);
close(plik); {E scroll}


datassign(plik,'celis.dat','ikonki.obr',2);
blockread(plik,ikony,576);
close(plik);

datassign(plik,'celis.dat','ikonki2.obr',2);
blockread(plik,ikony2,800);
close(plik);
datassign(plik,'celis.dat','boscan1.obr',2);
blockread(plik,ikony2[800],480);
close(plik);
datassign(plik,'celis.dat','radar.obr',2);
blockread(plik,ikony2[1280],364);
close(plik);

{---}
a:=ioresult;
end;

end.