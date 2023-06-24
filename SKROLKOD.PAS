uses crt;

var
pl1,pl2:file;
b:byte;

begin
assign(pl1,'scroll.txt');
reset(pl1,1);

assign(pl2,'scroll.kod');
rewrite(pl2,1);

while not eof(pl1) do begin
   blockread(pl1,b,1);
   if (b<>13) and (b<>10) then begin
      b:=b xor 93;
      blockwrite(pl2,b,1);
   end;
end;

close(pl1);
close(pl2);


end.