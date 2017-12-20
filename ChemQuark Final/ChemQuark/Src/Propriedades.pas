unit Propriedades;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls, MMSystem, JogoDistribuicao, jpeg,
  DB_Integrator, Sound;

type
//==============================================================================
// ** TWindowPropertie
//------------------------------------------------------------------------------
// Esta classe � respons�vel por exibir informa��es sobre cada elemento
// qu�mico da tabela peri�dica.
//==============================================================================
  TWindowPropertie = class(TForm)
    Propriedades: TImage;
    Nome: TLabel;
    NumeroAtomico: TLabel;
    MassaAtomica: TLabel;
    Simbolo: TLabel;
    Grupo: TLabel;
    Periodo: TLabel;
    Bloco: TLabel;
    Eletrons: TLabel;
    SerieQuimica: TLabel;
    RaioAtomico: TLabel;
    RaioCovalente: TLabel;
    RaioVanDerWalls: TLabel;
    ConfiguracaoEletronica: TLabel;
    EstruturaCristalina: TLabel;
    EstadoDaMateria: TLabel;
    PontoDeFusao: TLabel;
    PontoDeEbulicao: TLabel;
    PressaoAoVapor: TLabel;
    VelocidadeDoSom: TLabel;
    CalorEspecifico: TLabel;
    CondutividadeTermica: TLabel;
    ClasseMagnetica: TLabel;
    Eletronegatividade: TLabel;
    Descricao: TLabel;
    Imagem: TImage;
    Botao: TImage;
    procedure OnShow(Sender: TObject);
    procedure OnClose(Sender: TObject; var Action: TCloseAction);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
    procedure OnClick(Sender: TObject);
    procedure WentFromTable;
    procedure WentFromGame( Index : Byte );
    procedure FormDestroy(Sender: TObject);
  private
  public
  end;

var
  WindowPropertie: TWindowPropertie;
  // N�mero at�mico do elemento qu�mico a ser exibido
  ID : Byte = 1;
  // Redirecionado a partir da tabela peri�dica ?
  FromTable : Boolean;

implementation

uses Tabela;

{$R *.dfm}

//------------------------------------------------------------------------------
// * Quando chamada a partir da tabela peri�dica
//------------------------------------------------------------------------------
procedure TWindowPropertie.WentFromTable;
begin
  // Atribui que a classe foi chamada a partir da tabela
  FromTable := True;
end;

//------------------------------------------------------------------------------
// * Quando chamada de um game
//    Index : Elemento qu�mico
//------------------------------------------------------------------------------
procedure TWindowPropertie.WentFromGame(Index: Byte);
begin
  // Atribui que a classe n�o foi chamada da tabela peri�dica
  FromTable := False;
  // Armazena o n�mero at�mico do elemento qu�mico
  ID := Index;
end;

//------------------------------------------------------------------------------
// * Destrui��o do formul�rio
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TWindowPropertie.FormDestroy(Sender: TObject);
begin
  // Chama o destruidor de formul�rios
  DataModule1.DataModuleDestroy(Self);
end;

//------------------------------------------------------------------------------
// * Evento ao clicar no bot�o Voltar
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TWindowPropertie.OnClick(Sender: TObject);
begin
  // Executa efeito sonoro
  Play_Cancel();
  // Fecha a janela
  Close();
end;

//------------------------------------------------------------------------------
// * Processa o fechamento da janela
//    Sender : Componente respons�vel pela execu��o
//    Action : Tipo de a��o
//------------------------------------------------------------------------------
procedure TWindowPropertie.OnClose(Sender: TObject; var Action: TCloseAction);
  var GambzX, GambzY : Integer;
begin
  // Se a classe foi chamada a partir da tabela peri�dica
  if FromTable then
  begin
    // Exibe a tabela peri�dica
    Tabela.PeriodicTable.Show;
    // Torna a tabela peri�dica acess�vel
    Tabela.PeriodicTable.Enabled := true;
    // Torna a tabela peri�dica vis�vel
    Tabela.PeriodicTable.Visible := true;
    // Permite a ativa��o da tabela peri�dica
    Tabela.PeriodicTable.ActiveForm := true;
    // Reestabelece a posi��o do cursor na tabela
    Tabela.PeriodicTable.CursorIndex := Tabela.PeriodicTable.SaveCursorIndex;
    // Altera a imagem do bot�o
    PeriodicTable.Botao.Picture.LoadFromFile('Graphics\Tabela\Bot�o\Normal.png');
    // Esconde a janela atual
    WindowPropertie.Hide();
  end
  // Se foi chamado pelo jogo Distribui��o Eletr�nica
  else
  begin
    // Exibe o jogo
    EletronicDistribution.Show();
    // Esconde a janela atual
    WindowPropertie.Hide();
  end;
end;

//------------------------------------------------------------------------------
// * Processo executado ao apertar o bot�o do mouse sobre o bot�o 'Voltar'
//    Sender : Componente respons�vel pela execu��o ( Bot�o Voltar )
//    Action : Tipo de a��o
//    Button : Tipo de bot�o ( Esquerdo, Direito e etc .. )
//    Shift  : Estado da tecla CTRL
//    X      : Posi��o X do Cursor dentro do Bot�o
//    Y      : Posi��o Y do Cursor dentro do Bot�o
//------------------------------------------------------------------------------
procedure TWindowPropertie.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Altera a imagem do bot�o 'Voltar'
  Botao.Picture.LoadFromFile('Graphics/Properties/Botao/Press.png');
end;

//------------------------------------------------------------------------------
// * Processo executado ao adentrar as coordenadas do bot�o 'Voltar'
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TWindowPropertie.OnMouseEnter(Sender: TObject);
begin
  // Altera a imagem do bot�o 'Voltar'
  Botao.Picture.LoadFromFile('Graphics/Properties/Botao/Sob.png');
end;

//------------------------------------------------------------------------------
// * Processo executado ao sair dos limites das coordenadas do bot�o 'Voltar'
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TWindowPropertie.OnMouseLeave(Sender: TObject);
begin
  // Altera a imagem do bot�o 'Voltar'
  Botao.Picture.LoadFromFile('Graphics/Properties/Botao/Normal.png');
end;

//------------------------------------------------------------------------------
// * Processo executado ao soltar o bot�o esquerdo do mouse sobre o bot�o Voltar
//    Sender : Componente respons�vel pela execu��o
//    Button : Tipo de bot�o ( Esquerdo, Direito e etc .. )
//    Shift  : Estado da tecla CTRL
//    X      : Posi��o X do Cursor dentro do Bot�o
//    Y      : Posi��o Y do Cursor dentro do Bot�o
//------------------------------------------------------------------------------
procedure TWindowPropertie.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Altera a imagem do bot�o 'Voltar'
  Botao.Picture.LoadFromFile('Graphics/Properties/Botao/Normal.png');
end;

//------------------------------------------------------------------------------
// * Exibe a janela
//    Sender : Componente respons�vel pela execu��o
//------------------------------------------------------------------------------
procedure TWindowPropertie.OnShow(Sender: TObject);
  var Properties : Array[0..23] of TLabel;
      I : Byte;
begin

  // Atribui��o de Labels a um conjunto
  Properties[0]  := NumeroAtomico;
  Properties[1]  := Nome;
  Properties[2]  := Simbolo;
  Properties[3]  := MassaAtomica;
  Properties[4]  := Grupo;
  Properties[5]  := Periodo;
  Properties[6]  := Bloco;
  Properties[7]  := Eletrons;
  Properties[8]  := SerieQuimica;
  Properties[9]  := RaioAtomico;
  Properties[10] := RaioCovalente;
  Properties[11] := RaioVanDerWalls;
  Properties[12] := ConfiguracaoEletronica;
  Properties[13] := EstruturaCristalina;
  Properties[14] := EstadoDaMateria;
  Properties[15] := PontoDeFusao;
  Properties[16] := PontoDeEbulicao;
  Properties[17] := PressaoAoVapor;
  Properties[18] := VelocidadeDoSom;
  Properties[19] := CalorEspecifico;
  Properties[20] := CondutividadeTermica;
  Properties[21] := ClasseMagnetica;
  Properties[22] := Eletronegatividade;
  Properties[23] := Descricao;

  // Altera o Cursor para o Foguetinho
  Screen.Cursor := 5;


  // Para todos os labels do formul�rio
  for I := 0 to 23 do
    // Se diferente de Configura��o Eletr�nica
    if I <> 12 then
      // Se chamado pela tabela peri�dica
      if FromTable then
      begin
        // Obt�m a informa��o do elemento e a atribui ao label
        Properties[I].Caption := Elemento[PeriodicTable.AtomicPicture[PeriodicTable.SaveCursorIndex]].Get_Elemento(I);
        // Carrega a imagem do elemento qu�mico
        Imagem.Picture.LoadFromFile(Elemento[PeriodicTable.AtomicPicture[PeriodicTable.SaveCursorIndex]].Get_Elemento(25));
      end
      // Se chamado pelo jogo Distribui��o Eletr�nica
      else
      begin
        // Obt�m a informa��o do elemento e a atribui ao label
        Properties[I].Caption := Elemento[ID].Get_Elemento(I);
        // Carrega a imagem do elemento qu�mico
        Imagem.Picture.LoadFromFile(Elemento[ID].Get_Elemento(25));
      end;
  // Adapta formul�rio aos demais
  PerformForm(Self);
end;

end.
