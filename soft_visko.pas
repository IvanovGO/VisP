unit Soft_Visko;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Hard_Visko;

type

  TSoft_Visko = class

    constructor Catch(PHard:pointer);
    destructor  Free;
    function    Compose2Str:string;
    property    DataLine:string read Compose2Str;
    private
        PHard_Visko:^THard_Visko;
   end;

implementation
      constructor TSoft_Visko.Catch(PHard:pointer);
      begin
         PHard_Visko:=PHard
      end;

      destructor TSoft_Visko.Free;
      begin

      end;

      function TSoft_Visko.Compose2Str:string;
      {  TData = record
    vt:word;        {напряжение термопары}
    im:word;        { ток двигателя}
    temp: smallint; {температура с датчика}
    crc:word;       {сумма первых трех}
         end; }

       begin
         with  PHard_Visko^.GetViData() do
        begin
           Compose2Str+='Thermocouple-'+InttoStr(vt);
           Compose2Str+=' Motor current-'+InttoStr(im);
           Compose2Str+=' temp-'+InttoStr(temp div 16);
           Compose2Str+=' CRC-'+InttoStr(crc);
         end;
       end;

end.

