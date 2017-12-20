unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, pngimage, ExtCtrls;

type
  TInstall2 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Image2: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Install2: TInstall2;

implementation

uses Unit1;

{$R *.dfm}

end.
