unit Master;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls;

type
  TAdmin = class(TForm)
    BackGround: TImage;
    Name: TEdit;
    Image3: TImage;
    Continue: TImage;
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnCreate(Sender: TObject);
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure ContinueClick(Sender: TObject);
    procedure OnShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Admin: TAdmin;

implementation

uses DB_Integrator, Sound, Register, Login;

{$R *.dfm}

procedure TAdmin.ContinueClick(Sender: TObject);
begin
  if Name.Text = '' then
    // Informa que o usuário já existe
    Application.MessageBox('Insira a senha.', 'Login', MB_ICONWARNING );

  // Limpa comandos SQL
  DB_Integrator.DataModule1.ADOQuery3.SQL.Clear;
  // Adiciona comando SQL ( Obtém a senha )
  DB_Integrator.DataModule1.ADOQuery3.SQL.Add('Select Senha from' +
                                              ' Administrador');
  // Ativa o SQL
  DataModule1.Adoquery3.Active := True;
  // Executa comandos SQL
  DataModule1.Adoquery3.ExecSQL;

  if Crypt(Name.Text) = DataModule1.ADOQuery3.FieldByName('Senha').AsString then
  begin
    RegisterUser.Make();
    // Informa que o usuário já existe
    Application.MessageBox('Usuário cadastrado com sucesso', 'Login', MB_ICONINFORMATION );
    Self.Close();
    RegisterUser.Close();
    Login.TeacherLogin.Close();
  end
  else
    // Informa que o usuário já existe
    Application.MessageBox('Senha incorreta.', 'Login', MB_ICONWARNING  );
end;

procedure TAdmin.OnCreate(Sender: TObject);
begin
  DB_Integrator.PerformForm( Self );
end;

procedure TAdmin.OnKeyPress(Sender: TObject; var Key: Char);
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
    // Continua
  end;
end;

procedure TAdmin.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Continue.Picture.LoadFromFile('Graphics/Master/Continue_3.png');
end;

procedure TAdmin.OnMouseEnter(Sender: TObject);
begin
  Continue.Picture.LoadFromFile('Graphics/Master/Continue_2.png');
end;

procedure TAdmin.OnMouseLeave(Sender: TObject);
begin
  Continue.Picture.LoadFromFile('Graphics/Master/Continue_1.png');
end;

procedure TAdmin.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Continue.Picture.LoadFromFile('Graphics/Master/Continue_1.png');
end;

procedure TAdmin.OnShow(Sender: TObject);
begin
  Name.Clear();
end;

end.
