unit Pre_Ranking;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, ComCtrls, StdCtrls, Vcl.Imaging.jpeg;

type
  TPre_Rank = class(TForm)
    BackGround: TImage;
    Visualizar: TImage;
    Jogo: TComboBox;
    Serie: TComboBox;
    De: TDateTimePicker;
    Ate: TDateTimePicker;
    Image1: TImage;
    procedure OnCreate(Sender: TObject);
    procedure OnClose(Sender: TObject; var Action: TCloseAction);
    procedure OnMouseEnter(Sender: TObject);
    procedure SetPicture( Index : Byte );
    procedure OnMouseLeave(Sender: TObject);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnClick(Sender: TObject);
    procedure OnKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Pre_Rank: TPre_Rank;

implementation

uses DB_Integrator, Rank, Sound, Menu;

{$R *.dfm}

procedure TPre_Rank.OnClick(Sender: TObject);
begin
  if ( Jogo.ItemIndex > -1 ) and ( Serie.ItemIndex > -1 ) then
    if De.Date <= Ate.Date then
    begin
      Play_Decision(2);
      Ranking := TRanking.Create(Application);
      Ranking.SetConditions(Jogo.ItemIndex + 1, Serie.Text, De.Date, Ate.Date);
      Self.Hide();
      Ranking.Show();
    end
    else
    begin
      Sound.Play_Error;
      Application.MessageBox('A Data final deve ser inferior à data inicial',
                 'Ranking', MB_ICONWARNING  );
    end
  else
  begin
    Sound.Play_Error;
    Application.MessageBox('Preencha todos os campos', 'Ranking', MB_ICONWARNING  );
  end;
end;

procedure TPre_Rank.OnClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule1.DataModuleDestroy(Self);
end;

procedure TPre_Rank.OnCreate(Sender: TObject);
begin
  DB_Integrator.PerformForm(Self);
end;

procedure TPre_Rank.OnKeyPress(Sender: TObject; var Key: Char);
begin
  // Se a tecla Escape é pressionada
  if Key = #27 then
  begin
    Key := #0;
    Sound.Play_Cancel();
    // Fecha a janela
    if Ranking <> Nil then
      FreeAndNil(Ranking);
    inicio.Show();
    FreeAndNil(Self);
  end
end;

procedure TPre_Rank.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetPicture(3);
end;

procedure TPre_Rank.OnMouseEnter(Sender: TObject);
begin
  SetPicture(2);
end;

procedure TPre_Rank.OnMouseLeave(Sender: TObject);
begin
  SetPicture(1);
end;

procedure TPre_Rank.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetPicture(1);
end;

procedure TPre_RAnk.SetPicture(Index: Byte);
begin
  With Visualizar.Picture Do
    LoadFromFile('Graphics/Pontuações/Botão_' + IntToStr(Index) + '.png');
end;

end.
