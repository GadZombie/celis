unit dzwieki;

interface
uses crt,xms,wave,dos;

var
karta_muzyczna,jest_dzwiek:boolean;
VoiceData : Array [0..30] of WaveData;

{*}FUNCTION rozpoczecie_xms:boolean;
{*}PROCEDURE wstep;
{*}PROCEDURE zamknij;
{*}PROCEDURE graj_dzwiek (Voice : WaveData;sz:real;gdzie:byte);


implementation

{*}FUNCTION rozpoczecie_xms;
begin
rozpoczecie_xms:=false;
_xms[0].os:=0;
if xmsgetmem(_xms[0].h,200000)<>0 then exit; {0 - pamiec dla dzwiekow}
if xmsgetmem(_xms[1].h,500000)<>0 then exit; {1 - pamiec dla obrazkow}
rozpoczecie_xms:=true;
end;

{*}PROCEDURE wstep;
var
bb,_port,karta:byte;plik2:file;
plik:file of byte;
begin
   assign(plik,'dzwiek.cfg');
   filemode:=0;
   {$I-}
   Reset(plik);
   {$I+}
   if IOResult = 0 then begin
      read(plik,karta);
      read(plik,_port);
      read(plik,bb); DMA:=bb;
      read(plik,bb); IRQ:=bb;
      close(plik);
   end
    else begin
         writeln('Uruchom najpierw konfiguracje karty muzycznej!');
         halt;
    end;
  if karta = 1 then karta_muzyczna:=false
               else karta_muzyczna:=true;
 if karta_muzyczna then begin
     ResetDSP ($200 + _port shl 4);
  AssignBuffer;

  LoadVoice (VoiceData[0], 'laser1.wav'  ,   976 ,0  ,0);
  LoadVoice (VoiceData[1], 'laser2.wav'  ,  4976 ,0  ,0);
  LoadVoice (VoiceData[2], 'laser3.wav'  ,  1780 ,0  ,0);
  LoadVoice (VoiceData[3], 'laser4.wav'  ,  3238 ,0  ,0);
  LoadVoice (VoiceData[4], 'bonus1.wav'  ,  4940 ,0  ,0);
  LoadVoice (VoiceData[5], 'dzialo1.wav' ,  2572 ,0  ,0);
  LoadVoice (VoiceData[6], 'dzialo2.wav' ,  4554 ,0  ,0);
  LoadVoice (VoiceData[7], 'bum1.wav'    ,  8324 ,0  ,0);
  LoadVoice (VoiceData[8], 'intro1.wav'  , 32110 ,0  ,0);
  LoadVoice (VoiceData[9], 'intro2.wav'  , 23308 ,0  ,0);
  LoadVoice (VoiceData[10],'intro3.wav'  , 12952 ,0  ,0);
  LoadVoice (VoiceData[11],'radar1.wav'  ,  4636 ,0  ,0);
  LoadVoice (VoiceData[12],'zmbron2.wav' ,  9776 ,0  ,0);
  LoadVoice (VoiceData[13],'start1.wav'  , 25836 ,0  ,0);
  LoadVoice (VoiceData[14],'tick.wav'    ,   564 ,0  ,0);
  LoadVoice (VoiceData[15],'bossa1.wav'  , 20818 ,0  ,0);
  LoadVoice (VoiceData[16],'bossa2.wav'  ,  2508 ,0  ,0);
  LoadVoice (VoiceData[17],'wrog1.wav'   ,  1446 ,0  ,0);

  case IRQ of
    2 : GetIntVec($71, OldIRQ);
   10 : GetIntVec($72, OldIRQ);
   11 : GetIntVec($73, OldIRQ);
  else
    GetIntVec (8 + IRQ, OldIRQ);
  end;
  case IRQ of
    2 : SetIntVec($71, Addr (ServiceIRQ));
   10 : SetIntVec($72, Addr (ServiceIRQ));
   11 : SetIntVec($73, Addr (ServiceIRQ));
  else
    SetIntVec (8 + IRQ, Addr (ServiceIRQ));
  end;
  case IRQ of
    2 : Port[$A1] := Port[$A1] and not 2;
   10 : Port[$A1] := Port[$A1] and not 4;
   11 : Port[$A1] := Port[$A1] and not 8;
  else
    Port[$21] := Port[$21] and not (1 shl IRQ);
  end;
  if IRQ in [2, 10, 11] then Port[$21] := Port[$21] and not 4;

  CBuffer := 3;
  StartPlayBack;
 end;
end;

{*}PROCEDURE zamknij;
var
a:byte;
begin
 if karta_muzyczna then begin
  WriteDSP ($D0);
  WriteDSP ($DA);
  FreeMem (DMABuffer, 32768);
  case IRQ of
    2 : SetIntVec($71, OldIRQ);
   10 : SetIntVec($72, OldIRQ);
   11 : SetIntVec($73, OldIRQ);
  else
    SetIntVec (8 + IRQ, OldIRQ);
  end;
  case IRQ of
    2 : Port[$A1] := Port[$A1] or 2;
   10 : Port[$A1] := Port[$A1] or 4;
   11 : Port[$A1] := Port[$A1] or 8;
  else
    Port[$21] := Port[$21] or (1 shl IRQ);
  end;
  if IRQ in [2, 10, 11] then Port[$21] := Port[$21] or 4;
 end;


for a:=0 to 1 do xmsfreemem(_xms[a].h);
end;

{*}PROCEDURE graj_dzwiek (Voice : WaveData;sz:real;gdzie:byte);
begin
if (karta_muzyczna) and (jest_dzwiek) then MixVoice (Voice,sz,gdzie);
end;






end.