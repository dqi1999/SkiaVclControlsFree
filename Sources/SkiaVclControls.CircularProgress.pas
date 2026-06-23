unit SkiaVclControls.CircularProgress;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.ExtCtrls, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  { TDSkCircularProgress - MUI 风格环形进度条
    支持定量(Determinate)和不定量(Indeterminate)两种变体。
    参考 Material-UI CircularProgress 组件。 }
  TDSkCircularProgress = class(TDSCustomSkControl)
  private
    FMin: Single;
    FMax: Single;
    FValue: Single;
    FVariant: TDSkCircularProgressVariant;
    FColorScheme: TDSkMUIColorScheme;
    FProgressColor: TAlphaColor;    // 自定义颜色，Null 时使用 ColorScheme
    FTrackColor: TAlphaColor;       // 轨道背景色
    FCircleSize: Single;            // 圆环直径
    FThickness: Single;             // 线条粗细
    FShowLabel: Boolean;
    FFont: TFont;
    FValueLabelFormat: string;
    FOnChange: TNotifyEvent;
    // 不定量动画
    FAnimTimer: TTimer;
    FAnimProgress: Single;          // 0..1 循环动画进度
    // 字体缓存
    FTextCacheFont: ISkFont;
    FTextCacheTypeface: ISkTypeface;
    FTextCacheFontName: string;
    FTextCacheFontStyle: TFontStyles;
    FTextCacheFontSize: Single;
    FTextCachePPI: Integer;
    procedure RequestRedraw;
    procedure SetMin(Value: Single);
    procedure SetMax(Value: Single);
    procedure SetValue(Value: Single);
    procedure SetVariant(Value: TDSkCircularProgressVariant);
    procedure SetColorScheme(Value: TDSkMUIColorScheme);
    procedure SetProgressColor(Value: TAlphaColor);
    procedure SetTrackColor(Value: TAlphaColor);
    procedure SetCircleSize(Value: Single);
    procedure SetThickness(Value: Single);
    procedure SetShowLabel(Value: Boolean);
    procedure SetFont(Value: TFont);
    procedure SetValueLabelFormat(const Value: string);
    procedure FontChanged(Sender: TObject);
    procedure InvalidateTextCache;
    function GetTextFont: ISkFont;
    function GetActiveColor: TAlphaColor;
    function GetTrackBgColor: TAlphaColor;
    procedure ClampValue(var AValue: Single);
    procedure StartAnimation;
    procedure StopAnimation;
    procedure AnimTimerTick(Sender: TObject);
  protected
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawTrackCircle(const ACanvas: ISkCanvas; const ACenter: TPointF; ARadius: Single);
    procedure DrawProgressArc(const ACanvas: ISkCanvas; const ACenter: TPointF; ARadius: Single;
      AStartAngle, ASweepAngle: Single; AColor: TAlphaColor);
    procedure DrawDeterminate(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawIndeterminate(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawLabel(const ACanvas: ISkCanvas; const ADest: TRectF; const ACenter: TPointF);
    function DependsOnParentBackground: Boolean; override;
    function DependsOnParentVisualBackground: Boolean; override;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ShouldClipWindowRegion: Boolean; override;
  published
    property Min: Single read FMin write SetMin;
    property Max: Single read FMax write SetMax;
    property Value: Single read FValue write SetValue;
    property Variant: TDSkCircularProgressVariant read FVariant write SetVariant default cpvDeterminate;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property ProgressColor: TAlphaColor read FProgressColor write SetProgressColor;
    property TrackColor: TAlphaColor read FTrackColor write SetTrackColor;
    property CircleSize: Single read FCircleSize write SetCircleSize;
    property Thickness: Single read FThickness write SetThickness;
    property ShowLabel: Boolean read FShowLabel write SetShowLabel default False;
    property Font: TFont read FFont write SetFont;
    property ValueLabelFormat: string read FValueLabelFormat write SetValueLabelFormat;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property CornerRadius stored IsCornerRadiusStored;
    property BackgroundColor;
    property BorderColor;
    property BorderWidth;
    property OnClick;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

implementation

const
  DEFAULT_CIRCLE_SIZE = 40;
  DEFAULT_THICKNESS = 3.6;
  ANIM_INTERVAL = 16;  // ~60fps
  ANIM_SPEED = 0.012;  // 每帧递增量

{ TDSkCircularProgress }

constructor TDSkCircularProgress.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMin := 0;
  FMax := 100;
  FValue := 0;
  FVariant := cpvDeterminate;
  FColorScheme := muiPrimary;
  FProgressColor := TAlphaColors.Null;
  FTrackColor := TAlphaColors.Null;
  FCircleSize := DEFAULT_CIRCLE_SIZE;
  FThickness := DEFAULT_THICKNESS;
  FShowLabel := False;
  FFont := TFont.Create;
  FFont.Name := GetDefaultFontName;
  FFont.Size := 10;
  FFont.OnChange := FontChanged;
  FValueLabelFormat := '%.0f%%';
  FAnimProgress := 0;
  FAnimTimer := nil;
  InvalidateTextCache;
  Width := 48;
  Height := 48;
  TabStop := False;
  CornerRadius := 0;
  BackgroundColor := TAlphaColors.Null;
  BorderColor := TAlphaColors.Null;
  BorderWidth := 0;
end;

destructor TDSkCircularProgress.Destroy;
begin
  StopAnimation;
  FFont.Free;
  inherited;
end;

function TDSkCircularProgress.ShouldClipWindowRegion: Boolean;
begin
  Result := False;
end;

procedure TDSkCircularProgress.RequestRedraw;
begin
  if csLoading in ComponentState then Exit;
  Redraw;
end;

{ 属性设置器 }

procedure TDSkCircularProgress.SetMin(Value: Single);
begin
  if FMin <> Value then
  begin
    FMin := Value;
    if FMax < FMin then FMax := FMin;
    ClampValue(FValue);
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkCircularProgress.SetMax(Value: Single);
begin
  if FMax <> Value then
  begin
    FMax := Value;
    if FMin > FMax then FMin := FMax;
    ClampValue(FValue);
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkCircularProgress.SetValue(Value: Single);
begin
  ClampValue(Value);
  if FValue <> Value then
  begin
    FValue := Value;
    if not (csLoading in ComponentState) then
      RequestRedraw;
    if Assigned(FOnChange) and not (csLoading in ComponentState) and
      not (csDesigning in ComponentState) then
      FOnChange(Self);
  end;
end;

procedure TDSkCircularProgress.SetVariant(Value: TDSkCircularProgressVariant);
begin
  if FVariant <> Value then
  begin
    FVariant := Value;
    if Value = cpvIndeterminate then
      StartAnimation
    else
      StopAnimation;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkCircularProgress.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then
  begin
    FColorScheme := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkCircularProgress.SetProgressColor(Value: TAlphaColor);
begin
  if FProgressColor <> Value then
  begin
    FProgressColor := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkCircularProgress.SetTrackColor(Value: TAlphaColor);
begin
  if FTrackColor <> Value then
  begin
    FTrackColor := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkCircularProgress.SetCircleSize(Value: Single);
begin
  if not SameValue(FCircleSize, Value) then
  begin
    FCircleSize := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkCircularProgress.SetThickness(Value: Single);
begin
  if not SameValue(FThickness, Value) then
  begin
    FThickness := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkCircularProgress.SetShowLabel(Value: Boolean);
begin
  if FShowLabel <> Value then
  begin
    FShowLabel := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkCircularProgress.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  InvalidateTextCache;
  if not (csLoading in ComponentState) then RequestRedraw;
end;

procedure TDSkCircularProgress.SetValueLabelFormat(const Value: string);
begin
  if FValueLabelFormat <> Value then
  begin
    FValueLabelFormat := Value;
    if FShowLabel and not (csLoading in ComponentState) then
      RequestRedraw;
  end;
end;

procedure TDSkCircularProgress.FontChanged(Sender: TObject);
begin
  InvalidateTextCache;
  if FShowLabel and not (csLoading in ComponentState) then
    RequestRedraw;
end;

{ 字体缓存 }

procedure TDSkCircularProgress.InvalidateTextCache;
begin
  FTextCacheFont := nil;
  FTextCacheTypeface := nil;
  FTextCacheFontName := '';
  FTextCacheFontStyle := [];
  FTextCacheFontSize := -1;
  FTextCachePPI := 0;
end;

function TDSkCircularProgress.GetTextFont: ISkFont;
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

{ 颜色计算 }

function TDSkCircularProgress.GetActiveColor: TAlphaColor;
begin
  if not Enabled then
    Exit($FFBDBDBD);

  if FProgressColor <> TAlphaColors.Null then
    Exit(FProgressColor);

  case FColorScheme of
    muiSecondary: Result := $FF9C27B0;
    muiError:     Result := $FFD32F2F;
    muiWarning:   Result := $FFED6C02;
    muiInfo:      Result := $FF0288D1;
    muiSuccess:   Result := $FF2E7D32;
  else
    Result := $FF1976D2; // Primary
  end;
end;

function TDSkCircularProgress.GetTrackBgColor: TAlphaColor;
begin
  if not Enabled then
    Exit($FFF5F5F5);

  if FTrackColor <> TAlphaColors.Null then
    Exit(FTrackColor);
  Result := $FFE0E0E0;
end;

{ 值钳制 }

procedure TDSkCircularProgress.ClampValue(var AValue: Single);
begin
  if AValue < FMin then AValue := FMin;
  if AValue > FMax then AValue := FMax;
end;

{ 不定量动画 }

procedure TDSkCircularProgress.StartAnimation;
begin
  if FAnimTimer = nil then
  begin
    FAnimTimer := TTimer.Create(Self);
    FAnimTimer.Interval := ANIM_INTERVAL;
    FAnimTimer.OnTimer := AnimTimerTick;
  end;
  FAnimTimer.Enabled := True;
end;

procedure TDSkCircularProgress.StopAnimation;
begin
  if FAnimTimer <> nil then
    FAnimTimer.Enabled := False;
end;

procedure TDSkCircularProgress.AnimTimerTick(Sender: TObject);
begin
  FAnimProgress := FAnimProgress + ANIM_SPEED;
  if FAnimProgress >= 1.0 then
    FAnimProgress := FAnimProgress - 1.0;
  Redraw;
end;

{ 绘制方法 }

procedure TDSkCircularProgress.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
begin
  ACanvas.Clear($00FFFFFF);

  case FVariant of
    cpvDeterminate: DrawDeterminate(ACanvas, ADest);
    cpvIndeterminate: DrawIndeterminate(ACanvas, ADest);
  end;
end;

procedure TDSkCircularProgress.DrawTrackCircle(const ACanvas: ISkCanvas;
  const ACenter: TPointF; ARadius: Single);
var
  LPaint: ISkPaint;
  LRect: TRectF;
begin
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Stroke;
  LPaint.StrokeWidth := DpiScaleValue(FThickness);
  LPaint.Color := GetTrackBgColor;
  LPaint.StrokeCap := TSkStrokeCap.Round;

  LRect := RectF(
    ACenter.X - ARadius, ACenter.Y - ARadius,
    ACenter.X + ARadius, ACenter.Y + ARadius);
  ACanvas.DrawArc(LRect, 0, 360, False, LPaint);
end;

procedure TDSkCircularProgress.DrawProgressArc(const ACanvas: ISkCanvas;
  const ACenter: TPointF; ARadius: Single;
  AStartAngle, ASweepAngle: Single; AColor: TAlphaColor);
var
  LPaint: ISkPaint;
  LRect: TRectF;
begin
  if Abs(ASweepAngle) < 0.1 then Exit;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Stroke;
  LPaint.StrokeWidth := DpiScaleValue(FThickness);
  LPaint.Color := AColor;
  LPaint.StrokeCap := TSkStrokeCap.Round;

  LRect := RectF(
    ACenter.X - ARadius, ACenter.Y - ARadius,
    ACenter.X + ARadius, ACenter.Y + ARadius);
  ACanvas.DrawArc(LRect, AStartAngle, ASweepAngle, False, LPaint);
end;

function GetPercent(AValue, AMin, AMax: Single): Single;
var
  LRange: Single;
begin
  LRange := AMax - AMin;
  if LRange < 1.0 then
    LRange := 1.0;
  Result := (AValue - AMin) / LRange;
end;

procedure TDSkCircularProgress.DrawDeterminate(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LCenter: TPointF;
  LRadius: Single;
  LSize: Single;
  LPercent: Single;
  LSweepAngle: Single;
begin
  LCenter := PointF(ADest.Width / 2, ADest.Height / 2);
  if ADest.Width < ADest.Height then
    LSize := ADest.Width
  else
    LSize := ADest.Height;
  LRadius := (LSize - DpiScaleValue(FThickness)) / 2;
  if LRadius < 1 then Exit;

  // 轨道背景
  DrawTrackCircle(ACanvas, LCenter, LRadius);

  // 进度弧（从顶部 -90 度开始，顺时针）
  LPercent := GetPercent(FValue, FMin, FMax);
  LSweepAngle := LPercent * 360;
  DrawProgressArc(ACanvas, LCenter, LRadius, -90, LSweepAngle, GetActiveColor);

  // 标签
  if FShowLabel then
    DrawLabel(ACanvas, ADest, LCenter);
end;

procedure TDSkCircularProgress.DrawIndeterminate(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LCenter: TPointF;
  LRadius: Single;
  LSize: Single;
  LStartAngle, LSweepAngle: Single;
begin
  LCenter := PointF(ADest.Width / 2, ADest.Height / 2);
  if ADest.Width < ADest.Height then
    LSize := ADest.Width
  else
    LSize := ADest.Height;
  LRadius := (LSize - DpiScaleValue(FThickness)) / 2;
  if LRadius < 1 then Exit;

  // 轨道背景
  DrawTrackCircle(ACanvas, LCenter, LRadius);

  // 不定量旋转弧
  // 效果：弧线旋转的同时长度变化（从小到大再到小）
  // 使用 sin 曲线控制弧长，位置线性推进控制旋转
  LStartAngle := FAnimProgress * 360 - 90;
  // 弧长：使用 sin 曲线，最小 15 度，最大 270 度
  LSweepAngle := 15 + Sin(FAnimProgress * PI) * 255;

  DrawProgressArc(ACanvas, LCenter, LRadius, LStartAngle, LSweepAngle, GetActiveColor);
end;

procedure TDSkCircularProgress.DrawLabel(const ACanvas: ISkCanvas;
  const ADest: TRectF; const ACenter: TPointF);
var
  LFont: ISkFont;
  LPaint: ISkPaint;
  LText: string;
  LTextW, LTextH: Single;
  LPercent: Single;
begin
  LPercent := GetPercent(FValue, FMin, FMax);
  LText := Format(FValueLabelFormat, [LPercent * 100]);
  LFont := GetTextFont;
  LTextW := LFont.MeasureText(LText);
  LTextH := LFont.Size;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Fill;
  LPaint.Color := GetActiveColor;

  // 标签居中显示在圆环内
  ACanvas.DrawSimpleText(LText,
    ACenter.X - LTextW / 2,
    ACenter.Y + LTextH / 2,
    LFont, LPaint);
end;

{ 依赖关系 }

function TDSkCircularProgress.DependsOnParentBackground: Boolean;
begin
  Result := True;
end;

function TDSkCircularProgress.DependsOnParentVisualBackground: Boolean;
begin
  if Parent is TDSCustomSkControl then
    Result := TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack
  else
    Result := False;
end;

procedure TDSkCircularProgress.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  RequestRedraw;
end;

end.
