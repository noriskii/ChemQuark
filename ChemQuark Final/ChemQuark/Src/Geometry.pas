unit Geometry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, StdCtrls, pngimage, DB_Integrator, Sound;

type

//==============================================================================
// ** TGeometryGame
//------------------------------------------------------------------------------
// Esta classe � respons�vel por todo o processamento e exibi��o do
// jogo Geometria Molecular. Utiliza a classe DB_Integrator como fonte
// de informa��es
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
  // Respons�vel pela posi��o dos el�trons
  Vertices : Array[1..8, 1..2] of Integer;
  // Grupos aceitos na Ioniza��o
  Accepted : Array[1..7] of Byte = ( 1, 2, 13, 14, 15, 16, 17 );
  // Elementos N�o-Metais aceitos na Ioniza��o
  Accepted_NonMetal : Array[1..11] of Byte = (6, 7, 8, 9, 15, 16, 17, 34, 35,
                                                                      53, 85);
  // Elemento Metal processado
  Ionica_Metal    : Byte;
  // Elemento N�o-Metal processado
  Ionica_NonMetal : Byte;
  // Quantidade de �tomos do elemento Metal processado
  Atoms_Metal     : Byte;
  // Quantidade de �tomos do elemento N�o-Metal processado
  Atoms_NonMetal  : Byte;
  // S�mbolo dos �tomos
  Symbol   : Array[1..7] of String;
  // Quantidade de el�trons dos atomos
  Electron : Array[1..7] of Byte;
  // Quantidade fixa de el�trons dos �tomos
  FixElectron : Array[1..7] of Byte;
  // Conjunto que cont�m Labels dos 7 elementos
  Obj_Elementos : Array[1..7] of TLabel;
  // Conjunto que cont�m as Imagens de todos os El�trons
  Pic_Electrons : Array[1..7] of Array[1..8] of TImage;
  // Armazena dados sobre os el�trons
  Pic_Active    : Array[1..7] of Array[1..8] of Boolean;
  // Modo Sele��o de Alvo
  WhereTo  : Boolean;
  // �ltimo el�tron selecionado
  LastElectronSelected : TImage;
  // ID do �ltimo el�tron selecionado
  LastIDElectronSelected : Byte;
  // ID do �ltimo Elemento selecionado
  LastElementSelected : Byte;
  // Quantidade de Jogadas
  SavesCount : Integer = 0;
  // El�trons das rodadas anteriores
  ElectronsPast : Array of Array of Byte;
  // Equa��es j� jogadas
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
// * Define a posi��o dos el�trons na tela
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
  // El�trons
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
// * Obt�m a quantidade de el�trons da camada de val�ncia
//      ID : N�nero At�mico do Elemento
//------------------------------------------------------------------------------
function GetElectron( ID : Byte ) : Byte;
var I : Byte;
begin
  // Procura o grupo do elemento para determinar seus el�trons
  for I := 1 to 7 do
    if Elemento[ID].Get_Elemento(4) = IntToStr(Accepted[I]) then
      // Retorna o grupo
      Result := I;
end;


//------------------------------------------------------------------------------
// * Substitui n�meros naturais por n�meros moleculares
//    Equacao : Equa��o molecular
//------------------------------------------------------------------------------
function FormatEquation( Equacao : String) : String;
var I, J : Byte;
    Sub  : String;
begin
  // Obt�m o tamanho da String
  for I := 1 to Length(Equacao) + 1 do
  begin
    // Checa n�mero por n�mero
    for J := 0 to 9 do
      // Se o caracter X da String for um n�mero
      if Equacao[I] = IntToStr(J) then
      begin
        // Substitue-o pelo n�mero at�mico correspondente
        case J of
          0: Sub := '�';
          1: Sub := '';
          2: Sub := '�';
          3: Sub := '�';
          4: Sub := '�';
          5: Sub := '�';
          6: Sub := '�';
          7: Sub := '�';
          8: Sub := '�';
          9: Sub := '�';
        end;
        // Deleta o n�mero
        Delete( Equacao, I, 1 );
        // Insere o n�mero at�mico
        Insert( Sub, Equacao, I );
        // Retorna a Equa��o com n�meros at�micos
        Result := Equacao;
      end;
  end;
end;

//------------------------------------------------------------------------------
// * Cria a equa��o
//------------------------------------------------------------------------------
function DefMakeEquation() : String;
begin
  Result := Elemento[Ionica_Metal].Get_Elemento(2) + IntToStr(Atoms_Metal) +
             Elemento[Ionica_NonMetal].Get_Elemento(2) + IntToStr(Atoms_NonMetal);
end;

//------------------------------------------------------------------------------
// * Algoritmo gerador de Liga��es I�nicas
//------------------------------------------------------------------------------
procedure DefEquation();
var Rand, I         : Byte;
    Checked         : Boolean;
    ValenceMetal    : Byte;
    ValenceNonMetal : Byte;
begin
    // Atribui��o �s Vari�veis
    Rand := 0;

    //-------------------
    // Escolha do Metal
    //-------------------

      // Enquanto o n�mero at�mico for 0
      while Rand = 0 do
      begin
        // Randomiza o n�mero at�mico
        Rand := Random(88);

        // Se n�mero at�mico for diferente de 0
        if Rand <> 0 then
        begin

          // Checa se o elemento faz parte dos grupos I,II ou III da tabela
          for I := 1 to 3 do
            if ( Elemento[Rand].Get_Elemento(4) = IntToStr(Accepted[I]) ) and
            // Checa se o elemento n�o � o Boro
            (  Elemento[Rand].Get_Elemento(0) <> IntToStr(5) ) then
            begin
              // Armazena o n�mero at�mico
              Ionica_Metal := Rand;
              // Permite parar o loop prim�rio
              Checked := True;
              // Para o loop secund�rio
              Break;
            end;

            // Se � permitido parar o Loop prim�rio
            if Checked then
              // Para o loop prim�rio
              Break
            // Se n�o for permitido para o Loop prim�rio
            else
              // Repete o loop
              Rand := 0;
        end;
      end;
      // Fim da escolha do Metal

      // Atribui��o �s Vari�veis
      Rand    := 0;
      Checked := False;

      //-------------------
      // Escolha do Ametal
      //-------------------

      // Enquanto o n�mero at�mico for 0
      while Rand = 0 do
      begin
        // Randomiza o n�mero at�mico
        Rand := Random(86);

        // Se n�mero at�mico for diferente de 0
        if Rand <> 0 then
        begin

          // Checa se o elemento � um n�o-metal permitido para a ioniza��o
          for I := 1 to 11 do
            if Elemento[Rand].Get_Elemento(0) = IntToStr(Accepted_NonMetal[I]) then
            begin
              // Armazena o N�o-Metal
              Ionica_NonMetal := Rand;
              // Permite a quebra do loop principal
              Checked := True;
              // Quebra o loop secund�rio
              Break;
            end;

          // Se � permitido parar o loop
          if Checked then
            // Para o loop principal
            Break
          // Se n�o � permitido
          else
            // Repete o loop
            Rand := 0;
        end;
      end;
      // Fim da escolha do Ametal

      // Atribui��o dos El�trons da C�mada de Val�ncia dos elementos
      ValenceMetal    := GetElectron(Ionica_Metal);
      ValenceNonMetal := GetElectron(Ionica_NonMetal);

      //---------------------
      // Forma��o de Equa��o
      //---------------------

      // Se a uni�o de 1 �tomo do Metal e 1 do N�o-Metal concluir o octeto
      if ValenceMetal + ValenceNonMetal = 8 then
      begin
        // Define 1 �tomo para o n�o-metal
        Atoms_NonMetal := 1;
        // Define 1 �tomo para o Metal
        Atoms_Metal    := 1;
      end
      // Caso n�o seja, processa a regra da tesoura
      else
      begin
        // �tomos do N�o-Metal � igual aos c�tions do Metal
        Atoms_NonMetal := ValenceMetal;
        // �tomos do Metal � igual aos �nios do N�o-Metal
        Atoms_Metal    := 8 - ValenceNonMetal;
      end;

      // Para as 5 rodadas poss�veis
      for I := 1 to 5 do
        // Se a equa��o selecionada j� tiver sido jogada
        if AlreadyPlayed[I] = FormatEquation(DefMakeEquation) then
          // Refaz o processo de sele��o de equa��o
          DefEquation();

      // Para as 5 rodadas poss�veis
      for I := 1 to 5 do
        // Se a rodada n�o tiver sido jogada
        if AlreadyPlayed[I] = '' then
        begin
          // Adiciona a equa��o a esta rodada
          AlreadyPlayed[I] := FormatEquation(DefMakeEquation);
          // Para o loop
          Break;
        end;

end;

//------------------------------------------------------------------------------
// * Processamento para facilitar a organiza��o das informa��es na tela
//------------------------------------------------------------------------------
procedure DefGeometry();
var I     : Byte;
begin
  // Caso a quantidade de �tomos de N�o-metal seja menor que as do de Metal
  if Atoms_NonMetal < Atoms_Metal then
  begin
    // At� a quantidade de �tomos de N�o-Metal
    for I := 1 to Atoms_NonMetal do
    begin
      // Armazena o s�mbolo do �tomo N�o-Metal
      Symbol[I]   := Elemento[Ionica_NonMetal].Get_Elemento(2);
      // Armazena a quantidade de el�trons do �tomo N�o-Metal
      Electron[I] := GetElectron(Ionica_NonMetal);
      // Armazena a quantidade original de el�trons do �tomo N�o-Metal
      FixElectron[I] := GetElectron(Ionica_NonMetal);
    end;
    // At� a quantidade de �tomos de Metal + N�o-Metal
    for I := Atoms_NonMetal + 1 to Atoms_Metal + Atoms_NonMetal do
    begin
      // Armazena o s�mbolo do �tomo Metal
      Symbol[I]   := Elemento[Ionica_Metal].Get_Elemento(2);
      // Armazena a quantidade de el�trons do �tomo Metal
      Electron[I] := GetElectron(Ionica_Metal);
      // Armazena a quantidade original de el�trons do �tomo Metal
      FixElectron[I] := GetElectron(Ionica_Metal);
    end;
  end
  // Caso a quantidade de �tomos de Metal seja menor que as do de N�o-Metal
  else
  begin

    // At� a quantidade de �tomos de Metal
    for I := 1 to Atoms_Metal do
    begin
      // Armazena o s�mbolo do �tomo Metal
      Symbol[I]   := Elemento[Ionica_Metal].Get_Elemento(2);
      // Armazena a quantidade de el�trons do �tomo Metal
      Electron[I] := GetElectron(Ionica_Metal);
      // Armazena a quantidade original de el�trons do �tomo Metal
      FixElectron[I] := GetElectron(Ionica_Metal);
    end;
    // At� a quantidade de �tomos de N�o-Metal + Metal
    for I := Atoms_Metal + 1 to Atoms_NonMetal + Atoms_Metal do
    begin
      // Armazena o s�mbolo do �tomo N�o-Metal
      Symbol[I]   := Elemento[Ionica_NonMetal].Get_Elemento(2);
      // Armazena a quantidade de el�trons do �tomo N�o-Metal
      Electron[I] := GetElectron(Ionica_NonMetal);
      // Armazena a quantidade original de el�trons do �tomo N�o-Metal
      FixElectron[I] := GetElectron(Ionica_NonMetal);
    end;
  end;
  // Desenha o elemento na tela
  GeometryGame.DrawText();
  // Desenha os el�trons na tela
  GeometryGame.DrawElectrons();
end;

//------------------------------------------------------------------------------
// * Desenha os elementos na tela
//------------------------------------------------------------------------------
procedure TGeometryGame.DrawText();
var I : Byte;
begin
  // Para todos os �tomos de Metal e de N�o-Metal
  for I := 1 to Atoms_NonMetal + Atoms_Metal do
  begin
    // Atribui o s�mbolo do �tomo ao Label
    Obj_Elementos[I].Caption := Symbol[I];
    // Torna o Label vis�vel
    Obj_Elementos[I].Visible := True;
    // Torna o Label acess�vel
    Obj_Elementos[I].Enabled := True;
  end;
  // Atribui a equa��o a um Label
  Equacao.Caption := FormatEquation(DefMakeEquation);
end;

//------------------------------------------------------------------------------
// * Convers�o de String para PWideChar
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
  // Organiza informa��es na Array para que possa retornar rodadas
  ElectronsPast[SavesCount - 1][0] := ID;
  ElectronsPast[SavesCount - 1][1] := LastElementSelected;
  ElectronsPast[SavesCount - 1][2] := LastIDElectronSelected;
end;

//------------------------------------------------------------------------------
// * Evento ao clicar em um el�tron
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TGeometryGame.ElectronClick(Sender: TObject);
var I, J, M : Byte;
var Controller    : Boolean;
var FileName      : PWideChar;
var Least         : Byte;
begin
  // Atribui��o �s vari�veis
  Controller := True;

  // Se estiver selecionando o alvo
  if WhereTo then
  begin
    // Procura o Elemento que foi clicado
    for I := 1 to Atoms_Metal + Atoms_NonMetal do
    begin
      // Bloqueia clique ao �ltimo elemento selecionado
      if Sender = Obj_Elementos[LastElementSelected] then
        Exit();

      if Sender = Obj_Elementos[I] then
      begin
        // Caso n�o haja 8 el�trons na camada de Val�ncia
        if Electron[I] < 8 then
        begin
          // Soma 1 ao contador de jogadas
          SavesCount := SavesCount + 1;
          // Salva a jogada anterior � rodada
          SaveTime(I);
          // Define o nome do arquivo
          FileName := StrToWide('Saves/' + IntToStr(SavesCount) + '.gaspar');
          // Salva o Bitmap da jogada
          Back.Picture.SaveToFile(FileName);
          // Prote��o para o arquivo ( Torna-o oculto )
          SetFileAttributes(FileName, 2);
          // Altera a posi��o do novo el�tron
          ChangeElectronsPosition(I, Electron[I] + 1);

          // Para todos os el�trons
          for M := 1 to 8 do
            // Checa se o elemento ganhou um c�tion
            if Pic_Active[I][M] then
            begin
              // Define a posi��o do �nion doado
              Least := M;
              // Atribui como c�tion n�o recebido
              Pic_Active[I][M] := False;
              // Finaliza o loop
              Break;
            end
            // Se o elemento n�o ganhou um c�tion
            else
              // Define a posi��o do novo �nion como o pr�ximo el�tron
              Least := Electron[I] + 1;
          // Com o Novo El�tron
          With Pic_Electrons[I][Least] do
          begin
            // Altera sua imagem
            Picture.LoadFromFile('Graphics/Geometry/Little Ball_Came.png');
            // Desenha uma linha do el�tron selecionado at� o el�tron alvo
            Back.Canvas.LineTo(Left,Top);
            // Torna-o inacess�vel
            Enabled := False;
            // Torna-o vis�vel
            Visible := True;
          end;
          // Com o �ltimo el�tron selecionado
          With LastElectronSelected do
          begin
            // Altera sua imagem
            Picture.LoadFromFile('Graphics/Geometry/Little Ball_Went.png');
            // Torna-o inacess�vel
            Enabled := False;
          end;
          // Adiciona 1 el�tron ao controle da camada de Val�ncia
          Electron[I] := Electron[I] + 1;
          // Subtrai 1 el�tron  ao controle da camada de Val�ncia
          Electron[LastElementSelected] := Electron[LastElementSelected] - 1;
          // Permite o elemento anterior ser acessado
          LastElementSelected := 0;
          // Executa efeito sonoro
          Play_Se('Okay.wav');
        end
        // Se houver 8 el�trons no elemento
        else
          // Sai do m�todo
          Exit();
        // Desativa o modo sele��o de alvo
        WhereTo := False;
        // Para o loop
        Break;
      end;
    end;
  end
  else
    // Procura o el�tron selecionado
    for I := 1 to 7 do
      for J := 1 to 7 do
        if Sender = Pic_Electrons[I][J] then
        begin
          // Com o el�tron selecionado
          With Pic_Electrons[I][J] do
          begin
            // Altera sua imagem
            Picture.LoadFromFile('Graphics/Geometry/Little Ball_To.png');
            // Move o ponto de desenho do bitmap para a posi��o do el�tron
            Back.Canvas.MoveTo(Left, Top);
          end;
          // Armazena o el�tron selecionado
          LastElectronSelected := Pic_Electrons[I][J];
          // Informa que o el�tron � removido
          Pic_Active[I][J] := True;
          // Armazena o ID do el�tron selecionado
          LastIDElectronSelected := J;
          // Armazena o elemento selecionado
          LastElementSelected  := I;
          // Ativa o modo sele��o de alvo
          WhereTo := True;
          // Para o loop
          Break;
        end;
  // Checa se todas as liga��es corretas foram feitas
  for I := 1 to Atoms_Metal + Atoms_NonMetal do
    // Se a quantidade de el�trons n�o for 0 nem 8
    if ( Electron[I] <> 0 ) and ( Electron[I] <> 8 ) then
      // N�o permite o jogo ser finalizado
      Controller := False;

  // Se for permitido finalizar o jogo
  if Controller then
    // Pr�xima rodada
    NextMatch();

end;

//------------------------------------------------------------------------------
// * Desenha os el�trons na tela
//------------------------------------------------------------------------------
procedure TGeometryGame.DrawElectrons;
var I, J : Byte;
begin
  // Para todos os el�trons dos �tomos
  for I := 1 to Atoms_NonMetal + Atoms_Metal do
    for J := 1 to Electron[I] do
    begin
      // Altera a posi��o do El�tron
      ChangeElectronsPosition(I, J);
      // Altera a imagem do El�tron
      Pic_Electrons[I][J].Picture.LoadFromFile('Graphics/Geometry/Little Ball.png');
      // Torna o el�tron vis�vel
      Pic_Electrons[I][J].Visible := True;
      // Torna o el�tron acess�vel
      Pic_Electrons[I][J].Enabled := True;
    end;
end;

//------------------------------------------------------------------------------
// * Altera posi��o dos el�trons
//    I : �ndice da Linha
//    J : �ndice da Coluna
//------------------------------------------------------------------------------
procedure TGeometryGame.ChangeElectronsPosition(I : Byte; J : Byte);
begin
  // Se for necess�rio que se some a largura do Elemento
  if ( J = 3 ) or ( J = 4 ) or ( J = 5 ) then
    // Soma a largura do elemento � posi��o X do El�tron
    Pic_Electrons[I][J].Left := Obj_Elementos[I].Left + Vertices[J,1]
                                                      + Obj_Elementos[I].Width
  else
    // N�o soma a largura do elemento � posi��o X do El�tron
    Pic_Electrons[I][J].Left := Obj_Elementos[I].Left + Vertices[J,1];
  // Define a nova posi��o Y do el�tron
  Pic_Electrons[I][J].Top  := Obj_Elementos[I].Top  + Vertices[J,2];
end;

//------------------------------------------------------------------------------
// * Inicializa o jogo
//------------------------------------------------------------------------------
procedure TGeometryGame.StartGame();
begin
  // Inicializa o armazenador de posi��es dos el�trons
  DefVertices();
  // Inicializa o construtor de conjuntos para El�trons e Elementos
  MakeArray();
  // Gera a equa��o para a Ioniza��o
  DefEquation();
  // Organiza os objetos na tela
  DefGeometry();
end;

//------------------------------------------------------------------------------
// * Processo chamado a cada segundo
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TGeometryGame.TimeCounter(Sender: TObject);
begin
  // Atualiza o rel�gio
  UpdateTimer();
end;

//------------------------------------------------------------------------------
// * Processo de atualiza��o do tempo
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
    // Atribui novo tempo ao rel�gio
    Tempo.Caption := '00:00';
    // Altera a cor do rel�gio para preto
    Tempo.Font.Color := RGB(0,0,0);
    // Sai do m�todo
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
        // Adiciona um 0 antes do n�mero do segundo e do minuto
        Caption := '0' + IntToStr(Minute) + ':0' + IntToStr(Second)
      else
        // Adiciona um 0 antes do minuto
        Caption := '0' + IntToStr(Minute) + ':'  + IntToStr(Second);
    end
    else
      // Se os segundos forem inferiores ao 10
      if Second < 10 then
        // Adiciona um 0 antes do n�mero do segundo
        Caption := IntToStr(Minute) + ':0' + IntToStr(Second)
      else
        // Adiciona somente os pontos de separa��o
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
  // Torna a imagem de fade out vis�vel
  FadeOut.Visible := True;
  // Torna a imagem de game over vis�vel
  GameOverPicture.Visible := True;
end;

//------------------------------------------------------------------------------
// * Clique ao bot�o
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
    // Sai do m�todo
    Exit();
  // N�o permite selecionar um alvo
  WhereTo := False;
  // Altera a imagem do el�tron
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
  // Limpeza de c�digo ( Atribui��o dos el�trons da rodada anterior )
  A := ElectronsPast[SavesCount - 1][0];
  B := ElectronsPast[SavesCount - 1][1];
  // Retorna el�trons � rodada anterior
  Electron[A] := Electron[A] - 1;
  Electron[B] := Electron[B] + 1;

  // Para todos os el�trons do elemento
  for I := 1 to 8 do
    // Se o el�tron for diferente da val�ncia natural do elemento
    if ( I > Electron[A] ) and ( I > FixElectron[A] ) and not ( Pic_Active[A][I] ) then
      // Torna o el�tron invis�vel
      Pic_Electrons[A][I].Visible := False;
  // Com o C�tion: Substituir c�tion por �nion
  with Pic_Electrons[B][ElectronsPast[SavesCount - 1][2]] do
  begin
    // Altera sua imagem
    Picture.LoadFromFile('Graphics/Geometry/Little Ball.png');
    // Define como c�tion n�o recebido
    Pic_Active[B][ElectronsPast[SavesCount - 1][2]] := False;
    // Torna o el�tron acess�vel
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
    // Torne-os invis�veis
    Obj_Elementos[I].Visible := False;
    // Para todos os el�trons
    for J := 1 to 8 do
      // Torne-os invis�veis
      Pic_Electrons[I][J].Visible := False;
  end;

  // Para todas as rodadas jogadas
  for I := 1 to SavesCount do
    // Retorna uma rodada
    ReturnOneTime();

  // Para o m�xima de rodadas poss�vel
  for I := 1 to 5 do
    // Se ainda n�o estiver na �ltima rodada
    if AlreadyPlayed[I] = '' then
    begin
      Play_Se('Clean.wav');
      // Inicia nova rodada
      CallMe();
      // Altera a exibi��o da atual rodada
      Rodada.Caption := OrdinalToCardinal(I);
      // Sai do Loop
      Exit();
    end;
  // Processa o fim de jogo ao ter ganhado
  GameWon();
end;

//------------------------------------------------------------------------------
// * Processo executado ao apertar qualquer tecla dentro do formul�rio
//    Sender : Componente respons�vel pela execu��o
//    Key    : Tecla
//------------------------------------------------------------------------------
procedure TGeometryGame.OnKeyPress(Sender: TObject; var Key: Char);
begin

  // Se o enter for pressionado
  if Key = #13 then
  begin
    // Se o game over n�o tiver sido chamado
    if not FadeOut.Visible then
      // Sai do m�todo
      Exit();
    // Se o game over tiver sido chamado
    if GameOverPicture.Visible then
    begin
      // Fecha a janela
      Self.Close();
      // Cria uma inst�ncia da classe de sele��o de jogos
      Inicio := TInicio.Create(Application);
      // Exibe o formul�rio
      Inicio.Show();
    end
    // Se a pontua��o � mostrada
    else
    begin
      // Fecha a janela
      Self.Close();
      { C�digo pr�-pronto para o envio de pontua��o
      // Cria uma inst�ncia para a janela de envio de pontua��o
      SendingPoints := TSendingPoints.Create(Application);
      SendingPoints.FormCreate(Application);
      SendingPoints.Visible(); } { C�digo a seguir deste m�todo ser�
      eliminado }
      // Cria uma inst�ncia da classe de sele��o de jogos
      Inicio := TInicio.Create(Application);
      // Exibe o formul�rio
      Inicio.Show();
    end;  

  end
  // Se a tecla escape for pressionada
  else if Key = #27 then
  begin
    // Executa efeito sonoro de cancelamento
    Sound.Play_Cancel();
    // Torna a imagem de escolha de desist�ncia vis�vel
    Forfeit.Visible := True;
    // Reseta o cursor
    Cursor := 1;
    // Para a contagem
    TimeCount.Enabled := False;
  end;

end;

//------------------------------------------------------------------------------
// * Altera a imagem de desist�ncia
//    Kind : Op��o
//------------------------------------------------------------------------------
procedure TGeometryGame.Change_Forfeit_Picture();
begin
  // Executa efeito sonoro de cursor
  Sound.Play_Cursor(1);
  // Altera imagem de desist�ncia
  With Forfeit.Picture do
    LoadFromFile('Graphics/System/Forfeit_' + IntToStr(Cursor) + '.png');
end;
//------------------------------------------------------------------------------
// * Processo executado ao apertar o bot�o do mouse sobre o bot�o
//    Sender : Componente respons�vel pela execu��o
//    Action : Tipo de a��o
//    Button : Tipo de bot�o ( Esquerdo, Direito e etc .. )
//    Shift  : Estado da tecla CTRL
//    X      : Posi��o X do Cursor dentro do Bot�o
//    Y      : Posi��o Y do Cursor dentro do Bot�o
//------------------------------------------------------------------------------
procedure TGeometryGame.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Altera a imagem do bot�o
  Self.Button.Picture.LoadFromFile('Graphics/Geometry/Desfazer Jogada_3.png');
end;

//------------------------------------------------------------------------------
// * Processo executado ao adentrar as coordenadas do bot�o
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TGeometryGame.OnMouseEnter(Sender: TObject);
begin
  // Altera a imagem do bot�o
  Button.Picture.LoadFromFile('Graphics/Geometry/Desfazer Jogada_2.png');
end;

//------------------------------------------------------------------------------
// * Processo executado ao sair dos limites das coordenadas do bot�o
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TGeometryGame.OnMouseLeave(Sender: TObject);
begin
  // Altera a imagem do bot�o
  Button.Picture.LoadFromFile('Graphics/Geometry/Desfazer Jogada_1.png');
end;

//------------------------------------------------------------------------------
// * Processo executado ao soltar o bot�o esquerdo do mouse sobre o bot�o
//    Sender : Componente respons�vel pela execu��o
//    Button : Tipo de bot�o ( Esquerdo, Direito e etc .. )
//    Shift  : Estado da tecla CTRL
//    X      : Posi��o X do Cursor dentro do Bot�o
//    Y      : Posi��o Y do Cursor dentro do Bot�o
//------------------------------------------------------------------------------
procedure TGeometryGame.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Altera a imagem do bot�o
  Self.Button.Picture.LoadFromFile('Graphics/Geometry/Desfazer Jogada_1.png');
end;

//------------------------------------------------------------------------------
// * Processo ao vencer o jogo
//------------------------------------------------------------------------------
procedure TGeometryGame.GameWon();
begin
  // Reproduz efeito musical de vit�ria
  Play_Me('Vitoria1.wav');
  // Desativa o atualizador de rel�gio
  TimeCount.Enabled := False;
  // Torna a imagem escura vis�vel
  FadeOut.Visible := True;
  // Se os minutos forem maiores que 0
  if Minute > 0 then
    // Determina a pontua��o de acordo com o tempo ( Segundos ao total )
    Pontuacao.Caption := IntToStr( Minute * 60 + Second )
  else
    // Determina a pontua��o de acordo com o tempo ( Segundos )
    Pontuacao.Caption := IntToStr( Second );
  // Torna a janela de pontua��o vis�vel
  PontuacaoPicture.Visible := True;
  // Torna a pontua��o vis�vel
  Pontuacao.Visible := True;
end;

//------------------------------------------------------------------------------
// * Deleta arquivos
//    Til : Deletar arquivos 'at�...'
//------------------------------------------------------------------------------
procedure DeleteFiles( Til : Short );
var I : Short;
begin
  // Deleta todos os arquivos de save
  for I := 1 to Til do
    DeleteFile('Saves/' + IntToStr(I) + '.gaspar');
end;

//------------------------------------------------------------------------------
// * Cria��o do formul�rio
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TGeometryGame.FormCreate(Sender: TObject);
var I : Byte;
begin
  // Adapta formul�rio �s configura��es padr�es do programa
  PerformForm(Self);
end;

//------------------------------------------------------------------------------
// * Processo ao fechar o formul�rio
//    Sender : Componente respons�vel pela execu��o
//    Action : Tipo de a��o
//------------------------------------------------------------------------------
procedure TGeometryGame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Deletar Cache
  DeleteFiles( SavesCount );
end;

//------------------------------------------------------------------------------
// * Inicializa��o do jogo
//------------------------------------------------------------------------------
procedure TGeometryGame.CallMe();
begin
  // Configura o Bitmap
  CanvasConfig();
  // Inicia o jogo
  StartGame();
end;

//------------------------------------------------------------------------------
// * Destrui��o do formul�rio
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TGeometryGame.FormDestroy(Sender: TObject);
begin
  // Deletar Cache
  DeleteFiles( SavesCount );
  // Deletar Vari�veis
  ResetVariables();
  // Finaliza o aplicativo
  DataModule1.DataModuleDestroy(Self);
end;

procedure TGeometryGame.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = VK_F4 then
    Key := 0;

  // Se a tela de desist�ncia estiver vis�vel
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
      // Executa efeito sonoro de confirma��o
      Sound.Play_Decision(1);
      // Se continuar no jogo foi selecionado
      if Cursor = 1 then
      begin
        // Torna a contagem ativa
        TimeCount.Enabled := True;
        // Invisibiliza a janela de escolhas
        Forfeit.Visible   := False;
      end
      // Se a op��o de desistir foi selecionada
      else if Cursor = 2 then
      begin
        // Fecha a janela
        Self.Close();
        // Cria uma inst�ncia da classe de sele��o de jogos
        Inicio := TInicio.Create(Application);
        // Exibe o formul�rio
        Inicio.Show();
      end;

    end;
  end;
end;

//------------------------------------------------------------------------------
// * Reseta todas as vari�veis da mem�ria ram ( Delphi lixo n�o tem GC )
//------------------------------------------------------------------------------
procedure TGeometryGame.ResetVariables();
var I, J : Byte;
begin

  // Reseta todas as vari�veis ( Exceto as com valores constantes )
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
    // Para todos os el�trons
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
