unit Hard_Visko;

{$mode objfpc}{$H+}

interface
     uses
  {Classes, SysUtils,} Serial;

   type

    TData = record
    vt:word;          { Vtc напряжение термопары}
    im:word;          { I   ток двигателя}
    temp: smallint;   { T   температура с датчика}
    crc:word;         {CRC  сумма первых трех}
  end;


  THard_Visko = class
    public
     Opened:boolean;
     CRCError:boolean;
     FBytes_Written:longint;
     FSerialHandle:TSerialHandle;

     FPData:^TData;
     procedure       SetPower(FPower:Byte);
     procedure       DataIdle(FIdle:boolean);
     property        Power:Byte write SetPower;
     property        Idle:boolean write DataIdle;
     function        GetViData():TData;
     constructor     Connect_Device(DeviceName: String; BitsPerSec: LongInt;
                                    ByteSize: Integer; Parity: TParityType;
                                    StopBits: Integer; Flags: TSerialFlags);
     destructor      Close;

     private
         FRead_Buffer:array [0..255] of byte;
  end;




implementation

 constructor THard_Visko.Connect_Device(DeviceName:String; BitsPerSec: LongInt;
                            ByteSize: Integer; Parity: TParityType;
                            StopBits: Integer; Flags: TSerialFlags);
   var
     b:byte=255;
     i:byte;
 begin
    Opened:=false;
    FSerialHandle:=Serial.SerOpen(DeviceName);  //open specified RS-232 port
    Serial.SerSetParams(FSerialHandle,     //setting port parameters
                        BitsPerSec,
                        ByteSize,
                        Parity,
                        StopBits,
                        Flags);
 if FSerialHandle>0 then     //if port opened succesfully
  begin
    Idle:=true;  //send 255 to initialize & shutdown MC
    Power:=0;   //go quiet first
    for i:=0 to 7 do FRead_Buffer[i]:=0;
    FPData:=@FRead_Buffer;

 GetViData;     GetViData;     GetViData;

    if not CRCError then Opened:=true;   //set flag Port is connected to PC & Opened
  end;


 end;

 destructor THard_Visko.Close;

  begin
                   //if opened - close
    if Opened then
     begin
       Power:=0;
       Idle:=true;
       Serial.SerClose(FSerialHandle);
      end;
     Opened:=false;
  end;

 function THard_Visko.GetViData():TData;
 var b:byte;
  begin
   {  TData = record
    vt:word;        {напряжение термопары}
    im:word;        { ток двигателя}
    temp: smallint; {температура с датчика}
    crc:word;       {сумма первых трех}
  end; }

       Idle:=true;
     // SetPower(Power);

  if Serial.SerReadTimeout(FSerialHandle,FRead_Buffer,8,100) = 7 then
  begin        //get data to fresult
     GetViData.vt:=FPData^.vt;
     GetViData.im:=FPData^.im;
     GetViData.temp:=FPData^.temp;
     GetViData.crc:=FPData^.crc;
  end else
  begin
     GetViData.vt:=0;
     GetViData.im:=0;
     GetViData.temp:=0;
     GetViData.crc:=300;

  end;
        //check CRC
     CRCError:= ((GetViData.vt+GetViData.im+GetViData.temp)<>GetViData.crc);


 end;

 procedure THard_Visko.SetPower(FPower:byte);
 begin
 if Opened then FBytes_Written:=Serial.SerWrite(FSerialHandle,FPower,1);

 end;

 procedure THard_Visko.DataIdle(FIdle:boolean);
 var b:byte=255;
 begin
  if (Opened and FIdle) then FBytes_Written:=Serial.SerWrite(FSerialHandle,b,1);

 end;

end.

