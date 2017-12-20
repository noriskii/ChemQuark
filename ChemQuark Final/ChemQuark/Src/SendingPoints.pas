unit SendingPoints;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSendingPoint = class(TForm)
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var SendingPoint : TSendingPoint;

implementation


uses GameStoichiometric, DB_Integrator;


{$R *.dfm}

procedure TSendingPoint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);
end;

end.
