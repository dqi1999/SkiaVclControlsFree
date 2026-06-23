unit SkiaVclControls.Slider;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.Forms, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  PRGBQuadArray = ^TRGBQuadArray;
  TRGBQuadArray = array[0..MaxInt div SizeOf(TRGBQuad) - 1] of TRGBQuad;

  TDSkSliderMark = record
    Value: Single;
    Text: string;
  end;

  TDSkSliderChangeEvent = procedure(Sender: TObject; Value: Single) of object;
  TDSkSliderRangeChangeEvent = procedure(Sender: TObject; ValueLow, ValueHigh: Single) of object;

  TDSkSlider = class;

  { 浮动值标签窗口 - 独立透明窗口 }
  TDSkSliderValueLabelForm = class(TCustomForm)
  private
    FOwnerSlider: TDSkSlider;
    FText: string;
    FFontColor: TAlphaColor;
    procedure ApplyLabelFont(ACanvas: TCanvas);
    procedure UpdateLayeredContent;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure PaintWindow(DC: HDC); override;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMNCHitTest(var Message: TWMNCHitMessage); message WM_NCHITTEST;
  public
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    procedure UpdateAndShow(const AText: string; AColor: TAlphaColor; AScreenPos: TPoint; AIsVertical: Boolean);
  end;

  TDSkSlider = class(TDSCustomSkControl)
  private
    FMin: Single;
    FMax: Single;
    FValue: Single;
    FValueLow: Single;
    FValueHigh: Single;
    FStep: Single;
    FOrientation: TDSkSliderOrientation;
    FColorScheme: TDSkMUIColorScheme;
    FShowValueLabel: TDSkSliderValueLabelDisplay;
    FShowMarks: Boolean;
    FMarks: array of TDSkSliderMark;
    FMarkCount: Integer;
    FTrackVisible: TDSkSliderTrack;
    FThumbSize: Single;
    FTrackHeight: Single;
    FRange: Boolean;
    FDragging: Boolean;
    FDragTarget: Integer; // 0=value/low, 1=high
    FHoverThumb: Integer; // -1=none, 0=value/low, 1=high
    FFont: TFont;
    FValueLabelFormat: string;
    FOnChange: TDSkSliderChangeEvent;
    FOnRangeChange: TDSkSliderRangeChangeEvent;
    FTextCacheFont: ISkFont;
    FTextCacheTypeface: ISkTypeface;
    FTextCacheFontName: string;
    FTextCacheFontStyle: TFontStyles;
    FTextCacheFontSize: Single;
    FTextCachePPI: Integer;
    FFloatLabel: TDSkSliderValueLabelForm;
    procedure RequestRedraw;
    procedure SetMin(Value: Single);
    procedure SetMax(Value: Single);
    procedure SetValue(Value: Single);
    procedure SetValueLow(Value: Single);
    procedure SetValueHigh(Value: Single);
    procedure SetStep(Value: Single);
    procedure SetOrientation(Value: TDSkSliderOrientation);
    procedure SetColorScheme(Value: TDSkMUIColorScheme);
    procedure SetShowValueLabel(Value: TDSkSliderValueLabelDisplay);
    procedure SetShowMarks(Value: Boolean);
    procedure SetTrackVisible(Value: TDSkSliderTrack);
    procedure SetThumbSize(Value: Single);
    procedure SetTrackHeight(Value: Single);
    procedure SetRange(Value: Boolean);
    procedure SetFont(Value: TFont);
    procedure SetValueLabelFormat(const Value: string);
    procedure FontChanged(Sender: TObject);
    procedure InvalidateTextCache;
    function GetTextFont: ISkFont;
    function GetSliderColor: TAlphaColor;
    function GetThumbColor: TAlphaColor;
    function GetTrackColor: TAlphaColor;
    function GetTrackActiveColor: TAlphaColor;
    function GetThumbPosition(Value: Single): TPointF;
    function GetValueFromPosition(X, Y: Integer): Single;
    function HitTestThumb(X, Y: Integer): Integer;
    function FormatValueLabel(Value: Single): string;
    procedure ClampValue(var AValue: Single);
    procedure UpdateRangeValues;
    procedure ShowFloatLabel(AValue: Single);
    procedure HideFloatLabel;
  protected
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawTrack(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawThumb(const ACanvas: ISkCanvas; const ADest: TRectF; AValue: Single; AThumbIndex: Integer);
    procedure DrawMarks(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Resize; override;
    function DependsOnParentBackground: Boolean; override;
    function DependsOnParentVisualBackground: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddMark(AValue: Single; const AText: string = '');
    procedure ClearMarks;
    function ShouldClipWindowRegion: Boolean; override;
  published
    property Min: Single read FMin write SetMin;
    property Max: Single read FMax write SetMax;
    property Value: Single read FValue write SetValue;
    property ValueLow: Single read FValueLow write SetValueLow;
    property ValueHigh: Single read FValueHigh write SetValueHigh;
    property Step: Single read FStep write SetStep;
    property Orientation: TDSkSliderOrientation read FOrientation write SetOrientation default sloHorizontal;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property ShowValueLabel: TDSkSliderValueLabelDisplay read FShowValueLabel write SetShowValueLabel default svldAuto;
    property ShowMarks: Boolean read FShowMarks write SetShowMarks default False;
    property TrackVisible: TDSkSliderTrack read FTrackVisible write SetTrackVisible default stNormal;
    property ThumbSize: Single read FThumbSize write SetThumbSize;
    property TrackHeight: Single read FTrackHeight write SetTrackHeight;
    property Range: Boolean read FRange write SetRange default False;
    property Font: TFont read FFont write SetFont;
    property ValueLabelFormat: string read FValueLabelFormat write SetValueLabelFormat;
    property OnChange: TDSkSliderChangeEvent read FOnChange write FOnChange;
    property OnRangeChange: TDSkSliderRangeChangeEvent read FOnRangeChange write FOnRangeChange;
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
  THUMB_RADIUS = 10;
  TRACK_HEIGHT = 4;
  MARK_SIZE = 8;
  LABEL_GAP = 8;
  LAYOUT_BITMAPORIENTATIONPRESERVED = $00000008;

function SetLayout(hdc: HDC; dwLayout: DWORD): DWORD; stdcall; external gdi32 name 'SetLayout';

{ TDSkSliderValueLabelForm }

constructor TDSkSliderValueLabelForm.CreateNew(AOwner: TComponent; Dummy: Integer);
begin
  inherited CreateNew(AOwner, Dummy);
  FOwnerSlider := AOwner as TDSkSlider;
  FText := '';
  FFontColor := TAlphaColors.Blue;
  BorderStyle := bsNone;
  FormStyle := fsStayOnTop;
  Position := poDesigned;
  Visible := False;
end;

procedure TDSkSliderValueLabelForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := WS_POPUP;
  Params.ExStyle := WS_EX_TOPMOST or WS_EX_TOOLWINDOW or WS_EX_NOACTIVATE or
    WS_EX_LAYERED or WS_EX_TRANSPARENT or WS_EX_NOINHERITLAYOUT;
  Params.ExStyle := Params.ExStyle and not WS_EX_LAYOUTRTL;
  Params.WndParent := 0;
  Params.WindowClass.hbrBackground := 0;
end;

procedure TDSkSliderValueLabelForm.CreateWnd;
var
  LExStyle: NativeInt;
begin
  inherited;
  // 某些环境下 layered 样式虽然声明在 CreateParams 里，
  // 但运行时最终样式组合仍可能让 UpdateLayeredWindow 报 87。
  // 这里在窗口真正创建后再显式补一次，保证样式状态明确。
  LExStyle := GetWindowLongPtr(Handle, GWL_EXSTYLE);
  SetWindowLongPtr(Handle, GWL_EXSTYLE,
    (LExStyle or WS_EX_LAYERED or WS_EX_TOOLWINDOW or WS_EX_NOACTIVATE or
    WS_EX_TOPMOST or WS_EX_TRANSPARENT or WS_EX_NOINHERITLAYOUT) and not WS_EX_LAYOUTRTL);
end;

procedure TDSkSliderValueLabelForm.PaintWindow(DC: HDC);
begin
  // 这个窗体的可见内容完全由 UpdateLayeredWindow 提供，
  // 普通 VCL 绘制如果介入，就会出现现在截图里的白块。
end;

procedure TDSkSliderValueLabelForm.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TDSkSliderValueLabelForm.WMNCHitTest(var Message: TWMNCHitMessage);
begin
  Message.Result := HTTRANSPARENT;
end;

procedure TDSkSliderValueLabelForm.ApplyLabelFont(ACanvas: TCanvas);
begin
  if FOwnerSlider <> nil then
    ACanvas.Font.Assign(FOwnerSlider.Font)
  else
  begin
    ACanvas.Font.Name := GetDefaultFontName;
    ACanvas.Font.Size := 10;
    ACanvas.Font.Style := [];
  end;
  ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];
  ACanvas.Font.Quality := fqAntialiased;
end;

procedure TDSkSliderValueLabelForm.UpdateLayeredContent;
var
  LMemDC: HDC;
  LBitmap: HBITMAP;
  LOldBitmap: HGDIOBJ;
  LBits: Pointer;
  LBitmapInfo: BITMAPINFO;
  LCanvas: TCanvas;
  LPixels: PRGBQuadArray;
  LMaskRow: PRGBQuadArray;
  LBlend: BLENDFUNCTION;
  LSize: TSize;
  LSourcePoint: TPoint;
  LWindowPoint: TPoint;
  LTextAlpha: Byte;
  LBaseAlpha: Byte;
  LRed: Byte;
  LGreen: Byte;
  LBlue: Byte;
  LTextBitmap: Vcl.Graphics.TBitmap;
  LTextRect: TRect;
  LExStyle: NativeInt;
  X: Integer;
  Y: Integer;
begin
  if not HandleAllocated or (Width <= 0) or (Height <= 0) then
    Exit;

  LExStyle := GetWindowLongPtr(Handle, GWL_EXSTYLE);
  if (LExStyle and WS_EX_LAYERED) = 0 then
  begin
    SetWindowLongPtr(Handle, GWL_EXSTYLE, LExStyle or WS_EX_LAYERED);
    LExStyle := GetWindowLongPtr(Handle, GWL_EXSTYLE);
  end;

  // 创建源内存 DC
  LMemDC := CreateCompatibleDC(0);
  try
    if LMemDC = 0 then
      Exit;

    ZeroMemory(@LBitmapInfo, SizeOf(LBitmapInfo));
    LBitmapInfo.bmiHeader.biSize := SizeOf(BITMAPINFOHEADER);
    LBitmapInfo.bmiHeader.biWidth := Width;
    // 负高度表示 top-down 位图，与屏幕坐标系一致（左上角为 0,0）
    LBitmapInfo.bmiHeader.biHeight := -Height;
    LBitmapInfo.bmiHeader.biPlanes := 1;
    LBitmapInfo.bmiHeader.biBitCount := 32;
    LBitmapInfo.bmiHeader.biCompression := BI_RGB;

    // 创建最终供 UpdateLayeredWindow 使用的 32 位 DIB Section
    LBitmap := CreateDIBSection(0, LBitmapInfo, DIB_RGB_COLORS, LBits, 0, 0);
    if LBitmap = 0 then
      Exit;

    try
      LOldBitmap := SelectObject(LMemDC, LBitmap);
      try
        // 初始化画布背景为全透明
        FillChar(LBits^, Width * Height * SizeOf(TRGBQuad), 0);

        // 创建临时位图，用于通过 GDI 渲染纯白文字作为“遮罩”
        LTextBitmap := Vcl.Graphics.TBitmap.Create;
        try
          LTextBitmap.SetSize(Width, Height);
          LTextBitmap.PixelFormat := pf32Bit;
          LTextBitmap.AlphaFormat := afIgnored; // 避免 GDI 绘图时受到预乘干扰

          LCanvas := LTextBitmap.Canvas;
          SetLayout(LCanvas.Handle, LAYOUT_BITMAPORIENTATIONPRESERVED);

          // 填充黑色背景
          LCanvas.Brush.Color := clBlack;
          LCanvas.Brush.Style := bsSolid;
          LCanvas.FillRect(Rect(0, 0, Width, Height));

          // 绘制白色文字
          ApplyLabelFont(LCanvas);
          LCanvas.Font.Color := clWhite;
          LCanvas.Brush.Style := bsClear;
          SetBkMode(LCanvas.Handle, TRANSPARENT);

          LTextRect := Rect(0, 0, Width, Height);
          DrawText(LCanvas.Handle, PChar(FText), Length(FText), LTextRect, DT_SINGLELINE or DT_CENTER or DT_VCENTER);

          // 提取目标颜色的 RGBA 分量
          LPixels := PRGBQuadArray(LBits);
          LBaseAlpha := (FFontColor shr 24) and $FF;
          LRed := (FFontColor shr 16) and $FF;
          LGreen := (FFontColor shr 8) and $FF;
          LBlue := FFontColor and $FF;

          // 核心修正：采用正向混色循环。
          // 移除了会导致图像旋转 180 度的 LTargetX / LTargetY 反向映射。
          for Y := 0 to Height - 1 do
          begin
            LMaskRow := PRGBQuadArray(LTextBitmap.ScanLine[Y]);
            for X := 0 to Width - 1 do
            begin
              // 提取白色文字在黑色背景上的亮度值作为 Alpha
              LTextAlpha := Max(LMaskRow[X].rgbRed, Max(LMaskRow[X].rgbGreen, LMaskRow[X].rgbBlue));
              if LTextAlpha = 0 then
                Continue;

              // 如果字体自带半透明，叠加计算最终 Alpha
              if LBaseAlpha < 255 then
                LTextAlpha := MulDiv(LTextAlpha, LBaseAlpha, 255);

              // 按照 Win32 预乘 Alpha（Premultiplied Alpha）的标准，写入对应的像素点
              LPixels[Y * Width + X].rgbRed := MulDiv(LRed, LTextAlpha, 255);
              LPixels[Y * Width + X].rgbGreen := MulDiv(LGreen, LTextAlpha, 255);
              LPixels[Y * Width + X].rgbBlue := MulDiv(LBlue, LTextAlpha, 255);
              LPixels[Y * Width + X].rgbReserved := LTextAlpha;
            end;
          end;
        finally
          LTextBitmap.Free;
        end;

          // 配置混合参数
        LBlend.BlendOp := AC_SRC_OVER;
        LBlend.BlendFlags := 0;
        LBlend.SourceConstantAlpha := 255;
        LBlend.AlphaFormat := AC_SRC_ALPHA; // 声明使用像素级 Alpha

        LSize.cx := Width;
        LSize.cy := Height;
        LSourcePoint := Point(0, 0);
        LWindowPoint := Point(Left, Top);

        // 提交到分层窗口
        UpdateLayeredWindow(Handle, 0, @LWindowPoint, @LSize, LMemDC, @LSourcePoint, 0, @LBlend, ULW_ALPHA);
      finally
        SelectObject(LMemDC, LOldBitmap);
      end;
    finally
      DeleteObject(LBitmap);
    end;
  finally
    DeleteDC(LMemDC);
  end;
end;

procedure TDSkSliderValueLabelForm.UpdateAndShow(const AText: string; AColor: TAlphaColor; AScreenPos: TPoint; AIsVertical: Boolean);
var
  LX, LY: Integer;
  LMonitorRect: TRect;
  LBitmap: Vcl.Graphics.TBitmap;
begin
  FText := AText;
  FFontColor := AColor;

  // 计算窗口尺寸
  LBitmap := Vcl.Graphics.TBitmap.Create;
  try
    ApplyLabelFont(LBitmap.Canvas);
    Width := LBitmap.Canvas.TextWidth(AText) + 16;
    Height := LBitmap.Canvas.TextHeight(AText) + 10;
  finally
    LBitmap.Free;
  end;

  // 计算位置
  LMonitorRect := Screen.MonitorFromPoint(AScreenPos).WorkareaRect;
  if AIsVertical then
  begin
    LX := AScreenPos.X + 20;
    LY := AScreenPos.Y - Height div 2;
  end
  else
  begin
    LX := AScreenPos.X - Width div 2;
    LY := AScreenPos.Y - Height - 10;
  end;

  // 边界检查
  if LX < LMonitorRect.Left then LX := LMonitorRect.Left;
  if LX + Width > LMonitorRect.Right then LX := LMonitorRect.Right - Width;
  if LY < LMonitorRect.Top then
  begin
    if AIsVertical then
      LY := AScreenPos.Y - Height div 2
    else
      LY := AScreenPos.Y + 20;
  end;

  SetBounds(LX, LY, Width, Height);
  HandleNeeded;
  SetWindowPos(Handle, HWND_TOPMOST, LX, LY, Width, Height, SWP_NOACTIVATE or SWP_SHOWWINDOW);
  UpdateLayeredContent;
end;

{ TDSkSlider }

constructor TDSkSlider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMin := 0;
  FMax := 100;
  FValue := 0;
  FValueLow := 0;
  FValueHigh := 100;
  FStep := 0;
  FOrientation := sloHorizontal;
  FColorScheme := muiPrimary;
  FShowValueLabel := svldAuto;
  FShowMarks := False;
  FMarkCount := 0;
  FTrackVisible := stNormal;
  FThumbSize := THUMB_RADIUS;
  FTrackHeight := TRACK_HEIGHT;
  FRange := False;
  FDragging := False;
  FDragTarget := -1;
  FHoverThumb := -1;
  FFont := TFont.Create;
  FFont.Name := GetDefaultFontName;
  FFont.Size := 10;
  FFont.OnChange := FontChanged;
  FValueLabelFormat := '%.0f';
  FFloatLabel := nil;
  InvalidateTextCache;
  Width := 200;
  Height := 40;
  TabStop := True;
  CornerRadius := 0;
  BackgroundColor := TAlphaColors.Null;
  BorderColor := TAlphaColors.Null;
  BorderWidth := 0;
end;

destructor TDSkSlider.Destroy;
begin
  FFloatLabel.Free;
  FFont.Free;
  SetLength(FMarks, 0);
  inherited;
end;

procedure TDSkSlider.RequestRedraw;
begin
  if csLoading in ComponentState then
    Exit;
  Redraw;
end;

procedure TDSkSlider.SetMin(Value: Single);
begin
  if FMin <> Value then
  begin
    FMin := Value;
    if FMax < FMin then
      FMax := FMin;
    ClampValue(FValue);
    ClampValue(FValueLow);
    ClampValue(FValueHigh);
    if not (csLoading in ComponentState) then
      Invalidate;
  end;
end;

procedure TDSkSlider.SetMax(Value: Single);
begin
  if FMax <> Value then
  begin
    FMax := Value;
    if FMin > FMax then
      FMin := FMax;
    ClampValue(FValue);
    ClampValue(FValueLow);
    ClampValue(FValueHigh);
    if not (csLoading in ComponentState) then
      Invalidate;
  end;
end;

procedure TDSkSlider.SetValue(Value: Single);
begin
  ClampValue(Value);
  if FValue <> Value then
  begin
    FValue := Value;
    if not (csLoading in ComponentState) then
      Invalidate;
    if Assigned(FOnChange) and not (csLoading in ComponentState) and
      not (csDesigning in ComponentState) then
      FOnChange(Self, FValue);
  end;
end;

procedure TDSkSlider.SetValueLow(Value: Single);
begin
  ClampValue(Value);
  if FValueLow <> Value then
  begin
    FValueLow := Value;
    if FValueLow > FValueHigh then
      FValueHigh := FValueLow;
    if not (csLoading in ComponentState) then
      Invalidate;
    if Assigned(FOnRangeChange) and not (csLoading in ComponentState) and
      not (csDesigning in ComponentState) then
      FOnRangeChange(Self, FValueLow, FValueHigh);
  end;
end;

procedure TDSkSlider.SetValueHigh(Value: Single);
begin
  ClampValue(Value);
  if FValueHigh <> Value then
  begin
    FValueHigh := Value;
    if FValueHigh < FValueLow then
      FValueLow := FValueHigh;
    if not (csLoading in ComponentState) then
      Invalidate;
    if Assigned(FOnRangeChange) and not (csLoading in ComponentState) and
      not (csDesigning in ComponentState) then
      FOnRangeChange(Self, FValueLow, FValueHigh);
  end;
end;

procedure TDSkSlider.SetStep(Value: Single);
begin
  if FStep <> Value then
  begin
    FStep := Value;
    if not (csLoading in ComponentState) then
      Invalidate;
  end;
end;

procedure TDSkSlider.SetOrientation(Value: TDSkSliderOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    if not (csLoading in ComponentState) then
      Invalidate;
  end;
end;

procedure TDSkSlider.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then
  begin
    FColorScheme := Value;
    if not (csLoading in ComponentState) then
      Invalidate;
  end;
end;

procedure TDSkSlider.SetShowValueLabel(Value: TDSkSliderValueLabelDisplay);
begin
  if FShowValueLabel <> Value then
  begin
    FShowValueLabel := Value;
    if FShowValueLabel = svldOff then
      HideFloatLabel;
    if not (csLoading in ComponentState) then
      Invalidate;
  end;
end;

procedure TDSkSlider.SetShowMarks(Value: Boolean);
begin
  if FShowMarks <> Value then
  begin
    FShowMarks := Value;
    if not (csLoading in ComponentState) then
      Invalidate;
  end;
end;

procedure TDSkSlider.SetTrackVisible(Value: TDSkSliderTrack);
begin
  if FTrackVisible <> Value then
  begin
    FTrackVisible := Value;
    if not (csLoading in ComponentState) then
      Invalidate;
  end;
end;

procedure TDSkSlider.SetThumbSize(Value: Single);
begin
  if FThumbSize <> Value then
  begin
    FThumbSize := Value;
    if not (csLoading in ComponentState) then
      Invalidate;
  end;
end;

procedure TDSkSlider.SetTrackHeight(Value: Single);
begin
  if FTrackHeight <> Value then
  begin
    FTrackHeight := Value;
    if not (csLoading in ComponentState) then
      Invalidate;
  end;
end;

procedure TDSkSlider.SetRange(Value: Boolean);
begin
  if FRange <> Value then
  begin
    FRange := Value;
    if not (csLoading in ComponentState) then
      Invalidate;
  end;
end;

procedure TDSkSlider.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  InvalidateTextCache;
  if not (csLoading in ComponentState) then
    Invalidate;
end;

procedure TDSkSlider.FontChanged(Sender: TObject);
begin
  InvalidateTextCache;
  if not (csLoading in ComponentState) then
    Invalidate;
end;

procedure TDSkSlider.SetValueLabelFormat(const Value: string);
begin
  if FValueLabelFormat <> Value then
  begin
    FValueLabelFormat := Value;
    if not (csLoading in ComponentState) then
      Invalidate;
  end;
end;

procedure TDSkSlider.InvalidateTextCache;
begin
  FTextCacheFont := nil;
  FTextCacheTypeface := nil;
  FTextCacheFontName := '';
  FTextCacheFontStyle := [];
  FTextCacheFontSize := -1;
  FTextCachePPI := 0;
end;

function TDSkSlider.GetTextFont: ISkFont;
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

function TDSkSlider.GetSliderColor: TAlphaColor;
begin
  if not Enabled then
    Result := $FFBDBDBD
  else
    case FColorScheme of
      muiSecondary: Result := $FF9C27B0;
      muiError: Result := $FFD32F2F;
      muiWarning: Result := $FFED6C02;
      muiInfo: Result := $FF0288D1;
      muiSuccess: Result := $FF2E7D32;
    else
      Result := $FF1976D2; // Primary
    end;
end;

function TDSkSlider.GetThumbColor: TAlphaColor;
begin
  Result := GetSliderColor;
end;

function TDSkSlider.GetTrackColor: TAlphaColor;
begin
  if not Enabled then
    Result := $FFE0E0E0
  else
    Result := $FFBDBDBD; // 灰色轨道
end;

function TDSkSlider.GetTrackActiveColor: TAlphaColor;
begin
  Result := GetSliderColor;
end;

function TDSkSlider.GetThumbPosition(Value: Single): TPointF;
var
  LPercent: Single;
  LTrackLength: Single;
  LStartPos: Single;
begin
  if FMax = FMin then
    LPercent := 0
  else
    LPercent := (Value - FMin) / (FMax - FMin);

  if FOrientation = sloHorizontal then
  begin
    LTrackLength := Width - FThumbSize * 2;
    LStartPos := FThumbSize;
    Result := PointF(LStartPos + LPercent * LTrackLength, Height / 2);
  end
  else
  begin
    LTrackLength := Height - FThumbSize * 2;
    LStartPos := FThumbSize;
    Result := PointF(Width / 2, LStartPos + (1 - LPercent) * LTrackLength);
  end;
end;

function TDSkSlider.GetValueFromPosition(X, Y: Integer): Single;
var
  LPercent: Single;
  LTrackLength: Single;
  LStartPos: Single;
  LPos: Single;
begin
  if FOrientation = sloHorizontal then
  begin
    LTrackLength := Width - FThumbSize * 2;
    LStartPos := FThumbSize;
    if LTrackLength <= 0 then
      LPercent := 0
    else
    begin
      LPos := X - LStartPos;
      LPercent := LPos / LTrackLength;
    end;
  end
  else
  begin
    LTrackLength := Height - FThumbSize * 2;
    LStartPos := FThumbSize;
    if LTrackLength <= 0 then
      LPercent := 0
    else
    begin
      LPos := Y - LStartPos;
      LPercent := 1 - (LPos / LTrackLength);
    end;
  end;

  if LPercent < 0 then LPercent := 0;
  if LPercent > 1 then LPercent := 1;
  Result := FMin + LPercent * (FMax - FMin);
end;

function TDSkSlider.HitTestThumb(X, Y: Integer): Integer;
var
  LPos: TPointF;
  LDist: Single;
  LThumbPos: TPointF;
begin
  Result := -1;
  LPos := PointF(X, Y);

  if FRange then
  begin
    LThumbPos := GetThumbPosition(FValueLow);
    LDist := Sqrt(Sqr(LPos.X - LThumbPos.X) + Sqr(LPos.Y - LThumbPos.Y));
    if LDist <= FThumbSize + 4 then
      Exit(0);

    LThumbPos := GetThumbPosition(FValueHigh);
    LDist := Sqrt(Sqr(LPos.X - LThumbPos.X) + Sqr(LPos.Y - LThumbPos.Y));
    if LDist <= FThumbSize + 4 then
      Exit(1);
  end
  else
  begin
    LThumbPos := GetThumbPosition(FValue);
    LDist := Sqrt(Sqr(LPos.X - LThumbPos.X) + Sqr(LPos.Y - LThumbPos.Y));
    if LDist <= FThumbSize + 4 then
      Exit(0);
  end;
end;

function TDSkSlider.FormatValueLabel(Value: Single): string;
begin
  Result := Format(FValueLabelFormat, [Value]);
end;

procedure TDSkSlider.ClampValue(var AValue: Single);
begin
  if AValue < FMin then AValue := FMin;
  if AValue > FMax then AValue := FMax;
  if FStep > 0 then
    AValue := FMin + Round((AValue - FMin) / FStep) * FStep;
end;

procedure TDSkSlider.UpdateRangeValues;
var
  LTemp: Single;
begin
  ClampValue(FValueLow);
  ClampValue(FValueHigh);
  if FValueLow > FValueHigh then
  begin
    LTemp := FValueLow;
    FValueLow := FValueHigh;
    FValueHigh := LTemp;
  end;
end;

procedure TDSkSlider.AddMark(AValue: Single; const AText: string);
begin
  Inc(FMarkCount);
  SetLength(FMarks, FMarkCount);
  FMarks[FMarkCount - 1].Value := AValue;
  FMarks[FMarkCount - 1].Text := AText;
  if not (csLoading in ComponentState) then
    Invalidate;
end;

procedure TDSkSlider.ClearMarks;
begin
  FMarkCount := 0;
  SetLength(FMarks, 0);
  if not (csLoading in ComponentState) then
    Invalidate;
end;

procedure TDSkSlider.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
begin
  // 先清除为透明
  ACanvas.Clear($00FFFFFF);
  
  // 绘制轨道
  if FTrackVisible <> stFalse then
    DrawTrack(ACanvas, ADest);

  // 绘制标记
  if FShowMarks or (FMarkCount > 0) then
    DrawMarks(ACanvas, ADest);

  // 绘制滑块
  if FRange then
  begin
    DrawThumb(ACanvas, ADest, FValueLow, 0);
    DrawThumb(ACanvas, ADest, FValueHigh, 1);
  end
  else
    DrawThumb(ACanvas, ADest, FValue, 0);
end;

procedure TDSkSlider.DrawTrack(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LPaint: ISkPaint;
  LTrackRect: TRectF;
  LActiveRect: TRectF;
  LPosLow, LPosHigh: TPointF;
  LPos: TPointF;
  LRadius: Single;
begin
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LRadius := FTrackHeight / 2;

  if FOrientation = sloHorizontal then
  begin
    // 背景轨道
    LTrackRect := RectF(FThumbSize, Height / 2 - LRadius, Width - FThumbSize, Height / 2 + LRadius);
    LPaint.Color := GetTrackColor;
    LPaint.Style := TSkPaintStyle.Fill;
    ACanvas.DrawRoundRect(TSkRoundRect.Create(LTrackRect, LRadius, LRadius), LPaint);

    // 活动轨道
    if FRange then
    begin
      LPosLow := GetThumbPosition(FValueLow);
      LPosHigh := GetThumbPosition(FValueHigh);
      LActiveRect := RectF(LPosLow.X, Height / 2 - LRadius, LPosHigh.X, Height / 2 + LRadius);
    end
    else
    begin
      LPos := GetThumbPosition(FValue);
      LActiveRect := RectF(FThumbSize, Height / 2 - LRadius, LPos.X, Height / 2 + LRadius);
    end;

    if FTrackVisible = stInverted then
    begin
      // 反转轨道：活动部分为灰色，非活动部分为彩色
      LPaint.Color := GetTrackColor;
      ACanvas.DrawRoundRect(TSkRoundRect.Create(LActiveRect, LRadius, LRadius), LPaint);
    end
    else
    begin
      // 正常轨道：活动部分为彩色
      LPaint.Color := GetTrackActiveColor;
      ACanvas.DrawRoundRect(TSkRoundRect.Create(LActiveRect, LRadius, LRadius), LPaint);
    end;
  end
  else
  begin
    // 垂直轨道
    LTrackRect := RectF(Width / 2 - LRadius, FThumbSize, Width / 2 + LRadius, Height - FThumbSize);
    LPaint.Color := GetTrackColor;
    LPaint.Style := TSkPaintStyle.Fill;
    ACanvas.DrawRoundRect(TSkRoundRect.Create(LTrackRect, LRadius, LRadius), LPaint);

    // 活动轨道
    if FRange then
    begin
      LPosLow := GetThumbPosition(FValueLow);
      LPosHigh := GetThumbPosition(FValueHigh);
      LActiveRect := RectF(Width / 2 - LRadius, LPosHigh.Y, Width / 2 + LRadius, LPosLow.Y);
    end
    else
    begin
      LPos := GetThumbPosition(FValue);
      LActiveRect := RectF(Width / 2 - LRadius, LPos.Y, Width / 2 + LRadius, Height - FThumbSize);
    end;

    if FTrackVisible = stInverted then
    begin
      LPaint.Color := GetTrackColor;
      ACanvas.DrawRoundRect(TSkRoundRect.Create(LActiveRect, LRadius, LRadius), LPaint);
    end
    else
    begin
      LPaint.Color := GetTrackActiveColor;
      ACanvas.DrawRoundRect(TSkRoundRect.Create(LActiveRect, LRadius, LRadius), LPaint);
    end;
  end;
end;

procedure TDSkSlider.DrawThumb(const ACanvas: ISkCanvas; const ADest: TRectF; AValue: Single; AThumbIndex: Integer);
var
  LPaint: ISkPaint;
  LPos: TPointF;
  LColor: TAlphaColor;
  LIsHover: Boolean;
begin
  LPos := GetThumbPosition(AValue);
  LColor := GetThumbColor;
  LIsHover := (FHoverThumb = AThumbIndex) or (FDragging and (FDragTarget = AThumbIndex));

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;

  // 悬停/拖动时放大效果
  if LIsHover then
  begin
    LPaint.Style := TSkPaintStyle.Fill;
    LPaint.Color := (LColor and $00FFFFFF) or $30000000; // 浅色背景
    ACanvas.DrawCircle(LPos, FThumbSize + 4, LPaint);
  end;

  // 绘制滑块主体
  LPaint.Style := TSkPaintStyle.Fill;
  LPaint.Color := LColor;
  ACanvas.DrawCircle(LPos, FThumbSize, LPaint);
end;

procedure TDSkSlider.DrawMarks(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LPaint: ISkPaint;
  LFont: ISkFont;
  I: Integer;
  LPos: TPointF;
  LMarkSize: Single;
begin
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Fill;
  LPaint.Color := $FF757575; // 灰色标记
  LMarkSize := DpiScaleValue(MARK_SIZE);

  LFont := GetTextFont;

  for I := 0 to FMarkCount - 1 do
  begin
    LPos := GetThumbPosition(FMarks[I].Value);

    if FOrientation = sloHorizontal then
    begin
      // 绘制刻度线
      ACanvas.DrawLine(LPos.X, LPos.Y + FThumbSize + 4, LPos.X, LPos.Y + FThumbSize + 4 + LMarkSize, LPaint);
      
      // 绘制标签
      if FMarks[I].Text <> '' then
      begin
        LPaint.Color := VclColorToAlphaColor(FFont.Color);
        ACanvas.DrawSimpleText(FMarks[I].Text, 
          LPos.X - LFont.MeasureText(FMarks[I].Text) / 2, 
          LPos.Y + FThumbSize + 4 + LMarkSize + LFont.Size + 2, 
          LFont, LPaint);
        LPaint.Color := $FF757575;
      end;
    end
    else
    begin
      // 垂直方向的刻度线
      ACanvas.DrawLine(LPos.X + FThumbSize + 4, LPos.Y, LPos.X + FThumbSize + 4 + LMarkSize, LPos.Y, LPaint);
      
      // 绘制标签
      if FMarks[I].Text <> '' then
      begin
        LPaint.Color := VclColorToAlphaColor(FFont.Color);
        ACanvas.DrawSimpleText(FMarks[I].Text, 
          LPos.X + FThumbSize + 4 + LMarkSize + 4, 
          LPos.Y + LFont.Size / 2, 
          LFont, LPaint);
        LPaint.Color := $FF757575;
      end;
    end;
  end;
end;

procedure TDSkSlider.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LThumbIndex: Integer;
  LNewValue: Single;
begin
  inherited;
  if Button <> mbLeft then Exit;
  if not Enabled then Exit;

  LThumbIndex := HitTestThumb(X, Y);
  if LThumbIndex >= 0 then
  begin
    FDragging := True;
    FDragTarget := LThumbIndex;
    SetCapture(Handle);
    if FDragTarget = 0 then
    begin
      if FRange then
        ShowFloatLabel(FValueLow)
      else
        ShowFloatLabel(FValue);
    end
    else
      ShowFloatLabel(FValueHigh);
  end
  else
  begin
    // 点击轨道，直接跳转到该位置
    LNewValue := GetValueFromPosition(X, Y);
    ClampValue(LNewValue);
    
    if FRange then
    begin
      // 确定哪个滑块更近
      if Abs(LNewValue - FValueLow) <= Abs(LNewValue - FValueHigh) then
      begin
        SetValueLow(LNewValue);
        FDragTarget := 0;
      end
      else
      begin
        SetValueHigh(LNewValue);
        FDragTarget := 1;
      end;
    end
    else
    begin
      SetValue(LNewValue);
      FDragTarget := 0;
    end;
    
    FDragging := True;
    SetCapture(Handle);
    if FDragTarget = 0 then
    begin
      if FRange then
        ShowFloatLabel(FValueLow)
      else
        ShowFloatLabel(FValue);
    end
    else
      ShowFloatLabel(FValueHigh);
  end;
end;

procedure TDSkSlider.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  LNewValue: Single;
  LThumbIndex: Integer;
  LChanged: Boolean;
begin
  inherited;
  
  if FDragging then
  begin
    LNewValue := GetValueFromPosition(X, Y);
    ClampValue(LNewValue);
    LChanged := False;
    
    if FRange then
    begin
      if FDragTarget = 0 then
      begin
        if FValueLow <> LNewValue then
        begin
          FValueLow := LNewValue;
          if FValueLow > FValueHigh then
            FValueHigh := FValueLow;
          LChanged := True;
        end;
      end
      else
      begin
        if FValueHigh <> LNewValue then
        begin
          FValueHigh := LNewValue;
          if FValueHigh < FValueLow then
            FValueLow := FValueHigh;
          LChanged := True;
        end;
      end;
    end
    else
    begin
      if FValue <> LNewValue then
      begin
        FValue := LNewValue;
        LChanged := True;
      end;
    end;
    
    // 直接重绘，避免Invalidate的延迟
    if LChanged then
    begin
      Redraw;
      // 更新浮动标签
      if FDragTarget = 0 then
      begin
        if FRange then
          ShowFloatLabel(FValueLow)
        else
          ShowFloatLabel(FValue);
      end
      else
        ShowFloatLabel(FValueHigh);
      // 触发事件
      if not (csLoading in ComponentState) and not (csDesigning in ComponentState) then
      begin
        if FRange and Assigned(FOnRangeChange) then
          FOnRangeChange(Self, FValueLow, FValueHigh)
        else if not FRange and Assigned(FOnChange) then
          FOnChange(Self, FValue);
      end;
    end;
  end
  else
  begin
    // 更新悬停状态
    LThumbIndex := HitTestThumb(X, Y);
    if LThumbIndex <> FHoverThumb then
    begin
      FHoverThumb := LThumbIndex;
      RequestRedraw;
    end;
  end;
end;

procedure TDSkSlider.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if FDragging then
  begin
    HideFloatLabel;
    FDragging := False;
    FDragTarget := -1;
    ReleaseCapture;
    RequestRedraw;
  end;
end;

procedure TDSkSlider.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FHoverThumb >= 0 then
  begin
    FHoverThumb := -1;
    RequestRedraw;
  end;
  if not FDragging then
    HideFloatLabel;
end;

procedure TDSkSlider.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not Enabled then
  begin
    FDragging := False;
    FDragTarget := -1;
    HideFloatLabel;
  end;
  RequestRedraw;
end;

procedure TDSkSlider.KeyDown(var Key: Word; Shift: TShiftState);
var
  LDelta: Single;
begin
  inherited;
  if not Enabled then Exit;

  LDelta := IfThen(FStep > 0, FStep, (FMax - FMin) / 100);

  case Key of
    VK_LEFT, VK_DOWN: begin
      if FRange then
      begin
        if Focused then
          SetValueLow(FValueLow - LDelta);
      end
      else
        SetValue(FValue - LDelta);
    end;
    VK_RIGHT, VK_UP: begin
      if FRange then
      begin
        if Focused then
          SetValueLow(FValueLow + LDelta);
      end
      else
        SetValue(FValue + LDelta);
    end;
    VK_HOME: begin
      if FRange then
        SetValueLow(FMin)
      else
        SetValue(FMin);
    end;
    VK_END: begin
      if FRange then
        SetValueHigh(FMax)
      else
        SetValue(FMax);
    end;
  end;
end;

procedure TDSkSlider.Resize;
begin
  inherited;
  RequestRedraw;
end;

function TDSkSlider.DependsOnParentBackground: Boolean;
begin
  Result := True;
end;

function TDSkSlider.DependsOnParentVisualBackground: Boolean;
begin
  if Parent is TDSCustomSkControl then
    Result := TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack
  else
    Result := False;
end;

function TDSkSlider.ShouldClipWindowRegion: Boolean;
begin
  Result := False;
end;

procedure TDSkSlider.ShowFloatLabel(AValue: Single);
var
  LThumbPos: TPointF;
  LScreenPos: TPoint;
begin
  if FShowValueLabel = svldOff then Exit;
  
  if FFloatLabel = nil then
    FFloatLabel := TDSkSliderValueLabelForm.CreateNew(Self);
  
  LThumbPos := GetThumbPosition(AValue);
  LScreenPos := ClientToScreen(Point(Round(LThumbPos.X), Round(LThumbPos.Y)));
  FFloatLabel.UpdateAndShow(FormatValueLabel(AValue), GetSliderColor, LScreenPos, FOrientation = sloVertical);
end;

procedure TDSkSlider.HideFloatLabel;
begin
  if FFloatLabel <> nil then
  begin
    if FFloatLabel.HandleAllocated then
      ShowWindow(FFloatLabel.Handle, SW_HIDE)
    else
      FFloatLabel.Hide;
  end;
end;

end.
