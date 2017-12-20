unit Solubilidade;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, math, ExtCtrls, pngimage, jpeg, MPlayer, MMSystem;


type
  TSoluct = class(TForm)
    BackGround: TImage;
    PictureFixed: TImage;
    Data: TLabel;
    DataSoluto: TLabel;
    AnswerSoluto: TEdit;
    AnswerSolvente: TEdit;
    Start: TImage;
    MultimediaTable: TPanel;
    Player_1: TMediaPlayer;
    Player_2: TMediaPlayer;
    Player_3: TMediaPlayer;
    Player_4: TMediaPlayer;
    Player_5: TMediaPlayer;
    AfterMathPicture: TImage;
    Rodada: TLabel;
    Pontos: TLabel;
    PicturePoint: TImage;
    RodadaPoint: TLabel;
    Forfeit: TImage;
    Final_Points: TImage;
    Points: TLabel;
    procedure OnCreate(Sender: TObject);
    procedure OnClose(Sender: TObject; var Action: TCloseAction);
    procedure SetCoeficiente();
    procedure FormatData();
    procedure FormatSubstance();
    procedure SetSize( Sender : TLabel );
    procedure SetResult();
    procedure SetKind();
    function  FormatResult( Value : Double ) : String;
    procedure ShowResult();
    procedure OnMouseEnter(Sender: TObject);
    procedure SetButtonState( Kind : Byte );
    procedure OnMouseLeave(Sender: TObject);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StartClick(Sender: TObject);
    procedure SetMask();
    function RemoveLetter( Text : String ) : String;
    function RemovePoints( Text : String ) : String;
    function FormatAnswer( Text : String ) : String;
    procedure SetVideo();
    procedure CreateMultimedia();
    procedure MakeWaiting();   
    procedure Initialize();
    procedure ShowTurn();
    procedure AfterMath( Kind : Byte );
    procedure UpdatePoint( Sum : Integer );
    procedure Reset();
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure Change_Forfeit_Picture();
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ChangeAnswer( Kind : Boolean );
    procedure ChangeEnabled();
    procedure ShowFinished();
    procedure Player_5Click(Sender: TObject; Button: TMPBtnType;
      var DoDefault: Boolean);
    procedure OpenMultimedia( Index : Byte );
    procedure FormShow(Sender: TObject);
  private
    { Private Declarations }
  public
    ID         : Integer;
    Solvente   : Double;
    Soluto     : Double;

    { Soluto -> True / Solvente -> False }
    Kind       : Boolean;
    Coeficiente : Double;
    DataPorVolume   : Double;
    Turn  : Byte;
    Point : Integer;
    Cursor: Byte;
  end;

var
  Soluct: TSoluct;
  Numbers : Array[1..11] of String;
  Players : Array[1..5] of TMediaPlayer;
  MaxTurn : Byte = 1;
implementation

uses DB_Integrator, Sound, Menu, SendingPoints;

{$R *.dfm}

procedure TSoluct.OpenMultimedia(Index: Byte);
begin
  Players[Index].Open();
end;

procedure TSoluct.ShowFinished();
var I : Integer;
begin
 db_integrator.mode:=2;

  Sound.Play_Me('FinalGame.wav');
  // Torna as respostas invisíveis
  ChangeAnswer( False );
  // Torna o painel de vídeo invisível
  MultimediaTable.Visible := False;
  // Torna a imagem de escolha de desistência visível
  Final_Points.Visible := True;
  Points.Caption := IntToStr(Point);
  Points.Visible := True;
  for I := 0 to 150 do
    Soluct.Refresh();

  // Se modo Avaliação
  if DB_Integrator.Mode = 1 then
  begin
    // Criação do Formulário
    SendingPoint := TSendingPoint.Create(Application);
    // Define valores
    SendingPoint.SetData(4, Point, 1);
    // Exibe o formulário
    Self.Hide();
    SendingPoint.Show();
  end
  // Se modo livre
  Else if DB_Integrator.Mode = 2 then  begin;

  begin
    // Cria uma instância da classe de seleção de jogos
    Inicio := TInicio.Create(Application);
    // Exibe o formulário
    Self.Hide();
    Inicio.Show
  end;
  end;
  Exit();
end;

procedure TSoluct.ChangeEnabled();
begin
  if Kind then
    AnswerSolvente.SetFocus()
  else
    AnswerSoluto.SetFocus();
end;

procedure TSoluct.ChangeAnswer(Kind: Boolean);
begin
  AnswerSolvente.Visible := Kind;
  AnswerSoluto.Visible := Kind;
end;

procedure TSoluct.UpdatePoint( Sum : Integer );
begin
  Point := Point + Sum;
  Pontos.Caption := IntToStr(Point);
  RodadaPoint.Caption := Pontos.Caption;
end;

procedure TSoluct.Reset();
begin
  With AnswerSoluto do
  begin
    Enabled := True;
    Clear();
  end;
  With AnswerSolvente do
  begin
    Enabled := True;
    Clear();
  end;
end;

procedure TSoluct.AfterMath( Kind : Byte );
var I     : Integer;
var Sum   : Integer;
begin
  Sound.Play_SE('Okay');
  if Kind = 1 then
    Sum := 100
  Else
    Sum := 1;
  AfterMathPicture.Picture.LoadFromFile('Graphics/Interface/Resultado/' +
                                        IntToStr(Kind) + '.png');
  MultimediaTable.Visible := False;
  AfterMathPicture.Visible := True;
  for I := 1 to 150 do
    Soluct.Refresh;
  AfterMathPicture.Visible := False;
  Sound.Play_SE('Stare', SND_NOSTOP);
  PicturePoint.Visible := True;
  RodadaPoint.Visible := True;
  for I := 1 to Sum do
  begin
    UpdatePoint( 1 );
    Soluct.Refresh();
  end;
  MultimediaTable.Visible := False;
  PicturePoint.Visible := False;
  RodadaPoint.Visible := False;
  Sound.Play_SE('Clean');
  Initialize();
  if Turn = MaxTurn + 1 then
  begin
    ShowFinished();
    Exit();
  end;
end;

procedure TSoluct.ShowTurn();
begin
  Turn := Turn + 1;
  Rodada.Caption := IntToStr(Turn);
end;

procedure TSoluct.MakeWaiting();
var I : Byte;
begin
  for I := 1 to 5 do
    Players[I].Wait := True;
end;

procedure TSoluct.CreateMultimedia();
var I : Byte;
begin
  //====================
  // Índice de vídeos
  //--------------------
  // Soluto         -> 1
  // Solvente       -> 2
  // Saturada       -> 3
  // Insatura       -> 4
  // Super-saturada -> 5
  //=====================

  Players[1] := Player_1;
  Players[2] := Player_2;
  Players[3] := Player_3;
  Players[4] := Player_4;
  Players[5] := Player_5;

  MakeWaiting();

end;
//------------------------------------------------------------------------------
// * Substitui pontos(.) por vírgulas(,)
//    Text : Texto qualquer
//------------------------------------------------------------------------------
function TSoluct.RemovePoints( Text : String ) : String;
var I : Byte;
begin
  I := 1;
  // Para todos os caracteres do texto
  while I <= Length(Text) do
  begin
    // Se encontrar um ponto(.)
    if Text[I] = '.' then
    begin
      // Delete-o
      Delete(Text,I,1);
      // Insira uma vírgula em seu lugar
      Insert(',',Text,I);
    end;
      // Passa para o próximo caracter
      I := I + 1;
  end;
  // Retorna o texto como valor decimal
  Result := Text;

end;

procedure TSoluct.OnClose(Sender: TObject; var Action: TCloseAction);
begin

  DataModule1.DataModuleDestroy(Self);
end;

procedure TSoluct.OnCreate(Sender: TObject);
begin
  DB_Integrator.PerformForm( Self );
  Turn  := 0;
  Point := 0;
  Initialize();
end;

procedure TSoluct.OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
      // Invisibiliza a janela de escolhas
      Forfeit.Visible   := False;
      Cursor := 1;
      Change_Forfeit_Picture();
      // Torna os campos visíveis
      ChangeAnswer( True );
      // Focaliza a resposta
      ChangeEnabled();
    end
    // Se a tecla Enter for pressionada
    else if Key = VK_Return then
    begin
      // Executa efeito sonoro de confirmação
      Sound.Play_Decision(1);
      // Se continuar no jogo foi selecionado
      if Cursor = 1 then
      begin
        // Invisibiliza a janela de escolhas
        Forfeit.Visible   := False;
        // Torna os campos visíveis
        ChangeAnswer( True );
        // Focaliza a resposta
        ChangeEnabled();
      end
      // Se a opção de desistir foi selecionada
      else if Cursor = 2 then
      begin
        // Cria uma instância da classe de seleção de jogos
        Inicio := TInicio.Create(Application);
        // Exibe o formulário
        Inicio.Show();
        // Destrói a janela atual
        FreeAndNil(Soluct);
      end;

    end;
  end;
end;

procedure TSoluct.OnKeyPress(Sender: TObject; var Key: Char);
begin
  // Se a tecla escape for pressionada
  if Key = #27 then
  begin
    Key := #0;
    // Executa efeito sonoro de cancelamento
    Sound.Play_Cancel();
    // Torna as respostas invisíveis
    ChangeAnswer( False );
    // Torna o painel de vídeo invisível
    MultimediaTable.Visible := False;
    if Forfeit.Visible then
    begin
      Cursor := 1;
      Change_Forfeit_Picture;
    end;
    // Torna a imagem de escolha de desistência visível
    Forfeit.Visible := True;
    // Reseta o cursor
    Cursor := 1;
  end;
end;

//------------------------------------------------------------------------------
// * Altera a imagem de desistência
//    Kind : Opção
//------------------------------------------------------------------------------
procedure TSoluct.Change_Forfeit_Picture();
begin
  // Executa efeito sonoro de cursor
  Sound.Play_Cursor(1);
  // Altera imagem de desistência
  With Forfeit.Picture do
    LoadFromFile('Graphics/System/Forfeit_' + IntToStr(Cursor) + '.png');
end;

procedure TSoluct.Initialize();
begin
  Reset();
  SetMask();
  SetCoeficiente();
  FormatData();
  FormatSubstance();
  SetKind();
  SetResult();
  ShowResult();
  SetVideo();
  CreateMultimedia();
  ShowTurn();
  UpdatePoint( 0 );
end;

procedure TSoluct.SetVideo();
begin
  With PictureFixed.Picture do
  if Kind then
    LoadFromFile('Graphics/Animações(Final)/Imagens/Solvente.jpg')
  else
    LoadFromFile('Graphics/Animações(Final)/Imagens/Soluto.jpg');
end;


function TSoluct.RemoveLetter(Text: String) : String;
var I, J : Byte;
var Can  : Boolean;
begin
  I := 1;
  while I <= Length(Text) do
  begin
    Can   := True;
    for J := 1 to 11 do
      if ( Text[I] = Numbers[J] ) then
        Can := False;

    if Can then
      Delete(Text, I, 1)
    else
      I := I + 1;
  end;
  Result := Text;
end;

procedure TSoluct.SetMask();
var I : Byte;
begin
  for I := 1 to 10 do
    Numbers[I] := Chr( 47 + I );

  Numbers[11] := ',';
end;

procedure TSoluct.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetButtonState(3);
end;

procedure TSoluct.OnMouseEnter(Sender: TObject);
begin
  Sound.Play_Cursor(1);
  SetButtonState(2);
end;

procedure TSoluct.OnMouseLeave(Sender: TObject);
begin
  SetButtonState(1);
end;

procedure TSoluct.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetButtonState(1);
end;

procedure TSoluct.Player_5Click(Sender: TObject; Button: TMPBtnType;
  var DoDefault: Boolean);
begin

end;

// Define a imagem do botão de confirmação
procedure TSoluct.SetButtonState(Kind: Byte);
begin
  Start.Picture.LoadFromFile('Graphics/Interface/Principal/' +
                              IntToStr(Kind) + '.png');
end;

procedure TSoluct.ShowResult();
begin
  if Kind then
    AnswerSoluto.Text   := FormatResult( Soluto )
  else
    AnswerSolvente.Text := FormatResult( Solvente );
end;

function TSoluct.FormatAnswer( Text: String ) : String;
begin
  Result := FloatToStr(StrToFloatDef(RemoveLetter(SpaceDelete(Self.RemovePoints(
                                   Text))), 0))
end;

procedure TSoluct.StartClick(Sender: TObject);
var I : Integer;
var FinalAnswer : Double;
begin
  MakeWaiting();
  if Kind then
  begin
    if SpaceDelete(AnswerSolvente.Text) = '' then
      Application.MessageBox('Insira um valor válido.', 'Solubilidade', MB_ICONWARNING  )
    else
    begin
      Sound.Play_Decision(1);
      FinalAnswer := StrToFloatDef(FormatAnswer(AnswerSolvente.Text),0);
      AnswerSolvente.Text := FormatAnswer(AnswerSolvente.Text) + ' L';
      AnswerSolvente.SelStart := Length(AnswerSolvente.Text);
      if ( ( ( FinalAnswer ) - Solvente / 1000 ) < 0.1 ) and
         ( ( ( FinalAnswer ) - Solvente / 1000 ) > -0.1 ) then 
      // Se correto
      begin
        MultimediaTable.Visible := True;
        Players[2].Play();
        Players[3].Play();
        AfterMath(1);
      end
      else
        // Se maior
        if FinalAnswer < Solvente / 1000 then
        begin
          MultimediaTable.Visible := True;
          Players[2].Play();
          Players[5].Play();
          AfterMath(3);
        end
        // Se menor
        else
        begin
          MultimediaTable.Visible := True;
          Players[2].Play();
          Players[4].Play();
          AfterMath(2);
        end
    end;
  end
  else
  begin
    if SpaceDelete(AnswerSoluto.Text) = '' then
      Application.MessageBox('Insira um valor válido.', 'Solubilidade', MB_ICONWARNING  )
    else
    begin
      Sound.Play_Decision(1);
      FinalAnswer := StrToFloatDef(FormatAnswer(AnswerSoluto.Text),0);
      AnswerSoluto.Text := FormatAnswer(AnswerSoluto.Text) + ' Kg';
      AnswerSoluto.SelStart := Length(AnswerSoluto.Text);
      if ( ( ( FinalAnswer ) - Soluto / 1000 ) < 0.1 ) and
         ( ( ( FinalAnswer ) - Soluto / 1000 ) > -0.1 ) then
      // Se correto
      begin
        MultimediaTable.Visible := True;
        Players[1].Play();
        Players[3].Play();
        AfterMath(1);

      end
      else
        // Se maior
        if FinalAnswer > Soluto / 1000 then
        begin
          MultimediaTable.Visible := True;
          Players[1].Play();
          Players[5].Play();
          AfterMath(3);
        end
        // Se menor
        else
        begin
          MultimediaTable.Visible := True;
          Players[1].Play();
          Players[4].Play();
          AfterMath(2);
        end
    end;

  end;


end;

function TSoluct.FormatResult( Value : Double ) : String;
var Formated : String;
begin
  if Value > 999 then
  begin
    Formated := FloatToStr( Value / 1000 );
    if Kind then
      Formated := Formated + ' Kg'
    else
      Formated := Formated + ' L';
  end
  else
    if Kind then
      Formated := FloatToStr(Value) + ' g'
    else
      Formated := FloatToStr(Value) + ' ml';
  Result := Formated;
end;

procedure TSoluct.SetKind();
begin
  if Random(20) > 10 then
  begin
    Kind := True;
    AnswerSoluto.Enabled   := False;
  end
  else
  begin
    Kind := False;
    AnswerSolvente.Enabled := False;
  end;
end;

procedure TSoluct.SetResult();
begin
  Soluto   := 0;
  Solvente := 0;
  if Kind then
  begin
    While Soluto = 0 do
      Soluto   := Random(9999);
    // Resultado em solvente
    Solvente := Round(Soluto / Coeficiente * DataPorVolume);
  end
  else
  begin
    While Solvente = 0 do
      Solvente := Random(9999);
    // Resultado em soluto
    Soluto := Round(Solvente / DataPorVolume * Coeficiente) ;
  end;
end;

procedure TSoluct.SetSize(Sender: TLabel);
begin
  if Sender = DataSoluto then
  begin
    Sender.Font.Size := Round( ( Sender.Width / Length(Sender.Caption) ) / 3 * 4.2);
    Exit();
  end;
  Sender.Font.Size := Round( ( Sender.Width / Length(Sender.Caption) ) / 3 * 5.5) ;
end;

// Formata a Substância
procedure TSoluct.FormatSubstance();
begin
  With DataModule1.ADOQuery1.Fields do
    DataSoluto.Caption := Fields[2].Value + '(' + 
                          SpaceDelete(ChemistryFormat(Fields[1].Value)) + ')';
  SetSize(DataSoluto);
end;

procedure TSoluct.FormShow(Sender: TObject);
begin

end;

// Exibe o coeficiente
procedure TSoluct.FormatData();
begin
  DataPorVolume := 0;
  Coeficiente := 0;
  With DataModule1.ADOQuery1.Fields do
  begin
    while DataPorVolume = 0 do
      DataPorVolume := Random(999);
    while Coeficiente = 0 do
      Coeficiente := Round( Fields[4].Value / 100 * DataPorVolume );
    Data.Caption := ( 'Dado: ' + FloatToStr(Coeficiente) + ' g/' + FloatToStr(DataPorVolume) +
            ' ml a ' + FloatToStr(Fields[5].Value) + 'º ' + Fields[6].Value );
  end;
  SetSize(Data);
end;

// Define e carrega informações da rodada atual
procedure TSoluct.SetCoeficiente();
begin
  //===========================
  // Índice de valores
  //---------------------------
  // (PK)Codigo substância -> 0
  // Substância            -> 1
  // Nome                  -> 2
  // (FK)Codigo substância -> 3
  // Massa                 -> 4
  // Temperatura           -> 5
  // Medida                -> 6
  // ID                    -> 7
  //===========================

  ID := 0;
  // Limpa comandos SQL
  DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
  // Adiciona comando SQL ( Obtém a quantidade de coeficientes )
  DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Select Count(*) as Codigo from' +
                                              ' Coeficiente');
  // Ativa o SQL
  DataModule1.Adoquery1.Active := True;
  // Executa comandos SQL
  DataModule1.Adoquery1.ExecSQL;

  // Define o coeficiente a ser usado
  while ID = 0 do
    ID := Random(DataModule1.AdoQuery1.FieldByName('Codigo').AsInteger);

  // Limpa comandos SQL
  DataModule1.ADOQuery1.SQL.Clear;

  // Adiciona comando SQL ( Seleciona valores relacionados à solubilidade )
  DataModule1.ADOQuery1.SQL.Add('SELECT Solubilidade.ID, Solubilidade.Substancia, Solubilidade.Nome, Coeficiente.ID_Substancia, Coeficiente.Massa, Coeficiente.Temperatura, Coeficiente.Medida, Coeficiente.Codigo' +
                                ' FROM Solubilidade INNER JOIN Coeficiente ON Solubilidade.[ID] = Coeficiente.[ID_Substancia]' +
                                ' WHERE (((Coeficiente.Codigo)=' + IntToStr(ID) + '));');

  // Ativa SQL
  DataModule1.ADOQuery1.Active := True;
  // Executa SQL
  DataModule1.ADOQuery1.ExecSQL;
end;

end.


