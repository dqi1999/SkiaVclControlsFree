unit SkiaVclControls.Button;

interface

uses
  System.Classes, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.ImgList, Vcl.ExtCtrls,
  Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  TDSkButton = class(TDSCustomSkControl)
  private
    FButtonText: string;
    FButtonColor: TAlphaColor;
    FButtonHover: TAlphaColor;
    FButtonPressed: TAlphaColor;
    FButtonDisabled: TAlphaColor;
    FButtonChecked: TAlphaColor;
    FFontColor: TAlphaColor;
    FFontHover: TAlphaColor;
    FFontDisabled: TAlphaColor;
    FFontChecked: TAlphaColor;
    FFont: TFont;
    FButtonStyle: TDSkButtonStyle;
    FButtonType: TDSkButtonType;
    FButtonRound: Single;
    FPressed: Boolean;
    FChecked: Boolean;
    FImages: TCustomImageList;
    FImageLink: TChangeLink;
    FImageIndex: TImageIndex;
    FImageAlign: TDSkImageAlign;
    FImageMargin: Integer;
    FGroupMode: Boolean;
    FGroupDividerColor: TAlphaColor;
    FGroupDividerVertical: Boolean;
    FGroupCornerBackgroundColor: TAlphaColor;
    FTextCacheFont: ISkFont;
    FTextCacheTypeface: ISkTypeface;
    FTextCacheFontName: string;
    FTextCacheFontStyle: TFontStyles;
    FTextCacheFontSize: Single;
    FTextCachePPI: Integer;
    FTextCacheText: string;
    FTextCacheWidth: Single;
    FImageCache: ISkImage;
    FImageCacheList: TCustomImageList;
    FImageCacheIndex: TImageIndex;
    FImageCacheWidth: Integer;
    FImageCacheHeight: Integer;
    // 动画相关
    FHoverEffect: TDSkHoverEffect;
    FAnimTimer: TTimer;
    FTime: Double;
    FAnimActive: Boolean;
    // Ripple 效果相关
    FRippleOrigin: TPointF;       // 涟漪起始位置（点击位置）
    FRippleProgress: Single;      // 涟漪动画进度 0~1
    FRippleActive: Boolean;       // 涟漪是否激活
    // 绘制对象缓存
    FFillPaint: ISkPaint;         // 填充画笔缓存
    FStrokePaint: ISkPaint;       // 边框画笔缓存
    FRoundRect: ISkRoundRect;     // 圆角矩形缓存
    FPathBuilder: ISkPathBuilder; // 路径构建器缓存
    // MUI 主题相关
    FMUIColorScheme: TDSkMUIColorScheme;
    FMUIStyle: TDSkMUIStyle;
    FLoading: Boolean;
    procedure SetButtonText(const Value: string);
    procedure SetButtonColor(const Value: TAlphaColor);
    procedure SetButtonHover(const Value: TAlphaColor);
    procedure SetButtonPressed(const Value: TAlphaColor);
    procedure SetButtonDisabled(const Value: TAlphaColor);
    procedure SetButtonChecked(const Value: TAlphaColor);
    procedure SetFontColor(const Value: TAlphaColor);
    procedure SetFontHover(const Value: TAlphaColor);
    procedure SetFontDisabled(const Value: TAlphaColor);
    procedure SetFontChecked(const Value: TAlphaColor);
    procedure SetFont(const Value: TFont);
    procedure FontChanged(Sender: TObject);
    procedure SetButtonStyle(const Value: TDSkButtonStyle);
    procedure SetButtonType(const Value: TDSkButtonType);
    procedure SetButtonRound(const Value: Single);
    procedure SetChecked(const Value: Boolean);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetImageAlign(const Value: TDSkImageAlign);
    procedure SetImageMargin(const Value: Integer);
    procedure SetHoverEffect(const Value: TDSkHoverEffect);
    procedure SetMUIColorScheme(const Value: TDSkMUIColorScheme);
    procedure SetMUIStyle(const Value: TDSkMUIStyle);
    procedure ApplyMUIThemeInternal;
    procedure OnAnimTimer(Sender: TObject);
    procedure UpdateAnimState;
    procedure ImageListChange(Sender: TObject);
    procedure InvalidateTextCache;
    procedure InvalidateImageCache;
    function GetTextFont: ISkFont;
    function MeasureButtonText: Single;
    function GetCachedImage: ISkImage;
    procedure DrawGroupDivider(const ACanvas: ISkCanvas; const ADest: TRectF);
  protected
    procedure Click; override;
    function ShouldClipWindowRegion: Boolean; override;
    function GetBackgroundColor: TAlphaColor; override;
    function DependsOnParentBackground: Boolean; override;
    function DependsOnParentVisualBackground: Boolean; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure PaintDesignTime(ACanvas: TCanvas); override;
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawButtonText(const ACanvas: ISkCanvas; const ADest: TRectF); virtual;
    procedure DrawButtonImage(const ACanvas: ISkCanvas; const ADest: TRectF); virtual;
    procedure DrawHoverEffect(const ACanvas: ISkCanvas; const ADest: TRectF); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function HasVisualStateChangesOnMouseTrack: Boolean; override;
    procedure ResetSettings;
    procedure SetGroupRenderOptions(AGroupMode: Boolean; ADividerColor: TAlphaColor;
      ADividerVertical: Boolean; ACornerBackgroundColor: TAlphaColor);
    property State: Boolean read FChecked;
  published
    property ButtonText: string read FButtonText write SetButtonText;
    property ButtonColor: TAlphaColor read FButtonColor write SetButtonColor;
    property ButtonHover: TAlphaColor read FButtonHover write SetButtonHover;
    property ButtonPressed: TAlphaColor read FButtonPressed write SetButtonPressed;
    property ButtonDisabled: TAlphaColor read FButtonDisabled write SetButtonDisabled;
    property ButtonChecked: TAlphaColor read FButtonChecked write SetButtonChecked;
    property FontColor: TAlphaColor read FFontColor write SetFontColor;
    property FontHover: TAlphaColor read FFontHover write SetFontHover;
    property FontDisabled: TAlphaColor read FFontDisabled write SetFontDisabled;
    property FontChecked: TAlphaColor read FFontChecked write SetFontChecked;
    property Font: TFont read FFont write SetFont;
    property ButtonStyle: TDSkButtonStyle read FButtonStyle write SetButtonStyle;
    property ButtonType: TDSkButtonType read FButtonType write SetButtonType;
    property ButtonRound: Single read FButtonRound write SetButtonRound;
    property Checked: Boolean read FChecked write SetChecked;
    property Images: TCustomImageList read FImages write SetImages;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex;
    property ImageAlign: TDSkImageAlign read FImageAlign write SetImageAlign;
    property ImageMargin: Integer read FImageMargin write SetImageMargin;
    property HoverEffect: TDSkHoverEffect read FHoverEffect write SetHoverEffect default heNone;
    property MUIColorScheme: TDSkMUIColorScheme read FMUIColorScheme write SetMUIColorScheme default muiSchemeNone;
    property MUIStyle: TDSkMUIStyle read FMUIStyle write SetMUIStyle default muiStyleNone;
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
  // 通知父容器（ButtonGroup）按钮被点击的自定义消息
  CM_DSKBUTTON_CLICK = WM_USER + 200;

{ TDSkButton }

constructor TDSkButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImageIndex := -1;
  FImageAlign := iaLeft;
  FImageMargin := 8;
  FHoverEffect := heNone;
  FGroupMode := False;
  FGroupDividerColor := TAlphaColors.Null;
  FGroupDividerVertical := True;
  FGroupCornerBackgroundColor := TAlphaColors.Null;
  FImageLink := TChangeLink.Create;
  FImageLink.OnChange := ImageListChange;
  FTime := 0;
  FAnimActive := False;
  FRippleActive := False;
  FRippleProgress := 0;
  FRippleOrigin := PointF(0, 0);
  FMUIColorScheme := muiSchemeNone;
  FMUIStyle := muiStyleNone;
  FLoading := True;
  InvalidateTextCache;
  InvalidateImageCache;

  // 初始化绘制对象缓存
  FFillPaint := TSkPaint.Create;
  FFillPaint.AntiAlias := True;
  FFillPaint.Style := TSkPaintStyle.Fill;
  FStrokePaint := TSkPaint.Create;
  FStrokePaint.AntiAlias := True;
  FStrokePaint.Style := TSkPaintStyle.Stroke;
  FRoundRect := TSkRoundRect.Create;
  FPathBuilder := TSkPathBuilder.Create;

  // 创建字体对象（与 Panel 的 CaptionFont 一致，支持 IDE 字体编辑器）
  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
  FFont.Name := GetDefaultFontName;
  FFont.Size := 12;

  // 创建动画定时器 (16ms ≈ 60fps)
  FAnimTimer := TTimer.Create(Self);
  FAnimTimer.Interval := 16;
  FAnimTimer.Enabled := False;
  FAnimTimer.OnTimer := OnAnimTimer;

  // 设计时禁用动画定时器
  if csDesigning in ComponentState then
    FAnimTimer.Enabled := False;

  ResetSettings;
  // 构造完成后标记为非加载状态，允许属性设置器触发重绘
  FLoading := False;
end;

destructor TDSkButton.Destroy;
begin
  // 从 ImageList 注销变化通知
  if FImages <> nil then
    FImages.UnRegisterChanges(FImageLink);
  FImageLink.Free;
  FAnimTimer.Free;
  FFont.Free;
  inherited;
end;

procedure TDSkButton.ResetSettings;
begin
  FButtonText := 'Button';
  FButtonColor := $FF1976D2;  // Material Primary
  FButtonHover := $FF42A5F5;  // Material Primary Light
  FButtonPressed := $FF1565C0; // Material Primary Dark
  FButtonDisabled := $FFBDBDBD;
  FButtonChecked := $FF1565C0;
  FFontColor := TAlphaColors.White;
  FFontHover := TAlphaColors.White;
  FFontDisabled := $FF757575;
  FFontChecked := TAlphaColors.White;
  FFont.Name := GetDefaultFontName;
  FFont.Size := 12;
  FFont.Style := [];
  FButtonStyle := bsRoundRect;
  FButtonType := btNormal;
  FButtonRound := 10;
  FPressed := False;
  FChecked := False;
end;

procedure TDSkButton.Loaded;
begin
  inherited;
  FLoading := False;
  // 如果 ButtonText 未设置，使用组件名称作为默认值
  if FButtonText = '' then
    FButtonText := Name;
  // 所有 DFM 属性加载完毕后，应用 MUI 主题
  ApplyMUIThemeInternal;
  // 确保设计模式下触发重绘
  if csDesigning in ComponentState then
    Invalidate;
end;

procedure TDSkButton.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  inherited;
  // ImageList 被删除时，清除引用避免悬挂指针
  if (AOperation = opRemove) and (AComponent = FImages) then
  begin
    FImages := nil;
    InvalidateImageCache;
  end;
end;

procedure TDSkButton.ImageListChange(Sender: TObject);
begin
  // ImageList 尺寸或内容变化时，触发重绘
  InvalidateImageCache;
  if not (csLoading in ComponentState) then Redraw;
end;

procedure TDSkButton.SetMUIColorScheme(const Value: TDSkMUIColorScheme);
begin
  if FMUIColorScheme <> Value then begin
    FMUIColorScheme := Value;
    if not FLoading then
      ApplyMUIThemeInternal;
  end;
end;

procedure TDSkButton.SetMUIStyle(const Value: TDSkMUIStyle);
begin
  if FMUIStyle <> Value then begin
    FMUIStyle := Value;
    if not FLoading then
      ApplyMUIThemeInternal;
  end;
end;

procedure TDSkButton.ApplyMUIThemeInternal;
const
  // Material-UI 颜色常量 (ARGB 格式)，与 MUIHelper 一致
  MUI_PRIMARY_MAIN   = $FF1976D2; MUI_PRIMARY_LIGHT  = $FF42A5F5; MUI_PRIMARY_DARK   = $FF1565C0;
  MUI_SECONDARY_MAIN = $FF9C27B0; MUI_SECONDARY_LIGHT = $FFBA68C8; MUI_SECONDARY_DARK = $FF7B1FA2;
  MUI_ERROR_MAIN     = $FFD32F2F; MUI_ERROR_LIGHT    = $FFEF5350; MUI_ERROR_DARK     = $FFC62828;
  MUI_WARNING_MAIN   = $FFED6C02; MUI_WARNING_LIGHT  = $FFFF9800; MUI_WARNING_DARK   = $FFE65100;
  MUI_INFO_MAIN      = $FF0288D1; MUI_INFO_LIGHT     = $FF03A9F4; MUI_INFO_DARK      = $FF01579B;
  MUI_SUCCESS_MAIN   = $FF2E7D32; MUI_SUCCESS_LIGHT  = $FF4CAF50; MUI_SUCCESS_DARK   = $FF1B5E20;
  MUI_CONTRAST       = $FFFFFFFF;
var
  LColorScheme: TDSkMUIColorScheme;
  LStyle: TDSkMUIStyle;
begin
  // 两个都是 muiNone 时不应用主题，保留 ResetSettings 的默认颜色
  if (FMUIColorScheme = muiSchemeNone) and (FMUIStyle = muiStyleNone) then Exit;
  BeginRedrawLock;
  try
  // 只有一个是 muiNone 时，用另一个的默认值替代
    LColorScheme := FMUIColorScheme;
    LStyle := FMUIStyle;
    if LColorScheme = muiSchemeNone then LColorScheme := muiPrimary;
    if LStyle = muiStyleNone then LStyle := muiContained;
    // 根据颜色方案设置基础色
    case LColorScheme of
      muiPrimary: begin
        FButtonColor := MUI_PRIMARY_MAIN; FButtonHover := MUI_PRIMARY_LIGHT;
        FButtonPressed := MUI_PRIMARY_DARK; BorderColor := MUI_PRIMARY_MAIN;
        FFontColor := MUI_CONTRAST;
      end;
      muiSecondary: begin
        FButtonColor := MUI_SECONDARY_MAIN; FButtonHover := MUI_SECONDARY_LIGHT;
        FButtonPressed := MUI_SECONDARY_DARK; BorderColor := MUI_SECONDARY_MAIN;
        FFontColor := MUI_CONTRAST;
      end;
      muiError: begin
        FButtonColor := MUI_ERROR_MAIN; FButtonHover := MUI_ERROR_LIGHT;
        FButtonPressed := MUI_ERROR_DARK; BorderColor := MUI_ERROR_MAIN;
        FFontColor := MUI_CONTRAST;
      end;
      muiWarning: begin
        FButtonColor := MUI_WARNING_MAIN; FButtonHover := MUI_WARNING_LIGHT;
        FButtonPressed := MUI_WARNING_DARK; BorderColor := MUI_WARNING_MAIN;
        FFontColor := MUI_CONTRAST;
      end;
      muiInfo: begin
        FButtonColor := MUI_INFO_MAIN; FButtonHover := MUI_INFO_LIGHT;
        FButtonPressed := MUI_INFO_DARK; BorderColor := MUI_INFO_MAIN;
        FFontColor := MUI_CONTRAST;
      end;
      muiSuccess: begin
        FButtonColor := MUI_SUCCESS_MAIN; FButtonHover := MUI_SUCCESS_LIGHT;
        FButtonPressed := MUI_SUCCESS_DARK; BorderColor := MUI_SUCCESS_MAIN;
        FFontColor := MUI_CONTRAST;
      end;
    end;
    // 根据样式调整
    case LStyle of
      muiContained: BorderWidth := 0;
      muiOutlined: begin
        FButtonColor := $FFF5F5F5;
        FButtonHover := BorderColor;
        FFontColor := BorderColor;
        FFontHover := MUI_CONTRAST;
        FFontChecked := MUI_CONTRAST;
        BorderWidth := 2;
      end;
      muiText: begin
        FButtonColor := $00000000;
        FButtonHover := BorderColor;
        FFontColor := BorderColor;
        FFontHover := MUI_CONTRAST;
        FFontChecked := MUI_CONTRAST;
        BorderColor := $00000000;
        BorderWidth := 0;
      end;
    end;
    // Contained 样式：悬停/选中字体色与正常色一致
    // Outlined/Text 样式：已在上方单独设置白色悬停字体色
    if LStyle = muiContained then begin
      FFontHover := FFontColor;
      FFontChecked := FFontColor;
    end;
  finally
    EndRedrawLock;
  end;
  // 非加载状态下触发重绘（包括设计模式，以便预览效果）
  if not (csLoading in ComponentState) then
    Redraw;
end;

procedure TDSkButton.SetButtonText(const Value: string);
begin
  if FButtonText <> Value then begin
    FButtonText := Value;
    InvalidateTextCache;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetButtonColor(const Value: TAlphaColor);
begin
  if FButtonColor <> Value then begin
    FButtonColor := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetButtonHover(const Value: TAlphaColor);
begin
  if FButtonHover <> Value then begin
    FButtonHover := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetButtonPressed(const Value: TAlphaColor);
begin
  if FButtonPressed <> Value then begin
    FButtonPressed := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetButtonDisabled(const Value: TAlphaColor);
begin
  if FButtonDisabled <> Value then begin
    FButtonDisabled := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetButtonChecked(const Value: TAlphaColor);
begin
  if FButtonChecked <> Value then begin
    FButtonChecked := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetFontColor(const Value: TAlphaColor);
begin
  if FFontColor <> Value then begin
    FFontColor := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetFontHover(const Value: TAlphaColor);
begin
  if FFontHover <> Value then begin
    FFontHover := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetFontDisabled(const Value: TAlphaColor);
begin
  if FFontDisabled <> Value then begin
    FFontDisabled := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetFontChecked(const Value: TAlphaColor);
begin
  if FFontChecked <> Value then begin
    FFontChecked := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  InvalidateTextCache;
  if not (csLoading in ComponentState) then Redraw;
end;

procedure TDSkButton.FontChanged(Sender: TObject);
begin
  InvalidateTextCache;
  if not (csLoading in ComponentState) then Redraw;
end;

procedure TDSkButton.SetButtonStyle(const Value: TDSkButtonStyle);
begin
  if FButtonStyle <> Value then begin
    FButtonStyle := Value;
    if HandleAllocated then UpdateControlRegion;
    if not (csLoading in ComponentState) then Redraw;
  end;
end;


procedure TDSkButton.SetButtonType(const Value: TDSkButtonType);
begin
  if FButtonType <> Value then begin
    FButtonType := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetButtonRound(const Value: Single);
begin
  if FButtonRound <> Value then begin
    FButtonRound := Value;
    CornerRadii[0] := Value;
    CornerRadii[1] := Value;
    CornerRadii[2] := Value;
    CornerRadii[3] := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetChecked(const Value: Boolean);
begin
  if FChecked <> Value then begin
    FChecked := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then begin
    // 从旧 ImageList 注销变化通知
    if FImages <> nil then
      FImages.UnRegisterChanges(FImageLink);
    FImages := Value;
    // 向新 ImageList 注册变化通知
    if FImages <> nil then
      FImages.RegisterChanges(FImageLink);
    InvalidateImageCache;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetGroupRenderOptions(AGroupMode: Boolean; ADividerColor: TAlphaColor;
  ADividerVertical: Boolean; ACornerBackgroundColor: TAlphaColor);
begin
  if (FGroupMode <> AGroupMode) or (FGroupDividerColor <> ADividerColor) or
     (FGroupDividerVertical <> ADividerVertical) or
     (FGroupCornerBackgroundColor <> ACornerBackgroundColor) then
  begin
    FGroupMode := AGroupMode;
    FGroupDividerColor := ADividerColor;
    FGroupDividerVertical := ADividerVertical;
    FGroupCornerBackgroundColor := ACornerBackgroundColor;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

function TDSkButton.ShouldClipWindowRegion: Boolean;
begin
  // 【最关键一步】告诉基类，按钮也不要让 Windows 系统去硬切 HWND
  // 从而让 Skia 的抗锯齿像素百分之百保留
  Result := False;
end;

function TDSkButton.DependsOnParentBackground: Boolean;
begin
  Result := inherited DependsOnParentBackground and
    ((not FGroupMode) or (FGroupCornerBackgroundColor = TAlphaColors.Null));
end;

function TDSkButton.DependsOnParentVisualBackground: Boolean;
begin
  Result := DependsOnParentBackground;
end;

function TDSkButton.HasVisualStateChangesOnMouseTrack: Boolean;
begin
  Result := (FHoverEffect <> heNone) or (FButtonHover <> FButtonColor) or
    (FFontHover <> FFontColor);
end;

procedure TDSkButton.SetImageIndex(const Value: TImageIndex);
begin
  if FImageIndex <> Value then begin
    FImageIndex := Value;
    InvalidateImageCache;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetImageAlign(const Value: TDSkImageAlign);
begin
  if FImageAlign <> Value then begin
    FImageAlign := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetImageMargin(const Value: Integer);
begin
  if FImageMargin <> Value then begin
    FImageMargin := Value;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.SetHoverEffect(const Value: TDSkHoverEffect);
begin
  if FHoverEffect <> Value then begin
    FHoverEffect := Value;
    UpdateAnimState;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.OnAnimTimer(Sender: TObject);
begin
  FTime := FTime + 0.016; // 16ms 间隔
  // 更新 Ripple 进度（快速扩散，约 0.35 秒完成）
  if FRippleActive then begin
    FRippleProgress := FRippleProgress + 0.045; // 约 0.35 秒完成
    if FRippleProgress >= 1.0 then
      FRippleProgress := 1.0;
  end;
  Redraw;
end;

procedure TDSkButton.UpdateAnimState;
var
  LNeedAnim: Boolean;
begin
  // 设计时禁用动画
  if csDesigning in ComponentState then begin
    FAnimTimer.Enabled := False;
    Exit;
  end;

  // 判断是否需要动画（悬停效果或 Ripple 动画）
  LNeedAnim := ((FHoverEffect <> heNone) and (MouseIsInside or FPressed)) or FRippleActive;
  if LNeedAnim <> FAnimActive then begin
    FAnimActive := LNeedAnim;
    FAnimTimer.Enabled := LNeedAnim;
    if LNeedAnim and not FRippleActive then
      FTime := 0;
  end;
end;



procedure TDSkButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then begin
    FPressed := True;
    // 记录 Ripple 起始位置（点击位置）
    FRippleOrigin := PointF(X, Y);
    FRippleProgress := 0;
    FRippleActive := True;
    UpdateAnimState;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then begin
    FPressed := False;
    if FButtonType = btToggle then
      FChecked := not FChecked;
    // Ripple 动画完成后停止
    FRippleActive := False;
    UpdateAnimState;
    if not (csLoading in ComponentState) then
      Redraw;
  end;
end;

procedure TDSkButton.Click;
begin
  inherited Click;
  // ButtonGroup 是父容器时，用消息把点击转交给父控件管理选中状态。
  if (Parent <> nil) and Parent.HandleAllocated then
    SendMessage(Parent.Handle, CM_DSKBUTTON_CLICK, WPARAM(Self), 0);
end;

procedure TDSkButton.MouseEnter;
begin
  inherited;
  UpdateAnimState;
  if not (csLoading in ComponentState) then
    Redraw;
end;

procedure TDSkButton.MouseLeave;
begin
  inherited;
  UpdateAnimState;
  if not (csLoading in ComponentState) then
    Redraw;
end;

function TDSkButton.GetBackgroundColor: TAlphaColor;
begin
  if (not Enabled) or IsParentDisabled then
    Result := FButtonDisabled
  else if FPressed then
    Result := FButtonPressed
  else if FChecked then
    Result := FButtonChecked
  else if MouseIsInside then
    Result := FButtonHover
  else
    Result := FButtonColor;
end;

procedure TDSkButton.PaintDesignTime(ACanvas: TCanvas);
var
  R: TRect;
  LColor: TAlphaColor;
  LWinColor: TColor;
  LRoundRgn: HRGN;
  LFontColor: TColor;
  LText: string;
  LButtonRound: Integer;
  LSavedDC: Integer;
begin
  R := ClientRect;

  LColor := GetBackgroundColor;
  LWinColor := TColor(
    ((LColor and $FF0000) shr 16) or
    (LColor and $00FF00) or
    ((LColor and $0000FF) shl 16)
  );

  // 保存设备上下文状态
  LSavedDC := SaveDC(ACanvas.Handle);
  try
    ACanvas.Brush.Color := LWinColor;
    ACanvas.Brush.Style := bsSolid;

    case FButtonStyle of
      bsCircle: begin
        LRoundRgn := CreateEllipticRgn(R.Left, R.Top, R.Right, R.Bottom);
        try
          SelectClipRgn(ACanvas.Handle, LRoundRgn);
          ACanvas.FillRect(R);
        finally
          DeleteObject(LRoundRgn);
        end;
        // 恢复裁剪区域后再绘制边框
        SelectClipRgn(ACanvas.Handle, 0);
        ACanvas.Pen.Color := LWinColor;
        ACanvas.Brush.Style := bsClear;
        ACanvas.Ellipse(R.Left, R.Top, R.Right, R.Bottom);
      end;
      bsRoundRect: begin
        LButtonRound := Round(DpiScaleValue(FButtonRound) * 2);
        LRoundRgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom,
          LButtonRound, LButtonRound);
        try
          SelectClipRgn(ACanvas.Handle, LRoundRgn);
          ACanvas.FillRect(R);
        finally
          DeleteObject(LRoundRgn);
        end;
        // 恢复裁剪区域后再绘制边框
        SelectClipRgn(ACanvas.Handle, 0);
        ACanvas.Pen.Color := LWinColor;
        ACanvas.Brush.Style := bsClear;
        ACanvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom,
          LButtonRound, LButtonRound);
      end;
    else
      ACanvas.FillRect(R);
      ACanvas.Pen.Color := clGray;
      ACanvas.Brush.Style := bsClear;
      ACanvas.Rectangle(R);
    end;

    // 确保裁剪区域已清除后再绘制文字
    SelectClipRgn(ACanvas.Handle, 0);
    
    LText := FButtonText;
    if LText <> '' then begin
      if not Enabled then
        LFontColor := TColor(
          ((FFontDisabled and $FF0000) shr 16) or
          (FFontDisabled and $00FF00) or
          ((FFontDisabled and $0000FF) shl 16)
        )
      else
        LFontColor := TColor(
          ((FFontColor and $FF0000) shr 16) or
          (FFontColor and $00FF00) or
          ((FFontColor and $0000FF) shl 16)
        );
      ACanvas.Font.Color := LFontColor;
      ACanvas.Font.Size := FFont.Size;
      ACanvas.Font.Name := FFont.Name;
      ACanvas.Font.Style := FFont.Style;
      ACanvas.Brush.Style := bsClear;
      ACanvas.TextRect(R, LText, [tfCenter, tfVerticalCenter, tfSingleLine]);
    end;
  finally
    // 恢复设备上下文状态
    RestoreDC(ACanvas.Handle, LSavedDC);
  end;
end;

procedure TDSkButton.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
var
  LColor: TAlphaColor;
  LScale: Single;
  LCenter: TPointF;
  LSaveCount: Integer;
  LIsDesigning: Boolean;
  LColorRec: TAlphaColorRec;
  LAdjustedDest: TRectF;
  LRadius: Single;
  LAdj: TSkRoundRectRadii;
  LUniformRadii: Boolean;
  LEdgeInset: Single;
  LBorderWidth: Single;
  LCornerRadius: array[0..3] of Single;
  LNeedCornerBackground: Boolean;
  LClipRoundRect: ISkRoundRect;
begin
  LIsDesigning := csDesigning in ComponentState;
  LColor := GetBackgroundColor;
  LEdgeInset := DpiScaleValue(1.2);
  if FGroupMode then
    LEdgeInset := 0;
  LBorderWidth := DpiScaleValue(BorderWidth);
  LCornerRadius[0] := DpiScaleValue(CornerRadii[0]);
  LCornerRadius[1] := DpiScaleValue(CornerRadii[1]);
  LCornerRadius[2] := DpiScaleValue(CornerRadii[2]);
  LCornerRadius[3] := DpiScaleValue(CornerRadii[3]);
  LNeedCornerBackground := ((CornerRadii[0] > 0) or (CornerRadii[1] > 0) or
    (CornerRadii[2] > 0) or (CornerRadii[3] > 0)) and
    ((FGroupMode and (FGroupCornerBackgroundColor <> TAlphaColors.Null)) or
    DependsOnParentVisualBackground);

  // 计算圆角参数（填充和边框复用）
  LUniformRadii := (LCornerRadius[0] = LCornerRadius[1]) and
    (LCornerRadius[1] = LCornerRadius[2]) and (LCornerRadius[2] = LCornerRadius[3]);

  LSaveCount := ACanvas.Save;
  if LNeedCornerBackground then
  begin
    // 子控件不使用窗口圆角裁剪时，先把整块位图角落填成父背景色或组背景色。
    FFillPaint.AntiAlias := False;
    FFillPaint.Style := TSkPaintStyle.Fill;
    if FGroupMode and (FGroupCornerBackgroundColor <> TAlphaColors.Null) then
      FFillPaint.Color := FGroupCornerBackgroundColor
    else
      FFillPaint.Color := GetParentBackgroundColor;
    ACanvas.DrawRect(ADest, FFillPaint);
  end;

  LScale := 1.0;
  if not LIsDesigning then begin
    if FPressed then LScale := 0.95
    else if MouseIsInside and (FHoverEffect = heScaleUp) then LScale := 1.03;
  end;

  if LScale <> 1.0 then begin
    LCenter := PointF(ADest.Left + ADest.Width / 2, ADest.Top + ADest.Height / 2);
    ACanvas.Translate(LCenter.X, LCenter.Y);
    ACanvas.Scale(LScale, LScale);
    ACanvas.Translate(-LCenter.X, -LCenter.Y);
  end;

  FFillPaint.AntiAlias := True;
  FFillPaint.Style := TSkPaintStyle.Fill;
  if AOpacity < 1.0 then begin
    LColorRec := TAlphaColorRec(LColor);
    LColorRec.A := Round(LColorRec.A * AOpacity);
    FFillPaint.Color := TAlphaColor(LColorRec);
  end else
    FFillPaint.Color := LColor;

  case FButtonStyle of
    bsCircle: begin
      LCenter := PointF(ADest.Left + ADest.Width / 2, ADest.Top + ADest.Height / 2);
      LRadius := (Min(ADest.Width, ADest.Height) / 2) - LEdgeInset;

      FPathBuilder.Reset;
      FPathBuilder.AddCircle(LCenter.X, LCenter.Y, LRadius);

      ACanvas.ClipPath(FPathBuilder.Detach, TSkClipOp.Intersect, True);
      ACanvas.DrawCircle(LCenter, LRadius, FFillPaint);
    end;

    bsRoundRect: begin
      LAdjustedDest := ADest;
      LAdjustedDest.Inflate(-LEdgeInset, -LEdgeInset);

      LAdj[TSkRoundRectCorner.UpperLeft] := PointF(Max(0, LCornerRadius[0] - LEdgeInset), Max(0, LCornerRadius[0] - LEdgeInset));
      LAdj[TSkRoundRectCorner.UpperRight] := PointF(Max(0, LCornerRadius[1] - LEdgeInset), Max(0, LCornerRadius[1] - LEdgeInset));
      LAdj[TSkRoundRectCorner.LowerRight] := PointF(Max(0, LCornerRadius[2] - LEdgeInset), Max(0, LCornerRadius[2] - LEdgeInset));
      LAdj[TSkRoundRectCorner.LowerLeft] := PointF(Max(0, LCornerRadius[3] - LEdgeInset), Max(0, LCornerRadius[3] - LEdgeInset));

      FRoundRect.SetRect(LAdjustedDest, LAdj);
      LClipRoundRect := TSkRoundRect.Create;
      LClipRoundRect.SetRect(LAdjustedDest, LAdj);
      ACanvas.ClipRoundRect(LClipRoundRect, TSkClipOp.Intersect, True);
      ACanvas.DrawRoundRect(FRoundRect, FFillPaint);
    end;

    bsRectangle: begin
      ACanvas.DrawRect(ADest, FFillPaint);
    end;
  end;

  if (BorderWidth > 0) and (BorderColor <> TAlphaColors.Null) then
  begin
    FStrokePaint.AntiAlias := True;
    FStrokePaint.Style := TSkPaintStyle.Stroke;
    FStrokePaint.StrokeWidth := LBorderWidth;
    FStrokePaint.Color := BorderColor;
    FStrokePaint.StrokeJoin := TSkStrokeJoin.Round;

    if FButtonStyle = bsCircle then begin
      LCenter := PointF(ADest.Left + ADest.Width / 2, ADest.Top + ADest.Height / 2);
      ACanvas.DrawCircle(LCenter, (Min(ADest.Width, ADest.Height) / 2) - (LBorderWidth / 2) - LEdgeInset, FStrokePaint);
    end else if FButtonStyle = bsRoundRect then begin
      LAdjustedDest := ADest;
      LAdjustedDest.Inflate(-(LBorderWidth / 2) - LEdgeInset, -(LBorderWidth / 2) - LEdgeInset);

      LAdj[TSkRoundRectCorner.UpperLeft] := PointF(Max(0, LCornerRadius[0] - (LBorderWidth / 2) - LEdgeInset), Max(0, LCornerRadius[0] - (LBorderWidth / 2) - LEdgeInset));
      LAdj[TSkRoundRectCorner.UpperRight] := PointF(Max(0, LCornerRadius[1] - (LBorderWidth / 2) - LEdgeInset), Max(0, LCornerRadius[1] - (LBorderWidth / 2) - LEdgeInset));
      LAdj[TSkRoundRectCorner.LowerRight] := PointF(Max(0, LCornerRadius[2] - (LBorderWidth / 2) - LEdgeInset), Max(0, LCornerRadius[2] - (LBorderWidth / 2) - LEdgeInset));
      LAdj[TSkRoundRectCorner.LowerLeft] := PointF(Max(0, LCornerRadius[3] - (LBorderWidth / 2) - LEdgeInset), Max(0, LCornerRadius[3] - (LBorderWidth / 2) - LEdgeInset));
      FRoundRect.SetRect(LAdjustedDest, LAdj);
      ACanvas.DrawRoundRect(FRoundRect, FStrokePaint);
    end else begin
      ACanvas.DrawRect(ADest, FStrokePaint);
    end;
  end;

  if FGroupMode and (FGroupDividerColor <> TAlphaColors.Null) then
    DrawGroupDivider(ACanvas, ADest);

  // 绘制 Ripple 效果或悬停效果
  if not LIsDesigning then begin
    if FRippleActive and (FRippleProgress < 1.0) then
      DrawHoverEffect(ACanvas, ADest)
    else if MouseIsInside and (FHoverEffect <> heNone) then
      DrawHoverEffect(ACanvas, ADest);
  end;

  DrawButtonText(ACanvas, ADest);

  if (FImages <> nil) and (FImageIndex >= 0) then
    DrawButtonImage(ACanvas, ADest);

  ACanvas.RestoreToCount(LSaveCount);
end;

procedure TDSkButton.DrawGroupDivider(const ACanvas: ISkCanvas; const ADest: TRectF);
begin
  // ButtonGroup 的父控件绘制会被子 HWND 盖住，所以分隔线由按钮自己画。
  FStrokePaint.AntiAlias := False;
  FStrokePaint.Style := TSkPaintStyle.Stroke;
  FStrokePaint.StrokeWidth := DpiScaleValue(1);
  FStrokePaint.Color := FGroupDividerColor;

  if FGroupDividerVertical then
    ACanvas.DrawLine(PointF(ADest.Left + DpiScaleValue(0.5), ADest.Top + DpiScaleValue(1)),
      PointF(ADest.Left + DpiScaleValue(0.5), ADest.Bottom - DpiScaleValue(1)), FStrokePaint)
  else
    ACanvas.DrawLine(PointF(ADest.Left + DpiScaleValue(1), ADest.Top + DpiScaleValue(0.5)),
      PointF(ADest.Right - DpiScaleValue(1), ADest.Top + DpiScaleValue(0.5)), FStrokePaint);
end;

procedure TDSkButton.DrawHoverEffect(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LPulse: Single;
  LCenter: TPointF;
  LGlowSize: Single;
  LButtonRound: Single;
  LRippleRadius: Single;
  LRippleAlpha: Single;
begin
  LButtonRound := DpiScaleValue(FButtonRound);
  case FHoverEffect of
    heRipple: begin
      // MUI 风格 Ripple：从点击位置快速扩散
      if FRippleActive and (FRippleProgress < 1.0) then begin
        // 计算最大半径（需要覆盖整个按钮）
        LRippleRadius := Sqrt(Sqr(ADest.Width) + Sqr(ADest.Height)) * 0.7;
        // 使用 ease-out 缓动函数，开始快后面慢
        LPulse := 1.0 - Sqr(1.0 - FRippleProgress);
        // 透明度从 0.35 渐变到 0
        LRippleAlpha := 0.35 * (1.0 - FRippleProgress);

        FFillPaint.Style := TSkPaintStyle.Fill;
        FFillPaint.Color := $FFFFFF;
        FFillPaint.AntiAlias := True;
        FFillPaint.AlphaF := LRippleAlpha;
        ACanvas.DrawCircle(FRippleOrigin, LPulse * LRippleRadius, FFillPaint);
      end;
    end;

    heGlow: begin
      // 发光边框效果
      FFillPaint.Style := TSkPaintStyle.Stroke;
      FFillPaint.StrokeWidth := DpiScaleValue(3);
      FFillPaint.Color := $FFFFFF;
      FFillPaint.AntiAlias := True;
      // 呼吸式透明度变化
      FFillPaint.AlphaF := 0.2 + (Sin(FTime * 3) * 0.15);
      // 模糊效果
      FFillPaint.MaskFilter := TSkMaskFilter.MakeBlur(TSkBlurStyle.Solid, DpiScaleValue(4));

      case FButtonStyle of
        bsCircle: begin
          LCenter := PointF(ADest.Left + ADest.Width / 2, ADest.Top + ADest.Height / 2);
          ACanvas.DrawCircle(LCenter, Min(ADest.Width, ADest.Height) / 2 - DpiScaleValue(1), FFillPaint);
        end;
        bsRoundRect: begin
          ACanvas.DrawRoundRect(ADest, LButtonRound, LButtonRound, FFillPaint);
        end;
      else
        ACanvas.DrawRect(ADest, FFillPaint);
      end;
    end;

    heScaleUp: begin
      // 缩放效果在 Draw 方法中已处理，此处无需额外绘制
    end;
  end;
end;

procedure TDSkButton.DrawButtonText(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LX, LY: Single;
  LFontColor: TAlphaColor;
  LHasImage: Boolean;
  LTextW, LTotalW, LTotalH: Single;
  LFontSize, LImageMargin, LBaselineOffset: Single;
  LFont: ISkFont;
  LTextPaint: ISkPaint;
begin
  if FButtonText = '' then Exit;

  // 根据按钮状态选择字体颜色：禁用 > 选中 > 悬停 > 普通
  if (not Enabled) or IsParentDisabled then
    LFontColor := FFontDisabled
  else if FChecked then
    LFontColor := FFontChecked
  else if MouseIsInside then
    LFontColor := FFontHover
  else
    LFontColor := FFontColor;

  // 使用独立的画笔绘制文字，避免状态污染
  LTextPaint := TSkPaint.Create;
  LTextPaint.AntiAlias := True;
  LTextPaint.Style := TSkPaintStyle.Fill;
  LTextPaint.Color := LFontColor;
  LFont := GetTextFont;
  LFontSize := LFont.Size;
  LImageMargin := DpiScaleValue(FImageMargin);
  LBaselineOffset := DpiScaleValue(2);

  // 根据图标位置调整文字布局
  LHasImage := (FImages <> nil) and (FImageIndex >= 0);
  LTextW := MeasureButtonText;

  if LHasImage and (FImageAlign = iaCenter) then begin
    // 图标居中时，不显示文字
    Exit;
  end else if LHasImage and (FImageAlign in [iaLeft, iaRight]) then begin
    // 图标在左/右时，文字和图标水平排列居中
    LTotalW := FImages.Width + LImageMargin + LTextW;
    LX := ADest.Left + (ADest.Width - LTotalW) / 2;
    if FImageAlign = iaLeft then
      LX := LX + FImages.Width + LImageMargin;
    LY := ADest.Top + (ADest.Height + LFont.Size) / 2 - LBaselineOffset;
  end else if LHasImage and (FImageAlign in [iaTop, iaBottom]) then begin
    // 图标在上/下时，文字水平居中，垂直偏移
    LX := ADest.Left + (ADest.Width - LTextW) / 2;
    LTotalH := FImages.Height + LImageMargin;
    if FImageAlign = iaTop then
      LY := ADest.Top + LTotalH + (ADest.Height - LTotalH + LFont.Size) / 2 - LBaselineOffset
    else
      LY := ADest.Top + (ADest.Height - LTotalH + LFont.Size) / 2 - LBaselineOffset - LImageMargin;
  end else begin
    // 无图标或默认：文字居中
    LX := ADest.Left + (ADest.Width - LTextW) / 2;
    LY := ADest.Top + (ADest.Height + LFont.Size) / 2 - LBaselineOffset;
  end;

  ACanvas.DrawSimpleText(FButtonText, LX, LY, LFont, LTextPaint);
end;

procedure TDSkButton.DrawButtonImage(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LSkImage: ISkImage;
  LImgW, LImgH: Integer;
  LX, LY: Single;
  LImageMargin: Single;
begin
  if (FImages = nil) or (FImageIndex < 0) then Exit;

  LImgW := FImages.Width;
  LImgH := FImages.Height;
  LImageMargin := DpiScaleValue(FImageMargin);

  LSkImage := GetCachedImage;
  if LSkImage = nil then Exit;

  // 根据 ImageAlign 计算图标绘制位置
  case FImageAlign of
    iaLeft:
      begin LX := ADest.Left + LImageMargin; LY := ADest.Top + (ADest.Height - LImgH) / 2; end;
    iaRight:
      begin LX := ADest.Right - LImageMargin - LImgW; LY := ADest.Top + (ADest.Height - LImgH) / 2; end;
    iaTop:
      begin LX := ADest.Left + (ADest.Width - LImgW) / 2; LY := ADest.Top + LImageMargin; end;
    iaBottom:
      begin LX := ADest.Left + (ADest.Width - LImgW) / 2; LY := ADest.Bottom - LImageMargin - LImgH; end;
    iaCenter:
      begin LX := ADest.Left + (ADest.Width - LImgW) / 2; LY := ADest.Top + (ADest.Height - LImgH) / 2; end;
  else
    begin LX := ADest.Left + LImageMargin; LY := ADest.Top + (ADest.Height - LImgH) / 2; end;
  end;

  ACanvas.DrawImage(LSkImage, LX, LY);
end;

procedure TDSkButton.InvalidateTextCache;
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

procedure TDSkButton.InvalidateImageCache;
begin
  FImageCache := nil;
  FImageCacheList := nil;
  FImageCacheIndex := -1;
  FImageCacheWidth := 0;
  FImageCacheHeight := 0;
end;

function TDSkButton.GetTextFont: ISkFont;
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

function TDSkButton.MeasureButtonText: Single;
var
  LFont: ISkFont;
begin
  LFont := GetTextFont;
  if FTextCacheText <> FButtonText then
  begin
    FTextCacheWidth := LFont.MeasureText(FButtonText);
    FTextCacheText := FButtonText;
  end;
  Result := FTextCacheWidth;
end;

function TDSkButton.GetCachedImage: ISkImage;
var
  LBitmap: Vcl.Graphics.TBitmap;
begin
  if (FImages = nil) or (FImageIndex < 0) then
    Exit(nil);

  if (FImageCache = nil) or (FImageCacheList <> FImages) or
    (FImageCacheIndex <> FImageIndex) or (FImageCacheWidth <> FImages.Width) or
    (FImageCacheHeight <> FImages.Height) then
  begin
    LBitmap := Vcl.Graphics.TBitmap.Create;
    try
      LBitmap.SetSize(FImages.Width, FImages.Height);
      LBitmap.PixelFormat := pf32Bit;
      LBitmap.AlphaFormat := afPremultiplied;
      FillChar(LBitmap.ScanLine[FImages.Height - 1]^, FImages.Width * FImages.Height * 4, 0);
      FImages.GetBitmap(FImageIndex, LBitmap);
      FImageCache := BitmapToSkImage(LBitmap);
      FImageCacheList := FImages;
      FImageCacheIndex := FImageIndex;
      FImageCacheWidth := FImages.Width;
      FImageCacheHeight := FImages.Height;
    finally
      LBitmap.Free;
    end;
  end;
  Result := FImageCache;
end;

end.
