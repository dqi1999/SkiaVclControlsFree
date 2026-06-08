unit SkiaVclControls.LabelControl;

interface

uses
  System.Classes, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  { TDSkLabel - Skia绘制的透明标签组件
    支持透明背景、主题色、自动大小、渐变、描边和阴影 }
  TDSkLabel = class(TDSCustomSkControl)
  private
    FCaption: string;
    FFont: TFont;
    FAutoSize: Boolean;
    FColorScheme: TDSkMUIColorScheme;
    FFontColor: TAlphaColor;
    FTextEffect: TDSkLabelTextEffect;
    FGradientStartColor: TAlphaColor;
    FGradientEndColor: TAlphaColor;
    FGradientDirection: TDSkLabelGradientDirection;
    FFillEnabled: Boolean;
    FStrokeEnabled: Boolean;
    FStrokeColor: TAlphaColor;
    FStrokeWidth: Single;
    FShadowEnabled: Boolean;
    FShadowColor: TAlphaColor;
    FShadowBlur: Single;
    FShadowOffsetX: Single;
    FShadowOffsetY: Single;
    FTextAlign: TDSkLabelTextAlign;
    FVerticalAlign: TDSkLabelVerticalAlign;
    FTextCacheFont: ISkFont;
    FTextCacheTypeface: ISkTypeface;
    FTextCacheFontName: string;
    FTextCacheFontStyle: TFontStyles;
    FTextCacheFontSize: Single;
    FTextCachePPI: Integer;
    procedure SetCaption(const Value: string);
    procedure SetFont(Value: TFont);
    procedure SetAutoSize(Value: Boolean);
    procedure SetColorScheme(Value: TDSkMUIColorScheme);
    procedure SetFontColor(Value: TAlphaColor);
    procedure SetTextEffect(Value: TDSkLabelTextEffect);
    procedure SetGradientStartColor(Value: TAlphaColor);
    procedure SetGradientEndColor(Value: TAlphaColor);
    procedure SetGradientDirection(Value: TDSkLabelGradientDirection);
    procedure SetFillEnabled(Value: Boolean);
    procedure SetStrokeEnabled(Value: Boolean);
    procedure SetStrokeColor(Value: TAlphaColor);
    procedure SetStrokeWidth(Value: Single);
    procedure SetShadowEnabled(Value: Boolean);
    procedure SetShadowColor(Value: TAlphaColor);
    procedure SetShadowBlur(Value: Single);
    procedure SetShadowOffsetX(Value: Single);
    procedure SetShadowOffsetY(Value: Single);
    procedure SetTextAlign(Value: TDSkLabelTextAlign);
    procedure SetVerticalAlign(Value: TDSkLabelVerticalAlign);
    procedure FontChanged(Sender: TObject);
    procedure InvalidateTextCache;
    procedure VisualChanged(AAffectsSize: Boolean = False);
    function ApplyOpacityToColor(AColor: TAlphaColor; AOpacity: Single): TAlphaColor;
    function GetEffectiveTextColor: TAlphaColor;
    function GetEffectPadding: Single;
    function GetTextFont: ISkFont;
    function MeasureTextSize: TSize;
    procedure CalculateTextOrigin(const ADest: TRectF; const AFont: ISkFont;
      const AMetrics: TSkFontMetrics; out AX, AY: Single; out ATextRect: TRectF);
    function CreateGradientShader(const ATextRect: TRectF; const AOpacity: Single): ISkShader;
    procedure DrawTextLayer(const ACanvas: ISkCanvas; const AText: string;
      const AX, AY: Single; const AFont: ISkFont; const APaint: ISkPaint);
    procedure UpdateSize;
  protected
    procedure Loaded; override;
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    function ShouldClipWindowRegion: Boolean; override;
    function DependsOnParentBackground: Boolean; override;
    function DependsOnParentVisualBackground: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption: string read FCaption write SetCaption;
    property Font: TFont read FFont write SetFont;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default True;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property FontColor: TAlphaColor read FFontColor write SetFontColor;
    property TextEffect: TDSkLabelTextEffect read FTextEffect write SetTextEffect default lteSolid;
    property GradientStartColor: TAlphaColor read FGradientStartColor write SetGradientStartColor;
    property GradientEndColor: TAlphaColor read FGradientEndColor write SetGradientEndColor;
    property GradientDirection: TDSkLabelGradientDirection read FGradientDirection write SetGradientDirection default lgdHorizontal;
    property FillEnabled: Boolean read FFillEnabled write SetFillEnabled default True;
    property StrokeEnabled: Boolean read FStrokeEnabled write SetStrokeEnabled default False;
    property StrokeColor: TAlphaColor read FStrokeColor write SetStrokeColor;
    property StrokeWidth: Single read FStrokeWidth write SetStrokeWidth;
    property ShadowEnabled: Boolean read FShadowEnabled write SetShadowEnabled default False;
    property ShadowColor: TAlphaColor read FShadowColor write SetShadowColor;
    property ShadowBlur: Single read FShadowBlur write SetShadowBlur;
    property ShadowOffsetX: Single read FShadowOffsetX write SetShadowOffsetX;
    property ShadowOffsetY: Single read FShadowOffsetY write SetShadowOffsetY;
    property TextAlign: TDSkLabelTextAlign read FTextAlign write SetTextAlign default ltaCenter;
    property VerticalAlign: TDSkLabelVerticalAlign read FVerticalAlign write SetVerticalAlign default lvaCenter;
    property CornerRadius stored IsCornerRadiusStored;
    property BackgroundColor;
    property BorderColor;
    property BorderWidth;
    property OnClick;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

implementation

function AlphaColorToTColor(AColor: TAlphaColor): TColor;
begin
  Result := ((AColor shr 16) and $FF) or (AColor and $FF00) or ((AColor and $FF) shl 16);
end;

{ TDSkLabel }

constructor TDSkLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaption := 'Label';
  FAutoSize := True;
  FColorScheme := muiPrimary;
  FFontColor := TAlphaColors.Null; // 使用Null表示自动根据ColorScheme计算
  FTextEffect := lteSolid;
  FGradientStartColor := $FF1976D2;
  FGradientEndColor := $FF42A5F5;
  FGradientDirection := lgdHorizontal;
  FFillEnabled := True;
  FStrokeEnabled := False;
  FStrokeColor := $FFFFFFFF;
  FStrokeWidth := 1;
  FShadowEnabled := False;
  FShadowColor := $60000000;
  FShadowBlur := 4;
  FShadowOffsetX := 0;
  FShadowOffsetY := 2;
  FTextAlign := ltaCenter;
  FVerticalAlign := lvaCenter;

  FFont := TFont.Create;
  FFont.Name := GetDefaultFontName;
  FFont.Size := 10;
  FFont.Color := clBlack;
  FFont.OnChange := FontChanged;

  InvalidateTextCache;

  // 默认透明背景
  CornerRadius := 0;
  BackgroundColor := TAlphaColors.Null;
  BorderColor := TAlphaColors.Null;
  BorderWidth := 0;

  Width := 50;
  Height := 20;
end;

destructor TDSkLabel.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TDSkLabel.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    if FAutoSize and not (csLoading in ComponentState) then
      UpdateSize;
    if CanRedrawNow then
      Redraw;
  end;
end;

procedure TDSkLabel.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  InvalidateTextCache;
  if FAutoSize and not (csLoading in ComponentState) then
    UpdateSize;
  if CanRedrawNow then
    Redraw;
end;

procedure TDSkLabel.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    if Value and not (csLoading in ComponentState) then
      UpdateSize;
  end;
end;

procedure TDSkLabel.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then
  begin
    FColorScheme := Value;
    if CanRedrawNow then
      Redraw;
  end;
end;

procedure TDSkLabel.SetFontColor(Value: TAlphaColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    if CanRedrawNow then
      Redraw;
  end;
end;

procedure TDSkLabel.SetTextEffect(Value: TDSkLabelTextEffect);
begin
  if FTextEffect <> Value then
  begin
    FTextEffect := Value;
    VisualChanged(False);
  end;
end;

procedure TDSkLabel.SetGradientStartColor(Value: TAlphaColor);
begin
  if FGradientStartColor <> Value then
  begin
    FGradientStartColor := Value;
    VisualChanged(False);
  end;
end;

procedure TDSkLabel.SetGradientEndColor(Value: TAlphaColor);
begin
  if FGradientEndColor <> Value then
  begin
    FGradientEndColor := Value;
    VisualChanged(False);
  end;
end;

procedure TDSkLabel.SetGradientDirection(Value: TDSkLabelGradientDirection);
begin
  if FGradientDirection <> Value then
  begin
    FGradientDirection := Value;
    VisualChanged(False);
  end;
end;

procedure TDSkLabel.SetFillEnabled(Value: Boolean);
begin
  if FFillEnabled <> Value then
  begin
    FFillEnabled := Value;
    VisualChanged(False);
  end;
end;

procedure TDSkLabel.SetStrokeEnabled(Value: Boolean);
begin
  if FStrokeEnabled <> Value then
  begin
    FStrokeEnabled := Value;
    VisualChanged(True);
  end;
end;

procedure TDSkLabel.SetStrokeColor(Value: TAlphaColor);
begin
  if FStrokeColor <> Value then
  begin
    FStrokeColor := Value;
    VisualChanged(False);
  end;
end;

procedure TDSkLabel.SetStrokeWidth(Value: Single);
begin
  Value := Max(0, Value);
  if not SameValue(FStrokeWidth, Value) then
  begin
    FStrokeWidth := Value;
    VisualChanged(True);
  end;
end;

procedure TDSkLabel.SetShadowEnabled(Value: Boolean);
begin
  if FShadowEnabled <> Value then
  begin
    FShadowEnabled := Value;
    VisualChanged(True);
  end;
end;

procedure TDSkLabel.SetShadowColor(Value: TAlphaColor);
begin
  if FShadowColor <> Value then
  begin
    FShadowColor := Value;
    VisualChanged(False);
  end;
end;

procedure TDSkLabel.SetShadowBlur(Value: Single);
begin
  Value := Max(0, Value);
  if not SameValue(FShadowBlur, Value) then
  begin
    FShadowBlur := Value;
    VisualChanged(True);
  end;
end;

procedure TDSkLabel.SetShadowOffsetX(Value: Single);
begin
  if not SameValue(FShadowOffsetX, Value) then
  begin
    FShadowOffsetX := Value;
    VisualChanged(True);
  end;
end;

procedure TDSkLabel.SetShadowOffsetY(Value: Single);
begin
  if not SameValue(FShadowOffsetY, Value) then
  begin
    FShadowOffsetY := Value;
    VisualChanged(True);
  end;
end;

procedure TDSkLabel.SetTextAlign(Value: TDSkLabelTextAlign);
begin
  if FTextAlign <> Value then
  begin
    FTextAlign := Value;
    VisualChanged(False);
  end;
end;

procedure TDSkLabel.SetVerticalAlign(Value: TDSkLabelVerticalAlign);
begin
  if FVerticalAlign <> Value then
  begin
    FVerticalAlign := Value;
    VisualChanged(False);
  end;
end;

procedure TDSkLabel.FontChanged(Sender: TObject);
begin
  InvalidateTextCache;
  if FAutoSize and not (csLoading in ComponentState) then
    UpdateSize;
  if CanRedrawNow then
    Redraw;
end;

procedure TDSkLabel.Loaded;
begin
  inherited;
  if FAutoSize then
    UpdateSize;
  if CanRedrawNow then
    Redraw;
end;

procedure TDSkLabel.InvalidateTextCache;
begin
  FTextCacheFont := nil;
  FTextCacheTypeface := nil;
  FTextCacheFontName := '';
  FTextCacheFontStyle := [];
  FTextCacheFontSize := -1;
  FTextCachePPI := 0;
end;

procedure TDSkLabel.VisualChanged(AAffectsSize: Boolean);
begin
  if AAffectsSize and FAutoSize then
    UpdateSize;
  if CanRedrawNow then
    Redraw;
end;

function TDSkLabel.ApplyOpacityToColor(AColor: TAlphaColor; AOpacity: Single): TAlphaColor;
var
  LColorRec: TAlphaColorRec;
begin
  if AOpacity >= 1.0 then
    Exit(AColor);

  LColorRec := TAlphaColorRec(AColor);
  LColorRec.A := Round(LColorRec.A * EnsureRange(AOpacity, 0.0, 1.0));
  Result := TAlphaColor(LColorRec);
end;

function TDSkLabel.GetEffectiveTextColor: TAlphaColor;
begin
  if (not Enabled) or IsParentDisabled then
    Result := $FFBDBDBD
  else if FFontColor <> TAlphaColors.Null then
    Result := FFontColor
  else
  begin
    case FColorScheme of
      muiSecondary: Result := $FF9C27B0;
      muiError: Result := $FFD32F2F;
      muiWarning: Result := $FFED6C02;
      muiInfo: Result := $FF0288D1;
      muiSuccess: Result := $FF2E7D32;
      muiSchemeNone: Result := VclColorToAlphaColor(FFont.Color);
    else
      Result := $FF1976D2; // Primary
    end;
  end;
end;

function TDSkLabel.GetEffectPadding: Single;
var
  LShadowExtra: Single;
  LStrokeExtra: Single;
begin
  LStrokeExtra := 0;
  if FStrokeEnabled and (FStrokeWidth > 0) then
    LStrokeExtra := FStrokeWidth * DpiScale;

  LShadowExtra := 0;
  if FShadowEnabled then
    LShadowExtra := Max(Abs(FShadowOffsetX * DpiScale), Abs(FShadowOffsetY * DpiScale)) +
      (FShadowBlur * DpiScale);

  Result := Ceil(Max(LStrokeExtra, LShadowExtra) + DpiScaleValue(1));
end;

function TDSkLabel.GetTextFont: ISkFont;
var
  LFontStyle: TSkFontStyle;
  LPPI: Integer;
  LFontSize: Single;
begin
  LPPI := GetEffectivePPI;
  LFontSize := FontSizeToPixels(FFont);
  if (fsBold in FFont.Style) and (fsItalic in FFont.Style) then
    LFontStyle := TSkFontStyle.BoldItalic
  else if fsBold in FFont.Style then
    LFontStyle := TSkFontStyle.Bold
  else if fsItalic in FFont.Style then
    LFontStyle := TSkFontStyle.Italic
  else
    LFontStyle := TSkFontStyle.Normal;

  if (FTextCacheFont = nil) or (FTextCachePPI <> LPPI) or
    (FTextCacheFontName <> FFont.Name) or (FTextCacheFontStyle <> FFont.Style) or
    not SameValue(FTextCacheFontSize, LFontSize) then
  begin
    FTextCacheTypeface := TSkTypeface.MakeFromName(FFont.Name, LFontStyle);
    FTextCacheFont := TSkFont.Create(FTextCacheTypeface, LFontSize);
    FTextCacheFontName := FFont.Name;
    FTextCacheFontStyle := FFont.Style;
    FTextCacheFontSize := LFontSize;
    FTextCachePPI := LPPI;
  end;
  Result := FTextCacheFont;
end;

function TDSkLabel.MeasureTextSize: TSize;
var
  LFont: ISkFont;
  LTextBounds: TRectF;
  LMetrics: TSkFontMetrics;
  LPadding: Single;
begin
  LFont := GetTextFont;
  LTextBounds := RectF(0, 0, 0, 0);
  LFont.MeasureText(FCaption, LTextBounds);
  LFont.GetMetrics(LMetrics);

  if (LTextBounds.Width <= 0) or (LTextBounds.Height <= 0) then
    LTextBounds := RectF(0, LMetrics.Ascent, LFont.MeasureText(FCaption), LMetrics.Descent);

  LPadding := GetEffectPadding;
  Result.cx := Ceil(LTextBounds.Width + LPadding * 2);
  Result.cy := Ceil(LTextBounds.Height + LPadding * 2);
end;

procedure TDSkLabel.CalculateTextOrigin(const ADest: TRectF; const AFont: ISkFont;
  const AMetrics: TSkFontMetrics; out AX, AY: Single; out ATextRect: TRectF);
var
  LBounds: TRectF;
  LTextBounds: TRectF;
  LTextWidth: Single;
  LTextHeight: Single;
  LPadding: Single;
begin
  LPadding := GetEffectPadding;
  LBounds := ADest;
  LBounds.Inflate(-LPadding, -LPadding);

  LTextBounds := RectF(0, 0, 0, 0);
  AFont.MeasureText(FCaption, LTextBounds);
  if (LTextBounds.Width <= 0) or (LTextBounds.Height <= 0) then
    LTextBounds := RectF(0, AMetrics.Ascent, AFont.MeasureText(FCaption), AMetrics.Descent);

  LTextWidth := LTextBounds.Width;
  LTextHeight := LTextBounds.Height;

  case FTextAlign of
    ltaLeft:
      AX := LBounds.Left - LTextBounds.Left;
    ltaRight:
      AX := LBounds.Right - LTextBounds.Right;
  else
    AX := LBounds.Left + (LBounds.Width - LTextWidth) / 2 - LTextBounds.Left;
  end;

  case FVerticalAlign of
    lvaTop:
      AY := LBounds.Top - LTextBounds.Top;
    lvaBottom:
      AY := LBounds.Bottom - LTextBounds.Bottom;
  else
    AY := LBounds.Top + (LBounds.Height - LTextHeight) / 2 - LTextBounds.Top;
  end;

  ATextRect := RectF(AX + LTextBounds.Left, AY + LTextBounds.Top,
    AX + LTextBounds.Right, AY + LTextBounds.Bottom);
end;

function TDSkLabel.CreateGradientShader(const ATextRect: TRectF; const AOpacity: Single): ISkShader;
var
  LStart: TPointF;
  LEnd: TPointF;
begin
  case FGradientDirection of
    lgdVertical:
      begin
        LStart := PointF(ATextRect.Left, ATextRect.Top);
        LEnd := PointF(ATextRect.Left, ATextRect.Bottom);
      end;
    lgdDiagonalDown:
      begin
        LStart := PointF(ATextRect.Left, ATextRect.Top);
        LEnd := PointF(ATextRect.Right, ATextRect.Bottom);
      end;
    lgdDiagonalUp:
      begin
        LStart := PointF(ATextRect.Left, ATextRect.Bottom);
        LEnd := PointF(ATextRect.Right, ATextRect.Top);
      end;
  else
    LStart := PointF(ATextRect.Left, ATextRect.Top);
    LEnd := PointF(ATextRect.Right, ATextRect.Top);
  end;

  Result := TSkShader.MakeGradientLinear(LStart, LEnd,
    ApplyOpacityToColor(FGradientStartColor, AOpacity),
    ApplyOpacityToColor(FGradientEndColor, AOpacity),
    TSkTileMode.Clamp);
end;

procedure TDSkLabel.DrawTextLayer(const ACanvas: ISkCanvas; const AText: string;
  const AX, AY: Single; const AFont: ISkFont; const APaint: ISkPaint);
begin
  ACanvas.DrawSimpleText(AText, AX, AY, AFont, APaint);
end;

procedure TDSkLabel.UpdateSize;
var
  LSize: TSize;
begin
  if FCaption = '' then
  begin
    Width := 0;
    Height := 0;
    Exit;
  end;
  LSize := MeasureTextSize;
  Width := LSize.cx;
  Height := LSize.cy;
end;

procedure TDSkLabel.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
var
  LFont: ISkFont;
  LPaint: ISkPaint;
  LX, LY: Single;
  LTextRect: TRectF;
  LColor: TAlphaColor;
  LMetrics: TSkFontMetrics;
  LDisabled: Boolean;
begin
  if FCaption = '' then Exit;

  // 清除背景为透明
  ACanvas.Clear(TAlphaColors.Null);

  LFont := GetTextFont;
  LFont.GetMetrics(LMetrics);
  CalculateTextOrigin(ADest, LFont, LMetrics, LX, LY, LTextRect);
  LDisabled := (not Enabled) or IsParentDisabled;

  // 阴影先画在最底层，使用文字轮廓做模糊；描边和填充会覆盖在上面。
  if FShadowEnabled and (not LDisabled) then
  begin
    LPaint := TSkPaint.Create;
    LPaint.AntiAlias := True;
    LPaint.Style := TSkPaintStyle.Fill;
    LPaint.Color := ApplyOpacityToColor(FShadowColor, AOpacity);
    if FShadowBlur > 0 then
      LPaint.MaskFilter := TSkMaskFilter.MakeBlur(TSkBlurStyle.Normal, FShadowBlur * DpiScale);
    DrawTextLayer(ACanvas, FCaption, LX + FShadowOffsetX * DpiScale,
      LY + FShadowOffsetY * DpiScale, LFont, LPaint);
  end;

  if FStrokeEnabled and (FStrokeWidth > 0) then
  begin
    LPaint := TSkPaint.Create;
    LPaint.AntiAlias := True;
    LPaint.Style := TSkPaintStyle.Stroke;
    LPaint.StrokeWidth := FStrokeWidth * DpiScale;
    if LDisabled then
      LPaint.Color := ApplyOpacityToColor($FFBDBDBD, AOpacity)
    else
      LPaint.Color := ApplyOpacityToColor(FStrokeColor, AOpacity);
    DrawTextLayer(ACanvas, FCaption, LX, LY, LFont, LPaint);
  end;

  if FFillEnabled then
  begin
    LPaint := TSkPaint.Create;
    LPaint.AntiAlias := True;
    LPaint.Style := TSkPaintStyle.Fill;

    LColor := ApplyOpacityToColor(GetEffectiveTextColor, AOpacity);
    if (FTextEffect = lteGradient) and (not LDisabled) then
      LPaint.Shader := CreateGradientShader(LTextRect, AOpacity)
    else
      LPaint.Color := LColor;

    DrawTextLayer(ACanvas, FCaption, LX, LY, LFont, LPaint);
  end;
end;

function TDSkLabel.ShouldClipWindowRegion: Boolean;
begin
  Result := False;
end;

function TDSkLabel.DependsOnParentBackground: Boolean;
begin
  Result := True;
end;

function TDSkLabel.DependsOnParentVisualBackground: Boolean;
begin
  if Parent is TDSCustomSkControl then
    Result := TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack
  else
    Result := False;
end;

end.
