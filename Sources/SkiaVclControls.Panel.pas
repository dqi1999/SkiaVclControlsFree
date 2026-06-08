unit SkiaVclControls.Panel;

interface

uses
  System.Classes, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  TDSkPanel = class(TDSCustomSkControl)
  private
    FCaption: string;
    FCaptionPosition: TDSkCaptionPosition;
    FCaptionFont: TFont;
    FCaptionMargin: Single;
    FChildPadding: Single;
    FBackgroundHover: TAlphaColor;
    FHoverEnabled: Boolean;
    FPanelStyle: TDSkPanelStyle;
    FLoading: Boolean;
    FApplyingPanelStyle: Boolean;
    FCornerRadiusExplicit: Boolean;
    FCaptionCacheFont: ISkFont;
    FCaptionCacheTypeface: ISkTypeface;
    FCaptionCacheFontName: string;
    FCaptionCacheFontStyle: TFontStyles;
    FCaptionCacheFontSize: Single;
    FCaptionCachePPI: Integer;
    FCaptionCacheText: string;
    FCaptionCacheTextWidth: Single;
    procedure SetCaption(const Value: string);
    procedure SetCaptionPosition(const Value: TDSkCaptionPosition);
    procedure SetCaptionFont(const Value: TFont);
    procedure SetCaptionMargin(const Value: Single);
    procedure SetChildPadding(const Value: Single);
    procedure SetBackgroundHover(const Value: TAlphaColor);
    procedure SetHoverEnabled(const Value: Boolean);
    procedure SetPanelStyle(const Value: TDSkPanelStyle);
    procedure ApplyPanelStyleInternal;
    procedure FontChanged(Sender: TObject);
    procedure InvalidateCaptionCache;
    function GetCaptionFontCache: ISkFont;
    function MeasureCaptionText: Single;
    procedure RequestRedraw;
  protected
    function GetBackgroundColor: TAlphaColor; override;
    procedure Loaded; override;
    procedure PaintDesignTime(ACanvas: TCanvas); override;
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawCaption(const ACanvas: ISkCanvas; const ADest: TRectF); virtual;
    procedure CornerRadiusChanged; override;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    function ShouldClipWindowRegion: Boolean; override; // 【核心引入】彻底关掉 Panel 的操作系统物理窗口硬剪裁
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function HasVisualStateChangesOnMouseTrack: Boolean; override;
  published
    property Caption: string read FCaption write SetCaption;
    property CaptionPosition: TDSkCaptionPosition read FCaptionPosition write SetCaptionPosition;
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property CaptionMargin: Single read FCaptionMargin write SetCaptionMargin;
    property ChildPadding: Single read FChildPadding write SetChildPadding;
    property BackgroundHover: TAlphaColor read FBackgroundHover write SetBackgroundHover;
    property HoverEnabled: Boolean read FHoverEnabled write SetHoverEnabled default False;
    property PanelStyle: TDSkPanelStyle read FPanelStyle write SetPanelStyle default psStyleNone;
    property CornerRadius stored IsCornerRadiusStored;
    property BackgroundColor;
    property BorderColor;
    property BorderWidth;
    property OnClick; property OnMouseEnter; property OnMouseLeave;
  end;

implementation

constructor TDSkPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaptionFont := TFont.Create;
  FCaptionFont.OnChange := FontChanged;
  FCaptionFont.Name := GetDefaultFontName;
  FCaptionFont.Size := 12;
  FCaption := '';
  FCaptionPosition := cpTopCenter;
  FCaptionMargin := 8;
  FChildPadding := 8;
  FBackgroundHover := $FFF5F5F5;
  FHoverEnabled := False;
  FPanelStyle := psStyleNone;
  FLoading := True;
  FApplyingPanelStyle := False;
  FCornerRadiusExplicit := False;
  InvalidateCaptionCache;
  // Panel 作为容器时，默认直角比默认圆角更安全。
  // 这样即使设计期把 CornerRadius 设为 0 时 DFM 没有显式写出，
  // 运行时也不会回退到基类的默认值 10。
  CornerRadius := 0;
  FCornerRadiusExplicit := False;
  Width := 200;
  Height := 150;
end;

destructor TDSkPanel.Destroy;
begin
  FCaptionFont.Free;
  inherited;
end;

function TDSkPanel.ShouldClipWindowRegion: Boolean;
begin
  // 【最关键】告诉基类：Panel 容器在运行时完全不需要系统进行粗暴的硬切
  // 这样 Windows 就会放权给 Skia，在普通矩形区域内进行极限抗锯齿自绘
  Result := False;
end;

procedure TDSkPanel.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
var
  LSaveCount: Integer;
begin
  // 直接继承基类调整后的“1.2 像素亚像素内缩画布裁剪加绘制”体系
  inherited Draw(ACanvas, ADest, AOpacity);

  if FCaption <> '' then
  begin
    LSaveCount := ACanvas.Save;
    try
      DrawCaption(ACanvas, ADest);
    finally
      ACanvas.RestoreToCount(LSaveCount);
    end;
  end;
end;

procedure TDSkPanel.FontChanged(Sender: TObject);
begin
  InvalidateCaptionCache;
  if CanRedrawNow then Redraw;
end;

procedure TDSkPanel.SetCaption(const Value: string);
begin
  if FCaption <> Value then begin FCaption := Value; InvalidateCaptionCache; if CanRedrawNow then Redraw; end;
end;

procedure TDSkPanel.SetCaptionPosition(const Value: TDSkCaptionPosition);
begin if FCaptionPosition <> Value then begin FCaptionPosition := Value; if CanRedrawNow then Redraw; end; end;

procedure TDSkPanel.SetCaptionFont(const Value: TFont);
begin FCaptionFont.Assign(Value); InvalidateCaptionCache; if CanRedrawNow then Redraw; end;

procedure TDSkPanel.SetCaptionMargin(const Value: Single);
begin if FCaptionMargin <> Value then begin FCaptionMargin := Value; if CanRedrawNow then Redraw; end; end;

procedure TDSkPanel.SetChildPadding(const Value: Single);
begin if FChildPadding <> Value then begin FChildPadding := Value; if CanRedrawNow then Redraw; end; end;

procedure TDSkPanel.SetBackgroundHover(const Value: TAlphaColor);
begin
  if FBackgroundHover <> Value then
  begin
    FBackgroundHover := Value;
    if CanRedrawNow then
    begin
      Redraw;
      if FHoverEnabled and MouseIsInside then
        RedrawDependentSkiaChildren(True);
    end;
  end;
end;

procedure TDSkPanel.SetHoverEnabled(const Value: Boolean);
var
  LAffectsVisualState: Boolean;
begin
  if FHoverEnabled <> Value then
  begin
    LAffectsVisualState := MouseIsInside and (FHoverEnabled or Value);
    FHoverEnabled := Value;
    if CanRedrawNow then
    begin
      Redraw;
      if LAffectsVisualState then
        RedrawDependentSkiaChildren(True);
    end;
  end;
end;

procedure TDSkPanel.CornerRadiusChanged;
begin
  inherited;
  // 只要不是 PanelStyle 在内部回填预设值，就认为这是用户显式设置的圆角，
  // 运行时再应用样式时应继续尊重这个值（例如 CornerRadius = 0 的直角面板）。
  if not FApplyingPanelStyle then
    FCornerRadiusExplicit := True;
end;

procedure TDSkPanel.Loaded;
begin
  inherited;
  FLoading := False;
  ApplyPanelStyleInternal;
end;

procedure TDSkPanel.SetPanelStyle(const Value: TDSkPanelStyle);
begin
  if FPanelStyle <> Value then begin
    FPanelStyle := Value;
    if not FLoading then
      ApplyPanelStyleInternal;
  end;
end;

procedure TDSkPanel.ApplyPanelStyleInternal;
begin
  if FPanelStyle = psStyleNone then Exit;

  // Material Design 3 容器样式配色
  BeginRedrawLock;
  FApplyingPanelStyle := True;
  try
    case FPanelStyle of
      psElevated: begin
        // 浮起卡片：白底 + 微边框模拟层级
        BackgroundColor := $FFFFFFFF;
        BackgroundHover := $FFF5F5F5;
        BorderColor := $FFE0E0E0;
        BorderWidth := 0.5;
        if not FCornerRadiusExplicit then
          CornerRadius := 12;
      end;
      psFilled: begin
        // 填充样式：表面变体色底，无边框
        BackgroundColor := $FFF5F5F5;
        BackgroundHover := $FFEEEEEE;
        BorderColor := $FFE0E0E0;
        BorderWidth := 0;
        if not FCornerRadiusExplicit then
          CornerRadius := 12;
      end;
      psOutlined: begin
        // 轮廓样式：白底 + 细边框
        BackgroundColor := $FFFFFFFF;
        BackgroundHover := $FFF5F5F5;
        BorderColor := $FFE0E0E0;
        BorderWidth := 1;
        if not FCornerRadiusExplicit then
          CornerRadius := 12;
      end;
      psSurface: begin
        // 表面样式：最低层级
        BackgroundColor := $FFFAFAFA;
        BackgroundHover := $FFF0F0F0;
        BorderColor := $FFE0E0E0;
        BorderWidth := 0;
        if not FCornerRadiusExplicit then
          CornerRadius := 12;
      end;
      psPrimaryContainer: begin
        // 主色容器：主色浅底
        BackgroundColor := $FFE3F2FD;
        BackgroundHover := $FFBBDEFB;
        BorderColor := $FFBBDEFB;
        BorderWidth := 0;
        if not FCornerRadiusExplicit then
          CornerRadius := 12;
      end;
      psSecondaryContainer: begin
        // 次色容器：次色浅底
        BackgroundColor := $FFF3E5F5;
        BackgroundHover := $FFE1BEE7;
        BorderColor := $FFE1BEE7;
        BorderWidth := 0;
        if not FCornerRadiusExplicit then
          CornerRadius := 12;
      end;
      psErrorContainer: begin
        // 错误容器：错误色浅底
        BackgroundColor := $FFFFEBEE;
        BackgroundHover := $FFFFCDD2;
        BorderColor := $FFFFCDD2;
        BorderWidth := 0;
        if not FCornerRadiusExplicit then
          CornerRadius := 12;
      end;
    end;
  finally
    FApplyingPanelStyle := False;
    EndRedrawLock;
  end;

  if CanRedrawNow then
  begin
    Redraw;
    RedrawDependentSkiaChildren(False);
  end;
end;

function TDSkPanel.GetBackgroundColor: TAlphaColor;
begin
  if not Enabled then
  begin
    // 禁用状态：使用灰色背景
    Result := $FFE0E0E0;
  end
  else if FHoverEnabled and not (csDesigning in ComponentState) and MouseIsInside then
    Result := FBackgroundHover
  else
    Result := inherited GetBackgroundColor;
end;

function TDSkPanel.HasVisualStateChangesOnMouseTrack: Boolean;
begin
  Result := FHoverEnabled;
end;

procedure TDSkPanel.CMEnabledChanged(var Message: TMessage);
begin
  // 基类已处理 Enabled 状态传播给子控件和触发重绘
  inherited;
end;

procedure TDSkPanel.DrawCaption(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LPaint: ISkPaint; LFont: ISkFont; LX, LY: Single; LTextW: Single;
  LCaptionMargin, LOffset: Single;
begin
  LPaint := TSkPaint.Create; LPaint.AntiAlias := True; LPaint.Color := VclColorToAlphaColor(FCaptionFont.Color);
  LX := 0; LY := 0; LFont := GetCaptionFontCache; LTextW := MeasureCaptionText;
  LCaptionMargin := DpiScaleValue(FCaptionMargin);
  LOffset := DpiScaleValue(2);
  case FCaptionPosition of
    cpTopLeft: begin LX := ADest.Left + LCaptionMargin + LOffset; LY := ADest.Top + LCaptionMargin + LFont.Size + LOffset; end;
    cpTopCenter: begin LX := ADest.Left + (ADest.Width - LTextW) / 2; LY := ADest.Top + LCaptionMargin + LFont.Size + LOffset; end;
    cpTopRight: begin LX := ADest.Right - LCaptionMargin - LTextW - LOffset; LY := ADest.Top + LCaptionMargin + LFont.Size + LOffset; end;
    cpLeftCenter: begin LX := ADest.Left + LCaptionMargin + LOffset; LY := ADest.Top + (ADest.Height + LFont.Size) / 2; end;
    cpCenter: begin LX := ADest.Left + (ADest.Width - LTextW) / 2; LY := ADest.Top + (ADest.Height + LFont.Size) / 2; end;
    cpRightCenter: begin LX := ADest.Right - LCaptionMargin - LTextW - LOffset; LY := ADest.Top + (ADest.Height + LFont.Size) / 2; end;
    cpBottomLeft: begin LX := ADest.Left + LCaptionMargin + LOffset; LY := ADest.Bottom - LCaptionMargin - LOffset; end;
    cpBottomCenter: begin LX := ADest.Left + (ADest.Width - LTextW) / 2; LY := ADest.Bottom - LCaptionMargin - LOffset; end;
    cpBottomRight: begin LX := ADest.Right - LCaptionMargin - LTextW - LOffset; LY := ADest.Bottom - LCaptionMargin - LOffset; end;
  end;
  ACanvas.DrawSimpleText(FCaption, LX, LY, LFont, LPaint);
end;

procedure TDSkPanel.InvalidateCaptionCache;
begin
  FCaptionCacheFont := nil;
  FCaptionCacheTypeface := nil;
  FCaptionCacheFontName := '';
  FCaptionCacheFontStyle := [];
  FCaptionCacheFontSize := -1;
  FCaptionCachePPI := 0;
  FCaptionCacheText := '';
  FCaptionCacheTextWidth := 0;
end;

function TDSkPanel.GetCaptionFontCache: ISkFont;
var
  LFontStyle: TSkFontStyle;
  LPPI: Integer;
  LFontSize: Single;
begin
  LPPI := GetEffectivePPI;
  LFontSize := FontSizeToPixels(FCaptionFont);
  if (fsBold in FCaptionFont.Style) and (fsItalic in FCaptionFont.Style) then LFontStyle := TSkFontStyle.BoldItalic
  else if fsBold in FCaptionFont.Style then LFontStyle := TSkFontStyle.Bold
  else if fsItalic in FCaptionFont.Style then LFontStyle := TSkFontStyle.Italic
  else LFontStyle := TSkFontStyle.Normal;

  if (FCaptionCacheFont = nil) or (FCaptionCachePPI <> LPPI) or
    (FCaptionCacheFontName <> FCaptionFont.Name) or
    (FCaptionCacheFontStyle <> FCaptionFont.Style) or
    not SameValue(FCaptionCacheFontSize, LFontSize) then
  begin
    FCaptionCacheTypeface := TSkTypeface.MakeFromName(FCaptionFont.Name, LFontStyle);
    FCaptionCacheFont := TSkFont.Create(FCaptionCacheTypeface, LFontSize);
    FCaptionCacheFontName := FCaptionFont.Name;
    FCaptionCacheFontStyle := FCaptionFont.Style;
    FCaptionCacheFontSize := LFontSize;
    FCaptionCachePPI := LPPI;
    FCaptionCacheText := '';
    FCaptionCacheTextWidth := 0;
  end;
  Result := FCaptionCacheFont;
end;

function TDSkPanel.MeasureCaptionText: Single;
var
  LFont: ISkFont;
begin
  LFont := GetCaptionFontCache;
  if FCaptionCacheText <> FCaption then
  begin
    FCaptionCacheTextWidth := LFont.MeasureText(FCaption);
    FCaptionCacheText := FCaption;
  end;
  Result := FCaptionCacheTextWidth;
end;

procedure TDSkPanel.RequestRedraw;
begin
  if csLoading in ComponentState then
    Exit;
  Redraw;
end;

procedure TDSkPanel.PaintDesignTime(ACanvas: TCanvas); begin inherited; end;

end.
