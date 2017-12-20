unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, pngimage, ExtCtrls;

type
  TInstall1 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Image3: TImage;
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Install1: TInstall1;

implementation

uses Unit2, Unit3, Unit4, Unit5;

{$R *.dfm}

procedure TInstall1.FormKeyPress(Sender: TObject; var Key: Char);
begin
//verifica se a tecla pressionada é a tecla ENTER
If key = #13 then
Begin
speedbutton1.Click;
end;

end;
procedure TInstall1.SpeedButton1Click(Sender: TObject);
begin
Install1.Hide;
Install2.show;
end;

procedure TInstall1.SpeedButton3Click(Sender: TObject);
begin
if Messagebox(0,'Deseja realmente cancelar a instalação?','Cancelar Instalação', +mb_yesno +mb_defbutton2) = 6 then
install1.Close;
install2.Close;
install3.Close;
install4.Close;
install5.Close;
end;

end.
