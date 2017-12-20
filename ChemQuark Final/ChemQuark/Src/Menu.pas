unit Menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, Tabela, jpeg, DB_Integrator,
  Insert_Stoichiometric, Sound, JogoDistribuicao, GameStoichiometric;

type
  TInicio = class(TForm)
    Back: TImage;
    FadeOut: TImage;
    procedure FormCreate(Sender: TObject);
    procedure ChangePicture();
    procedure Mode1();
    procedure Mode2();
    procedure Mode3();
    procedure Mode4();
    procedure Mode5();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Login( Kind : Boolean );
  private
    { Private declarations }
  public
    { Public declarations }
      // Menu atual
      Mode   : Byte;
  end;

var
  Inicio : TInicio;
  // Armazena o índice da atual escolha selecionada
  Cursor : Byte = 1;
  // Jogo selecionado
  Game   : Byte;

implementation

uses Geometry, Manual, ManualVideo, Load, Login, Solubilidade;

{$R *.dfm}

procedure TInicio.Login(Kind: Boolean);
begin
  FadeOut.Visible := False;
  if Kind then
  begin
    Mode := 4;
    Cursor := 1;
  end
  else
  begin
    Mode := 1;
    Cursor := 1;
  end;
  ChangePicture();
end;

procedure TInicio.Mode2;
begin
  Mode := 3;
  Game := Cursor;
  Cursor := 1;
  ChangePicture();
end;

procedure TInicio.Mode5();
begin
  if Cursor < 3 then
  begin
    Ajuda := TAjuda.Create(Self);
    Ajuda.SetManual(Game, Cursor);
    Ajuda.Show();
    Self.Hide();
    Exit();
  end
  else if Cursor = 4 then
  begin
    Mode := 3;
    Cursor := 1;
    ChangePicture();
  end
  else if Cursor = 3 then
  begin
    FadeOut.Visible := True;
    VideoManual := TVideoManual.Create(Self);
    VideoManual.SetVideo(Game);
    VideoManual.OpenVideo();
    Self.Enabled := False;
    VideoManual.Show();
  end;


end;

procedure TInicio.Mode3;
begin
  if Cursor = 3 then
  begin
    Mode := 5;
    Cursor := 1;
    ChangePicture();
    Exit();
  end
  else if Cursor = 4 then
  begin
    Mode := 2;
    Cursor := 1;
    ChangePicture();
    Exit();
  end
  else if Cursor = 2 then
    case Game of
    1:
    begin
      FreeAndNil(EletronicDistribution);
      EletronicDistribution := TEletronicDistribution.Create(Self);
      EletronicDistribution.FormCreate(Application);
      EletronicDistribution.ToChoose.Enabled := true;
      EletronicDistribution.ToConfirm.Enabled := True;
      EletronicDistribution.Show();
      Self.Hide();
    end;
    2:
    begin
      GeometryGame := TGeometryGame.Create(Self);
      GeometryGame.ResetVariables();
      GEometryGame.CallMe();
      GeometryGame.Show();
      Self.Hide();
    end;
    3:
    begin
      CalculoEstequiometrico := TCalculoEstequiometrico.Create(Application);
      CalculoEstequiometrico.CallMe();
      CalculoEstequiometrico.Show();
      Self.Hide();
    end;
    4:
    begin
      FreeAndNil(Soluct);
      Soluct := TSoluct.Create(Application);
      Soluct.Show();
      Self.Hide();
    end;
  end;
end;

procedure TInicio.Mode4();
begin
  if Cursor = 4 then
  begin
    Mode := 1;
    Cursor := 1;
    ChangePicture();
  end
  else if Cursor = 1 then
  begin
    InsertStoichiometric := TInsertStoichiometric.Create(Application);
    Self.Hide();
    InsertStoichiometric.OnFormCreate(Application);
    InsertStoichiometric.Show();
  end
end;

procedure TInicio.Mode1();
begin

  case Cursor of
  1:
  begin
    Mode := 2;
    Cursor := 1;
    ChangePicture();
  end;
  2:
  begin
    FadeOut.Visible := True;
    TeacherLogin.ShowModal;
    FadeOut.Visible := False;
  end;
  3:
  begin
    Tabela.PeriodicTable.Show();
    Tabela.PeriodicTable.Enabled := true;
    Tabela.PeriodicTable.Visible := true;
    Tabela.PeriodicTable.ActiveForm := true;
    Tabela.PeriodicTable.CursorIndex := Tabela.PeriodicTable.SaveCursorIndex;
    Tabela.WhereTo := 3;
    Self.Hide();
  end;
  4: Self.Close();
  end;
end;

procedure TInicio.ChangePicture();
begin
  Back.Picture.LoadFromFile('Graphics/Inicio/' + IntToStr(Mode) + '/' + IntToStr
                                                             (Cursor) + '.jpg');
end;

procedure TInicio.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);
end;

procedure TInicio.FormCreate(Sender: TObject);
begin
  PerformForm(Self);
  Cursor := 1;
  Mode   := 1;
  ShowCursor(False);
end;

procedure TInicio.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if ( Key = VK_ESCAPE ) and ( Mode = 2 ) then
  begin
    Sound.Play_Cancel;
    Mode := 1;
    Cursor := 1;
    ChangePicture();
  end;

  if Key = VK_DOWN then
    begin
      Play_Cursor(1);
      if Cursor < 4 then
        Cursor := Cursor + 1
      else
        Cursor := 1;
      ChangePicture();
    end
    else if Key = VK_UP then
    begin
      Play_Cursor(1);
      if Cursor > 1 then
        Cursor := Cursor - 1
      else
        Cursor := 4;
      ChangePicture();
    end;

  if Key = VK_Return then
    begin
      Play_Decision(1);
      case Mode of
      1: Mode1();
      2: Mode2();
      3: Mode3();
      4: Mode4();
      5: Mode5();
      end;
    end;
end;

end.
