uses crt;
var
r1:real;
a:byte;
begin
clrscr;
randomize;
for a:=0 to 20 do begin
    r1:=(integer(random(2))*2-1)*(random/2+0.1);
    writeln(r1:5:20,'      ',r1);
end;
end.