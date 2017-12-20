unit ManualVideo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MPlayer, ExtCtrls, pngimage;

type
  TVideoManual = class(TForm)
    Panel_video: TPanel;
    MediaPlayer1: TMediaPlayer;
    Timer1: TTimer;
    procedure SetVideo( ID : Byte );
    procedure PlayVideo();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure OpenVideo();
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  VideoManual: TVideoManual;
  Dir  : String;

implementation

uses DB_Integrator, Sound, Menu;

{$R *.dfm}

procedure TVideoManual.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WindowClass.Style := Params.WindowClass.Style or $00020000;
end;

procedure TVideoManual.SetVideo(ID: Byte);
begin
  Dir := 'Vídeos/' + IntToStr(ID) + '.wmv';
end;

procedure TVideoManual.Timer1Timer(Sender: TObject);
begin

  if ( Self.Width < 600 ) then
  begin
    Self.Width := Self.Width + 4;
    Self.Left := ( 1024 - Self.Width  ) div 2;
  end
  else
  begin
    MediaPlayer1.DisplayRect := Self.ClientRect;
    PlayVideo();
    Timer1.Enabled := False;
  end;

  if ( Self.Height < 500 ) then
  begin
    Self.Height := Self.Height + 4;
    Self.Top  := ( 768  - Self.Height ) div 2;
  end;

end;

procedure TVideoManual.OpenVideo;
begin
  MediaPLayer1.FileName := Dir;
  MediaPlayer1.Open();
end;

procedure TVideoManual.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);
end;

procedure TVideoManual.FormCreate(Sender: TObject);
begin
  DB_Integrator.PerformForm( Self );
  Self.Width := 1;
  Self.Height := 1;
  Self.Left := ( 1024 - Self.Width  ) div 2;
  Self.Top  := ( 768  - Self.Height ) div 2;
end;

procedure TVideoManual.OnKeyPress(Sender: TObject; var Key: Char);
begin
  // Se a tecla Escape é pressionada
  if Key = #27 then
  begin
    MediaPlayer1.Stop();
    Sound.Play_Cancel;
    Inicio.Enabled := True;
    Inicio.Mode := 5;
    Inicio.Show();
    Inicio.FadeOut.Visible := False;
    FreeAndNil(Self);
  end;
end;

procedure TVideoManual.PlayVideo;
begin
  MediaPLayer1.Play();
end;
end.
