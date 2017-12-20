unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls, Buttons;

type
  TInstall1 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Image2: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Install1: TInstall1;

implementation

uses Unit2;

{$R *.dfm}

procedure TInstall1.Button3Click(Sender: TObject);
begin
if Messagebox(0,'Deseja realmente cancelar a instalação?','Cancelar Instalação', +mb_yesno +mb_defbutton2) = 6 then
close;
end;

procedure TInstall1.SpeedButton1Click(Sender: TObject);
begin
Install1.Hide;
Install2.show;
end;

procedure TInstall1.SpeedButton3Click(Sender: TObject);
begin
if Messagebox(0,'Deseja realmente cancelar a instalação?','Cancelar Instalação', +mb_yesno +mb_defbutton2) = 6 then
close;
end;

end.

