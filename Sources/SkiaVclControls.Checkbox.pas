unit SkiaVclControls.Checkbox;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  { TDSkCheckbox - MUI 风格的复选框组件
    支持三态：未选中、选中、不确定（Indeterminate）。
    无边框、透明背景，可单独使用或放入 TDSkCheckboxGroup 中管理。 }
  TDSkCheckbox = class(TDSCustomSkControl)
  private
    FChecked: Boolean;
    FIndeterminate: Boolean;
    FCaption: string;
    FLabelPlacement: TDSkRadioLabelPlacement;
    FColorScheme: TDSkMUIColorScheme;
    FCheckboxSize: Single;
    FFont: TFont;
    FError: Boolean;
    FMouseIsDown: Boolean;
    FOnCheckChanged: TNotifyEvent;
    FTextCacheFont: ISkFont;
    FTextCacheTypeface: ISkTypeface;
    FTextCacheFontName: string;
    FTextCacheFontStyle: TFontStyles;
    FTextCacheFontSize: Single;
    FTextCachePPI: Integer;
    FTextCacheText: string;
    FTextCacheWidth: Single;
    procedure RequestRedraw;
    procedure SetChecked(Value: Boolean);
    procedure SetIndeterminate(Value: Boolean);
    procedure SetCaption(const Value: string);
    procedure SetLabelPlacement(Value: TDSkRadioLabelPlacement);
    procedure SetColorScheme(Value: TDSkMUIColorScheme);
    procedure SetCheckboxSize(Value: Single);
    procedure SetFont(Value: TFont);
    procedure SetError(Value: Boolean);
    procedure FontChanged(Sender: TObject);
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure InvalidateTextCache;
    function GetTextFont: ISkFont;
    function MeasureCaptionText: Single;
  protected
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawCheckbox(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawCheckMark(const ACanvas: ISkCanvas; const ACenter: TPointF; ASize: Single);
    procedure DrawIndeterminateMark(const ACanvas: ISkCanvas; const ACenter: TPointF; ASize: Single);
    procedure DrawLabel(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Click; override;
    function ShouldClipWindowRegion: Boolean; override;
    function DependsOnParentBackground: Boolean; override;
    function DependsOnParentVisualBackground: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Toggle;
  published
    property Checked: Boolean read FChecked write SetChecked default False;
    property Indeterminate: Boolean read FIndeterminate write SetIndeterminate default False;
    property Caption: string read FCaption write SetCaption;
    property LabelPlacement: TDSkRadioLabelPlacement read FLabelPlacement write SetLabelPlacement default rlpRight;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property CheckboxSize: Single read FCheckboxSize write SetCheckboxSize;
    property Font: TFont read FFont write SetFont;
    property Error: Boolean read FError write SetError default False;
    property OnCheckChanged: TNotifyEvent read FOnCheckChanged write FOnCheckChanged;
    property Enabled;
    property Visible;
    property OnClick;
    property OnEnter;
    property OnExit;
  end;

implementation

{ TDSkCheckbox }

constructor TDSkCheckbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FChecked := False;
  FIndeterminate := False;
  FCaption := '';
  FLabelPlacement := rlpRight;
  FColorScheme := muiPrimary;
  FCheckboxSize := 20;
  FFont := TFont.Create;
  FFont.Name := GetDefaultFontName;
  FFont.Size := 10;
  FFont.OnChange := FontChanged;
  FError := False;
  FMouseIsDown := False;
  InvalidateTextCache;
  Width := 120;
  Height := 24;
  TabStop := True;

  // Checkbox 与 Radio 一样，需要表现为"透明叠加在父容器上"
  CornerRadius := 0;
  BackgroundColor := TAlphaColors.Null;
  BorderColor := TAlphaColors.Null;
  BorderWidth := 0;
end;

destructor TDSkCheckbox.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TDSkCheckbox.SetChecked(Value: Boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    // 选中时清除不确定状态
    if Value and FIndeterminate then
      FIndeterminate := False;
    RequestRedraw;
    if Assigned(FOnCheckChanged) then
      FOnCheckChanged(Self);
  end;
end;

procedure TDSkCheckbox.SetIndeterminate(Value: Boolean);
begin
  if FIndeterminate <> Value then
  begin
    FIndeterminate := Value;
    // 设置不确定状态时清除选中状态
    if Value and FChecked then
      FChecked := False;
    RequestRedraw;
    if Assigned(FOnCheckChanged) then
      FOnCheckChanged(Self);
  end;
end;

procedure TDSkCheckbox.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    InvalidateTextCache;
    RequestRedraw;
  end;
end;

procedure TDSkCheckbox.SetLabelPlacement(Value: TDSkRadioLabelPlacement);
begin
  if FLabelPlacement <> Value then
  begin
    FLabelPlacement := Value;
    RequestRedraw;
  end;
end;

procedure TDSkCheckbox.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then
  begin
    FColorScheme := Value;
    RequestRedraw;
  end;
end;

procedure TDSkCheckbox.SetCheckboxSize(Value: Single);
begin
  if FCheckboxSize <> Value then
  begin
    FCheckboxSize := Value;
    RequestRedraw;
  end;
end;

procedure TDSkCheckbox.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  InvalidateTextCache;
end;

procedure TDSkCheckbox.SetError(Value: Boolean);
begin
  if FError <> Value then
  begin
    FError := Value;
    RequestRedraw;
  end;
end;

procedure TDSkCheckbox.FontChanged(Sender: TObject);
begin
  InvalidateTextCache;
  RequestRedraw;
end;

procedure TDSkCheckbox.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  RequestRedraw;
end;

procedure TDSkCheckbox.RequestRedraw;
begin
  if csLoading in ComponentState then
    Exit;
  Redraw;
end;

function TDSkCheckbox.ShouldClipWindowRegion: Boolean;
begin
  // Checkbox 不需要圆角裁剪，保持透明背景
  Result := False;
end;

function TDSkCheckbox.DependsOnParentBackground: Boolean;
begin
  // Checkbox 不依赖父背景，直接透明绘制
  Result := False;
end;

function TDSkCheckbox.DependsOnParentVisualBackground: Boolean;
begin
  // 当父容器有 hover 效果时，Checkbox 需要跟随重绘以更新父背景缓冲区
  if Parent is TDSCustomSkControl then
    Result := TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack
  else
    Result := False;
end;

procedure TDSkCheckbox.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
begin
  // 先清除为透明，再绘制 Checkbox 内容，让父控件背景自然透出
  ACanvas.Clear($00FFFFFF);
  DrawCheckbox(ACanvas, ADest);
  DrawLabel(ACanvas, ADest);
end;

procedure TDSkCheckbox.DrawCheckbox(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LCenter: TPointF;
  LHalfSize: Single;
  LPaint: ISkPaint;
  LColor: TAlphaColor;
  LRoundRect: ISkRoundRect;
  LCornerRadius: Single;
begin
  LHalfSize := FCheckboxSize / 2;
  // 根据标签放置确定 Checkbox 中心位置
  case FLabelPlacement of
    rlpRight: LCenter := PointF(ADest.Left + LHalfSize, ADest.Top + ADest.Height / 2);
    rlpLeft: LCenter := PointF(ADest.Right - LHalfSize, ADest.Top + ADest.Height / 2);
    rlpTop: LCenter := PointF(ADest.Left + ADest.Width / 2, ADest.Bottom - LHalfSize);
    rlpBottom: LCenter := PointF(ADest.Left + ADest.Width / 2, ADest.Top + LHalfSize);
  end;

  // 确定颜色
  if (not Enabled) or IsParentDisabled then
    LColor := $FFBDBDBD
  else if FError then
    LColor := $FFD32F2F
  else
  begin
    case FColorScheme of
      muiSecondary: LColor := $FF9C27B0;
      muiError: LColor := $FFD32F2F;
      muiWarning: LColor := $FFED6C02;
      muiInfo: LColor := $FF0288D1;
      muiSuccess: LColor := $FF2E7D32;
    else
      LColor := $FF1976D2; // Primary
    end;
  end;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;

  // Checkbox 使用 3px 圆角
  LCornerRadius := 3;

  // 创建圆角矩形路径
  LRoundRect := TSkRoundRect.Create;
  LRoundRect.SetRect(RectF(
    LCenter.X - LHalfSize,
    LCenter.Y - LHalfSize,
    LCenter.X + LHalfSize,
    LCenter.Y + LHalfSize
  ), LCornerRadius, LCornerRadius);

  if FChecked or FIndeterminate then
  begin
    // 选中或不确定状态：实心圆角矩形
    LPaint.Style := TSkPaintStyle.Fill;
    if (not Enabled) or IsParentDisabled then
      LPaint.Color := $FFBDBDBD
    else
      LPaint.Color := LColor;
    ACanvas.DrawRoundRect(LRoundRect, LPaint);

    // 绘制勾选或横线图标
    if FIndeterminate then
      DrawIndeterminateMark(ACanvas, LCenter, FCheckboxSize)
    else
      DrawCheckMark(ACanvas, LCenter, FCheckboxSize);
  end
  else
  begin
    // 未选中状态：空心圆角矩形
    LPaint.Style := TSkPaintStyle.Stroke;
    LPaint.StrokeWidth := 2;
    LPaint.Color := LColor;
    ACanvas.DrawRoundRect(LRoundRect, LPaint);
  end;
end;

procedure TDSkCheckbox.DrawCheckMark(const ACanvas: ISkCanvas; const ACenter: TPointF; ASize: Single);
var
  LPathBuilder: ISkPathBuilder;
  LPath: ISkPath;
  LPaint: ISkPaint;
  LScale: Single;
begin
  // 绘制白色勾选图标 √
  // MUI 标准勾选路径：从左下方到中间再到右下方
  LScale := ASize / 24; // 以 24 为基准尺寸缩放

  LPathBuilder := TSkPathBuilder.Create;
  // √ 路径坐标（基于 24x24 网格，居中）
  // 起点：左下方 (4.5, 12.5)
  // 中间点：(9, 17)
  // 终点：右下方 (19.5, 7)
  LPathBuilder.MoveTo(
    ACenter.X + (-7.5) * LScale,
    ACenter.Y + (0.5) * LScale
  );
  LPathBuilder.LineTo(
    ACenter.X + (-3) * LScale,
    ACenter.Y + (5) * LScale
  );
  LPathBuilder.LineTo(
    ACenter.X + (7.5) * LScale,
    ACenter.Y + (-5) * LScale
  );
  LPath := LPathBuilder.Detach;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Stroke;
  LPaint.StrokeWidth := 2 * LScale;
  LPaint.Color := $FFFFFFFF; // 白色
  LPaint.StrokeCap := TSkStrokeCap.Round;
  LPaint.StrokeJoin := TSkStrokeJoin.Round;

  ACanvas.DrawPath(LPath, LPaint);
end;

procedure TDSkCheckbox.DrawIndeterminateMark(const ACanvas: ISkCanvas; const ACenter: TPointF; ASize: Single);
var
  LPaint: ISkPaint;
  LScale: Single;
  LStartX, LEndX, LY: Single;
begin
  // 绘制白色横线 —
  LScale := ASize / 24;

  LStartX := ACenter.X - 5 * LScale;
  LEndX := ACenter.X + 5 * LScale;
  LY := ACenter.Y;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Stroke;
  LPaint.StrokeWidth := 2 * LScale;
  LPaint.Color := $FFFFFFFF; // 白色
  LPaint.StrokeCap := TSkStrokeCap.Round;

  ACanvas.DrawLine(PointF(LStartX, LY), PointF(LEndX, LY), LPaint);
end;

procedure TDSkCheckbox.DrawLabel(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LFont: ISkFont;
  LPaint: ISkPaint;
  LX, LY: Single;
  LTextW, LTextH: Single;
begin
  if FCaption = '' then Exit;
  LFont := GetTextFont;
  LTextW := MeasureCaptionText;
  LTextH := LFont.Size;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  // 使用固定的文字颜色，确保可见
  if (not Enabled) or IsParentDisabled then
    LPaint.Color := $FF757575
  else
    LPaint.Color := $DE000000;

  // 根据标签放置确定位置
  LX := 0;
  LY := 0;
  case FLabelPlacement of
    rlpRight: begin
      LX := ADest.Left + FCheckboxSize + 8;
      LY := ADest.Top + (ADest.Height - LTextH) / 2 + LTextH;
    end;
    rlpLeft: begin
      LX := ADest.Right - FCheckboxSize - 8 - LTextW;
      LY := ADest.Top + (ADest.Height - LTextH) / 2 + LTextH;
    end;
    rlpTop: begin
      LX := ADest.Left + (ADest.Width - LTextW) / 2;
      LY := ADest.Bottom - FCheckboxSize - 8;
    end;
    rlpBottom: begin
      LX := ADest.Left + (ADest.Width - LTextW) / 2;
      LY := ADest.Top + FCheckboxSize + 8 + LTextH;
    end;
  end;

  ACanvas.DrawSimpleText(FCaption, LX, LY, LFont, LPaint);
end;

procedure TDSkCheckbox.InvalidateTextCache;
begin
  FTextCacheFont := nil;
  FTextCacheTypeface := nil;
  FTextCacheFontName := '';
  FTextCacheFontStyle := [];
  FTextCacheFontSize := -1;
  FTextCachePPI := 0;
  FTextCacheText := '';
  FTextCacheWidth := 0;
end;

function TDSkCheckbox.GetTextFont: ISkFont;
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
    FTextCacheText := '';
    FTextCacheWidth := 0;
  end;
  Result := FTextCacheFont;
end;

function TDSkCheckbox.MeasureCaptionText: Single;
var
  LFont: ISkFont;
begin
  LFont := GetTextFont;
  if FTextCacheText <> FCaption then
  begin
    FTextCacheWidth := LFont.MeasureText(FCaption);
    FTextCacheText := FCaption;
  end;
  Result := FTextCacheWidth;
end;

procedure TDSkCheckbox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FMouseIsDown := True;
end;

procedure TDSkCheckbox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if FMouseIsDown then
  begin
    FMouseIsDown := False;
    Toggle;
  end;
end;

procedure TDSkCheckbox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_SPACE then
    Toggle;
end;

procedure TDSkCheckbox.Click;
begin
  inherited;
end;

procedure TDSkCheckbox.Toggle;
begin
  // 如果当前是不确定状态，切换到选中状态
  if FIndeterminate then
  begin
    FIndeterminate := False;
    FChecked := True;
    RequestRedraw;
    if Assigned(FOnCheckChanged) then
      FOnCheckChanged(Self);
  end
  else
    Checked := not Checked;
end;

end.
