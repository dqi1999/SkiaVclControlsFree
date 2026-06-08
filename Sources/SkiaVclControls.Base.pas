unit SkiaVclControls.Base;

interface

uses
  System.Classes, System.Types, System.UITypes, System.Math, System.Rtti,
  Vcl.Controls, Vcl.Forms, Vcl.Graphics, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows;

function VclColorToAlphaColor(AColor: TColor): TAlphaColor;
{ 获取默认字体名称，优先使用 Microsoft YaHei（微软雅黑）以支持中文，
  若系统未安装则回退到 Tahoma。结果缓存，仅首次调用时检测。 }
function GetDefaultFontName: string;

type
  { TDSCustomSkControl - Skia控件基类
    所有Skia自定义控件的父类，提供圆角、背景色、边框等基础功能 }
  TDSCustomSkControl = class abstract(TSkCustomWinControl)
  private
    FCornerRadius: Single;      // 圆角半径，0=直角
    FCornerRadii: array[0..3] of Single; // 逐角圆角半径: 0=TL, 1=TR, 2=BR, 3=BL
    FBackgroundColor: TAlphaColor; // 背景色(含透明度)
    FBorderColor: TAlphaColor;  // 边框颜色
    FBorderWidth: Single;       // 边框宽度，0=无边框
    FMouseIsInside: Boolean;    // 鼠标是否在控件内(用于悬停效果)
    FRedrawLockCount: Integer;  // 批量更新时暂时抑制即时重绘
    FOnMouseEnter: TNotifyEvent; // 鼠标进入事件
    FOnMouseLeave: TNotifyEvent; // 鼠标离开事件
    procedure SetCornerRadius(const Value: Single);
    procedure SetBackgroundColor(const Value: TAlphaColor);
    procedure SetBorderColor(const Value: TAlphaColor);
    procedure SetBorderWidth(const Value: Single);
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    function GetCornerRadii(Index: Integer): Single;
    procedure SetCornerRadii(Index: Integer; Value: Single);
    function HasAnyCornerRadius: Boolean;

  protected
    function GetBackgroundColor: TAlphaColor; virtual;
    function GetParentBackgroundColor: TAlphaColor; virtual;
    function GetParentBaseBackgroundColor: TAlphaColor; virtual;
    procedure PaintDesignTime(ACanvas: TCanvas); virtual;
    procedure DrawParentBackground(const ACanvas: ISkCanvas; const ADest: TRectF;
      const AUseVisualState: Boolean = True); virtual;
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawBackground(const ACanvas: ISkCanvas; const ADest: TRectF; AOpacity: Single); virtual;
    procedure DrawBorderWithPath(const ACanvas: ISkCanvas; const ADest: TRectF; AOpacity: Single); virtual;
    procedure MouseEnter; virtual;
    procedure MouseLeave; virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Resize; override;
    function ShouldClipWindowRegion: Boolean; virtual;
    procedure UpdateControlRegion; virtual;
    procedure CornerRadiusChanged; virtual;
    function IsCornerRadiusStored: Boolean; virtual;
    function NeedsParentBackgroundFill: Boolean; virtual;
    function DependsOnParentBackground: Boolean; virtual;
    function DependsOnParentVisualBackground: Boolean; virtual;
    procedure RedrawDependentSkiaChildren(AVisualStateOnly: Boolean = False);
    procedure BeginRedrawLock;
    procedure EndRedrawLock;
    function CanRedrawNow: Boolean;
    function GetEffectivePPI: Integer;
    function DpiScale: Single;
    function FontSizeToPixels(AFont: TFont): Single;
    // 检查父控件链中是否有禁用的父控件（用于绘制时判断禁用状态）
    function IsParentDisabled: Boolean;
    property MouseIsInside: Boolean read FMouseIsInside;
    property CornerRadius: Single read FCornerRadius write SetCornerRadius;
    property BackgroundColor: TAlphaColor read FBackgroundColor write SetBackgroundColor;
    property BorderColor: TAlphaColor read FBorderColor write SetBorderColor;
    property BorderWidth: Single read FBorderWidth write SetBorderWidth;
  public
    function DpiScaleValue(AValue: Single): integer; overload;
//    function DpiScaleValue(AValue: Integer): Integer; overload;
    constructor Create(AOwner: TComponent); override;
    // 逐角圆角半径属性（0=TL, 1=TR, 2=BR, 3=BL）
    function HasVisualStateChangesOnMouseTrack: Boolean; virtual;
    property CornerRadii[Index: Integer]: Single read GetCornerRadii write SetCornerRadii;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  published
    property Left; property Top; property Width; property Height;
    property Align; property Anchors; property Constraints;
    property Enabled; property Visible; property OnClick; property OnDblClick;
    property OnMouseDown; property OnMouseMove; property OnMouseUp;
  end;

implementation

var
  _DefaultFontName: string;

function GetDefaultFontName: string;
const
  CJK_FONT_NAMES: array[0..2] of string = (
    'Microsoft YaHei', 'Microsoft YaHei UI', #$5FAE#$8F6F#$96C5#$9ED1);
var
  I: Integer;
begin
  if _DefaultFontName = '' then
  begin
    _DefaultFontName := 'Tahoma';
    for I := Low(CJK_FONT_NAMES) to High(CJK_FONT_NAMES) do
      if Screen.Fonts.IndexOf(CJK_FONT_NAMES[I]) >= 0 then
      begin
        _DefaultFontName := CJK_FONT_NAMES[I];
        Break;
      end;
  end;
  Result := _DefaultFontName;
end;

procedure SetParentBackgroundColor(AControl: TSkCustomWinControl; AValue: TAlphaColor);
var
  LCtx: TRttiContext;
  LField: TRttiField;
begin
  LField := LCtx.GetType(TSkCustomWinControl.ClassInfo).GetField('FBackgroundColor');
  if LField <> nil then
    LField.SetValue(AControl, AValue);
end;

function VclColorToAlphaColor(AColor: TColor): TAlphaColor;
var
  LRGB: COLORREF;
begin
  // TColor 可能是负数或系统色，先归一化成 RGB，再拼成 Skia 需要的 ARGB。
  LRGB := ColorToRGB(AColor);
  Result := $FF000000 or
    (TAlphaColor(GetRValue(LRGB)) shl 16) or
    (TAlphaColor(GetGValue(LRGB)) shl 8) or
    TAlphaColor(GetBValue(LRGB));
end;

constructor TDSCustomSkControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCornerRadius := 10;
  FCornerRadii[0] := 10; // TL
  FCornerRadii[1] := 10; // TR
  FCornerRadii[2] := 10; // BR
  FCornerRadii[3] := 10; // BL
  FBackgroundColor := TAlphaColors.White;
  FBorderColor := TAlphaColors.Gray;
  FBorderWidth := 2;
  FMouseIsInside := False;
  FRedrawLockCount := 0;
  Width := 120;
  Height := 40;

  DoubleBuffered := True;
  ParentBackground := False;
  ControlStyle := ControlStyle - [csOpaque] + [csAcceptsControls];
end;

function TDSCustomSkControl.GetEffectivePPI: Integer;
var
  LDC: HDC;
  LForm: TCustomForm;
begin
  Result := 96;

  if HandleAllocated then
  begin
    Result := GetDpiForWindow(Handle);
    if Result > 0 then
      Exit;
  end;

  if (Parent <> nil) and Parent.HandleAllocated then
  begin
    Result := GetDpiForWindow(Parent.Handle);
    if Result > 0 then
      Exit;
  end;

  LForm := GetParentForm(Self);
  if (LForm <> nil) and LForm.HandleAllocated then
  begin
    Result := GetDpiForWindow(LForm.Handle);
    if Result > 0 then
      Exit;
  end;

  LDC := GetDC(0);
  try
    if LDC <> 0 then
      Result := GetDeviceCaps(LDC, LOGPIXELSX);
  finally
    if LDC <> 0 then
      ReleaseDC(0, LDC);
  end;

  if Result <= 0 then
    Result := 96;
end;

function TDSCustomSkControl.DpiScale: Single;
begin
  Result := GetEffectivePPI / 96;
end;



function TDSCustomSkControl.DpiScaleValue(AValue: Single): integer;
begin
  if AValue <= 0 then
    Result := 0
  else
    Result := Max(1, Round(AValue * DpiScale));
end;

function TDSCustomSkControl.FontSizeToPixels(AFont: TFont): Single;
begin
  // VCL 的 Font.Size 是点数，Skia 的字体尺寸是像素；这里按当前窗口 DPI 做统一换算。
  Result := Max(1.0, AFont.Size * GetEffectivePPI / 72);
end;

procedure TDSCustomSkControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle and not WS_EX_TRANSPARENT;
  Params.WindowClass.hbrBackground := 0;
end;

procedure TDSCustomSkControl.CreateWnd;
begin
  inherited CreateWnd;
  if HandleAllocated then
  begin
    SetClassLongPtr(Handle, GCL_HBRBACKGROUND, 0);
    UpdateControlRegion;
  end;
end;

procedure TDSCustomSkControl.Resize;
begin
  inherited Resize;
  if HandleAllocated then UpdateControlRegion;
end;

function TDSCustomSkControl.ShouldClipWindowRegion: Boolean;
begin
  Result := not (Parent is TDSCustomSkControl);
end;

procedure TDSCustomSkControl.UpdateControlRegion;
var
  LRegion: HRGN;
begin
  if not HandleAllocated then Exit;

  if not ShouldClipWindowRegion then
  begin
    // 不裁剪时清除区域，使用 False 避免触发不必要的重绘
    SetWindowRgn(Handle, 0, False);
    Exit;
  end;

  if (FCornerRadius > 0) then
  begin
    LRegion := CreateRoundRectRgn(0, 0, Width + 1, Height + 1,
      Round(DpiScaleValue(FCornerRadius) * 2),
      Round(DpiScaleValue(FCornerRadius) * 2));
    if LRegion <> 0 then
    begin
      // 使用 False 避免触发不必要的重绘
      if SetWindowRgn(Handle, LRegion, False) = 0 then
        DeleteObject(LRegion);
    end;
  end else
    SetWindowRgn(Handle, 0, False);
end;

function TDSCustomSkControl.GetCornerRadii(Index: Integer): Single;
begin
  Result := FCornerRadii[Index];
end;

function TDSCustomSkControl.HasAnyCornerRadius: Boolean;
begin
  Result := (FCornerRadii[0] > 0) or (FCornerRadii[1] > 0) or
    (FCornerRadii[2] > 0) or (FCornerRadii[3] > 0);
end;

procedure TDSCustomSkControl.SetCornerRadii(Index: Integer; Value: Single);
begin
  if FCornerRadii[Index] <> Value then begin
    FCornerRadii[Index] := Value;
    if CanRedrawNow then Redraw;
  end;
end;

procedure TDSCustomSkControl.SetCornerRadius(const Value: Single);
begin
  if FCornerRadius <> Value then begin
    FCornerRadius := Value;
    // 同步所有四个角的半径
    FCornerRadii[0] := Value;
    FCornerRadii[1] := Value;
    FCornerRadii[2] := Value;
    FCornerRadii[3] := Value;
    if HandleAllocated then UpdateControlRegion;
    CornerRadiusChanged;
    if CanRedrawNow then Redraw;
  end;
end;

procedure TDSCustomSkControl.SetBackgroundColor(const Value: TAlphaColor);
var
  i: Integer;
begin
  if FBackgroundColor <> Value then
  begin
    FBackgroundColor := Value;
    // 同步 TSkCustomWinControl.FBackgroundColor（strict private），
    // 确保 IsOpaque 判定正确：alpha < 255 时创建父背景缓冲区实现透明渲染
    SetParentBackgroundColor(Self, Value);
    if CanRedrawNow then
    begin
      Redraw;
      RedrawDependentSkiaChildren(False);
    end;
  end;
end;
procedure TDSCustomSkControl.SetBorderColor(const Value: TAlphaColor);
begin if FBorderColor <> Value then begin FBorderColor := Value; if CanRedrawNow then Redraw; end; end;
procedure TDSCustomSkControl.SetBorderWidth(const Value: Single);
begin if FBorderWidth <> Value then begin FBorderWidth := Value; if CanRedrawNow then Redraw; end; end;

procedure TDSCustomSkControl.WMPaint(var Message: TWMPaint);
begin
  inherited;
end;

procedure TDSCustomSkControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TDSCustomSkControl.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
var
  LRoundRect: ISkRoundRect;
  LAdjustedDest: TRectF;
  LAdjustedRadius: Single;
  LHasRadius: Boolean;
  LUniform: Boolean;
  LAdj: TSkRoundRectRadii;
  LEdgeInset: Single;
  LRadius: array[0..3] of Single;
begin
  if NeedsParentBackgroundFill then
    DrawParentBackground(ACanvas, ADest);

  ACanvas.Save;
  try
    LEdgeInset := DpiScaleValue(1.2);
    LRadius[0] := DpiScaleValue(FCornerRadii[0]);
    LRadius[1] := DpiScaleValue(FCornerRadii[1]);
    LRadius[2] := DpiScaleValue(FCornerRadii[2]);
    LRadius[3] := DpiScaleValue(FCornerRadii[3]);

    // 只要有一个角有半径，就需要使用圆角裁剪。
    LHasRadius := HasAnyCornerRadius;
    if LHasRadius then begin
      LRoundRect := TSkRoundRect.Create;

      LAdjustedDest := ADest;
      LAdjustedDest.Inflate(-LEdgeInset, -LEdgeInset);

      // 检查四个角是否一致
      LUniform := (LRadius[0] = LRadius[1]) and
                  (LRadius[1] = LRadius[2]) and
                  (LRadius[2] = LRadius[3]);

      if LUniform then begin
        LAdjustedRadius := Max(0, LRadius[0] - LEdgeInset);
        LRoundRect.SetRect(LAdjustedDest, LAdjustedRadius, LAdjustedRadius);
      end else begin
        LAdj[TSkRoundRectCorner.UpperLeft] := PointF(Max(0, LRadius[0] - LEdgeInset), Max(0, LRadius[0] - LEdgeInset));
        LAdj[TSkRoundRectCorner.UpperRight] := PointF(Max(0, LRadius[1] - LEdgeInset), Max(0, LRadius[1] - LEdgeInset));
        LAdj[TSkRoundRectCorner.LowerRight] := PointF(Max(0, LRadius[2] - LEdgeInset), Max(0, LRadius[2] - LEdgeInset));
        LAdj[TSkRoundRectCorner.LowerLeft] := PointF(Max(0, LRadius[3] - LEdgeInset), Max(0, LRadius[3] - LEdgeInset));
        LRoundRect.SetRect(LAdjustedDest, LAdj);
      end;

      ACanvas.ClipRoundRect(LRoundRect, TSkClipOp.Intersect, True);
    end;
    DrawBackground(ACanvas, ADest, AOpacity);
  finally
    ACanvas.Restore;
  end;

  DrawBorderWithPath(ACanvas, ADest, AOpacity);
end;

procedure TDSCustomSkControl.DrawParentBackground(const ACanvas: ISkCanvas; const ADest: TRectF;
  const AUseVisualState: Boolean);
var
  LCornerBgPaint: ISkPaint;
begin
  // 先把父控件背景铺满当前区域，供需要“视觉透明”的子控件复用。
  LCornerBgPaint := TSkPaint.Create;
  LCornerBgPaint.AntiAlias := False;
  if AUseVisualState then
    LCornerBgPaint.Color := GetParentBackgroundColor
  else
    LCornerBgPaint.Color := GetParentBaseBackgroundColor;
  LCornerBgPaint.Style := TSkPaintStyle.Fill;
  ACanvas.DrawRect(ADest, LCornerBgPaint);
end;

procedure TDSCustomSkControl.DrawBackground(const ACanvas: ISkCanvas; const ADest: TRectF; AOpacity: Single);
var
  LPaint: ISkPaint;
  LColor: TAlphaColor;
  LColorRec: TAlphaColorRec;
begin
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LColor := GetBackgroundColor;
  if AOpacity < 1.0 then begin
    LColorRec := TAlphaColorRec(LColor);
    LColorRec.A := Round(LColorRec.A * AOpacity);
    LPaint.Color := TAlphaColor(LColorRec);
  end else
    LPaint.Color := LColor;
  LPaint.Style := TSkPaintStyle.Fill;
  ACanvas.DrawRect(ADest, LPaint);
end;

procedure TDSCustomSkControl.DrawBorderWithPath(const ACanvas: ISkCanvas; const ADest: TRectF; AOpacity: Single);
var
  LPaint: ISkPaint;
  LPathBuilder: ISkPathBuilder;
  LPath: ISkPath;
  LAdjustedDest: TRectF;
  LAdjustedRadius: Single;
  LSkRoundRect: ISkRoundRect;
  LColor: TAlphaColor;
  LColorRec: TAlphaColorRec;
  LHasRadius: Boolean;
  LUniform: Boolean;
  LAdj: TSkRoundRectRadii;
  LBorderWidth: Single;
  LEdgeInset: Single;
  LRadius: array[0..3] of Single;
begin
  if (FBorderWidth <= 0) or (FBorderColor = TAlphaColors.Null) then Exit;

  LBorderWidth := DpiScaleValue(FBorderWidth);
  LEdgeInset := DpiScaleValue(1.2);
  LRadius[0] := DpiScaleValue(FCornerRadii[0]);
  LRadius[1] := DpiScaleValue(FCornerRadii[1]);
  LRadius[2] := DpiScaleValue(FCornerRadii[2]);
  LRadius[3] := DpiScaleValue(FCornerRadii[3]);

  LAdjustedDest := ADest;
  LAdjustedDest.Inflate(-(LBorderWidth / 2) - LEdgeInset, -(LBorderWidth / 2) - LEdgeInset);

  LSkRoundRect := TSkRoundRect.Create;
  LHasRadius := (LRadius[0] > 0) or (LRadius[1] > 0) or
    (LRadius[2] > 0) or (LRadius[3] > 0);

  if LHasRadius then begin
    LUniform := (LRadius[0] = LRadius[1]) and
                (LRadius[1] = LRadius[2]) and
                (LRadius[2] = LRadius[3]);

    if LUniform then begin
      LAdjustedRadius := Max(0, LRadius[0] - (LBorderWidth / 2) - LEdgeInset);
      LSkRoundRect.SetRect(LAdjustedDest, LAdjustedRadius, LAdjustedRadius);
    end else begin
      LAdj[TSkRoundRectCorner.UpperLeft] := PointF(Max(0, LRadius[0] - (LBorderWidth / 2) - LEdgeInset), Max(0, LRadius[0] - (LBorderWidth / 2) - LEdgeInset));
      LAdj[TSkRoundRectCorner.UpperRight] := PointF(Max(0, LRadius[1] - (LBorderWidth / 2) - LEdgeInset), Max(0, LRadius[1] - (LBorderWidth / 2) - LEdgeInset));
      LAdj[TSkRoundRectCorner.LowerRight] := PointF(Max(0, LRadius[2] - (LBorderWidth / 2) - LEdgeInset), Max(0, LRadius[2] - (LBorderWidth / 2) - LEdgeInset));
      LAdj[TSkRoundRectCorner.LowerLeft] := PointF(Max(0, LRadius[3] - (LBorderWidth / 2) - LEdgeInset), Max(0, LRadius[3] - (LBorderWidth / 2) - LEdgeInset));
      LSkRoundRect.SetRect(LAdjustedDest, LAdj);
    end;
  end else
    LSkRoundRect.SetRect(LAdjustedDest, 0, 0);

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Stroke;
  LPaint.StrokeWidth := LBorderWidth;
  LColor := FBorderColor;
  if AOpacity < 1.0 then begin
    LColorRec := TAlphaColorRec(LColor);
    LColorRec.A := Round(LColorRec.A * AOpacity);
    LPaint.Color := TAlphaColor(LColorRec);
  end else
    LPaint.Color := LColor;
  if LHasRadius then
    LPaint.StrokeJoin := TSkStrokeJoin.Round
  else
    LPaint.StrokeJoin := TSkStrokeJoin.Miter;

  if not LHasRadius then
    ACanvas.DrawRect(LAdjustedDest, LPaint)
  else if LUniform then
    ACanvas.DrawRoundRect(LSkRoundRect, LPaint)
  else
  begin
    LPathBuilder := TSkPathBuilder.Create;
    LPathBuilder.AddRoundRect(LSkRoundRect);
    LPath := LPathBuilder.Detach;
    ACanvas.DrawPath(LPath, LPaint);
  end;
end;

function TDSCustomSkControl.GetBackgroundColor: TAlphaColor; begin Result := FBackgroundColor; end;

function TDSCustomSkControl.GetParentBaseBackgroundColor: TAlphaColor;
var
  LColor: TColor;
begin
  if Parent is TDSCustomSkControl then
    Result := TDSCustomSkControl(Parent).BackgroundColor
  else if Parent <> nil then
  begin
    LColor := Parent.Brush.Color;
    Result := VclColorToAlphaColor(LColor);
  end
  else
    Result := TAlphaColors.White;
end;

function TDSCustomSkControl.GetParentBackgroundColor: TAlphaColor;
begin
  if Parent is TDSCustomSkControl then
    Result := TDSCustomSkControl(Parent).GetBackgroundColor
  else
    Result := GetParentBaseBackgroundColor;
end;

procedure TDSCustomSkControl.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FMouseIsInside := True;
  MouseEnter;
  if not (csDesigning in ComponentState) and not (csLoading in ComponentState) and
    HasVisualStateChangesOnMouseTrack then
  begin
    Redraw;
    RedrawDependentSkiaChildren(True);
  end;
end;

procedure TDSCustomSkControl.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FMouseIsInside := False;
  MouseLeave;
  if not (csDesigning in ComponentState) and not (csLoading in ComponentState) and
    HasVisualStateChangesOnMouseTrack then
  begin
    Redraw;
    RedrawDependentSkiaChildren(True);
  end;
end;

procedure TDSCustomSkControl.CMEnabledChanged(var Message: TMessage);
var
  i: Integer;
  LControl: TControl;
begin
  inherited;
  // 将 Enabled 状态传递给所有子 TWinControl，
  // 确保嵌套容器层级较深时也能正确禁用/启用。
  for i := 0 to ControlCount - 1 do
  begin
    LControl := Controls[i];
    if LControl is TWinControl then
      TWinControl(LControl).Enabled := Enabled;
  end;
  Redraw;
end;

procedure TDSCustomSkControl.MouseEnter; begin if Assigned(FOnMouseEnter) then FOnMouseEnter(Self); end;
procedure TDSCustomSkControl.MouseLeave; begin if Assigned(FOnMouseLeave) then FOnMouseLeave(Self); end;
procedure TDSCustomSkControl.PaintDesignTime(ACanvas: TCanvas); begin end;
procedure TDSCustomSkControl.CornerRadiusChanged; begin end;

function TDSCustomSkControl.NeedsParentBackgroundFill: Boolean;
begin
  // 只有在关闭系统窗口裁剪，且内容外仍可能露出圆角外区域时，
  // 才需要先铺一层父背景作为“角落底色”。
  Result := (not ShouldClipWindowRegion) and HasAnyCornerRadius;
end;

function TDSCustomSkControl.DependsOnParentBackground: Boolean;
begin
  Result := NeedsParentBackgroundFill;
end;

function TDSCustomSkControl.DependsOnParentVisualBackground: Boolean;
begin
  Result := DependsOnParentBackground;
end;

function TDSCustomSkControl.HasVisualStateChangesOnMouseTrack: Boolean;
begin
  Result := False;
end;

procedure TDSCustomSkControl.RedrawDependentSkiaChildren(AVisualStateOnly: Boolean);
var
  i: Integer;
  LSkiaChild: TDSCustomSkControl;
begin
  for i := 0 to ControlCount - 1 do
    if Controls[i] is TDSCustomSkControl then
    begin
      LSkiaChild := TDSCustomSkControl(Controls[i]);
      if (AVisualStateOnly and LSkiaChild.DependsOnParentVisualBackground) or
        ((not AVisualStateOnly) and LSkiaChild.DependsOnParentBackground) then
        LSkiaChild.Redraw;
    end;
end;

procedure TDSCustomSkControl.BeginRedrawLock;
begin
  Inc(FRedrawLockCount);
end;

procedure TDSCustomSkControl.EndRedrawLock;
begin
  if FRedrawLockCount > 0 then
    Dec(FRedrawLockCount);
end;

function TDSCustomSkControl.CanRedrawNow: Boolean;
begin
  Result := (FRedrawLockCount = 0) and not (csLoading in ComponentState);
end;

function TDSCustomSkControl.IsCornerRadiusStored: Boolean;
begin
  // 基类构造默认值是 10。显式设置成 0 时，如果不告诉流系统这是"非默认值"，
  // DFM 可能不会把它写出来，运行时就又回到构造默认值 10。
  Result := not SameValue(FCornerRadius, 10.0);
end;

function TDSCustomSkControl.IsParentDisabled: Boolean;
var
  LParent: TControl;
begin
  // 向上遍历父控件链，检查是否有禁用的父控件。
  // VCL 的 TControl.GetEnabled 只返回自身的 FEnabled，不检查父控件状态，
  // 所以需要手动遍历来确定运行时的实际禁用状态。
  Result := False;
  LParent := Parent;
  while LParent <> nil do
  begin
    if not LParent.Enabled then
      Exit(True);
    LParent := LParent.Parent;
  end;
end;

end.
