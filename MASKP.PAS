{$A+,B-,D+,E-,F+,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}
unit maskp;

interface
uses xms;
type
  chm=array[1..255] of array[0..255] of byte;
var
  chmur:^chm;


{*}PROCEDURE MaskPic(X,Y,Width,Height:integer; Maskcolor:byte; Sprite, Dest:Pointer);
{*}PROCEDURE MaskPic2(X,Y,Width,Height:integer; Maskcolor,color:byte; Sprite,Dest:Pointer);
{*}PROCEDURE MaskPict(X,Y,Width,Height:integer; Maskcolor:byte; tab,Sprite, Dest:Pointer);
{*}PROCEDURE MaskPicXMS(X,Y,Width,Height:integer; Maskcolor:byte; offset:longint ;Dest:Pointer);
{*}PROCEDURE barT(x1,y1,x2,y2:word; kolor:byte; var gdzie,tab);

implementation

{*}PROCEDURE MaskPic(X,Y,Width,Height:integer; Maskcolor:byte; Sprite, Dest:Pointer);
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
   ADD   DI,8
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
   JZ    @Skipped
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

{*}PROCEDURE MaskPic2(X,Y,Width,Height:integer; Maskcolor,color:byte; Sprite,Dest:Pointer);
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
   ADD   DI,8
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
   JZ    @Skipped
   MOV	 AL,color
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

Procedure MaskPicT(X,Y,Width,Height:integer; Maskcolor:byte; tab,Sprite,Dest:Pointer);
 Begin
  If (x <= -width) or (x >= 320) or (y <= -height) or (y >= 200) then exit;
 Asm
   PUSH  DS
   LDS   SI,Sprite
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
   ADD   DI,8
   POP   DX
   MOV   BX,Width
   MOV   CX,Height
  @HeightLoop:
   PUSH  SI
   PUSH  DI
   PUSH  CX
   MOV   CX,BX
  @WidthLoop:
   PUSH  BX
   MOV   BL,Byte Ptr DS:[SI]
   CMP   BL,Maskcolor
   JZ    @Skipped
{} ADD   Bl,8
   MOV   BH,Byte Ptr Es:[DI]
   PUSH  ES
   PUSH  DI
   LES   DI,TAB
   MOV   AL,Byte Ptr ES:[BX]
   POP   DI
   POP   ES
   MOV   Byte Ptr ES:[DI],AL
  @Skipped:
   POP   BX
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

{*}PROCEDURE MaskPicXMS(X,Y,Width,Height:integer; Maskcolor:byte; offset:longint ;Dest:Pointer);
var
sprite:pointer;
buf:array[0..3599] of byte;
begin
XMS2Mem(_xms[1].h,offset,buf,width*height);
MaskPic(X,Y,Width,Height, Maskcolor, @buf, Dest);
end;

{*}PROCEDURE barT(x1,y1,x2,y2:word; kolor:byte; var gdzie,tab); assembler;
asm
  add   x1,8
  add   x2,8
  les   di,gdzie
  mov   ax,y1
  mov   bx,320
  mul   bx
  add   ax,x1
  mov   di,ax
  mov   ax,y2
  sub   ax,y1
  inc   ax
 @wys:
  mov   cx,x2
  sub   cx,x1
  inc   cx
  push  di
 @szer:
  mov   bl,byte ptr es:[di]
  mov   bh,kolor
{}{add   bl,8}
{}{sub   bl,8}
  dec   bh
  push  es
  push  di
  les   di,tab
  mov   dl,byte ptr es:[bx+8]
  pop   di
  pop   es
  mov   byte ptr es:[di],dl
  inc   di
 loop   @szer
  pop   di
  add   di,320
  dec   ax
  jnz @wys;
end;
end.