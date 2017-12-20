unit SendingPoints;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls, Vcl.Imaging.jpeg;

type
  TSendingPoint = class(TForm)
    BackGround: TImage;
    Name: TEdit;
    Number: TEdit;
    Room: TComboBox;
    Button: TImage;
    Image1: TImage;
    btn_jogar: TImage;
    procedure FormCreate(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure SetButton( Kind : Byte );
    procedure OnMouseLeave(Sender: TObject);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetData( Game : Byte; Points : Integer; Professor : Byte );
    procedure ButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_jogarClick(Sender: TObject);
    procedure btn_jogarMouseEnter(Sender: TObject);
    procedure btn_jogarMouseLeave(Sender: TObject);
  private
    { Private declarations }
    Points       : Integer;
    Game         : Byte;
    Professor    : Byte;
  public
    { Public declarations }
  end;



var SendingPoint : TSendingPoint;

implementation


uses GameStoichiometric, DB_Integrator, Menu, Solubilidade, JogoDistribuicao,
  Geometry, Load;


{$R *.dfm}

procedure TSendingPoint.SetData(Game: Byte; Points: Integer; Professor : Byte);
begin
  Self.Points := Points;
  Self.Game   := Game;
  Self.Professor := Professor;
end;

procedure TSendingPoint.btn_jogarMouseEnter(Sender: TObject);
begin
btn_jogar.Picture.LoadFromFile('Graphics/Button/JogarPrincipal_on.png');
end;

procedure TSendingPoint.btn_jogarMouseLeave(Sender: TObject);
begin
                              btn_jogar.Picture.LoadFromFile('Graphics/Button/JogarPrincipal.png');
end;

procedure TSendingPoint.ButtonClick(Sender: TObject);
begin
    // ------------------------------------------------------------------------ //
    // Limpa comandos SQL
    DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
    // Cria parâmetros para inserção
    DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Insert into Pontuacao' +
    ' (ID_Professor, ID_Jogo, Nome_Aluno, Numero_Aluno' +
    ', Serie_Aluno, Pontuacao, Data)' +
    ' Values (:A, :B, :C, :D, :E, :F, :G)');

    DataModule1.ADOQuery1.Parameters[0].Value := Professor;
    DataModule1.ADOQuery1.Parameters[1].Value := Game;
    DataModule1.ADOQuery1.Parameters[2].Value := Name.Text;
    DataModule1.ADOQuery1.Parameters[3].Value := StrToInt(Number.Text);
    DataModule1.ADOQuery1.Parameters[4].Value := Room.Text;
    DataModule1.ADOQuery1.Parameters[5].Value := Points;
    DataModule1.ADOQuery1.Parameters[6].Value := Date;

    // Executa comandos SQL
    DataModule1.ADOQuery1.ExecSQL();


    // ------------------------------------------------------------------------ //
    // Cria uma instância da classe de seleção de jogos
    Inicio := TInicio.Create(Application);
    // Exibe o formulário
    Inicio.Show();
    Self.Hide();
end;

procedure TSendingPoint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);
end;

procedure TSendingPoint.FormCreate(Sender: TObject);
begin
if  DB_Integrator.Mode = 2 then
             Button.visible := false
                    else if DB_Integrator.Mode = 1 then begin
                      Button.Visible := true;
                      btn_jogar.Visible := false;
                    end;
  PerformForm(Self);


end;

procedure TSendingPoint.btn_jogarClick(Sender: TObject);
begin

  DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
    // Cria parâmetros para inserção
    DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Insert into Pontuacao' +
    ' (ID_Professor, ID_Jogo, Nome_Aluno, Numero_Aluno' +
    ', Serie_Aluno, Pontuacao, Data)' +
    ' Values (:A, :B, :C, :D, :E, :F, :G)');

    DataModule1.ADOQuery1.Parameters[0].Value := Professor;
    DataModule1.ADOQuery1.Parameters[1].Value := Game;
    DataModule1.ADOQuery1.Parameters[2].Value := Name.Text;
    DataModule1.ADOQuery1.Parameters[3].Value := StrToInt(Number.Text);
    DataModule1.ADOQuery1.Parameters[4].Value := Room.Text;
    DataModule1.ADOQuery1.Parameters[5].Value := Points;
    DataModule1.ADOQuery1.Parameters[6].Value := Date;
           DataModule1.ADOQuery1.ExecSQL();


       case game of
         1: begin
                   SendingPoint.SetData( 1, Points, 1 );
             EletronicDistribution := TEletronicDistribution.Create(Self);
        EletronicDistribution.Show();
        EletronicDistribution.ToChoose.Enabled  := True;
        EletronicDistribution.ToConfirm.Enabled := True;
        Self.Hide();
         end;

         2: begin
          SendingPoint.SetData( 2, Pontos, 1 );
         GeometryGame := TGeometryGame.Create(Self);
        GeometryGame.ResetVariables();
        GEometryGame.CallMe();
        GeometryGame.Show();
        Self.Hide();
         end;

         3: begin
             SendingPoint.SetData( 3, TotalPoints, 1 );
          CalculoEstequiometrico := TCalculoEstequiometrico.Create(Application);
        CalculoEstequiometrico.CallMe();
        CalculoEstequiometrico.Show();
        Self.Hide();
         end;
         4: begin
          SendingPoint.SetData( 4, Points, 1 );
             if Soluct <> Nil then
            FreeAndNil(Soluct);
          Soluct := TSoluct.Create(Soluct);
          Loading := TLoading.Create(Self);
          Loading.SetSoluct();
          Loading.Show();
          Self.Hide();
         end;
      end;
end;

procedure TSendingPoint.SetButton(Kind: Byte);
begin
  Button.Picture.LoadFromFile('Graphics/Ranking/Enviar_' + IntToStr(Kind) + '.png')
end;

procedure TSendingPoint.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetButton(3)
end;

procedure TSendingPoint.OnMouseEnter(Sender: TObject);
begin
  SetButton(2)
end;

procedure TSendingPoint.OnMouseLeave(Sender: TObject);
begin
  SetButton(1)
end;

procedure TSendingPoint.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetButton(1)
end;

end.
