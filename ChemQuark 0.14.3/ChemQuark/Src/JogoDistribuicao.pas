unit JogoDistribuicao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, pngimage, jpeg, DB_Integrator, Sound, Vcl.MPlayer;

type
  TEletronicDistribution = class(TForm)
    MoveLabel: TTimer;
    BackGround: TImage;
    Element: TLabel;
    Number: TLabel;
    PopUp: TImage;
    ToChoose: TTimer;
    ToConfirm: TTimer;
    Points: TLabel;
    Tempo: TLabel;
    CountTime: TTimer;
    WinCount: TTimer;
    _1s: TLabel;
    _2p: TLabel;
    _2s: TLabel;
    _3d: TLabel;
    _3p: TLabel;
    _3s: TLabel;
    _4d: TLabel;
    _4f: TLabel;
    _4p: TLabel;
    _4s: TLabel;
    _5d: TLabel;
    _5f: TLabel;
    _5p: TLabel;
    _5s: TLabel;
    _6d: TLabel;
    _6p: TLabel;
    _6s: TLabel;
    _7p: TLabel;
    _7s: TLabel;
    FastTimer: TTimer;
    Table: TImage;
    FinalPoint: TLabel;
    Forfeit: TImage;
    MediaPlayer1: TMediaPlayer;
    Img_facil: TImage;
    Img_medio: TImage;
    Img_dificil: TImage;
    lbl_points: TLabel;
    JogarNovamente: TImage;
    Sair: TImage;
    popup2: TImage;
    btn_Manual: TImage;
    lbl_status: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ___1sOnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure __1sOnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MoveLabelTimer(Sender: TObject);
    procedure TableClick(Sender: TObject);
    procedure SetDirection;
    procedure Back( Index : Byte );
    procedure FinishPress;
    procedure GameBegins( TLevel : Byte );
    procedure ToChooseTimer(Sender: TObject);
    procedure ChangePicture;
    procedure DisposeSelect;
    procedure RemovePoints( Value : Integer );
    procedure UpdateTime;
    procedure CountTimeTimer(Sender: TObject);
    procedure ShowResult( Result : Boolean );
    procedure WinCountTimer(Sender: TObject);
    procedure Choices();
    procedure SelectChoice( Index : Byte );
    procedure ElementClick(Sender: TObject);
    procedure _TableOnMouseEnter(Sender: TObject);
    procedure _TableOnMouseLeave(Sender: TObject);
    procedure _TableOnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure _TableOnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Change_Forfeit_Picture();
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Img_facilMouseEnter(Sender: TObject);
    procedure Img_medioMouseEnter(Sender: TObject);
    procedure Img_dificilMouseEnter(Sender: TObject);
    procedure Img_facilClick(Sender: TObject);
    procedure Img_medioClick(Sender: TObject);
    procedure Img_dificilClick(Sender: TObject);
    procedure JogarNovamenteClick(Sender: TObject);
    procedure SairClick(Sender: TObject);
    procedure JogarNovamenteMouseEnter(Sender: TObject);
    procedure JogarNovamenteMouseLeave(Sender: TObject);
    procedure SairMouseEnter(Sender: TObject);
    procedure SairMouseLeave(Sender: TObject);
    procedure btn_ManualClick(Sender: TObject);
    procedure FastTimerTimer(Sender: TObject);
    procedure btn_ManualMouseEnter(Sender: TObject);
    procedure btn_ManualMouseLeave(Sender: TObject);
  private
    { Private declarations }

  public
    var Scene: String ;   MusicLenght: integer ;
  end;

var

  EletronicDistribution: TEletronicDistribution;
  Niveis : Array[1..19] of TLabel;
  SubNiveis : Array[1..19] of Byte =
  ( 2  { 1s }, 2  { 2s }, 6  { 2p }, 2 { 3s },
    6  { 3p }, 2  { 4s }, 10 { 3d }, 6 { 4p },
    2  { 5s }, 10 { 4d }, 6  { 5p }, 2 { 6s },
    14 { 4f }, 10 { 5d }, 6  { 6p }, 2 { 7s },
    14 { 5f }, 10 { 6d }, 6  { 7p }         );
  MouseActive : Byte;
  Dir : Byte = 1;
  Inside : Array[1..19] of TLabel;
  Count  : Byte = 0;
  Answer : String = '';
  ElementRand : Byte = 1;
  Cursor : Byte;
  Point  : Integer = 1000;
  Second : Byte = 0;
  Minute : Byte = 0;
  WinCoun : Byte = 0;
  Level  : Byte;
  ButtonPressing : Boolean;
  Forfeit_Cursor : Byte;
  
implementation

uses Tabela, Menu, Propriedades, SendingPoints;

{$R *.dfm}

  procedure TEletronicDistribution.SairClick(Sender: TObject);
begin
 ToChoose.Enabled := false;
      ToConfirm.Enabled := false;
      Inicio := TInicio.Create(Application);
      Inicio.FormCreate(Application);
      Inicio.Show();
      Cursor := 1;
      Table.Enabled := true;
      FreeAndNil(Self);
end;

procedure TEletronicDistribution.SairMouseEnter(Sender: TObject);
begin
Sair.Picture.LoadFromFile('Graphics/Button/sair_on.png');
end;

procedure TEletronicDistribution.SairMouseLeave(Sender: TObject);
begin
Sair.Picture.LoadFromFile('Graphics/Button/sair.png');
end;

procedure TEletronicDistribution.SelectChoice(Index: Byte);
  var I : Integer;
  begin
  lbl_points.Caption:= '';
    Play_Decision(1);
    if Index = 3 then
    begin
      ToChoose.Enabled := false;
      ToConfirm.Enabled := false;
      Inicio := TInicio.Create(Application);
      Inicio.FormCreate(Application);
      Inicio.Show();
      Cursor := 1;
      Table.Enabled := true;
      FreeAndNil(Self);
    end
    else if Index = 2 then
    begin
      FreeAndNil(EletronicDistribution);
      EletronicDistribution := TEletronicDistribution.Create(Application);
      ToChoose.Enabled := true;
      ToConfirm.Enabled := true;
      Cursor := 1;
      Table.Enabled := True;
      Self.Show;
    end
    else if Index = 1 then
    begin
      I := Level;
      if Self <> Nil then
      begin
        FreeAndNil(EletronicDistribution);
        EletronicDistribution := TEletronicDistribution.Create(Application);
      end;
      PopUp.Visible := False;
      Cursor := 1;
      Points.Caption := '1000';
      Table.Enabled := True;
      Self.Show;
      GameBegins( I );
    end;
  end;

  procedure TEletronicDistribution.Choices;
  begin
  lbl_points.caption :=  '';
    PopUp.Picture.LoadFromFile('Graphics/Distribuição/Escolha/Retry.png');
    Scene := 'Menu';
    Cursor := 1;
    ToChoose.Enabled  := True;
    ToConfirm.Enabled := True;
    popup.Visible:= true;
  end;

  procedure TEletronicDistribution.ShowResult;
  var I : Byte;
  begin
  if db_integrator.Mode = 1 then begin;
    SendingPoint := TSendingPoint.Create(Application);
        SendingPoint.SetData( 1, Point, 1 );
        SendingPoint.Show();
        FreeAndNil(EletronicDistribution);
  end
   else if db_integrator.Mode = 2 then  begin;

    for I := 1 to 19 do
      Niveis[I].Enabled := false;

    CountTime.Enabled := False;
    Table.Enabled     := False;
    WinCount.Enabled  := True;
    if Result then
    begin
      PopUp.Picture.LoadFromFile('Graphics/Distribuição/Result/Won.png');
      lbl_points.caption :=   IntToStr( Point div ( ( Minute * 60 ) + Second ) * ElementRand );;
      Play_Me('Victory1.wav');
    end
    else
    begin
      PopUp2.Picture.LoadFromFile('Graphics/Distribuição/Result/Lost.png');
      lbl_points.caption := '';
      Play_Me('GameOver2.wav');
    end;
    lbl_status.Font.Color:=clgreen;
    lbl_status.Caption:= 'Ótimo! Você foi muito bem :)';
    PopUp.Visible := false;
    Popup.Enabled:= false;
     popup2.Visible:= true;
     JogarNovamente.visible := true;
Sair.visible := true;
JogarNovamente.Enabled := true;
Sair.Enabled:= true;
   end;

end ;

  procedure TEletronicDistribution.UpdateTime;
  begin
    Second := Second + 1;
    if Second mod 60 = 0 then
    begin
      Second := 0;
      Minute := Minute + 1;
    end;

    With Tempo do
    begin
      if Minute < 10 then
      begin
        if Second < 10 then
          Caption := '0' + IntToStr(Minute) + ':0' + IntToStr(Second)
        else
          Caption := '0' + IntToStr(Minute) + ':'  + IntToStr(Second);
      end
      else
        if Second < 10 then
          Caption := IntToStr(Minute) + ':0' + IntToStr(Second)
        else
          Caption := IntToStr(Minute) + ':'  + IntToStr(Second);
    end;

  end;

  procedure TEletronicDistribution.WinCountTimer(Sender: TObject);

  begin


    if ( WinCoun = 8 )then
    begin

      // Avaliação
      if DB_Integrator.Mode = 1 then
      begin
        SendingPoint := TSendingPoint.Create(Application);
        SendingPoint.SetData( 1, Point, 1 );
        SendingPoint.Show();
        FreeAndNil(EletronicDistribution);
      end
      else if DB_Integrator.Mode = 2 then

      begin
        Choices();
        FinalPoint.Visible := False;
        FinalPoint.Caption := '';
         //self.Enabled := False;

      end
    end;
    if ( WinCoun = 1 ) then
    begin
      FinalPoint.Visible := false;
      FinalPoint.Caption := IntToStr( Point div ( ( Minute * 60 ) + Second ) * ElementRand );

      ShowResult(true);

        end;


  end;

procedure TEletronicDistribution.RemovePoints(Value: Integer);
    var name, numero_aluno,serie_aluno : string;
  begin

       BackGround.Picture.LoadFromFile ('Graphics\Distribuição\AllError.png');

    Point := Point - Value;
    if Point < 0 then
      Point := 0;
    With Points do
    begin
      Caption := IntToStr(Point);
    end;
    if db_integrator.Mode=2 then
                           begin;
    name := SendingPoints.SendingPoint.Name.Text+'-Distribuicao Eletronica';
    numero_aluno :=  SendingPoints.SendingPoint.Number.Text;
    serie_aluno := SendingPoints.SendingPoint.Room.Text;
        DB_Integrator.DataModule1.ADOQuery1.SQL.Clear;


     // INSERIR CÓDIGO DE ATUALIZAÇÃO DO BANCO AQUI '-'
      DB_Integrator.DataModule1.ADOQuery1.SQL.Add('Insert into Pontuacao' +
    ' (ID_Professor, ID_Jogo, Nome_Aluno, Numero_Aluno' +
    ', Serie_Aluno, Pontuacao, Data)' +
    ' Values (1, 1,'''+name+''','''+numero_aluno+''','''+serie_aluno+''','+inttostr(point)+','+ datetostr(date)+')');
           //Values (:A, :B, :C, :D, :E, :F, :G)');
    DataModule1.ADOQuery1.ExecSQL();
   // É ESSA LINHAA
   end;





  end;

  procedure TEletronicDistribution.DisposeSelect;
  begin
    PopUp.Visible := False;
    ToChoose.Enabled := False;
    ToConfirm.Enabled := False;
  end;

  procedure TEletronicDistribution.ElementClick(Sender: TObject);
  begin
    Play_Decision(3);
    WindowPropertie := TWindowPropertie.Create(Self);
    WindowPropertie.WentFromGame( ElementRand );
    WindowPropertie.Show;
  end;

procedure TEletronicDistribution.GameBegins(TLevel: Byte);
  var Index, I, J, K : Byte;
  begin
    Level := TLevel;
    Index := 0;
    while Index = 0 do
      case Level of
      1: begin Index := Random(30);  K := 20; end;
      2: begin Index := Random(60);  K := 5;  end;
      3: begin Index := Random(90);  K := 3;  end;
      end;

    ElementRand := Index;
    Number.Caption  := IntToStr(Index);
    Element.Caption := Elemento[Index].Get_Elemento(2);
    CountTime.Enabled := True;

    for I := 1 to 19 do

      if Index - SubNiveis[I] >= 0 then
      begin
        Niveis[I].Caption := Niveis[I].Caption + IntToStr(SubNiveis[I]);
        Niveis[I].Visible := True;
        Niveis[I].Enabled := True;
        Index := Index - SubNiveis[I];
      end
      else if Index > 0 then
      begin
        Niveis[I].Caption := Niveis[I].Caption + IntToStr(Index);
        Niveis[I].Visible := True;
        Niveis[I].Enabled := True;
        Index := 0;
      end
      else
      begin
        if ( Random(K) = 1 ) then
        begin
          J := 0;
          while J = 0 do
            J := Random(SubNiveis[I]);
          Niveis[I].Caption := Niveis[I].Caption + IntToStr(J);
          Niveis[I].Visible := True;
          Niveis[I].Enabled := True;
        end

      end;

  end;

  procedure TEletronicDistribution.Img_dificilClick(Sender: TObject);
begin
 Play_Decision(1);
        GameBegins( Cursor );
        Table.Enabled := True;
        DisposeSelect;
          img_dificil.Enabled := false;
          img_facil.Enabled := false;
          img_medio.Enabled := false;
end;

procedure TEletronicDistribution.Img_dificilMouseEnter(Sender: TObject);
begin
if popup.Visible then
begin;
Img_dificil.Enabled;
end;
cursor :=3;
ChangePicture();
end;

procedure TEletronicDistribution.Img_facilClick(Sender: TObject);
begin

      Play_Decision(1);
        GameBegins( Cursor );
        Table.Enabled := True;
        DisposeSelect;
          img_dificil.Enabled := false;
          img_facil.Enabled := false;
          img_medio.Enabled := false;

end;

procedure TEletronicDistribution.Img_facilMouseEnter(Sender: TObject);
begin
if popup.Visible then
begin;
Img_facil.Enabled;
end;
cursor :=1;
ChangePicture();
end;

procedure TEletronicDistribution.Img_medioClick(Sender: TObject);
begin
 Play_Decision(1);
        GameBegins( Cursor );
        Table.Enabled := True;
        DisposeSelect;
           img_dificil.Enabled := false;
          img_facil.Enabled := false;
          img_medio.Enabled := false;

end;

procedure TEletronicDistribution.Img_medioMouseEnter(Sender: TObject);
begin
if popup.Visible then
begin;
Img_medio.Enabled;
end;
cursor :=2;
ChangePicture();
end;

procedure TEletronicDistribution.JogarNovamenteClick(Sender: TObject);
 var i: integer;
begin
lbl_status.Visible:= false;
btn_manual.Visible := false;
btn_manual.enabled := false;
      I := Level;
      if Self <> Nil then
      begin
        FreeAndNil(EletronicDistribution);
        EletronicDistribution := TEletronicDistribution.Create(Application);
      end;
      PopUp.Visible := False;
      Cursor := 1;
      Points.Caption := '1000';
      Table.Enabled := True;
      Self.Show;
      GameBegins( I );

end;

procedure TEletronicDistribution.JogarNovamenteMouseEnter(Sender: TObject);
begin
JogarNovamente.Picture.LoadFromFile('Graphics/Button/jogar_novamente_on.png');
end;

procedure TEletronicDistribution.JogarNovamenteMouseLeave(Sender: TObject);
begin
JogarNovamente.Picture.LoadFromFile('Graphics/Button/jogar_novamente.png');
end;

procedure TEletronicDistribution.FastTimerTimer(Sender: TObject);
begin
if point= 0 then begin;
lbl_status.Caption:='Você não foi bem... Se tiver dúvidas acesse o manual :)';
  lbl_status.Visible:= true;
btn_manual.Visible := true;
btn_manual.enabled := true;
  popup2.visible := true;
  popup2.Enabled := true;
   JogarNovamente.visible := true;
Sair.visible := true;
JogarNovamente.Enabled := true;
Sair.Enabled:= true;
lbl_points.Visible:=true;
Fasttimer.Enabled:=false;
end;

end;

procedure TEletronicDistribution.FinishPress;
  begin
    ClipCursor(Nil);
    SetDirection();
    MouseActive := 0;

  end;

  procedure TEletronicDistribution.Back(Index: Byte);
  var I : Byte;
  begin
    for I := Index to Count do
      Inside[I] := Inside[I + 1];

  end;
  procedure TEletronicDistribution.SetDirection;
  var I : Byte;
  begin
    Answer := '';
    if Count > 0 then
      for I := 1 to Count do
      begin
        if ( I > 1 ) then
        begin
          if ( Length(Inside[I - 1].Caption) > 3 ) then
            Inside[I].Left := Inside[I - 1].Left + 55
          else
            Inside[I].Left := Inside[I - 1].Left + 45;
        end
        else
          Inside[I].Left := 130;
        Answer := Answer + Inside[I].Caption + ' ';
      end;
    if Answer = Elemento[ElementRand].Get_Elemento(12) then
      ShowResult( true );
          Play_Move();
  end;

  procedure TEletronicDistribution.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);
end;

//------------------------------------------------------------------------------
// * Altera a imagem de desistência
//    Kind : Opção
//------------------------------------------------------------------------------
procedure TEletronicDistribution.Change_Forfeit_Picture();
begin
  Sound.Play_Cursor(1);
  With Forfeit.Picture do
    LoadFromFile('Graphics/System/Forfeit_' + IntToStr(Forfeit_Cursor) + '.png');
end;

procedure TEletronicDistribution.FormCreate(Sender: TObject);
  var
  I: Integer;
  begin

  lbl_status.Visible:= false;
btn_manual.Visible := false;
btn_manual.enabled := false;
  popup2.visible := false;
  popup2.Enabled := false;
   JogarNovamente.visible := false;
Sair.visible := false;
JogarNovamente.Enabled := false;
Sair.Enabled:= false;


    Niveis[1]  := _1s;
    Niveis[2]  := _2s;
    Niveis[3]  := _2p;
    Niveis[4]  := _3s;
    Niveis[5]  := _3p;
    Niveis[6]  := _4s;
    Niveis[7]  := _3d;
    Niveis[8]  := _4p;
    Niveis[9]  := _5s;
    Niveis[10] := _4d;
    Niveis[11] := _5p;
    Niveis[12] := _6s;
    Niveis[13] := _4f;
    Niveis[14] := _5d;
    Niveis[15] := _6p;
    Niveis[16] := _7s;
    Niveis[17] := _5f;
    Niveis[18] := _6d;
    Niveis[19] := _7p;

    for I := 1 to 19 do
    begin
      Niveis[I].Enabled := false;
      Niveis[I].Visible := false;
    end;

    MouseActive := 0;
    Cursor := 1;

    PerformForm(Self);

    for I := 1 to 19 do
      Inside[I] := TLabel.Create(Inside[I]);

    With PopUp do
    begin
      Left := ( Self.Width  div 2 ) - ( Width  div 2 );
      Top  := ( Self.Height div 2 ) - ( Height div 2 );
    end;

    With ToChoose do
      Enabled := False;

    With ToConfirm do
      Enabled := False;

    With Points do
      Caption := IntToStr(Point);

    With Tempo do
      Caption := '00:00';

    With Table do
      Enabled := False;

    Scene := 'InGame';
    Second := 0;
    Minute := 0;
    ElementRand := 0;
    Point := 1000;
    for I := 1 to 19 do
      Inside[I] := TLabel.Create(Inside[I]);
    Count := 0;
    WinCoun := 0;

  end;

procedure TEletronicDistribution.FormHide(Sender: TObject);
begin

MusicLenght := MediaPlayer1.Position;
With MediaPlayer1 do
begin
close;

end;
end;

procedure TEletronicDistribution.FormShow(Sender: TObject);
begin
with MediaPlayer1 do
begin
 StartPos := MusicLenght;
 open;
 play;
     end;


end;

procedure TEletronicDistribution.TableClick(Sender: TObject);
  begin
    PeriodicTable := TPeriodicTable.Create(Self);
    Play_Decision(1);
    Tabela.PeriodicTable.Show;
    Tabela.PeriodicTable.Enabled := true;
    Tabela.PeriodicTable.Visible := true;
    Tabela.PeriodicTable.ActiveForm := true;
    Tabela.PeriodicTable.CursorIndex := Tabela.PeriodicTable.SaveCursorIndex;
    Tabela.WhereTo := 1;
    EletronicDistribution.Hide();
  end;

  procedure TEletronicDistribution.ToChooseTimer(Sender: TObject);
  begin

    if Windows.GetAsyncKeyState(VK_DOWN) <> 0 then
    begin
      Play_Cursor(1);
      if Cursor < 3 then
        Cursor := Cursor + 1
      else
        Cursor := 1;
      ChangePicture();
    end
    else if Windows.GetAsyncKeyState(VK_UP) <> 0 then
    begin
      Play_Cursor(1);
      if Cursor > 1 then
        Cursor := Cursor - 1
      else
        Cursor := 3;
      ChangePicture();
    end;


  end;

procedure TEletronicDistribution.btn_ManualClick(Sender: TObject);
begin
Inicio := TInicio.Create(Application);
          // Exibe o formulário
          inicio.mode:=5;
          inicio.Cursor:=1;

          Inicio.Show();


          // Deleta a instância e chama o Garbage Collector
          FreeAndNil(Self);
end;

procedure TEletronicDistribution.btn_ManualMouseEnter(Sender: TObject);
begin
btn_manual.Picture.LoadFromFile('Graphics/Button/Manual_on.png');
end;

procedure TEletronicDistribution.btn_ManualMouseLeave(Sender: TObject);
begin
btn_manual.Picture.LoadFromFile('Graphics/Button/Manual.png');
end;

procedure TEletronicDistribution.ChangePicture();
  begin
  if Scene = 'InGame' then
    case Cursor of
    1: PopUp.Picture.LoadFromFile('Graphics/Dificuldade/Facil.png');
    2: PopUp.Picture.LoadFromFile('Graphics/Dificuldade/Medio.png');
    3: PopUp.Picture.LoadFromFile('Graphics/Dificuldade/Dificil.png');
    end
  else if Scene = 'Menu' then
    case Cursor of
    1: PopUp.Picture.LoadFromFile('Graphics/Distribuição/Escolha/Retry.png');
    2: PopUp.Picture.LoadFromFile('Graphics/Distribuição/Escolha/Choose.png');
    3: PopUp.Picture.LoadFromFile('Graphics/Distribuição/Escolha/Other.png');
    end;


  end;

  procedure TEletronicDistribution.CountTimeTimer(Sender: TObject);
  begin
    UpdateTime();
  end;

procedure TEletronicDistribution.MoveLabelTimer(Sender: TObject);
  var I : Byte;
  begin
    if MouseActive <> 0 then
    begin
      Niveis[MouseActive].Left := Mouse.CursorPos.X - 10;
      Niveis[MouseActive].Top  := Mouse.CursorPos.Y - 10;
      if Dir = 1 then
      begin
        Table.Picture.LoadFromFile('Graphics/Distribuição/TableDark.png');
        BackGround.Picture.LoadFromFile('Graphics/Distribuição/AllDark.jpg');
        Dir := 2;
      end;
    end
    else
      if Dir = 2 then
      begin
        Table.Picture.LoadFromFile('Graphics/Distribuição/Table.png');
        BackGround.Picture.LoadFromFile('Graphics/Distribuição/All.jpg');
        Dir := 1;
      end;
  end;

  procedure TEletronicDistribution.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  // Se a tela de desistência estiver visível
  if Forfeit.Visible then
  begin
    // Se a seta direita for pressionada
    if Key = VK_Right then
    begin
      case Forfeit_Cursor of
      1: Forfeit_Cursor := 2;
      2: Forfeit_Cursor := 1;
      end;
      // Altera a imagem
      Change_Forfeit_Picture();
    end

    // Se a seta esquerda for pressionada
    else if Key = VK_Left then
    begin
      case Forfeit_Cursor of
      1: Forfeit_Cursor := 2;
      2: Forfeit_Cursor := 1;
      end;
      // Altera a imagem
      Change_Forfeit_Picture();
    end

    // Se a tecla escape for pressionada
    else if Key = VK_ESCAPE then
    begin
      // Invisibiliza a janela de escolhas
      Forfeit.Visible   := False;
      Cursor := 1;
      Change_Forfeit_Picture();
      // Regulariza o tempo
      CountTime.Enabled := True;
    end

    // Se a tecla Enter for pressionada
    else if Key = VK_Return then
    begin
      Sound.Play_Decision(1);
      // Se continuar no jogo foi selecionado
      if Forfeit_Cursor = 1 then
      begin
        // Invisibiliza a janela de escolhas
        Forfeit.Visible   := False;
        // Regulariza o tempo
        CountTime.Enabled := True;
      end
      // Se a opção de desistir foi selecionada
      else if Forfeit_Cursor = 2 then
      begin
        ToChoose.Enabled := false;
        ToConfirm.Enabled := false;
        Inicio := TInicio.Create(Application);
        Inicio.FormCreate(Application);
        Inicio.Show();
        Cursor := 1;
        Table.Enabled := true;
        FreeAndNil(Self);
      end;

    end;
  end;
end;

procedure TEletronicDistribution.OnKeyPress(Sender: TObject; var Key: Char);
begin
  // Se a tecla escape for pressionada
  if Key = #27 then
  begin
    Sound.Play_Cancel;
    if Forfeit.Visible then
    begin
      Cursor := 1;
      Change_Forfeit_Picture;
    end;
    // Torna a imagem de escolha de desistência visível
    Forfeit.Visible := True;
    // Reseta o cursor
    Forfeit_Cursor := 1;
    // Paraliza o tempo
    CountTime.Enabled := False;
  end;

  if ( Key = #13 ) and ( ToConfirm.Enabled ) then
    begin
      Play_Decision(1);
      if Scene = 'InGame' then
      begin
        GameBegins( Cursor );
        Table.Enabled := True;
        DisposeSelect;
      end
      else if Scene = 'Menu' then
        SelectChoice( Cursor );
    end;
end;

procedure TEletronicDistribution._TableOnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin
    ButtonPressing := True;
    Table.Picture.LoadFromFile('Graphics/Distribuição/Table_2.png');
  end;

procedure TEletronicDistribution._TableOnMouseEnter(Sender: TObject);
  begin
    if not ButtonPressing then
      Table.Picture.LoadFromFile('Graphics/Distribuição/Table_1.png');
  end;

  procedure TEletronicDistribution._TableOnMouseLeave(Sender: TObject);
  begin
    if not ButtonPressing then
      Table.Picture.LoadFromFile('Graphics/Distribuição/Table.png');
  end;

  procedure TEletronicDistribution._TableOnMouseUp(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin
    ButtonPressing := False;
    Table.Picture.LoadFromFile('Graphics/Distribuição/Table.png');
  end;

  procedure TEletronicDistribution.___1sOnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var A : Boolean;
      I : Byte;
      R : TRect;
  begin
    for I := 1 to 19 do
    begin
      a := Sender.Equals(Niveis[I]);
      if a then
        MouseActive := I;
    end;
    R.Left   := 105;
    R.Right  := 880;
    R.Top    := 236;
    R.Bottom := 607;
    ClipCursor(@R);
  end;

  procedure TEletronicDistribution.__1sOnMouseUp(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    var I, J : Integer;
        T : Boolean;
  begin
    I := Niveis[MouseActive].Left;
    J := Niveis[MouseActive].Top;
    if ( I > 120 ) and ( I < 880 ) and ( J > 540 ) and ( J < 620 ) then
    begin
      for I := 1 to 19 do
        if Inside[I].Caption = '' then
        begin
          Niveis[MouseActive].Top := 570;
          Inside[I] := Niveis[MouseActive];
          Count := Count + 1;
          FinishPress();
          Exit();
        end
        else
          if Inside[I].Equals(Niveis[MouseActive]) then
          begin
            Niveis[MouseActive].Top := 570;
            FinishPress();
            Exit();
          end;
    end
    else
    begin
      for I := 1 to 19 do
        if Inside[I].Equals(Niveis[MouseActive]) then
        begin
          Inside[I] := TLabel.Create(Inside[I]);
          Back(I);
          Count := Count - 1;
          RemovePoints( Level * 50 );
          FinishPress();
          Exit();
        end

    end;
    FinishPress();
  end;

end.
