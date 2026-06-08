unit SkiaVclControls.SwitchGroup;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  System.Math.Vectors, System.Generics.Collections,
  Vcl.Controls, Vcl.Graphics, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  TDSkSwitchGroupItemClickEvent = procedure(Sender: TObject;
    ItemIndex: Integer; Checked: Boolean) of object;

  { TDSkSwitchGroup - MUI 风格的开关组容器
    自行绘制所有开关，不创建子组件。支持多选和单选模式。 }
  TDSkSwitchGroup = class(TDSCustomSkControl)
  private
    FOrientation: TDSkRadioGroupOrientation;
    FItems: TStrings;
    FCheckedItems: TList<Integer>;
    FColorScheme: TDSkMUIColorScheme;
    FLabelPlacement: TDSkRadioLabelPlacement;
    FSize: TDSkSwitchSize;
    FExclusive: Boolean;
    FAllowNone: Boolean;
    FHoverIndex: Integer;
    FCaption: string;
    FCaptionFont: TFont;
    FCaptionMargin: Single;
    FItemFont: TFont;
    FOnItemClick: TDSkSwitchGroupItemClickEvent;
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
    procedure SetSize(Value: TDSkSwitchSize);
    procedure SetExclusive(Value: Boolean);
    procedure SetAllowNone(Value: Boolean);
    procedure SetCaption(const Value: string);
    procedure SetCaptionFont(Value: TFont);
    procedure SetCaptionMargin(Value: Single);
    procedure SetItemFont(Value: TFont);
    procedure CaptionFontChanged(Sender: TObject);
    procedure ItemFontChanged(Sender: TObject);
    procedure ItemsChanged(Sender: TObject);
    procedure RequestRedraw;
    function GetItemRect(Index: Integer): TRectF;
    function GetSwitchCenter(Index: Integer): TPointF;
    function HitTest(X, Y: Integer): Integer;
    function GetSwitchColor: TAlphaColor;
    function GetItemCount: Integer;
    function GetTitleHeight: Single;
    function GetTrackWidth: Single;
    function GetTrackHeight: Single;
    function GetThumbRadius: Single;
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
    procedure DrawItemSwitch(const ACanvas: ISkCanvas; const ACenter: TPointF; AChecked: Boolean; AColor: TAlphaColor);
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
    property ItemFont: TFont read FItemFont write SetItemFont;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property LabelPlacement: TDSkRadioLabelPlacement read FLabelPlacement write SetLabelPlacement default rlpRight;
    property Size: TDSkSwitchSize read FSize write SetSize default sssMedium;
    property Exclusive: Boolean read FExclusive write SetExclusive default False;
    property AllowNone: Boolean read FAllowNone write SetAllowNone default True;
    property OnItemClick: TDSkSwitchGroupItemClickEvent read FOnItemClick write FOnItemClick;
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
  ITEM_SPACING_V = 8;
  ITEM_SPACING_H = 16;
  LABEL_GAP = 8;
  // Medium 尺寸
  SWITCH_MEDIUM_WIDTH = 36;
  SWITCH_MEDIUM_HEIGHT = 20;
  SWITCH_MEDIUM_THUMB = 18;
  // Small 尺寸
  SWITCH_SMALL_WIDTH = 28;
  SWITCH_SMALL_HEIGHT = 16;
  SWITCH_SMALL_THUMB = 12;

function DarkenColor(AColor: TAlphaColor; AAmount: Single): TAlphaColor;
var
  R, G, B: Byte;
begin
  R := Round(((AColor shr 16) and $FF) * (1 - AAmount));
  G := Round(((AColor shr 8) and $FF) * (1 - AAmount));
  B := Round((AColor and $FF) * (1 - AAmount));
  Result := $FF000000 or (TAlphaColor(R) shl 16) or (TAlphaColor(G) shl 8) or TAlphaColor(B);
end;

{ TDSkSwitchGroup }

constructor TDSkSwitchGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOrientation := rgoVertical;
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ItemsChanged;
  FCheckedItems := TList<Integer>.Create;
  FColorScheme := muiPrimary;
  FLabelPlacement := rlpRight;
  FSize := sssMedium;
  FExclusive := False;
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

destructor TDSkSwitchGroup.Destroy;
begin
  FItemTextWidthCache.Free;
  FCheckedItems.Free;
  FItems.Free;
  FCaptionFont.Free;
  FItemFont.Free;
  inherited;
end;

function TDSkSwitchGroup.GetTrackWidth: Single;
begin
  if FSize = sssSmall then
    Result := SWITCH_SMALL_WIDTH
  else
    Result := SWITCH_MEDIUM_WIDTH;
end;

function TDSkSwitchGroup.GetTrackHeight: Single;
begin
  if FSize = sssSmall then
    Result := SWITCH_SMALL_HEIGHT
  else
    Result := SWITCH_MEDIUM_HEIGHT;
end;

function TDSkSwitchGroup.GetThumbRadius: Single;
begin
  if FSize = sssSmall then
    Result := SWITCH_SMALL_THUMB / 2
  else
    Result := SWITCH_MEDIUM_THUMB / 2;
end;

procedure TDSkSwitchGroup.SetOrientation(Value: TDSkRadioGroupOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    RequestRedraw;
  end;
end;

procedure TDSkSwitchGroup.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TDSkSwitchGroup.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then
  begin
    FColorScheme := Value;
    RequestRedraw;
  end;
end;

procedure TDSkSwitchGroup.SetLabelPlacement(Value: TDSkRadioLabelPlacement);
begin
  if FLabelPlacement <> Value then
  begin
    FLabelPlacement := Value;
    RequestRedraw;
  end;
end;

procedure TDSkSwitchGroup.SetSize(Value: TDSkSwitchSize);
begin
  if FSize <> Value then
  begin
    FSize := Value;
    RequestRedraw;
  end;
end;

procedure TDSkSwitchGroup.SetExclusive(Value: Boolean);
begin
  if FExclusive <> Value then
  begin
    FExclusive := Value;
    if Value and (FCheckedItems.Count > 1) then
    begin
      FCheckedItems.Clear;
      RequestRedraw;
    end;
  end;
end;

procedure TDSkSwitchGroup.SetAllowNone(Value: Boolean);
begin
  FAllowNone := Value;
end;

procedure TDSkSwitchGroup.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    InvalidateCaptionFontCache;
    RequestRedraw;
  end;
end;

procedure TDSkSwitchGroup.SetCaptionFont(Value: TFont);
begin
  FCaptionFont.Assign(Value);
end;

procedure TDSkSwitchGroup.SetCaptionMargin(Value: Single);
begin
  if FCaptionMargin <> Value then
  begin
    FCaptionMargin := Value;
    RequestRedraw;
  end;
end;

procedure TDSkSwitchGroup.CaptionFontChanged(Sender: TObject);
begin
  InvalidateCaptionFontCache;
  RequestRedraw;
end;

procedure TDSkSwitchGroup.ItemFontChanged(Sender: TObject);
begin
  InvalidateItemFontCache;
  RequestRedraw;
end;

procedure TDSkSwitchGroup.SetItemFont(Value: TFont);
begin
  FItemFont.Assign(Value);
  InvalidateItemFontCache;
end;

procedure TDSkSwitchGroup.ItemsChanged(Sender: TObject);
var
  i: Integer;
begin
  for i := FCheckedItems.Count - 1 downto 0 do
  begin
    if FCheckedItems[i] >= FItems.Count then
      FCheckedItems.Delete(i);
  end;
  FItemTextWidthCache.Clear;
  RequestRedraw;
end;

procedure TDSkSwitchGroup.RequestRedraw;
begin
  if csLoading in ComponentState then
    Exit;
  Redraw;
end;

procedure TDSkSwitchGroup.Loaded;
begin
  inherited;
  RequestRedraw;
end;

function TDSkSwitchGroup.GetSwitchColor: TAlphaColor;
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

function TDSkSwitchGroup.GetTitleHeight: Single;
var
  LFont: ISkFont;
begin
  if FCaption = '' then
    Result := 0
  else
  begin
    LFont := GetCaptionFontCache;
    Result := LFont.Size + DpiScaleValue(FCaptionMargin);
  end;
end;

function TDSkSwitchGroup.GetItemRect(Index: Integer): TRectF;
var
  LTitleHeight: Single;
  LItemHeight: Single;
  LScaledTrackHeight: Single;
  LScaledSpacingV: Single;
  LScaledSpacingH: Single;
  LScaledItemWidth: Single;
begin
  LTitleHeight := GetTitleHeight;
  LScaledTrackHeight := DpiScaleValue(GetTrackHeight);
  LScaledSpacingV := DpiScaleValue(ITEM_SPACING_V);
  LScaledSpacingH := DpiScaleValue(ITEM_SPACING_H);
  LScaledItemWidth := DpiScaleValue(140);
  LItemHeight := LScaledTrackHeight + DpiScaleValue(8);

  if FOrientation = rgoVertical then
    Result := RectF(0, LTitleHeight + Index * (LItemHeight + LScaledSpacingV), ClientWidth,
      LTitleHeight + Index * (LItemHeight + LScaledSpacingV) + LItemHeight)
  else
    Result := RectF(Index * (LScaledItemWidth + LScaledSpacingH), 0,
      Index * (LScaledItemWidth + LScaledSpacingH) + LScaledItemWidth, ClientHeight);
end;

function TDSkSwitchGroup.GetSwitchCenter(Index: Integer): TPointF;
var
  LRect: TRectF;
  LScaledTrackWidth: Single;
  LScaledTrackHeight: Single;
begin
  LRect := GetItemRect(Index);
  LScaledTrackWidth := DpiScaleValue(GetTrackWidth);
  LScaledTrackHeight := DpiScaleValue(GetTrackHeight);
  case FLabelPlacement of
    rlpRight: Result := PointF(LRect.Left + LScaledTrackWidth / 2, LRect.Top + LRect.Height / 2);
    rlpLeft: Result := PointF(LRect.Right - LScaledTrackWidth / 2, LRect.Top + LRect.Height / 2);
    rlpTop: Result := PointF(LRect.Left + LRect.Width / 2, LRect.Bottom - LScaledTrackHeight / 2);
    rlpBottom: Result := PointF(LRect.Left + LRect.Width / 2, LRect.Top + LScaledTrackHeight / 2);
  else
    Result := PointF(LRect.Left + LScaledTrackWidth / 2, LRect.Top + LRect.Height / 2);
  end;
end;

function TDSkSwitchGroup.HitTest(X, Y: Integer): Integer;
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

function TDSkSwitchGroup.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TDSkSwitchGroup.GetCheckedItems: TList<Integer>;
begin
  Result := FCheckedItems;
end;

procedure TDSkSwitchGroup.SetCheckedItems(Value: TList<Integer>);
begin
  FCheckedItems.Clear;
  FCheckedItems.AddRange(Value);
  RequestRedraw;
end;

function TDSkSwitchGroup.IsItemChecked(Index: Integer): Boolean;
begin
  Result := FCheckedItems.Contains(Index);
end;

procedure TDSkSwitchGroup.SetItemChecked(Index: Integer; Value: Boolean);
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

procedure TDSkSwitchGroup.ClearCheckedItems;
begin
  FCheckedItems.Clear;
  RequestRedraw;
end;

function TDSkSwitchGroup.ShouldClipWindowRegion: Boolean;
begin
  Result := False;
end;

function TDSkSwitchGroup.DependsOnParentBackground: Boolean;
begin
  Result := False;
end;

function TDSkSwitchGroup.DependsOnParentVisualBackground: Boolean;
begin
  if Parent is TDSCustomSkControl then
    Result := TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack
  else
    Result := False;
end;

procedure TDSkSwitchGroup.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
var
  i: Integer;
  LScale: Single;
  LPhysicalDest: TRectF;
begin
  ACanvas.Clear(TAlphaColors.Null);
  // 撤销 canvas 的 DPI 缩放变换，使后续绘制使用物理像素坐标
  LScale := ScaleFactor;
  ACanvas.Save;
  try
    if LScale <> 1.0 then
      ACanvas.Concat(TMatrix.CreateScaling(1 / LScale, 1 / LScale));
    LPhysicalDest := RectF(ADest.Left * LScale, ADest.Top * LScale,
      ADest.Right * LScale, ADest.Bottom * LScale);
    DrawTitle(ACanvas, LPhysicalDest);
    for i := 0 to FItems.Count - 1 do
      DrawItem(ACanvas, LPhysicalDest, i);
  finally
    ACanvas.Restore;
  end;
end;

procedure TDSkSwitchGroup.DrawTitle(const ACanvas: ISkCanvas; const ADest: TRectF);
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

procedure TDSkSwitchGroup.DrawItem(const ACanvas: ISkCanvas; const ADest: TRectF; Index: Integer);
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
  LScaledTrackWidth: Single;
  LScaledTrackHeight: Single;
  LScaledLabelGap: Single;
begin
  if (Index < 0) or (Index >= FItems.Count) then Exit;

  LChecked := IsItemChecked(Index);
  LCenter := GetSwitchCenter(Index);
  LItemRect := GetItemRect(Index);
  LScaledTrackWidth := DpiScaleValue(GetTrackWidth);
  LScaledTrackHeight := DpiScaleValue(GetTrackHeight);
  LScaledLabelGap := DpiScaleValue(LABEL_GAP);

  // 根据选中状态确定颜色
  if (not Enabled) or IsParentDisabled then
    LColor := $FFBDBDBD
  else if LChecked then
  begin
    LColor := GetSwitchColor;
    if FHoverIndex = Index then
      LColor := DarkenColor(LColor, 0.15);
  end
  else
    LColor := $FFE0E0E0;  // 未选中灰色

  DrawItemSwitch(ACanvas, LCenter, LChecked, LColor);

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
        LX := LCenter.X + LScaledTrackWidth / 2 + LScaledLabelGap;
        LY := LItemRect.Top + (LItemRect.Height + LFontSize) / 2 - DpiScaleValue(2);
      end;
      rlpLeft: begin
        LX := LCenter.X - LScaledTrackWidth / 2 - LScaledLabelGap - LTextW;
        LY := LItemRect.Top + (LItemRect.Height + LFontSize) / 2 - DpiScaleValue(2);
      end;
      rlpTop: begin
        LX := LItemRect.Left + (LItemRect.Width - LTextW) / 2;
        LY := LCenter.Y - LScaledTrackHeight / 2 - LScaledLabelGap;
      end;
      rlpBottom: begin
        LX := LItemRect.Left + (LItemRect.Width - LTextW) / 2;
        LY := LCenter.Y + LScaledTrackHeight / 2 + LScaledLabelGap + LFontSize;
      end;
    else
      begin
        LX := LCenter.X + LScaledTrackWidth / 2 + LScaledLabelGap;
        LY := LItemRect.Top + (LItemRect.Height + LFontSize) / 2 - DpiScaleValue(2);
      end;
    end;

    ACanvas.DrawSimpleText(LText, LX, LY, LFont, LPaint);
  end;
end;

procedure TDSkSwitchGroup.DrawItemSwitch(const ACanvas: ISkCanvas; const ACenter: TPointF;
  AChecked: Boolean; AColor: TAlphaColor);
var
  LTrackWidth, LTrackHeight, LThumbRadius: Single;
  LTrackRect: TRectF;
  LRoundRect: ISkRoundRect;
  LPaint: ISkPaint;
  LThumbCenter: TPointF;
  LCornerRadius: Single;
begin
  // 将尺寸值进行DPI缩放
  LTrackWidth := DpiScaleValue(GetTrackWidth);
  LTrackHeight := DpiScaleValue(GetTrackHeight);
  LThumbRadius := DpiScaleValue(GetThumbRadius);
  LCornerRadius := LTrackHeight / 2;

  LTrackRect := RectF(
    ACenter.X - LTrackWidth / 2,
    ACenter.Y - LTrackHeight / 2,
    ACenter.X + LTrackWidth / 2,
    ACenter.Y + LTrackHeight / 2
  );

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;

  LRoundRect := TSkRoundRect.Create;
  LRoundRect.SetRect(LTrackRect, LCornerRadius, LCornerRadius);

  LPaint.Style := TSkPaintStyle.Fill;
  if (not Enabled) or IsParentDisabled then
    LPaint.Color := (AColor and $00FFFFFF) or $80000000
  else
    LPaint.Color := AColor;
  ACanvas.DrawRoundRect(LRoundRect, LPaint);

  if AChecked then
    LThumbCenter := PointF(LTrackRect.Right - LCornerRadius, LTrackRect.Top + LCornerRadius)
  else
    LThumbCenter := PointF(LTrackRect.Left + LCornerRadius, LTrackRect.Top + LCornerRadius);

  LPaint.Style := TSkPaintStyle.Fill;
  LPaint.Color := $40000000;
  ACanvas.DrawCircle(PointF(LThumbCenter.X, LThumbCenter.Y + DpiScaleValue(1)), LThumbRadius + DpiScaleValue(0.5), LPaint);

  LPaint.Style := TSkPaintStyle.Fill;
  if (not Enabled) or IsParentDisabled then
    LPaint.Color := $FFFFFFFF or $80000000
  else
    LPaint.Color := $FFFFFFFF;
  ACanvas.DrawCircle(LThumbCenter, LThumbRadius, LPaint);
end;

procedure TDSkSwitchGroup.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
      LItemPos := FCheckedItems.IndexOf(LIndex);
      if LItemPos >= 0 then
      begin
        if FAllowNone then
          FCheckedItems.Delete(LItemPos);
      end
      else
      begin
        FCheckedItems.Clear;
        FCheckedItems.Add(LIndex);
      end;
    end
    else
    begin
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

procedure TDSkSwitchGroup.MouseMove(Shift: TShiftState; X, Y: Integer);
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

procedure TDSkSwitchGroup.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FHoverIndex >= 0 then
  begin
    FHoverIndex := -1;
    RequestRedraw;
  end;
end;

procedure TDSkSwitchGroup.Resize;
begin
  inherited;
  RequestRedraw;
end;

procedure TDSkSwitchGroup.InvalidateCaptionFontCache;
begin
  FCaptionCacheFont := nil;
  FCaptionCacheTypeface := nil;
  FCaptionCacheFontName := '';
  FCaptionCacheFontStyle := [];
  FCaptionCacheFontSize := -1;
  FCaptionCachePPI := 0;
end;

procedure TDSkSwitchGroup.InvalidateItemFontCache;
begin
  FItemCacheFont := nil;
  FItemCacheTypeface := nil;
  FItemCacheFontName := '';
  FItemCacheFontStyle := [];
  FItemCacheFontSize := -1;
  FItemCachePPI := 0;
  FItemTextWidthCache.Clear;
end;

function TDSkSwitchGroup.GetCaptionFontCache: ISkFont;
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

function TDSkSwitchGroup.GetItemFontCache: ISkFont;
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

function TDSkSwitchGroup.MeasureItemText(const AText: string): Single;
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
