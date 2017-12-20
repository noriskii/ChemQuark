//==============================================================================
// *** DB_Integrator
//------------------------------------------------------------------------------
// Módulo responsável por funções padrões
// - Adaptação do formulário
// - Mudança de resolução
// - Modificação de Strings
// - Acesso ao Banco de Dados
//==============================================================================
unit DB_Integrator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBCtrls, Grids, DBGrids, DB, ADODB, StdCtrls, Mask,
  DBTables, Elementos, MMSystem;

  // Informações dos elementos periódicos
  var Elemento : Array[1..118] of TElemento; // Banco de dados
  // Resolução do monitor do usuário
  var Before_Resolution : Array[1..2] of Integer; // Antigas configurações

type
  TDataModule1 = class(TDataModule)
    DataSource1: TDataSource;
    ADOTable1: TADOTable;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    ADOTable2: TADOTable;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    ADOTable3: TADOTable;
    ADOQuery3: TADOQuery;
    DataSource4: TDataSource;
    ADOTable4: TADOTable;
    ADOQuery4: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure Start();
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
    procedure PerformForm(Sender: TForm);
    function RemovePoints( Text : String ) : Real;
    function SpaceDelete(Text : String) : String;
    function OrdinalToCardinal( Number : Byte ) : String;
    function Crypt( Word : String ) : String;
    function ChemistryFormat( Text : String ) : String;

var
  DataModule1: TDataModule1;

implementation

uses Geometry;

{$R *.dfm}

//------------------------------------------------------------------------------
// * Converte números ordinais em cardinais ( Somente os 10 primeiros )
//    Number : 0..9
//------------------------------------------------------------------------------
function OrdinalToCardinal( Number : Byte ) : String;
begin
  // Conversão
  case Number of
    0: Result := 'Nula';
    1: Result := 'Primeira';
    2: Result := 'Segunda';
    3: Result := 'Terceira';
    4: Result := 'Quarta';
    5: Result := 'Quinta';
    6: Result := 'Sexta';
    7: Result := 'Sétima';
    8: Result := 'Oitava';
    9: Result := 'Nona';
  end;
end;

//------------------------------------------------------------------------------
// * Deleta todos os espaços presentes em um Texto
//    Text : Texto qualquer
//------------------------------------------------------------------------------
function SpaceDelete(Text : String) : String;
var I : Integer;
begin
  I := 1;
  // Para todos os caracteres do texto
  while I <= Length(Text) do
  begin
    // Se encontrar um espaço
    if Text[I] = #32 then
      // Delete-o
      Delete(Text,I,1)
    // Caso não encontre um espaço
    else
      // Passa para o próximo caracter
      I := I + 1;
  end;
  // Retorna o texto sem espaços
  Result := Text;
end;

// Formata equaçõs químicas
function ChemistryFormat( Text : String ) : String;
  var I, J, K, Y: Byte;
  var Can : Boolean;
  var Sub : Char;
begin
  Text := SpaceDelete(Text);
  Text := Text + #32;
  for J := 2 to Length(Text) do
    for I := 0 to 9 do
      if Text[J] = IntToStr(I) then
      begin
        for K := 0 to 9 do
          if (Text[J + 1] = IntToStr(K)) then
            Y := 2;

        if (Text[J + Y] = '+') or (Text[J + Y] = #32) or (Text[J + Y] = '-') then
          Can := True;

        if (Text[J + Y] <> '-') and (Text[J - Y] <> '-') and (Text[J + Y] <> '+')
                               and (Text[J - Y] <> '+') and (Text[J + Y] <> #32)
                               and (Text[J - Y] <> #32) and (Text[J - Y] <> '>') then
          Can := True;

        if Can then
        begin
          case I of
            0: Sub := 'Í';
            1: Sub := 'Ì';
            2: Sub := '¿';
            3: Sub := 'À';
            4: Sub := 'Á';
            5: Sub := 'Â';
            6: Sub := 'Ã';
            7: Sub := 'Î';
            8: Sub := 'Ï';
            9: Sub := 'ß';
          end;
          Delete(Text,J,1);
          Insert(Sub, Text, J);
          Can := False;
        end;
        Y := 1;
        Can := False;
      end;

  I := 1;
  while I < Length(Text) do
  begin
    if Text[I] = '+' then
    begin
      Delete(Text, I, 1);
      Insert(' + ', Text, I);
      I := I + 2;
    end
    else if Text[I] = '-' then
    begin
      Delete(Text, I, 2);
      Insert(' -> ', Text, I);
      I := I + 3;
    end;
    I := I + 1;
  end;

  Result := Text;
end;

//------------------------------------------------------------------------------
// * Substitui pontos(.) por vírgulas(,)
//    Text : Texto qualquer
//------------------------------------------------------------------------------
function RemovePoints( Text : String ) : Real;
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
  Result := StrToFloatDef(Text,0);

end;

//------------------------------------------------------------------------------
// * Adapta o formulário
//    Sender : Formulário que se adaptará
//------------------------------------------------------------------------------
procedure PerformForm(Sender: TForm);
begin
  // Torna o cursor visível
  ShowCursor(True);
  // Com o formulário
  With Sender do
    begin
      BorderStyle := BsNone; // Forma sem bordas
      Width  := Screen.Width; // Largura da forma proporcional à da tela
      Height := Screen.Height; // Altura da forma proporcional à da tela
      Left   := 0; // Coordenada X inicial da forma
      Top    := 0; // Coordenada Y inicial da forma
      DoubleBuffered := true;
      AlphaBlend := true;
    end;
end;

//------------------------------------------------------------------------------
// * Criação da Classe
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  // Ativa o banco de dados
  AdoTable1.Open;
  AdoTable2.Open;
  AdoTable3.Open;
  AdoTable4.Open;
  // Ativa a conexão com o banco de dados
  AdoQuery1.Open;
  AdoQuery2.Open;
  AdoQuery3.Open;
  AdoQuery4.Open;
  // Executa tabela professor
  DataModule1.ADOQuery4.ExecSQL;
  DataModule1.ADOQuery2.ExecSQL;

  // Cria um novo Cursor
  Screen.Cursors[ 5 ] := Windows.LoadCursorFromFile('Graphics/System/Cursor1.cur');
  // Altera o cursor para o novo cursor criado
  Screen.Cursor := 5;
  // Inicializa o programa
  Start();
end;

//------------------------------------------------------------------------------
// * Alteração da Resolução da tela
//    Width  : Largura da tela
//    Height : Altura  da tela
//------------------------------------------------------------------------------
  procedure Set_ScreenResolution(Width, Height : Integer);
    var Mode : TDevMode; // Instância para modificação de tela
  begin
    ZeroMemory(@mode, SizeOf( TDevMode )); // Zera as configurações
    Mode.DmSize       := SizeOf(TDevMode); // Define tipo de configuração
    mode.DmPelsWidth  := Width; // Nova largura da resolução
    mode.DmPelsHeight := Height; // Nova altura da resolução
    mode.DmFields     := Dm_PelsWidth or Dm_PelsHeight; // Especifica modificações
    ChangeDisplaySettings(Mode, 0); // Altera definitivamente
  end;

//------------------------------------------------------------------------------
// * Guarda informações de resolução
//------------------------------------------------------------------------------
  procedure Keep_ScreenResolution;
  begin
    Before_Resolution[1] := Screen.Width; // Guarda a largura da tela
    Before_Resolution[2] := Screen.Height; // Guarda a altura da tela
  end;

//------------------------------------------------------------------------------
// * Altera a resolução para a resolução 1024x768
//------------------------------------------------------------------------------
  procedure GoScreenSettings;
    var HTaskBar : HWND; // Instância de componentes do sistema operacional
    var R : TRect;
  begin
    Keep_ScreenResolution(); // Guarda as configurações de vídeo
    Set_ScreenResolution(1024, 768); // Define novas configurações
    SystemParametersInfo(SPI_GETWORKAREA, 0, @r,0);
  end;

//------------------------------------------------------------------------------
// * Retorna à resolução padrão
//------------------------------------------------------------------------------
  procedure ReturnScreenSettings;
  var HTaskBar : HWND; // Instância de componentes do sistema operacional
  begin
    { Retorna resolução }
    Set_ScreenResolution(Before_Resolution[1], Before_Resolution[2]);
    HTaskBar := FindWindow('Shell_TrayWnd', nil); // Instância a Barra de Tarefas
    EnableWindow(HTaskBar, True); // Torna a barra acessível
    ShowWindow(HTaskbar, Sw_Show); // Torna a barra inacessível
  end;

//------------------------------------------------------------------------------
// * Destruição do formulário
//    Sender : Componente responsável pela execução
//------------------------------------------------------------------------------
  procedure TDataModule1.DataModuleDestroy(Sender: TObject);
  begin
    ReturnScreenSettings();
    Application.Terminate();
  end;

//------------------------------------------------------------------------------
// * Inicializa o programa
//------------------------------------------------------------------------------
procedure TDataModule1.Start;
  begin
    GoScreenSettings(); // Define novas configurações de vídeo
    { Guarda informações em banco de dados interno }
    Elemento[1] := TElemento. Create ( 1, 'Hidrogênio', 'H', 1.00794, '1', 1, 's', '1', 'Não-Metal', '53 pm', '37 pm', '120 pm',                             '1s1 ', 'hexagonal', 'gasoso', '14,025 K', '20,268 K', '209 Pa a 23 K', '1270 m/s a 20 °C', 14304, '0,1815 W/(m•K) ', '1312 kJ/mol', 'Diamagnético', '2,2', 'O hidrogênio é o elemento mais simples, constituído por um núcleo contendo um próton com um elétron orbitando em sua volta.' + ^m + ^m + 'Este elemento não é encontrado livre na natureza em sua forma atômica, é localizado sempre na composição de outras substâncias.' + ^m + 'Sua grande instabilidade o torna muito reativo.', 'Graphics/Properties/Pictures/1' );
    Elemento[2] := TElemento. Create ( 2, 'Hélio', 'He', 4.002602, '18', 1, 's', '2', 'Gases Nobres', '21 pm', '32 pm', '140 pm',                         '1s2 ', 'hexagonal', 'gasoso', '0,95 K', '4,22 K', '100 Pa a 1,23 K', '972 m/s a 20 °C', 5193, '0,152 W/(m•K) ', '2372,3 kJ/mol', '-', '-', ' ' );
    Elemento[3] := TElemento. Create ( 3, 'Lítio', 'Li', 6.941, '1', 2, 's', '2, 1', 'Metais Alcalinos', '152 pm', '134 pm', '182 pm',                       '1s2 2s1 ', 'cúbico de corpo centrado', 'sólido', '453 K', '1615 K', '1,63', '6000 m/s a 20 °C', 3582, '84,7 W/(m•K) ', '520,2 kJ/mol', 'Paramagnético', '0,98', ' ' );
    Elemento[4] := TElemento. Create ( 4, 'Berílio', 'Be', 9.012182, '2', 2, 's', '2, 2', 'Metal Alcalinoterroso', '112 pm', '90 pm', '153 pm',             '1s2 2s2 ', 'hexagonal', 'sólido', '1560 K', '2744 K', '1 Pa a 1462 K', '13000 m/s a 20 °C', 1825, '201 W/(m•K) ', '899,5 kJ/mol', 'Diamagnético', '1,57', ' ' );
    Elemento[5] := TElemento. Create ( 5, 'Boro', 'B', 10.811, '13', 2, 's', '2, 3', 'Semimetal', '87 pm', '82 pm', '192 pm',                              '1s2 2s2 2p1 ', 'tetragonal', 'sólido', '2348 K', '4273 K', '0,348', '16200 m/s a 20 °C', 1026, '27,4 W/(m•K) ', '800,6 kJ/mol', '-', '2,04', ' ' );
    Elemento[6] := TElemento. Create ( 6, 'Carbono', 'C', 12.0107, '14', 2, 'p', '2, 4', 'Não-Metal', '67 pm', '77 pm', '170 pm',                           '1s2 2s2 2p2 ', 'hexagonal', 'sólido', '-', '-', '-', '18 350 m/s a 20 °C', 710, '129 W/(m•K) ', '1086,5 kJ/mol', '-', '2,55', ' ' );
    Elemento[7] := TElemento. Create ( 7, 'Nitrogênio', 'N', 14.0067, '15', 2, 'p', '2, 5', 'Não-Metal', '65 pm', '75 pm', '155 pm',                         '1s2 2s2 2p3 ', 'hexagonal', 'gasoso', '63,15 K', '75,36 K', '-', '334 m/s a 20 °C', 1040, '0,02598 W/(m•K) ', '1402,3 kJ/mol', 'Diamagnético', '3,04', ' ' );
    Elemento[8] := TElemento. Create ( 8, 'Oxigênio', 'O', 15.9994, '16', 2, 'p', '2, 6', 'Não-Metal', '48 pm', '73 pm', '152 pm',                          '1s2 2s2 2p4 ', 'cúbico', 'gasoso', '50,35 K', '90,18 K', '-', '317,5 m/s a 20 °C', 920, '0,02674 W/(m•K) ', '1313,9 kJ/mol', 'Paramagnético', '3,44', ' ' );
    Elemento[9] := TElemento. Create ( 9, 'Flúor', 'F', 18.9984032, '17', 2, 'p', '2, 7', 'Halogênio', '42 pm', '71 pm', '147 pm',                         '1s2 2s2 2p5 ', 'cúbico', 'gasoso', '53,53 K', '85,03 K', '-', '-', 824, '0,0279 W/(m•K) ', '1681 kJ/mol', '-', '3,98', ' ' );
    Elemento[10] := TElemento. Create ( 10, 'Neônio', 'Ne', 20.1797, '18', 2, 'p', '2, 8', 'Gases Nobres', '38 pm', '69 pm', '154 pm',                    '1s2 2s2 2p6 ', 'cúbico de faces centradas', 'gasoso', '24,56 K', '27,07 K', '1 Pa a 12 K', '435 m/s a 20 °C', 103, '0,0493 W/(m•K) ', '2080,7 kJ/mol', '-', '-', ' ' );
    Elemento[11] := TElemento. Create ( 11, 'Sódio', 'Na', 22.98976928, '1', 3, 's', '2, 8, 1', 'Metais Alcalinos', '186 pm', '154 pm', '227 pm',            '1s2 2s2 2p6 3s1 ', 'cúbico de corpo centrado', 'sólido', '370,95 K', '1156 K', '1 Pa a 554 K', '3200 m/s a 20 °C', 1230, '141 W/(m•K) ', '495,8 kJ/mol', 'Paramagnético', '0,93', ' ' );
    Elemento[12] := TElemento. Create ( 12, 'Magnésio', 'Mg', 24.305, '2', 3, 's', '2, 8, 2', 'Metal Alcalinoterroso', '160 pm', '130 pm', '173 pm',        '1s2 2s2 2p6 3s2 ', 'hexagonal', 'sólido', '923 K', '1363 K', '361 Pa a 923 K', '4602 m/s a 20 °C', 1020, '156 W/(m•K) ', '737,7 kJ/mol', 'Paramagnético', '1,31', ' ' );
    Elemento[13] := TElemento. Create ( 13, 'Alumínio', 'Al', 26.9815386, '13', 3, 'p', '2, 8, 3', 'Metais Representativos', '143 pm', '121 pm', '184 pm', '1s2 2s2 2p6 3s2 3p1 ', 'cúbico de faces centradas', 'sólido', '933,47 K', '2792 K', '-', '-', 900, '237 W/(m•K) ', '577,5 kJ/mol', 'Paramagnético', '1,61', ' ' );
    Elemento[14] := TElemento. Create ( 14, 'Silício', 'Si', 28.0855, '14', 3, 'p', '2, 8, 4', 'Semimetais', '111 pm', '111 pm', '210 pm',                  '1s2 2s2 2p6 3s2 3p2 ', 'cúbico de faces centradas', 'sólido', '1687 K', '3538 K', '-', '8433 m/s a 20 °C', 700, '148 W/(m•K) ', '786,5 kJ/mol', '-', '1,9', ' ' );
    Elemento[15] := TElemento. Create ( 15, 'Fósforo', 'P', 30.973762, '15', 3, 'p', '2, 8, 5', 'Não-Metais', '98 pm', '106 pm', '180 pm',                   '1s2 2s2 2p6 3s2 3p3 ', 'alótropos com várias estruturas', 'sólido', '317,3 K', '553,6 K', '(B)1 Pa a 279 K ou (V)1 Pa a 455 K', '-', 12.4, '0,236 W/(m•K) ', '1011,8 kJ/mol', '-', '2,19', ' ' );
    Elemento[16] := TElemento. Create ( 16, 'Enxofre', 'S', 32.065, '16', 3, 'p', '2, 8, 6', 'Não-Metal', '88 pm', '102 pm', '180 pm',                      '1s2 2s2 2p6 3s2 3p4 ', 'ortorrômbico', 'sólido', '388,36 K', '717,75 K', '1 Pa a 375 K', '-', 710, '0,269 W/(m•K) ', '999,6 kJ/mol', '-', '2,58', ' ' );
    Elemento[17] := TElemento. Create ( 17, 'Cloro', 'Cl', 35.453, '17', 3, 'p', '2, 8, 7', 'Halogênio', '79 pm', '99 pm', '175 pm',                       '1s2 2s2 2p6 3s2 3p5 ', 'ortorrômbico', 'gasoso', '171,6 K', '239,11 K', '1000 Pa a 170 K', '-', 480, '0,089 W/(m•K) ', '1251,2 kJ/mol', '-', '3,16', ' ' );
    Elemento[18] := TElemento. Create ( 18, 'Argônio', 'Ar', 39.948, '18 ', 3, 'p', '2, 8, 8', 'Gases Nobres', '71 pm', '97 pm', '188 pm',                         '1s2 2s2 2p6 3s2 3p6 ', 'cúbico de faces centradas', 'gasoso', '83,80 K', '87,30 K', '-', '319 m/s a 20 °C', 520, '0,01772 W/(m•K) ', '1520,6 kJ/mol', '-', '-', ' ' );
    Elemento[19] := TElemento. Create ( 19, 'Potássio', 'K', 39.0983, '1', 4, 's', '2, 8, 8, 1', 'Metais Alcalinos', '243 pm', '196 pm', '275 pm',           '1s2 2s2 2p6 3s2 3p6 4s1 ', 'cúbico de corpo centrado', 'sólido', '336,53 K', '1032 K', '0,000106 Pa a 336,5 K', '2000 m/s a 20 °C', 757, '102,4 W/(m•K) ', '418,8 kJ/mol', 'Paramagnético', '0,82', ' ' );
    Elemento[20] := TElemento. Create ( 20, 'Cálcio', 'Ca', 40.078, '2', 4, 's', '2, 8, 8, 2', 'Metal Alcalinoterroso', '194 pm', '174 pm', '-',            '1s2 2s2 2p6 3s2 3p6 4s2 ', 'cúbico de faces centradas', 'sólido', '1115 K', '1757 K', '254 Pa a 1112 K', '3810 m/s a 20 °C', 632, '201 W/(m•K) ', '589,8 kJ/mol', 'Paramagnético', '1', ' ' );
    Elemento[21] := TElemento. Create ( 21, 'Escândio', 'Sc', 44.955912, '3', 4, 'd', '2, 8, 9, 2', 'Metais de Transição', '184 pm', '144 pm', '-',        '1s2 2s2 2p6 3s2 3p6 4s2 3d1 ', 'hexagonal', 'sólido', '1814 K', '3109 K', '22,1 Pa a 1112 K', '-', 568, '15,8 W/(m•K) ', '633,1 kJ/mol', '-', '1,36', ' ' );
    Elemento[22] := TElemento. Create ( 22, 'Titânio', 'Ti', 47.867, '4', 4, 'd', '2, 8, 10, 2', 'Metais de Transição', '176 pm', '136 pm', '-',            '1s2 2s2 2p6 3s2 3p6 4s2 3d2 ', 'hexagonal', 'sólido', '1941 K', '3560 K', '0,49 Pa a 1933 K', '4140 m/s a 20 °C', 520, '21,9 W/(m•K) ', '658,8 kJ/mol', '-', '1,54', ' ' );
    Elemento[23] := TElemento. Create ( 23, 'Vanádio', 'V', 50.9415, '5', 4, 'd', '2, 8, 11, 2', 'Metais de Transição', '134 pm', '125 pm', '-',                 '1s2 2s2 2p6 3s2 3p6 4s2 3d3 ', 'cúbica centrada no corpo', 'sólido', '2183 K', '3680 K', '1 Pa a 2101 K', '4560 m/s a 20 °C', 489, '30,7 W/(m•K) ', '650,9 kJ/mol', '-', '1,63', ' ' );
    Elemento[24] := TElemento. Create ( 24, 'Cromo', 'Cr', 51.9961, '6', 4, 'd', '2, 8, 13, 1', 'Metais de Transição', '140 pm', '127 pm', '-',                  '1s2 2s2 2p6 3s2 3p6 4s2 3d4 ', 'cúbico de corpo centrado', 'sólido', '2180 K', '2944 K', '1 Pa a 1656 K', '5940 m/s a 20 °C', 448, '93,7 W/(m•K) ', '652,9 kJ/mol', 'Paramagnético', '1,66', ' ' );
    Elemento[25] := TElemento. Create ( 25, 'Manganês', 'Mn', 54.938045, '7', 4, 'd', '2, 8, 13, 2', 'Metais de Transição', '127 pm', '139 pm', '-',             '1s2 2s2 2p6 3s2 3p6 4s2 3d5 ', 'cúbico de corpo centrado', 'sólido', '1519 K', '2334 K', '1 Pa a 1228 K', '5150 m/s a 20 °C', 479, '7,82 W/(m•K) ', '717,3 kJ/mol', '-', '1,55', ' ' );
    Elemento[26] := TElemento. Create ( 26, 'Ferro', 'Fe', 55.845, '8', 4, 'd', '2, 8, 14, 2', 'Metais de Transição', '156 pm', '125 pm', '-',            '1s2 2s2 2p6 3s2 3p6 4s2 3d6 ', 'cúbico de corpo centrado', 'sólido', '1811 K', '3134 K', '7,05 Pa a 1808 K', '4910 m/s a 20 °C', 440, '80,2 W/(m•K) ', '762,5 kJ/mol', 'Ferromagnético', '1,83', ' ' );
    Elemento[27] := TElemento. Create ( 27, 'Cobalto', 'Co', 58.933195, '9', 4, 'd', '2, 8, 15, 2', 'Metais de Transição', '126 pm', '152 pm', '-',               '1s2 2s2 2p6 3s2 3p6 4s2 3d7 ', 'hexagonal', 'sólido', '1768 K', '3200 K', '1 Pa a 1790 K', '4720 m/s a 20 °C', 420, '100 W/(m•K) ', '760,4 kJ/mol', 'Ferromagnético', '1,88', ' ' );
    Elemento[28] := TElemento. Create ( 28, 'Níquel', 'Ni', 58.6934, '10', 4, 'd', '2, 8, 17, 1', 'Metais de Transição', '124 pm', '124±4 pm', '163 pm',          '1s2 2s2 2p6 3s2 3p6 4s2 3d8 ', 'cúbico de faces centradas', 'sólido', '1728 K', '3186 K', '1 Pa a 1783 K', '4970 m/s a 20 °C', 444, '90,7536 W/(m•K) ', '737,1 kJ/mol', 'Ferromagnético', '1,91', ' ' );
    Elemento[29] := TElemento. Create ( 29, 'Cobre', 'Cu', 63.546, '11', 4, 'd', '2, 8, 18, 1', 'Metais de Transição', '128 pm', '132±4 pm', '140 pm',            '1s2 2s2 2p6 3s2 3p6 4s2 3d9 ', 'cúbico de faces centradas', 'sólido', '1357,77 K', '2835 K', '1 Pa a 1509 K', '3570 m/s a 20 °C', 385, '401 W/(m•K) ', '745,5 kJ/mol', 'Diamagnético', '1,9', ' ' );
    Elemento[30] := TElemento. Create ( 30, 'Zinco', 'Zn', 65.38, '12', 4, 'd', '2, 8, 18, 2', 'Metais de Transição', '134 pm', '122±4 pm', '139 pm',             '1s2 2s2 2p6 3s2 3p6 4s2 3d10 ', 'hexagonal', 'sólido', '692,68 K', '1180 K', '1 Pa a 610 K', '3700 m/s a 20 °C', 444, '116 W/(m•K) ', '906,4 kJ/mol', '-', '1.65', ' ' );
    Elemento[31] := TElemento. Create ( 31, 'Gálio', 'Ga', 69.723, '13', 4, 'p', '2, 8, 18, 3', 'Metais representativos', '135 pm', '122±3 pm', '187 pm',         '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p1 ', 'Ortorrômbico', 'Sólido', '302,9146 K', '2477 K', '1Pa a 1310 K', '2740 m/s a 20ºC', 0, '40,6  W/(m-K) ', '578,8 kJ/mol', '', '1,81', ' ' );
    Elemento[32] := TElemento. Create ( 32, 'Germânio', 'Ge', 72.64, '14', 4, 'p', '2, 8, 18, 4', 'Semimetal', '122 pm', '122 pm', '211 pm',                      '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p2 ', 'Cúbico de faces centradas', 'Sólido', '1211,40 K', '3106 K', '1 Pa a 1644 K', '5400 m/s a 20ºC', 320, '59,9 W/(m-K) ', '762 kJ/mol', '', '2,01', ' ' );
    Elemento[33] := TElemento. Create ( 33, 'Arsênio', 'As', 74.9216, '15', 4, 'p', '2, 8, 18, 5', 'Semimetal', '119 pm', '119±4 pm', '185 pm',                   '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p3 ', 'Romboédrico', 'Sólido', '1090 K', '887 K', '1 Pa a 553 K', '', 330, '50 W/(m-K) ', '947,0 kJ/mol', '', '2,18', ' ' );
    Elemento[34] := TElemento. Create ( 34, 'Selênio', 'Se', 78.96, '16', 4, 'p', '2, 8, 18, 6', 'Não metal', '120 pm', '120±4 pm', '190 pm',                     '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p4 ', 'Hexagonal', 'Sólido', '494 K', '958 K', '1 Pa a 500 K', '3350 m/s a 20ºC', 320, '2,04 W/(m-K) ', '941 kJ/mol', '', '2,55', ' ' );
    Elemento[35] := TElemento. Create ( 35, 'Bromo', 'Br', 79.904, '17', 4, 'p', '2, 8, 18, 7', 'Não metal', '120 pm', '120±3 pm', '185 pm',                      '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p5 ', 'Ortorrômbico', 'Líquido', '265,8 K', '332 K', '1 Pa a 185 K', '206m/s a 20ºC', 480, '0,122 W/(m-K) ', '1139,9 kJ/mol', '', '2,96', ' ' );
    Elemento[36] := TElemento. Create ( 36, 'Criptônio', 'Kr', 83.798, '18', 4, 'p', '2, 8, 18, 8', 'Gás nobre', '88 pm', '116±4 pm', '202 pm',                   '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 ', 'Cúbico de faces centradas', 'Gasoso', '115,79 K', '119,93 K', '1 Pa a 59 K', 'Gás: 220 m/s a 23ºC', 248, '0,00949 W/(m•K) ', '1350,8 kJ/mol', '', '3', ' ' );
    Elemento[37] := TElemento. Create ( 37, 'Rubídio', 'Rb', 85.4678, '1', 5, 's', '2, 8, 18, 8, 1', 'Metal Alcalino', '248 pm', '211 pm', '2,44 pm',            '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s1 ', 'Cúbica centrada no corpo', 'Sólido', '312,46 K', '961 K', '434 Pa a 1 K', '1300 m/s a 20 °C', 0, '58,2 W/(m•K) ', '403,0 kJ/mol', 'Paramagnético', '0,82', ' ' );
    Elemento[38] := TElemento. Create ( 38, 'Estrôncio', 'Sr', 87.62, '2', 5, 's', '2, 8, 18, 8, 2', 'Metal alcalinoterroso', '219 pm', '192 pm', '249 pm', '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 ', 'Cúbico de corpo centrado', 'Sólido', '1050 K', '1655 K', '1 Pa a 796 K', '', 0, '35,3 W/(m•K) ', '549,5 kJ/mol', 'Paramagnético', '0,95', ' ' );
    Elemento[39] := TElemento. Create ( 39, 'Ítrio', 'Y', 88.90585, '3', 5, 'd', '2, 8, 18, 9, 2', 'Metal de transição', '180 pm', '190±7 pm', '',               '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d1 ', 'Hexagonal', 'Sólido', '1799 K', '3609 K', '1 Pa a 1883 K', '3300 m/s a 20 °C', 300, '17,2 W/(m•K) ', '600 kJ/mol', '', '1,22', ' ' );
    Elemento[40] := TElemento. Create ( 40, 'Zircônio', 'Zr', 91.224, '4', 5, 'd', '2, 8, 18, 10, 2', 'Metal de transição', '160 pm', '175±7 pm', '',            '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d2 ', 'Hexagonal', 'Sólido', '2128 K', '4682 K', '1 Pa a 2639 K', '3800 m/s a 20 °C', 0.27, '22,7 W/(m•K) ', '640,1 kJ/mol', '', '1,33', ' ' );
    Elemento[41] := TElemento. Create ( 41, 'Nióbio', 'Nb', 92.90638, '5', 5, 'd', '2, 8, 18, 12, 1', 'Metal de transição', '146 pm', '164±6 pm', '',            '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d3 ', 'Cúbica centrada no corpo', 'Sólido', '2750 K', '5017 K', '1 Pa a 2942 K', '3480 m/s a 20 °C', 265, '53,7 W/(m•K) ', '652,1 kJ/mol', '', '1,6', ' ' );
    Elemento[42] := TElemento. Create ( 42, 'Molibdênio', 'Mo', 95.96, '6', 5, 'd', '2, 8, 18, 13, 1', 'Metal de transição', '139 pm', '154±5 pm', '',           '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d4 ', 'Cúbica centrada no corpo', 'Sólido', '2896 K', '4912 K', '1 Pa a 2742 K', '', 250, '138 W/(m•K) ', '684,3 kJ/mol', '', '2,16', ' ' );
    Elemento[43] := TElemento. Create ( 43, 'Tecnécio', 'Tc', 98, '7', 5, 'd', '2, 8, 18, 13, 2', 'Metal de transição', '136 pm', '147±7 pm', '',                '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d5 ', 'Hexagonal', 'Sólido', '2430 K', '4538 K', '1 Pa a 2727 K', '16200 m/s a 20 °C', 210, '50,6 W/(m•K) ', '702 kJ/mol', 'Paramagnético', '1,9', ' ' );
    Elemento[44] := TElemento. Create ( 44, 'Rutênio', 'Ru', 101.07, '8', 5, 'd', '2, 8, 18, 15, 1', 'Metal de transição', '134 pm', '146±7 pm', '',             '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d6 ', 'Hexagonal', 'Sólido', '2607 K', '4423 K', '1 Pa a 2588 K', '5970 m/s a 20 °C', 238, '117 W/(m•K) ', '710,2 kJ/mol', '', '2,2', ' ' );
    Elemento[45] := TElemento. Create ( 45, 'Ródio', 'Rh', 102.9055, '9', 5, 'd', '2, 8, 18, 16, 1', 'Metal de transição', '134 pm', '142±7 pm', '',             '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d7 ', 'Cúbico de faces centradas', 'Sólido', '2237 K', '3968 K', '1 Pa a 2288 K', '4700 m/s a 20 °C', 242, '150 W/(m•K) ', '719,7 kJ/mol', '', '2,28', ' ' );
    Elemento[46] := TElemento. Create ( 46, 'Paládio', 'Pd', 106.42, '10', 5, 'd', '2, 8, 18, 18', 'Metal de transição', '137 pm', '139±6 pm', '163 pm',         '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d8 ', 'Cúbico de faces centradas', 'Sólido', '1828,05 K', '3236 K', '1 Pa a 1721 K', '3070 m/s a 20 °C', 244, '71,8 W/(m•K) ', '804,4 kJ/mol', '', '2,2', ' ' );
    Elemento[47] := TElemento. Create ( 47, 'Prata', 'Ag', 107.8682, '11', 5, 'd', '2, 8, 18, 18, 1', 'Metal de transição', '144 pm', '145±5 pm', '172 pm',       '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d9 ', 'Cúbico de faces centradas', 'Sólido', '1234,93 K', '2435 K', '1 Pa a 1283 K', '2680 m/s a 20 °C', 0, '429 W/(m•K) ', '731 kJ/mol', 'Diamagnético', '1,93', ' ' );
    Elemento[48] := TElemento. Create ( 48, 'Cádmio', 'Cd', 112.411, '12', 5, 'd', '2, 8, 18, 18, 2', 'Metal de transição', '151 pm', '144±9 pm', '158 pm',       '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 ', 'Hexagonal', 'Sólido', '594,22 K', '1040 K', '1 Pa a 530 K', '2310 m/s a 20 °C', 26.02, '96,8 W/(m•K) ', '867,8 kJ/mol', '', '1,69', ' ' );
    Elemento[49] := TElemento. Create ( 49, 'Índio', 'In', 114.818, '13', 5, 'p', '2, 8, 18, 18, 3', 'Metais representativos', '167 pm', '142±5 pm', '193 pm',    '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p1 ', 'Tetragonal', 'Sólido', '429,7485 K', '2345 K', '1 Pa a 1196 K', '1215 m/s a 20 °C', 26.74, '81,6 W/(m•K) ', '558,3 kJ/mol', '', '1,78', ' ' );
    Elemento[50] := TElemento. Create ( 50, 'Estanho', 'Sn', 118.71, '14', 5, 'p', '2, 8, 18, 18, 4', 'Metais representativos', '140 pm', '139±4 pm', '217 pm',   '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p2 ', 'Tetragonal', 'Sólido', '505,08 K', '2875 K', '1 Pa a 1497 K', '2500 m/s a 20 °C', 228, '66,6 W/(m•K) ', '708,6 kJ/mol', '', '1,96', ' ' );
    Elemento[51] := TElemento. Create ( 51, 'Antimônio', 'Sb', 121.76, '15 ', 5, 'p', '2, 8, 18, 18, 5', 'Semimetal', '140 pm', '139±5 pm', '206 pm',              '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p3 ', 'Romboédrico', 'Sólido', '903,78 K', '1860 K', '1 Pa a 807 K', '', 210, '24,3 W/(m•K) ', '834 kJ/mol', '', '2,05', ' ' );
    Elemento[52] := TElemento. Create ( 52, 'Telúrio', 'Te', 127.6, '16', 5, 'p', '2, 8, 18, 18, 6', 'Semimetal', '140 pm', '138±4 pm', '206 pm',           '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p4 ', 'Hexagonal', 'Sólido', '722,66 K', '1261 K', '100 Pa a 1266 K', '', 202, '2,35 W/(m•K) ', '869,3 kJ/mol', '', '2,1', ' ' );
    Elemento[53] := TElemento. Create ( 53, 'Iodo', 'I', 126.90447, '17', 5, 'p', '2, 8, 18, 18, 7', 'Halogênios', '140 pm', '139±3 pm', '198 pm',         '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p5 ', 'Ortorrômbico', 'Sólido', '386,85 K', '457,6 K', '100 Pa a 309 K', '', 145, '8 x 10-8 S/m ', '1008,4 kJ/mol', '', '2,66', ' ' );
    Elemento[54] := TElemento. Create ( 54, 'Xenônio', 'Xe', 131.293, '18', 5, 'p', '2, 8, 18, 18, 8', 'Gás nobre', '108 pm', '130 pm', '216 pm',         '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 ', 'Cúbico de faces centradas', 'Gasoso', '161,36 K', '165,03 K', '100 Pa a 103 K', '1090 m/s a 20 °C', 158, '0,00569 W/(m•K) ', '1170,4 kJ/mol', '', '2,6', ' ' );
    Elemento[55] := TElemento. Create ( 55, 'Césio', 'Cs', 132.9054519, '1', 6, 's', '2, 8, 18, 18, 8, 1', 'Metal Alcalino', '298 pm', '225 pm', '',             '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s1 ', 'Cúbica centrada no corpo', 'Sólido', '301,6 K', '944 K', '1 Pa a 418 K', '', 0, '35,9 W/(m•K) ', '375,7 kJ/mol', 'Paramagnético', '0,79', ' ' );
    Elemento[56] := TElemento. Create ( 56, 'Bário', 'Ba', 137.327, '2', 6, 's','2, 8, 18, 18, 8, 2','Metal Alcalinoterroso','222 pm','215±11 pm','268 pm', '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 ', 'Cúbica centrada no corpo', 'Sólido', '1000 K', '2170 K', '100 Pa a 1185 K', '1620 m/s a 20 °C', 0, '18,4 W/(m•K) ', '502,9 kJ/mol', 'Paramagnético', '0,89', ' ' );
    Elemento[57] := TElemento. Create ( 57, 'Lantânio', 'La', 138.90547, '-', 6, 'f', '2, 8, 18, 18, 9, 2', 'Lantanídios', '195 pm', '169 pm', '',                '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f1 ', 'Hexagonal', 'Sólido', '1191 K', '3737 K', '100 Pa a 2458 K', '2475 m/s a 20 °C', 0, '13,5 W/(m•K) ', '538,1 kJ/mol', '', '1,1', ' ' );
    Elemento[58] := TElemento. Create ( 58, 'Cério', 'Ce', 140.116, '-', 6, 'f', '2, 8, 18, 19, 9, 2', 'Lantanídios', '185 pm', '', '',                           '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f2 ', 'Cúbico de faces centradas', 'Sólido', '1071 K', '3699 K', '100 Pa a 2442 K', '2100 m/s a 20 °C', 0, '11,4 W/(m•K) ', '534,4 kJ/mol', '', '1,12', ' ' );
    Elemento[59] := TElemento. Create ( 59, 'Praseodímio', 'Pr', 140.93765, '-', 6, 'f', '2, 8, 18, 21, 8, 2', 'Lantanídios', '185 pm', '165 pm', '',             '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f3 ', 'Hexagonal', 'Sólido', '1204 K', '3793 K', '100 Pa a 2227 K', '2280 m/s a 20 °C', 0, '12,5 W/(m•K) ', '527 kJ/mol', '', '1,13', ' ' );
    Elemento[60] := TElemento. Create ( 60, 'Neodímio', 'Nd', 144.242, '-', 6, 'f', '2, 8, 18, 22, 8, 2', 'Lantanídios', '185 pm', '', '',                        '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f4 ', 'Hexagonal', 'sólido', '1294 K', '3347', '100 Pa a 1998 K', '2330 m/s a 20 °C', 190, '16,5 W/(m°C) ', '533,1 kJ/mol', 'diamagnético', '1,14', ' ' );
    Elemento[61] := TElemento. Create ( 61, 'Promécio', 'Pm', 144.9127, '-', 2, 's', '2,8,18,23,8,2', 'Lantanídeos', '!', '1,63 A', '!',                   '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f5 ', 'Hexagonal', 'Sólido', '!', '!', '120 Pa a 1450 K', '2340 m/s a 20 °C', 1975, '1,6 E6/ohms/m ', '5,55', 'Paramagnético', '1,13', ' ' );
    Elemento[62] := TElemento. Create ( 62, 'Samário', 'Sm', 150.36, '-', 2, 's', '2,8,18,24,8,2', 'Lantanídeos', '1,81 A', '1,62 A', '!',                 '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f6 ', 'Trigonal', 'Sólido', '1072', '1900', '1 Pa a 1001 K', '2400 m/s a 20 °C', 986, '2 E6/ohms/m ', '5,63', 'Diamagnético', '1,17', ' ' );
    Elemento[63] := TElemento. Create ( 63, 'Európio', 'Eu', 151.964, '-', 2, 's', '2,8,18,25,8,2', 'Lantanídeos', '1,99 A', '1,85 A', '!',               '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f7 ', 'Cúbica de Corpo Centrado', 'Sólido', '822', '1597', '1 Pa a 863 K', '1000 m/s a 20 °C', 1345, '1,1 E6/ohms/m ', '5,67', 'Diamagnético', '1,2', ' ' );
    Elemento[64] := TElemento. Create ( 64, 'Gadolínio', 'Gd', 157.25, '-', 2, 's', '2,8,18,25,9,2', 'Lantanídeos', '1,8 A', '1,61 A', '!',                  '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f8 ', 'Hexagonal Compactada', 'Sólido', '1311', '3233', '10 Pa a 1979 K', '1300 m/s a 20 °C', 1670, '1,1 E6/ohms/m ', '6,15', 'Paramagnético', '1,2', ' ' );
    Elemento[65] := TElemento. Create ( 65, 'Térbio', 'Tb', 158.92535, '-', 2, 's', '2,8,18,27,8,2', 'Lantanídeos', '1,8 A', '1,59 A', '!',                  '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f9 ', 'Hexagonal Compactada', 'Sólido', '1360', '3041', '10 Pa a 1979 K', '2629 m/s a 20°C', 1815, '0,8 E6/ohms/m ', '5,86', 'Paramagnético', '1,2', ' ' );
    Elemento[66] := TElemento. Create ( 66, 'Disprósio', 'Dy', 162.5, '-', 2, 's', '2,8,18,28,8,2', 'Lantanídeos', '1,8 A', '1,59 A', '!',                 '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f10 ', 'Hexagonal Compactada', 'Sólido', '1412', '2562', '10 Pa a 1523 K', '2710 m/s a 20°C', 170, '0,9 E6/ohms/m ', '5,93', 'Paramagnético', '1,22', ' ' );
    Elemento[67] := TElemento. Create ( 67, 'Hólmio', 'Ho', 164.93032, '-', 2, 's', '2,8,18,29,8,2', 'Lantanídeos', '1,79 A', '1,58 A', '!',                '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f11 ', 'Hexagonal Compactada', 'Sólido', '1470', '2720', '10 Pa a 1584 K', '2710 m/s a 20°C', 160, '1,1 E6/ohms/m ', '6,02', 'Paramagnético', '1,23', ' ' );
    Elemento[68] := TElemento. Create ( 68, 'Érbio', 'Er', 167.259, '-', 2, 's', '2,8,18,30,8,2', 'Lantanídeos', '1,78 A', '1,57 A', '!',                    '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f12 ', 'Hexagonal Compactada', 'Sólido', '1522', '2510', '1 Pa a 1504 K', '2310 m/s a 20°C', 170, '1,1 E6/ohms/m ', '6,101', 'Paramagnético', '1,24', ' ' );
    Elemento[69] := TElemento. Create ( 69, 'Túlio', 'Tm', 168.93421, '-', 2, 's', '2,8,18,31,8,2', 'Lantanídeos', '1,77 A', '1,56 A', '!',                 '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f13 ', 'Hexagonal Compactada', 'Sólido', '1545', '1727', '10 Pa a 1235 K', '2239 m/s a 20°C', 160, '1,2 E6/ohms/m ', '6,184', 'Diamagnético', '1,25', ' ' );
    Elemento[70] := TElemento. Create ( 70, 'Itérbio', 'Yb', 173.04, '-', 2, 's', '2,8,18,32,8,2', 'Lantanídeos', '1,94 A', '1,74 A', '!',                 '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 ', 'Cúbica de Corpo Centrado', 'Sólido', '824', '1466', '1 Pa a 736 K', '1590 m/s a 20 °C', 150, '1,3 E6/ohms/m ', '6,254', 'Paramagnético', '1,1', ' ' );
    Elemento[71] := TElemento. Create ( 71, 'Lutécio', 'Lu', 174.967, '3', 2, 's', '2,8,18,32,9,2', 'Lantanídeos', '1,75 A', '1,56 A', '!',               '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d1 ', 'Hexagonal Compactada', 'Sólido', '1656', '3315', '100 Pa a 2346 K', '2259 m/s a 20°C', 150, '3,7 E6/ohms/m ', '5,43', 'Paramagnético', '1,27', ' ' );
    Elemento[72] := TElemento. Create ( 72, 'Háfnio', 'Hf', 178.49, '4', 2, 's', '2,8,18,32,10,2', 'Metais de Transição', '1,67 A', '1,44 A', '!',          '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d2 ', 'Hexagonal Compactada', 'Sólido', '2150', '5400', '100 Pa a 3277 K', '3010 m/s a 20°C', 140, '1,5 E6/ohms/m ', '6,65', 'Diamagnético', '1,3', ' ' );
    Elemento[73] := TElemento. Create ( 73, 'Tantálio', 'Ta', 180.94788, '5', 2, 's', '2,8,18,32,11,2', 'Metais de Transição', '1,49 A', '1,34 A', '!',       '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d3 ', 'Cúbica de Corpo Centrado', 'Sólido', '2996', '5425+-100', '0,776 Pa a 3269 K', '3400 m/s a 20°C', 150, '3,6 E6/ohms/m ', '7,89', 'Paramagnético', '1,5', ' ' );
    Elemento[74] := TElemento. Create ( 74, 'Tungstênio', 'W', 183.84, '6', 2, 's', '2,8,18,32,12,2', 'Metais de Transição', '1,41 A', '1,30 A', '!',        '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d4 ', 'Cúbica de Corpo Centrado', 'Sólido', '3410+-20', '5660', '4,27 Pa a 3269 K', '5174 m/s a 20°C', 140, '8,1 E6/ohms/m ', '7,98', 'Paramagnético', '2,36', ' ' );
    Elemento[75] := TElemento. Create ( 75, 'Rênio', 'Ra', 186.207, '7', 2, 's', '2,8,18,32,13,2', 'Metais de Transição', '1,37 A', '1,28 A', '!',          '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d5 ', 'Hexagonal Compactada', 'Sólido', '3180', '5627', '10 Pa a 3614 K', '4700 m/s a 20°C', 137, '18,2 E6/ohms/m ', '7,88', 'Paramagnético', '1,9', ' ' );
    Elemento[76] := TElemento. Create ( 76, 'Ósmio', 'Os', 190.23, '8', 2, 's', '2,8,18,32,14,2', 'Metais de Transição', '1,35 A', '1,26 A', '!',          '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d6 ', 'Hexagonal Compactada', 'Sólido', '3045', '5027', '10 Pa a 3423 K', '4940 m/s a 20°C', 130, '5,8 E6/ohms/m ', '8,7', 'Paramagnético', '2,2', ' ' );
    Elemento[77] := TElemento. Create ( 77, 'Irídio', 'Ir', 192.217, '9', 2, 's', '2,8,18,32,15,2', 'Metais de Transição', '1,35 A', '1,27 A', '!',        '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d7 ', 'Cúbica de Face Centrado', 'Sólido', '2410', '4527+-100', '10 Pa a 2957 K', '4825 m/s a 20°C', 130, '12,3 E6/ohms/m ', '9,1', 'Paramagnético', '2,2', ' ' );
    Elemento[78] := TElemento. Create ( 78, 'Platina', 'Pt', 195.084, '10', 2, 's', '2,8,18,32,17,1', 'Outros Metais', '1,36 A', '1,3 A', '!',             '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d8 ', 'Cúbica de Face Centrado', 'Sólido', '1772', '3827', '100 Pa a 2815 K', '2680 m/s a 20°C', 130, '21,3 E6/ohms/m ', '9', 'Paramagnético', '2,28', ' ' );
    Elemento[79] := TElemento. Create ( 79, 'Ouro', 'Au', 196.966569, '11', 2, 's', '2,8,18,32,18,1', 'Outros Metais', '1,39 A', '1,34 A', '166 pm',          '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d9 ', 'Cúbica de Face Centrado', 'Sólido', '1064,43', '2807', '0,000237 Pa a 1337 K', '1740 m/s a 20°C', 128, '9,4 E6/ohms/m ', '9,225', 'Diamagnético', '2,54', ' ' );
    Elemento[80] := TElemento. Create ( 80, 'Mercúrio', 'Hg', 200.59, '12', 2, 's', '2,8,18,32,18,2', 'Outros Metais', '1,46 A', '1,49 A', '155 pm',          '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 ', 'Romboédrica', 'Liquido', '-38,87', '356,58', '10 Pa a 350 K', '1407 m/s a 20°C', 140, '48,8 E6/ohms/m ', '10,437', 'Diamagnético', '2', ' ' );
    Elemento[81] := TElemento. Create ( 81, 'Tálio', 'Ti', 204.3833, '13', 2, 's', '2,8,18,32,18,3', 'Outros Metais', '1,6 A', '1,48 A', '196 pm',          '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p1 ', 'Hexagonal', 'Sólido', '303,5', '1457+-10', '100 Pa a 1097 K', '818 m/s a 20°C', 129, '1 E6/ohms/m ', '6,108', 'Diamagnético', '2,04', ' ' );
    Elemento[82] := TElemento. Create ( 82, 'Chumbo', 'Pb', 207.2, '14', 2, 's', '2,8,18,32,18,4', 'Outros Metais', '1,71 A', '1,47 A', '202 pm',            '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p2 ', 'Cúbica de Face Centrado', 'Sólido', '327,5', '1740', '4,21x10(a menos 7)Pa a 1097', '1260 m/s a 20°C', 129, '5,6 E6/ohms/m ', '7,416', 'Diamagnético', '2,33', ' ' );
    Elemento[83] := TElemento. Create ( 83, 'Bismuto', 'Bi', 208.9804, '15', 2, 's', '2,8,18,32,18,5', 'Outros Metais', '1,75 A', '1,46 A', '207 pm',         '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p3 ', 'Monocíclica', 'Sólido', '271,3', '1560+-5', '1 Pa a 941 K', '1790 m/s a 20°C', 122, '4,8 E6/ohms/m ', '7,289', '!', '2,02', ' ' );
    Elemento[84] := TElemento. Create ( 84, 'Polônio', 'Po', 208.9824, '16', 2, 's', '2,8,18,32,18,6', 'Outros Metais', '1,7 A', '1,46 A', '!',              '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p4 ', 'Cúbica', 'Sólido', '254', '962', '10 Pa a 1003 K', 's.d m/s a 20°C', 0, '0,9 E6/ohms/m ', '8,42', 'Não Magnético', '2', ' ' );
    Elemento[85] := TElemento. Create ( 85, 'Astato', 'At', 208.9871, '17', 2, 's', '2,8,18,32,18,7', 'Metais Halogênios', '1,67 A', '1,45 A', '!',         '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p5 ', '!', 'Sólido', '302', '337', '10 Pa a 392 K', 's.d m/s a 20°C', 0, '0,7 E6/ohms/m ', '!', 's.d', '2,2', ' ' );
    Elemento[86] := TElemento. Create ( 86, 'Radônio', 'Rn', 206.0176, '18', 2, 's', '2,8,18,32,18,8', 'Gases Nobres', '1,45 A', '!', '220 pm',            '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 ', '!', 'Gasoso', '-71', '-61,8', '1 Pa a 110 K', 's.d m/s a 20°C', 0, '! ', '10,748', 's.d', '!', ' ' );
    Elemento[87] := TElemento. Create ( 87, 'Frâncio', 'Fr', 223.0197, '1', 2, 's', '2,8,18,32,18,8,1', 'Metais Alcalinos', '1,34 A', '!', '348 pm',          '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s1 ', '!', 'Sólido', '27', '677', '1 Pa a 404 K', 's.d m/s a 20°C', 0, '! ', '0', 'Paramagnético', '0,7', ' ' );
    Elemento[88] := TElemento. Create ( 88, 'Rádio', 'Ra', 226.0254, '2', 2, 's', '2,8,18,32,18,8,2', 'Metais Alcalinos - Terrosos', '2,7 A', '!', '283 pm', '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 ', 'Cúbica de Corpo Centrado', 'Sólido', '700', '1737', '1 Pa a 819 K', 's.d m/s a 20°C', 0, '! ', '5,279', 'Paramagnético', '0,9', ' ' );
    Elemento[89] := TElemento. Create ( 89, 'Actínio', 'Ac', 227.0278, '-', 2, 's', '2,8,18,32,18,9,2', 'Actinídeos', '2,33 A', '!', '!',                    '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f1 ', 'Cúbica de Face Centrado', 'Sólido', '1050', '3200+-300', '!', '!', 0, '1 E6/ohms/m ', '5,17', '!', '1,1', ' ', 'Graphics/Properties/Pictures/89' );
    Elemento[90] := TElemento. Create ( 90, 'Tório', 'Th', 232.03806, '-', 2, 's', '2,8,18,32,18,10,2', 'Actinídeos', '1,88 A', '1,65 A', '!',                '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f2 ', 'Cúbica de Face Centrado', 'Sólido', '1750', '4790', '1 Pa a 2633 K', '2490 m/s a 20°C', 120, '54 E6/ohms/m ', '!', '!', '1,3', ' ' );
    Elemento[91] := TElemento. Create ( 91, 'Protactínio', 'Pa', 231.03588, '-', 7, 'f', '2, 8, 18, 32, 20, 9, 2', 'Actinídeo', '163 pm', '200 pm', '-',        '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f3 ', 'tetragonal', 'sólido', '1841K', '4300K', '481kJ/mol', '-', 120, '47W(m-k) ', '568kJ/mol', '-', '1,5', ' ' );
    Elemento[92] := TElemento. Create ( 92, 'Urânio', 'U', 238.02891, '-', 7, 'f', '2,8,18,32,21,9,2', 'Actinídeo', '-', '175 pm', '186 pm',                     '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f4 ', 'ortorrômbico', 'sólido', '1405,3K', '4404K', '-', '3155m/s a 20ºC', 300, '27,5W/(m-k) ', '-', 'Paramagnético', '1,38', ' ' );
    Elemento[93] := TElemento. Create ( 93, 'Netúnio', 'Np', 237, '-', 7, 'f', '2,8,18,32,22,9,2', 'Actinídeo', '155 pm', '190+/-1 pm', '-',                    '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f5 ', 'ortorrómbica, tetragonal e cúbica', 'sólido', '910K', '4273K', '1 Pa a 2194K', '-', 0, '6,3W/(m-k) ', '604,5Kj/mol', 'Paramagnético', '1,36', ' ', 'Graphics/Properties/Pictures/93' );
    Elemento[94] := TElemento. Create ( 94, 'Plutônio', 'Pu', 244, '-', 7, 'f', '2,8,18,32,24,8,2', 'Actinídeo', '159 pm', '187+/-1pm', '-',                    '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f6 ', 'monoclínico', 'sólido', '912,5k', '3505k', '1Pa a 1756k', '2260m/s a 20ºc', 0, '6,74W(m-k) ', '584,7Kj/mol', 'Paramagnético', '1,28', ' ' );
    Elemento[95] := TElemento. Create ( 95, 'Amerício', 'Am', 243, '-', 7, 'f', '2,8,18,32,25,8,2', 'Actinídeo', '-', '-', '-',                                 '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f7 ', 'monoclínico', 'sólido', '1176c', '2607c', '-', '-', 0, '10W(m-k) ', '-', '-', '1,3', ' ' );
    Elemento[96] := TElemento. Create ( 96, 'Cúrio', 'Cm', 247, '-', 7, 'f', '2,8,18,32,25,9,2', 'Actinídeo', '-', '-', '-',                                    '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f8 ', 'hexagonal compacta', 'sólido', '1618k', '3383k', '-', '-', 0, '- ', '581Kj/mol', '-', '1,3', ' ' );
    Elemento[97] := TElemento. Create ( 97, 'Barquélio', 'Bk', 247, '-', 7, 'f', '2,8,18,32,27,8,2', 'Actinídeo', '-', '-', '-',                                '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f9 ', '-', 'sólido', '1323k', '-', '-', '-', 0, '- ', '601kJmol', '-', '1,3', ' ' );
    Elemento[98] := TElemento. Create ( 98, 'Califórnio', 'Cf', 251, '-', 7, 'f', '2,8,18,32,28,8,2', 'Actinídeo', '169 pm', '-', '-',                          '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f10 ', '-', 'sólido', '1173k', '1743k', '-', '-', 0, '- ', '608kjmol', '-', '-', ' ' );
    Elemento[99] := TElemento. Create ( 99, 'Einstênio', 'Es', 252, '-', 7, 'f', '2,8,18,32,29,8,2', 'Actinídeo', '-', '-', '-',                                '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f11 ', '-', 'sólido', '860c', '-', '-', '-', 0, '10W(m-k) ', '619kjmol', '-', '1,3', ' ' );
    Elemento[100] := TElemento. Create ( 100, 'Férmio', 'Fm', 257, '-', 7, 'f', '2,8,18,32,30,8,2', 'Actinídeo', '-', '-', '-',                                 '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f12 ', '-', 'sólido', '1800k', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[101] := TElemento. Create ( 101, 'Mendelévio', 'Md', 258, '-', 7, 'f', '2,8,18,32,31,8,2', 'Actinídeo', '-', '-', '-',                             '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f13 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[102] := TElemento. Create ( 102, 'Nobélio', 'No', 259, '-', 7, 'f', '2,8,18,32,32,8,2', 'Actinídeo', '-', '-', '-',                                '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[103] := TElemento. Create ( 103, 'Laurêncio', 'Lr', 262, '3', 7, 'f', '2,8,18,32,32,8,3', 'Actinídeo', '-', '-', '-',                              '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d1 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[104] := TElemento. Create ( 104, 'Rutherfórdio', 'Rf', 267, '4', 7, 'd', '2,8,18,32,32,10,2', 'Metal em Transição', '-', '-', '-',                   '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d2 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[105] := TElemento. Create ( 105, 'Dúbnio', 'Db', 268, '5', 7, 'd', '2,8,18,32,32,11,2', 'Metal em Transição', '-', '-', '-',                         '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d3 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[106] := TElemento. Create ( 106, 'Seabórgio', 'Sg', 271, '6', 7, 'd', '2,8,18,32,32,12,2', 'Metal em Transição', '-', '-', '-',                      '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d4 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[107] := TElemento. Create ( 107, 'Bóhrio', 'Bh', 272, '7', 7, 'd', '2,8,18,32,32,13,2', 'Metal em Transição', '-', '-', '-',                         '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d5 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[108] := TElemento. Create ( 108, 'Hássio', 'Hs', 270, '8', 7, 'd', '2,8,18,32,32,14,2', 'Metal em Transição', '-', '-', '-',                         '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d6 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[109] := TElemento. Create ( 109, 'Meitnério', 'Mt', 276, '9', 7, 'd', '2,8,18,32,32,15,2', 'Metal em Transição', '-', '-', '-',                      '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d7 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[110] := TElemento. Create ( 110, 'Darmstádio', 'Ds', 281, '10', 7, 'd', '2,8,18,32,32,17,1', 'Metal em Transição', '-', '-', '-',                    '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d8 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[111] := TElemento. Create ( 111, 'Roentgênio', 'Rg', 280, '11', 7, 'd', '2,8,18,32,32,18,1', 'Metal em Transição', '-', '-', '-',                    '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d9 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[112] := TElemento. Create ( 112, 'Ununbium', 'Uub', 285, '12', 7, 'd', '2,8,18,32,32,18,2', 'Metal em Transição', '-', '-', '-',                     '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d10 ', '-', 'liquido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[113] := TElemento. Create ( 113, 'Ununtrio', 'Uut', 284, '13', 7, 'p', '2,8,18,32,32,18,3', 'Metal Representativo', '-', '-', '-',                   '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d10 7p1 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[114] := TElemento. Create ( 114, 'Ununquádio', 'Uuq', 289, '14', 7, 'p', '2,8,18,32,32,18,4', 'Metal Representativo', '-', '-', '-',                 '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d10 7p2 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[115] := TElemento. Create ( 115, 'Ununpentio', 'Uup', 288, '15', 7, 'p', '2,8,18,32,32,18,5', 'Metal Representativo', '-', '-', '-',                 '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d10 7p3 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[116] := TElemento. Create ( 116, 'Ununhéxio', 'Uuh', 293, '16', 7, 'p', '2,8,18,32,32,18,6', 'Metal Representativo', '-', '-', '-',                  '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d10 7p4 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[117] := TElemento. Create ( 117, 'Ununséptio', 'Uus', 294, '17', 7, 'p', '2, 8, 18, 32, 32, 18, 7', 'Halogênio', '-', '-', '-',                      '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d10 7p5 ', '-', 'sólido', '-', '-', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    Elemento[118] := TElemento. Create ( 118, 'Ununóctio', 'Uuo', 294, '18', 7, 'd', '2, 8, 18, 32, 32, 18, 8', 'Gases Nobres', '152 pm', '230 pm', '-',          '1s2 2s2 2p6 3s2 3p6 4s2 3d10 4p6 5s2 4d10 5p6 6s2 4f14 5d10 6p6 7s2 5f14 6d10 7p6 ', '-', 'gasoso', '-', '3550+/-30k', '-', '-', 0, '- ', '-', '-', '-', ' ' );
    { Put end }

  end;

// ------------------------
// JB_Crypt
// Autor: Lucas Gaspar
// ------------------------

function Crypt( Word : String ) : String;

// String já criptografada
var Crypted : String;
// Chave anterior
var Key_Before : Byte;
// Chave nova
var Key_After : Byte;
// Índices
var I, J : Byte;

begin

  // Define o tamanho do texto a ser criptografado
  SetLength( Crypted, Length( Word ) * Length( Word ) );
  // Define a chave temporária
  Key_Before := Ord( Word[1] );

  // Se a chave temporária não for divisível por 2
  if not ( Key_Before mod 2 = 0 ) then
    // Faça-a divisível
    Key_Before := Key_Before - 1;

  // Divide a chave por 2.
  Key_After := Key_Before div 2;

  // Para todos os caracteres
  for I := 0 to Length( Word ) - 1 do
    // Para todos os caracteres
    for J := 1 to Length( Word ) do
      // Se o caracter criptografado não exceder o número de caracteres ASC II
      if ( Ord ( Word[I] ) + Key_After ) < ( 126 - Length( Word ) ) then
        // Criptografa
        Crypted[J * Length(Word) - I] := Chr( Key_After + Ord ( Word[I] ) + J )
      // Se o caracter criptografado exceder o número de caracteres ASC II
      else
        // Criptografa
        Crypted[J * Length(Word) - I] := Chr( Abs( Ord( Word[I] ) - Key_After + J ) );

  // Retorna a nova string
  Result := Crypted;

end;
end.
