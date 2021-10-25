unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Serial, Hard_Visko, Soft_Visko;

type

  { TMainForm }

  TMainForm = class(TForm)
    Avto: TCheckBox;
    ReadButton: TButton;
    PowerTrackBar: TTrackBar;
    Timer1: TTimer;
    WriteButton: TButton;
    ConnectButton: TButton;
    DisconnectButton: TButton;
    WriteEdit: TEdit;
    OutputMemo: TMemo;
    PortEdit: TEdit;
    MainPanel: TPanel;
    procedure AvtoChange(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure DisconnectButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MainPanelClick(Sender: TObject);
    procedure PowerTrackBarChange(Sender: TObject);
    procedure ReadButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure WriteButtonClick(Sender: TObject);
  private


  public

  end;

var
  MainForm: TMainForm;
  MyVisko:THard_Visko;
  SV:TSoft_Visko;
  PData:TData;


implementation

{$R *.lfm}

{ TMainForm }




procedure TMainForm.PowerTrackBarChange(Sender: TObject);

begin
       MyVisko.Power:=byte(PowerTrackBar.Position);
end;

procedure TMainForm.ReadButtonClick(Sender: TObject);
begin
 if MyVisko.Opened then OutputMemo.Lines.Insert(0,SV.DataLine);
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
     if MyVisko.Opened and not ConnectButton.Enabled then
      begin
      OutputMemo.Lines.Insert(0,SV.DataLine);
       OutputMemo.Lines.Insert(0,InttoStr(MyVisko.GetViData().im));
      end;

end;

procedure TMainForm.WriteButtonClick(Sender: TObject);

begin
      MyVisko.Power:=byte(StrtoInt(WriteEdit.Text))
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //   print('Application is running...');

end;

procedure TMainForm.MainPanelClick(Sender: TObject);
begin

end;

procedure TMainForm.ConnectButtonClick(Sender: TObject);
begin

  MyVisko:=THard_Visko.Connect_Device(PortEdit.Text, 115200,8,NoneParity,1,[]);

       if MyVisko.Opened then
        begin
           SV:=TSoft_Visko.Catch(@MyVisko);
           ConnectButton.Enabled:=false;
           DisconnectButton.Enabled:=true;
           MainPanel.Enabled:=true;
        end;

end;

procedure TMainForm.AvtoChange(Sender: TObject);
begin
  if (Avto.Checked and not ConnectButton.Enabled) then
   Timer1.Interval:=300 else Timer1.Interval:=0;
end;

procedure TMainForm.DisconnectButtonClick(Sender: TObject);
begin
     MyVisko.Close;
     SV.Free;
     ConnectButton.Enabled:=true;
     DisconnectButton.Enabled:=false;
     MainPanel.Enabled:=false;

end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    MyVisko.Close;
    SV.Free;
end;





end.

