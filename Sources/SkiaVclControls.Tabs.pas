unit SkiaVclControls.Tabs;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.ImgList, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  TDSkTabsItemClickEvent = procedure(Sender: TObject;TabIndex: Integer) of object;

  TDSkTabs = class(TDSCustomSkControl)
  private
    FItems: TStrings;
    FItemIndex: Integer;
    FVariant: TDSkTabsVariant;
    FAlignment: TDSkTabsAlignment;
    FOrientation: TDSkTabsOrientation;
    FIndicatorColor: TDSkTabIndicatorColor;
    FTextColor: TDSkTabTextColor;
    FColorScheme: TDSkMUIColorScheme;
    FTabFont: TFont;
    FTabHeight: Single;
    FIndicatorHeight: Single;
    FTabPadding: Single;
    FTabIndex: Integer;
    FHoverIndex: Integer;
    FOnItemClick: TDSkTabsItemClickEvent;
    FTabCacheFont: ISkFont;
    FTabCacheTypeface: ISkTypeface;
    FTabCacheFontName: string;
    FTabCacheFontStyle: TSkFontStyle;
    FTabCacheFontSize: Single;
    FTabCachePPI: Integer;
    FTabTextWidthCache: TStringList;
    FImages: TCustomImageList;
    FImageChangeLink: TChangeLink;
    procedure SetItems(Value: TStrings);
    procedure SetItemIndex(Value: Integer);
    procedure SetVariant(Value: TDSkTabsVariant);
    procedure SetAlignment(Value: TDSkTabsAlignment);
    procedure SetOrientation(Value: TDSkTabsOrientation);
    procedure SetIndicatorColor(Value: TDSkTabIndicatorColor);
    procedure SetTextColor(Value: TDSkTabTextColor);
    procedure SetColorScheme(Value: TDSkMUIColorScheme);
    procedure SetTabFont(Value: TFont);
    procedure SetTabHeight(Value: Single);
    procedure SetIndicatorHeight(Value: Single);
    procedure SetTabPadding(Value: Single);
    procedure SetImages(Value: TCustomImageList);
    procedure TabFontChanged(Sender: TObject);
    procedure ItemsChanged(Sender: TObject);
    procedure ImageListChanged(Sender: TObject);
    procedure RequestRedraw;
    function GetTabRect(Index: Integer): TRectF;
    function GetIndicatorRect: TRectF;
    function HitTest(X, Y: Integer): Integer;
    function GetTabColor: TAlphaColor;
    function GetItemCount: Integer;
    function GetTotalTabsWidth: Single;
    function GetMaxVisibleTabs: Integer;
    procedure InvalidateTabFontCache;
    function GetTabFontCache: ISkFont;
    function MeasureTabText(const AText: string): Single;
    function GetItemText(Index: Integer): string;
    function GetTabContentWidth(Index: Integer): Single;
    function GetItemImageIndex(Index: Integer): Integer;
    procedure DrawIcon(ACanvas: ISkCanvas; const ARect: TRectF; AImageIndex: Integer; AColor: TAlphaColor);
  protected
    procedure Loaded; override;
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawTabs(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawTab(const ACanvas: ISkCanvas; const ADest: TRectF; Index: Integer);
    procedure DrawIndicator(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure Resize; override;
    function DependsOnParentBackground: Boolean; override;
    function DependsOnParentVisualBackground: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ShouldClipWindowRegion: Boolean; override;
    property ItemCount: Integer read GetItemCount;
  published
    property Items: TStrings read FItems write SetItems;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Variant: TDSkTabsVariant read FVariant write SetVariant default tvStandard;
    property Alignment: TDSkTabsAlignment read FAlignment write SetAlignment default taLeft;
    property Orientation: TDSkTabsOrientation read FOrientation write SetOrientation default toHorizontal;
    property IndicatorColor: TDSkTabIndicatorColor read FIndicatorColor write SetIndicatorColor default ticPrimary;
    property TextColor: TDSkTabTextColor read FTextColor write SetTextColor default ttcPrimary;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property TabFont: TFont read FTabFont write SetTabFont;
    property TabHeight: Single read FTabHeight write SetTabHeight;
    property IndicatorHeight: Single read FIndicatorHeight write SetIndicatorHeight;
    property TabPadding: Single read FTabPadding write SetTabPadding;
    property Images: TCustomImageList read FImages write SetImages;
    property OnItemClick: TDSkTabsItemClickEvent read FOnItemClick write FOnItemClick;
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
  TAB_HEIGHT = 48;
  INDICATOR_HEIGHT = 3;
  TAB_PADDING = 16;
  TAB_SPACING = 0;
  MIN_TAB_WIDTH = 80;
  ICON_TEXT_GAP = 10;

function DarkenColor(AColor: TAlphaColor; AAmount: Single): TAlphaColor;
var
  R, G, B: Byte;
begin
  R := Round(((AColor shr 16) and $FF) * (1 - AAmount));
  G := Round(((AColor shr 8) and $FF) * (1 - AAmount));
  B := Round((AColor and $FF) * (1 - AAmount));
  Result := $FF000000 or (TAlphaColor(R) shl 16) or (TAlphaColor(G) shl 8) or TAlphaColor(B);
end;

function AlphaColorWithAlpha(AColor: TAlphaColor; AAlpha: Byte): TAlphaColor;
begin
  Result := (TAlphaColor(AAlpha) shl 24) or (AColor and $00FFFFFF);
end;

{ TDSkTabs }

constructor TDSkTabs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ItemsChanged;
  FItemIndex := -1;
  FVariant := tvStandard;
  FAlignment := taLeft;
  FOrientation := toHorizontal;
  FIndicatorColor := ticPrimary;
  FTextColor := ttcPrimary;
  FColorScheme := muiPrimary;
  FTabFont := TFont.Create;
  FTabFont.Name := GetDefaultFontName;
  FTabFont.Size := 12;
  FTabFont.Color := -570425344;
  FTabFont.Style := [];
  FTabFont.OnChange := TabFontChanged;
  FTabHeight := TAB_HEIGHT;
  FIndicatorHeight := INDICATOR_HEIGHT;
  FTabPadding := TAB_PADDING;
  FTabIndex := -1;
  FHoverIndex := -1;
  FTabTextWidthCache := TStringList.Create;
  FTabTextWidthCache.NameValueSeparator := '=';
  InvalidateTabFontCache;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChanged;
  Width := 300;
  Height := Round(FTabHeight + FIndicatorHeight);
  
  // Tabs 默认圆角为 0，背景透明
  CornerRadius := 0;
  BackgroundColor := TAlphaColors.Null;
  BorderColor := TAlphaColors.Null;
  BorderWidth := 0;

  // 设计期添加默认标签，让组件拖到窗体后立即可见
  if csDesigning in ComponentState then
  begin
    FItems.Add('Tab 1');
    FItems.Add('Tab 2');
    FItems.Add('Tab 3');
    FItemIndex := 0;
  end;
end;

destructor TDSkTabs.Destroy;
begin
  FTabTextWidthCache.Free;
  FItems.Free;
  FTabFont.Free;
  FImageChangeLink.Free;
  inherited;
end;

procedure TDSkTabs.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TDSkTabs.SetItemIndex(Value: Integer);
begin
  if Value < -1 then Value := -1;
  if (Value >= 0) and (Value >= FItems.Count) then Value := -1;
  if FItemIndex <> Value then
  begin
    FItemIndex := Value;
    RequestRedraw;
    if Assigned(FOnItemClick) and not (csLoading in ComponentState) and
      not (csDesigning in ComponentState) then
      FOnItemClick(Self, FItemIndex);
  end;
end;

procedure TDSkTabs.SetVariant(Value: TDSkTabsVariant);
begin
  if FVariant <> Value then
  begin
    FVariant := Value;
    RequestRedraw;
  end;
end;

procedure TDSkTabs.SetAlignment(Value: TDSkTabsAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RequestRedraw;
  end;
end;

procedure TDSkTabs.SetOrientation(Value: TDSkTabsOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    RequestRedraw;
  end;
end;

procedure TDSkTabs.SetIndicatorColor(Value: TDSkTabIndicatorColor);
begin
  if FIndicatorColor <> Value then
  begin
    FIndicatorColor := Value;
    RequestRedraw;
  end;
end;

procedure TDSkTabs.SetTextColor(Value: TDSkTabTextColor);
begin
  if FTextColor <> Value then
  begin
    FTextColor := Value;
    RequestRedraw;
  end;
end;

procedure TDSkTabs.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then
  begin
    FColorScheme := Value;
    RequestRedraw;
  end;
end;

procedure TDSkTabs.SetTabFont(Value: TFont);
begin
  FTabFont.Assign(Value);
end;

procedure TDSkTabs.SetTabHeight(Value: Single);
begin
  if FTabHeight <> Value then
  begin
    FTabHeight := Value;
    RequestRedraw;
  end;
end;

procedure TDSkTabs.SetIndicatorHeight(Value: Single);
begin
  if FIndicatorHeight <> Value then
  begin
    FIndicatorHeight := Value;
    RequestRedraw;
  end;
end;

procedure TDSkTabs.SetTabPadding(Value: Single);
begin
  if FTabPadding <> Value then
  begin
    FTabPadding := Value;
    RequestRedraw;
  end;
end;

procedure TDSkTabs.SetImages(Value: TCustomImageList);
begin
  if FImages <> nil then
    FImages.UnRegisterChanges(FImageChangeLink);
  FImages := Value;
  if FImages <> nil then
  begin
    FImages.RegisterChanges(FImageChangeLink);
    FImages.FreeNotification(Self);
  end;
  RequestRedraw;
end;

procedure TDSkTabs.ImageListChanged(Sender: TObject);
begin
  RequestRedraw;
end;

function TDSkTabs.GetItemImageIndex(Index: Integer): Integer;
var
  LStr: string;
  LColonPos: Integer;
begin
  Result := -1;
  if (Index < 0) or (Index >= FItems.Count) then Exit;
  
  // 支持 "文字:图标索引" 格式
  LStr := FItems[Index];
  LColonPos := Pos(':', LStr);
  if LColonPos > 0 then
  begin
    TryStrToInt(Copy(LStr, LColonPos + 1, Length(LStr)), Result);
  end
  else if (FImages <> nil) and (Index < FImages.Count) then
  begin
    // 如果没有指定索引，使用索引作为图标索引
    Result := Index;
  end;
end;

function TDSkTabs.GetItemText(Index: Integer): string;
var
  LColonPos: Integer;
begin
  Result := '';
  if (Index < 0) or (Index >= FItems.Count) then
    Exit;

  Result := FItems[Index];
  LColonPos := Pos(':', Result);
  if LColonPos > 0 then
    Result := Copy(Result, 1, LColonPos - 1);
end;

function TDSkTabs.GetTabContentWidth(Index: Integer): Single;
var
  LImageIndex: Integer;
begin
  Result := MeasureTabText(GetItemText(Index));

  LImageIndex := GetItemImageIndex(Index);
  if (FImages <> nil) and (LImageIndex >= 0) and (LImageIndex < FImages.Count) then
    Result := Result + FImages.Width + ICON_TEXT_GAP;
end;

procedure TDSkTabs.DrawIcon(ACanvas: ISkCanvas; const ARect: TRectF; AImageIndex: Integer; AColor: TAlphaColor);
var
  LBitmap: Vcl.Graphics.TBitmap;
  LImage: ISkImage;
  LPaint: ISkPaint;
  LDestRect: TRectF;
  LX, LY: Single;
  LImageSize: Single;
begin
  if (FImages = nil) or (AImageIndex < 0) or (AImageIndex >= FImages.Count) then Exit;
  
  LBitmap := Vcl.Graphics.TBitmap.Create;
  try
    LBitmap.SetSize(FImages.Width, FImages.Height);
    LBitmap.PixelFormat := pf32Bit;
    LBitmap.AlphaFormat := afPremultiplied;
    FillChar(LBitmap.ScanLine[FImages.Height - 1]^, FImages.Width * FImages.Height * 4, 0);
    FImages.GetBitmap(AImageIndex, LBitmap);
    LImage := BitmapToSkImage(LBitmap);
    if LImage <> nil then
    begin
      LImageSize := Min(ARect.Width, ARect.Height);
      LX := ARect.Left + (ARect.Width - LImageSize) / 2;
      LY := ARect.Top + (ARect.Height - LImageSize) / 2;
      LDestRect := RectF(LX, LY, LX + LImageSize, LY + LImageSize);

      // ImageList 只负责提供 Alpha 形状，实际颜色跟随 Tabs 当前状态。
      LPaint := TSkPaint.Create;
      LPaint.AntiAlias := True;
      LPaint.ColorFilter := TSkColorFilter.MakeBlend(AColor, TSkBlendMode.SrcIn);
      ACanvas.DrawImageRect(LImage, LDestRect, TSkSamplingOptions.Medium, LPaint);
    end;
  finally
    LBitmap.Free;
  end;
end;

procedure TDSkTabs.TabFontChanged(Sender: TObject);
begin
  InvalidateTabFontCache;
  RequestRedraw;
end;

procedure TDSkTabs.ItemsChanged(Sender: TObject);
begin
  if FItemIndex >= FItems.Count then
    FItemIndex := -1;
  FTabTextWidthCache.Clear;
  RequestRedraw;
end;

procedure TDSkTabs.RequestRedraw;
begin
  if csLoading in ComponentState then
    Exit;
  Redraw;
end;

procedure TDSkTabs.Loaded;
begin
  inherited;
  RequestRedraw;
end;

function TDSkTabs.GetTabColor: TAlphaColor;
begin
  if not Enabled then
    Exit($FFBDBDBD);

  case FColorScheme of
    muiSecondary: Result := $FF9C27B0;
    muiError: Result := $FFD32F2F;
    muiWarning: Result := $FFED6C02;
    muiInfo: Result := $FF0288D1;
    muiSuccess: Result := $FF2E7D32;
  else
    Result := $FF1976D2;
  end;
end;

function TDSkTabs.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TDSkTabs.GetTotalTabsWidth: Single;
var
  i: Integer;
  LTabWidth: Single;
begin
  Result := 0;
  for i := 0 to FItems.Count - 1 do
  begin
    LTabWidth := GetTabContentWidth(i) + FTabPadding * 2;
    if LTabWidth < MIN_TAB_WIDTH then
      LTabWidth := MIN_TAB_WIDTH;
    Result := Result + LTabWidth;
  end;
end;

function TDSkTabs.GetMaxVisibleTabs: Integer;
var
  LTotalWidth: Single;
  LTabWidth: Single;
  i: Integer;
begin
  Result := 0;
  LTotalWidth := 0;
  for i := 0 to FItems.Count - 1 do
  begin
    LTabWidth := GetTabContentWidth(i) + FTabPadding * 2;
    if LTabWidth < MIN_TAB_WIDTH then
      LTabWidth := MIN_TAB_WIDTH;
    LTotalWidth := LTotalWidth + LTabWidth;
    if LTotalWidth > ClientWidth then
      Break;
    Inc(Result);
  end;
end;

function TDSkTabs.GetTabRect(Index: Integer): TRectF;
var
  LTabWidth: Single;
  LX, LY: Single;
  LTotalWidth: Single;
  i: Integer;
begin
  if FItems.Count = 0 then
  begin
    Result := TRectF.Empty;
    Exit;
  end;

  if FOrientation = toVertical then
  begin
    // 垂直模式：标签宽度为容器宽度，垂直排列
    LTabWidth := ClientWidth;
    LY := Index * FTabHeight;
    Result := RectF(0, LY, LTabWidth, LY + FTabHeight);
  end
  else
  begin
    // 水平模式
    // 计算标签宽度
    if FAlignment = taFullWidth then
    begin
      // 全宽模式：平分容器宽度
      LTabWidth := ClientWidth / FItems.Count;
    end
    else
    begin
      // 标准/居中模式：根据文本宽度
      LTabWidth := GetTabContentWidth(Index) + FTabPadding * 2;
      if LTabWidth < MIN_TAB_WIDTH then
        LTabWidth := MIN_TAB_WIDTH;
    end;

    // 计算X位置
    if FAlignment = taFullWidth then
    begin
      LX := Index * LTabWidth;
    end
    else if FAlignment = taCenter then
    begin
      // 居中模式：计算总宽度并居中
      LTotalWidth := 0;
      for i := 0 to FItems.Count - 1 do
      begin
        LTabWidth := GetTabContentWidth(i) + FTabPadding * 2;
        if LTabWidth < MIN_TAB_WIDTH then
          LTabWidth := MIN_TAB_WIDTH;
        LTotalWidth := LTotalWidth + LTabWidth;
      end;
      
      // 计算起始X位置（居中）
      LX := (ClientWidth - LTotalWidth) / 2;
      if LX < 0 then LX := 0; // 防止负数
      
      // 计算当前标签的X位置
      for i := 0 to Index - 1 do
      begin
        LTabWidth := GetTabContentWidth(i) + FTabPadding * 2;
        if LTabWidth < MIN_TAB_WIDTH then
          LTabWidth := MIN_TAB_WIDTH;
        LX := LX + LTabWidth;
      end;
      
      // 重新计算当前标签宽度
      LTabWidth := GetTabContentWidth(Index) + FTabPadding * 2;
      if LTabWidth < MIN_TAB_WIDTH then
        LTabWidth := MIN_TAB_WIDTH;
    end
    else
    begin
      // 标准模式（靠左）：从左开始
      LX := 0;
      for i := 0 to Index - 1 do
      begin
        LTabWidth := GetTabContentWidth(i) + FTabPadding * 2;
        if LTabWidth < MIN_TAB_WIDTH then
          LTabWidth := MIN_TAB_WIDTH;
        LX := LX + LTabWidth;
      end;
    end;

    Result := RectF(LX, 0, LX + LTabWidth, FTabHeight);
  end;
end;

function TDSkTabs.GetIndicatorRect: TRectF;
var
  LTabRect: TRectF;
begin
  if (FItemIndex < 0) or (FItemIndex >= FItems.Count) then
  begin
    Result := TRectF.Empty;
    Exit;
  end;

  LTabRect := GetTabRect(FItemIndex);
  if FOrientation = toHorizontal then
    // 水平模式：指示器在底部
    Result := RectF(LTabRect.Left, LTabRect.Bottom, LTabRect.Right, LTabRect.Bottom + FIndicatorHeight)
  else
    // 垂直模式：指示器在右侧内部（不超出标签边界）
    Result := RectF(LTabRect.Right - FIndicatorHeight, LTabRect.Top, LTabRect.Right, LTabRect.Bottom);
end;

function TDSkTabs.HitTest(X, Y: Integer): Integer;
var
  i: Integer;
  LRect: TRectF;
begin
  Result := -1;
  for i := 0 to FItems.Count - 1 do
  begin
    LRect := GetTabRect(i);
    if LRect.Contains(PointF(X, Y)) then
      Exit(i);
  end;
end;

procedure TDSkTabs.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
var
  LUseVisualState: Boolean;
  LPaint: ISkPaint;
begin
  // BottomNav 样式：绘制深色背景
  if FVariant = tvBottomNav then
  begin
    LPaint := TSkPaint.Create;
    LPaint.AntiAlias := True;
    LPaint.Style := TSkPaintStyle.Fill;
    LPaint.Color := DarkenColor(GetTabColor, 0.3);
    ACanvas.DrawRect(ADest, LPaint);
  end;

  // 当父容器有 hover 效果时，需要获取父容器的视觉背景色（含 hover 状态），
  // 否则 DrawParentBackground 只会绘制父容器的存储背景色，hover 时背景不变。
  LUseVisualState := (csDesigning in ComponentState) or
    ((Parent is TDSCustomSkControl) and TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack);
  DrawParentBackground(ACanvas, ADest, LUseVisualState);
  
  // BottomNav 样式需要重新绘制背景（因为 DrawParentBackground 会覆盖）
  if FVariant = tvBottomNav then
  begin
    LPaint := TSkPaint.Create;
    LPaint.AntiAlias := True;
    LPaint.Style := TSkPaintStyle.Fill;
    LPaint.Color := DarkenColor(GetTabColor, 0.3);
    ACanvas.DrawRect(ADest, LPaint);
  end;

  DrawTabs(ACanvas, ADest);
  DrawIndicator(ACanvas, ADest);
end;

procedure TDSkTabs.DrawTabs(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  i: Integer;
begin
  for i := 0 to FItems.Count - 1 do
    DrawTab(ACanvas, ADest, i);
end;

procedure TDSkTabs.DrawTab(const ACanvas: ISkCanvas; const ADest: TRectF; Index: Integer);
var
  LRect: TRectF;
  LFont: ISkFont;
  LPaint: ISkPaint;
  LTextWidth: Single;
  LTextX, LTextY: Single;
  LColor: TAlphaColor;
  LFontSize: Single;
  LIsContained: Boolean;
  LIsBottomNav: Boolean;
  LItemText: string;
  LImageIndex: Integer;
  LIconRect: TRectF;
  LHasIcon: Boolean;
  LContentWidth: Single;
  LContentLeft: Single;
begin
  if (Index < 0) or (Index >= FItems.Count) then Exit;

  LRect := GetTabRect(Index);
  LFont := GetTabFontCache;
  LFontSize := FontSizeToPixels(FTabFont);
  LIsContained := False; // tvContained 已移除
  LIsBottomNav := (FVariant = tvBottomNav);

  // 解析项目文本（支持 "文字:图标索引" 格式），图标索引只参与绘制，不显示给用户。
  LItemText := GetItemText(Index);
  LTextWidth := MeasureTabText(LItemText);
  LImageIndex := GetItemImageIndex(Index);
  LHasIcon := (FImages <> nil) and (LImageIndex >= 0) and (LImageIndex < FImages.Count);
  LContentWidth := LTextWidth;
  if LHasIcon then
    LContentWidth := LContentWidth + FImages.Width + ICON_TEXT_GAP;

  // 绘制标签背景
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Fill;
  
  if LIsBottomNav then
  begin
    // BottomNav 样式：选中项不绘制背景（只显示文字+选择条+图标）
    // 悬停时显示浅色背景
    if Index = FHoverIndex then
    begin
      LPaint.Color := AlphaColorWithAlpha(TAlphaColors.White, $1A); // 10% 白色
      ACanvas.DrawRoundRect(RectF(LRect.Left + 4, LRect.Top + 4, 
        LRect.Right - 4, LRect.Bottom - 4), 4, 4, LPaint);
    end;
  end
  else if LIsContained then
  begin
    // Contained 样式：选中项有背景色，未选中项透明
    if Index = FItemIndex then
    begin
      // 选中状态：深色背景
      LPaint.Color := DarkenColor(GetTabColor, 0.3);
      // 绘制圆角背景
      ACanvas.DrawRoundRect(RectF(LRect.Left + 2, LRect.Top + 2, 
        LRect.Right - 2, LRect.Bottom - 2), 4, 4, LPaint);
    end
    else if Index = FHoverIndex then
    begin
      // 悬停状态：浅色背景
      LPaint.Color := AlphaColorWithAlpha(GetTabColor, $0D); // 5% 透明度
      ACanvas.DrawRoundRect(RectF(LRect.Left + 2, LRect.Top + 2, 
        LRect.Right - 2, LRect.Bottom - 2), 4, 4, LPaint);
    end;
  end
  else
  begin
    // Standard 样式：仅悬停时有背景色
    if Index = FHoverIndex then
      LPaint.Color := AlphaColorWithAlpha(GetTabColor, $14) // 8% 透明度
    else
      LPaint.Color := TAlphaColors.Null;
    
    ACanvas.DrawRect(LRect, LPaint);
  end;

  // 绘制图标
  if LHasIcon then
  begin
    // BottomNav 样式：图标在上，文字在下
    if LIsBottomNav then
    begin
      // 计算图标区域（上半部分）
      LIconRect := RectF(
        LRect.Left,
        LRect.Top + 4,
        LRect.Right,
        LRect.Top + (LRect.Height - FTabHeight * 0.35) / 2 + 4
      );
      
      // 设置图标颜色
      if Index = FItemIndex then
        LColor := TAlphaColors.White
      else
        LColor := $FFB0B0B0;
      
      DrawIcon(ACanvas, LIconRect, LImageIndex, LColor);
    end
    else
    begin
      // 其他样式：图标在文字左侧。垂直导航左对齐，水平标签整体居中。
      if FOrientation = toVertical then
        LContentLeft := LRect.Left + FTabPadding
      else
        LContentLeft := LRect.Left + (LRect.Width - LContentWidth) / 2;

      LIconRect := RectF(
        LContentLeft,
        LRect.Top + (LRect.Height - FImages.Height) / 2,
        LContentLeft + FImages.Width,
        LRect.Top + (LRect.Height + FImages.Height) / 2
      );
      
      // 设置图标颜色
      if Index = FItemIndex then
      begin
        if LIsContained then
          LColor := TAlphaColors.White
        else
          LColor := GetTabColor;
      end
      else
        LColor := $FF757575;
      
      DrawIcon(ACanvas, LIconRect, LImageIndex, LColor);
    end;
  end;

  // 绘制标签文字
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Fill;
  
  // 根据选中状态和颜色方案设置文字颜色
  if Index = FItemIndex then
  begin
    if LIsBottomNav then
    begin
      // BottomNav 样式选中状态：有背景色，使用白色文字
      LColor := TAlphaColors.White;
    end
    else
    begin
      // Standard 样式选中状态：使用主题色
      case FTextColor of
        ttcPrimary: LColor := GetTabColor;
        ttcSecondary: LColor := DarkenColor(GetTabColor, 0.2);
      else
        LColor := GetTabColor;
      end;
    end;
  end
  else
  begin
    // 未选中状态
    if LIsBottomNav then
    begin
      // BottomNav 样式：有背景色，使用浅白色文字
      LColor := $FFB0B0B0;
    end
    else
    begin
      // Standard 样式：未选中文字使用灰色
      LColor := $FF757575;
    end;
  end;
  
  LPaint.Color := LColor;

  // 计算文字位置。垂直导航采用左对齐，水平标签继续整体居中。
  if LIsBottomNav then
  begin
    // BottomNav 样式：文字在下半部分
    LTextX := LRect.Left + (LRect.Width - LTextWidth) / 2;
    LTextY := LRect.Bottom - FTabHeight * 0.35 + 4;
  end
  else
  begin
    if FOrientation = toVertical then
      LTextX := LRect.Left + FTabPadding
    else
      LTextX := LRect.Left + (LRect.Width - LContentWidth) / 2;
    if LHasIcon then
      LTextX := LTextX + FImages.Width + ICON_TEXT_GAP;
    LTextY := LRect.Top + (LRect.Height + LFontSize) / 2 - 2;
  end;

  ACanvas.DrawSimpleText(LItemText, LTextX, LTextY, LFont, LPaint);
end;

procedure TDSkTabs.DrawIndicator(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LRect: TRectF;
  LPaint: ISkPaint;
  LColor: TAlphaColor;
begin
  if (FItemIndex < 0) or (FItemIndex >= FItems.Count) then Exit;

  LRect := GetIndicatorRect;
  if LRect.IsEmpty then Exit;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Fill;

  // 根据指示器颜色方案设置颜色
  if FVariant = tvBottomNav then
  begin
    // BottomNav 样式：使用白色指示条
    LColor := TAlphaColors.White;
  end
  else
  begin
    case FIndicatorColor of
      ticPrimary: LColor := GetTabColor;
      ticSecondary: LColor := DarkenColor(GetTabColor, 0.2);
    else
      LColor := GetTabColor;
    end;
  end;

  LPaint.Color := LColor;

  // 绘制指示器（带圆角）
  ACanvas.DrawRoundRect(LRect, 2, 2, LPaint);
end;

procedure TDSkTabs.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LIndex: Integer;
begin
  inherited;
  if Button = mbLeft then
  begin
    LIndex := HitTest(X, Y);
    if LIndex >= 0 then
      SetItemIndex(LIndex);
  end;
end;

procedure TDSkTabs.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  LIndex: Integer;
begin
  inherited;
  LIndex := HitTest(X, Y);
  if LIndex <> FHoverIndex then
  begin
    FHoverIndex := LIndex;
    Redraw;
  end;
end;

procedure TDSkTabs.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FHoverIndex := -1;
  Redraw;
end;

procedure TDSkTabs.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  RequestRedraw;
end;

procedure TDSkTabs.Resize;
begin
  inherited;
  RequestRedraw;
end;

function TDSkTabs.DependsOnParentBackground: Boolean;
begin
  // Tabs 需要视觉透明，因此依赖父背景
  Result := True;
end;

function TDSkTabs.DependsOnParentVisualBackground: Boolean;
begin
  // 当父容器有 hover 效果时，需要获取父容器的视觉背景色
  Result := (Parent is TDSCustomSkControl) and 
    TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack;
end;

function TDSkTabs.ShouldClipWindowRegion: Boolean;
begin
  // Tabs 不需要窗口裁剪，因为它是自绘组件
  Result := False;
end;

procedure TDSkTabs.InvalidateTabFontCache;
begin
  FTabCacheFont := nil;
  FTabCacheTypeface := nil;
  FTabCacheFontName := '';
  FTabCacheFontStyle := TSkFontStyle.Normal;
  FTabCacheFontSize := 0;
  FTabCachePPI := 0;
end;

function TDSkTabs.GetTabFontCache: ISkFont;
var
  LTypeface: ISkTypeface;
  LFontName: string;
  LFontStyle: TSkFontStyle;
  LFontSize: Single;
  LPPI: Integer;
begin
  LFontName := FTabFont.Name;
  LFontSize := FTabFont.Size;
  LPPI := GetEffectivePPI;
  
  // 将 TFontStyles 转换为 TSkFontStyle
  if (fsBold in FTabFont.Style) and (fsItalic in FTabFont.Style) then
    LFontStyle := TSkFontStyle.BoldItalic
  else if fsBold in FTabFont.Style then
    LFontStyle := TSkFontStyle.Bold
  else if fsItalic in FTabFont.Style then
    LFontStyle := TSkFontStyle.Italic
  else
    LFontStyle := TSkFontStyle.Normal;

  if (FTabCacheFont = nil) or (FTabCacheFontName <> LFontName) or
    (FTabCacheFontStyle <> LFontStyle) or (FTabCacheFontSize <> LFontSize) or
    (FTabCachePPI <> LPPI) then
  begin
    LTypeface := TSkTypeface.MakeFromName(LFontName, LFontStyle);
    FTabCacheFont := TSkFont.Create(LTypeface, FontSizeToPixels(FTabFont));
    FTabCacheTypeface := LTypeface;
    FTabCacheFontName := LFontName;
    FTabCacheFontStyle := LFontStyle;
    FTabCacheFontSize := LFontSize;
    FTabCachePPI := LPPI;
  end;

  Result := FTabCacheFont;
end;

function TDSkTabs.MeasureTabText(const AText: string): Single;
var
  LFont: ISkFont;
  LTextWidth: Single;
  LKey: string;
begin
  LKey := AText + '|' + FTabFont.Name + '|' + IntToStr(FTabFont.Size);
  FTabTextWidthCache.Values[LKey];
  
  if FTabTextWidthCache.IndexOfName(LKey) >= 0 then
    LTextWidth := StrToFloatDef(FTabTextWidthCache.Values[LKey], 0)
  else
  begin
    LFont := GetTabFontCache;
    LTextWidth := LFont.MeasureText(AText);
    FTabTextWidthCache.Values[LKey] := FloatToStr(LTextWidth);
  end;
  
  Result := LTextWidth;
end;

end.
