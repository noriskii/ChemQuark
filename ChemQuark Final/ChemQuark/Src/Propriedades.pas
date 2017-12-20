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
// Esta classe é responsável por exibir informações sobre cada elemento
// químico da tabela periódica.
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
  // Número atômico do elemento químico a ser exibido
  ID : Byte = 1;
  // Redirecionado a partir da tabela periódica ?
  FromTable : Boolean;

implementation

uses Tabela;

{$R *.dfm}

//------------------------------------------------------------------------------
// * Quando chamada a partir da tabela periódica
//------------------------------------------------------------------------------
procedure TWindowPropertie.WentFromTable;
begin
  // Atribui que a classe foi chamada a partir da tabela
  FromTable := True;
end;

//------------------------------------------------------------------------------
// * Quando chamada de um game
//    Index : Elemento químico
//------------------------------------------------------------------------------
procedure TWindowPropertie.WentFromGame(Index: Byte);
begin
  // Atribui que a classe não foi chamada da tabela periódica
  FromTable := False;
  // Armazena o número atômico do elemento químico
  ID := Index;
end;

//------------------------------------------------------------------------------
// * Destruição do formulário
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
procedure TWindowPropertie.FormDestroy(Sender: TObject);
begin
  // Chama o destruidor de formulários
  DataModule1.DataModuleDestroy(Self);
end;

//------------------------------------------------------------------------------
// * Evento ao clicar no botão Voltar
//    Sender : Componente responsável pela execução
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
//    Sender : Componente responsável pela execução
//    Action : Tipo de ação
//------------------------------------------------------------------------------
procedure TWindowPropertie.OnClose(Sender: TObject; var Action: TCloseAction);
  var GambzX, GambzY : Integer;
begin
  // Se a classe foi chamada a partir da tabela periódica
  if FromTable then
  begin
    // Exibe a tabela periódica
    Tabela.PeriodicTable.Show;
    // Torna a tabela periódica acessível
    Tabela.PeriodicTable.Enabled := true;
    // Torna a tabela periódica visível
    Tabela.PeriodicTable.Visible := true;
    // Permite a ativação da tabela periódica
    Tabela.PeriodicTable.ActiveForm := true;
    // Reestabelece a posição do cursor na tabela
    Tabela.PeriodicTable.CursorIndex := Tabela.PeriodicTable.SaveCursorIndex;
    // Altera a imagem do botão
    PeriodicTable.Botao.Picture.LoadFromFile('Graphics\Tabela\Botão\Normal.png');
    // Esconde a janela atual
    WindowPropertie.Hide();
  end
  // Se foi chamado pelo jogo Distribuição Eletrônica
  else
  begin
    // Exibe o jogo
    EletronicDistribution.Show();
    // Esconde a janela atual
    WindowPropertie.Hide();
  end;
end;

//------------------------------------------------------------------------------
// * Processo executado ao apertar o botão do mouse sobre o botão 'Voltar'
//    Sender : Componente responsável pela execução ( Botão Voltar )
//    Action : Tipo de ação
//    Button : Tipo de botão ( Esquerdo, Direito e etc .. )
//    Shift  : Estado da tecla CTRL
//    X      : Posição X do Cursor dentro do Botão
//    Y      : Posição Y do Cursor dentro do Botão
//------------------------------------------------------------------------------
procedure TWindowPropertie.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Altera a imagem do botão 'Voltar'
  Botao.Picture.LoadFromFile('Graphics/Properties/Botao/Press.png');
end;

//------------------------------------------------------------------------------
// * Processo executado ao adentrar as coordenadas do botão 'Voltar'
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
procedure TWindowPropertie.OnMouseEnter(Sender: TObject);
begin
  // Altera a imagem do botão 'Voltar'
  Botao.Picture.LoadFromFile('Graphics/Properties/Botao/Sob.png');
end;

//------------------------------------------------------------------------------
// * Processo executado ao sair dos limites das coordenadas do botão 'Voltar'
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
procedure TWindowPropertie.OnMouseLeave(Sender: TObject);
begin
  // Altera a imagem do botão 'Voltar'
  Botao.Picture.LoadFromFile('Graphics/Properties/Botao/Normal.png');
end;

//------------------------------------------------------------------------------
// * Processo executado ao soltar o botão esquerdo do mouse sobre o botão Voltar
//    Sender : Componente responsável pela execução
//    Button : Tipo de botão ( Esquerdo, Direito e etc .. )
//    Shift  : Estado da tecla CTRL
//    X      : Posição X do Cursor dentro do Botão
//    Y      : Posição Y do Cursor dentro do Botão
//------------------------------------------------------------------------------
procedure TWindowPropertie.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Altera a imagem do botão 'Voltar'
  Botao.Picture.LoadFromFile('Graphics/Properties/Botao/Normal.png');
end;

//------------------------------------------------------------------------------
// * Exibe a janela
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
procedure TWindowPropertie.OnShow(Sender: TObject);
  var Properties : Array[0..23] of TLabel;
      I : Byte;
begin

  // Atribuição de Labels a um conjunto
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


  // Para todos os labels do formulário
  for I := 0 to 23 do
    // Se diferente de Configuração Eletrônica
    if I <> 12 then
      // Se chamado pela tabela periódica
      if FromTable then
      begin
        // Obtém a informação do elemento e a atribui ao label
        Properties[I].Caption := Elemento[PeriodicTable.AtomicPicture[PeriodicTable.SaveCursorIndex]].Get_Elemento(I);
        // Carrega a imagem do elemento químico
        Imagem.Picture.LoadFromFile(Elemento[PeriodicTable.AtomicPicture[PeriodicTable.SaveCursorIndex]].Get_Elemento(25));
      end
      // Se chamado pelo jogo Distribuição Eletrônica
      else
      begin
        // Obtém a informação do elemento e a atribui ao label
        Properties[I].Caption := Elemento[ID].Get_Elemento(I);
        // Carrega a imagem do elemento químico
        Imagem.Picture.LoadFromFile(Elemento[ID].Get_Elemento(25));
      end;
  // Adapta formulário aos demais
  PerformForm(Self);
end;

end.
