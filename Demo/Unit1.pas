unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Skia.FMX, ScratchCard, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  FMX.StdCtrls, Skia;

type
  TForm2 = class(TForm)
    Layout1: TLayout;
    ScratchCard1: TScratchCard;
    Rectangle1: TRectangle;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.Button1Click(Sender: TObject);
begin
  ScratchCard1.Redraw;
end;

end.
