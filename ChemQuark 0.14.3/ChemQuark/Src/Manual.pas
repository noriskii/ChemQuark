unit Manual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, pngimage, jpeg;

type
  TAjuda = class(TForm)
    PictureManual: TImage;
    ToolPicture: TImage;
    Preview: TImage;
    Next: TImage;
    Page: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SetManual(Game: Byte; Kind : Byte);
    procedure OnClose(Sender: TObject; var Action: TCloseAction);
    procedure ImageClick(Sender: TObject);
    procedure UpdateImage();
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
    procedure UpdateLevel();
    procedure OnKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Ajuda: TAjuda;
  Pages: Integer;
  Index: Integer = 1;
  Directory: String;

implementation

uses DB_Integrator, Menu, Sound;

{$R *.dfm}

procedure TAjuda.FormCreate(Sender: TObject);
begin
  DB_Integrator.PerformForm( Self );
end;

procedure TAjuda.UpdateImage();
begin
  PictureManual.Picture.LoadFromFile(Directory + IntToStr(Index) + '.png');
end;

procedure TAjuda.UpdateLevel;
begin
  Page.Caption := IntToStr(Index) + ' / ' + IntToStr(Pages);
end;

procedure TAjuda.ImageClick(Sender: TObject);
begin

  if Sender = Next then
  begin
    if Index < Pages then
      Index := Index + 1
  end
  else if Sender = Preview then
  begin
    if Index > 1 then
      Index := Index - 1;
  end;

  UpdateImage();
  Self.UpdateLevel();
end;



procedure TAjuda.OnClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);
end;

procedure TAjuda.OnKeyPress(Sender: TObject; var Key: Char);
begin
  // Se a tecla Escape é pressionada
  if Key = #27 then
  begin
    Sound.Play_Cancel;
    FreeAndNil(Self);
    Inicio.Mode := 5;
    Inicio.Show();
  end;
end;

procedure TAjuda.OnMouseEnter(Sender: TObject);
begin

  if Sender = Next then
    Next.Picture.LoadFromFile('Graphics/Manual/Button_Right_2.png')
  else if Sender = Preview then
    Preview.Picture.LoadFromFile('Graphics/Manual/Button_Left_2.png')

end;

procedure TAjuda.OnMouseLeave(Sender: TObject);
begin
  if Sender = Next then
    Next.Picture.LoadFromFile('Graphics/Manual/Button_Right_1.png')
  else if Sender = Preview then
    Preview.Picture.LoadFromFile('Graphics/Manual/Button_Left_1.png')
end;

procedure TAjuda.SetManual(Game: Byte; Kind : Byte);
var I : Integer;
begin
  Directory := 'Graphics/Manuais/' + IntToStr(Game) + '/' + IntToStr(Kind) + '/';
  for I := 1 to 99 do
    if not FileExists(Directory + IntToStr(I) + '.png') then
    begin
      Pages := I - 1;
      Break
    end;
  Index := 1;
  Self.UpdateLevel();
  UpdateImage();
end;

end.
