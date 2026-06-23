unit SkiaVclControls.Select;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.Forms, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base, SkiaVclControls.Panel;

type
  TDSkSelectVariant = (svOutlined, svFilled, svUnderline);
  TDSkSelectLabelPlacement = (slpFloat, slpShrink);
  TDSkSelectSize = (ssMedium, ssSmall);
  TDSkSelectItemClickEvent = procedure(Sender: TObject;
    ItemIndex: Integer; const ItemText: string) of object;

  TDSkSelect = class;

  TDSkSelectDropDownForm = class(TCustomForm)
  private
    FOwnerSelect: TDSkSelect;
    FItems: TStrings;
    FItemIndex: Integer;
    FHoverIndex: Integer;
    FScrollOffset: Single;
    FMaxVisibleCount: Integer;
    FItemHeight: Single;
    FColorScheme: TDSkMUIColorScheme;
    FFont: TFont;
    FOnSelectItem: TDSkSelectItemClickEvent;
    function HitTest(X, Y: Integer): Integer;
    function GetItemRect(Index: Integer): TRect;
    function NeedsScroll: Boolean;
    procedure ClampScrollOffset;
    function GetSelectColor: TColor;
  protected
    procedure PaintWindow(DC: HDC); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    property Items: TStrings read FItems write FItems;
    property ItemIndex: Integer read FItemIndex write FItemIndex;
    property HoverIndex: Integer read FHoverIndex write FHoverIndex;
    property MaxVisibleCount: Integer read FMaxVisibleCount write FMaxVisibleCount;
    property ItemHeight: Single read FItemHeight write FItemHeight;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write FColorScheme;
    property Font: TFont read FFont write FFont;
    property OnSelectItem: TDSkSelectItemClickEvent read FOnSelectItem write FOnSelectItem;
  end;

  TDSkSelect = class(TDSCustomSkControl)
  private
    FItems: TStrings;
    FItemIndex: Integer;
    FText: string;
    FUseItemText: Boolean;
    FLabel: string;
    FPlaceholder: string;
    FHelperText: string;
    FVariant: TDSkSelectVariant;
    FColorScheme: TDSkMUIColorScheme;
    FLabelPlacement: TDSkSelectLabelPlacement;
    FFont: TFont;
    FLabelFont: TFont;
    FMaxDropCount: Integer;
    FReadOnly: Boolean;
    FError: Boolean;
    FErrorText: string;
    FClearable: Boolean;
    FSize: TDSkSelectSize;
    FDroppedDown: Boolean;
    FDropDownForm: TDSkSelectDropDownForm;
    FOnItemClick: TDSkSelectItemClickEvent;
    FOnDropDown: TNotifyEvent;
    FOnCloseUp: TNotifyEvent;
    FTextCacheFont: ISkFont;
    FTextCacheTypeface: ISkTypeface;
    FTextCacheFontName: string;
    FTextCacheFontStyle: TFontStyles;
    FTextCacheFontSize: Single;
    FTextCachePPI: Integer;
    FTextCacheText: string;
    FTextCacheWidth: Single;
    FLabelCacheFont: ISkFont;
    FLabelCacheTypeface: ISkTypeface;
    FLabelCacheFontName: string;
    FLabelCacheFontStyle: TFontStyles;
    FLabelCacheFontSize: Single;
    FLabelCachePPI: Integer;
    FHelperCacheFont: ISkFont;
    FHelperCacheTypeface: ISkTypeface;
    FHelperCacheFontName: string;
    FHelperCacheFontSize: Single;
    FHelperCachePPI: Integer;
    procedure SetItems(Value: TStrings);
    procedure SetItemIndex(Value: Integer);
    procedure SetText(const Value: string);
    procedure SetLabel_(const Value: string);
    procedure SetPlaceholder(const Value: string);
    procedure SetHelperText(const Value: string);
    procedure SetVariant(Value: TDSkSelectVariant);
    procedure SetColorScheme(Value: TDSkMUIColorScheme);
    procedure SetLabelPlacement(Value: TDSkSelectLabelPlacement);
    procedure SetFont(Value: TFont);
    procedure SetLabelFont(Value: TFont);
    procedure SetMaxDropCount(Value: Integer);
    procedure SetReadOnly(Value: Boolean);
    procedure SetError(Value: Boolean);
    procedure SetErrorText(const Value: string);
    procedure SetClearable(Value: Boolean);
    procedure SetSize(Value: TDSkSelectSize);
    procedure ItemsChanged(Sender: TObject);
    procedure FontChanged(Sender: TObject);
    procedure LabelFontChanged(Sender: TObject);
    procedure RequestRedraw;
    procedure InvalidateTextCache;
    procedure InvalidateLabelFontCache;
    procedure InvalidateHelperFontCache;
    function GetTextFont: ISkFont;
    function GetLabelFontCache: ISkFont;
    function GetHelperFontCache: ISkFont;
    function GetDisplayText: string;
    function GetSelectBorderColor: TAlphaColor;
    function GetSelectLabelColor: TAlphaColor;
    function HasValue: Boolean;
    function IsLabelFloating: Boolean;
    procedure ToggleDropDown;
    procedure DoSelectItem(Sender: TObject; ItemIndex: Integer; const ItemText: string);
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
  protected
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawBackground(const ACanvas: ISkCanvas; const ADest: TRectF; AOpacity: Single); override;
    procedure DrawBorder(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawLabel(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawText(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawPlaceholder(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawArrowIcon(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawClearButton(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawHelperText(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function ShouldClipWindowRegion: Boolean; override;
    function DependsOnParentBackground: Boolean; override;
    function DependsOnParentVisualBackground: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CloseDropDown;
    procedure Clear;
    procedure AddItem(const AText: string);
    procedure RemoveItem(Index: Integer);
    property DroppedDown: Boolean read FDroppedDown;
    property DropDownForm: TDSkSelectDropDownForm read FDropDownForm;
  published
    property Items: TStrings read FItems write SetItems;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Text: string read FText write SetText;
    property Label_: string read FLabel write SetLabel_;
    property Placeholder: string read FPlaceholder write SetPlaceholder;
    property HelperText: string read FHelperText write SetHelperText;
    property Variant: TDSkSelectVariant read FVariant write SetVariant default svOutlined;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property LabelPlacement: TDSkSelectLabelPlacement read FLabelPlacement write SetLabelPlacement default slpFloat;
    property Font: TFont read FFont write SetFont;
    property LabelFont: TFont read FLabelFont write SetLabelFont;
    property MaxDropCount: Integer read FMaxDropCount write SetMaxDropCount default 8;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property Error: Boolean read FError write SetError default False;
    property ErrorText: string read FErrorText write SetErrorText;
    property Clearable: Boolean read FClearable write SetClearable default False;
    property Size: TDSkSelectSize read FSize write SetSize default ssMedium;
    property OnItemClick: TDSkSelectItemClickEvent read FOnItemClick write FOnItemClick;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property Enabled;
    property Visible;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

implementation

const
  ITEM_HEIGHT = 36;
  ITEM_PADDING_H = 16;
  ARROW_ICON_SIZE = 10;
  CLEAR_BTN_SIZE = 18;
  LABEL_FLOAT_SIZE_RATIO = 0.75;
  BORDER_RADIUS = 4;
  HELPER_TEXT_GAP = 4;
  SCROLLBAR_WIDTH = 6;

function BlendColor(AColor1, AColor2: TColor; AAlpha: Double): TColor;
var
  R1, G1, B1, R2, G2, B2: Byte;
begin
  R1 := GetRValue(AColor1); G1 := GetGValue(AColor1); B1 := GetBValue(AColor1);
  R2 := GetRValue(AColor2); G2 := GetGValue(AColor2); B2 := GetBValue(AColor2);
  Result := RGB(
    Round(R1 * (1 - AAlpha) + R2 * AAlpha),
    Round(G1 * (1 - AAlpha) + G2 * AAlpha),
    Round(B1 * (1 - AAlpha) + B2 * AAlpha));
end;

{ TDSkSelectDropDownForm }

constructor TDSkSelectDropDownForm.CreateNew(AOwner: TComponent; Dummy: Integer);
begin
  inherited CreateNew(AOwner, Dummy);
  if AOwner is TDSkSelect then
    FOwnerSelect := TDSkSelect(AOwner)
  else
    FOwnerSelect := nil;
  BorderStyle := bsNone;
  FormStyle := fsStayOnTop;
  Position := poDesigned;
  Visible := False;
  FItems := nil;
  FItemIndex := -1;
  FHoverIndex := -1;
  FScrollOffset := 0;
  FMaxVisibleCount := 8;
  FItemHeight := ITEM_HEIGHT;
  FColorScheme := muiPrimary;
  FFont := nil;
end;

procedure TDSkSelectDropDownForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := WS_POPUP;
  Params.ExStyle := WS_EX_TOPMOST or WS_EX_TOOLWINDOW;
  Params.WndParent := 0;
end;

procedure TDSkSelectDropDownForm.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TDSkSelectDropDownForm.WMActivate(var Message: TWMActivate);
begin
  inherited;
  if Message.Active = WA_INACTIVE then
    if FOwnerSelect <> nil then
      FOwnerSelect.CloseDropDown;
end;

function TDSkSelectDropDownForm.GetSelectColor: TColor;
begin
  case FColorScheme of
    muiSecondary: Result := $00B0279C;
    muiError: Result := $002F2FD3;
    muiWarning: Result := $00026CED;
    muiInfo: Result := $00D18802;
    muiSuccess: Result := $00327D2E;
  else
    Result := $00D27619;
  end;
end;

function TDSkSelectDropDownForm.GetItemRect(Index: Integer): TRect;
var
  LTop: Integer;
begin
  LTop := Round(Index * FItemHeight - FScrollOffset);
  Result := Rect(0, LTop, ClientWidth, LTop + Round(FItemHeight));
end;

function TDSkSelectDropDownForm.NeedsScroll: Boolean;
begin
  Result := (FItems <> nil) and (FItems.Count > FMaxVisibleCount);
end;

procedure TDSkSelectDropDownForm.ClampScrollOffset;
var
  LMaxScroll: Single;
begin
  if FItems = nil then begin FScrollOffset := 0; Exit; end;
  LMaxScroll := Max(0, FItems.Count * FItemHeight - ClientHeight);
  FScrollOffset := Max(0, Min(FScrollOffset, LMaxScroll));
end;

function TDSkSelectDropDownForm.HitTest(X, Y: Integer): Integer;
var
  i: Integer;
  LRect: TRect;
begin
  Result := -1;
  if FItems = nil then Exit;
  for i := 0 to FItems.Count - 1 do
  begin
    LRect := GetItemRect(i);
    if (Y >= LRect.Top) and (Y < LRect.Bottom) and (X >= 0) and (X < ClientWidth) then
      Exit(i);
  end;
end;

procedure TDSkSelectDropDownForm.PaintWindow(DC: HDC);
var
  LCanvas: TCanvas;
  i: Integer;
  LRect: TRect;
  LText: string;
  LIsSelected, LIsHover: Boolean;
  LSelectColor: TColor;
  LTextRect: TRect;
  LTotalH, LVisibleH, LThumbH, LThumbTop: Single;
  LTrackRect, LThumbRect: TRect;
begin
  LCanvas := TCanvas.Create;
  try
    LCanvas.Handle := DC;

    // 白色背景
    LCanvas.Brush.Color := clWhite;
    LCanvas.Brush.Style := bsSolid;
    LCanvas.FillRect(Rect(0, 0, ClientWidth, ClientHeight));

    if FItems = nil then Exit;
    LSelectColor := GetSelectColor;

    // 绘制选项
    for i := 0 to FItems.Count - 1 do
    begin
      LRect := GetItemRect(i);
      if (LRect.Bottom <= 0) or (LRect.Top >= ClientHeight) then Continue;

      LIsSelected := (i = FItemIndex);
      LIsHover := (i = FHoverIndex);
      LText := FItems[i];

      // 背景
      // 选中项：浅色背景（12% 主题色 + 88% 白色）+ 黑色文字
      if LIsSelected then
      begin
        LCanvas.Brush.Color := BlendColor(clWhite, LSelectColor, 0.12);
        LCanvas.Brush.Style := bsSolid;
        LCanvas.FillRect(LRect);
      end
      else if LIsHover then
      begin
        LCanvas.Brush.Color := $00F4F4F4;
        LCanvas.Brush.Style := bsSolid;
        LCanvas.FillRect(LRect);
      end
      else
        LCanvas.Brush.Style := bsClear;

      // 字体
      if FFont <> nil then
        LCanvas.Font.Assign(FFont)
      else
      begin
        LCanvas.Font.Name := GetDefaultFontName;
        LCanvas.Font.Size := 12;
      end;

      // 文字默认黑色，选中项仅靠勾选图标 + 淡色背景区分
      LCanvas.Font.Color := clBlack;

      // 文字
      LTextRect := LRect;
      Inc(LTextRect.Left, ITEM_PADDING_H);
      if LIsSelected then
      begin
        LCanvas.Font.Color := LSelectColor;
        LCanvas.TextOut(LTextRect.Left + 2, LTextRect.Top + (Round(FItemHeight) - LCanvas.TextHeight('Wg')) div 2, #$2713);
        LCanvas.Font.Color := clBlack;
        Inc(LTextRect.Left, 24);
      end;
      LCanvas.TextOut(LTextRect.Left, LTextRect.Top + (Round(FItemHeight) - LCanvas.TextHeight('Wg')) div 2, LText);
    end;

    // 滚动条
    if NeedsScroll then
    begin
      LTotalH := FItems.Count * FItemHeight;
      LVisibleH := ClientHeight;
      LTrackRect := Rect(ClientWidth - SCROLLBAR_WIDTH, 0, ClientWidth, ClientHeight);
      LCanvas.Brush.Color := $00F8F8F8;
      LCanvas.Brush.Style := bsSolid;
      LCanvas.FillRect(LTrackRect);

      LThumbH := Max(20, LVisibleH * LVisibleH / LTotalH);
      LThumbTop := (FScrollOffset / Max(1, LTotalH - LVisibleH)) * (LVisibleH - LThumbH);
      LThumbRect := Rect(ClientWidth - 5, Round(LThumbTop), ClientWidth - 1, Round(LThumbTop + LThumbH));
      LCanvas.Brush.Color := $00C0C0C0;
      LCanvas.Pen.Style := psClear;
      LCanvas.RoundRect(LThumbRect.Left, LThumbRect.Top, LThumbRect.Right, LThumbRect.Bottom, 4, 4);
      LCanvas.Pen.Style := psSolid;
    end;
  finally
    LCanvas.Handle := 0;
    LCanvas.Free;
  end;
end;

procedure TDSkSelectDropDownForm.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LIndex: Integer;
begin
  inherited;
  if Button <> mbLeft then Exit;
  LIndex := HitTest(X, Y);
  if LIndex >= 0 then
  begin
    FItemIndex := LIndex;
    if Assigned(FOnSelectItem) and (FItems <> nil) and (LIndex < FItems.Count) then
      FOnSelectItem(Self, LIndex, FItems[LIndex]);
    if FOwnerSelect <> nil then
      FOwnerSelect.CloseDropDown;
  end;
end;

procedure TDSkSelectDropDownForm.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  LIndex: Integer;
begin
  inherited;
  LIndex := HitTest(X, Y);
  if LIndex <> FHoverIndex then
  begin
    FHoverIndex := LIndex;
    if HandleAllocated then Invalidate;
  end;
end;

function TDSkSelectDropDownForm.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  if NeedsScroll then
  begin
    FScrollOffset := FScrollOffset - WheelDelta / 120 * FItemHeight;
    ClampScrollOffset;
    Result := True;
    if HandleAllocated then Invalidate;
  end;
end;

procedure TDSkSelectDropDownForm.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  case Key of
    VK_UP: begin
      if FItemIndex > 0 then begin
        Dec(FItemIndex);
        if Assigned(FOnSelectItem) and (FItems <> nil) and (FItemIndex < FItems.Count) then
          FOnSelectItem(Self, FItemIndex, FItems[FItemIndex]);
        ClampScrollOffset;
        if HandleAllocated then Invalidate;
      end;
    end;
    VK_DOWN: begin
      if (FItems <> nil) and (FItemIndex < FItems.Count - 1) then begin
        Inc(FItemIndex);
        if Assigned(FOnSelectItem) and (FItems <> nil) and (FItemIndex < FItems.Count) then
          FOnSelectItem(Self, FItemIndex, FItems[FItemIndex]);
        ClampScrollOffset;
        if HandleAllocated then Invalidate;
      end;
    end;
    VK_RETURN, VK_ESCAPE: begin
      if FOwnerSelect <> nil then FOwnerSelect.CloseDropDown;
    end;
  end;
end;

{ TDSkSelect }

constructor TDSkSelect.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ItemsChanged;
  FItemIndex := -1;
  FText := '';
  FUseItemText := True;
  FLabel := '';
  FPlaceholder := '';
  FHelperText := '';
  FVariant := svOutlined;
  FColorScheme := muiPrimary;
  FLabelPlacement := slpFloat;
  FMaxDropCount := 8;
  FReadOnly := False;
  FError := False;
  FErrorText := '';
  FClearable := False;
  FSize := ssMedium;
  FDroppedDown := False;
  FDropDownForm := nil;
  FFont := TFont.Create;
  FFont.Name := GetDefaultFontName;
  FFont.Size := 12;
  FFont.Color := $00575049;  // #495057 深灰色
  FFont.OnChange := FontChanged;
  FLabelFont := TFont.Create;
  FLabelFont.Name := GetDefaultFontName;
  FLabelFont.Size := 12;
  FLabelFont.Color := -9079435;
  FLabelFont.OnChange := LabelFontChanged;
  InvalidateTextCache;
  InvalidateLabelFontCache;
  InvalidateHelperFontCache;
  Width := 200;
  if FSize = ssSmall then
    Height := 46
  else
    Height := 62;
  TabStop := True;
  CornerRadius := BORDER_RADIUS;
  BackgroundColor := TAlphaColors.Null;
  BorderColor := TAlphaColors.Null;
  BorderWidth := 0;

  // 设计期添加默认选项，让组件拖到窗体后立即可见
  if csDesigning in ComponentState then
  begin
    FItems.Add('Item 1');
    FItems.Add('Item 2');
    FItems.Add('Item 3');
    FLabel := 'Select';
  end;
end;

destructor TDSkSelect.Destroy;
begin
  CloseDropDown;
  FDropDownForm.Free;
  FItems.Free;
  FFont.Free;
  FLabelFont.Free;
  inherited;
end;

procedure TDSkSelect.SetItems(Value: TStrings); begin FItems.Assign(Value); end;
procedure TDSkSelect.SetItemIndex(Value: Integer);
begin
  if FItemIndex <> Value then begin
    if (Value < -1) or (FItems.Count = 0) then Value := -1;
    if Value >= FItems.Count then Value := FItems.Count - 1;
    FItemIndex := Value;
    FUseItemText := True;
    InvalidateTextCache;
    RequestRedraw;
  end;
end;

procedure TDSkSelect.SetText(const Value: string);
begin
  if FText <> Value then begin FText := Value; FUseItemText := (Value = ''); InvalidateTextCache; RequestRedraw; end;
end;

procedure TDSkSelect.SetLabel_(const Value: string);
begin
  if FLabel <> Value then begin FLabel := Value; InvalidateLabelFontCache; RequestRedraw; end;
end;

procedure TDSkSelect.SetPlaceholder(const Value: string);
begin
  if FPlaceholder <> Value then begin FPlaceholder := Value; RequestRedraw; end;
end;

procedure TDSkSelect.SetHelperText(const Value: string);
begin
  if FHelperText <> Value then begin FHelperText := Value; RequestRedraw; end;
end;

procedure TDSkSelect.SetVariant(Value: TDSkSelectVariant);
begin
  if FVariant <> Value then begin FVariant := Value; RequestRedraw; end;
end;

procedure TDSkSelect.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then begin FColorScheme := Value; RequestRedraw; end;
end;

procedure TDSkSelect.SetLabelPlacement(Value: TDSkSelectLabelPlacement);
begin
  if FLabelPlacement <> Value then begin FLabelPlacement := Value; RequestRedraw; end;
end;

procedure TDSkSelect.SetFont(Value: TFont); begin FFont.Assign(Value); InvalidateTextCache; end;
procedure TDSkSelect.SetLabelFont(Value: TFont); begin FLabelFont.Assign(Value); InvalidateLabelFontCache; end;
procedure TDSkSelect.SetMaxDropCount(Value: Integer); begin FMaxDropCount := Max(1, Value); end;
procedure TDSkSelect.SetReadOnly(Value: Boolean); begin FReadOnly := Value; end;

procedure TDSkSelect.SetError(Value: Boolean);
begin
  if FError <> Value then begin FError := Value; RequestRedraw; end;
end;

procedure TDSkSelect.SetErrorText(const Value: string);
begin
  if FErrorText <> Value then begin FErrorText := Value; RequestRedraw; end;
end;

procedure TDSkSelect.SetClearable(Value: Boolean);
begin
  if FClearable <> Value then begin FClearable := Value; RequestRedraw; end;
end;

procedure TDSkSelect.SetSize(Value: TDSkSelectSize);
const
  HEIGHTS: array[TDSkSelectSize] of Integer = (62, 46);
begin
  if FSize <> Value then begin
    FSize := Value;
    Height := HEIGHTS[Value];
    RequestRedraw;
  end;
end;

procedure TDSkSelect.ItemsChanged(Sender: TObject);
begin
  if (FItemIndex >= 0) and (FItemIndex >= FItems.Count) then FItemIndex := FItems.Count - 1;
  if FItems.Count = 0 then FItemIndex := -1;
  InvalidateTextCache;
  RequestRedraw;
end;

procedure TDSkSelect.FontChanged(Sender: TObject); begin InvalidateTextCache; RequestRedraw; end;
procedure TDSkSelect.LabelFontChanged(Sender: TObject); begin InvalidateLabelFontCache; RequestRedraw; end;
procedure TDSkSelect.RequestRedraw; begin if not (csLoading in ComponentState) then Redraw; end;

procedure TDSkSelect.InvalidateTextCache;
begin
  FTextCacheFont := nil; FTextCacheTypeface := nil; FTextCacheFontName := '';
  FTextCacheFontStyle := []; FTextCacheFontSize := -1; FTextCachePPI := 0;
  FTextCacheText := ''; FTextCacheWidth := 0;
end;

procedure TDSkSelect.InvalidateLabelFontCache;
begin
  FLabelCacheFont := nil; FLabelCacheTypeface := nil; FLabelCacheFontName := '';
  FLabelCacheFontStyle := []; FLabelCacheFontSize := -1; FLabelCachePPI := 0;
end;

procedure TDSkSelect.InvalidateHelperFontCache;
begin
  FHelperCacheFont := nil; FHelperCacheTypeface := nil; FHelperCacheFontName := '';
  FHelperCacheFontSize := -1; FHelperCachePPI := 0;
end;

function TDSkSelect.GetTextFont: ISkFont;
var LFontStyle: TSkFontStyle; LPPI: Integer; LFontSize: Single;
begin
  LPPI := GetEffectivePPI; LFontSize := FontSizeToPixels(FFont);
  if (fsBold in FFont.Style) and (fsItalic in FFont.Style) then LFontStyle := TSkFontStyle.BoldItalic
  else if fsBold in FFont.Style then LFontStyle := TSkFontStyle.Bold
  else if fsItalic in FFont.Style then LFontStyle := TSkFontStyle.Italic
  else LFontStyle := TSkFontStyle.Normal;
  if (FTextCacheFont = nil) or (FTextCachePPI <> LPPI) or (FTextCacheFontName <> FFont.Name) or
    (FTextCacheFontStyle <> FFont.Style) or not SameValue(FTextCacheFontSize, LFontSize) then begin
    FTextCacheTypeface := TSkTypeface.MakeFromName(FFont.Name, LFontStyle);
    FTextCacheFont := TSkFont.Create(FTextCacheTypeface, LFontSize);
    FTextCacheFontName := FFont.Name; FTextCacheFontStyle := FFont.Style;
    FTextCacheFontSize := LFontSize; FTextCachePPI := LPPI; FTextCacheText := ''; FTextCacheWidth := 0;
  end;
  Result := FTextCacheFont;
end;

function TDSkSelect.GetLabelFontCache: ISkFont;
var LFontStyle: TSkFontStyle; LPPI: Integer; LFontSize: Single;
begin
  LPPI := GetEffectivePPI;
  if IsLabelFloating then LFontSize := FLabelFont.Size * LPPI / 72 * LABEL_FLOAT_SIZE_RATIO
  else LFontSize := FLabelFont.Size * LPPI / 72;
  if (fsBold in FLabelFont.Style) and (fsItalic in FLabelFont.Style) then LFontStyle := TSkFontStyle.BoldItalic
  else if fsBold in FLabelFont.Style then LFontStyle := TSkFontStyle.Bold
  else if fsItalic in FLabelFont.Style then LFontStyle := TSkFontStyle.Italic
  else LFontStyle := TSkFontStyle.Normal;
  if (FLabelCacheFont = nil) or (FLabelCachePPI <> LPPI) or (FLabelCacheFontName <> FLabelFont.Name) or
    (FLabelCacheFontStyle <> FLabelFont.Style) or not SameValue(FLabelCacheFontSize, LFontSize) then begin
    FLabelCacheTypeface := TSkTypeface.MakeFromName(FLabelFont.Name, LFontStyle);
    FLabelCacheFont := TSkFont.Create(FLabelCacheTypeface, LFontSize);
    FLabelCacheFontName := FLabelFont.Name; FLabelCacheFontStyle := FLabelFont.Style;
    FLabelCacheFontSize := LFontSize; FLabelCachePPI := LPPI;
  end;
  Result := FLabelCacheFont;
end;

function TDSkSelect.GetHelperFontCache: ISkFont;
var LPPI: Integer; LFontSize: Single;
begin
  LPPI := GetEffectivePPI; LFontSize := 10 * LPPI / 72;
  if (FHelperCacheFont = nil) or (FHelperCachePPI <> LPPI) or not SameValue(FHelperCacheFontSize, LFontSize) then begin
    FHelperCacheTypeface := TSkTypeface.MakeFromName(GetDefaultFontName, TSkFontStyle.Normal);
    FHelperCacheFont := TSkFont.Create(FHelperCacheTypeface, LFontSize);
    FHelperCacheFontName := GetDefaultFontName; FHelperCacheFontSize := LFontSize; FHelperCachePPI := LPPI;
  end;
  Result := FHelperCacheFont;
end;

function TDSkSelect.GetDisplayText: string;
begin
  if FUseItemText and (FItemIndex >= 0) and (FItemIndex < FItems.Count) then
    Result := FItems[FItemIndex]
  else
    Result := FText;
end;

function TDSkSelect.HasValue: Boolean; begin Result := GetDisplayText <> ''; end;
function TDSkSelect.IsLabelFloating: Boolean;
begin
  Result := (FLabelPlacement = slpShrink) or HasValue or FDroppedDown or Focused;
end;

function TDSkSelect.GetSelectBorderColor: TAlphaColor;
begin
  if FError then Result := $FFD32F2F
  else if FDroppedDown or Focused then begin
    case FColorScheme of
      muiSecondary: Result := $FF9C27B0; muiError: Result := $FFD32F2F;
      muiWarning: Result := $FFED6C02; muiInfo: Result := $FF0288D1;
      muiSuccess: Result := $FF2E7D32;
    else Result := $FF1976D2; end;
  end else Result := $FFBDBDBD;
end;

function TDSkSelect.GetSelectLabelColor: TAlphaColor;
begin
  if FError then Result := $FFD32F2F
  else if FDroppedDown or Focused then begin
    case FColorScheme of
      muiSecondary: Result := $FF9C27B0; muiError: Result := $FFD32F2F;
      muiWarning: Result := $FFED6C02; muiInfo: Result := $FF0288D1;
      muiSuccess: Result := $FF2E7D32;
    else Result := $FF1976D2; end;
  end else Result := $FF757575;
end;

procedure TDSkSelect.ToggleDropDown;
var LScreenPos: TPoint; LDropDownH: Single; LMonitorRect: TRect;
begin
  if FDroppedDown then begin CloseDropDown; Exit; end;
  if (FItems.Count = 0) or FReadOnly or not Enabled then Exit;
  if FDropDownForm = nil then FDropDownForm := TDSkSelectDropDownForm.CreateNew(Self);
  FDropDownForm.Items := FItems;
  FDropDownForm.ItemIndex := FItemIndex;
  FDropDownForm.HoverIndex := FItemIndex;
  FDropDownForm.MaxVisibleCount := FMaxDropCount;
  FDropDownForm.ColorScheme := FColorScheme;
  FDropDownForm.Font := FFont;
  FDropDownForm.OnSelectItem := DoSelectItem;
  FDropDownForm.ItemHeight := ITEM_HEIGHT;
  LDropDownH := Min(FMaxDropCount, FItems.Count) * ITEM_HEIGHT;
  LScreenPos := ClientToScreen(Point(0, Height));
  LMonitorRect := Screen.MonitorFromPoint(LScreenPos).WorkareaRect;
  if LScreenPos.Y + LDropDownH > LMonitorRect.Bottom then
    LScreenPos.Y := ClientToScreen(Point(0, 0)).Y - Round(LDropDownH);
  FDropDownForm.SetBounds(LScreenPos.X, LScreenPos.Y, Width, Round(LDropDownH));
  FDropDownForm.Show;
  SetWindowPos(FDropDownForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
  FDroppedDown := True;
  RequestRedraw;
  if Assigned(FOnDropDown) then FOnDropDown(Self);
  Winapi.Windows.SetFocus(FDropDownForm.Handle);
end;

procedure TDSkSelect.CloseDropDown;
begin
  if not FDroppedDown then Exit;
  FDroppedDown := False;
  if FDropDownForm <> nil then FDropDownForm.Hide;
  RequestRedraw;
  if Assigned(FOnCloseUp) then FOnCloseUp(Self);
  if CanFocus then SetFocus;
end;

procedure TDSkSelect.DoSelectItem(Sender: TObject; ItemIndex: Integer; const ItemText: string);
begin
  FItemIndex := ItemIndex;
  FUseItemText := True;
  InvalidateTextCache;
  RequestRedraw;
  if Assigned(FOnItemClick) then FOnItemClick(Self, ItemIndex, ItemText);
end;

procedure TDSkSelect.Clear; begin FItemIndex := -1; FText := ''; FUseItemText := True; InvalidateTextCache; RequestRedraw; end;
procedure TDSkSelect.AddItem(const AText: string); begin FItems.Add(AText); end;
procedure TDSkSelect.RemoveItem(Index: Integer);
begin
  if (Index >= 0) and (Index < FItems.Count) then begin
    FItems.Delete(Index);
    if FItemIndex = Index then FItemIndex := -1
    else if FItemIndex > Index then Dec(FItemIndex);
  end;
end;

function TDSkSelect.ShouldClipWindowRegion: Boolean; begin Result := False; end;
function TDSkSelect.DependsOnParentBackground: Boolean; begin Result := False; end;
function TDSkSelect.DependsOnParentVisualBackground: Boolean;
begin
  if Parent is TDSCustomSkControl then Result := TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack
  else Result := False;
end;

procedure TDSkSelect.CMEnabledChanged(var Message: TMessage); begin inherited; RequestRedraw; end;
procedure TDSkSelect.CMFocusChanged(var Message: TCMFocusChanged); begin inherited; RequestRedraw; end;

procedure TDSkSelect.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var LClearBtnSize, LClearBtnX, LClearBtnY, LArrowSize: Single;
begin
  inherited;
  if (Button <> mbLeft) or not Enabled then Exit;
  if FClearable and HasValue then begin
    LClearBtnSize := DpiScaleValue(CLEAR_BTN_SIZE);
    LArrowSize := DpiScaleValue(ARROW_ICON_SIZE);
    LClearBtnX := Width - DpiScaleValue(ITEM_PADDING_H) - LArrowSize - DpiScaleValue(8) - LClearBtnSize;
    LClearBtnY := (Height - LClearBtnSize) / 2;
    if (X >= LClearBtnX) and (X <= LClearBtnX + LClearBtnSize) and
       (Y >= LClearBtnY) and (Y <= LClearBtnY + LClearBtnSize) then begin Clear; Exit; end;
  end;
  ToggleDropDown;
end;

procedure TDSkSelect.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if FReadOnly then Exit;
  case Key of
    VK_SPACE, VK_DOWN: if not FDroppedDown then ToggleDropDown;
    VK_ESCAPE: if FDroppedDown then CloseDropDown;
  end;
end;

procedure TDSkSelect.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
begin
  ACanvas.Clear($00FFFFFF);
  DrawBackground(ACanvas, ADest, AOpacity);
  DrawBorder(ACanvas, ADest);
  DrawLabel(ACanvas, ADest);
  if HasValue then DrawText(ACanvas, ADest)
  else if FPlaceholder <> '' then DrawPlaceholder(ACanvas, ADest);
  DrawArrowIcon(ACanvas, ADest);
  if FClearable and HasValue then DrawClearButton(ACanvas, ADest);
  DrawHelperText(ACanvas, ADest);
end;

procedure TDSkSelect.DrawBackground(const ACanvas: ISkCanvas; const ADest: TRectF; AOpacity: Single);
var LPaint: ISkPaint; LRoundRect: ISkRoundRect; LRadius: Single;
begin
  if FVariant = svFilled then begin
    LPaint := TSkPaint.Create; LPaint.AntiAlias := True;
    LPaint.Style := TSkPaintStyle.Fill; LPaint.Color := $08000000;
    LRadius := DpiScaleValue(BORDER_RADIUS);
    LRoundRect := TSkRoundRect.Create; LRoundRect.SetRect(ADest, LRadius, LRadius);
    ACanvas.DrawRoundRect(LRoundRect, LPaint);
  end;
  // svUnderline 和 svOutlined 不绘制背景（透明）
end;

procedure TDSkSelect.DrawBorder(const ACanvas: ISkCanvas; const ADest: TRectF);
var LPaint: ISkPaint; LPathBuilder: ISkPathBuilder; LPath: ISkPath;
    LRect: TRectF; LRadius, LBorderW: Single; LColor: TAlphaColor;
    LLabelFont: ISkFont; LLabelW, LLabelLeft: Single; LRoundRect: ISkRoundRect;
begin
  LColor := GetSelectBorderColor;
  LBorderW := DpiScaleValue(1);
  if FDroppedDown or Focused then LBorderW := DpiScaleValue(2);
  LRadius := DpiScaleValue(BORDER_RADIUS);
  LRect := ADest; LRect.Inflate(-LBorderW / 2, -LBorderW / 2);
  LPaint := TSkPaint.Create; LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Stroke; LPaint.StrokeWidth := LBorderW;
  LPaint.Color := LColor; LPaint.StrokeJoin := TSkStrokeJoin.Round;
  if FVariant = svOutlined then begin
    if IsLabelFloating and (FLabel <> '') then begin
      LLabelFont := GetLabelFontCache;
      LLabelW := LLabelFont.MeasureText(FLabel) + DpiScaleValue(8);
      LLabelLeft := DpiScaleValue(ITEM_PADDING_H - 2);
      LPathBuilder := TSkPathBuilder.Create;
      LPathBuilder.MoveTo(LLabelLeft - DpiScaleValue(4), LRect.Top);
      LPathBuilder.LineTo(LRect.Left + LRadius, LRect.Top);
      LPathBuilder.ArcTo(RectF(LRect.Left, LRect.Top, LRect.Left + LRadius * 2, LRect.Top + LRadius * 2), 270, -90, False);
      LPathBuilder.LineTo(LRect.Left, LRect.Bottom - LRadius);
      LPathBuilder.ArcTo(RectF(LRect.Left, LRect.Bottom - LRadius * 2, LRect.Left + LRadius * 2, LRect.Bottom), 180, -90, False);
      LPathBuilder.LineTo(LRect.Right - LRadius, LRect.Bottom);
      LPathBuilder.ArcTo(RectF(LRect.Right - LRadius * 2, LRect.Bottom - LRadius * 2, LRect.Right, LRect.Bottom), 90, -90, False);
      LPathBuilder.LineTo(LRect.Right, LRect.Top + LRadius);
      LPathBuilder.ArcTo(RectF(LRect.Right - LRadius * 2, LRect.Top, LRect.Right, LRect.Top + LRadius * 2), 0, -90, False);
      LPathBuilder.LineTo(LLabelLeft + LLabelW + DpiScaleValue(4), LRect.Top);
      LPath := LPathBuilder.Detach; ACanvas.DrawPath(LPath, LPaint);
    end else begin
      LRoundRect := TSkRoundRect.Create; LRoundRect.SetRect(LRect, LRadius, LRadius);
      ACanvas.DrawRoundRect(LRoundRect, LPaint);
    end;
  end else begin
    // Filled 和 Underline 变体：只绘制底部横线
    LPaint.StrokeCap := TSkStrokeCap.Round;
    if FVariant = svUnderline then
      // Underline 变体：下划线上移，靠近文字
      ACanvas.DrawLine(PointF(LRect.Left, LRect.Bottom - DpiScaleValue(6)), PointF(LRect.Right, LRect.Bottom - DpiScaleValue(6)), LPaint)
    else
      // Filled 变体：底部横线
      ACanvas.DrawLine(PointF(LRect.Left, LRect.Bottom), PointF(LRect.Right, LRect.Bottom), LPaint);
  end;
end;

procedure TDSkSelect.DrawLabel(const ACanvas: ISkCanvas; const ADest: TRectF);
var LFont: ISkFont; LPaint: ISkPaint; LX, LY, LTextW: Single;
    LBackPaint: ISkPaint; LBackRect: TRectF;
    LMetrics: TSkFontMetrics;
begin
  if FLabel = '' then Exit;
  LFont := GetLabelFontCache;
  LFont.GetMetrics(LMetrics);
  LPaint := TSkPaint.Create; LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Fill; LPaint.Color := GetSelectLabelColor;
  if IsLabelFloating then begin
    LX := DpiScaleValue(ITEM_PADDING_H - 2);
    if FVariant = svOutlined then begin
      // 使用实际字体 ascent 定位，确保中文和大字号不会被截取
      // LMetrics.Ascent 为负值（如 -10.8），取反后即为文字顶部到基线的距离
      LY := ADest.Top + DpiScaleValue(1) - LMetrics.Ascent;
      LTextW := LFont.MeasureText(FLabel);
      // 白色背景覆盖从控件顶部到文字底部的区域
      LBackRect := RectF(LX - DpiScaleValue(4), ADest.Top - DpiScaleValue(1),
        LX + LTextW + DpiScaleValue(4), ADest.Top + LMetrics.Descent + DpiScaleValue(1));
      LBackPaint := TSkPaint.Create; LBackPaint.AntiAlias := False;
      LBackPaint.Style := TSkPaintStyle.Fill; LBackPaint.Color := $FFFFFFFF;
      ACanvas.DrawRect(LBackRect, LBackPaint);
    end else
      // Filled 和 Underline 变体：标签位于底部横线上方
      LY := DpiScaleValue(8) + LFont.Size;
  end else begin
    LX := DpiScaleValue(ITEM_PADDING_H);
    LY := ADest.Top + (ADest.Height + LFont.Size) / 2;
  end;
  ACanvas.DrawSimpleText(FLabel, LX, LY, LFont, LPaint);
end;

procedure TDSkSelect.DrawText(const ACanvas: ISkCanvas; const ADest: TRectF);
var LFont: ISkFont; LPaint: ISkPaint; LX, LY: Single; LText: string;
begin
  LText := GetDisplayText; if LText = '' then Exit;
  LFont := GetTextFont;
  LPaint := TSkPaint.Create; LPaint.AntiAlias := True; LPaint.Style := TSkPaintStyle.Fill;
  if not Enabled then LPaint.Color := $FF757575 else LPaint.Color := VclColorToAlphaColor(FFont.Color);
  LX := DpiScaleValue(ITEM_PADDING_H);
  if IsLabelFloating and (FLabel <> '') then begin
    if FSize = ssSmall then
      LY := ADest.Top + DpiScaleValue(16) + LFont.Size
    else
      LY := ADest.Top + DpiScaleValue(28) + LFont.Size;
  end
  else
    LY := ADest.Top + (ADest.Height + LFont.Size) / 2;
  ACanvas.DrawSimpleText(LText, LX, LY, LFont, LPaint);
end;

procedure TDSkSelect.DrawPlaceholder(const ACanvas: ISkCanvas; const ADest: TRectF);
var LFont: ISkFont; LPaint: ISkPaint; LX, LY: Single;
begin
  if FPlaceholder = '' then Exit;
  // slpFloat 模式下，当有 label 且 label 未浮动时（无选中项），label 充当 placeholder，不再额外显示
  if (FLabel <> '') and (FLabelPlacement = slpFloat) and not IsLabelFloating then Exit;
  LFont := GetTextFont;
  LPaint := TSkPaint.Create; LPaint.AntiAlias := True; LPaint.Style := TSkPaintStyle.Fill; LPaint.Color := $61000000;
  LX := DpiScaleValue(ITEM_PADDING_H);
  if (FLabel <> '') and not IsLabelFloating then begin
    if FSize = ssSmall then
      LY := ADest.Top + DpiScaleValue(16) + LFont.Size
    else
      LY := ADest.Top + DpiScaleValue(28) + LFont.Size;
  end
  else
    LY := ADest.Top + (ADest.Height + LFont.Size) / 2;
  ACanvas.DrawSimpleText(FPlaceholder, LX, LY, LFont, LPaint);
end;

procedure TDSkSelect.DrawArrowIcon(const ACanvas: ISkCanvas; const ADest: TRectF);
var LPathBuilder: ISkPathBuilder; LPath: ISkPath; LPaint: ISkPaint;
    LCenter: TPointF; LSize: Single; LColor: TAlphaColor;
begin
  LSize := DpiScaleValue(ARROW_ICON_SIZE / 2);
  LCenter := PointF(ADest.Right - DpiScaleValue(ITEM_PADDING_H) - LSize, ADest.Top + ADest.Height / 2);
  LPathBuilder := TSkPathBuilder.Create;
  LPathBuilder.MoveTo(LCenter.X - LSize * 0.6, LCenter.Y - LSize * 0.3);
  LPathBuilder.LineTo(LCenter.X, LCenter.Y + LSize * 0.3);
  LPathBuilder.LineTo(LCenter.X + LSize * 0.6, LCenter.Y - LSize * 0.3);
  LPath := LPathBuilder.Detach;
  LPaint := TSkPaint.Create; LPaint.AntiAlias := True; LPaint.Style := TSkPaintStyle.Stroke;
  LPaint.StrokeWidth := DpiScaleValue(1.5); LPaint.StrokeCap := TSkStrokeCap.Round; LPaint.StrokeJoin := TSkStrokeJoin.Round;
  if not Enabled then LColor := $FFBDBDBD else LColor := $FF757575;
  LPaint.Color := LColor; ACanvas.DrawPath(LPath, LPaint);
end;

procedure TDSkSelect.DrawClearButton(const ACanvas: ISkCanvas; const ADest: TRectF);
var LPaint: ISkPaint; LCenter: TPointF; LSize, LArrowSize: Single;
    LPathBuilder: ISkPathBuilder; LPath: ISkPath;
begin
  LSize := DpiScaleValue(CLEAR_BTN_SIZE / 2);
  LArrowSize := DpiScaleValue(ARROW_ICON_SIZE);
  LCenter := PointF(ADest.Right - DpiScaleValue(ITEM_PADDING_H) - LArrowSize - DpiScaleValue(8) - LSize, ADest.Top + ADest.Height / 2);
  LPaint := TSkPaint.Create; LPaint.AntiAlias := True; LPaint.Style := TSkPaintStyle.Fill; LPaint.Color := $20000000;
  ACanvas.DrawCircle(LCenter, LSize, LPaint);
  LPathBuilder := TSkPathBuilder.Create;
  LPathBuilder.MoveTo(LCenter.X - LSize * 0.4, LCenter.Y - LSize * 0.4);
  LPathBuilder.LineTo(LCenter.X + LSize * 0.4, LCenter.Y + LSize * 0.4);
  LPathBuilder.MoveTo(LCenter.X + LSize * 0.4, LCenter.Y - LSize * 0.4);
  LPathBuilder.LineTo(LCenter.X - LSize * 0.4, LCenter.Y + LSize * 0.4);
  LPath := LPathBuilder.Detach;
  LPaint.Style := TSkPaintStyle.Stroke; LPaint.StrokeWidth := DpiScaleValue(1.5);
  LPaint.StrokeCap := TSkStrokeCap.Round; LPaint.Color := $FF757575;
  ACanvas.DrawPath(LPath, LPaint);
end;

procedure TDSkSelect.DrawHelperText(const ACanvas: ISkCanvas; const ADest: TRectF);
var LFont: ISkFont; LPaint: ISkPaint; LText: string; LX, LY: Single;
begin
  if FError and (FErrorText <> '') then LText := FErrorText
  else if FHelperText <> '' then LText := FHelperText else Exit;
  LFont := GetHelperFontCache;
  LX := DpiScaleValue(ITEM_PADDING_H); LY := ADest.Bottom + DpiScaleValue(HELPER_TEXT_GAP) + LFont.Size;
  LPaint := TSkPaint.Create; LPaint.AntiAlias := True; LPaint.Style := TSkPaintStyle.Fill;
  if FError then LPaint.Color := $FFD32F2F else LPaint.Color := $FF757575;
  ACanvas.DrawSimpleText(LText, LX, LY, LFont, LPaint);
end;

end.
