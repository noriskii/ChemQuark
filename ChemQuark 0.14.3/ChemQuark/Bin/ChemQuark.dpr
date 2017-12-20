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
  Tip in 'Src\Tip.pas' {PassWordFaq},
  Rank in 'Src\Rank.pas' {Ranking},
  Pre_Ranking in 'Src\Pre_Ranking.pas' {Pre_Rank},
  Insert_Solubilidade in 'Src\Insert_Solubilidade.pas' {Insert_Solubilidad},
  Insert_Substance in 'Src\Insert_Substance.pas' {InsertSubstancia};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ChemQuark 0.10';
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TLoading, Loading);
  Application.CreateForm(TInicio, Inicio);
  Application.Run;
end.
