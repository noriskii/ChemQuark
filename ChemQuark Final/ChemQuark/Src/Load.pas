unit Load;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, pngimage, jpeg;

type
  TLoading = class(TForm)
    Image3: TImage;
    Timer1: TTimer;
    Image2: TImage;
    Image1: TImage;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Loading: TLoading;

implementation

uses DB_Integrator, ManualVideo, Menu;

{$R *.dfm}

procedure TLoading.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);
end;

procedure TLoading.FormCreate(Sender: TObject);
begin
  DB_Integrator.PerformForm( Self );
end;

procedure TLoading.Timer1Timer(Sender: TObject);
var Rand : Byte;
begin
  Rand := 0;
  Image3.Width := Image3.Width + 10;
  Image3.Repaint;
  while Rand < 10 do
    Rand := Random(100);
  Timer1.Interval := Rand;

  if Image3.Width >= 885 then
  begin
    Timer1.Enabled := False;
    FreeAndNil(Self);;
    Inicio.AlphaBlendValue := 255;
    Inicio.Show();
  end;

end;

end.
