unit SkiaVclControls.Radio;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  TDSkRadio = class(TDSCustomSkControl)
  private
    FChecked: Boolean;
    FCaption: string;
    FLabelPlacement: TDSkRadioLabelPlacement;
    FColorScheme: TDSkMUIColorScheme;
    FRadioSize: Single;
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
    procedure SetCaption(const Value: string);
    procedure SetLabelPlacement(Value: TDSkRadioLabelPlacement);
    procedure SetColorScheme(Value: TDSkMUIColorScheme);
    procedure SetRadioSize(Value: Single);
    procedure SetFont(Value: TFont);
    procedure SetError(Value: Boolean);
    procedure FontChanged(Sender: TObject);
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure InvalidateTextCache;
    function GetTextFont: ISkFont;
    function MeasureCaptionText: Single;
  protected
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawRadio(const ACanvas: ISkCanvas; const ADest: TRectF);
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
    property Caption: string read FCaption write SetCaption;
    property LabelPlacement: TDSkRadioLabelPlacement read FLabelPlacement write SetLabelPlacement default rlpRight;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property RadioSize: Single read FRadioSize write SetRadioSize;
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

{ TDSkRadio }

constructor TDSkRadio.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FChecked := False;
  FCaption := '';
  FLabelPlacement := rlpRight;
  FColorScheme := muiPrimary;
  FRadioSize := 20;
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
  
  // Radio 需要表现为“透明叠加在父容器上”，
  // 实际做法是先由基类把父背景铺到底图，再绘制自身内容。
  CornerRadius := 0;
  BackgroundColor := TAlphaColors.Null;
  BorderColor := TAlphaColors.Null;
  BorderWidth := 0;
end;

destructor TDSkRadio.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TDSkRadio.SetChecked(Value: Boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    RequestRedraw;
    if Assigned(FOnCheckChanged) then
      FOnCheckChanged(Self);
  end;
end;

procedure TDSkRadio.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    InvalidateTextCache;
    RequestRedraw;
  end;
end;

procedure TDSkRadio.SetLabelPlacement(Value: TDSkRadioLabelPlacement);
begin
  if FLabelPlacement <> Value then
  begin
    FLabelPlacement := Value;
    RequestRedraw;
  end;
end;

procedure TDSkRadio.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then
  begin
    FColorScheme := Value;
    RequestRedraw;
  end;
end;

procedure TDSkRadio.SetRadioSize(Value: Single);
begin
  if FRadioSize <> Value then
  begin
    FRadioSize := Value;
    RequestRedraw;
  end;
end;

procedure TDSkRadio.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  InvalidateTextCache;
end;

procedure TDSkRadio.SetError(Value: Boolean);
begin
  if FError <> Value then
  begin
    FError := Value;
    RequestRedraw;
  end;
end;

procedure TDSkRadio.FontChanged(Sender: TObject);
begin
  InvalidateTextCache;
  RequestRedraw;
end;

procedure TDSkRadio.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  RequestRedraw;
end;

procedure TDSkRadio.RequestRedraw;
begin
  if csLoading in ComponentState then
    Exit;
  Redraw;
end;

function TDSkRadio.ShouldClipWindowRegion: Boolean;
begin
  // Radio 不需要圆角裁剪，保持透明背景
  Result := False;
end;

function TDSkRadio.DependsOnParentBackground: Boolean;
begin
  // Radio 不依赖父背景，直接透明绘制
  Result := False;
end;

function TDSkRadio.DependsOnParentVisualBackground: Boolean;
begin
  // 当父容器有 hover 效果时，Radio 需要跟随重绘以更新父背景缓冲区。
  // Radio 是真透明控件（IsOpaque=False），依赖 TSkCustomWinControl.Paint
  // 中的 DrawParentImage 捕获父背景。父容器 hover 背景色改变后，
  // 必须触发 Radio 重绘才能让父背景缓冲区更新。
  if Parent is TDSCustomSkControl then
    Result := TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack
  else
    Result := False;
end;

procedure TDSkRadio.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
begin
  // 先清除为透明，再绘制 Radio 内容，让父控件背景自然透出
  ACanvas.Clear($00FFFFFF); // 透明白色，避免 premultiplied alpha 问题
  DrawRadio(ACanvas, ADest);
  DrawLabel(ACanvas, ADest);
end;

procedure TDSkRadio.DrawRadio(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LCenter: TPointF;
  LRadius: Single;
  LPaint: ISkPaint;
  LColor, LOuterColor: TAlphaColor;
begin
  LRadius := FRadioSize / 2;
  case FLabelPlacement of
    rlpRight: LCenter := PointF(ADest.Left + LRadius, ADest.Top + ADest.Height / 2);
    rlpLeft: LCenter := PointF(ADest.Right - LRadius, ADest.Top + ADest.Height / 2);
    rlpTop: LCenter := PointF(ADest.Left + ADest.Width / 2, ADest.Bottom - LRadius);
    rlpBottom: LCenter := PointF(ADest.Left + ADest.Width / 2, ADest.Top + LRadius);
  end;

  // 确定颜色
  if (not Enabled) or IsParentDisabled then
  begin
    LColor := $FFBDBDBD;
    LOuterColor := $FFBDBDBD;
  end
  else if FError then
  begin
    LColor := $FFD32F2F;
    LOuterColor := $FFD32F2F;
  end
  else
  begin
    case FColorScheme of
      muiSecondary: begin LColor := $FF9C27B0; LOuterColor := $FF9C27B0; end;
      muiError: begin LColor := $FFD32F2F; LOuterColor := $FFD32F2F; end;
      muiWarning: begin LColor := $FFED6C02; LOuterColor := $FFED6C02; end;
      muiInfo: begin LColor := $FF0288D1; LOuterColor := $FF0288D1; end;
      muiSuccess: begin LColor := $FF2E7D32; LOuterColor := $FF2E7D32; end;
    else
      begin LColor := $FF1976D2; LOuterColor := $FF1976D2; end; // Primary
    end;
  end;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;

  if FChecked then
  begin
    // 选中状态：实心圆 + 外圈（外圈颜色变淡）
    LPaint.Style := TSkPaintStyle.Fill;
    LPaint.Color := LColor;
    ACanvas.DrawCircle(LCenter, LRadius * 0.5, LPaint);

    // 外圈（选中时颜色变淡）
    LPaint.Style := TSkPaintStyle.Stroke;
    LPaint.StrokeWidth := 1.5;
    LPaint.Color := (LOuterColor and $00FFFFFF) or $80000000; // 50% 透明度
    ACanvas.DrawCircle(LCenter, LRadius - 1, LPaint);
  end
  else
  begin
    // 未选中状态：空心圆
    LPaint.Style := TSkPaintStyle.Stroke;
    LPaint.StrokeWidth := 1.5;
    LPaint.Color := LOuterColor;
    ACanvas.DrawCircle(LCenter, LRadius - 1, LPaint);
  end;
end;

procedure TDSkRadio.DrawLabel(const ACanvas: ISkCanvas; const ADest: TRectF);
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
  case FLabelPlacement of
    rlpRight: begin
      LX := ADest.Left + FRadioSize + 8;
      LY := ADest.Top + (ADest.Height - LTextH) / 2 + LTextH;
    end;
    rlpLeft: begin
      LX := ADest.Right - FRadioSize - 8 - LTextW;
      LY := ADest.Top + (ADest.Height - LTextH) / 2 + LTextH;
    end;
    rlpTop: begin
      LX := ADest.Left + (ADest.Width - LTextW) / 2;
      LY := ADest.Bottom - FRadioSize - 8;
    end;
    rlpBottom: begin
      LX := ADest.Left + (ADest.Width - LTextW) / 2;
      LY := ADest.Top + FRadioSize + 8 + LTextH;
    end;
  end;

  ACanvas.DrawSimpleText(FCaption, LX, LY, LFont, LPaint);
end;

procedure TDSkRadio.InvalidateTextCache;
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

function TDSkRadio.GetTextFont: ISkFont;
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

function TDSkRadio.MeasureCaptionText: Single;
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

procedure TDSkRadio.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FMouseIsDown := True;
end;

procedure TDSkRadio.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if FMouseIsDown then
  begin
    FMouseIsDown := False;
    Toggle;
  end;
end;

procedure TDSkRadio.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_SPACE then
    Toggle;
end;

procedure TDSkRadio.Click;
begin
  inherited;
end;

procedure TDSkRadio.Toggle;
begin
  Checked := not Checked;
end;

end.
