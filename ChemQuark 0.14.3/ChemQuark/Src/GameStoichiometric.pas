unit GameStoichiometric;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, pngimage, DB_Integrator, Tabela, Sound,
  Vcl.MPlayer;

type
  TCalculoEstequiometrico = class(TForm)
    Background: TImage;
    ReagenteBalanceado: TEdit;
    PictureReagente: TImage;
    Reagente: TLabel;
    Reagente_Massa: TLabel;
    Produto: TLabel;
    Produto_Massa: TLabel;
    FixNaoBalanceada: TLabel;
    EquacaoNaoBalanceada: TLabel;
    Fonte: TTimer;
    FixReagente: TLabel;
    FixProduto: TLabel;
    Seta: TLabel;
    PictureProduto: TImage;
    ProdutoBalanceado: TEdit;
    FixMassaMolar: TLabel;
    MassaReagente: TLabel;
    MassaProduto: TLabel;
    PictureMassaReagente: TImage;
    AnswerMassaReagente: TEdit;
    AnswerMassaProduto: TEdit;
    PictureMassaProduto: TImage;
    FixFinalAnswer: TLabel;
    AnswerFinalAnswer: TEdit;
    PictureFinalAnswer: TImage;
    CheckReagente: TImage;
    CheckMassaReagente: TImage;
    CheckMassaProduto: TImage;
    CheckProduto: TImage;
    CheckFinalAnswer: TImage;
    Fix_Pontuacao: TLabel;
    AutoPontuacao: TLabel;
    CheckFinished: TImage;
    FadeOut: TImage;
    PicturePoints: TImage;
    Rodada_X: TLabel;
    X: TLabel;
    Pontuacao: TLabel;
    CountIntervalPoint: TTimer;
    Rodada: TImage;
    Label_Rodada: TLabel;
    Fix_Rodada: TLabel;
    FixBalanceada: TLabel;
    Control: TTimer;
    ToTable: TImage;
    Forfeit: TImage;
    MediaPlayer1: TMediaPlayer;
    RankTimer: TTimer;
    JogarNovamente: TImage;
    Sair: TImage;
    btn_Manual: TImage;
    lbl_status: TLabel;
    procedure FonteTimer(Sender: TObject);
    procedure SolveFont( Edit : TEdit );
    procedure ChangeFocus( ID : Byte );
    procedure MakeAllInOne;
    procedure UpdateChecker(ID : Byte);
    procedure ChangePictureToMaybe(ID : Byte);
    procedure ChangePicture(ID : Byte);
    procedure OnClickAnswer(Sender: TObject);
    procedure FadeOutAll();
    procedure UpdateFinishedSelect();
    procedure FadeInAll();
    procedure ShowPoint();
    procedure CountIntervalPointTimer(Sender: TObject);
    procedure HidePoints();
    procedure ShowTime();
    procedure StartNewTime();
    procedure AnswerFinalAnswerKeyPress(Sender: TObject; var Key: Char);
    procedure ContolTheControllerTimer(Sender: TObject);
    procedure UpdatePoints( ID : Byte; Kind : Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ControlTimer(Sender: TObject);
    procedure MakeRandomWeight();
    procedure CallMe();
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OnClick(Sender: TObject);
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Change_Forfeit_Picture();
    function GetMaxTurn() : Integer;
    procedure JogarNovamenteClick(Sender: TObject);
    procedure SairClick(Sender: TObject);
    procedure JogarNovamenteMouseEnter(Sender: TObject);
    procedure JogarNovamenteMouseLeave(Sender: TObject);
    procedure SairMouseEnter(Sender: TObject);
    procedure SairMouseLeave(Sender: TObject);
    procedure btn_ManualClick(Sender: TObject);
    procedure btn_ManualMouseEnter(Sender: TObject);
    procedure btn_ManualMouseLeave(Sender: TObject);

  private
    { Private declarations }


  public
    { Public declarations }
    var Times  : Byte;
        InTest : Boolean;
        Test   : Array[1..7] of String;
  end;

var
  CalculoEstequiometrico: TCalculoEstequiometrico;
  Answers  : Array[1..5] of TEdit;
  Checkers : Array[1..5] of TImage;
  WhoFocused : Byte = 1;
  CanFinish : Boolean = False;
  Cursor : Byte = 1;
  CanShowPoints : Boolean = False;
  TimePoints : Short = 0;
  TotalPoints : Integer = 0;
  Count : Byte = 0;
  CanShowTime : Boolean = True;
  CannotupdateControl : Boolean = False;
  Question : Integer = 0;
  Reply : Array[1..5] of String;
  Final_Reply : Array[1..3] of Real;
  CorrectAnswers : Array[1..5] of Byte;
  CanStopTheGame : Boolean = false;
  WaitingTime : Byte = 5;
  MaxTurn : Byte = 5;
  AlreadyPlayed : Array of Integer;

implementation

uses SendingPoints, Insert_Stoichiometric, Menu;

{$R *.dfm}


function TCalculoEstequiometrico.GetMaxTurn;
begin
  Result := MaxTurn;
end;

//------------------------------------------------------------------------------
// * Altera a imagem de desistência
//    Kind : Opção
//------------------------------------------------------------------------------
procedure TCalculoEstequiometrico.Change_Forfeit_Picture();
begin
  // Executa efeito sonoro de cursor
  Sound.Play_Cursor(1);
  // Altera imagem de desistência
  With Forfeit.Picture do
    LoadFromFile('Graphics/System/Forfeit_' + IntToStr(Cursor) + '.png');
end;

procedure TCalculoEstequiometrico.MakeRandomWeight();
var I, K : Byte;
begin
  Final_Reply[1] := 0;
  Final_Reply[2] := 0;
  for K := 1 to 2 do
    while Final_Reply[K] = 0 do
      Final_Reply[K] := Random(10000);

      if I <= 5 then
      begin
        Reagente_Massa.Caption := FloatToStr(Final_Reply[1]) + ' gramas';
        Produto_Massa.Caption  := '?';
        Final_Reply[3] := StrToFloat(Reply[4]) * Final_Reply[1] / StrToFloat(Reply[3]);
      end
      else
      begin
        Produto_Massa.Caption  := FloatToStr(Final_Reply[2]) + ' gramas';
        Reagente_Massa.Caption := '?';
        Final_Reply[3] := StrToFloat(Reply[3]) * Final_Reply[2] / StrToFloat(Reply[4]);
      end;
    Reply[5] := FloatToStr(Final_Reply[3]);
end;

procedure TCalculoEstequiometrico.UpdatePoints( ID : Byte; Kind : Boolean );
var I     : Byte;
 var name, numero_aluno,serie_aluno : string; var total_points: integer;
begin

  TimePoints := 0;
  Count := 0;
  if Kind then
    CorrectAnswers[ID] := 20
  else
    CorrectAnswers[ID] := 0;

  for I := 1 to 5 do
    TimePoints  := TimePoints + CorrectAnswers[I];

  AutoPontuacao.Caption := IntToStr(TimePoints + TotalPoints);
  if db_integrator.Mode=2 then
  begin
  total_points:= TimePoints + TotalPoints;
  //DEFINE VARIAVEIS PARA INSERIR NO BD
  name := SendingPoints.SendingPoint.Name.Text+'-Cálculos Estequiometricos';
    numero_aluno :=  SendingPoints.SendingPoint.Number.Text;
    serie_aluno := SendingPoints.SendingPoint.Room.Text;
        DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;


     // INSERIR CÓDIGO DE ATUALIZAÇÃO DO BANCO AQUI '-'
      DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Insert into Pontuacao' +
    ' (ID_Professor, ID_Jogo, Nome_Aluno, Numero_Aluno' +
    ', Serie_Aluno, Pontuacao, Data)' +
    ' Values (1, 3,'''+name+''','''+numero_aluno+''','''+serie_aluno+''','+inttostr(total_points)+','+ datetostr(date)+')');
           //Values (:A, :B, :C, :D, :E, :F, :G)');
    DataModule1.ADOQuery1.ExecSQL();
   // É ESSA LINHAA
       end;

end;

procedure TCalculoEstequiometrico.StartNewTime();
var I, K, J : Byte;
begin
  for I := 1 to 5 do
  begin
    Checkers[I].Visible := False;
    self.ChangePictureToMaybe(I);
    Answers[I].Clear();
  end;
  Checkers[1].Visible := True;

  if InTest then
  begin
    EquacaoNaoBalanceada.Caption := ChemistryFormat(Test[1]);
    Reagente.Caption := ChemistryFormat(Test[2]);
    Produto.Caption  := ChemistryFormat(Test[3]);
    Reply[1] := Test[4];
    Reply[2] := Test[5];
    Reply[3] := Test[6];
    Reply[4] := Test[7];
    MassaReagente.Caption := ChemistryFormat(Test[2]);
    MassaProduto.Caption  := ChemistryFormat(Test[3]);
    MakeRandomWeight();
    Exit();
  end;
  I := 0;
  while I = 0 do
    I := Random(10);

  DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
  DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Select Count(*) as ID from' +
                                              ' Estequiometrico');
  DataModule1.Adoquery1.Active := True;
  DataModule1.Adoquery1.ExecSQL;

  Question := 0;
  while Question = 0 do
  begin
    Question := Random(DataModule1.ADOQuery1.FieldByName('ID').AsInteger);
    for J := 1 to 5 do
      if Question = AlreadyPlayed[J] then
        Question := 0;
  end;

  AlreadyPlayed[Times] := Question;

  // -------------------------------------------------------------------------- //

  DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
  DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Select EquacaoNaoBalanceada from' +
                           ' Estequiometrico where ID = ' + IntToStr(Question));
  DataModule1.Adoquery1.Active := True;
  DataModule1.Adoquery1.ExecSQL;
  with EquacaoNaoBalanceada do
    Caption := ChemistryFormat(DataModule1.Adoquery1.FieldByName('' +
               'EquacaoNaoBalanceada').AsString);
  // -------------------------------------------------------------------------- //

  DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
  DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Select ReagenteBalanceado from' +
                           ' Estequiometrico where ID = ' + IntToStr(Question));
  DataModule1.Adoquery1.Active := True;
  DataModule1.Adoquery1.ExecSQL;
  Reply[1] := DataModule1.ADOQuery1.FieldByName('ReagenteBalanceado').AsString;

  // -------------------------------------------------------------------------- //

  DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
  DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Select MassaReagente from' +
                           ' Estequiometrico where ID = ' + IntToStr(Question));
  DataModule1.Adoquery1.Active := True;
  DataModule1.Adoquery1.ExecSQL;
  Reply[3] := FloatToStr(Round(RemovePoints(DataModule1.ADOQuery1.FieldByName(''
                                          + 'MassaReagente').AsString)));

  // -------------------------------------------------------------------------- //

  DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
  DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Select MassaProduto from' +
                           ' Estequiometrico where ID = ' + IntToStr(Question));
  DataModule1.Adoquery1.Active := True;
  DataModule1.Adoquery1.ExecSQL;
  Reply[4] := FloatToStr(Round(RemovePoints(DataModule1.ADOQuery1.FieldByName(''
                                                + 'MassaProduto').AsString)));

  // -------------------------------------------------------------------------- //

  DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
  DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Select ProdutoBalanceado from' +
                           ' Estequiometrico where ID = ' + IntToStr(Question));
  DataModule1.Adoquery1.Active := True;
  DataModule1.Adoquery1.ExecSQL;
  Reply[2] := DataModule1.ADOQuery1.FieldByName('ProdutoBalanceado').AsString;

  // -------------------------------------------------------------------------- //
  MakeRandomWeight();
  // -------------------------------------------------------------------------- //

  DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
  DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Select Reagente from' +
                           ' Estequiometrico where ID = ' + IntToStr(Question));
  DataModule1.Adoquery1.Active := True;
  DataModule1.Adoquery1.ExecSQL;
  with Reagente do
    Caption := ChemistryFormat(DataModule1.Adoquery1.FieldByName('' +
               'Reagente').AsString) + ': ';
  with MassaReagente do
    Caption := ChemistryFormat(DataModule1.Adoquery1.FieldByName('' +
               'Reagente').AsString);

  // -------------------------------------------------------------------------- //
  DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
  DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Select Produto from' +
                           ' Estequiometrico where ID = ' + IntToStr(Question));
  DataModule1.Adoquery1.Active := True;
  DataModule1.Adoquery1.ExecSQL;
  with Produto do
    Caption := ChemistryFormat(DataModule1.Adoquery1.FieldByName('' +
               'Produto').AsString) + ': ';
  with MassaProduto do
    Caption := ChemistryFormat(DataModule1.Adoquery1.FieldByName('' +
               'Produto').AsString);

end;

procedure TCalculoEstequiometrico.ShowTime();
begin
  if Times >= MaxTurn + 1 then
    Exit();
  Fonte.Enabled := False;
  Control.Enabled := False;
  CannotUpdateControl := True;
  FadeOutAll();
  Rodada.Visible := True;
  Fix_Rodada.Visible := True;
  with Label_Rodada do
    if InTest then
      Caption := 'de Teste'
    else
      if Times >= MaxTurn then
      begin
        Caption := 'Final';
        Play_Me('FinalMatch.wav');
      end
      else
      begin
        Caption := IntToStr(Times);
        Play_Me('Match.wav');
      end;
  Label_Rodada.Visible := True;
  CanShowTime := False;
  CountIntervalPoint.Enabled := True;
  WaitingTime := 3;
  StartNewTime();
end;

procedure TCalculoEstequiometrico.SairClick(Sender: TObject);
begin
    // Cria uma instância da classe de seleção de jogos
          Inicio := TInicio.Create(Application);
          // Exibe o formulário
          Inicio.Show();
          // Deleta a instância e chama o Garbage Collector
          FreeAndNil(Self);
end;

procedure TCalculoEstequiometrico.SairMouseEnter(Sender: TObject);
begin
Sair.Picture.LoadFromFile('Graphics/Button/sair_on.png');
end;

procedure TCalculoEstequiometrico.SairMouseLeave(Sender: TObject);
begin
Sair.Picture.LoadFromFile('Graphics/Button/sair.png');
end;

procedure TCalculoEstequiometrico.ShowPoint();
var I : Byte;
begin
  WaitingTime := 7;
  for I := 1 to 5 do
    CorrectAnswers[I] := 0;
  TotalPoints := TotalPoints + TimePoints;   // Usar TotalPoints no BD Real
  CannotUpdateControl := True;
  CheckFinished.Visible := False;
  if Times >= MaxTurn then
  begin
    WaitingTime := 10;
    Play_Me('FinalGame.wav');
    With X do
      if InTest then
        Caption := 'Rodada de Teste'
      else
        Caption := 'Rodada Final';
    CanStopTheGame := True;
     if totalpoints<=1 then  begin;
            btn_Manual.Visible:=true;
            btn_Manual.enabled:=true;
             lbl_status.caption := 'Você não foi bem. Se tiver dúvidas acesse o manual do jogo  :) ';
              lbl_status.Visible:= true;
            end
            else if totalpoints>=5 then begin
              lbl_status.Caption:='Parabéns ! Você teve um ótimo desempenho :)';
              lbl_status.Font.Color:= clgreen;
                                    lbl_status.Visible:= true;
            end;
  end
  else
    if InTest then
      X.Caption := 'Rodada de Teste'
    else
      X.Caption := 'Rodada ' + IntToStr(Times);
  Pontuacao.Caption := IntToStr(TotalPoints);
  PicturePoints.Visible := True;
  X.Visible := True;
  Rodada_X.Visible := True;
  Pontuacao.Visible := True;
  CountIntervalPoint.Enabled := True;
  Times := Times + 1;
  CanShowTime := True;


JogarNovamente.Visible:= true;
JogarNovamente.enabled:= true;
sair.Visible:= true;
sair.Enabled:= true;
end;

procedure TCalculoEstequiometrico.HidePoints();
var I : Byte;
begin
  CountIntervalPoint.Enabled := False;
  Rodada.Visible := False;
  Fix_Rodada.Visible := False;
  Label_Rodada.Visible := False;
  PicturePoints.Visible := False;
  X.Visible := False;
  Rodada_X.Visible := False;
  Pontuacao.Visible := False;
  FadeInAll();
  for I := 2 to 5 do
    with Answers[I] do
    begin
      Visible := False;
      Enabled := False;
    end;
     JogarNovamente.Visible:= false;
JogarNovamente.enabled:= false;
sair.Visible:= false;
sair.Enabled:= false;
end;

procedure TCalculoEstequiometrico.JogarNovamenteClick(Sender: TObject);
begin
lbl_status.Visible:= false;
btn_manual.Visible := false;
btn_manual.enabled := false;
callme();
startnewtime();
end;

procedure TCalculoEstequiometrico.JogarNovamenteMouseEnter(Sender: TObject);
begin
 JogarNovamente.Picture.LoadFromFile('Graphics/Button/jogar_novamente_on.png');
end;

procedure TCalculoEstequiometrico.JogarNovamenteMouseLeave(Sender: TObject);
begin
 JogarNovamente.Picture.LoadFromFile('Graphics/Button/jogar_novamente.png');
end;

procedure TCalculoEstequiometrico.FadeInAll();
var I : Byte;
begin
  for I := 1 to 5 do
    with Answers[I] do
    begin
      Visible := True;
      Enabled := True;
    end;
  Fonte.Enabled := True;
  FadeOut.Visible := False;
  CheckFinished.Visible := False;
  Answers[1].SetFocus();
  CannotUpdateControl := False;
  CanFinish := False;
end;

procedure TCalculoEstequiometrico.UpdateFinishedSelect;
begin
  case Cursor of
  1: CheckFinished.Picture.LoadFromFile('Graphics/Estequiométrico/Message/PopUp_1.png');
  2: CheckFinished.Picture.LoadFromFile('Graphics/Estequiométrico/Message/PopUp_2.png');
  end;
end;

procedure TCalculoEstequiometrico.FadeOutAll();
var I : Byte;
begin
  Fonte.Enabled := False;
  for I := 1 to 5 do
    with Answers[I] do
    begin
      Visible := False;
      Enabled := False;
    end;
  FadeOut.Visible := True;
  CanFinish := True;
end;


procedure TCalculoEstequiometrico.ChangePictureToMaybe(ID: Byte);
begin
  Checkers[ID].Picture.LoadFromFile('Graphics/Estequiométrico/Incerto.png');
end;

procedure TCalculoEstequiometrico.ContolTheControllerTimer(Sender: TObject);
begin
  if (Answers[1].Focused) or (Answers[2].Focused) then
    Fonte.Enabled := True
  else
    Fonte.Enabled := False;

end;

procedure TCalculoEstequiometrico.ControlTimer(Sender: TObject);
begin

  if CanFinish then
    if GetAsyncKeyState(VK_Right) <> 0 then
      begin
        Play_Cursor(1);
        case Cursor of
        1 : Cursor := 2;
        2 : Cursor := 1;
        end;
        UpdateFinishedSelect();
      end
      else if GetAsyncKeyState(VK_Left) <> 0 then
      begin
        Play_Cursor(1);
        case Cursor of
        1 : Cursor := 2;
        2 : Cursor := 1;
        end;
        UpdateFinishedSelect();
      end;
end;

procedure TCalculoEstequiometrico.CountIntervalPointTimer(Sender: TObject);
begin
  Count := Count + 1;
  if Count = WaitingTime then
  begin
    HidePoints();
    Control.Enabled := True;
    Fonte.Enabled := True;
    Count := 0;
    if CanStopTheGame then
    begin
      if InTest then
      begin
        InsertStoichiometric.Show();
        FreeAndNil(Self);
        Exit();
      end
      else
      begin
        // Avaliação
        if DB_Integrator.Mode = 1 then
        begin
          // Criação do Formulário
          SendingPoint := TSendingPoint.Create(Application);
          // Define valores
          SendingPoint.SetData(3, TotalPoints, 1);
          SendingPoint.Show();
          FreeAndNil(CalculoEstequiometrico);
        end
        else
        begin
          // Cria uma instância da classe de seleção de jogos
          Inicio := TInicio.Create(Application);
          // Exibe o formulário
          Inicio.Show();
          // Deleta a instância e chama o Garbage Collector
          FreeAndNil(Self);
        end;
      end;
    end;
  end;
  if CanShowTime then
  begin
    ShowTime();
    CanShowTime := False;
  end;
end;

procedure TCalculoEstequiometrico.ChangePicture(ID: Byte);
var ToWhere : Boolean;
var Answer : Array[1..3] of Real;
begin
  ToWhere := False;
  if ID < 3 then
  begin
    if SpaceDelete(Answers[ID].Text) = SpaceDelete(ChemistryFormat(Reply[ID])) then
      ToWhere := True
    else
      ToWhere := False;
  end
   else
   begin
     Answer[ID - 2] := RemovePoints(Answers[ID].Text);
     if Round(Answer[ID - 2]) = Round(RemovePoints( Reply[ID] )) then
       ToWhere := True
     else
       ToWhere := False;
   end;




  if ToWhere then
  begin
    Play_Decision(2);
    UpdatePoints(ID, True);
    Checkers[ID].Picture.LoadFromFile('Graphics/Estequiométrico/Certo.png')
  end
  else
  begin
    Play_Error();
    UpdatePoints(ID, False);
    Checkers[ID].Picture.LoadFromFile('Graphics/Estequiométrico/Errado.png');
  end;

end;

procedure TCalculoEstequiometrico.UpdateChecker(ID: Byte);
begin
  ChangePicture(ID - 1);
  Checkers[ID].Visible := True;
  ChangePictureToMaybe(ID);
end;

procedure TCalculoEstequiometrico.MakeAllInOne;
begin
  Answers[1]  := ReagenteBalanceado;
  Answers[2]  := ProdutoBalanceado;
  Answers[3]  := AnswerMassaReagente;
  Answers[4]  := AnswerMassaProduto;
  Answers[5]  := AnswerFinalAnswer;
  Checkers[1] := CheckReagente;
  Checkers[2] := CheckProduto;
  Checkers[3] := CheckMassaReagente;
  Checkers[4] := CheckMassaProduto;
  Checkers[5] := CheckFinalAnswer;
end;

procedure TCalculoEstequiometrico.OnClick(Sender: TObject);
begin
  Tabela.Gambz_[1] := 0;
  Fonte.Enabled := False;
  Play_Decision(1);
  PeriodicTable := TPeriodicTable.Create(Self);
  Tabela.PeriodicTable.Show();
  Tabela.PeriodicTable.Enabled := true;
  Tabela.PeriodicTable.Visible := true;
  Tabela.PeriodicTable.ActiveForm := true;
  Tabela.PeriodicTable.CursorIndex := Tabela.PeriodicTable.SaveCursorIndex;
  Tabela.WhereTo := 2;
  Self.Hide();
end;

procedure TCalculoEstequiometrico.OnClickAnswer(Sender: TObject);
var I : Byte;
begin
  for I := 1 to 5 do
    if Answers[I].Focused then
    begin
      if I <> WhoFocused then
      begin
        ChangePicture(WhoFocused);
        ChangePictureToMaybe(I);
        WhoFocused := I;
      end;
    end;
end;

procedure TCalculoEstequiometrico.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var I : Byte;
begin
    // Se a tela de desistência estiver visível
  if Forfeit.Visible then
  begin
    // Se a seta direita for pressionada
    if Key = VK_Right then
    begin
      case Cursor of
      1: Cursor := 2;
      2: Cursor := 1;
      end;
      // Altera a imagem
      Change_Forfeit_Picture();
    end

    // Se a seta esquerda for pressionada
    else if Key = VK_Left then
    begin
      case Cursor of
      1: Cursor := 2;
      2: Cursor := 1;
      end;
      // Altera a imagem
      Change_Forfeit_Picture();
    end

    // Se a tecla escape for pressionada
    else if Key = VK_ESCAPE then
    begin
      // Se continuar no jogo foi selecionado
      if Cursor = 1 then
      begin
        for I := 2 to 5 do
          with Answers[I] do
          begin
            if Text <> '' then
            begin
              Visible := True;
              Enabled := True;
            end;
          end;
        // Torna o primeiro campo visível, acessível e focado.
        Answers[1].Visible := True;
        Answers[1].Enabled := True;
        Answers[1].SetFocus();
        // Invisibiliza a janela de escolhas
        Forfeit.Visible   := False;
      end;
    end

    // Se a tecla Enter for pressionada
    else if Key = VK_Return then
    begin
      // Executa efeito sonoro de confirmação
      Sound.Play_Decision(1);
      // Se continuar no jogo foi selecionado
      if Cursor = 1 then
      begin
        for I := 2 to 5 do
          with Answers[I] do
          begin
            if Text <> '' then
            begin
              Visible := True;
              Enabled := True;
            end;
          end;
        // Torna o primeiro campo visível, acessível e focado.
        Answers[1].Visible := True;
        Answers[1].Enabled := True;
        Answers[1].SetFocus();
        // Invisibiliza a janela de escolhas
        Forfeit.Visible   := False;
      end
      // Se a opção de desistir foi selecionada
      else if Cursor = 2 then
      begin
        if InTest then
        begin
          InsertStoichiometric.Show();
          FreeAndNil(Self);
          Exit();
        end
        else
        begin
          // Cria uma instância da classe de seleção de jogos
          Inicio := TInicio.Create(Application);
          // Exibe o formulário
          Inicio.Show();
          // Deleta a instância e chama o Garbage Collector
          FreeAndNil(Self);
        end;
      end;
    end;

  end;
end;

procedure TCalculoEstequiometrico.btn_ManualClick(Sender: TObject);
begin
             Inicio := TInicio.Create(Application);
          // Exibe o formulário
          inicio.mode:=5;
          inicio.Cursor:=3;

          Inicio.Show();


          // Deleta a instância e chama o Garbage Collector
          FreeAndNil(Self);
end;

procedure TCalculoEstequiometrico.btn_ManualMouseEnter(Sender: TObject);
begin
btn_manual.Picture.LoadFromFile('Graphics/Button/Manual_on.png');
end;

procedure TCalculoEstequiometrico.btn_ManualMouseLeave(Sender: TObject);
begin
btn_manual.Picture.LoadFromFile('Graphics/Button/Manual.png');
end;

procedure TCalculoEstequiometrico.CallMe();
var I : Byte;
begin
  ShowCursor(True);
  Cursor := 2;
  CanStopTheGame := False;
  MakeAllInOne();
  ShowTime();
  WhoFocused := 1;
  CanFinish := False;
  CanShowPoints := False;
  Times := 1;
  Count := 0;
  CanShowTime := True;
  CannotupdateControl := False;
  Question := 0;
  CanStopTheGame := false;
  TimePoints := 0;
  TotalPoints := 0;
  for I := 1 to 5 do
    CorrectAnswers[I] := 0;
end;

procedure TCalculoEstequiometrico.AnswerFinalAnswerKeyPress(Sender: TObject; var Key: Char);
var I : Byte;
var Check : Boolean;
begin
  Check := False;
  if ( Key = #13 ) then
  begin
    Key := #0;
    for I := 1 to 5 do
      if Answers[I].Focused then
      begin
        ChangeFocus(I + 1);
        Exit();
      end;
  end;

  for I := 1 to 5 do
    if Answers[I].Focused then
      Check := True;

  if not Check then
    Exit();

  if ( Key = #27 ) then
  begin
    Key := #0;
    for I := 1 to 5 do
      with Answers[I] do
      begin
        Visible := False;
        Enabled := False;
      end;
    // Executa efeito sonoro de cancelamento.
    Sound.Play_Cancel();
    if Forfeit.Visible then
      Exit;
    Forfeit.Visible := True;
    Cursor := 1;
  end;

end;

procedure TCalculoEstequiometrico.ChangeFocus( ID : Byte );
begin
  if ID = 6 then
  begin
    ChangePicture(ID - 1);
    FadeOutAll();
    CheckFinished.Visible := True;
    Cursor := 2;
    UpdateFinishedSelect();
    Exit();
  end;
  WhoFocused := ID;
  Answers[ID].Enabled := True;
  Answers[ID].Visible := True;
  Answers[ID].SetFocus;
  UpdateChecker(ID)
end;

procedure TCalculoEstequiometrico.SolveFont(Edit: TEdit);
var Active : Boolean;
    Active_ : Array[0..9] of Boolean;
    I : Integer;
begin
   if GetAsyncKeyState(17) <> 0 then
    Active := True
   else
    Active := False;

     for I := 0 to 9 do
     begin
       if GetAsyncKeyState(48 + I) <> 0 then
        Active_[I] := True
       else
        Active_[I] := False;
       if (Active) and (Active_[I]) then
       begin
         case I of
         0: Edit.Text := Edit.Text + 'Í';
         1: Edit.Text := Edit.Text + 'Ì';
         2: Edit.Text := Edit.Text + '¿';
         3: Edit.Text := Edit.Text + 'À';
         4: Edit.Text := Edit.Text + 'Á';
         5: Edit.Text := Edit.Text + 'Â';
         6: Edit.Text := Edit.Text + 'Ã';
         7: Edit.Text := Edit.Text + 'Î';
         8: Edit.Text := Edit.Text + 'Ï';
         9: Edit.Text := Edit.Text + 'ß';
         end;
         Keybd_Event(VK_END,0,0,0);
       end;
     end;

end;

procedure TCalculoEstequiometrico.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);

  MediaPlayer1.close;
end;

procedure TCalculoEstequiometrico.FormCreate(Sender: TObject);
begin
lbl_status.Visible:= false;
btn_manual.Visible := false;
btn_manual.enabled := false;
JogarNovamente.Visible:= false;
JogarNovamente.enabled:= false;
Sair.Enabled:=false;
Sair.Visible:= false;
  PerformForm(Self);
  SetLength( AlreadyPlayed, MaxTurn + 1 );
end;

procedure TCalculoEstequiometrico.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if CanFinish then
    if Key = #13 then
    begin
      if ( CannotUpdateControl ) then
        Exit();
      Play_Decision(1);
      CanFinish := False;
      case Cursor of
      1: ShowPoint();
      2: FadeInAll();
      end;
    end;
end;

procedure TCalculoEstequiometrico.FormShow(Sender: TObject);
begin

  Fonte.Enabled := True;

  MediaPlayer1.open;
MediaPlayer1.play;
end;

procedure TCalculoEstequiometrico.FonteTimer(Sender: TObject);
var I : Byte;
begin
  if ReagenteBalanceado.Focused then
    SolveFont(ReagenteBalanceado)
  else if ProdutoBalanceado.Focused then
    SolveFont(ProdutoBalanceado);

end;

end.
