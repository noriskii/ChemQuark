unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, pngimage, ExtCtrls, ComCtrls;

type
  TInstall4 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Timer1: TTimer;
    Timer2: TTimer;
    Label1: TLabel;
    Timer3: TTimer;
    Timer4: TTimer;
    ProgressBar1: TProgressBar;
    TrackBar1: TTrackBar;
    process: TLabel;
    Timer5: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer5Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Install4: TInstall4;

implementation

uses Unit1, Unit2, Unit3, Unit5, ShellAPI;

function moveCopiaDiretorios(pOperacao: Integer; pOrigem, pDestino: string):Boolean;
var
recOperacao : TShFileOpStruct;
begin
Result := False;
if(pOrigem<>'')and(pDestino<>'')and(DirectoryExists(pOrigem))then
begin
pOrigem := pOrigem+#0;
pDestino := pDestino+#0;
FillChar(recOperacao, Sizeof(TShFileOpStruct), 0);

recOperacao.Wnd := Application.Handle;
recOperacao.wFunc := pOperacao;
recOperacao.pFrom := PChar(pOrigem);
recOperacao.pTo := PChar(pDestino);
recOperacao.fFlags := FOF_ALLOWUNDO or FOF_SIMPLEPROGRESS or FOF_NOCONFIRMATION;

result:= ShFileOperation(recOperacao)=0;
end;
end;

{$R *.dfm}

procedure TInstall4.FormShow(Sender: TObject);
begin
timer5.Enabled:=true;
end;

procedure TInstall4.SpeedButton1Click(Sender: TObject);
begin
Install4.Hide;
Install5.Show;
end;

procedure TInstall4.SpeedButton3Click(Sender: TObject);
begin
if Messagebox(0,'Deseja realmente cancelar o processo de instalação?','Cancelar Instalação', +mb_yesno +mb_defbutton2) = 6 then
install1.Close;
install2.Close;
install3.Close;
install4.Close;
install5.Close;
end;

procedure TInstall4.Timer1Timer(Sender: TObject);
begin
label1.Width:=235;
label1.Height:=18;
label1.Caption:='Instalando o ChemQuark';
timer2.Enabled:=true;
timer1.enabled:=false;
end;

procedure TInstall4.Timer2Timer(Sender: TObject);
begin
label1.Width:=235;
label1.Height:=18;
label1.Caption:='Instalando o ChemQuark.';
timer3.Enabled:=true;
timer2.Enabled:=false;
end;

procedure TInstall4.Timer3Timer(Sender: TObject);
begin
label1.Width:=235;
label1.Height:=18;
label1.Caption:='Instalando o ChemQuark..';
timer4.Enabled:=true;
timer3.Enabled:=false;

end;

procedure TInstall4.Timer4Timer(Sender: TObject);
begin
label1.Width:=235;
label1.Height:=18;
label1.Caption:='Instalando o ChemQuark...';
timer4.Enabled:=false;
timer1.Enabled:=true;
end;

procedure TInstall4.Timer5Timer(Sender: TObject);
begin
//Caso precise, crie + e mude as pastas origem, no caso '\instala-a-dor\...'
process.Caption:='Instalando a Fonte';
movecopiadiretorios($0002,'L:\ChemQuark 0.14.3\ChemQuark\Font','C:\ATHOS\ChemQuark');
trackbar1.Position:=6;
process.Caption:='Instalando Graficos';
movecopiadiretorios($0002,'L:\ChemQuark 0.14.3\ChemQuark\Graphics','C:\ATHOS\ChemQuark');
trackbar1.Position:=19;
process.Caption:='Instalando Manuais';
movecopiadiretorios($0002,'L:\ChemQuark 0.14.3\ChemQuark\ManuaisTexto','C:\ATHOS\ChemQuark');
trackbar1.Position:=27;
process.Caption:='Instalando Dados De Saida';
movecopiadiretorios($0002,'L:\ChemQuark 0.14.3\ChemQuark\Output','C:\ATHOS\ChemQuark');
trackbar1.Position:=34;
process.Caption:='Instalando Saves';
movecopiadiretorios($0002,'L:\ChemQuark 0.14.3\ChemQuark\Saves','C:\ATHOS\ChemQuark');
trackbar1.Position:=48;
process.Caption:='Instalando Sons';
movecopiadiretorios($0002,'L:\ChemQuark 0.14.3\ChemQuark\Sound','C:\ATHOS\ChemQuark');
trackbar1.Position:=59;
process.Caption:='Instalando Códigos';
movecopiadiretorios($0002,'L:\ChemQuark 0.14.3\ChemQuark\Src','C:\ATHOS\ChemQuark');
trackbar1.Position:=71;
process.Caption:='Instalando Videos';
movecopiadiretorios($0002,'L:\ChemQuark 0.14.3\ChemQuark\Videos','C:\ATHOS\ChemQuark');
trackbar1.Position:=83;
process.Caption:='Criando Executavel';
movecopiadiretorios($0002,'L:\ChemQuark 0.14.3\ChemQuark\Bin','C:\ATHOS\ChemQuark');
trackbar1.Position:=100;
timer5.Enabled:=false;
end;

procedure TInstall4.TrackBar1Change(Sender: TObject);
begin
progressbar1.position:=trackbar1.Position;
if progressbar1.Position = 100 then
begin
speedbutton3.Visible:=false;
process.Caption:='Instalação Terminada';
speedbutton1.flat:=true;
speedbutton1.Enabled:=true;
speedbutton1.Caption:='';
end;
end;

end.
