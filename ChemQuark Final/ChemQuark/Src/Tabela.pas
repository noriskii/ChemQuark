unit Tabela;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Elementos, StdCtrls, pngimage, ExtCtrls, MMSystem, Propriedades,
  JogoDistribuicao, jpeg, DB_Integrator, Sound;

type
//==============================================================================
// ** TPeriodicTable
//------------------------------------------------------------------------------
// Esta classe � respons�vel pela tabela peri�dica
//==============================================================================
  TPeriodicTable = class(TForm)
    TabelaPeriodica: TImage;
    Hidrogenio: TImage;
    Helio: TImage;
    Litio: TImage;
    Berilio: TImage;
    Boro: TImage;
    Magnesio: TImage;
    Aluminio: TImage;
    Silicio: TImage;
    Fosforo: TImage;
    Enxofre: TImage;
    Cloro: TImage;
    Argon: TImage;
    Potassio: TImage;
    Calcio: TImage;
    Escandio: TImage;
    Titanio: TImage;
    Vanadio: TImage;
    Cromo: TImage;
    Manganes: TImage;
    Ferro: TImage;
    Cobalto: TImage;
    Niquel: TImage;
    Cobre: TImage;
    Zinco: TImage;
    Galio: TImage;
    Germanio: TImage;
    Arsenio: TImage;
    Selenio: TImage;
    Bromo: TImage;
    Kriptonio: TImage;
    Sodio: TImage;
    Fluor: TImage;
    Neonio: TImage;
    Oxigenio: TImage;
    Nitrogenio: TImage;
    Carbono: TImage;
    Indio: TImage;
    Cadmio: TImage;
    Prata: TImage;
    Paladio: TImage;
    Rodio: TImage;
    Rutenio: TImage;
    Zirconio: TImage;
    Tecnecio: TImage;
    Molibdenio: TImage;
    Niobio: TImage;
    Bario: TImage;
    Hafnio: TImage;
    Cesio: TImage;
    Rubidio: TImage;
    Estanho: TImage;
    Tantalio: TImage;
    Estroncio: TImage;
    Antimonio: TImage;
    Xenomio: TImage;
    Iodo: TImage;
    Telurio: TImage;
    Itrio: TImage;
    Erbio: TImage;
    Tulio: TImage;
    Iterbio: TImage;
    Lutecio: TImage;
    Tungstenio: TImage;
    Talio: TImage;
    Mercurio: TImage;
    Ouro: TImage;
    Platina: TImage;
    Iridio: TImage;
    Osmio: TImage;
    Renio: TImage;
    Cerio: TImage;
    Holmio: TImage;
    Neodimio: TImage;
    Praseodimio: TImage;
    Disprosio: TImage;
    Terbio: TImage;
    Europio: TImage;
    Promecio: TImage;
    Gadolinio: TImage;
    Samario: TImage;
    Lantanio: TImage;
    Ruterfordio: TImage;
    Torio: TImage;
    Dubnio: TImage;
    Actinio: TImage;
    Uranio: TImage;
    Plutonio: TImage;
    Protactinio: TImage;
    Netunio: TImage;
    Seaborgio: TImage;
    Bohrio: TImage;
    Hassio: TImage;
    Meitnerio: TImage;
    Darmstadio: TImage;
    Roentgentum: TImage;
    Ununbium: TImage;
    Ununtrium: TImage;
    Ununpentium: TImage;
    Americio: TImage;
    Curio: TImage;
    Berquelio: TImage;
    Californio: TImage;
    Einstenio: TImage;
    Ununquadium: TImage;
    Fermio: TImage;
    Laurencio: TImage;
    Nobelio: TImage;
    Ununhexio: TImage;
    Mendelevio: TImage;
    Ununoctium: TImage;
    Ununseptium: TImage;
    Branco2: TImage;
    Radio: TImage;
    Francio: TImage;
    Radonio: TImage;
    Astato: TImage;
    Polonio: TImage;
    Bismuto: TImage;
    Chumbo: TImage;
    Branco1: TImage;
    Cursor: TImage;
    CursorKeyboard: TTimer;
    Nome: TLabel;
    AtomicNumber: TLabel;
    AtomicWeight: TLabel;
    CursorMouse: TTimer;
    Other: TTimer;
    Botao: TImage;
    Button: TTimer;
    Timer1: TTimer;
    procedure OnShow(Sender: TObject);
    procedure OnClose(Sender: TObject; var Action: TCloseAction);
    procedure CursorKeyboardTimer(Sender: TObject);
    procedure CursorMouseTimer(Sender: TObject);
    procedure OtherTimer(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
    procedure BotaoClick(Sender: TObject);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    procedure KeepPicture;
    procedure MoveCursor( CursorSoundID : Byte = 1 );
    procedure SetDirectionCursor( Direction : Byte );
    procedure ChangeDescription();
  public
    { Public declarations }

    // Tabela peri�dica ativa ?
    ActiveForm   : Boolean;
    // Cursor dos elementos
    CursorIndex : Byte;
    // Armazena o estado do cursor ao chamar outra janela
    SaveCursorIndex : Byte;

    // Simula o n�mero at�mico dos elementos qu�micos
    AtomicPicture : Array[1..120] of Byte;

  end;

var
  // Inst�ncia da forma
  PeriodicTable : TPeriodicTable;
  // Resolu��o do monitor do usu�rio
  Before_Resolution : Array[1..2] of Integer;
  // Todas as imagens dos elementos armazenadas em um conjunto
  Picture : Array[1..121] of TImage;
  // Bot�o de outras propriedades est� sendo pressionado ?
  ActiveButton : Boolean;
  // Bot�o de outras propriedades est� ativado ?
  EnableButton : Boolean;
  { Vari�veis de aux�lio para bloquear pressionamento imediato de bot�es
     assim que entrar no formul�rio }
  Gambz : Boolean;
  Gambz_ : Array[1..2] of Integer;
  // Veio de onde, ir� para onde ?
  WhereTo : Byte;


implementation

uses GameStoichiometric, Menu;

{$R *.dfm}

//------------------------------------------------------------------------------
// * Define a posi��o dos el�trons na tela
//------------------------------------------------------------------------------
  procedure TPeriodicTable.ChangeDescription;
  begin
    { Se o cursor estiver nos espa�os de liga��o para os Lantan�deos e os
      Act�nideos }
    if ( CursorIndex = 75 ) or ( CursorIndex = 57 ) then
    begin
      { Os seguintes labels tornam-se vazios: }
      // Nome
      Nome.Caption := '';
      // N�mero at�mico
      AtomicNumber.Caption := '';
      // Massa at�mica
      AtomicWeight.Caption := '';

      // Torna o bot�o Outras Propriedades inacess�vel
      EnableButton := false;
    end
    else
    begin
      { Desenha os seguintes atributos de acordo com o cursor: }
      // Nome
      Nome.Caption := Elemento[AtomicPicture[CursorIndex]].Get_Elemento(1);
      // N�mero at�mico
      AtomicNumber.Caption := Elemento[AtomicPicture[CursorIndex]].Get_Elemento(0);
      // Massa at�mica
      AtomicWeight.Caption := Elemento[AtomicPicture[CursorIndex]].Get_Elemento(3);

      // Torna o bot�o Outras Propriedades acess�vel
      EnableButton := true;
    end;

  end;

//------------------------------------------------------------------------------
// * Muda a posi��o do Cursor
//    CursorSoundID : Sufixo do �udio de movimento
//------------------------------------------------------------------------------
  procedure TPeriodicTable.MoveCursor( CursorSoundID : Byte = 1 );
  begin
    // Se a tabela peri�dica n�o estiver ativa
    if not ActiveForm then
      // Sai do m�todo
      Exit();
    // Executa efeito sonoro de cursor
    Play_Cursor(CursorSoundID);
    // Estabelece nova posi��o X para o cursor
    Cursor.Left := Picture[CursorIndex].Left - 3;
    // Estabelece nova posi��o Y para o cursor
    Cursor.Top  := Picture[CursorIndex].Top;
    // Altera a descri��o para o atual elemento selecionado
    ChangeDescription();
  end;

//------------------------------------------------------------------------------
// * Define a nova posi��o do cursor
//    Direction : Ponto cardeal
//------------------------------------------------------------------------------
  procedure TPeriodicTable.SetDirectionCursor(Direction: Byte);
  begin
    // Caso a Dire��o do Cursor seja:
    case Direction of
      6: CursorIndex := CursorIndex + 1; // Soma 1 ao cursor
      4: CursorIndex := CursorIndex - 1; // Subtrai 1 ao cursor
    end;
    // Move o cursor de acordo com a nova posi��o
    MoveCursor();
  end;

//------------------------------------------------------------------------------
// * Armazena todas as imagens dos s�mbolos dos elementos em um conjunto
//------------------------------------------------------------------------------
  procedure TPeriodicTable.KeepPicture();
  var I : Byte;
  begin
    // Imagens inseridas com perspectiva horizontal
    Picture[1] := Hidrogenio;
    Picture[2] := Helio;
    Picture[3] := Litio;
    Picture[4] := Berilio;
    Picture[5] := Boro;
    Picture[6] := Carbono;
    Picture[7] := Nitrogenio;
    Picture[8] := Oxigenio;
    Picture[9] := Fluor;
    Picture[10] := Neonio;
    Picture[11] := Sodio;
    Picture[12] := Magnesio;
    Picture[13] := Aluminio;
    Picture[14] := Silicio;
    Picture[15] := Fosforo;
    Picture[16] := Enxofre;
    Picture[17] := Cloro;
    Picture[18] := Argon;
    Picture[19] := Potassio;
    Picture[20] := Calcio;
    Picture[21] := Escandio;
    Picture[22] := Titanio;
    Picture[23] := Vanadio;
    Picture[24] := Cromo;
    Picture[25] := Manganes;
    Picture[26] := Ferro;
    Picture[27] := Cobalto;
    Picture[28] := Niquel;
    Picture[29] := Cobre;
    Picture[30] := Zinco;
    Picture[31] := Galio;
    Picture[32] := Germanio;
    Picture[33] := Arsenio;
    Picture[34] := Selenio;
    Picture[35] := Bromo;
    Picture[36] := Kriptonio;
    Picture[37] := Rubidio;
    Picture[38] := Estroncio;
    Picture[39] := Itrio;
    Picture[40] := Zirconio;
    Picture[41] := Niobio;
    Picture[42] := Molibdenio;
    Picture[43] := Tecnecio;
    Picture[44] := Rutenio;
    Picture[45] := Rodio;
    Picture[46] := Paladio;
    Picture[47] := Prata;
    Picture[48] := Cadmio;
    Picture[49] := Indio;
    Picture[50] := Estanho;
    Picture[51] := Antimonio;
    Picture[52] := Telurio;
    Picture[53] := Iodo;
    Picture[54] := Xenomio;
    Picture[55] := Cesio;
    Picture[56] := Bario;
    Picture[57] := Branco1;
    Picture[58] := Hafnio;
    Picture[59] := Tantalio;
    Picture[60] := Tungstenio;
    Picture[61] := Renio;
    Picture[62] := Osmio;
    Picture[63] := Iridio;
    Picture[64] := Platina;
    Picture[65] := Ouro;
    Picture[66] := Mercurio;
    Picture[67] := Talio;
    Picture[68] := Chumbo;
    Picture[69] := Bismuto;
    Picture[70] := Polonio;
    Picture[71] := Astato;
    Picture[72] := Radonio;
    Picture[73] := Francio;
    Picture[74] := Radio;
    Picture[75] := Branco2;
    Picture[76] := Ruterfordio;
    Picture[77] := Dubnio;
    Picture[78] := Seaborgio;
    Picture[79] := Bohrio;
    Picture[80] := Hassio;
    Picture[81] := Meitnerio;
    Picture[82] := Darmstadio;
    Picture[83] := Roentgentum;
    Picture[84] := Ununbium;
    Picture[85] := Ununtrium;
    Picture[86] := Ununquadium;
    Picture[87] := Ununpentium;
    Picture[88] := Ununhexio;
    Picture[89] := Ununseptium;
    Picture[90] := Ununoctium;
    Picture[91] := Lantanio;
    Picture[92] := Cerio;
    Picture[93] := Praseodimio;
    Picture[94] := Neodimio;
    Picture[95] := Promecio;
    Picture[96] := Samario;
    Picture[97] := Europio;
    Picture[98] := Gadolinio;
    Picture[99] := Terbio;
    Picture[100] := Disprosio;
    Picture[101] := Holmio;
    Picture[102] := Erbio;
    Picture[103] := Tulio;
    Picture[104] := Iterbio;
    Picture[105] := Lutecio;
    Picture[106] := Actinio;
    Picture[107] := Torio;
    Picture[108] := Protactinio;
    Picture[109] := Uranio;
    Picture[110] := Netunio;
    Picture[111] := Plutonio;
    Picture[112] := Americio;
    Picture[113] := Curio;
    Picture[114] := Berquelio;
    Picture[115] := Californio;
    Picture[116] := Einstenio;
    Picture[117] := Fermio;
    Picture[118] := Mendelevio;
    Picture[119] := Nobelio;
    Picture[120] := Laurencio;
    Picture[121] := Laurencio;

    // Do elemento Hidrog�nio at� o B�rio
    for I := 0 to 56 do
      // Simula o n�mero at�mico
      AtomicPicture[I] := I;

    { Torna a primeira casa em branco o elemento 0 ( Para que n�o
     exiba informa��es ) }
    AtomicPicture[57] := 0;

    // Do elemento Lant�nio at� o Lut�cio
    for I := 58 to 74 do
      // Simula o n�mero at�mico
      AtomicPicture[I] := I + 14;

    { Torna a segunda casa em branco o elemento 0 ( Para que n�o
     exiba informa��es ) }
    AtomicPicture[75] := 0;

    // Do elemento H�fnio ao R�dio
    for I := 76 to 90 do
      // Simula o n�mero at�mico
      AtomicPicture[I] := I + 28;

    // Do Actinio ao Laur�ncio
    for I := 91 to 105 do
      // Simula o n�mero at�mico
      AtomicPicture[I] := I - 34;

    // Do elemento Rutenf�rdio ao Unonoctium
    for I := 106 to 120 do
      // Simula o n�mero at�mico
      AtomicPicture[I] := I - 17;

  end;

//------------------------------------------------------------------------------
// * Atualiza��o do processo ( Movimento do Cursor da Tabela pelo Teclado )
//    Sender : Timer respons�vel pela execu��o
//------------------------------------------------------------------------------
  procedure TPeriodicTable.CursorKeyboardTimer(Sender: TObject);
  begin
    // Aumenta 1 ao controlador do clique n�o imediato
    Gambz_[1] := Gambz_[1] + 1;

      { Se a seta direita for pressionada e o Cursor estiver em qualquer
        elemento com n�mero at�mico simulado inferior ao 119 ( Unonoctium ) }
      if ( GetAsyncKeyState(VK_RIGHT) <> 0 ) and ( CursorIndex < 120 ) then
        // Define dire��o direita para locomo��o do Cursor
        SetDirectionCursor(6)
      { Se a seta esquerda for pressionado e o Cursor estiver em qualquer
        elemento com n�mero at�mico simulado superior ao 1 ( Hidrog�nio ) }
      else if ( GetAsyncKeyState(VK_LEFT) <> 0 ) and ( CursorIndex >= 2 ) then
        // Define dire��o esquerda para locomo��o do Cursor
        SetDirectionCursor(4)
      { Se a seta para baixa for pressionada e o Cursor estiver em qualquer
        elemento com n�mero at�mico simulado inferior ao 106 ( Lut�ncio ) }
      else if ( GetAsyncKeyState(VK_DOWN) <> 0 ) and ( CursorIndex < 106 ) then
      begin
        { Se o cursor estiver num elemento com n�mero at�mico simulado superior
          ao 18 ( Argonio ) }
        if ( CursorIndex > 18 ) then
        begin
          { Se o cursor estiver num elemento com n�mero �tomico simulado
            inferior ao 73 ( Fr�ncio ) }
          if  CursorIndex < 73 then
          begin
            // Move o cursor para o elemento Lant�nio
            CursorIndex := CursorIndex + 18;
          end
          { Se o cursor estiver num elemento com n�mero �tomico simulado
            inferior ao 76 ( 2� casa em branco ) }
          else if ( CursorIndex < 76 ) then
            // Move o cursor para o elemento Lant�nio
            CursorIndex := 91
          { Se o cursor estiver num elemento com n�mero �tomico simulado
            inferior ao 90 ( UnunSeptium ) }
          else if ( CursorIndex < 90 )  then
            // Move o cursor para Lut�ncio
            CursorIndex := CursorIndex + 16
          { Se o cursor estiver num elemento com n�mero �tomico simulado
            inferior ao 91 ( Unonoctium ) }
          else if ( CursorIndex < 91 ) then
            // Move o cursor para o Lut�ncio
            CursorIndex := 105
          { Se o cursor estiver num elemento da fileira aos Lantan�deos }
          else if ( CursorIndex < 106 ) then
            // Move para a fileira dos actin�deos
            CursorIndex := CursorIndex + 15
        end
        // Se o cursor estiver num elemento simulado acima de 12 ( Magn�sio )
        else if ( CursorIndex > 12 ) then
          // Define nova posi��o para o cursor
          CursorIndex := CursorIndex + 18
        // Se o cursor n�o estiver no Hidrog�nio
        else if ( CursorIndex > 1 ) then
          // Define nova posi��o para o cursor
          CursorIndex := CursorIndex + 8
        else
          // Envia o cursor at� o L�tio
          CursorIndex := 3;
        // Movimenta o cursor
        MoveCursor();
      end
      { Se a tecla para cima foi pressionado e o cursor n�o estiver nem
        no Hidrog�nio nem no H�lio }
      else if ( GetAsyncKeyState(VK_UP) <> 0 ) and ( CursorIndex > 2 ) then
      begin
        // Se o cursor estiver nas fileira dos Actin�deos
        if ( CursorIndex > 105 ) then
          CursorIndex := CursorIndex - 15
        // Se o cursor estiver nas fileira dos Lantan�deos
        else if ( CursorIndex > 90 ) then
          CursorIndex := CursorIndex - 16
        // Se o cursor estiver num n�mero at�mico simulado acima de 30 ( G�lio )
        else if ( CursorIndex > 30 ) then
          CursorIndex := CursorIndex - 18
        // Se o cursor estiver num n�mero at�mico simulado acima de 20 (C�lcio)
        else if ( CursorIndex > 20 ) then
          Exit() // I'm evil
        // Se o cursor estiver num n�mero at�mico simulado acima de 9 ( N�onio )
        else if ( CursorIndex > 9 ) then
          CursorIndex := CursorIndex - 8
        // Se o cursor estiver num n�mero at�mico simulado acima de 3 ( L�tio )
        else if ( CursorIndex > 3 ) then
          Exit() // The Most Evil
        else
          // Define nova posi��o do cursor: Hidrog�nio
          CursorIndex := 1;
        // Move o Cursor para a posi��o definida
        MoveCursor();
      end;
      
  end;

//------------------------------------------------------------------------------
// * Atualiza��o do processo ( Movimento do Cursor da Tabela pelo Mouse )
//    Sender : Timer respons�vel pela execu��o
//------------------------------------------------------------------------------
  procedure TPeriodicTable.CursorMouseTimer(Sender: TObject);
  var I, J, K : Byte;
  begin
    // Se bot�o esquerdo do mouse pressionado
    if GetAsyncKeyState(VK_LButton) <> 0 then
      // Para todos os elementos qu�micos
      for I := 1 to 120 do
        // Para todos os pixels da largura da imagem do s�mbolo dos elementos
        for J := 0 to Picture[I].Width do
          // Para todos os pixels da altura da imagem do s�mbolo dos elementos
          for K := 0 to Picture[I].Height - 1 do
            // Se o cursor foi pressionado na posi��o de algum dos elementos
            if ( Mouse.CursorPos.X = Picture[I].Left + J ) and
               ( Mouse.CursorPos.Y = Picture[I].Top + K  ) then
              if ( CursorIndex <> I ) then
              begin
                // Define nova posi��o para o cursor
                CursorIndex := I;
                // Move o cursor
                MoveCursor(2);
              end
  end;

//------------------------------------------------------------------------------
// * Processo ao clicar no bot�o 'Outras Propriedades'
//    Sender : Timer respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TPeriodicTable.BotaoClick(Sender: TObject);
  begin
    // Se Outras Propriedades n�o for acess�vel
    if not EnableButton then
    begin
      // Reproduz efeito sonoro de erro
      Play_Error();
      // Sai do m�todo
      Exit();
    end;
    // Reproduz efeito de confirma��o
    Play_Decision(1);
    // Tabela peri�dica � desativada
    ActiveForm := False;
    // Armazena o estado do cursor
    SaveCursorIndex := CursorIndex;
    // Avisa � janela Outras Propriedades que est� chamando-a
    WindowPropertie.WentFromTable;
    // Exibe a janela de propriedades
    WindowPropertie.Show();
    // Esconde a tabela
    PeriodicTable.Hide();
  end;

//------------------------------------------------------------------------------
// * Processo ao fechar a tabela peri�dica
//------------------------------------------------------------------------------
  procedure TPeriodicTable.OnClose(Sender: TObject; var Action: TCloseAction);
  begin
    // Finaliza o programa
    DataModule1.DataModuleDestroy(Self);
  end;

//------------------------------------------------------------------------------
// * Processo ao apertar o bot�o esquerdo do mouse
//    Sender : Componente respons�vel pela execu��o (Bot�o Outras Propriedades)
//    Button : Tipo de bot�o ( Esquerdo, Direito e etc .. )
//    Shift  : Estado da tecla CTRL
//    X      : Posi��o X do Cursor dentro do Bot�o
//    Y      : Posi��o Y do Cursor dentro do Bot�o
//------------------------------------------------------------------------------
procedure TPeriodicTable.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
    // Altera a imagem do Bot�o
    Botao.Picture.LoadFromFile('Graphics\Tabela\Bot�o\Pressionado.png');
    // Armazena a confirma��o de que o bot�o est� sendo pressionado
    ActiveButton := true;
  end;

//------------------------------------------------------------------------------
// * Processo executado ao adentrar as coordenadas do bot�o 'Outras Propriedades'
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
  procedure TPeriodicTable.OnMouseEnter(Sender: TObject);
  begin
    // Se o bot�o estiver sendo pressionado
    if ActiveButton then
      // Sai do m�todo
      Exit();
    // Altera a imagem
    Botao.Picture.LoadFromFile('Graphics\Tabela\Bot�o\MouseSob.png')
  end;

//------------------------------------------------------------------------------
// * Processo executado ao sair dos limites das coordenadas do bot�o
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
  procedure TPeriodicTable.OnMouseLeave(Sender: TObject);
  begin
    // Se o bot�o estiver sendo pressionado
    if ActiveButton then
      // Sai do m�todo
      Exit();
    // Altera a imagem
    Botao.Picture.LoadFromFile('Graphics\Tabela\Bot�o\Normal.png');
  end;

//------------------------------------------------------------------------------
// * Processo executado ao soltar o bot�o esquerdo do mouse sobre o bot�o
//    Sender : Componente respons�vel pela execu��o
//    Button : Tipo de bot�o ( Esquerdo, Direito e etc .. )
//    Shift  : Estado da tecla CTRL
//    X      : Posi��o X do Cursor dentro do Bot�o
//    Y      : Posi��o Y do Cursor dentro do Bot�o
//------------------------------------------------------------------------------
  procedure TPeriodicTable.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
    // Armazena a confirma��o de que o bot�o n�o est� sendo pressionado
    ActiveButton := false;
  end;

//------------------------------------------------------------------------------
// * Cria��o do Fomul�rio
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TPeriodicTable.FormCreate(Sender: TObject);
begin
  // Armazenas as imagens dos s�mbolos dos elementos
  KeepPicture();
  // Adapta o formul�rio aos demais
  PerformForm(Self);
  // Atribui��o inicial �s variaveis
  WhereTo := 0;
  CursorIndex := 1;
  ActiveForm  := False;
  SaveCursorIndex := 1;
  EnableButton := true;
  // Exibe as informa��es do Hidrog�nio como iniciais
  Nome.Caption := Elemento[1].Get_Elemento(1);
  AtomicNumber.Caption := Elemento[1].Get_Elemento(0);
  AtomicWeight.Caption := Elemento[1].Get_Elemento(3);
end;

//------------------------------------------------------------------------------
// * Ao soltar qualquer tecla pressionada
//    Sender : Componente respons�vel pela execu��o
//    Key    : Tecla
//    Shift  : Estado da tecla CTRL
//------------------------------------------------------------------------------
procedure TPeriodicTable.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  { Se ainda n�o foi estabelecido de onde veio e o bloqueio de tecla
    estiver ativo }
  if ( WhereTo = 0 ) or ( Gambz_[1] < 10 ) then
    // Sai do m�todo
    Exit();

  // Se a tecla Escape � pressionada
  if GetAsyncKeyState(VK_ESCAPE) <> 0 then
    begin
      // Executa efeito sonoro de cancelamento
      Play_Cancel();
      // Define Tabela peri�dica como n�o ativa
      ActiveForm := False;
      // Torna a tabela inacess�vel
      Tabela.PeriodicTable.Enabled := false;
      // Torna-a inacess�vel
      Tabela.PeriodicTable.Visible := False;
      // Armazena o estado do cursor
      SaveCursorIndex := CursorIndex;
      // Checa de onde a tabela foi chamada
      case WhereTo of
      // Envia a cena para a �ltima janela
      1 : EletronicDistribution.Show;
      2 : CalculoEstequiometrico.Show();
      3 : Inicio.Show();
      end;
      // Esconde a tabela peri�dica
      PeriodicTable.Hide();
      // Define como tabela n�o chamada
      WhereTo := 0;
    end;
end;

//------------------------------------------------------------------------------
// * Processo de exibi��o da tabela
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TPeriodicTable.OnShow(Sender: TObject);
begin
  // Torna a janela ativa
  ActiveForm  := True;
  // Define novo cursor para o mouse
  Screen.Cursor := 5;
end;

//------------------------------------------------------------------------------
// * Update
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
  procedure TPeriodicTable.OtherTimer(Sender: TObject);
  begin

    // Se a tecla 'Enter' estiver pressionada
    if GetAsyncKeyState(VK_Return) <> 0 then
      // Se estiver na 1� casa branca
      if ( CursorIndex = 57 ) then
      begin
        // Define posi��o do cursor como sendo o Lant�nio
        CursorIndex := 91;
        // Move o cursor para posi��o definida
        MoveCursor();
      end
      // Se estiver na 2� casa branca
      else if ( CursorIndex = 75 ) then
      begin
        // Define posi��o do cursor como sendo o Act�neo
        CursorIndex := 106;
        // Move o cursor para a posi��o definida
        MoveCursor();
      end;
  end;

end.

