unit Geometry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, StdCtrls, pngimage, DB_Integrator, Sound;

type

//==============================================================================
// ** TGeometryGame
//------------------------------------------------------------------------------
// Esta classe é responsável por todo o processamento e exibição do
// jogo Geometria Molecular. Utiliza a classe DB_Integrator como fonte
// de informações
//==============================================================================
  TGeometryGame = class(TForm)
    BackGround: TImage;
    Elemento_2: TLabel;
    Elemento_3: TLabel;
    Elemento_6: TLabel;
    E_2_7: TImage;
    E_2_1: TImage;
    E_2_2: TImage;
    E_2_6: TImage;
    E_2_4: TImage;
    E_2_3: TImage;
    E_2_5: TImage;
    E_6_3: TImage;
    E_6_5: TImage;
    E_6_4: TImage;
    E_6_6: TImage;
    E_6_2: TImage;
    E_6_1: TImage;
    E_6_7: TImage;
    E_3_3: TImage;
    E_3_5: TImage;
    E_3_4: TImage;
    E_3_6: TImage;
    E_3_2: TImage;
    E_3_1: TImage;
    E_3_7: TImage;
    Equacao: TLabel;
    E_1_6: TImage;
    E_1_2: TImage;
    E_1_1: TImage;
    E_1_7: TImage;
    Elemento_1: TLabel;
    E_1_4: TImage;
    E_1_3: TImage;
    E_1_5: TImage;
    E_4_6: TImage;
    E_4_2: TImage;
    E_4_1: TImage;
    E_4_7: TImage;
    Elemento_4: TLabel;
    E_4_4: TImage;
    E_4_3: TImage;
    E_4_5: TImage;
    E_7_7: TImage;
    E_7_1: TImage;
    E_7_2: TImage;
    E_7_6: TImage;
    Elemento_7: TLabel;
    E_7_4: TImage;
    E_7_3: TImage;
    E_7_5: TImage;
    E_5_7: TImage;
    E_5_1: TImage;
    E_5_2: TImage;
    E_5_6: TImage;
    Elemento_5: TLabel;
    E_5_4: TImage;
    E_5_3: TImage;
    E_5_5: TImage;
    E_2_8: TImage;
    E_6_8: TImage;
    E_3_8: TImage;
    E_1_8: TImage;
    E_7_8: TImage;
    E_5_8: TImage;
    E_4_8: TImage;
    Back: TImage;
    Button: TImage;
    Rodada: TLabel;
    Tempo: TLabel;
    TimeCount: TTimer;
    FadeOut: TImage;
    GameOverPicture: TImage;
    PontuacaoPicture: TImage;
    Pontuacao: TLabel;
    Forfeit: TImage;
    procedure FormCreate(Sender: TObject);
    procedure StartGame();
    procedure DrawText();
    procedure MakeArray();
    procedure DrawElectrons();
    procedure ChangeElectronsPosition(I : Byte; J : Byte);
    procedure ElectronClick(Sender: TObject);
    procedure CanvasConfig();
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ReturnOneTime();
    procedure SaveTime( ID : Byte );
    procedure NextMatch();
    procedure OnMouseLeave(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UpdateTimer();
    procedure TimeCounter(Sender: TObject);
    procedure GameOver();
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure GameWon();
    procedure ResetVariables();
    procedure CallMe();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Change_Forfeit_Picture();
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GeometryGame: TGeometryGame;
  // Responsável pela posição dos elétrons
  Vertices : Array[1..8, 1..2] of Integer;
  // Grupos aceitos na Ionização
  Accepted : Array[1..7] of Byte = ( 1, 2, 13, 14, 15, 16, 17 );
  // Elementos Não-Metais aceitos na Ionização
  Accepted_NonMetal : Array[1..11] of Byte = (6, 7, 8, 9, 15, 16, 17, 34, 35,
                                                                      53, 85);
  // Elemento Metal processado
  Ionica_Metal    : Byte;
  // Elemento Não-Metal processado
  Ionica_NonMetal : Byte;
  // Quantidade de átomos do elemento Metal processado
  Atoms_Metal     : Byte;
  // Quantidade de átomos do elemento Não-Metal processado
  Atoms_NonMetal  : Byte;
  // Símbolo dos átomos
  Symbol   : Array[1..7] of String;
  // Quantidade de elétrons dos atomos
  Electron : Array[1..7] of Byte;
  // Quantidade fixa de elétrons dos átomos
  FixElectron : Array[1..7] of Byte;
  // Conjunto que contém Labels dos 7 elementos
  Obj_Elementos : Array[1..7] of TLabel;
  // Conjunto que contém as Imagens de todos os Elétrons
  Pic_Electrons : Array[1..7] of Array[1..8] of TImage;
  // Armazena dados sobre os elétrons
  Pic_Active    : Array[1..7] of Array[1..8] of Boolean;
  // Modo Seleção de Alvo
  WhereTo  : Boolean;
  // Último elétron selecionado
  LastElectronSelected : TImage;
  // ID do último elétron selecionado
  LastIDElectronSelected : Byte;
  // ID do último Elemento selecionado
  LastElementSelected : Byte;
  // Quantidade de Jogadas
  SavesCount : Integer = 0;
  // Elétrons das rodadas anteriores
  ElectronsPast : Array of Array of Byte;
  // Equações já jogadas
  AlreadyPlayed : Array[1..5] of String;
  // Tempo em minutos
  Minute : Byte = 1;
  // Tempo em segundos
  Second : Byte = 1;
  // Cursor
  Cursor : Byte;


implementation

uses Menu;

{$R *.dfm}

//------------------------------------------------------------------------------
// * Define a posição dos elétrons na tela
//------------------------------------------------------------------------------
procedure DefVertices();
begin
  Vertices[1, 1] := 304 - 322;
  Vertices[1, 2] := 296 - 275;
  Vertices[2, 1] := 304 - 322;
  Vertices[2, 2] := 325 - 275;
  Vertices[3, 1] := 5;
  Vertices[3, 2] := 309 - 275;
  Vertices[4, 1] := 5;
  Vertices[4, 2] := 330 - 275;
  Vertices[5, 1] := 5;
  Vertices[5, 2] := 288 - 275;
  Vertices[6, 1] := 322 - 322;
  Vertices[6, 2] := 346 - 275;
  Vertices[7, 1] := 322 - 322;
  Vertices[7, 2] := 275 - 275;
  Vertices[8, 1] := 350 - 322;
  Vertices[8, 2] := 346 - 275;
end;

//------------------------------------------------------------------------------
// * Cria um Vetor para automatizar desenhos na tela
//------------------------------------------------------------------------------
procedure TGeometryGame.MakeArray;
begin

  //----------
  // Elementos
  //----------
  Obj_Elementos[1] := Elemento_1;
  Obj_Elementos[2] := Elemento_2;
  Obj_Elementos[3] := Elemento_3;
  Obj_Elementos[4] := Elemento_4;
  Obj_Elementos[5] := Elemento_5;
  Obj_Elementos[6] := Elemento_6;
  Obj_Elementos[7] := Elemento_7;

  //----------
  // Elétrons
  //----------

  // Elemento 1
  Pic_Electrons[1][1] := E_1_1;
  Pic_Electrons[1][2] := E_1_2;
  Pic_Electrons[1][3] := E_1_3;
  Pic_Electrons[1][4] := E_1_4;
  Pic_Electrons[1][5] := E_1_5;
  Pic_Electrons[1][6] := E_1_6;
  Pic_Electrons[1][7] := E_1_7;
  Pic_Electrons[1][8] := E_1_8;

  // Elemento 2
  Pic_Electrons[2][1] := E_2_1;
  Pic_Electrons[2][2] := E_2_2;
  Pic_Electrons[2][3] := E_2_3;
  Pic_Electrons[2][4] := E_2_4;
  Pic_Electrons[2][5] := E_2_5;
  Pic_Electrons[2][6] := E_2_6;
  Pic_Electrons[2][7] := E_2_7;
  Pic_Electrons[2][8] := E_2_8;

  // Elemento 3
  Pic_Electrons[3][1] := E_3_1;
  Pic_Electrons[3][2] := E_3_2;
  Pic_Electrons[3][3] := E_3_3;
  Pic_Electrons[3][4] := E_3_4;
  Pic_Electrons[3][5] := E_3_5;
  Pic_Electrons[3][6] := E_3_6;
  Pic_Electrons[3][7] := E_3_7;
  Pic_Electrons[3][8] := E_3_8;

  // Elemento 4
  Pic_Electrons[4][1] := E_4_1;
  Pic_Electrons[4][2] := E_4_2;
  Pic_Electrons[4][3] := E_4_3;
  Pic_Electrons[4][4] := E_4_4;
  Pic_Electrons[4][5] := E_4_5;
  Pic_Electrons[4][6] := E_4_6;
  Pic_Electrons[4][7] := E_4_7;
  Pic_Electrons[4][8] := E_4_8;

  // Elemento 5
  Pic_Electrons[5][1] := E_5_1;
  Pic_Electrons[5][2] := E_5_2;
  Pic_Electrons[5][3] := E_5_3;
  Pic_Electrons[5][4] := E_5_4;
  Pic_Electrons[5][5] := E_5_5;
  Pic_Electrons[5][6] := E_5_6;
  Pic_Electrons[5][7] := E_5_7;
  Pic_Electrons[5][8] := E_5_8;

  // Elemento 6
  Pic_Electrons[6][1] := E_6_1;
  Pic_Electrons[6][2] := E_6_2;
  Pic_Electrons[6][3] := E_6_3;
  Pic_Electrons[6][4] := E_6_4;
  Pic_Electrons[6][5] := E_6_5;
  Pic_Electrons[6][6] := E_6_6;
  Pic_Electrons[6][7] := E_6_7;
  Pic_Electrons[6][8] := E_6_8;

  // Elemento 7
  Pic_Electrons[7][1] := E_7_1;
  Pic_Electrons[7][2] := E_7_2;
  Pic_Electrons[7][3] := E_7_3;
  Pic_Electrons[7][4] := E_7_4;
  Pic_Electrons[7][5] := E_7_5;
  Pic_Electrons[7][6] := E_7_6;
  Pic_Electrons[7][7] := E_7_7;
  Pic_Electrons[7][8] := E_7_8;

end;

//------------------------------------------------------------------------------
// * Obtém a quantidade de elétrons da camada de valência
//      ID : Núnero Atômico do Elemento
//------------------------------------------------------------------------------
function GetElectron( ID : Byte ) : Byte;
var I : Byte;
begin
  // Procura o grupo do elemento para determinar seus elétrons
  for I := 1 to 7 do
    if Elemento[ID].Get_Elemento(4) = IntToStr(Accepted[I]) then
      // Retorna o grupo
      Result := I;
end;


//------------------------------------------------------------------------------
// * Substitui números naturais por números moleculares
//    Equacao : Equação molecular
//------------------------------------------------------------------------------
function FormatEquation( Equacao : String) : String;
var I, J : Byte;
    Sub  : String;
begin
  // Obtém o tamanho da String
  for I := 1 to Length(Equacao) + 1 do
  begin
    // Checa número por número
    for J := 0 to 9 do
      // Se o caracter X da String for um número
      if Equacao[I] = IntToStr(J) then
      begin
        // Substitue-o pelo número atômico correspondente
        case J of
          0: Sub := 'Í';
          1: Sub := '';
          2: Sub := '¿';
          3: Sub := 'À';
          4: Sub := 'Á';
          5: Sub := 'Â';
          6: Sub := 'Ã';
          7: Sub := 'Î';
          8: Sub := 'Ï';
          9: Sub := 'ß';
        end;
        // Deleta o número
        Delete( Equacao, I, 1 );
        // Insere o número atômico
        Insert( Sub, Equacao, I );
        // Retorna a Equação com números atômicos
        Result := Equacao;
      end;
  end;
end;

//------------------------------------------------------------------------------
// * Cria a equação
//------------------------------------------------------------------------------
function DefMakeEquation() : String;
begin
  Result := Elemento[Ionica_Metal].Get_Elemento(2) + IntToStr(Atoms_Metal) +
             Elemento[Ionica_NonMetal].Get_Elemento(2) + IntToStr(Atoms_NonMetal);
end;

//------------------------------------------------------------------------------
// * Algoritmo gerador de Ligações Iônicas
//------------------------------------------------------------------------------
procedure DefEquation();
var Rand, I         : Byte;
    Checked         : Boolean;
    ValenceMetal    : Byte;
    ValenceNonMetal : Byte;
begin
    // Atribuição às Variáveis
    Rand := 0;

    //-------------------
    // Escolha do Metal
    //-------------------

      // Enquanto o número atômico for 0
      while Rand = 0 do
      begin
        // Randomiza o número atômico
        Rand := Random(88);

        // Se número atômico for diferente de 0
        if Rand <> 0 then
        begin

          // Checa se o elemento faz parte dos grupos I,II ou III da tabela
          for I := 1 to 3 do
            if ( Elemento[Rand].Get_Elemento(4) = IntToStr(Accepted[I]) ) and
            // Checa se o elemento não é o Boro
            (  Elemento[Rand].Get_Elemento(0) <> IntToStr(5) ) then
            begin
              // Armazena o número atômico
              Ionica_Metal := Rand;
              // Permite parar o loop primário
              Checked := True;
              // Para o loop secundário
              Break;
            end;

            // Se é permitido parar o Loop primário
            if Checked then
              // Para o loop primário
              Break
            // Se não for permitido para o Loop primário
            else
              // Repete o loop
              Rand := 0;
        end;
      end;
      // Fim da escolha do Metal

      // Atribuição às Variáveis
      Rand    := 0;
      Checked := False;

      //-------------------
      // Escolha do Ametal
      //-------------------

      // Enquanto o número atômico for 0
      while Rand = 0 do
      begin
        // Randomiza o número atômico
        Rand := Random(86);

        // Se número atômico for diferente de 0
        if Rand <> 0 then
        begin

          // Checa se o elemento é um não-metal permitido para a ionização
          for I := 1 to 11 do
            if Elemento[Rand].Get_Elemento(0) = IntToStr(Accepted_NonMetal[I]) then
            begin
              // Armazena o Não-Metal
              Ionica_NonMetal := Rand;
              // Permite a quebra do loop principal
              Checked := True;
              // Quebra o loop secundário
              Break;
            end;

          // Se é permitido parar o loop
          if Checked then
            // Para o loop principal
            Break
          // Se não é permitido
          else
            // Repete o loop
            Rand := 0;
        end;
      end;
      // Fim da escolha do Ametal

      // Atribuição dos Elétrons da Câmada de Valência dos elementos
      ValenceMetal    := GetElectron(Ionica_Metal);
      ValenceNonMetal := GetElectron(Ionica_NonMetal);

      //---------------------
      // Formação de Equação
      //---------------------

      // Se a união de 1 átomo do Metal e 1 do Não-Metal concluir o octeto
      if ValenceMetal + ValenceNonMetal = 8 then
      begin
        // Define 1 átomo para o não-metal
        Atoms_NonMetal := 1;
        // Define 1 átomo para o Metal
        Atoms_Metal    := 1;
      end
      // Caso não seja, processa a regra da tesoura
      else
      begin
        // Átomos do Não-Metal é igual aos câtions do Metal
        Atoms_NonMetal := ValenceMetal;
        // Átomos do Metal é igual aos ânios do Não-Metal
        Atoms_Metal    := 8 - ValenceNonMetal;
      end;

      // Para as 5 rodadas possíveis
      for I := 1 to 5 do
        // Se a equação selecionada já tiver sido jogada
        if AlreadyPlayed[I] = FormatEquation(DefMakeEquation) then
          // Refaz o processo de seleção de equação
          DefEquation();

      // Para as 5 rodadas possíveis
      for I := 1 to 5 do
        // Se a rodada não tiver sido jogada
        if AlreadyPlayed[I] = '' then
        begin
          // Adiciona a equação a esta rodada
          AlreadyPlayed[I] := FormatEquation(DefMakeEquation);
          // Para o loop
          Break;
        end;

end;

//------------------------------------------------------------------------------
// * Processamento para facilitar a organização das informações na tela
//------------------------------------------------------------------------------
procedure DefGeometry();
var I     : Byte;
begin
  // Caso a quantidade de átomos de Não-metal seja menor que as do de Metal
  if Atoms_NonMetal < Atoms_Metal then
  begin
    // Até a quantidade de Átomos de Não-Metal
    for I := 1 to Atoms_NonMetal do
    begin
      // Armazena o símbolo do átomo Não-Metal
      Symbol[I]   := Elemento[Ionica_NonMetal].Get_Elemento(2);
      // Armazena a quantidade de elétrons do átomo Não-Metal
      Electron[I] := GetElectron(Ionica_NonMetal);
      // Armazena a quantidade original de elétrons do átomo Não-Metal
      FixElectron[I] := GetElectron(Ionica_NonMetal);
    end;
    // Até a quantidade de átomos de Metal + Não-Metal
    for I := Atoms_NonMetal + 1 to Atoms_Metal + Atoms_NonMetal do
    begin
      // Armazena o símbolo do átomo Metal
      Symbol[I]   := Elemento[Ionica_Metal].Get_Elemento(2);
      // Armazena a quantidade de elétrons do átomo Metal
      Electron[I] := GetElectron(Ionica_Metal);
      // Armazena a quantidade original de elétrons do átomo Metal
      FixElectron[I] := GetElectron(Ionica_Metal);
    end;
  end
  // Caso a quantidade de átomos de Metal seja menor que as do de Não-Metal
  else
  begin

    // Até a quantidade de átomos de Metal
    for I := 1 to Atoms_Metal do
    begin
      // Armazena o símbolo do átomo Metal
      Symbol[I]   := Elemento[Ionica_Metal].Get_Elemento(2);
      // Armazena a quantidade de elétrons do átomo Metal
      Electron[I] := GetElectron(Ionica_Metal);
      // Armazena a quantidade original de elétrons do átomo Metal
      FixElectron[I] := GetElectron(Ionica_Metal);
    end;
    // Até a quantidade de Átomos de Não-Metal + Metal
    for I := Atoms_Metal + 1 to Atoms_NonMetal + Atoms_Metal do
    begin
      // Armazena o símbolo do átomo Não-Metal
      Symbol[I]   := Elemento[Ionica_NonMetal].Get_Elemento(2);
      // Armazena a quantidade de elétrons do átomo Não-Metal
      Electron[I] := GetElectron(Ionica_NonMetal);
      // Armazena a quantidade original de elétrons do átomo Não-Metal
      FixElectron[I] := GetElectron(Ionica_NonMetal);
    end;
  end;
  // Desenha o elemento na tela
  GeometryGame.DrawText();
  // Desenha os elétrons na tela
  GeometryGame.DrawElectrons();
end;

//------------------------------------------------------------------------------
// * Desenha os elementos na tela
//------------------------------------------------------------------------------
procedure TGeometryGame.DrawText();
var I : Byte;
begin
  // Para todos os átomos de Metal e de Não-Metal
  for I := 1 to Atoms_NonMetal + Atoms_Metal do
  begin
    // Atribui o símbolo do átomo ao Label
    Obj_Elementos[I].Caption := Symbol[I];
    // Torna o Label visível
    Obj_Elementos[I].Visible := True;
    // Torna o Label acessível
    Obj_Elementos[I].Enabled := True;
  end;
  // Atribui a equação a um Label
  Equacao.Caption := FormatEquation(DefMakeEquation);
end;

//------------------------------------------------------------------------------
// * Conversão de String para PWideChar
//    Text : Texto qualquer
//------------------------------------------------------------------------------
function StrToWide( Text : String ) : PWideChar;
begin
  // Retorna String como WideChar
  Result := PWideChar(WideString(Text));
end;

//------------------------------------------------------------------------------
// * Salva o estado da rodada
//     ID : Elemento
//------------------------------------------------------------------------------
procedure TGeometryGame.SaveTime( ID : Byte );
begin
  // Define tamanho do vetor multidimensional de acordo com as rodadas
  SetLength(ElectronsPast,SavesCount, 3);
  // Organiza informações na Array para que possa retornar rodadas
  ElectronsPast[SavesCount - 1][0] := ID;
  ElectronsPast[SavesCount - 1][1] := LastElementSelected;
  ElectronsPast[SavesCount - 1][2] := LastIDElectronSelected;
end;

//------------------------------------------------------------------------------
// * Evento ao clicar em um elétron
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
procedure TGeometryGame.ElectronClick(Sender: TObject);
var I, J, M : Byte;
var Controller    : Boolean;
var FileName      : PWideChar;
var Least         : Byte;
begin
  // Atribuição às variáveis
  Controller := True;

  // Se estiver selecionando o alvo
  if WhereTo then
  begin
    // Procura o Elemento que foi clicado
    for I := 1 to Atoms_Metal + Atoms_NonMetal do
    begin
      // Bloqueia clique ao último elemento selecionado
      if Sender = Obj_Elementos[LastElementSelected] then
        Exit();

      if Sender = Obj_Elementos[I] then
      begin
        // Caso não haja 8 elétrons na camada de Valência
        if Electron[I] < 8 then
        begin
          // Soma 1 ao contador de jogadas
          SavesCount := SavesCount + 1;
          // Salva a jogada anterior à rodada
          SaveTime(I);
          // Define o nome do arquivo
          FileName := StrToWide('Saves/' + IntToStr(SavesCount) + '.gaspar');
          // Salva o Bitmap da jogada
          Back.Picture.SaveToFile(FileName);
          // Proteção para o arquivo ( Torna-o oculto )
          SetFileAttributes(FileName, 2);
          // Altera a posição do novo elétron
          ChangeElectronsPosition(I, Electron[I] + 1);

          // Para todos os elétrons
          for M := 1 to 8 do
            // Checa se o elemento ganhou um cátion
            if Pic_Active[I][M] then
            begin
              // Define a posição do ânion doado
              Least := M;
              // Atribui como cátion não recebido
              Pic_Active[I][M] := False;
              // Finaliza o loop
              Break;
            end
            // Se o elemento não ganhou um cátion
            else
              // Define a posição do novo ânion como o próximo elétron
              Least := Electron[I] + 1;
          // Com o Novo Elétron
          With Pic_Electrons[I][Least] do
          begin
            // Altera sua imagem
            Picture.LoadFromFile('Graphics/Geometry/Little Ball_Came.png');
            // Desenha uma linha do elétron selecionado até o elétron alvo
            Back.Canvas.LineTo(Left,Top);
            // Torna-o inacessível
            Enabled := False;
            // Torna-o visível
            Visible := True;
          end;
          // Com o último elétron selecionado
          With LastElectronSelected do
          begin
            // Altera sua imagem
            Picture.LoadFromFile('Graphics/Geometry/Little Ball_Went.png');
            // Torna-o inacessível
            Enabled := False;
          end;
          // Adiciona 1 elétron ao controle da camada de Valência
          Electron[I] := Electron[I] + 1;
          // Subtrai 1 elétron  ao controle da camada de Valência
          Electron[LastElementSelected] := Electron[LastElementSelected] - 1;
          // Permite o elemento anterior ser acessado
          LastElementSelected := 0;
          // Executa efeito sonoro
          Play_Se('Okay.wav');
        end
        // Se houver 8 elétrons no elemento
        else
          // Sai do método
          Exit();
        // Desativa o modo seleção de alvo
        WhereTo := False;
        // Para o loop
        Break;
      end;
    end;
  end
  else
    // Procura o elétron selecionado
    for I := 1 to 7 do
      for J := 1 to 7 do
        if Sender = Pic_Electrons[I][J] then
        begin
          // Com o elétron selecionado
          With Pic_Electrons[I][J] do
          begin
            // Altera sua imagem
            Picture.LoadFromFile('Graphics/Geometry/Little Ball_To.png');
            // Move o ponto de desenho do bitmap para a posição do elétron
            Back.Canvas.MoveTo(Left, Top);
          end;
          // Armazena o elétron selecionado
          LastElectronSelected := Pic_Electrons[I][J];
          // Informa que o elétron é removido
          Pic_Active[I][J] := True;
          // Armazena o ID do elétron selecionado
          LastIDElectronSelected := J;
          // Armazena o elemento selecionado
          LastElementSelected  := I;
          // Ativa o modo seleção de alvo
          WhereTo := True;
          // Para o loop
          Break;
        end;
  // Checa se todas as ligações corretas foram feitas
  for I := 1 to Atoms_Metal + Atoms_NonMetal do
    // Se a quantidade de elétrons não for 0 nem 8
    if ( Electron[I] <> 0 ) and ( Electron[I] <> 8 ) then
      // Não permite o jogo ser finalizado
      Controller := False;

  // Se for permitido finalizar o jogo
  if Controller then
    // Próxima rodada
    NextMatch();

end;

//------------------------------------------------------------------------------
// * Desenha os elétrons na tela
//------------------------------------------------------------------------------
procedure TGeometryGame.DrawElectrons;
var I, J : Byte;
begin
  // Para todos os elétrons dos átomos
  for I := 1 to Atoms_NonMetal + Atoms_Metal do
    for J := 1 to Electron[I] do
    begin
      // Altera a posição do Elétron
      ChangeElectronsPosition(I, J);
      // Altera a imagem do Elétron
      Pic_Electrons[I][J].Picture.LoadFromFile('Graphics/Geometry/Little Ball.png');
      // Torna o elétron visível
      Pic_Electrons[I][J].Visible := True;
      // Torna o elétron acessível
      Pic_Electrons[I][J].Enabled := True;
    end;
end;

//------------------------------------------------------------------------------
// * Altera posição dos elétrons
//    I : Índice da Linha
//    J : Índice da Coluna
//------------------------------------------------------------------------------
procedure TGeometryGame.ChangeElectronsPosition(I : Byte; J : Byte);
begin
  // Se for necessário que se some a largura do Elemento
  if ( J = 3 ) or ( J = 4 ) or ( J = 5 ) then
    // Soma a largura do elemento à posição X do Elétron
    Pic_Electrons[I][J].Left := Obj_Elementos[I].Left + Vertices[J,1]
                                                      + Obj_Elementos[I].Width
  else
    // Não soma a largura do elemento à posição X do Elétron
    Pic_Electrons[I][J].Left := Obj_Elementos[I].Left + Vertices[J,1];
  // Define a nova posição Y do elétron
  Pic_Electrons[I][J].Top  := Obj_Elementos[I].Top  + Vertices[J,2];
end;

//------------------------------------------------------------------------------
// * Inicializa o jogo
//------------------------------------------------------------------------------
procedure TGeometryGame.StartGame();
begin
  // Inicializa o armazenador de posições dos elétrons
  DefVertices();
  // Inicializa o construtor de conjuntos para Elétrons e Elementos
  MakeArray();
  // Gera a equação para a Ionização
  DefEquation();
  // Organiza os objetos na tela
  DefGeometry();
end;

//------------------------------------------------------------------------------
// * Processo chamado a cada segundo
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
procedure TGeometryGame.TimeCounter(Sender: TObject);
begin
  // Atualiza o relógio
  UpdateTimer();
end;

//------------------------------------------------------------------------------
// * Processo de atualização do tempo
//------------------------------------------------------------------------------
procedure TGeometryGame.UpdateTimer();
begin
  // Diminui os segundos em 1.
  Second := Second - 1;
  // Se o tempo esgotar
  if ( Second = 0 ) and ( Minute = 0 ) then
  begin
    // Chama processo de Game Over
    GameOver();
    // Atribui novo tempo ao relógio
    Tempo.Caption := '00:00';
    // Altera a cor do relógio para preto
    Tempo.Font.Color := RGB(0,0,0);
    // Sai do método
    Exit();
  end;
  // Se os segundos for 0
  if Second = 0 then
  begin
    // Passa para o minuto antecessor
    Second := 59;
    Minute := Minute - 1;
  end;
  // Com o label que exibe o tempo
  With Tempo do
  begin
    // Se os minutos fore inferiores ao 10
    if Minute < 10 then
    begin
      // Se os segundos forem inferiores ao 10
      if Second < 10 then
        // Adiciona um 0 antes do número do segundo e do minuto
        Caption := '0' + IntToStr(Minute) + ':0' + IntToStr(Second)
      else
        // Adiciona um 0 antes do minuto
        Caption := '0' + IntToStr(Minute) + ':'  + IntToStr(Second);
    end
    else
      // Se os segundos forem inferiores ao 10
      if Second < 10 then
        // Adiciona um 0 antes do número do segundo
        Caption := IntToStr(Minute) + ':0' + IntToStr(Second)
      else
        // Adiciona somente os pontos de separação
        Caption := IntToStr(Minute) + ':'  + IntToStr(Second);
    // Se o tempo do jogador for inferior aos 31 segundos
    if ( Minute = 0 ) and ( Second < 31 ) then
      // Se a fonte que exibe o tempo for preta
      if Font.Color = RGB(0,0,0) then
      begin
        // Mude-a para vermelha
        Font.Color := RGB(255,0,0);
      end
      // Se a fonte for vermelha
      else
        // Mude-a para preto
        Font.Color := RGB(0,0,0);
  end;
end;

//------------------------------------------------------------------------------
// * Processo de fim de jogo
//------------------------------------------------------------------------------
procedure TGeometryGame.GameOver();
begin
  // Reproduz efeito musical de derrota
  Play_Me('Derrota1.wav');
  // Desativa o contador de tempo
  TimeCount.Enabled := False;
  // Torna a imagem de fade out visível
  FadeOut.Visible := True;
  // Torna a imagem de game over visível
  GameOverPicture.Visible := True;
end;

//------------------------------------------------------------------------------
// * Clique ao botão
//------------------------------------------------------------------------------
procedure TGeometryGame.Button1Click(Sender: TObject);
begin
  // Retornar uma jogada
  ReturnOneTime();
end;

//------------------------------------------------------------------------------
// * Retorno de jogadas
//------------------------------------------------------------------------------
procedure TGeometryGame.ReturnOneTime();
var A, B, I : Byte;
begin
  // Se a quantidade de jogadas para retornar for nula
  if SavesCount < 1 then
    // Sai do método
    Exit();
  // Não permite selecionar um alvo
  WhereTo := False;
  // Altera a imagem do elétron
  LastElectronSelected.Picture.LoadFromFile('Graphics/Geometry/Little Ball.png');
  // Executa efeito sonoro de retorno de jogada
  Play_Se('Back.wav');
  // Muda o formato do arquivo para .bmp
  RenameFile('Saves/' + IntToStr(SavesCount) + '.gaspar',
             'Saves/' + IntToStr(SavesCount) + '.bmp');
  // Carrega a imagem da jogada anterior
  Back.Picture.LoadFromFile('Saves/' + IntToStr(SavesCount) + '.bmp');
  // Deleta a imagem da jogada anterior
  DeleteFile('Saves/' + IntToStr(SavesCount) + '.bmp');
  // Reconfigura o Bitmap
  CanvasConfig();
  // Limpeza de código ( Atribuição dos elétrons da rodada anterior )
  A := ElectronsPast[SavesCount - 1][0];
  B := ElectronsPast[SavesCount - 1][1];
  // Retorna elétrons à rodada anterior
  Electron[A] := Electron[A] - 1;
  Electron[B] := Electron[B] + 1;

  // Para todos os elétrons do elemento
  for I := 1 to 8 do
    // Se o elétron for diferente da valência natural do elemento
    if ( I > Electron[A] ) and ( I > FixElectron[A] ) and not ( Pic_Active[A][I] ) then
      // Torna o elétron invisível
      Pic_Electrons[A][I].Visible := False;
  // Com o Cátion: Substituir cátion por ânion
  with Pic_Electrons[B][ElectronsPast[SavesCount - 1][2]] do
  begin
    // Altera sua imagem
    Picture.LoadFromFile('Graphics/Geometry/Little Ball.png');
    // Define como cátion não recebido
    Pic_Active[B][ElectronsPast[SavesCount - 1][2]] := False;
    // Torna o elétron acessível
    Enabled := True;
  end;
  // Diminui 1 na quantidade de jogadas para retornar
  SavesCount := SavesCount - 1;
end;


//------------------------------------------------------------------------------
// * Configura atributos de Canvas do Bitmap para desenho
//------------------------------------------------------------------------------
procedure TGeometryGame.CanvasConfig();
begin
  // Define o tamanho do pincel de desenho
  Back.Canvas.Pen.Width := 4;
  // Define a cor do pincel de desenho
  Back.Canvas.Pen.Color := RGB(200,100,100);
end;

//------------------------------------------------------------------------------
// * Processo para iniciar nova rodada
//------------------------------------------------------------------------------
procedure TGeometryGame.NextMatch();
var I, J : Byte;
begin
  // Para todos os elementos
  for I := 1 to 7 do
  begin
    // Torne-os invisíveis
    Obj_Elementos[I].Visible := False;
    // Para todos os elétrons
    for J := 1 to 8 do
      // Torne-os invisíveis
      Pic_Electrons[I][J].Visible := False;
  end;

  // Para todas as rodadas jogadas
  for I := 1 to SavesCount do
    // Retorna uma rodada
    ReturnOneTime();

  // Para o máxima de rodadas possível
  for I := 1 to 5 do
    // Se ainda não estiver na última rodada
    if AlreadyPlayed[I] = '' then
    begin
      Play_Se('Clean.wav');
      // Inicia nova rodada
      CallMe();
      // Altera a exibição da atual rodada
      Rodada.Caption := OrdinalToCardinal(I);
      // Sai do Loop
      Exit();
    end;
  // Processa o fim de jogo ao ter ganhado
  GameWon();
end;

//------------------------------------------------------------------------------
// * Processo executado ao apertar qualquer tecla dentro do formulário
//    Sender : Componente responsável pela execução
//    Key    : Tecla
//------------------------------------------------------------------------------
procedure TGeometryGame.OnKeyPress(Sender: TObject; var Key: Char);
begin

  // Se o enter for pressionado
  if Key = #13 then
  begin
    // Se o game over não tiver sido chamado
    if not FadeOut.Visible then
      // Sai do método
      Exit();
    // Se o game over tiver sido chamado
    if GameOverPicture.Visible then
    begin
      // Fecha a janela
      Self.Close();
      // Cria uma instância da classe de seleção de jogos
      Inicio := TInicio.Create(Application);
      // Exibe o formulário
      Inicio.Show();
    end
    // Se a pontuação é mostrada
    else
    begin
      // Fecha a janela
      Self.Close();
      { Código pré-pronto para o envio de pontuação
      // Cria uma instância para a janela de envio de pontuação
      SendingPoints := TSendingPoints.Create(Application);
      SendingPoints.FormCreate(Application);
      SendingPoints.Visible(); } { Código a seguir deste método será
      eliminado }
      // Cria uma instância da classe de seleção de jogos
      Inicio := TInicio.Create(Application);
      // Exibe o formulário
      Inicio.Show();
    end;  

  end
  // Se a tecla escape for pressionada
  else if Key = #27 then
  begin
    // Executa efeito sonoro de cancelamento
    Sound.Play_Cancel();
    // Torna a imagem de escolha de desistência visível
    Forfeit.Visible := True;
    // Reseta o cursor
    Cursor := 1;
    // Para a contagem
    TimeCount.Enabled := False;
  end;

end;

//------------------------------------------------------------------------------
// * Altera a imagem de desistência
//    Kind : Opção
//------------------------------------------------------------------------------
procedure TGeometryGame.Change_Forfeit_Picture();
begin
  // Executa efeito sonoro de cursor
  Sound.Play_Cursor(1);
  // Altera imagem de desistência
  With Forfeit.Picture do
    LoadFromFile('Graphics/System/Forfeit_' + IntToStr(Cursor) + '.png');
end;
//------------------------------------------------------------------------------
// * Processo executado ao apertar o botão do mouse sobre o botão
//    Sender : Componente responsável pela execução
//    Action : Tipo de ação
//    Button : Tipo de botão ( Esquerdo, Direito e etc .. )
//    Shift  : Estado da tecla CTRL
//    X      : Posição X do Cursor dentro do Botão
//    Y      : Posição Y do Cursor dentro do Botão
//------------------------------------------------------------------------------
procedure TGeometryGame.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Altera a imagem do botão
  Self.Button.Picture.LoadFromFile('Graphics/Geometry/Desfazer Jogada_3.png');
end;

//------------------------------------------------------------------------------
// * Processo executado ao adentrar as coordenadas do botão
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
procedure TGeometryGame.OnMouseEnter(Sender: TObject);
begin
  // Altera a imagem do botão
  Button.Picture.LoadFromFile('Graphics/Geometry/Desfazer Jogada_2.png');
end;

//------------------------------------------------------------------------------
// * Processo executado ao sair dos limites das coordenadas do botão
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
procedure TGeometryGame.OnMouseLeave(Sender: TObject);
begin
  // Altera a imagem do botão
  Button.Picture.LoadFromFile('Graphics/Geometry/Desfazer Jogada_1.png');
end;

//------------------------------------------------------------------------------
// * Processo executado ao soltar o botão esquerdo do mouse sobre o botão
//    Sender : Componente responsável pela execução
//    Button : Tipo de botão ( Esquerdo, Direito e etc .. )
//    Shift  : Estado da tecla CTRL
//    X      : Posição X do Cursor dentro do Botão
//    Y      : Posição Y do Cursor dentro do Botão
//------------------------------------------------------------------------------
procedure TGeometryGame.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Altera a imagem do botão
  Self.Button.Picture.LoadFromFile('Graphics/Geometry/Desfazer Jogada_1.png');
end;

//------------------------------------------------------------------------------
// * Processo ao vencer o jogo
//------------------------------------------------------------------------------
procedure TGeometryGame.GameWon();
begin
  // Reproduz efeito musical de vitória
  Play_Me('Vitoria1.wav');
  // Desativa o atualizador de relógio
  TimeCount.Enabled := False;
  // Torna a imagem escura visível
  FadeOut.Visible := True;
  // Se os minutos forem maiores que 0
  if Minute > 0 then
    // Determina a pontuação de acordo com o tempo ( Segundos ao total )
    Pontuacao.Caption := IntToStr( Minute * 60 + Second )
  else
    // Determina a pontuação de acordo com o tempo ( Segundos )
    Pontuacao.Caption := IntToStr( Second );
  // Torna a janela de pontuação visível
  PontuacaoPicture.Visible := True;
  // Torna a pontuação visível
  Pontuacao.Visible := True;
end;

//------------------------------------------------------------------------------
// * Deleta arquivos
//    Til : Deletar arquivos 'até...'
//------------------------------------------------------------------------------
procedure DeleteFiles( Til : Short );
var I : Short;
begin
  // Deleta todos os arquivos de save
  for I := 1 to Til do
    DeleteFile('Saves/' + IntToStr(I) + '.gaspar');
end;

//------------------------------------------------------------------------------
// * Criação do formulário
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
procedure TGeometryGame.FormCreate(Sender: TObject);
var I : Byte;
begin
  // Adapta formulário às configurações padrões do programa
  PerformForm(Self);
end;

//------------------------------------------------------------------------------
// * Processo ao fechar o formulário
//    Sender : Componente responsável pela execução
//    Action : Tipo de ação
//------------------------------------------------------------------------------
procedure TGeometryGame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Deletar Cache
  DeleteFiles( SavesCount );
end;

//------------------------------------------------------------------------------
// * Inicialização do jogo
//------------------------------------------------------------------------------
procedure TGeometryGame.CallMe();
begin
  // Configura o Bitmap
  CanvasConfig();
  // Inicia o jogo
  StartGame();
end;

//------------------------------------------------------------------------------
// * Destruição do formulário
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
procedure TGeometryGame.FormDestroy(Sender: TObject);
begin
  // Deletar Cache
  DeleteFiles( SavesCount );
  // Deletar Variáveis
  ResetVariables();
  // Finaliza o aplicativo
  DataModule1.DataModuleDestroy(Self);
end;

procedure TGeometryGame.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = VK_F4 then
    Key := 0;

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
      // Torna a contagem ativa
      TimeCount.Enabled := True;
      // Invisibiliza a janela de escolhas
      Forfeit.Visible   := False;
    end

    // Se a tecla Enter for pressionada
    else if Key = VK_Return then
    begin
      // Executa efeito sonoro de confirmação
      Sound.Play_Decision(1);
      // Se continuar no jogo foi selecionado
      if Cursor = 1 then
      begin
        // Torna a contagem ativa
        TimeCount.Enabled := True;
        // Invisibiliza a janela de escolhas
        Forfeit.Visible   := False;
      end
      // Se a opção de desistir foi selecionada
      else if Cursor = 2 then
      begin
        // Fecha a janela
        Self.Close();
        // Cria uma instância da classe de seleção de jogos
        Inicio := TInicio.Create(Application);
        // Exibe o formulário
        Inicio.Show();
      end;

    end;
  end;
end;

//------------------------------------------------------------------------------
// * Reseta todas as variáveis da memória ram ( Delphi lixo não tem GC )
//------------------------------------------------------------------------------
procedure TGeometryGame.ResetVariables();
var I, J : Byte;
begin

  // Reseta todas as variáveis ( Exceto as com valores constantes )
  Ionica_Metal    := 0;
  Ionica_NonMetal := 0;
  Atoms_Metal     := 0;
  Atoms_NonMetal  := 0;

  // Para todos os elementos
  for I := 1 to 7 do
  begin
    Symbol[I] := '';
    Electron[I]  := 0;
    FixElectron[I] := 0;
    // Para todos os elétrons
    for J := 1 to 8 do
      Pic_Active[I][J] := False;
  end;

  WhereTo  := False;
  LastElectronSelected := Nil;
  LastIDElectronSelected := 0;
  LastElementSelected := 0;
  SavesCount := 0;
  ElectronsPast := Nil;
  // Para todas as jogadas
  for I := 1 to 5 do
    AlreadyPlayed[I] := '';
  Minute := 1;
  Second := 1;

end;

end.
