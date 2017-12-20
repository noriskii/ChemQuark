unit Insert_Stoichiometric;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, jpeg, ExtCtrls, StdCtrls, DB_Integrator, GameStoichiometric,
  Sound;

type
//==============================================================================
// ** TInsertStoichiometric
//------------------------------------------------------------------------------
// Esta classe é responsável pela inserção de equações, no banco de dados, para
// o jogo Cálculos estequiométricos.
//==============================================================================
  TInsertStoichiometric = class(TForm)
    BackGround: TImage;
    PreShow: TImage;
    Save: TImage;
    Clean: TImage;
    Exit: TImage;
    EquacaoNaoBalanceada: TEdit;
    Reagente: TEdit;
    Produto: TEdit;
    ReagenteBalanceado: TEdit;
    ProdutoBalanceado: TEdit;
    MassaReagente: TEdit;
    MassaProduto: TEdit;
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnFormCreate(Sender: TObject);
    procedure ActionPreShow();
    procedure ActionSave();
    procedure ActionClean();
    procedure ActionExit();
    procedure FormDestroy(Sender: TObject);
    function CorrectBoxes() : Boolean;
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InsertStoichiometric: TInsertStoichiometric;

implementation

uses Menu;

{$R *.dfm}

// Conjunto de Campos para inserção
var Boxes : Array[1..7] of TEdit;
// Conjunto de Nomes para campos de Inserção
var Names  : Array[1..7] of String;

//------------------------------------------------------------------------------
// * Checa se os campos para inserção têm informações corretas
//------------------------------------------------------------------------------
function TInsertStoichiometric.CorrectBoxes() : Boolean;
var I : Byte;
    J : Byte;
    S : String;
    T : String;
    A : Array[1..5] of Boolean;
    B : Boolean;
    N : Array[1..2] of Real;
    U : String;
    Y : Boolean;
    V : String;
begin
  // Para todos os campos de inserção
  for I := 1 to 7 do
    begin
      // Se for todos os campos menos os de Massas molares e Resposta Final
      if I < 6 then
        // Para todos os elementos químicos
        for J := 1 to 118 do
          // Se os campos de inserção realmente contiverem elementos químicos
          if Pos(Elemento[J].Get_Elemento(2), Boxes[I].Text) > 0 then
          begin
            // Se o campo de inserção for o de equação-não-balanceada
            if ( I = 1 ) and ( A[1] ) then
              // Não autoriza criar mensagem sobre falta de informação do campo
              B := True;
              // Campos de inserção que estão corretos
              A[I] := True;
          end;

      // Se os campos de inserção não contiverem nada inserido
      if Boxes[I].Text = '' then
      begin
        // Se o campo de inserção não for os de massas molares ou resposta final
        if I < 6 then
          // Campos de Inserção que estão corretos
          A[I] := True;
        // Armazena os campos que precisam de modificação
        S := S + ^m + Names[I];
      end;

    end;

  // Se o equação-não-balanceada estiver incorreto
  if not ( A[1] ) or not ( B ) then
    // Se o equação-não-balanceada contiver algo escrito
    if ( Boxes[1].Text <> '') then
    begin
      // Se Equação-Não-Balanceada não contiver '->'
      if pos('->', SpaceDelete(Boxes[1].Text)) > 0 then
      // Adiciona aviso sobre dados incorretos
      else T := T + ^m + Names[1];
      // Se já não contiver avisos sobre dados incorretos
      if T = '' then
      // Adiciona aviso sobre dados incorretos
        T := T + ^m + Names[1];
    end;

  // Para os campos Reagente, Produto, ReagenteBalanceado e ProdutoBalanceado
  for I := 2 to 5 do
    // Se os dados do campo estiver incorreto
    if not A[I] then
      // Adiciona aviso sobre campos incorretos
      T := T + ^m + Names[I];

  // Se há campos que não foram preenchidos
  if S <> '' then
    // Adiciona a mensagem
    S := 'Os seguintes campos não foram preenchidos:' + ^m + S;
  // Se há campos com dados incorretos
  if T <> '' then
    // Adiciona a mensagem
    T := ^m + 'Os seguintes campos não parecem possuir ' +
              'realmente equações químicas:' + ^m + T + ^m;

  // Para os campos de Massas Molares
  for I := 6 to 7 do
    // Armazena seus valores ( já com vírgulas ).
    N[I - 5] := RemovePoints(Boxes[I].Text);

  // Para valores de massas molares
  for I := 1 to 2 do
    // Se forem menores ou iguais a zero e conterem algo inserido
    if ( N[I] <= 0 ) and ( Boxes[I + 5].Text <> '' ) then
      // Armazena campo como errado
      U := U + ^m + Names[I + 5];


  // Se houve um campo de massa molar incorreto
  if U <> '' then
    // Adiciona a mensagem
    U := ^m + 'Os seguintes campos devem ser preenchidos apenas com números' +
              ' positivos:' + ^m + U;

  // Limpa comandos SQL
  DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
  // Adiciona comando SQL ( Obtém a quantidade de equações )
  DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Select Count(*) as ID from' +
                                              ' Estequiometrico');
  // Ativa o SQL
  DataModule1.Adoquery1.Active := True;
  // Executa comandos SQL
  DataModule1.Adoquery1.ExecSQL;

  // Para todos as equações
  for I := 1 to DataModule1.ADOQuery1.FieldByName('ID').AsInteger do
  begin
    // Limpa comandos SQL
    DataModule1.ADOQuery1.SQL.Clear();
    // Adiciona comando SQL ( Para todas Equações-Não-Balanceadas )
    DataModule1.ADOQuery1.SQL.Add('Select EquacaoNaoBalanceada from Estequi' +
      'ometrico where ID = ' + IntToStr(I));
    // Ativa SQL
    DataModule1.ADOQuery1.Active := True;
    // Executa SQL
    DataModule1.ADOQuery1.ExecSQL;
    // Se já houver a equação não balanceada
    if SpaceDelete(Boxes[1].Text) = SpaceDelete(
        DataModule1.ADOQuery1.FieldByName('EquacaoNaoBalanceada').AsString) then
      // Permite informar o erro
      Y := True;
  end;

  // Se permitir informar o erro de equação já inserida
  if Y then
    // Adiciona mensagem
    V := ^m + 'A Equação-não-Balanceada já está presente no banco de dados.';

  // Se não houver nenhum erro nos campos de inserção
  if ( S = '' ) and ( T = '' ) and ( N[1] <> 0 ) and ( N[2] <> 0 ) and ( U = '' )
                and not ( Y ) then
  begin
    // Permite armazenar no banco de dados e/ou testar as informações inseridas
    Result := True;
    // Executa efeito sonoro de bem sucedido
    Play_Se('Okay.wav');
  end
  // Se houver erros nas informações inseridas
  else
  begin
    // Executa efeito sonoro de falta de informação
    Play_SE('Miss.wav');
    // Exibe mensagens de erros
    ShowMessage(S + T + U + V);
    // Não permite armazenar nem testar as informações
    Result := False
  end;

end;

//------------------------------------------------------------------------------
// * Ação de Pré-Visualizar
//------------------------------------------------------------------------------
procedure TInsertStoichiometric.ActionPreShow();
var I    : Byte;
begin
  // Se as informações inseridas estiverem corretas
  if CorrectBoxes then
  begin
    // Reinstancia o jogo de Cálculos estequiométricos
    CalculoEstequiometrico := TCalculoEstequiometrico.Create(Application);
    // Diz ao jogo que o modo teste será executado
    GameStoichiometric.CalculoEstequiometrico.InTest := True;
    { Passa as informações para o jogo }
    for I := 1 to 5 do
      CalculoEstequiometrico.Test[I] := Boxes[I].Text;
    for I := 6 to 7 do
      CalculoEstequiometrico.Test[I] := FloatToStr(RemovePoints(Boxes[I].Text));
    { Informações passadas }
    // Cria o formulário do jogo
    CalculoEstequiometrico.CallMe();
    // Informa à instância que haverá somente a rodada de teste
    CalculoEstequiometrico.Times := CalculoEstequiometrico.GetMaxTurn();
    // Exibe o formulário do jogo
    CalculoEstequiometrico.Show();
    // Esconde o formulário atual
    Self.Hide();
  end;
end;

//------------------------------------------------------------------------------
// * Ação de Salvar Informações no Banco de Dados
//------------------------------------------------------------------------------
procedure TInsertStoichiometric.ActionSave();
var I : Byte;
begin
  // Se as informações inseridas estiverem corretas
  if CorrectBoxes then
  begin
  // ------------------------------------------------------------------------ //
    // Limpa comandos SQL
    DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
    // Cria parâmetros para inserção
    DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Insert into Estequiometrico' +
    ' (EquacaoNaoBalanceada, ReagenteBalanceado, ProdutoBalanceado, Reagente' +
    ', Produto, MassaReagente, MassaProduto)' +
    ' Values (:A, :B, :C, :D, :E, :F, :G)');
    { Para os campos Equação-Não-Balanceada, Reagente, Produto,
      Reagente Balanceado e Produto Balanceado }
    for I := 0 to 4 do
      // Insera-os no banco de dados
      DataModule1.ADOQuery1.Parameters[I].Value := Boxes[I + 1].Text;

    // Insere os campos de massas molares
    DataModule1.ADOQuery1.Parameters[5].Value := StrToFloat(Boxes[6].Text);
    DataModule1.ADOQuery1.Parameters[6].Value := StrToFloat(Boxes[7].Text);
    // Executa comandos SQL
    DataModule1.ADOQuery1.ExecSQL();
  // ------------------------------------------------------------------------ //
  end;
end;

//------------------------------------------------------------------------------
// * Destruição do formulário
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
procedure TInsertStoichiometric.FormDestroy(Sender: TObject);
begin
  // Finaliza o programa
  DataModule1.DataModuleDestroy(Self);
end;

//------------------------------------------------------------------------------
// * Ação de limpar campos de inserção
//------------------------------------------------------------------------------
procedure TInsertStoichiometric.ActionClean();
var I : Byte;
begin
  // Executa efeito sonoro de limpeza
  Play_Se('Clean.wav');
  // Para todos os campos
  for I := 1 to 7 do
    // Limpe-os
    Boxes[I].Clear();
  // Manda cursor ao Equação-Não-Balanceada
  Boxes[1].SetFocus();
end;

//------------------------------------------------------------------------------
// * Ação de sair do Inserção de equações
//------------------------------------------------------------------------------
procedure TInsertStoichiometric.ActionExit();
begin
  // Exibe o Menu Principal
  Inicio.Show();
  // Fecha a Janela atual
  Self.Close();
end;

//------------------------------------------------------------------------------
// * Criação do Formulário
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
procedure TInsertStoichiometric.OnFormCreate(Sender: TObject);
begin
  // Adapta formulário aos demais
  PerformForm(Self);
  // Cria um conjunto de campos de inserção
  Boxes[1] := EquacaoNaoBalanceada;
  Boxes[2] := Reagente;
  Boxes[3] := Produto;
  Boxes[4] := ReagenteBalanceado;
  Boxes[5] := ProdutoBalanceado;
  Boxes[6] := MassaReagente;
  Boxes[7] := MassaProduto;
  // Nomeia os campos de inserção
  Names[1] := 'Equação não Balanceada';
  Names[2] := 'Reagente';
  Names[3] := 'Produto';
  Names[4] := 'Reagente Balanceado';
  Names[5] := 'Produto Balanceado';
  Names[6] := 'Massa molar do Reagente Balanceado';
  Names[7] := 'Massa molar do Produto Balanceado'
end;

//------------------------------------------------------------------------------
// * Processo ao pressionar uma tecla
//    Sender : Componente responsável pela execução
//    Key    : Tecla pressionada
//------------------------------------------------------------------------------
procedure TInsertStoichiometric.OnKeyPress(Sender: TObject; var Key: Char);
begin
  // Se a tecla 'Enter' for pressionada
  if Key = #13 then
  begin
    // Impede Bip
    Key := #0;
    // Executa efeito sonoro de próximo
    Play_Move();
    // Move o cursor até o próximo Campo
    Perform(WM_nextdlgctl,0,0);
  end
  // Se a tecla 'Escape' for pressionada
  else if Key = #27 then
    // Impede Bip
    Key := #0;
end;

//------------------------------------------------------------------------------
// * Processo ao pressionar o botão do mouse
//    Sender : Componente responsável pela execução
//    Action : Tipo de ação
//    Button : Tipo de botão ( Esquerdo, Direito e etc .. )
//    Shift  : Estado da tecla CTRL
//    X      : Posição X do Cursor dentro do Botão
//    Y      : Posição Y do Cursor dentro do Botão
//------------------------------------------------------------------------------
procedure TInsertStoichiometric.OnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Se o componente executador for o botão 'Pré-Visualizar'
  if Sender = PreShow then
    // Altera a imagem do botão
    PreShow.Picture.LoadFromFile('Graphics/Insert/Pre_2.png')
  // Se o componente executador for o botão 'Salvar'
  else if Sender = Save then
    // Altera a imagem do botão
    Save.Picture.LoadFromFile('Graphics/Insert/Save_2.png')
  // Se o componente executador for o botão 'Limpar'
  else if Sender = Clean then
    // Altera a imagem do botão
    Clean.Picture.LoadFromFile('Graphics/Insert/Clean_2.png')
  // Se o componente executador for o botão 'Sair'
  else if Sender = Exit then
    // Altera a imagem do botão
    Exit.Picture.LoadFromFile('Graphics/Insert/Exit_2.png');
end;

//------------------------------------------------------------------------------
// * Processo ao deixar de pressionar o botão do mouse
//    Sender : Componente responsável pela execução
//    Button : Tipo de botão ( Esquerdo, Direito e etc .. )
//    Shift  : Estado da tecla CTRL
//    X      : Posição X do Cursor dentro do Botão
//    Y      : Posição Y do Cursor dentro do Botão
//------------------------------------------------------------------------------
procedure TInsertStoichiometric.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Se o componente executador for o botão 'Pré-Visualizar'
  if Sender = PreShow then
  begin
    // Altera a imagem do botão
    PreShow.Picture.LoadFromFile('Graphics/Insert/Pre_1.png');
    // Executa o processo de Pré-Visualizar
    ActionPreShow()
  end
  // Se o componente executador for o botão 'Salvar'
  else if Sender = Save then
  begin
    // Altera a imagem do botão
    Save.Picture.LoadFromFile('Graphics/Insert/Save_1.png');
    // Executa o processo de Salvar
    ActionSave()
  end
  // Se o componente executador for o botão 'Limpar'
  else if Sender = Clean then
  begin
    // Altera a imagem do botão
    Clean.Picture.LoadFromFile('Graphics/Insert/Clean_1.png');
    // Executa o processo de Limpar
    ActionClean()
  end
  // Se o componente executador for o botão 'Sair'
  else if Sender = Exit then
  begin
    // Executa efeito sonoro de cancelamento
    Play_Cancel();
    // Altera a imagem do botão
    Exit.Picture.LoadFromFile('Graphics/Insert/Exit_1.png');
    // Executa o processo de Sair
    ActionExit();
  end;
end;

end.
