unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, pngimage, ExtCtrls, ComCtrls;

type
  TInstall5 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    atalho: TCheckBox;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Install5: TInstall5;

implementation

uses Unit1, Unit2, Unit3, Unit4,ShellAPI, ShlObj, ActiveX, ComObj, Registry;

Procedure CriarAtalho(ANomeArquivo, AParametros, ADiretorioInicial,
  ANomedoAtalho, APastaDoAtalho: string);
var
  MeuObjeto: IUnknown;
  MeuSLink: IShellLink;
  MeuPFile: IPersistFile;
  Diretorio: string;
  wNomeArquivo: WideString;
  MeuRegistro: TRegIniFile;
begin
  //Cria e instancia os objetos usados para criar o atalho
  MeuObjeto := CreateComObject(CLSID_ShellLink);
  MeuSLink := MeuObjeto as IShellLink;
  MeuPFile := MeuObjeto as IPersistFile;
  with MeuSLink do
  begin
    SetArguments(PChar(AParametros));
    SetPath(PChar(ANomeArquivo));
     SetWorkingDirectory(PChar(ADiretorioInicial));
  end;
  //Pega endereço da pasta Desktop do Windows
  MeuRegistro :=
    TRegIniFile.Create('Software\MicroSoft\Windows\CurrentVersion\Explorer');
  Diretorio := MeuRegistro.ReadString('Shell Folders', 'Desktop', '');
  wNomeArquivo := Diretorio + '\' + ANomedoAtalho + '.lnk';
  //Cria de fato o atalho na tela
  MeuPFile.Save(PWChar(wNomeArquivo), False);
  MeuRegistro.Free;
end;

{$R *.dfm}

procedure TInstall5.SpeedButton1Click(Sender: TObject);
begin
if atalho.Checked= true then
begin
criaratalho('L:\ChemQuark 0.14.3\ChemQuark\Bin\ChemQuark.exe','L:\ChemQuark 0.14.3\ChemQuark\Bin\ChemQuark.exe','L:\instalador\Project1.exe','ChemQuark','L:\ChemQuark 0.14.3\ChemQuark\Bin\ChemQuark.exe');
install1.Close;
install2.Close;
install3.Close;
install4.Close;
install5.Close;
end;
if atalho.Checked=false then
begin
install1.Close;
install2.Close;
install3.Close;
install4.Close;
install5.Close;
end;
end;

end.
