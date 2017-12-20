program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Install1},
  Unit2 in 'Unit2.pas' {Install2},
  Unit3 in 'Unit3.pas' {Install3},
  Unit4 in 'Unit4.pas' {Install4},
  Unit5 in 'Unit5.pas' {Install5};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'SetupChemQuark';
  Application.CreateForm(TInstall1, Install1);
  Application.CreateForm(TInstall4, Install4);
  Application.CreateForm(TInstall5, Install5);
  Application.CreateForm(TInstall2, Install2);
  Application.CreateForm(TInstall3, Install3);
  Application.Run;
end.
