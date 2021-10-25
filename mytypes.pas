unit MyTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  TMas = array[0..8] of byte;

  TRead_Buffer = packed record
    vt:word;      {напряжение термопары}
    im:word;      { ток двигателя}
    temp: word;{температура с датчика}
    crc:word;  {сумма первых трех}
  end;

  Ttemp_si=smallint;

  Ttemp_w=word;

  PMas  = ^TMas;

implementation

end.

