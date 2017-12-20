unit Tip;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls;

type
  TPassWordFaq = class(TForm)
    BackGround: TImage;
    Name: TEdit;
    Image3: TImage;
    Okay: TImage;
    Tip: TMemo;
    Back: TImage;
    procedure UpdatePicture( Who : Byte; ID : Byte );
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BackClick(Sender: TObject);
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure OnCreate(Sender: TObject);
    procedure OnShow(Sender: TObject);
    procedure OkayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PassWordFaq: TPassWordFaq;

implementation

uses Sound, DB_Integrator, Login, Register, Solubilidade, Menu, Tabela,
  Propriedades, SendingPoints, Master;

{$R *.dfm}

procedure TPassWordFaq.BackClick(Sender: TObject);
begin
  // Executa efeito sonoro de cancelamento
  Sound.Play_Cancel();
  // Fecha a janela
  Self.Close();
end;

procedure TPassWordFaq.OkayClick(Sender: TObject);
var I : Byte;
begin
  if Name.Text = '' then
  begin
    Sound.Play_Error;
    Application.MessageBox('Insira um usuário.', 'Login', MB_ICONWARNING  );
    Exit;
  end;

  // Limpa comandos SQL
  DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;
  // Adiciona comando SQL ( Obtém a quantidade de usuários )
  DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Select Count(*) as ID from' +
                                              ' Professor');
  // Ativa o SQL
  DataModule1.Adoquery1.Active := True;
  // Executa comandos SQL
  DataModule1.Adoquery1.ExecSQL;

  // Para todos os usuários
  for I := 1 to DataModule1.ADOQuery1.FieldByName('ID').AsInteger do
  begin
    // Limpa comandos SQL
    DataModule1.ADOQuery1.SQL.Clear();
    // Adiciona comando SQL ( Para todos usuários )
    DataModule1.ADOQuery1.SQL.Add('Select * from Professo' +
      'r where ID = ' + IntToStr(I));
    // Ativa SQL
    DataModule1.ADOQuery1.Active := True;
    // Executa SQL
    DataModule1.ADOQuery1.ExecSQL;
    // Se já houver a equação não balanceada
    if Crypt(Name.Text) = DataModule1.ADOQuery1.FieldByName('Usuario').AsString then
    begin
      Tip.Text := DataModule1.ADOQuery1.FieldByName('Dica').AsString;
      // Sai da função
      Exit;
    end;
  end;
end;

procedure TPassWordFaq.OnCreate(Sender: TObject);
begin
  DB_Integrator.PerformForm( Self );
  Tip.Clear();
end;

procedure TPassWordFaq.OnKeyPress(Sender: TObject; var Key: Char);
begin
  // Se a tecla Escape é pressionada
  if Key = #27 then
  begin
    Key := #0;
    Sound.Play_Cancel();
    // Fecha a janela
    Self.Close();
  end
  else if Key = #13 then { Tecla Enter }
  begin
    // Impede Bip
    Key := #0;
    // Executa efeito sonoro de próximo
    Play_Move();
    // Move o cursor até o próximo Campo
    Perform(WM_nextdlgctl,0,0);
  end;
end;

procedure TPassWordFaq.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Sender = Okay then
    UpdatePicture(1, 3)
  else if Sender = Back then
    UpdatePicture(2, 3)
end;

procedure TPassWordFaq.OnMouseEnter(Sender: TObject);
begin
  if Sender = Okay then
    UpdatePicture(1, 2)
  else if Sender = Back then
    UpdatePicture(2, 2)
end;

procedure TPassWordFaq.OnMouseLeave(Sender: TObject);
begin
  if Sender = Okay then
    UpdatePicture(1, 1)
  else if Sender = Back then
    UpdatePicture(2, 1)
end;

procedure TPassWordFaq.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Sender = Okay then
    UpdatePicture(1, 1)
  else if Sender = Back then
    UpdatePicture(2, 1)
end;

procedure TPassWordFaq.OnShow(Sender: TObject);
begin
  Tip.Clear();
  Name.Clear();
end;

procedure TPassWordFaq.UpdatePicture( Who : Byte; ID: Byte);
begin
  case Who of
  1: Okay.Picture.LoadFromFile('Graphics/Tip/Okay_' + IntToStr(ID) + '.png');
  2: Back.Picture.LoadFromFile('Graphics/Tip/Back_' + IntToStr(ID) + '.png');
  end;
end;

end.
