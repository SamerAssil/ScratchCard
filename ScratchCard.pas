unit ScratchCard;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.Surfaces,
  FMX.Graphics, FMX.Objects, Skia, Skia.FMX, System.Types, System.UITypes;

type
  TScratchCard = class( TSkPaintBox )
  private
    FPath: ISkPath;
    FPathBuilder: ISkPathBuilder;
    FBackgroundFilter: ISkImageFilter;
    img: ISkImage;
    FCodedStream: TMemoryStream;
    FBackground: TBitmap;
    FBlendMode: TSkBlendMode;
    FBrushSize: Integer;
    procedure SetBackground( const Value: TBitmap );
  protected
    procedure Draw( const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single ); override;
    procedure MouseMove( Shift: TShiftState; X: Single; Y: Single ); override;
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X: Single; Y: Single ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property Background: TBitmap read FBackground write SetBackground;
    property BrushSize: Integer read FBrushSize write FBrushSize default 10;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents( 'Tulip', [TScratchCard] );
end;

{ TScratchCard }

constructor TScratchCard.Create( AOwner: TComponent );
begin
  inherited;
  FBackground  := TBitmap.Create( trunc(Self.LocalRect.Width), trunc(Self.LocalRect.Height) );
  FCodedStream := TMemoryStream.Create;
  HitTest      := true;
  BrushSize := 10;
end;

destructor TScratchCard.Destroy;
begin
  FBackground.Free;
  FCodedStream.Free;
  inherited;
end;

procedure TScratchCard.Draw( const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single );
var
  LPaint: ISkPaint;
begin
  inherited;

  if Assigned( FPathBuilder ) then
  begin
    if not Assigned( FPath ) then
      FPath := FPathBuilder.Snapshot;

    LPaint           := TSkPaint.Create( TSkPaintStyle.Stroke );
    LPaint.AntiAlias := true;
    LPaint.Color     := TAlphaColorRec.black;

    LPaint.ImageFilter := TSkImageFilter.MakeBlend(
      TSkBlendMode.DestOut,
      FBackgroundFilter, Self.ClipRect
      );

    LPaint.MaskFilter := TSkMaskFilter.MakeBlur( TSkBlurStyle.Inner, BrushSize );

    LPaint.StrokeCap   := TSkStrokeCap.Round;
    LPaint.StrokeWidth := 40;
    LPaint.StrokeMiter := 10;

    LPaint.setPathEffect( TSkPathEffect.MakeCorner( 50 ) );

    ACanvas.DrawPath( FPath, LPaint );

  end else
    begin
      img := FBackground.ToSkImage;
      ACanvas.DrawImageRect(img, self.LocalRect, self.LocalRect);
    end;


end;

procedure TScratchCard.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Single );

begin
  inherited;
  if not Assigned( FPathBuilder ) then
    FPathBuilder := TSkPathBuilder.Create;
  FPathBuilder.MoveTo( X, Y );
  FPath := nil;

  if not Assigned( FBackground ) then
    exit;

    img := FBackground.ToSkImage;
  FBackgroundFilter     := TSkImageFilter.MakeImage(img);

end;

procedure TScratchCard.MouseMove( Shift: TShiftState; X, Y: Single );
begin
  inherited;
  if Pressed then
  begin
    FPath := nil;
    FPathBuilder.LineTo( X, Y );
    Redraw;
  end;
end;

procedure TScratchCard.SetBackground( const Value: TBitmap );
begin
  FBackground.Assign( Value );
end;


end.
