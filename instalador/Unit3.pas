unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, pngimage, ExtCtrls, ComCtrls;

type
  TInstall3 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    prox: TSpeedButton;
    ant: TSpeedButton;
    cancel: TSpeedButton;
    editescolha1: TRichEdit;
    FileSaveDialog1: TFileSaveDialog;
    SpeedButton1: TSpeedButton;
    procedure antClick(Sender: TObject);
    procedure proxClick(Sender: TObject);
    procedure cancelClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Install3: TInstall3;

implementation

uses Unit2, Unit1, Unit4, Unit5,ShellAPI;

{$R *.dfm}

procedure TInstall3.antClick(Sender: TObject);

begin
Install3.hide;
Install2.show;
end;

procedure TInstall3.cancelClick(Sender: TObject);
begin
if Messagebox(0,'Deseja realmente cancelar a instalação?','Cancelar Instalação', +mb_yesno +mb_defbutton2) = 6 then
install1.Close;
install2.Close;
install3.Close;
install4.Close;
install5.Close;
end;

procedure TInstall3.proxClick(Sender: TObject);
var destino : String;
  begin
deletefile(filesavedialog1.FileName);
Install3.Hide;
    destino:=editescolha1.Text;
if not DirectoryExists(destino) then
begin
  ForceDirectories(destino+'\'+'ChemQuark');
end;
Install4.show;
end;

procedure TInstall3.SpeedButton1Click(Sender: TObject);
begin
if fileSavedialog1.Execute then
  begin
    editescolha1.Lines.Add(fileSavedialog1.FileName);
      editescolha1.text:=filesavedialog1.FileName;
  end;
end;

procedure TInstall3.FormCreate(Sender: TObject);
begin
   editescolha1.text:=filesavedialog1.defaultfolder;
end;
procedure TInstall3.FormKeyPress(Sender: TObject; var Key: Char);

begin
//verifica se a tecla pressionada é a tecla ENTER
If (key = #13) and (prox.Enabled = true) then
Begin
prox.Click;
end;

end;

end.

