unit Insert_Substance;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, Vcl.Imaging.jpeg;

type
  TInsertSubstancia = class(TForm)
    BackGround: TImage;
    Gravar: TImage;
    Substancia: TEdit;
    Nome: TEdit;
    Image1: TImage;
    procedure OnMouseLeave(Sender: TObject);
    procedure SetPicture( Index : Byte );
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GravarClick(Sender: TObject);
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure OnClose(Sender: TObject; var Action: TCloseAction);
    procedure OnCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InsertSubstancia: TInsertSubstancia;

implementation

uses DB_Integrator, Sound, Insert_Solubilidade;

{$R *.dfm}

procedure TInsertSubstancia.SetPicture(Index: Byte);
begin
  With Gravar.Picture Do
    LoadFromFile('Graphics/InsertSubstance/Botão_' + IntToStr(Index) + '.png');
end;

procedure TInsertSubstancia.GravarClick(Sender: TObject);
var I : Integer;
begin
    if ( SpaceDelete(Substancia.Text) = '' ) Or
       ( SpaceDelete(Nome.Text) = '' ) then
    begin
      Application.MessageBox('Preencha todos os campos',
                             'Inserção', MB_ICONWARNING  );
      Exit();
    end;

    I := 0;
    DataModule1.ADOQuery1.First();
    while not DataModule1.ADOQuery1.Eof do
    begin
      if SpaceDelete(Substancia.Text) = SpaceDelete(
                                        DataModule1.ADOQuery1.FieldByName(
                                                   'Substancia').AsString) then
      begin
        Application.MessageBox('Substância já cadastrada',
                               'Inserção', MB_ICONWARNING  );
        Exit()
      end;
      I := I + 1;
      DataModule1.ADOQuery1.Next();
    end;


    DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
    // Cria parâmetros para inserção
    DB_Integrator.DataModule1.ADOQuery1.SQL.Add('INSERT INTO Solubilidade' +
    ' (Substancia, Nome) VALUES (:A, :B);');

    // Insere os campos de massas molares
    DataModule1.ADOQuery1.Parameters[0].Value := Substancia.Text;
    DataModule1.ADOQuery1.Parameters[1].Value := Nome.Text;
    // Executa comandos SQL
    DataModule1.ADOQuery1.ExecSQL();

    Application.MessageBox('Inserido com sucesso!', 'Login',
                           Windows.MB_ICONINFORMATION);
    Insert_Solubilidad := TInsert_Solubilidad.Create(Application);
    Insert_Solubilidad.Show();
    Insert_Solubilidad.LoadData();
    Self.Hide();
end;

procedure TInsertSubstancia.OnClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);
end;

procedure TInsertSubstancia.OnCreate(Sender: TObject);
begin
  PerformForm(Self);
end;

procedure TInsertSubstancia.OnKeyPress(Sender: TObject; var Key: Char);
begin
  // Se a tecla Escape é pressionada
  if Key = #27 then
  begin
    Key := #0;
    Sound.Play_Cancel();
    Insert_Solubilidad.Show();
    Insert_Solubilidad.LoadData();
    Self.Hide();
  end
end;

procedure TInsertSubstancia.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SetPicture(3);
end;

procedure TInsertSubstancia.OnMouseEnter(Sender: TObject);
begin
  SetPicture(2);
end;

procedure TInsertSubstancia.OnMouseLeave(Sender: TObject);
begin
  SetPicture(1);
end;

procedure TInsertSubstancia.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetPicture(1);
end;

end.
