unit Rank;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, pngimage, ExtCtrls;

type
  TRanking = class(TForm)
    Dados: TDBGrid;
    BackGround: TImage;
    Voltar: TImage;
    RefershBD: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetConditions(Jogo : Byte; Serie : String;
                            De : TDate; Ate : TDate);
    procedure SetData();
    procedure OnTitleClick(Column: TColumn);
    function  Command( Order : String ) : String;
    procedure OnMouseLeave(Sender: TObject);
    procedure SetPicture( Index : Byte );
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnClick(Sender: TObject);
    procedure SetTitleNames();
    procedure RefreshBDTimer(Sender: TObject);
  private
    Jogo   : Byte;
    Serie  : String;
    De     : TDate;
    Ate    : TDate;
  public
    { Public declarations }
  end;

var
  Ranking: TRanking;
  Crescente : Boolean = False;

implementation

uses DB_Integrator, Pre_Ranking, Sound, Menu;

{$R *.dfm}

procedure TRanking.SetConditions(Jogo: Byte; Serie: string;
                                 De: TDate; Ate: TDate);
begin
  Self.Jogo  := Jogo;
  Self.Serie := Serie;
  Self.De    := De;
  Self.Ate   := Ate;
  SetData();
end;

procedure TRanking.SetTitleNames();
begin
  Dados.Columns[0].Title.Caption := 'Nome do Aluno';
  Dados.Columns[1].Title.Caption := 'Número';
  Dados.Columns[2].Title.Caption := 'Série';
  Dados.Columns[3].Title.Caption := 'Pontuação';
  Dados.Columns[4].Title.Caption := 'Data';


end;

procedure TRanking.SetPicture(Index: Byte);
begin
  With Voltar.Picture Do
    LoadFromFile('Graphics/RateResult/Botão_' + IntToStr(Index) + '.png');
end;

procedure TRanking.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);
end;

procedure TRanking.FormCreate(Sender: TObject);
begin
  DB_Integrator.PerformForm( Self );
  DataModule1.RankingQuery.SQL.Clear();
  DataModule1.RankingQuery.SQL.Add('SELECT Pontuacao.Nome_Aluno, Pontuacao.Numero_Aluno, Pontuacao.Serie_Aluno, Pontuacao.Pontuacao, Pontuacao.Data FROM Jogo INNER JOIN (Professor INNER JOIN Pontuacao ON Professor.ID = Pontuacao.ID_Professor) ON Jogo.ID = Pontuacao.ID_Jogo;');
  DataModule1.RankingQuery.Active := True;
  DataModule1.RankingQuery.ExecSQL();
  SetTitleNames();

end;

procedure TRanking.OnClick(Sender: TObject);
begin
  Sound.Play_Cancel;
 // Cria uma instância da classe de seleção de jogos
        Inicio := TInicio.Create(Application);
        // Exibe o formulário
        inicio.mode:=4;
        Inicio.Show();
        // Fecha a janela
  Self.Hide();
end;

procedure TRanking.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetPicture(3);
end;

procedure TRanking.OnMouseEnter(Sender: TObject);
begin
  SetPicture(2);
end;

procedure TRanking.OnMouseLeave(Sender: TObject);
begin
  SetPicture(1);
end;

procedure TRanking.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetPicture(1);
end;

procedure TRanking.OnTitleClick(Column: TColumn);
var Order : String;
begin

 
end;

procedure TRanking.RefreshBDTimer(Sender: TObject);
begin
     DataModule1.RankingQuery.Close;
     DataModule1.RankingQuery.open;
   dados.Refresh;
end;
                                     // DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Insert into Pontuacao' +
    //' (ID_Professor, ID_Jogo, Nome_Aluno, Numero_Aluno' +
    //', Serie_Aluno, Pontuacao, Data)' +
    //' Values (:A, :B, :C, :D, :E, :F, :G)');
procedure TRanking.SetData();
begin
  //DataModule1.RankingQuery.SQL.Clear();
 // DataModule1.RankingQuery.SQL.Add('SELECT Jogo.Nome As Jogo, Pontuacao.Nome_Aluno, Pontuacao.Numero_Aluno, Pontuacao.Serie_Aluno, Pontuacao.Pontuacao ' +
            // 'FROM Jogo INNER JOIN Pontuacao ON Jogo.[ID] = Pontuacao.[ID_Jogo] ' +
            // 'WHERE (((Pontuacao.ID_Jogo)=' + IntToStr(Jogo) + ') AND ((Pontuacao.Serie_Aluno) = "' + Serie +'") AND ((Pontuacao.Data) Between #' + DateToStr(De) + '# And #' + DateToStr(Ate) + '#)) ' +
           //  ';');
  //DataModule1.RankingQuery.Active := True;
  //DataModule1.RankingQuery.ExecSQL();
  //SetTitleNames()
end;

function TRanking.Command(Order: String) : String;
begin
  Result := 'SELECT Jogo.Nome As Jogo, Pontuacao.Nome_Aluno, Pontuacao.Numero_Aluno, Pontuacao.Serie_Aluno, Pontuacao.Pontuacao ' +
             'FROM Jogo INNER JOIN Pontuacao ON Jogo.[ID] = Pontuacao.[ID_Jogo] ' +
             'WHERE (((Pontuacao.ID_Jogo)=' + IntToStr(Jogo) + ') AND ((Pontuacao.Serie_Aluno) = "' + Serie +'") AND ((Pontuacao.Data) Between #' + DateToStr(De) + '# And #' + DateToStr(Ate) + '#)) ' +
             'ORDER BY ' + Order + ';';
end;

end.
