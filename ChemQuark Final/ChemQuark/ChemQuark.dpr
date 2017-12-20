program ChemQuark;

uses
  Forms,
  Tabela in 'Src\Tabela.pas' {PeriodicTable},
  Elementos in 'Src\Elementos.pas',
  Propriedades in 'Src\Propriedades.pas' {WindowPropertie},
  JogoDistribuicao in 'Src\JogoDistribuicao.pas' {EletronicDistribution},
  Menu in 'Src\Menu.pas' {Inicio},
  GameStoichiometric in 'Src\GameStoichiometric.pas' {CalculoEstequiometrico},
  DB_Integrator in 'Src\DB_Integrator.pas' {DataModule1: TDataModule},
  SendingPoints in 'Src\SendingPoints.pas' {SendingPoint},
  Insert_Stoichiometric in 'Src\Insert_Stoichiometric.pas' {InsertStoichiometric},
  Geometry in 'Src\Geometry.pas' {GeometryGame},
  Sound in 'Src\Sound.pas',
  Solubilidade in 'Src\Solubilidade.pas' {Soluct},
  Manual in 'Src\Manual.pas' {Ajuda},
  ManualVideo in 'Src\ManualVideo.pas' {VideoManual},
  Load in 'Src\Load.pas' {Loading},
  Login in 'Src\Login.pas' {TeacherLogin},
  Register in 'Src\Register.pas' {RegisterUser},
  Master in 'Src\Master.pas' {Admin},
  Tip in 'Src\Tip.pas' {PassWordFaq};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TLoading, Loading);
  Application.CreateForm(TSoluct, Soluct);
  Application.CreateForm(TInicio, Inicio);
  Application.CreateForm(TPeriodicTable, PeriodicTable);
  Application.CreateForm(TWindowPropertie, WindowPropertie);
  Application.CreateForm(TRegisterUser, RegisterUser);
  Application.CreateForm(TAdmin, Admin);
  Application.CreateForm(TTeacherLogin, TeacherLogin);
  Application.CreateForm(TPassWordFaq, PassWordFaq);
  Application.Run;
end.
