unit Register;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls;

type
  TRegisterUser = class(TForm)
    BackGround: TImage;
    Cancel: TImage;
    Register: TImage;
    Logo: TImage;
    PassWord: TEdit;
    User: TEdit;
    Tip: TEdit;
    ToTable: TImage;
    Image1: TImage;
    Image2: TImage;
    Name: TEdit;
    Image3: TImage;
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UpdatePicture( Who : Byte; ID: Byte);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure CancelClick(Sender: TObject);
    procedure RegisterClick(Sender: TObject);
    function  UserSearching() : Boolean;
    procedure Make();
    procedure OnShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RegisterUser: TRegisterUser;

implementation

uses DB_Integrator, Sound, Master;

{$R *.dfm}

procedure TRegisterUser.Make();
begin

    Sound.Play_Decision(1);

    // ------------------------------------------------------------------------ //
    // Limpa comandos SQL
    DB_Integrator.DataModule1.ADOQuery2.SQL.Clear;
    // Cria parâmetros para inserção
    DB_Integrator.DataModule1.ADOQuery2.SQL.Add('Insert into Professor' +
    ' (Nome, Usuario, Senha, Dica)' +
    ' Values (:A, :B, :C, :D)');

    // Insera-os no banco de dados
    DataModule1.ADOQuery2.Parameters[0].Value := Name.Text;
    DataModule1.ADOQuery2.Parameters[1].Value := Crypt(User.Text);
    DataModule1.ADOQuery2.Parameters[2].Value := Crypt(PassWord.Text);
    DataModule1.ADOQuery2.Parameters[3].Value := Tip.Text;

    // Executa comandos SQL
    DataModule1.ADOQuery2.ExecSQL();
  // ------------------------------------------------------------------------ //

end;

procedure TRegisterUser.CancelClick(Sender: TObject);
begin
  // Executa efeito sonoro de cancelamento
  Sound.Play_Cancel();
  // Fecha cadastro de usuário
  Self.Close();
end;

procedure TRegisterUser.FormCreate(Sender: TObject);
begin
  DB_Integrator.PerformForm( Self );
end;

procedure TRegisterUser.OnKeyPress(Sender: TObject; var Key: Char);
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

procedure TRegisterUser.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Sender = Register then
    UpdatePicture(1, 3)
  else if Sender = Cancel then
    UpdatePicture(2, 3)
end;

procedure TRegisterUser.OnMouseEnter(Sender: TObject);
begin
  if Sender = Register then
    UpdatePicture(1, 2)
  else if Sender = Cancel then
    UpdatePicture(2, 2);
end;

procedure TRegisterUser.OnMouseLeave(Sender: TObject);
begin
  if Sender = Register then
    UpdatePicture(1, 1)
  else if Sender = Cancel then
    UpdatePicture(2, 1);
end;

procedure TRegisterUser.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Sender = Register then
    UpdatePicture(1, 1)
  else if Sender = Cancel then
    UpdatePicture(2, 1);
end;

procedure TRegisterUser.OnShow(Sender: TObject);
begin
  PassWord.Clear();
  Tip.Clear();
  Name.Clear();
  User.Clear();
end;

procedure TRegisterUser.RegisterClick(Sender: TObject);
begin
  // Se o campo de usuário estiver vazio.
  if Name.Text = '' then
  begin
    Application.MessageBox('Insira o nome.', 'Login', MB_ICONWARNING  );
    Exit;
  end
  else if ( User.Text = '' ) or ( Length( User.Text ) < 4 ) then
  begin
    Application.MessageBox('Insira um usuário correto', 'Login', MB_ICONWARNING  );
    Exit;
  end
  else if ( PassWord.Text = '' ) or ( Length( PassWord.Text ) < 4 ) then
  begin
    Application.MessageBox('Insira uma senha correta.', 'Login', MB_ICONWARNING  );
    Exit;
  end
  else if Tip.Text = '' then
  begin
    Application.MessageBox('Insira a dica.', 'Login', MB_ICONWARNING  );
    Exit;
  end;

  if UserSearching() then
  begin
    // Executa efeito sonoro de decisão
    Sound.Play_Decision(3);
    // Abre a janela de permissão
    Master.Admin.ShowModal();
  end
  else
    // Informa que o usuário já existe
    Application.MessageBox('Usuário já cadastrado', 'Login', MB_ICONWARNING  );
end;

function TRegisterUser.UserSearching() : Boolean;
var I : Byte;
begin
    // Limpa comandos SQL
  DB_Integrator.DataModule1.ADOQuery2.SQL.Clear;
  // Adiciona comando SQL ( Obtém a quantidade de usuários )
  DB_Integrator.DataModule1.ADOQuery2.SQL.Add('Select Count(*) as ID from' +
                                              ' Professor');
  // Ativa o SQL
  DataModule1.Adoquery2.Active := True;
  // Executa comandos SQL
  DataModule1.Adoquery2.ExecSQL;

  // Para todos os usuários
  for I := 1 to DataModule1.ADOQuery2.FieldByName('ID').AsInteger do
  begin
    // Limpa comandos SQL
    DataModule1.ADOQuery2.SQL.Clear();
    // Adiciona comando SQL ( Para todos usuários )
    DataModule1.ADOQuery2.SQL.Add('Select Usuario from Professo' +
      'r where ID = ' + IntToStr(I));
    // Ativa SQL
    DataModule1.ADOQuery2.Active := True;
    // Executa SQL
    DataModule1.ADOQuery2.ExecSQL;
    // Se já houver a equação não balanceada
    if Crypt(User.Text) = DataModule1.ADOQuery2.FieldByName('Usuario').AsString then
    begin
      // Retorna que usuário existe
      Result := False;
      // Sai da função
      Exit;
    end;
  end;
  // Retorna que não existe o usuário
  Result := True;
end;

procedure TRegisterUser.UpdatePicture( Who : Byte; ID: Byte);
begin
  case Who of
  1: Register.Picture.LoadFromFile('Graphics/Register/Register_' + IntToStr(ID) + '.png');
  2: Cancel.Picture.LoadFromFile('Graphics/Register/Cancel_' + IntToStr(ID) + '.png');
  end;
end;

end.
