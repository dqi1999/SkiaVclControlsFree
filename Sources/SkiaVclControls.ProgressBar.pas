unit SkiaVclControls.ProgressBar;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.ExtCtrls, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  { TDSkProgressBar - MUI 风格线性进度条
    支持定量(Determinate)、不定量(Indeterminate)和缓冲(Buffer)三种变体。
    参考 Material-UI LinearProgress 组件。 }
  TDSkProgressBar = class(TDSCustomSkControl)
  private
    FMin: Single;
    FMax: Single;
    FValue: Single;
    FValueBuffer: Single;
    FVariant: TDSkProgressBarVariant;
    FOrientation: TDSkProgressBarOrientation;
    FColorScheme: TDSkMUIColorScheme;
    FBarColor: TAlphaColor;         // 自定义进度条颜色，Null 时使用 ColorScheme
    FTrackColor: TAlphaColor;       // 轨道背景色，Null 时使用默认灰色
    FTrackHeight: Single;
    FRounded: Boolean;
    FShowLabel: Boolean;
    FFont: TFont;
    FValueLabelFormat: string;
    FOnChange: TNotifyEvent;
    // 不定量动画
    FAnimTimer: TTimer;
    FAnimProgress: Single;          // 0..1 循环动画进度
    // 字体缓存（避免动画帧内重复创建）
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
    procedure SetValueBuffer(Value: Single);
    procedure SetVariant(Value: TDSkProgressBarVariant);
    procedure SetOrientation(Value: TDSkProgressBarOrientation);
    procedure SetColorScheme(Value: TDSkMUIColorScheme);
    procedure SetBarColor(Value: TAlphaColor);
    procedure SetTrackColor(Value: TAlphaColor);
    procedure SetTrackHeight(Value: Single);
    procedure SetRounded(Value: Boolean);
    procedure SetShowLabel(Value: Boolean);
    procedure SetFont(Value: TFont);
    procedure SetValueLabelFormat(const Value: string);
    procedure FontChanged(Sender: TObject);
    procedure InvalidateTextCache;
    function GetTextFont: ISkFont;
    function GetProgressColor: TAlphaColor;
    function GetTrackBgColor: TAlphaColor;
    function GetBufferColor: TAlphaColor;
    procedure ClampValue(var AValue: Single);
    procedure StartAnimation;
    procedure StopAnimation;
    procedure AnimTimerTick(Sender: TObject);
    function GetTrackRect(const ADest: TRectF): TRectF;
  protected
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawTrack(const ACanvas: ISkCanvas; const ATrackRect: TRectF);
    procedure DrawBar(const ACanvas: ISkCanvas; const ATrackRect: TRectF; APercent: Single; AColor: TAlphaColor);
    procedure DrawIndeterminateBars(const ACanvas: ISkCanvas; const ATrackRect: TRectF);
    procedure DrawBufferBar(const ACanvas: ISkCanvas; const ATrackRect: TRectF);
    procedure DrawLabel(const ACanvas: ISkCanvas; const ADest: TRectF);
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
    property ValueBuffer: Single read FValueBuffer write SetValueBuffer;
    property Variant: TDSkProgressBarVariant read FVariant write SetVariant default pbvDeterminate;
    property Orientation: TDSkProgressBarOrientation read FOrientation write SetOrientation default pboHorizontal;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property BarColor: TAlphaColor read FBarColor write SetBarColor;
    property TrackColor: TAlphaColor read FTrackColor write SetTrackColor;
    property TrackHeight: Single read FTrackHeight write SetTrackHeight;
    property Rounded: Boolean read FRounded write SetRounded default True;
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
  DEFAULT_TRACK_HEIGHT = 4;
  ANIM_INTERVAL = 16;  // ~60fps
  ANIM_SPEED = 0.008;  // 每帧递增量，约 2 秒完成一个周期

{ TDSkProgressBar }

constructor TDSkProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMin := 0;
  FMax := 100;
  FValue := 0;
  FValueBuffer := 0;
  FVariant := pbvDeterminate;
  FOrientation := pboHorizontal;
  FColorScheme := muiPrimary;
  FBarColor := TAlphaColors.Null;
  FTrackColor := TAlphaColors.Null;
  FTrackHeight := DEFAULT_TRACK_HEIGHT;
  FRounded := True;
  FShowLabel := False;
  FFont := TFont.Create;
  FFont.Name := GetDefaultFontName;
  FFont.Size := 10;
  FFont.OnChange := FontChanged;
  FValueLabelFormat := '%.0f%%';
  FAnimProgress := 0;
  FAnimTimer := nil;
  InvalidateTextCache;
  Width := 200;
  Height := 20;
  TabStop := False;
  // 进度条自身透明，只绘制轨道和进度条
  CornerRadius := 0;
  BackgroundColor := TAlphaColors.Null;
  BorderColor := TAlphaColors.Null;
  BorderWidth := 0;
end;

destructor TDSkProgressBar.Destroy;
begin
  StopAnimation;
  FFont.Free;
  inherited;
end;

function TDSkProgressBar.ShouldClipWindowRegion: Boolean;
begin
  Result := False;
end;

procedure TDSkProgressBar.RequestRedraw;
begin
  if csLoading in ComponentState then Exit;
  Redraw;
end;

{ 属性设置器 }

procedure TDSkProgressBar.SetMin(Value: Single);
begin
  if FMin <> Value then
  begin
    FMin := Value;
    if FMax < FMin then FMax := FMin;
    ClampValue(FValue);
    ClampValue(FValueBuffer);
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkProgressBar.SetMax(Value: Single);
begin
  if FMax <> Value then
  begin
    FMax := Value;
    if FMin > FMax then FMin := FMax;
    ClampValue(FValue);
    ClampValue(FValueBuffer);
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkProgressBar.SetValue(Value: Single);
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

procedure TDSkProgressBar.SetValueBuffer(Value: Single);
begin
  ClampValue(Value);
  if FValueBuffer <> Value then
  begin
    FValueBuffer := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkProgressBar.SetVariant(Value: TDSkProgressBarVariant);
begin
  if FVariant <> Value then
  begin
    FVariant := Value;
    // 切换变体时启动/停止动画定时器
    if Value = pbvIndeterminate then
      StartAnimation
    else
      StopAnimation;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkProgressBar.SetOrientation(Value: TDSkProgressBarOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkProgressBar.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then
  begin
    FColorScheme := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkProgressBar.SetBarColor(Value: TAlphaColor);
begin
  if FBarColor <> Value then
  begin
    FBarColor := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkProgressBar.SetTrackColor(Value: TAlphaColor);
begin
  if FTrackColor <> Value then
  begin
    FTrackColor := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkProgressBar.SetTrackHeight(Value: Single);
begin
  if not SameValue(FTrackHeight, Value) then
  begin
    FTrackHeight := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkProgressBar.SetRounded(Value: Boolean);
begin
  if FRounded <> Value then
  begin
    FRounded := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkProgressBar.SetShowLabel(Value: Boolean);
begin
  if FShowLabel <> Value then
  begin
    FShowLabel := Value;
    if not (csLoading in ComponentState) then RequestRedraw;
  end;
end;

procedure TDSkProgressBar.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  InvalidateTextCache;
  if not (csLoading in ComponentState) then RequestRedraw;
end;

procedure TDSkProgressBar.SetValueLabelFormat(const Value: string);
begin
  if FValueLabelFormat <> Value then
  begin
    FValueLabelFormat := Value;
    if FShowLabel and not (csLoading in ComponentState) then
      RequestRedraw;
  end;
end;

procedure TDSkProgressBar.FontChanged(Sender: TObject);
begin
  InvalidateTextCache;
  if FShowLabel and not (csLoading in ComponentState) then
    RequestRedraw;
end;

{ 字体缓存 }

procedure TDSkProgressBar.InvalidateTextCache;
begin
  FTextCacheFont := nil;
  FTextCacheTypeface := nil;
  FTextCacheFontName := '';
  FTextCacheFontStyle := [];
  FTextCacheFontSize := -1;
  FTextCachePPI := 0;
end;

function TDSkProgressBar.GetTextFont: ISkFont;
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

function TDSkProgressBar.GetProgressColor: TAlphaColor;
begin
  if not Enabled then
    Exit($FFBDBDBD);

  // 自定义颜色优先，否则使用 ColorScheme
  if FBarColor <> TAlphaColors.Null then
    Exit(FBarColor);

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

function TDSkProgressBar.GetTrackBgColor: TAlphaColor;
begin
  if not Enabled then
    Exit($FFF5F5F5);

  if FTrackColor <> TAlphaColors.Null then
    Exit(FTrackColor);
  Result := $FFE0E0E0; // MUI 默认灰色轨道
end;

function TDSkProgressBar.GetBufferColor: TAlphaColor;
begin
  if not Enabled then
    Exit($40BDBDBD);

  // 缓冲条颜色：主题色 40% 透明度
  Result := (GetProgressColor and $00FFFFFF) or $66000000;
end;

{ 值钳制 }

procedure TDSkProgressBar.ClampValue(var AValue: Single);
begin
  if AValue < FMin then AValue := FMin;
  if AValue > FMax then AValue := FMax;
end;

{ 不定量动画 }

procedure TDSkProgressBar.StartAnimation;
begin
  if FAnimTimer = nil then
  begin
    FAnimTimer := TTimer.Create(Self);
    FAnimTimer.Interval := ANIM_INTERVAL;
    FAnimTimer.OnTimer := AnimTimerTick;
  end;
  FAnimTimer.Enabled := True;
end;

procedure TDSkProgressBar.StopAnimation;
begin
  if FAnimTimer <> nil then
    FAnimTimer.Enabled := False;
end;

procedure TDSkProgressBar.AnimTimerTick(Sender: TObject);
begin
  FAnimProgress := FAnimProgress + ANIM_SPEED;
  if FAnimProgress >= 1.0 then
    FAnimProgress := FAnimProgress - 1.0;
  Redraw;
end;

{ 轨道矩形计算 }

function TDSkProgressBar.GetTrackRect(const ADest: TRectF): TRectF;
var
  LH: Single;
  LLabelSpace: Single;
  LFont: ISkFont;
  LMetrics: TSkFontMetrics;
begin
  LH := DpiScaleValue(FTrackHeight);
  
  // 计算标签需要的空间
  LLabelSpace := 0;
  if FShowLabel and (FOrientation = pboHorizontal) then
  begin
    LFont := GetTextFont;
    LFont.GetMetrics(LMetrics);
    LLabelSpace := -LMetrics.Ascent + LMetrics.Descent + 4; // 文字高度 + 间距
  end;
  
  if FOrientation = pboHorizontal then
    Result := RectF(
      ADest.Left,
      ADest.Top + LLabelSpace + (ADest.Height - LLabelSpace - LH) / 2,
      ADest.Right,
      ADest.Top + LLabelSpace + (ADest.Height - LLabelSpace + LH) / 2)
  else
    Result := RectF(
      ADest.Left + (ADest.Width - LH) / 2,
      ADest.Top,
      ADest.Left + (ADest.Width + LH) / 2,
      ADest.Bottom);
end;

{ 绘制方法 }

function GetPercent(AValue, AMin, AMax: Single): Single;
var
  LRange: Single;
begin
  LRange := AMax - AMin;
  if LRange < 1.0 then
    LRange := 1.0;
  Result := (AValue - AMin) / LRange;
end;

procedure TDSkProgressBar.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
var
  LTrackRect: TRectF;
begin
  // 清除为透明
  ACanvas.Clear($00FFFFFF);

  LTrackRect := GetTrackRect(ADest);

  // 1. 绘制轨道背景
  DrawTrack(ACanvas, LTrackRect);

  // 2. 根据变体绘制进度内容
  case FVariant of
    pbvDeterminate:
      begin
        DrawBar(ACanvas, LTrackRect, GetPercent(FValue, FMin, FMax), GetProgressColor);
        if FShowLabel then
          DrawLabel(ACanvas, ADest);
      end;
    pbvIndeterminate:
      DrawIndeterminateBars(ACanvas, LTrackRect);
    pbvBuffer:
      begin
        DrawBufferBar(ACanvas, LTrackRect);
        DrawBar(ACanvas, LTrackRect, GetPercent(FValue, FMin, FMax), GetProgressColor);
        if FShowLabel then
          DrawLabel(ACanvas, ADest);
      end;
  end;
end;

procedure TDSkProgressBar.DrawTrack(const ACanvas: ISkCanvas; const ATrackRect: TRectF);
var
  LPaint: ISkPaint;
  LRadius: Single;
begin
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Fill;
  LPaint.Color := GetTrackBgColor;

  if FRounded then
  begin
    LRadius := ATrackRect.Height / 2;
    ACanvas.DrawRoundRect(TSkRoundRect.Create(ATrackRect, LRadius, LRadius), LPaint);
  end
  else
    ACanvas.DrawRect(ATrackRect, LPaint);
end;

procedure TDSkProgressBar.DrawBar(const ACanvas: ISkCanvas; const ATrackRect: TRectF;
  APercent: Single; AColor: TAlphaColor);
var
  LPaint: ISkPaint;
  LRadius: Single;
  LBarRect: TRectF;
  LPercent: Single;
begin
  if APercent <= 0 then Exit;

  LPercent := APercent;
  if LPercent < 0 then LPercent := 0;
  if LPercent > 1 then LPercent := 1;
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Fill;
  LPaint.Color := AColor;

  if FRounded then
    LRadius := ATrackRect.Height / 2
  else
    LRadius := 0;

  if FOrientation = pboHorizontal then
  begin
    LBarRect := RectF(
      ATrackRect.Left,
      ATrackRect.Top,
      ATrackRect.Left + LPercent * ATrackRect.Width,
      ATrackRect.Bottom);
  end
  else
  begin
    // 垂直方向：从底部向上增长
    LBarRect := RectF(
      ATrackRect.Left,
      ATrackRect.Bottom - LPercent * ATrackRect.Height,
      ATrackRect.Right,
      ATrackRect.Bottom);
  end;

  if LRadius > 0 then
    ACanvas.DrawRoundRect(TSkRoundRect.Create(LBarRect, LRadius, LRadius), LPaint)
  else
    ACanvas.DrawRect(LBarRect, LPaint);
end;

procedure TDSkProgressBar.DrawIndeterminateBars(const ACanvas: ISkCanvas; const ATrackRect: TRectF);
var
  LColor: TAlphaColor;
  LRadius: Single;
  LBarRect: TRectF;
  LPaint: ISkPaint;
  LCenter, LWidth, LStart, LEnd: Single;
  LPhase1, LPhase2: Single;
begin
  LColor := GetProgressColor;
  if FRounded then
    LRadius := ATrackRect.Height / 2
  else
    LRadius := 0;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Fill;

  // 两根条形动画：相位偏移 0.5
  // 使用 sin 曲线控制宽度，位置线性推进
  // 效果：条形从左侧进入，逐渐变宽，到达右侧后逐渐变窄退出
  LPhase1 := FAnimProgress;
  LPhase2 := Frac(FAnimProgress + 0.5);

  // 绘制第一根条形
  LCenter := LPhase1;
  LWidth := Sin(LPhase1 * PI) * 0.35;
  LStart := LCenter - LWidth / 2;
  LEnd := LCenter + LWidth / 2;
  if LStart < 0 then LStart := 0;
  if LEnd > 1 then LEnd := 1;

  LPaint.Color := LColor;
  if (LEnd - LStart) > 0.001 then
  begin
    if FOrientation = pboHorizontal then
      LBarRect := RectF(
        ATrackRect.Left + LStart * ATrackRect.Width,
        ATrackRect.Top,
        ATrackRect.Left + LEnd * ATrackRect.Width,
        ATrackRect.Bottom)
    else
      LBarRect := RectF(
        ATrackRect.Left,
        ATrackRect.Bottom - LEnd * ATrackRect.Height,
        ATrackRect.Right,
        ATrackRect.Bottom - LStart * ATrackRect.Height);

    if LRadius > 0 then
      ACanvas.DrawRoundRect(TSkRoundRect.Create(LBarRect, LRadius, LRadius), LPaint)
    else
      ACanvas.DrawRect(LBarRect, LPaint);
  end;

  // 绘制第二根条形（稍淡的颜色）
  LCenter := LPhase2;
  LWidth := Sin(LPhase2 * PI) * 0.35;
  LStart := LCenter - LWidth / 2;
  LEnd := LCenter + LWidth / 2;
  if LStart < 0 then LStart := 0;
  if LEnd > 1 then LEnd := 1;

  // 第二根条形使用 50% 透明度
  LPaint.Color := (LColor and $00FFFFFF) or $80000000;
  if (LEnd - LStart) > 0.001 then
  begin
    if FOrientation = pboHorizontal then
      LBarRect := RectF(
        ATrackRect.Left + LStart * ATrackRect.Width,
        ATrackRect.Top,
        ATrackRect.Left + LEnd * ATrackRect.Width,
        ATrackRect.Bottom)
    else
      LBarRect := RectF(
        ATrackRect.Left,
        ATrackRect.Bottom - LEnd * ATrackRect.Height,
        ATrackRect.Right,
        ATrackRect.Bottom - LStart * ATrackRect.Height);

    if LRadius > 0 then
      ACanvas.DrawRoundRect(TSkRoundRect.Create(LBarRect, LRadius, LRadius), LPaint)
    else
      ACanvas.DrawRect(LBarRect, LPaint);
  end;
end;

procedure TDSkProgressBar.DrawBufferBar(const ACanvas: ISkCanvas; const ATrackRect: TRectF);
var
  LPercent: Single;
begin
  LPercent := GetPercent(FValueBuffer, FMin, FMax);
  if LPercent > 0 then
    DrawBar(ACanvas, ATrackRect, LPercent, GetBufferColor);
end;

procedure TDSkProgressBar.DrawLabel(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LFont: ISkFont;
  LPaint: ISkPaint;
  LText: string;
  LTextW: Single;
  LPercent: Single;
  LX, LY: Single;
  LMetrics: TSkFontMetrics;
  LTrackRect: TRectF;
begin
  LPercent := GetPercent(FValue, FMin, FMax);
  LText := Format(FValueLabelFormat, [LPercent * 100]);
  LFont := GetTextFont;
  LTextW := LFont.MeasureText(LText);
  LFont.GetMetrics(LMetrics);

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Fill;
  LPaint.Color := GetProgressColor;

  if FOrientation = pboHorizontal then
  begin
    // 水平模式：文字显示在轨道上方
    LTrackRect := GetTrackRect(ADest);
    LX := ADest.Left + (ADest.Width - LTextW) / 2;
    // 文字底部紧贴轨道上方，基线位置
    LY := LTrackRect.Top - 4 - LMetrics.Descent;
  end
  else
  begin
    // 垂直模式：文字居中显示
    LX := ADest.Left + (ADest.Width - LTextW) / 2;
    LY := ADest.Top + (ADest.Height - (-LMetrics.Ascent + LMetrics.Descent)) / 2 - LMetrics.Ascent;
  end;

  ACanvas.DrawSimpleText(LText, LX, LY, LFont, LPaint);
end;

{ 依赖关系 }

function TDSkProgressBar.DependsOnParentBackground: Boolean;
begin
  Result := True;
end;

function TDSkProgressBar.DependsOnParentVisualBackground: Boolean;
begin
  if Parent is TDSCustomSkControl then
    Result := TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack
  else
    Result := False;
end;

procedure TDSkProgressBar.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  RequestRedraw;
end;

end.
