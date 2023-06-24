{$G+}
unit xpal;

interface
type
 palettetype=array[0..255] of record r,g,b:byte end;
var
 paleta:palettetype;
 {tablica do przechowywania 256-cio kolorowej palety}

procedure setrgb(n,r,g,b:byte); {procedura ustawia skladowe koloru          }
                                {o numerze n na r(czerw), g(ziel.), b(nieb.)}

Procedure SetPalette(p:palettetype); {procedura do ustawienia calej palety z tablicy}

Procedure GetPalette(var p);

implementation


procedure setrgb(n,r,g,b:byte);
begin
 port[$3c8]:=n;
 port[$3c9]:=r;
 port[$3c9]:=g;
 port[$3c9]:=b;
end;

Procedure GetPalette(var p); assembler;
Asm
    PUSH DS
    XOR AX, AX
    MOV CX, 0300h
    LES DI, P
    MOV DX, 03C7h
    OUT DX, AL
    INC DX
    INC DX
    CLD
    REP INSB
    POP DS
end;
Procedure SetPalette(p:palettetype); assembler;
Asm
    PUSH DS
    XOR AX, AX
    MOV CX, 0300h
    LDS SI, P
    MOV DX, 03C8h
    OUT DX, AL
    INC DX
    CLD
    REP OutsB
    POP DS
end;

end.