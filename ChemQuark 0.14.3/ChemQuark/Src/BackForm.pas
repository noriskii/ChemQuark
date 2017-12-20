unit BackForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TFadeOut = class(TForm)
    procedure OnClose(Sender: TObject; var Action: TCloseAction);
    procedure OnCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FadeOut: TFadeOut;

implementation

uses DB_Integrator;

{$R *.dfm}

procedure TFadeOut.OnClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);
end;

procedure TFadeOut.OnCreate(Sender: TObject);
begin
  DB_Integrator.PerformForm(Self);
end;

end.
