unit Menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, Tabela, jpeg, DB_Integrator,
  Insert_Stoichiometric, Sound, JogoDistribuicao, GameStoichiometric,
  Vcl.Buttons, Vcl.Imaging.GIFImg, Vcl.MPlayer, Vcl.StdCtrls;

type
  TInicio = class(TForm)
    Back: TImage;
    FadeOut: TImage;
    btn_info: TSpeedButton;
    Image1: TImage;
    Image2: TImage;
    Mouse_Prof: TImage;
    Mouse_Table: TImage;
    Mouse_Sair: TImage;
    MouseJogar: TImage;
    MediaPlayer1: TMediaPlayer;
    btn_voltar_menu: TSpeedButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ChangePicture();
    procedure Mode1();
    procedure Mode2();
    procedure Mode3();
    procedure Mode4();
    procedure Mode5();
    procedure Mode6();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Login( Kind : Boolean );
    procedure btn_infoClick(Sender: TObject);
    procedure Mouse_ProfMouseEnter(Sender: TObject);
    procedure Mouse_TableMouseEnter(Sender: TObject);
    procedure Mouse_SairMouseEnter(Sender: TObject);
    procedure MouseJogarMouseEnter(Sender: TObject);
    procedure MouseJogarClick(Sender: TObject);
    procedure Mouse_ProfClick(Sender: TObject);
    procedure Mouse_TableClick(Sender: TObject);
    procedure Mouse_SairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btn_voltar_menuClick(Sender: TObject);


  private
    { Private declarations }
    fImageActive : boolean;
  public
    { Public declarations }
      // Menu atual
      Mode   : Byte;
  end;

var
  Inicio : TInicio;
  // Armazena o índice da atual escolha selecionada
  Cursor : Byte = 1;
  // Jogo selecionado
  Game   : Byte;

implementation

uses Geometry, Manual, ManualVideo, Load, Login, Solubilidade, SendingPoints,
  Rank, Pre_Ranking, Insert_Solubilidade, ShellApi;

{$R *.dfm}

procedure TInicio.Login(Kind: Boolean);
begin
  FadeOut.Visible := False;
  if Kind then
  begin
    Mode := 4;
    Cursor := 1;
  end
  else
  begin
    Mode := 1;
    Cursor := 1;
  end;
  ChangePicture();
end;

procedure TInicio.Mode2;
begin
  Mode := 3;
  Game := Cursor;
  Cursor := 1;
  ChangePicture();
end;

procedure TInicio.Mode5();
begin
  if Cursor < 3 then
  begin
    Ajuda := TAjuda.Create(Self);
    Ajuda.SetManual(Game, Cursor);
    Ajuda.Show();
    Self.Hide();
    Exit();
  end
  else if Cursor = 4 then
  begin
    Mode := 3;
    Cursor := 1;
    ChangePicture();
  end
  else if Cursor = 3 then
  begin
    FadeOut.Visible := True;
    VideoManual := TVideoManual.Create(Self);
    VideoManual.SetVideo(Game);
    VideoManual.OpenVideo();
    Self.Enabled := False;
    VideoManual.Show();
  end;


end;

procedure TInicio.Mode3;
var I : Integer;
begin

  // Manual
  if Cursor = 3 then
  begin
    Mode := 5;
    Cursor := 1;
    ChangePicture();
    Exit();
  end

  // Voltar
  else if Cursor = 4 then
  begin
    Mode := 2;
    Cursor := 1;
    ChangePicture();
    Exit();
  end

  // Modo Avaliação e Modo Livre
  else if ( Cursor = 2 ) or ( Cursor = 1 ) then
  begin
    // Define o modo de jogo
    DB_Integrator.SetMode( Cursor );
    case Game of
      1: // Distribuição Eletrônica
      begin
      game:=1;
      if cursor = 2  then   begin
          SendingPoint := TSendingPoint.Create(Application);
          // Define valores
          SendingPoint.SetData(1, TotalPoints, 1);
          SendingPoint.Show();
          self.Hide;
      end
      else if cursor=1 then     begin
        EletronicDistribution := TEletronicDistribution.Create(Self);
        EletronicDistribution.Show();
        EletronicDistribution.ToChoose.Enabled  := True;
        EletronicDistribution.ToConfirm.Enabled := True;
        Self.Hide();
            end;

      end;
      2: // Ligação Iônica
      begin
      if cursor = 2  then   begin
          SendingPoint := TSendingPoint.Create(Application);
          // Define valores
          SendingPoint.SetData(2, TotalPoints, 1);
          SendingPoint.Show();
          self.Hide;
      end
        else if cursor = 1 then begin
        GeometryGame := TGeometryGame.Create(Self);
        GeometryGame.ResetVariables();
        GEometryGame.CallMe();
        GeometryGame.Show();
        Self.Hide();
        end;
      end;
      3: // Cálculos Estequiométrico

      begin
      if cursor = 2  then   begin
          SendingPoint := TSendingPoint.Create(Application);
          // Define valores
          SendingPoint.SetData(3, TotalPoints, 1);
          SendingPoint.Show();
          self.Hide;
      end

       else if cursor = 1 then begin CalculoEstequiometrico := TCalculoEstequiometrico.Create(Application);
        CalculoEstequiometrico.CallMe();
        CalculoEstequiometrico.Show();
        Self.Hide();
       end;
      end;
      4: // Solubilidade
      begin
      if cursor = 2  then   begin
          SendingPoint := TSendingPoint.Create(Application);
          // Define valores
          SendingPoint.SetData(4, TotalPoints, 1);
          SendingPoint.Show();
          self.Hide;
      end
       else if cursor = 1  then begin

        begin
          if Soluct <> Nil then
            FreeAndNil(Soluct);
          Soluct := TSoluct.Create(Soluct);
          Loading := TLoading.Create(Self);
          Loading.SetSoluct();
          Loading.Show();
          Self.Hide();
        end;
        end;
      end;
    end;
  end;
end;

procedure TInicio.Mode4();
begin
  if Cursor = 4 then
  begin
    Mode := 1;
    Cursor := 1;
    ChangePicture();
  end
  else if Cursor = 1 then
  begin
    Mode := 6;
    Cursor := 1;
    ChangePicture();
  end
  else if Cursor = 3 then
  begin

   Play_Decision(2);
      Ranking := TRanking.Create(Application);

      Self.Hide();
      Ranking.Show();
   // Pre_Rank := TPre_Rank.Create(Application);
   // Self.Hide();
   // Pre_Rank.Show();
  end;
end;


procedure TInicio.Mode6();
begin
  if Cursor = 1 then
  begin
    InsertStoichiometric := TInsertStoichiometric.Create(Application);
    Self.Hide();
    InsertStoichiometric.OnFormCreate(Application);
    InsertStoichiometric.Show();
  end
  else if Cursor = 4 then
  begin
    Mode := 4;
    Cursor := 1;
    ChangePicture();
  end
  else if Cursor = 3 then
  begin
    Insert_Solubilidad := TInsert_Solubilidad.Create(Application);
    Self.Hide();
    Insert_Solubilidad.Show();
  end;
end;

procedure TInicio.Mode1();
begin

  case Cursor of
  1:
  begin
    Mode := 2;
    Cursor := 1;
    ChangePicture();
  end;
  2:
  begin
    FadeOut.Visible := True;
    TeacherLogin := TTeacherLogin.Create(Self);
    TeacherLogin.ShowModal;
    FadeOut.Visible := False;
  end;
  3:
  begin
    PeriodicTable := TPeriodicTable.Create(Self);
    Tabela.PeriodicTable.Show();
    Tabela.PeriodicTable.Enabled := true;
    Tabela.PeriodicTable.Visible := true;
    Tabela.PeriodicTable.ActiveForm := true;
    Tabela.PeriodicTable.CursorIndex := Tabela.PeriodicTable.SaveCursorIndex;
    Tabela.WhereTo := 3;
    Self.Hide();
  end;
  4: Self.Close();
  end;
end;

procedure TInicio.btn_infoClick(Sender: TObject);
begin
ShellExecute(Handle, 'open', 'https://www.facebook.com/gr.athos', '', '', 1);
end;

procedure TInicio.btn_voltar_menuClick(Sender: TObject);
begin

if mode> 1 = true then   begin;

  mode:= mode-1;
end;

             if mode=4 then begin
             mode:=1;
             end;


  ChangePicture()


end;

procedure TInicio.ChangePicture();
begin
       if mode<=1 then   begin
      btn_voltar_menu.visible := false;
      label1.Visible := false;
  end
  else    begin
     btn_voltar_menu.visible := true;
      label1.Visible := true;
  end;

  Back.Picture.LoadFromFile('Graphics/Inicio/' + IntToStr(Mode) + '/' + IntToStr
                                                             (Cursor) + '.png');
end;



procedure TInicio.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);


end;

procedure TInicio.FormCreate(Sender: TObject);
begin


  PerformForm(Self);
  Cursor := 1;
  Mode   := 1;
  ShowCursor(False);
end;

procedure TInicio.FormHide(Sender: TObject);
begin
With MediaPlayer1 do
close;


end;

procedure TInicio.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if ( Key = VK_ESCAPE ) and ( Mode = 2 ) then
  begin
    Sound.Play_Cancel;
    Mode := 1;
    Cursor := 1;
    ChangePicture();
  end;

  if Key = VK_Down then
    begin
      if Cursor < 4 then
        Cursor := Cursor + 1
      else
        Cursor := 1;
      ChangePicture();
      Play_Cursor(1);
    end
  else if Key = VK_Up then
    begin
      if Cursor > 1 then
        Cursor := Cursor - 1
      else
        Cursor := 4;
      ChangePicture();
      Play_Cursor(1);
    end;

    if Key = VK_Return then
    begin
      case Mode of
      1: Mode1();
      2: Mode2();
      3: Mode3();
      4: Mode4();
      5: Mode5();
      6: Mode6();
      end;
      Play_Decision(1);
    end;
end;



procedure TInicio.FormShow(Sender: TObject);
begin
if mode<=1 = true then   begin
      btn_voltar_menu.visible := false;
      label1.Visible := false;
  end;

  with MediaPlayer1 do
  begin
  open;
  play;
  end ;

 end;
procedure TInicio.Mouse_SairClick(Sender: TObject);
begin
case Mode of
      1: Mode1();
      2: Mode2();
      3: Mode3();
      4: Mode4();
      5: Mode5();
      6: Mode6();
      end;
      Play_Decision(1);
end;

procedure TInicio.Mouse_SairMouseEnter(Sender: TObject);
begin
if Mode = 1 then
begin
             Mode := 1;
    Cursor := 4;
    ChangePicture();
    Play_Cursor(1);
             end;

               if Mode = 2 then   begin
        Mode := 2;
    Cursor := 4;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 3 then   begin
        Mode := 3;
    Cursor := 4;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 4 then   begin
        Mode := 4;
    Cursor := 4;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 5 then   begin
        Mode := 5;
    Cursor := 4;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 6 then   begin
        Mode := 6;
    Cursor := 4;
    ChangePicture();
    Play_Cursor(1)   ;
                end;
end;

procedure TInicio.MouseJogarClick(Sender: TObject);
begin
case Mode of
      1: Mode1();
      2: Mode2();
      3: Mode3();
      4: Mode4();
      5: Mode5();
      6: Mode6();
      end;
      Play_Decision(1);

end;

procedure TInicio.MouseJogarMouseEnter(Sender: TObject);
begin
if Mode = 1 then
            begin
 Mode := 1;
    Cursor := 1;
    ChangePicture();
    Play_Cursor(1) ;
     end;

       if Mode = 2 then   begin
        Mode := 2;
    Cursor := 1;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 3 then   begin
        Mode := 3;
    Cursor := 1;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 4 then   begin
        Mode := 4;
    Cursor := 1;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 5 then   begin
        Mode := 5;
    Cursor := 1;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 6 then   begin
        Mode := 6;
    Cursor := 1;
    ChangePicture();
    Play_Cursor(1)   ;
                end;
end;

procedure TInicio.Mouse_ProfClick(Sender: TObject);
begin
case Mode of
      1: Mode1();
      2: Mode2();
      3: Mode3();
      4: Mode4();
      5: Mode5();
      6: Mode6();
      end;
      Play_Decision(1);

end;

procedure TInicio.Mouse_ProfMouseEnter(Sender: TObject);
begin
  if Mode = 1 then begin

      Mode := 1;
    Cursor := 2;
    ChangePicture();
    Play_Cursor(1)  ;
              end;
                if Mode = 2 then   begin
        Mode := 2;
    Cursor := 2;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 3 then   begin
        Mode := 3;
    Cursor := 2;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 4 then   begin
        Mode := 4;
    Cursor := 2;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 5 then   begin
        Mode := 5;
    Cursor := 2;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 6 then   begin
        Mode := 6;
    Cursor := 2;
    ChangePicture();
    Play_Cursor(1)   ;
                end;
end;

procedure TInicio.Mouse_TableClick(Sender: TObject);
begin
case Mode of
      1: Mode1();
      2: Mode2();
      3: Mode3();
      4: Mode4();
      5: Mode5();
      6: Mode6();
      end;
      Play_Decision(1);
end;

procedure TInicio.Mouse_TableMouseEnter(Sender: TObject);
begin              if Mode = 1 then   begin
        Mode := 1;
    Cursor := 3;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                if Mode = 2 then   begin
        Mode := 2;
    Cursor := 3;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 3 then   begin
        Mode := 3;
    Cursor := 3;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 4 then   begin
        Mode := 4;
    Cursor := 3;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 5 then   begin
        Mode := 5;
    Cursor := 3;
    ChangePicture();
    Play_Cursor(1)   ;
                end;

                 if Mode = 6 then   begin
        Mode := 6;
    Cursor := 3;
    ChangePicture();
    Play_Cursor(1)   ;
                end;


end;

end.
