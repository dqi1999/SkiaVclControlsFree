unit SkiaVclControls.CheckboxGroup;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  System.Generics.Collections,
  Vcl.Controls, Vcl.Graphics, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  TDSkCheckboxGroupItemClickEvent = procedure(Sender: TObject;
    ItemIndex: Integer; Checked: Boolean) of object;

  { TDSkCheckboxGroup - MUI 风格的复选框组容器
    自行绘制所有复选框，不创建子组件。支持多选和单选模式。
    默认多选模式（Exclusive=False），可设置 Exclusive=True 切换为单选。 }
  TDSkCheckboxGroup = class(TDSCustomSkControl)
  private
    FOrientation: TDSkRadioGroupOrientation;
    FItems: TStrings;
    FCheckedItems: TList<Integer>;
    FColorScheme: TDSkMUIColorScheme;
    FLabelPlacement: TDSkRadioLabelPlacement;
    FExclusive: Boolean;
    FAllowNone: Boolean;
    FHoverIndex: Integer;
    FCaption: string;
    FCaptionFont: TFont;
    FCaptionMargin: Single;
    FCheckboxSize: Single;
    FItemFont: TFont;
    FOnItemClick: TDSkCheckboxGroupItemClickEvent;
    FCaptionCacheFont: ISkFont;
    FCaptionCacheTypeface: ISkTypeface;
    FCaptionCacheFontName: string;
    FCaptionCacheFontStyle: TFontStyles;
    FCaptionCacheFontSize: Single;
    FCaptionCachePPI: Integer;
    FItemCacheFont: ISkFont;
    FItemCacheTypeface: ISkTypeface;
    FItemCacheFontName: string;
    FItemCacheFontStyle: TFontStyles;
    FItemCacheFontSize: Single;
    FItemCachePPI: Integer;
    FItemTextWidthCache: TStringList;
    procedure SetOrientation(Value: TDSkRadioGroupOrientation);
    procedure SetItems(Value: TStrings);
    procedure SetColorScheme(Value: TDSkMUIColorScheme);
    procedure SetLabelPlacement(Value: TDSkRadioLabelPlacement);
    procedure SetExclusive(Value: Boolean);
    procedure SetAllowNone(Value: Boolean);
    procedure SetCaption(const Value: string);
    procedure SetCaptionFont(Value: TFont);
    procedure SetCaptionMargin(Value: Single);
    procedure SetCheckboxSize(Value: Single);
    procedure SetItemFont(Value: TFont);
    procedure CaptionFontChanged(Sender: TObject);
    procedure ItemFontChanged(Sender: TObject);
    procedure ItemsChanged(Sender: TObject);
    procedure RequestRedraw;
    function GetItemRect(Index: Integer): TRectF;
    function GetCheckboxCenter(Index: Integer): TPointF;
    function HitTest(X, Y: Integer): Integer;
    function GetCheckboxColor: TAlphaColor;
    function GetItemCount: Integer;
    function GetTitleHeight: Single;
    procedure InvalidateCaptionFontCache;
    procedure InvalidateItemFontCache;
    function GetCaptionFontCache: ISkFont;
    function GetItemFontCache: ISkFont;
    function MeasureItemText(const AText: string): Single;
    function GetCheckedItems: TList<Integer>;
    procedure SetCheckedItems(Value: TList<Integer>);
  protected
    procedure Loaded; override;
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawTitle(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawItem(const ACanvas: ISkCanvas; const ADest: TRectF; Index: Integer);
    procedure DrawItemCheckbox(const ACanvas: ISkCanvas; const ACenter: TPointF; AChecked, AIndeterminate: Boolean; AColor: TAlphaColor);
    procedure DrawCheckMark(const ACanvas: ISkCanvas; const ACenter: TPointF; ASize: Single);
    procedure DrawIndeterminateMark(const ACanvas: ISkCanvas; const ACenter: TPointF; ASize: Single);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Resize; override;
    function DependsOnParentBackground: Boolean; override;
    function DependsOnParentVisualBackground: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ShouldClipWindowRegion: Boolean; override;
    function IsItemChecked(Index: Integer): Boolean;
    procedure SetItemChecked(Index: Integer; Value: Boolean);
    procedure ClearCheckedItems;
    property ItemCount: Integer read GetItemCount;
    property CheckedItems: TList<Integer> read GetCheckedItems write SetCheckedItems;
  published
    property Orientation: TDSkRadioGroupOrientation read FOrientation write SetOrientation default rgoVertical;
    property Items: TStrings read FItems write SetItems;
    property Caption: string read FCaption write SetCaption;
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property CaptionMargin: Single read FCaptionMargin write SetCaptionMargin;
    property CheckboxSize: Single read FCheckboxSize write SetCheckboxSize;
    property ItemFont: TFont read FItemFont write SetItemFont;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property LabelPlacement: TDSkRadioLabelPlacement read FLabelPlacement write SetLabelPlacement default rlpRight;
    property Exclusive: Boolean read FExclusive write SetExclusive default False;
    property AllowNone: Boolean read FAllowNone write SetAllowNone default True;
    property OnItemClick: TDSkCheckboxGroupItemClickEvent read FOnItemClick write FOnItemClick;
    property CornerRadius stored IsCornerRadiusStored;
    property BackgroundColor;
    property BorderColor;
    property BorderWidth;
    property OnClick;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

implementation

function DarkenColor(AColor: TAlphaColor; AAmount: Single): TAlphaColor;
var
  R, G, B: Byte;
begin
  R := Round(((AColor shr 16) and $FF) * (1 - AAmount));
  G := Round(((AColor shr 8) and $FF) * (1 - AAmount));
  B := Round((AColor and $FF) * (1 - AAmount));
  Result := $FF000000 or (TAlphaColor(R) shl 16) or (TAlphaColor(G) shl 8) or TAlphaColor(B);
end;

const
  ITEM_SPACING_V = 8;
  ITEM_SPACING_H = 16;
  LABEL_GAP = 8;
  ITEM_HEIGHT = 28;
  ITEM_WIDTH = 140;

{ TDSkCheckboxGroup }

constructor TDSkCheckboxGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOrientation := rgoVertical;
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ItemsChanged;
  FCheckedItems := TList<Integer>.Create;
  FColorScheme := muiPrimary;
  FLabelPlacement := rlpRight;
  FExclusive := False; // 默认多选模式
  FAllowNone := True;
  FHoverIndex := -1;
  FCaption := '';
  FCaptionFont := TFont.Create;
  FCaptionFont.Name := GetDefaultFontName;
  FCaptionFont.Size := 10;
  FCaptionFont.Color := -9079435;
  FCaptionFont.Style := [];
  FCaptionFont.OnChange := CaptionFontChanged;
  FCaptionMargin := 8;
  FCheckboxSize := 20;
  FItemFont := TFont.Create;
  FItemFont.Name := GetDefaultFontName;
  FItemFont.Size := 12;
  FItemFont.Color := -570425344;
  FItemFont.Style := [];
  FItemFont.OnChange := ItemFontChanged;
  FItemTextWidthCache := TStringList.Create;
  FItemTextWidthCache.NameValueSeparator := '=';
  InvalidateCaptionFontCache;
  InvalidateItemFontCache;
  Width := 200;
  Height := 150;

  // CheckboxGroup 使用伪透明，通过 DrawParentBackground 绘制父背景
  CornerRadius := 0;
  BackgroundColor := TAlphaColors.Null;
  BorderColor := TAlphaColors.Null;
  BorderWidth := 0;

  // 设计期添加默认选项，让组件拖到窗体后立即可见
  if csDesigning in ComponentState then
  begin
    FItems.Add('Option 1');
    FItems.Add('Option 2');
    FItems.Add('Option 3');
  end;
end;

destructor TDSkCheckboxGroup.Destroy;
begin
  FItemTextWidthCache.Free;
  FCheckedItems.Free;
  FItems.Free;
  FCaptionFont.Free;
  FItemFont.Free;
  inherited;
end;

procedure TDSkCheckboxGroup.SetOrientation(Value: TDSkRadioGroupOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    RequestRedraw;
  end;
end;

procedure TDSkCheckboxGroup.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TDSkCheckboxGroup.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then
  begin
    FColorScheme := Value;
    RequestRedraw;
  end;
end;

procedure TDSkCheckboxGroup.SetLabelPlacement(Value: TDSkRadioLabelPlacement);
begin
  if FLabelPlacement <> Value then
  begin
    FLabelPlacement := Value;
    RequestRedraw;
  end;
end;

procedure TDSkCheckboxGroup.SetExclusive(Value: Boolean);
begin
  if FExclusive <> Value then
  begin
    FExclusive := Value;
    // 切换到单选模式时，只保留第一个选中项
    if Value and (FCheckedItems.Count > 1) then
    begin
      FCheckedItems.Clear;
      RequestRedraw;
    end;
  end;
end;

procedure TDSkCheckboxGroup.SetAllowNone(Value: Boolean);
begin
  FAllowNone := Value;
end;

procedure TDSkCheckboxGroup.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    InvalidateCaptionFontCache;
    RequestRedraw;
  end;
end;

procedure TDSkCheckboxGroup.SetCaptionFont(Value: TFont);
begin
  FCaptionFont.Assign(Value);
end;

procedure TDSkCheckboxGroup.SetCaptionMargin(Value: Single);
begin
  if FCaptionMargin <> Value then
  begin
    FCaptionMargin := Value;
    RequestRedraw;
  end;
end;

procedure TDSkCheckboxGroup.CaptionFontChanged(Sender: TObject);
begin
  InvalidateCaptionFontCache;
  RequestRedraw;
end;

procedure TDSkCheckboxGroup.ItemFontChanged(Sender: TObject);
begin
  InvalidateItemFontCache;
  RequestRedraw;
end;

procedure TDSkCheckboxGroup.SetCheckboxSize(Value: Single);
begin
  if FCheckboxSize <> Value then
  begin
    FCheckboxSize := Value;
    RequestRedraw;
  end;
end;

procedure TDSkCheckboxGroup.SetItemFont(Value: TFont);
begin
  FItemFont.Assign(Value);
  InvalidateItemFontCache;
end;

procedure TDSkCheckboxGroup.ItemsChanged(Sender: TObject);
var
  i: Integer;
begin
  // 清除超出范围的选中项（从后往前删除避免索引偏移）
  for i := FCheckedItems.Count - 1 downto 0 do
  begin
    if FCheckedItems[i] >= FItems.Count then
      FCheckedItems.Delete(i);
  end;
  FItemTextWidthCache.Clear;
  RequestRedraw;
end;

procedure TDSkCheckboxGroup.RequestRedraw;
begin
  if csLoading in ComponentState then
    Exit;
  Redraw;
end;

procedure TDSkCheckboxGroup.Loaded;
begin
  inherited;
  RequestRedraw;
end;

function TDSkCheckboxGroup.GetCheckboxColor: TAlphaColor;
begin
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

function TDSkCheckboxGroup.GetTitleHeight: Single;
var
  LFont: ISkFont;
begin
  if FCaption = '' then
    Result := 0
  else
  begin
    LFont := GetCaptionFontCache;
    Result := LFont.Size + FCaptionMargin;
  end;
end;

function TDSkCheckboxGroup.GetItemRect(Index: Integer): TRectF;
var
  LTitleHeight: Single;
  LItemHeight: Single;
begin
  LTitleHeight := GetTitleHeight;
  LItemHeight := FCheckboxSize + 8;

  if FOrientation = rgoVertical then
    Result := RectF(0, LTitleHeight + Index * (LItemHeight + ITEM_SPACING_V), ClientWidth,
      LTitleHeight + Index * (LItemHeight + ITEM_SPACING_V) + LItemHeight)
  else
    Result := RectF(Index * (ITEM_WIDTH + ITEM_SPACING_H), 0,
      Index * (ITEM_WIDTH + ITEM_SPACING_H) + ITEM_WIDTH, ClientHeight);
end;

function TDSkCheckboxGroup.GetCheckboxCenter(Index: Integer): TPointF;
var
  LRect: TRectF;
begin
  LRect := GetItemRect(Index);
  case FLabelPlacement of
    rlpRight: Result := PointF(LRect.Left + FCheckboxSize / 2 + 4, LRect.Top + LRect.Height / 2);
    rlpLeft: Result := PointF(LRect.Right - FCheckboxSize / 2 - 4, LRect.Top + LRect.Height / 2);
    rlpTop: Result := PointF(LRect.Left + LRect.Width / 2, LRect.Bottom - FCheckboxSize / 2 - 4);
    rlpBottom: Result := PointF(LRect.Left + LRect.Width / 2, LRect.Top + FCheckboxSize / 2 + 4);
  else
    Result := PointF(LRect.Left + FCheckboxSize / 2 + 4, LRect.Top + LRect.Height / 2);
  end;
end;

function TDSkCheckboxGroup.HitTest(X, Y: Integer): Integer;
var
  i: Integer;
  LRect: TRectF;
begin
  Result := -1;
  for i := 0 to FItems.Count - 1 do
  begin
    LRect := GetItemRect(i);
    if LRect.Contains(PointF(X, Y)) then
      Exit(i);
  end;
end;

function TDSkCheckboxGroup.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TDSkCheckboxGroup.GetCheckedItems: TList<Integer>;
begin
  Result := FCheckedItems;
end;

procedure TDSkCheckboxGroup.SetCheckedItems(Value: TList<Integer>);
begin
  FCheckedItems.Clear;
  FCheckedItems.AddRange(Value);
  RequestRedraw;
end;

function TDSkCheckboxGroup.IsItemChecked(Index: Integer): Boolean;
begin
  Result := FCheckedItems.Contains(Index);
end;

procedure TDSkCheckboxGroup.SetItemChecked(Index: Integer; Value: Boolean);
var
  LItemIndex: Integer;
begin
  if (Index < 0) or (Index >= FItems.Count) then Exit;

  LItemIndex := FCheckedItems.IndexOf(Index);
  if Value then
  begin
    if LItemIndex < 0 then
    begin
      if FExclusive then
        FCheckedItems.Clear;
      FCheckedItems.Add(Index);
    end;
  end
  else
  begin
    if LItemIndex >= 0 then
      FCheckedItems.Delete(LItemIndex);
  end;
  RequestRedraw;
end;

procedure TDSkCheckboxGroup.ClearCheckedItems;
begin
  FCheckedItems.Clear;
  RequestRedraw;
end;

function TDSkCheckboxGroup.ShouldClipWindowRegion: Boolean;
begin
  // CheckboxGroup 不需要圆角裁剪，保持透明背景
  Result := False;
end;

function TDSkCheckboxGroup.DependsOnParentBackground: Boolean;
begin
  Result := False;
end;

function TDSkCheckboxGroup.DependsOnParentVisualBackground: Boolean;
begin
  if Parent is TDSCustomSkControl then
    Result := TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack
  else
    Result := False;
end;

procedure TDSkCheckboxGroup.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
var
  i: Integer;
begin
  ACanvas.Clear(TAlphaColors.Null);
  DrawTitle(ACanvas, ADest);
  for i := 0 to FItems.Count - 1 do
    DrawItem(ACanvas, ADest, i);
end;

procedure TDSkCheckboxGroup.DrawTitle(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LFont: ISkFont;
  LPaint: ISkPaint;
begin
  if FCaption = '' then Exit;

  LFont := GetCaptionFontCache;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Fill;
  LPaint.Color := VclColorToAlphaColor(FCaptionFont.Color);

  ACanvas.DrawSimpleText(FCaption, ADest.Left, ADest.Top + LFont.Size, LFont, LPaint);
end;

procedure TDSkCheckboxGroup.DrawItem(const ACanvas: ISkCanvas; const ADest: TRectF; Index: Integer);
var
  LCenter: TPointF;
  LPaint: ISkPaint;
  LColor: TAlphaColor;
  LFont: ISkFont;
  LX, LY: Single;
  LTextW, LFontSize: Single;
  LItemRect: TRectF;
  LChecked: Boolean;
  LText: string;
begin
  if (Index < 0) or (Index >= FItems.Count) then Exit;

  LChecked := IsItemChecked(Index);
  LColor := GetCheckboxColor;
  LCenter := GetCheckboxCenter(Index);
  LItemRect := GetItemRect(Index);

  // 确定颜色
  if (not Enabled) or IsParentDisabled then
    LColor := $FFBDBDBD
  else if FHoverIndex = Index then
    LColor := DarkenColor(LColor, 0.15);

  // 绘制 Checkbox
  DrawItemCheckbox(ACanvas, LCenter, LChecked, False, LColor);

  // 绘制标签文字
  LText := FItems[Index];
  if LText <> '' then
  begin
    LFont := GetItemFontCache;
    LFontSize := LFont.Size;
    LTextW := MeasureItemText(LText);

    LPaint := TSkPaint.Create;
    LPaint.AntiAlias := True;
    LPaint.Style := TSkPaintStyle.Fill;
    if (not Enabled) or IsParentDisabled then
      LPaint.Color := $FF757575
    else
      LPaint.Color := VclColorToAlphaColor(FItemFont.Color);

    case FLabelPlacement of
      rlpRight: begin
        LX := LCenter.X + FCheckboxSize / 2 + LABEL_GAP;
        LY := LItemRect.Top + (LItemRect.Height + LFontSize) / 2 - 2;
      end;
      rlpLeft: begin
        LX := LCenter.X - FCheckboxSize / 2 - LABEL_GAP - LTextW;
        LY := LItemRect.Top + (LItemRect.Height + LFontSize) / 2 - 2;
      end;
      rlpTop: begin
        LX := LItemRect.Left + (LItemRect.Width - LTextW) / 2;
        LY := LCenter.Y - FCheckboxSize / 2 - LABEL_GAP;
      end;
      rlpBottom: begin
        LX := LItemRect.Left + (LItemRect.Width - LTextW) / 2;
        LY := LCenter.Y + FCheckboxSize / 2 + LABEL_GAP + LFontSize;
      end;
    else
      begin
        LX := LCenter.X + FCheckboxSize / 2 + LABEL_GAP;
        LY := LItemRect.Top + (LItemRect.Height + LFontSize) / 2 - 2;
      end;
    end;

    ACanvas.DrawSimpleText(LText, LX, LY, LFont, LPaint);
  end;
end;

procedure TDSkCheckboxGroup.DrawItemCheckbox(const ACanvas: ISkCanvas;
  const ACenter: TPointF; AChecked, AIndeterminate: Boolean; AColor: TAlphaColor);
var
  LHalfSize: Single;
  LPaint: ISkPaint;
  LRoundRect: ISkRoundRect;
  LCornerRadius: Single;
begin
  LHalfSize := FCheckboxSize / 2;
  LCornerRadius := 3;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;

  // 创建圆角矩形路径
  LRoundRect := TSkRoundRect.Create;
  LRoundRect.SetRect(RectF(
    ACenter.X - LHalfSize,
    ACenter.Y - LHalfSize,
    ACenter.X + LHalfSize,
    ACenter.Y + LHalfSize
  ), LCornerRadius, LCornerRadius);

  if AChecked or AIndeterminate then
  begin
    // 选中或不确定状态：实心圆角矩形
    LPaint.Style := TSkPaintStyle.Fill;
    if (not Enabled) or IsParentDisabled then
      LPaint.Color := $FFBDBDBD
    else
      LPaint.Color := AColor;
    ACanvas.DrawRoundRect(LRoundRect, LPaint);

    // 绘制勾选或横线图标
    if AIndeterminate then
      DrawIndeterminateMark(ACanvas, ACenter, FCheckboxSize)
    else
      DrawCheckMark(ACanvas, ACenter, FCheckboxSize);
  end
  else
  begin
    // 未选中状态：空心圆角矩形
    LPaint.Style := TSkPaintStyle.Stroke;
    LPaint.StrokeWidth := 2;
    LPaint.Color := AColor;
    ACanvas.DrawRoundRect(LRoundRect, LPaint);
  end;
end;

procedure TDSkCheckboxGroup.DrawCheckMark(const ACanvas: ISkCanvas; const ACenter: TPointF; ASize: Single);
var
  LPathBuilder: ISkPathBuilder;
  LPath: ISkPath;
  LPaint: ISkPaint;
  LScale: Single;
begin
  LScale := ASize / 24;

  LPathBuilder := TSkPathBuilder.Create;
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
  LPaint.Color := $FFFFFFFF;
  LPaint.StrokeCap := TSkStrokeCap.Round;
  LPaint.StrokeJoin := TSkStrokeJoin.Round;

  ACanvas.DrawPath(LPath, LPaint);
end;

procedure TDSkCheckboxGroup.DrawIndeterminateMark(const ACanvas: ISkCanvas; const ACenter: TPointF; ASize: Single);
var
  LPaint: ISkPaint;
  LScale: Single;
  LStartX, LEndX, LY: Single;
begin
  LScale := ASize / 24;

  LStartX := ACenter.X - 5 * LScale;
  LEndX := ACenter.X + 5 * LScale;
  LY := ACenter.Y;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Stroke;
  LPaint.StrokeWidth := 2 * LScale;
  LPaint.Color := $FFFFFFFF;
  LPaint.StrokeCap := TSkStrokeCap.Round;

  ACanvas.DrawLine(PointF(LStartX, LY), PointF(LEndX, LY), LPaint);
end;

procedure TDSkCheckboxGroup.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LIndex: Integer;
  LItemPos: Integer;
begin
  inherited;
  if Button <> mbLeft then Exit;
  if not Enabled or IsParentDisabled then Exit;

  LIndex := HitTest(X, Y);
  if LIndex >= 0 then
  begin
    if FExclusive then
    begin
      // 单选模式
      LItemPos := FCheckedItems.IndexOf(LIndex);
      if LItemPos >= 0 then
      begin
        // 已选中，允许取消
        if FAllowNone then
          FCheckedItems.Delete(LItemPos);
      end
      else
      begin
        // 未选中，清除其他并选中当前
        FCheckedItems.Clear;
        FCheckedItems.Add(LIndex);
      end;
    end
    else
    begin
      // 多选模式
      LItemPos := FCheckedItems.IndexOf(LIndex);
      if LItemPos >= 0 then
        FCheckedItems.Delete(LItemPos)
      else
        FCheckedItems.Add(LIndex);
    end;

    RequestRedraw;
    if Assigned(FOnItemClick) and not (csDesigning in ComponentState) then
      FOnItemClick(Self, LIndex, IsItemChecked(LIndex));
  end;
end;

procedure TDSkCheckboxGroup.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  LIndex: Integer;
begin
  inherited;
  LIndex := HitTest(X, Y);
  if LIndex <> FHoverIndex then
  begin
    FHoverIndex := LIndex;
    RequestRedraw;
  end;
end;

procedure TDSkCheckboxGroup.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FHoverIndex >= 0 then
  begin
    FHoverIndex := -1;
    RequestRedraw;
  end;
end;

procedure TDSkCheckboxGroup.Resize;
begin
  inherited;
  RequestRedraw;
end;

procedure TDSkCheckboxGroup.InvalidateCaptionFontCache;
begin
  FCaptionCacheFont := nil;
  FCaptionCacheTypeface := nil;
  FCaptionCacheFontName := '';
  FCaptionCacheFontStyle := [];
  FCaptionCacheFontSize := -1;
  FCaptionCachePPI := 0;
end;

procedure TDSkCheckboxGroup.InvalidateItemFontCache;
begin
  FItemCacheFont := nil;
  FItemCacheTypeface := nil;
  FItemCacheFontName := '';
  FItemCacheFontStyle := [];
  FItemCacheFontSize := -1;
  FItemCachePPI := 0;
  FItemTextWidthCache.Clear;
end;

function TDSkCheckboxGroup.GetCaptionFontCache: ISkFont;
var
  LFontStyle: TSkFontStyle;
  LPPI: Integer;
  LFontSize: Single;
begin
  LPPI := GetEffectivePPI;
  LFontSize := FontSizeToPixels(FCaptionFont);
  if (fsBold in FCaptionFont.Style) and (fsItalic in FCaptionFont.Style) then
    LFontStyle := TSkFontStyle.BoldItalic
  else if fsBold in FCaptionFont.Style then
    LFontStyle := TSkFontStyle.Bold
  else if fsItalic in FCaptionFont.Style then
    LFontStyle := TSkFontStyle.Italic
  else
    LFontStyle := TSkFontStyle.Normal;

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
  end;
  Result := FCaptionCacheFont;
end;

function TDSkCheckboxGroup.GetItemFontCache: ISkFont;
var
  LFontStyle: TSkFontStyle;
  LPPI: Integer;
  LFontSize: Single;
begin
  LPPI := GetEffectivePPI;
  LFontSize := FontSizeToPixels(FItemFont);
  if (fsBold in FItemFont.Style) and (fsItalic in FItemFont.Style) then
    LFontStyle := TSkFontStyle.BoldItalic
  else if fsBold in FItemFont.Style then
    LFontStyle := TSkFontStyle.Bold
  else if fsItalic in FItemFont.Style then
    LFontStyle := TSkFontStyle.Italic
  else
    LFontStyle := TSkFontStyle.Normal;

  if (FItemCacheFont = nil) or (FItemCachePPI <> LPPI) or
    (FItemCacheFontName <> FItemFont.Name) or
    (FItemCacheFontStyle <> FItemFont.Style) or
    not SameValue(FItemCacheFontSize, LFontSize) then
  begin
    FItemCacheTypeface := TSkTypeface.MakeFromName(FItemFont.Name, LFontStyle);
    FItemCacheFont := TSkFont.Create(FItemCacheTypeface, LFontSize);
    FItemCacheFontName := FItemFont.Name;
    FItemCacheFontStyle := FItemFont.Style;
    FItemCacheFontSize := LFontSize;
    FItemCachePPI := LPPI;
    FItemTextWidthCache.Clear;
  end;
  Result := FItemCacheFont;
end;

function TDSkCheckboxGroup.MeasureItemText(const AText: string): Single;
var
  LIndex: Integer;
  LFont: ISkFont;
begin
  LIndex := FItemTextWidthCache.IndexOfName(AText);
  if LIndex >= 0 then
    Exit(StrToFloatDef(FItemTextWidthCache.ValueFromIndex[LIndex], 0));

  LFont := GetItemFontCache;
  Result := LFont.MeasureText(AText);
  FItemTextWidthCache.Values[AText] := FloatToStr(Result);
end;

end.
