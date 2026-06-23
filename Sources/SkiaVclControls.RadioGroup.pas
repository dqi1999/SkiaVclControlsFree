unit SkiaVclControls.RadioGroup;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  TDSkRadioGroupItemClickEvent = procedure(Sender: TObject; RadioIndex: Integer) of object;

  TDSkRadioGroup = class(TDSCustomSkControl)
  private
    FOrientation: TDSkRadioGroupOrientation;
    FItemIndex: Integer;
    FItems: TStrings;
    FColorScheme: TDSkMUIColorScheme;
    FLabelPlacement: TDSkRadioLabelPlacement;
    FExclusive: Boolean;
    FHoverIndex: Integer;
    FCaption: string;
    FCaptionFont: TFont;
    FCaptionMargin: Single;
    FRadioSize: Single;
    FItemFont: TFont;
    FOnItemClick: TDSkRadioGroupItemClickEvent;
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
    procedure SetItemIndex(Value: Integer);
    procedure SetItems(Value: TStrings);
    procedure SetColorScheme(Value: TDSkMUIColorScheme);
    procedure SetLabelPlacement(Value: TDSkRadioLabelPlacement);
    procedure SetExclusive(Value: Boolean);
    procedure SetCaption(const Value: string);
    procedure SetCaptionFont(Value: TFont);
    procedure SetCaptionMargin(Value: Single);
    procedure SetRadioSize(Value: Single);
    procedure SetItemFont(Value: TFont);
    procedure CaptionFontChanged(Sender: TObject);
    procedure ItemFontChanged(Sender: TObject);
    procedure ItemsChanged(Sender: TObject);
    procedure RequestRedraw;
    function GetItemRect(Index: Integer): TRectF;
    function GetRadioCircleCenter(Index: Integer): TPointF;
    function HitTest(X, Y: Integer): Integer;
    function GetRadioColor: TAlphaColor;
    function GetItemCount: Integer;
    function GetTitleHeight: Single;
    procedure InvalidateCaptionFontCache;
    procedure InvalidateItemFontCache;
    function GetCaptionFontCache: ISkFont;
    function GetItemFontCache: ISkFont;
    function MeasureItemText(const AText: string): Single;
  protected
    procedure Loaded; override;
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawTitle(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawItem(const ACanvas: ISkCanvas; const ADest: TRectF; Index: Integer);
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
    property ItemCount: Integer read GetItemCount;
  published
    property Orientation: TDSkRadioGroupOrientation read FOrientation write SetOrientation default rgoVertical;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Items: TStrings read FItems write SetItems;
    property Caption: string read FCaption write SetCaption;
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property CaptionMargin: Single read FCaptionMargin write SetCaptionMargin;
    property RadioSize: Single read FRadioSize write SetRadioSize;
    property ItemFont: TFont read FItemFont write SetItemFont;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property LabelPlacement: TDSkRadioLabelPlacement read FLabelPlacement write SetLabelPlacement default rlpRight;
    property Exclusive: Boolean read FExclusive write SetExclusive default True;
    property OnItemClick: TDSkRadioGroupItemClickEvent read FOnItemClick write FOnItemClick;
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
  RADIO_SIZE = 20;
  ITEM_SPACING_V = 8;
  ITEM_SPACING_H = 16;
  LABEL_GAP = 8;
  ITEM_HEIGHT = 28;
  ITEM_WIDTH = 140;

{ TDSkRadioGroup }

constructor TDSkRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOrientation := rgoVertical;
  FItemIndex := -1;
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ItemsChanged;
  FColorScheme := muiPrimary;
  FLabelPlacement := rlpRight;
  FExclusive := True;
  FHoverIndex := -1;
  FCaption := '';
  FCaptionFont := TFont.Create;
  FCaptionFont.Name := GetDefaultFontName;
  FCaptionFont.Size := 10;
  FCaptionFont.Color := -9079435;
  FCaptionFont.Style := [];
  FCaptionFont.OnChange := CaptionFontChanged;
  FCaptionMargin := 8;
  FRadioSize := 20;
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
  
  // RadioGroup 需要视觉透明，因此默认不做圆角裁剪，
  // 并通过基类先复制父背景来获得稳定的伪透明效果。
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
    FItemIndex := 0;
  end;
end;

destructor TDSkRadioGroup.Destroy;
begin
  FItemTextWidthCache.Free;
  FItems.Free;
  FCaptionFont.Free;
  FItemFont.Free;
  inherited;
end;

procedure TDSkRadioGroup.SetOrientation(Value: TDSkRadioGroupOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    RequestRedraw;
  end;
end;

procedure TDSkRadioGroup.SetItemIndex(Value: Integer);
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

procedure TDSkRadioGroup.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TDSkRadioGroup.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then
  begin
    FColorScheme := Value;
    RequestRedraw;
  end;
end;

procedure TDSkRadioGroup.SetLabelPlacement(Value: TDSkRadioLabelPlacement);
begin
  if FLabelPlacement <> Value then
  begin
    FLabelPlacement := Value;
    RequestRedraw;
  end;
end;

procedure TDSkRadioGroup.SetExclusive(Value: Boolean);
begin
  FExclusive := Value;
end;

procedure TDSkRadioGroup.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    InvalidateCaptionFontCache;
    RequestRedraw;
  end;
end;

procedure TDSkRadioGroup.SetCaptionFont(Value: TFont);
begin
  FCaptionFont.Assign(Value);
end;

procedure TDSkRadioGroup.SetCaptionMargin(Value: Single);
begin
  if FCaptionMargin <> Value then
  begin
    FCaptionMargin := Value;
    RequestRedraw;
  end;
end;

procedure TDSkRadioGroup.CaptionFontChanged(Sender: TObject);
begin
  InvalidateCaptionFontCache;
  RequestRedraw;
end;

procedure TDSkRadioGroup.ItemFontChanged(Sender: TObject);
begin
  InvalidateItemFontCache;
  RequestRedraw;
end;

procedure TDSkRadioGroup.SetRadioSize(Value: Single);
begin
  if FRadioSize <> Value then
  begin
    FRadioSize := Value;
    RequestRedraw;
  end;
end;

procedure TDSkRadioGroup.SetItemFont(Value: TFont);
begin
  FItemFont.Assign(Value);
  InvalidateItemFontCache;
end;

procedure TDSkRadioGroup.ItemsChanged(Sender: TObject);
begin
  if FItemIndex >= FItems.Count then
    FItemIndex := -1;
  FItemTextWidthCache.Clear;
  RequestRedraw;
end;

procedure TDSkRadioGroup.RequestRedraw;
begin
  if csLoading in ComponentState then
    Exit;
  Redraw;
end;

procedure TDSkRadioGroup.Loaded;
begin
  inherited;
  RequestRedraw;
end;

function TDSkRadioGroup.GetRadioColor: TAlphaColor;
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

function TDSkRadioGroup.GetTitleHeight: Single;
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

function TDSkRadioGroup.GetItemRect(Index: Integer): TRectF;
var
  LTitleHeight: Single;
  LItemHeight: Single;
begin
  LTitleHeight := GetTitleHeight;
  // 根据 RadioSize 计算 Item 高度
  LItemHeight := FRadioSize + 8; // RadioSize + 间距
  
  if FOrientation = rgoVertical then
    Result := RectF(0, LTitleHeight + Index * (LItemHeight + ITEM_SPACING_V), ClientWidth,
      LTitleHeight + Index * (LItemHeight + ITEM_SPACING_V) + LItemHeight)
  else
    Result := RectF(Index * (ITEM_WIDTH + ITEM_SPACING_H), 0,
      Index * (ITEM_WIDTH + ITEM_SPACING_H) + ITEM_WIDTH, ClientHeight);
end;

function TDSkRadioGroup.GetRadioCircleCenter(Index: Integer): TPointF;
var
  LRect: TRectF;
begin
  LRect := GetItemRect(Index);
  case FLabelPlacement of
    rlpRight: Result := PointF(LRect.Left + FRadioSize / 2 + 4, LRect.Top + LRect.Height / 2);
    rlpLeft: Result := PointF(LRect.Right - FRadioSize / 2 - 4, LRect.Top + LRect.Height / 2);
    rlpTop: Result := PointF(LRect.Left + LRect.Width / 2, LRect.Bottom - FRadioSize / 2 - 4);
    rlpBottom: Result := PointF(LRect.Left + LRect.Width / 2, LRect.Top + FRadioSize / 2 + 4);
  else
    Result := PointF(LRect.Left + FRadioSize / 2 + 4, LRect.Top + LRect.Height / 2);
  end;
end;

function TDSkRadioGroup.HitTest(X, Y: Integer): Integer;
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

procedure TDSkRadioGroup.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
var
  i: Integer;
begin
  ACanvas.Clear(TAlphaColors.Null);
  DrawTitle(ACanvas, ADest);
  for i := 0 to FItems.Count - 1 do
    DrawItem(ACanvas, ADest, i);
end;

procedure TDSkRadioGroup.DrawTitle(const ACanvas: ISkCanvas; const ADest: TRectF);
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

procedure TDSkRadioGroup.DrawItem(const ACanvas: ISkCanvas; const ADest: TRectF; Index: Integer);
var
  LCenter: TPointF;
  LRadius: Single;
  LPaint: ISkPaint;
  LColor, LOuterColor: TAlphaColor;
  LFont: ISkFont;
  LX, LY: Single;
  LTextW, LFontSize: Single;
  LItemRect: TRectF;
  LChecked: Boolean;
  LText: string;
begin
  if (Index < 0) or (Index >= FItems.Count) then Exit;

  LChecked := Index = FItemIndex;
  LColor := GetRadioColor;
  LCenter := GetRadioCircleCenter(Index);
  LRadius := FRadioSize / 2;
  LItemRect := GetItemRect(Index);

  // 确定颜色
  if (not Enabled) or IsParentDisabled then
  begin
    LColor := $FFBDBDBD;
    LOuterColor := $FFBDBDBD;
  end
  else if FHoverIndex = Index then
  begin
    LOuterColor := DarkenColor(LColor, 0.15);
  end
  else
  begin
    LOuterColor := LColor;
  end;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;

  if LChecked then
  begin
    // 选中状态：实心圆 + 外圈（外圈颜色变淡）
    LPaint.Style := TSkPaintStyle.Fill;
    if (not Enabled) or IsParentDisabled then
      LPaint.Color := $FFBDBDBD
    else
      LPaint.Color := LColor;
    ACanvas.DrawCircle(LCenter, LRadius * 0.5, LPaint);

    // 外圈（选中时颜色变淡）
    LPaint.Style := TSkPaintStyle.Stroke;
    LPaint.StrokeWidth := 1.5;
    if (not Enabled) or IsParentDisabled then
      LPaint.Color := $FFBDBDBD
    else
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

  // 绘制标签文字
  LText := FItems[Index];
  if LText <> '' then
  begin
    LFont := GetItemFontCache;
    LFontSize := LFont.Size;
    LTextW := MeasureItemText(LText);

    LPaint.Style := TSkPaintStyle.Fill;
    if (not Enabled) or IsParentDisabled then
      LPaint.Color := $FF757575
    else
      LPaint.Color := VclColorToAlphaColor(FItemFont.Color);

    case FLabelPlacement of
      rlpRight: begin
        LX := LCenter.X + LRadius + LABEL_GAP;
        LY := LItemRect.Top + (LItemRect.Height + LFontSize) / 2 - 2;
      end;
      rlpLeft: begin
        LX := LCenter.X - LRadius - LABEL_GAP - LTextW;
        LY := LItemRect.Top + (LItemRect.Height + LFontSize) / 2 - 2;
      end;
      rlpTop: begin
        LX := LItemRect.Left + (LItemRect.Width - LTextW) / 2;
        LY := LCenter.Y - LRadius - LABEL_GAP;
      end;
      rlpBottom: begin
        LX := LItemRect.Left + (LItemRect.Width - LTextW) / 2;
        LY := LCenter.Y + LRadius + LABEL_GAP + LFontSize;
      end;
    else
      begin
        LX := LCenter.X + LRadius + LABEL_GAP;
        LY := LItemRect.Top + (LItemRect.Height + LFontSize) / 2 - 2;
      end;
    end;

    ACanvas.DrawSimpleText(LText, LX, LY, LFont, LPaint);
  end;
end;

procedure TDSkRadioGroup.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LIndex: Integer;
begin
  inherited;
  if Button <> mbLeft then Exit;
  if not Enabled or IsParentDisabled then Exit;

  LIndex := HitTest(X, Y);
  if LIndex >= 0 then
  begin
    if FExclusive then
    begin
      if FItemIndex <> LIndex then
      begin
        FItemIndex := LIndex;
        RequestRedraw;
        if Assigned(FOnItemClick) and not (csDesigning in ComponentState) then
          FOnItemClick(Self, FItemIndex);
      end;
    end
    else
    begin
      if FItemIndex = LIndex then
        FItemIndex := -1
      else
        FItemIndex := LIndex;
      RequestRedraw;
      if Assigned(FOnItemClick) and not (csDesigning in ComponentState) then
        FOnItemClick(Self, FItemIndex);
    end;
  end;
end;

procedure TDSkRadioGroup.MouseMove(Shift: TShiftState; X, Y: Integer);
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

procedure TDSkRadioGroup.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FHoverIndex >= 0 then
  begin
    FHoverIndex := -1;
    RequestRedraw;
  end;
end;

procedure TDSkRadioGroup.Resize;
begin
  inherited;
  RequestRedraw;
end;

function TDSkRadioGroup.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TDSkRadioGroup.ShouldClipWindowRegion: Boolean;
begin
  // RadioGroup 不需要圆角裁剪，保持透明背景
  Result := False;
end;

function TDSkRadioGroup.DependsOnParentBackground: Boolean;
begin
  Result := False;
end;

function TDSkRadioGroup.DependsOnParentVisualBackground: Boolean;
begin
  if Parent is TDSCustomSkControl then
    Result := TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack
  else
    Result := False;
end;

procedure TDSkRadioGroup.InvalidateCaptionFontCache;
begin
  FCaptionCacheFont := nil;
  FCaptionCacheTypeface := nil;
  FCaptionCacheFontName := '';
  FCaptionCacheFontStyle := [];
  FCaptionCacheFontSize := -1;
  FCaptionCachePPI := 0;
end;

procedure TDSkRadioGroup.InvalidateItemFontCache;
begin
  FItemCacheFont := nil;
  FItemCacheTypeface := nil;
  FItemCacheFontName := '';
  FItemCacheFontStyle := [];
  FItemCacheFontSize := -1;
  FItemCachePPI := 0;
  FItemTextWidthCache.Clear;
end;

function TDSkRadioGroup.GetCaptionFontCache: ISkFont;
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

function TDSkRadioGroup.GetItemFontCache: ISkFont;
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

function TDSkRadioGroup.MeasureItemText(const AText: string): Single;
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
