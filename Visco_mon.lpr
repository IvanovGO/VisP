{%RunCommand $MakeExe($EdFile)}
program Visco_mon;
uses Serial, crt, MyTypes, sysutils;

var
PortHandle: TserialHandle;
Read_Buffer: TMas;
PData:^TRead_Buffer;
PTemp_si:^Ttemp_si;
PTemp_w:Ttemp_w;
Write_Buffer:byte=1;
Byte_Readed,Byte_Written:LongInt;
i,j:integer;
k:integer=0;
begin


  if Paramcount=2 then
    begin
    PortHandle:=Serial.SerOpen(paramstr(1));
    Serial.SerSetParams(PortHandle,
                        115200,
                        8,
                        NoneParity,
                        1,
                        []);
    end
   else begin
     writeln('Incorrect paramcount. Say "Visco_mon /dev/ttyXXX or COMn 0-255" 0-255 is a motor current ');
     halt;
   end;
 { writeln('Port Handle = ',PortHandle);

  writeln('Trying to write byte');    }
  Write_Buffer:=StrtoInt(paramstr(2));
  Byte_Written:=Serial.SerWrite(PortHandle,Write_Buffer,1);
 { Writeln(Byte_Written, ' bytes written');}

   {  TData = record
    vt:word;      {напряжение термопары}
    im:word;      { ток двигателя}
    temp: smallint;{температура с датчика}
    crc:word;  {сумма первых трех}
  end; }

    PData:=@Read_Buffer;
    PTemp_si:=@PTemp_w;
      writeln('vt;im;temp;crc');
    repeat
  Byte_Readed:=Serial.SerReadTimeout(PortHandle,Read_Buffer,8,8);

  with PData^ do
if (vt+im+temp=crc) then
  begin
  PTemp_w:=temp;

     writeln(vt,';',im,';',PTemp_si^/16:3:1,';',crc);


  end
  else
    begin
    Write_Buffer:=StrtoInt(paramstr(2));
  Byte_Written:=Serial.SerWrite(PortHandle,Write_Buffer,1);

    {writeln('CRT error');}
    end;
    until keypressed;
  Serial.SerClose(PortHandle);

end.

