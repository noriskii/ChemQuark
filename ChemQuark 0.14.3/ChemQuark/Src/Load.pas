unit Load;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, pngimage, jpeg;

type
  TLoading = class(TForm)
    Image3: TImage;
    Timer1: TTimer;
    Receptaculo: TImage;
    BackGround: TImage;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SetSoluct();
    procedure SetMax();
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Loading: TLoading;
  Soluct_: Boolean = False;
  Fill   : Integer = 100;
  Back   : Integer = 100;

implementation

uses DB_Integrator, ManualVideo, Menu, Solubilidade;

{$R *.dfm}

procedure TLoading.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);
end;

procedure TLoading.SetSoluct;
begin
  Soluct_ := True;
end;

procedure TLoading.FormCreate(Sender: TObject);
begin
  DB_Integrator.PerformForm( Self );
  SetMax();
  BackGround.Picture.LoadFromFile('Graphics/Loading/BackGround/Loading_' +
                      IntToStr((Random(Back - 1) + 1)) + '.jpg');
  Image3.Picture.LoadFromFile('Graphics/Loading/Fill/Fill_' +
                      IntToStr((Random(Fill - 1) + 1)) + '.png');
end;

procedure TLoading.FormShow(Sender: TObject);
begin
with Screen.Fonts do
  if not IndexOf('Royal Society of Chemistry') >= 0 then
                       AddFontResource(PChar('Font\RSC.ttf'))

end;

procedure TLoading.SetMax;
var I : Integer;
    Directory : String;
begin
  Directory := 'Graphics/Loading/BackGround/Loading_';
  for I := 1 to 99 do
    if not FileExists(Directory + IntToStr(I) + '.jpg') then
    begin
      Back := I - 1;
      Break
    end;
  Directory := 'Graphics/Loading/Fill/Fill_';
  for I := 1 to 99 do
    if not FileExists(Directory + IntToStr(I) + '.png') then
    begin
      Fill := I - 1;
      Break
    end;
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
  if Soluct_ then
  begin
    if Image3.Width = 201 then
      Players[1].Open()
    else if Image3.Width = 411 then
      Players[2].Open()
    else if Image3.Width = 621 then
      Players[3].Open()
    else if Image3.Width = 761 then
      Players[4].Open()
    else if Image3.Width = 871 then
      Players[5].Open();
  end;

  if Image3.Width >= 885 then
  begin
    Timer1.Enabled := False;
    Inicio.AlphaBlendValue := 255;
    FreeAndNil(Loading);
    if Soluct_ then
      Soluct.Show()
    else
      Inicio.Show();
  end;

end;

end.
