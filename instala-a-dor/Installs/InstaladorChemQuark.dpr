program InstaladorChemQuark;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Install1},
  Unit2 in 'Unit2.pas' {Install2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TInstall1, Install1);
  Application.CreateForm(TInstall2, Install2);
  Application.Run;
end.
