unit Insert_Solubilidade;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, pngimage, DBCtrls;

type
  TInsert_Solubilidad = class(TForm)
    Massa: TEdit;
    Temperatura: TEdit;
    NomeSubstancia: TEdit;
    BackGround: TImage;
    Plus: TImage;
    Medida: TComboBox;
    Substancia: TComboBox;
    Salvar: TImage;
    Sair: TImage;
    procedure ActionSave();
    procedure FormCreate(Sender: TObject);
    procedure LoadData();
    function  GetMax() : Integer;
    procedure SubstanciaChange(Sender: TObject);
    procedure PlusClick(Sender: TObject);
    procedure OnClose(Sender: TObject; var Action: TCloseAction);
    procedure SetPicture( Index : Byte );
    procedure SetPicture_( Index : Byte );
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseDown_(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseEnter_(Sender: TObject);
    procedure OnMouseLeave_(Sender: TObject);
    procedure OnMouseUp_(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SairClick(Sender: TObject);
    procedure SalvarClick(Sender: TObject);
    function GetCode() : LongInt;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Insert_Solubilidad: TInsert_Solubilidad;

implementation

uses DB_Integrator, Sound, Insert_Substance, Menu;

{$R *.dfm}

function TInsert_Solubilidad.GetCode : LongInt;
begin
  DataModule1.ADOQuery1.SQL.Clear;
  DataModule1.ADOQuery1.SQL.Add('Select ID From Solubilidade Where Substancia like "' +
                                Substancia.Text + '";');
  DataModule1.ADOQuery1.Active := True;
  DataModule1.ADOQuery1.ExecSQL;
  Result := DataModule1.ADOQuery1.FieldByName('ID').AsInteger;
end;

procedure TInsert_Solubilidad.SairClick(Sender: TObject);
begin
  Sound.Play_Cancel();
  // Fecha a janela
  if InsertSubstancia <> Nil then
    FreeAndNil(InsertSubstancia);
  Inicio.Show();
  Insert_Solubilidad.Release;
end;

procedure TInsert_Solubilidad.SalvarClick(Sender: TObject);
begin
  if ( SpaceDelete( Substancia.Text ) = '' ) Or
     ( SpaceDelete( Medida.Text     ) = '' ) Or
     ( SpaceDelete( Massa.Text      ) = '' ) Or
     ( SpaceDelete( Temperatura.Text) = '' ) then
  begin
    Application.MessageBox('Preencha todos os campos',
                             'Inserção', MB_ICONWARNING  );
    Exit();
  end;

  ActionSave();
  Sound.Play_Decision(3);
  ShowMessage('Gravado com sucesso!');
  Massa.Clear();
  Temperatura.Clear();
  NomeSubstancia.Clear();
  Medida.Text := '';
  Substancia.Text := '';

end;

procedure TInsert_Solubilidad.SetPicture(Index: Byte);
begin
  With Salvar.Picture Do
    LoadFromFile('Graphics/Insert/Save_' + IntToStr(Index) + '.png');
end;

procedure TInsert_Solubilidad.SetPicture_(Index: Byte);
begin
  With Sair.Picture Do
    LoadFromFile('Graphics/Insert/Exit_' + IntToStr(Index) + '.png');
end;

//------------------------------------------------------------------------------
// * Ação de Salvar Informações no Banco de Dados
//------------------------------------------------------------------------------
procedure TInsert_Solubilidad.ActionSave();
var I : Byte;
begin
  // ------------------------------------------------------------------------ //
    // Limpa comandos SQL
    DB_Integrator.DataModule1.RankingQuery.SQL.Clear;
    // Cria parâmetros para inserção
    DB_Integrator.DataModule1.RankingQuery.SQL.Add('Insert Into Coeficiente' +
    ' (ID_Substancia, Massa, Temperatura, Medida) Values (' + IntToStr(GetCode) +
    ',' + FloatToStr(RemovePoints_(SpaceDelete(Massa.Text))) + ',' +
    FloatToStr(RemovePoints_(SpaceDelete(Temperatura.Text))) + ',"' +
    Medida.Text[1] + '");');

    DataModule1.RankingQuery.ExecSQL();
  // ------------------------------------------------------------------------ //

end;

procedure TInsert_Solubilidad.FormCreate(Sender: TObject);
begin
  PerformForm(Self);
  LoadData();
end;

function TInsert_Solubilidad.GetMax() : Integer;
begin
  Result := DataModule1.ADOQuery1.FieldCount - 1;
end;

procedure TInsert_Solubilidad.LoadData();
var I : Integer;
begin

  I := 0;
  Substancia.Clear;
  DataModule1.ADOQuery1.SQL.Clear;
  DataModule1.ADOQuery1.SQL.Add('Select Substancia From Solubilidade');
  DataModule1.ADOQuery1.Active := True;
  DataModule1.ADOQuery1.ExecSQL;
  DataModule1.ADOQuery1.First();
  While not DataModule1.ADOQuery1.Eof do
  begin
    Substancia.Items.Add(DataModule1.ADOQuery1.FieldByName('Substancia').AsString);
    DataModule1.ADOQuery1.Next();
    I := I + 1;
  end;
end;

procedure TInsert_Solubilidad.OnClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);
end;

procedure TInsert_Solubilidad.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetPicture(2);
end;

procedure TInsert_Solubilidad.OnMouseDown_(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetPicture_(2);
end;

procedure TInsert_Solubilidad.OnMouseEnter(Sender: TObject);
begin
  SetPicture(3);
  Sound.Play_Cursor(1);
end;

procedure TInsert_Solubilidad.OnMouseEnter_(Sender: TObject);
begin
  SetPicture_(3);
  Sound.Play_Cursor(1);
end;

procedure TInsert_Solubilidad.OnMouseLeave(Sender: TObject);
begin
  SetPicture(1);
end;

procedure TInsert_Solubilidad.OnMouseLeave_(Sender: TObject);
begin
  SetPicture_(1);
end;

procedure TInsert_Solubilidad.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetPicture(1);
end;

procedure TInsert_Solubilidad.OnMouseUp_(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetPicture_(1);
end;

procedure TInsert_Solubilidad.PlusClick(Sender: TObject);
begin
  Sound.Play_Decision(1);
  InsertSubstancia := TInsertSubstancia.Create(Application);
  InsertSubstancia.Show();
  Self.Hide();
end;

procedure TInsert_Solubilidad.SubstanciaChange(Sender: TObject);
begin
  DataModule1.ADOQuery1.SQL.Clear;
  DataModule1.ADOQuery1.SQL.Add('Select Nome From Solubilidade Where Substancia' +
                                ' like "' + Substancia.Text + '";');
  DataModule1.ADOQuery1.Active := True;
  DataModule1.ADOQuery1.ExecSQL;
  NomeSubstancia.Text := DataModule1.ADOQuery1.FieldByName('Nome').AsString;
end;

end.
