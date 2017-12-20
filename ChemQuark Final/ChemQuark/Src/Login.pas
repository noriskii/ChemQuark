unit Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls;

type
  TTeacherLogin = class(TForm)
    Forgot_PassWord: TLabel;
    BackGround: TImage;
    User: TEdit;
    PassWord: TEdit;
    New: TImage;
    Enter: TImage;
    Cancel: TImage;
    Logo: TImage;
    procedure OnEnter(Sender: TObject);
    procedure OnLeave(Sender: TObject);
    procedure OnCreate(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure UpdatePicture( Who : Byte; ID : Byte );
    procedure OnMouseLeave(Sender: TObject);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CancelClick(Sender: TObject);
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure NewClick(Sender: TObject);
    procedure Forgot_PassWordClick(Sender: TObject);
    procedure EnterClick(Sender: TObject);
    procedure OnShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TeacherLogin: TTeacherLogin;

implementation

uses DB_Integrator, Sound, Register, Tip, Menu;

{$R *.dfm}

procedure TTeacherLogin.CancelClick(Sender: TObject);
begin
  Sound.Play_Cancel();
  Self.Close();
end;

procedure TTeacherLogin.EnterClick(Sender: TObject);
var I : Byte;
var CanLogin : Boolean;
begin

  // Se o campo de usuário estiver vazio.
  if User.Text = '' then
  begin
    Application.MessageBox('Insira o usuário.', 'Login', MB_ICONWARNING  );
    Exit;
  end
  else if PassWord.Text = '' then
  begin
    Application.MessageBox('Insira a senha.', 'Login', MB_ICONWARNING  );
    Exit;
  end;

  // Executa efeito sonoro de decisão
  Sound.Play_Decision(3);

  // Limpa comandos SQL
  DB_Integrator.DataModule1.ADOQuery2.SQL.Clear;
  // Adiciona comando SQL ( Obtém a quantidade de usuários )
  DB_Integrator.DataModule1.ADOQuery2.SQL.Add('Select Count(*) as ID from' +
                                              ' Professor');
  // Ativa o SQL
  DataModule1.Adoquery2.Active := True;
  // Executa comandos SQL
  DataModule1.Adoquery2.ExecSQL;

  // Para todos as usuários
  for I := 1 to DataModule1.ADOQuery2.FieldByName('ID').AsInteger do
  begin
    // Limpa comandos SQL
    DataModule1.ADOQuery2.SQL.Clear();
    // Adiciona comando SQL ( Para todos os Usuários )
    DataModule1.ADOQuery2.SQL.Add('Select Usuario from Professo' +
      'r where ID = ' + IntToStr(I));
    // Ativa SQL
    DataModule1.ADOQuery2.Active := True;
    // Executa SQL
    DataModule1.ADOQuery2.ExecSQL;
    // Se encontrar o usuário
    if Crypt(User.Text) = DataModule1.ADOQuery2.FieldByName(
                                                       'Usuario').AsString then
    begin
      // Limpa comandos SQL
      DataModule1.ADOQuery2.SQL.Clear();
      // Adiciona comando SQL ( Para todas as Senhas )
      DataModule1.ADOQuery2.SQL.Add('Select * from Professo' +
        'r where ID = ' + IntToStr(I));
      // Ativa SQL
      DataModule1.ADOQuery2.Active := True;
      // Executa SQL
      DataModule1.ADOQuery2.ExecSQL;
      // Se a senha corresponder à senha do usuário
      if Crypt(PassWord.Text) = DataModule1.ADOQuery2.FieldByName(
                                                  'Senha').AsString then
      begin
        ShowMessage('Bem-vindo, ' + DataModule1.ADOQuery2.FieldByName(
                'Nome').AsString + '.');
        // Permite logar
        CanLogin := True;
        // Sai do loop
        Break;
      end;

    end;
  end;

  // Se puder logar
  if CanLogin then
  begin
    // Fecha a janela
    Self.Close();
    // Loga
    Inicio.Login( True );
  end
  else
    Application.MessageBox('Usuário e/ou senha incorreto(s)', 'Login', MB_ICONWARNING );

end;

procedure TTeacherLogin.Forgot_PassWordClick(Sender: TObject);
begin
  Sound.Play_Cursor(1);
  Tip.PassWordFaq.ShowModal();
end;

procedure TTeacherLogin.NewClick(Sender: TObject);
begin
  // Executa efeito sonoro de confirmação
  Sound.Play_Decision(3);
  RegisterUser.ShowModal();
end;

procedure TTeacherLogin.OnCreate(Sender: TObject);
begin
  DB_Integrator.PerformForm( Self );
  Self.Width := 400;
  Self.Height := 400;
end;

procedure TTeacherLogin.OnEnter(Sender: TObject);
begin
  Forgot_PassWord.Font.Color := RGB(200,200,255)
end;

procedure TTeacherLogin.OnKeyPress(Sender: TObject; var Key: Char);
begin

  // Se a tecla Escape é pressionada
  if Key = #27 then
  begin
    Key := #0;
    Sound.Play_Cancel();
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

procedure TTeacherLogin.OnLeave(Sender: TObject);
begin
  Forgot_PassWord.Font.Color := clGray
end;

procedure TTeacherLogin.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if Sender = Enter then
    UpdatePicture(1, 3)
  else if Sender = New then
    UpdatePicture(2, 3)
  else if Sender = Cancel then
    UpdatePicture(3, 3);

end;

procedure TTeacherLogin.OnMouseEnter(Sender: TObject);
begin

  if Sender = Enter then
    UpdatePicture(1, 2)
  else if Sender = New then
    UpdatePicture(2, 2)
  else if Sender = Cancel then
    UpdatePicture(3, 2);

end;

procedure TTeacherLogin.OnMouseLeave(Sender: TObject);
begin
  if Sender = Enter then
    UpdatePicture(1, 1)
  else if Sender = New then
    UpdatePicture(2, 1)
  else if Sender = Cancel then
    UpdatePicture(3, 1);
end;

procedure TTeacherLogin.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Sender = Enter then
    UpdatePicture(1, 1)
  else if Sender = New then
    UpdatePicture(2, 1)
  else if Sender = Cancel then
    UpdatePicture(3, 1);
end;

procedure TTeacherLogin.OnShow(Sender: TObject);
begin
  PassWord.Clear();
  User.Clear();
end;

procedure TTeacherLogin.UpdatePicture( Who : Byte; ID: Byte);
begin
  case Who of
  1: Enter.Picture.LoadFromFile('Graphics/Login/Enter_' + IntToStr(ID) + '.png');
  2: New.Picture.LoadFromFile('Graphics/Login/New_' + IntToStr(ID) + '.png');
  3: Cancel.Picture.LoadFromFile('Graphics/Login/Cancel_' + IntToStr(ID) + '.png');
  end;
end;

end.
