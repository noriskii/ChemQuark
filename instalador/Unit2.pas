unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, pngimage, ExtCtrls;

type
  TInstall2 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label2: TLabel;
    Image3: TImage;
    Memo1: TMemo;
    Check: TCheckBox;
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CheckClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Install2: TInstall2;

implementation

uses Unit1, Unit3, Unit4, Unit5;

{$R *.dfm}


procedure TInstall2.CheckClick(Sender: TObject);
begin
if check.Checked=true then
begin
  speedbutton1.Enabled:= true;
  speedbutton1.Flat:=true;
  speedbutton1.Caption:='';
end;
if check.Checked=false then
begin
  speedbutton1.Enabled:= false;
  speedbutton1.Flat:=false;
  speedbutton1.Caption:='Próximo                             ';
end;
end;

procedure TInstall2.FormKeyPress(Sender: TObject; var Key: Char);
begin
//verifica se a tecla pressionada é a tecla ENTER
If (key = #13) and (speedbutton1.Enabled = true) then
Begin
speedbutton1.Click;
end;

end;
procedure TInstall2.SpeedButton1Click(Sender: TObject);
begin
Install2.Hide;
Install3.show;
end;

procedure TInstall2.SpeedButton2Click(Sender: TObject);
begin
Install2.hide;
Install1.show;
end;

procedure TInstall2.SpeedButton3Click(Sender: TObject);
begin
if Messagebox(0,'Deseja realmente cancelar a instalação?','Cancelar Instalação', +mb_yesno +mb_defbutton2) = 6 then
install1.Close;
install2.Close;
install3.Close;
install4.Close;
install5.Close;
end;

end.
