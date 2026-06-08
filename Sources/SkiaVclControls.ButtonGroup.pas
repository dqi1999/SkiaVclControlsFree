unit SkiaVclControls.ButtonGroup;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base, SkiaVclControls.Button;

type
  TDSkButtonGroupItemClickEvent = procedure(Sender: TObject; ButtonIndex: Integer) of object;

  TDSkButtonGroup = class(TDSCustomSkControl)
  private
    FOrientation: TDSkButtonGroupOrientation;
    FVariant: TDSkButtonGroupVariant;
    FSize: TDSkButtonGroupSize;
    FColorScheme: TDSkMUIColorScheme;
    FDisableElevation: Boolean;
    FFullWidth: Boolean;
    FExclusive: Boolean;
    FAllowNone: Boolean;
    FItemIndex: Integer;
    FSpacing: Single;
    FLoading: Boolean;
    FUpdating: Boolean;
    FOnItemClick: TDSkButtonGroupItemClickEvent;
    function MakeUniqueButtonName(const APrefix: string): string;
    procedure SetOrientation(Value: TDSkButtonGroupOrientation);
    procedure SetVariant(Value: TDSkButtonGroupVariant);
    procedure SetSize(Value: TDSkButtonGroupSize);
    procedure SetColorScheme(Value: TDSkMUIColorScheme);
    procedure SetDisableElevation(Value: Boolean);
    procedure SetFullWidth(Value: Boolean);
    procedure SetExclusive(Value: Boolean);
    procedure SetAllowNone(Value: Boolean);
    procedure SetItemIndex(Value: Integer);
    procedure SetSpacing(Value: Single);
    function GetSizeHeight: Integer;
    procedure ApplyGroupSettings;
    procedure ApplyButtonPosition(Btn: TDSkButton; Index, Count: Integer);
    procedure ApplyButtonVariant(Btn: TDSkButton; Index, Count: Integer);
    procedure ApplyButtonSize(Btn: TDSkButton);
    procedure ApplyButtonColors(Btn: TDSkButton);
    procedure CreateDefaultDesignButtons;
    procedure UpdateSelection(ClickedBtn: TDSkButton);
    procedure UpdateCheckedStates;
    procedure WMDSkButtonGroupClick(var Message: TMessage); message WM_USER + 200;
    procedure CMControlChange(var Message: TCMControlChange); message CM_CONTROLCHANGE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    function ShouldClipWindowRegion: Boolean; override;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawBackground(const ACanvas: ISkCanvas; const ADest: TRectF; AOpacity: Single); override;
    procedure CornerRadiusChanged; override;
    procedure Loaded; override;
    procedure Resize; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetButtonCount: Integer;
    function GetButton(Index: Integer): TDSkButton;
    function IndexOfButton(Btn: TDSkButton): Integer;
    property ButtonCount: Integer read GetButtonCount;
    property Buttons[Index: Integer]: TDSkButton read GetButton;
  published
    property Orientation: TDSkButtonGroupOrientation read FOrientation write SetOrientation default bgoHorizontal;
    property Variant: TDSkButtonGroupVariant read FVariant write SetVariant default bgvOutlined;
    property Size: TDSkButtonGroupSize read FSize write SetSize default bgsMedium;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property DisableElevation: Boolean read FDisableElevation write SetDisableElevation default False;
    property FullWidth: Boolean read FFullWidth write SetFullWidth default False;
    property Exclusive: Boolean read FExclusive write SetExclusive default True;
    property AllowNone: Boolean read FAllowNone write SetAllowNone default True;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Spacing: Single read FSpacing write SetSpacing;
    property OnItemClick: TDSkButtonGroupItemClickEvent read FOnItemClick write FOnItemClick;
    property CornerRadius;
    property BackgroundColor;
    property BorderColor;
    property BorderWidth;
    property OnClick;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

implementation

const
  DESIGNER_GRIP_SIZE  = 10;
  MUI_PRIMARY_MAIN     = $FF1976D2;
  MUI_PRIMARY_LIGHT    = $FF42A5F5;
  MUI_PRIMARY_DARK     = $FF1565C0;
  MUI_SECONDARY_MAIN   = $FF9C27B0;
  MUI_SECONDARY_LIGHT  = $FFBA68C8;
  MUI_SECONDARY_DARK   = $FF7B1FA2;
  MUI_ERROR_MAIN       = $FFD32F2F;
  MUI_ERROR_LIGHT      = $FFEF5350;
  MUI_ERROR_DARK       = $FFC62828;
  MUI_WARNING_MAIN     = $FFED6C02;
  MUI_WARNING_LIGHT    = $FFFF9800;
  MUI_WARNING_DARK     = $FFE65100;
  MUI_INFO_MAIN        = $FF0288D1;
  MUI_INFO_LIGHT       = $FF03A9F4;
  MUI_INFO_DARK        = $FF01579B;
  MUI_SUCCESS_MAIN     = $FF2E7D32;
  MUI_SUCCESS_LIGHT    = $FF4CAF50;
  MUI_SUCCESS_DARK     = $FF1B5E20;
  MUI_DISABLED_BG      = $FFE0E0E0;
  MUI_DISABLED_TEXT    = $FF757575;
  MUI_OUTLINED_BORDER  = $33000000;
  MUI_DIVIDER          = $1F000000;

function AlphaColorWithAlpha(AColor: TAlphaColor; AAlpha: Byte): TAlphaColor;
begin
  Result := (TAlphaColor(AAlpha) shl 24) or (AColor and $00FFFFFF);
end;

function DarkenColor(AColor: TAlphaColor; AAmount: Single): TAlphaColor;
var
  R, G, B: Byte;
begin
  R := Round(((AColor shr 16) and $FF) * (1 - AAmount));
  G := Round(((AColor shr 8) and $FF) * (1 - AAmount));
  B := Round((AColor and $FF) * (1 - AAmount));
  Result := $FF000000 or (TAlphaColor(R) shl 16) or (TAlphaColor(G) shl 8) or TAlphaColor(B);
end;

function BlendWithWhite(AColor: TAlphaColor; AAmount: Single): TAlphaColor;
var
  R, G, B: Byte;
begin
  R := Round(255 - (255 - ((AColor shr 16) and $FF)) * AAmount);
  G := Round(255 - (255 - ((AColor shr 8) and $FF)) * AAmount);
  B := Round(255 - (255 - (AColor and $FF)) * AAmount);
  Result := $FF000000 or (TAlphaColor(R) shl 16) or (TAlphaColor(G) shl 8) or TAlphaColor(B);
end;

{ TDSkButtonGroup }

constructor TDSkButtonGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOrientation := bgoHorizontal;
  FVariant := bgvOutlined;
  FSize := bgsMedium;
  FColorScheme := muiPrimary;
  FDisableElevation := False;
  FFullWidth := False;
  FExclusive := True;
  FAllowNone := True;
  FItemIndex := -1;
  FSpacing := 0;
  // DFM 读取时先延后布局；代码动态创建时应立即允许 Resize 重新排布子按钮。
  FLoading := (csLoading in ComponentState) or
    ((AOwner <> nil) and (csLoading in AOwner.ComponentState));
  FUpdating := False;
  Width := 260;
  Height := 36;
  CornerRadius := 4;
  BackgroundColor := TAlphaColors.White;
  BorderColor := MUI_OUTLINED_BORDER;
  BorderWidth := 1;

  if (csDesigning in ComponentState) and not FLoading then
    CreateDefaultDesignButtons;
end;

function TDSkButtonGroup.MakeUniqueButtonName(const APrefix: string): string;
var
  i: Integer;
  LOwner: TComponent;
begin
  LOwner := Owner;
  if LOwner = nil then
    LOwner := Self;

  i := 1;
  repeat
    Result := APrefix + IntToStr(i);
    Inc(i);
  until LOwner.FindComponent(Result) = nil;
end;

procedure TDSkButtonGroup.CreateDefaultDesignButtons;
const
  DefaultCaptions: array[0..2] of string = ('ONE', 'TWO', 'THREE');
var
  i: Integer;
  Btn: TDSkButton;
  LOwner: TComponent;
begin
  if GetButtonCount > 0 then
    Exit;

  LOwner := Owner;
  if LOwner = nil then
    LOwner := Self;

  // 只在设计器中新拖入控件时创建默认按钮，让使用者能立刻看到可编辑的 3 个 item。
  FFullWidth := True;
  FUpdating := True;
  try
    for i := Low(DefaultCaptions) to High(DefaultCaptions) do
    begin
      Btn := TDSkButton.Create(LOwner);
      Btn.Name := MakeUniqueButtonName('DSkButtonGroupItem');
      Btn.Parent := Self;
      Btn.ButtonText := DefaultCaptions[i];
      Btn.Width := Max(1, Width div Length(DefaultCaptions));
      Btn.Height := Height;
    end;
  finally
    FUpdating := False;
  end;

  ApplyGroupSettings;
  Realign;
end;

procedure TDSkButtonGroup.Loaded;
begin
  inherited;
  FLoading := False;
  ApplyGroupSettings;
  Realign;
end;

procedure TDSkButtonGroup.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  inherited;
  if (AOperation = opRemove) and (AComponent is TDSkButton) and not (csDestroying in ComponentState) then
  begin
    TDSkButton(AComponent).SetGroupRenderOptions(False, TAlphaColors.Null, True, TAlphaColors.Null);
    if not FLoading then
    begin
      ApplyGroupSettings;
      Realign;
    end;
  end;
end;

function TDSkButtonGroup.ShouldClipWindowRegion: Boolean;
begin
  Result := False;
end;

procedure TDSkButtonGroup.Resize;
begin
  inherited;
  if not FLoading then
    Realign;
end;

procedure TDSkButtonGroup.CornerRadiusChanged;
begin
  inherited;
  if not FLoading then
    ApplyGroupSettings;
end;

function TDSkButtonGroup.GetSizeHeight: Integer;
begin
  case FSize of
    bgsSmall: Result := DpiScaleValue(28);
    bgsLarge: Result := DpiScaleValue(44);
  else
    Result := DpiScaleValue(36);
  end;
end;

function TDSkButtonGroup.GetButtonCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to ControlCount - 1 do
    if Controls[i] is TDSkButton then
      Inc(Result);
end;

function TDSkButtonGroup.GetButton(Index: Integer): TDSkButton;
var
  i, LIndex: Integer;
begin
  Result := nil;
  LIndex := 0;
  for i := 0 to ControlCount - 1 do
    if Controls[i] is TDSkButton then
    begin
      if LIndex = Index then
        Exit(TDSkButton(Controls[i]));
      Inc(LIndex);
    end;
end;

function TDSkButtonGroup.IndexOfButton(Btn: TDSkButton): Integer;
var
  i, LIndex: Integer;
begin
  Result := -1;
  LIndex := 0;
  for i := 0 to ControlCount - 1 do
    if Controls[i] is TDSkButton then
    begin
      if Controls[i] = Btn then
        Exit(LIndex);
      Inc(LIndex);
    end;
end;

procedure TDSkButtonGroup.AlignControls(AControl: TControl; var Rect: TRect);
var
  Count, i: Integer;
  Btn: TDSkButton;
  X, Y, W, H, Overlap, ItemH: Integer;
  AvailableW, AvailableH: Integer;
begin
  inherited AlignControls(AControl, Rect);
  if FUpdating then Exit;

  Count := GetButtonCount;
  if Count = 0 then Exit;

  FUpdating := True;
  try
    AvailableW := Max(0, ClientWidth);
    AvailableH := Max(0, ClientHeight);
    if (csDesigning in ComponentState) and FFullWidth then
      AvailableW := Max(0, AvailableW - DpiScaleValue(DESIGNER_GRIP_SIZE));
    if (FVariant = bgvOutlined) and (Round(FSpacing) = 0) then
      Overlap := 1
    else
      Overlap := 0;
    ItemH := GetSizeHeight;

    if FOrientation = bgoHorizontal then
    begin
      X := 0;
      Y := Max(0, (AvailableH - ItemH) div 2);
      H := ItemH;
      if FFullWidth then
        W := Max(1, Round((AvailableW + (Count - 1) * Overlap - (Count - 1) * FSpacing) / Count))
      else
        W := 0;

      for i := 0 to Count - 1 do
      begin
        Btn := GetButton(i);
        if Btn = nil then Continue;
        if not FFullWidth then
          W := Btn.Width
        else if i = Count - 1 then
          W := Max(1, AvailableW - X);
        Btn.SetBounds(X, Y, W, H);
        X := X + W + Round(FSpacing) - Overlap;
      end;
    end
    else
    begin
      Y := 0;
      if FFullWidth then
        W := Max(1, AvailableW)
      else
        W := 0;
      H := ItemH;

      for i := 0 to Count - 1 do
      begin
        Btn := GetButton(i);
        if Btn = nil then Continue;
        if not FFullWidth then
          W := Btn.Width;
        Btn.SetBounds(0, Y, W, H);
        Y := Y + H + Round(FSpacing) - Overlap;
      end;
    end;
  finally
    FUpdating := False;
  end;
end;

procedure TDSkButtonGroup.SetOrientation(Value: TDSkButtonGroupOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    ApplyGroupSettings;
    Realign;
    Redraw;
  end;
end;

procedure TDSkButtonGroup.SetVariant(Value: TDSkButtonGroupVariant);
begin
  if FVariant <> Value then
  begin
    FVariant := Value;
    ApplyGroupSettings;
    Realign;
    Redraw;
  end;
end;

procedure TDSkButtonGroup.SetSize(Value: TDSkButtonGroupSize);
begin
  if FSize <> Value then
  begin
    FSize := Value;
    ApplyGroupSettings;
    Realign;
    Redraw;
  end;
end;

procedure TDSkButtonGroup.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then
  begin
    FColorScheme := Value;
    ApplyGroupSettings;
    Redraw;
  end;
end;

procedure TDSkButtonGroup.SetDisableElevation(Value: Boolean);
begin
  if FDisableElevation <> Value then
  begin
    FDisableElevation := Value;
    ApplyGroupSettings;
    Redraw;
  end;
end;

procedure TDSkButtonGroup.SetFullWidth(Value: Boolean);
begin
  if FFullWidth <> Value then
  begin
    FFullWidth := Value;
    Realign;
    Redraw;
  end;
end;

procedure TDSkButtonGroup.SetExclusive(Value: Boolean);
begin
  if FExclusive <> Value then
  begin
    FExclusive := Value;
    UpdateCheckedStates;
  end;
end;

procedure TDSkButtonGroup.SetAllowNone(Value: Boolean);
begin
  if FAllowNone <> Value then
    FAllowNone := Value;
end;

procedure TDSkButtonGroup.SetItemIndex(Value: Integer);
begin
  if Value < -1 then Value := -1;
  if Value >= GetButtonCount then Value := -1;
  if FItemIndex <> Value then
  begin
    FItemIndex := Value;
    UpdateCheckedStates;
    if Assigned(FOnItemClick) then
      FOnItemClick(Self, FItemIndex);
  end;
end;

procedure TDSkButtonGroup.SetSpacing(Value: Single);
begin
  if FSpacing <> Value then
  begin
    FSpacing := Value;
    Realign;
    Redraw;
  end;
end;

procedure TDSkButtonGroup.ApplyGroupSettings;
var
  Count, i: Integer;
  Btn: TDSkButton;
begin
  if FUpdating then Exit;

  Count := GetButtonCount;
  FUpdating := True;
  try
    for i := 0 to Count - 1 do
    begin
      Btn := GetButton(i);
      if Btn = nil then Continue;
      ApplyButtonSize(Btn);
      ApplyButtonColors(Btn);
      ApplyButtonVariant(Btn, i, Count);
      ApplyButtonPosition(Btn, i, Count);
      Btn.ButtonType := btNormal;
      Btn.HoverEffect := heNone;
      Btn.Redraw;
    end;
  finally
    FUpdating := False;
  end;
  UpdateCheckedStates;
end;

procedure TDSkButtonGroup.ApplyButtonPosition(Btn: TDSkButton; Index, Count: Integer);
var
  R: Single;
begin
  R := CornerRadius;
  Btn.ButtonStyle := bsRoundRect;
  Btn.ButtonRound := R;

  if Count <= 1 then
  begin
    Btn.CornerRadii[0] := R;
    Btn.CornerRadii[1] := R;
    Btn.CornerRadii[2] := R;
    Btn.CornerRadii[3] := R;
    Exit;
  end;

  Btn.CornerRadii[0] := 0;
  Btn.CornerRadii[1] := 0;
  Btn.CornerRadii[2] := 0;
  Btn.CornerRadii[3] := 0;

  if FOrientation = bgoHorizontal then
  begin
    if Index = 0 then
    begin
      Btn.CornerRadii[0] := R;
      Btn.CornerRadii[3] := R;
    end
    else if Index = Count - 1 then
    begin
      Btn.CornerRadii[1] := R;
      Btn.CornerRadii[2] := R;
    end;
  end
  else
  begin
    if Index = 0 then
    begin
      Btn.CornerRadii[0] := R;
      Btn.CornerRadii[1] := R;
    end
    else if Index = Count - 1 then
    begin
      Btn.CornerRadii[2] := R;
      Btn.CornerRadii[3] := R;
    end;
  end;
end;

procedure TDSkButtonGroup.ApplyButtonVariant(Btn: TDSkButton; Index, Count: Integer);
var
  DividerColor: TAlphaColor;
begin
  DividerColor := TAlphaColors.Null;

  case FVariant of
    bgvContained: begin
      Btn.BorderWidth := 0;
      BorderWidth := 0;
      if Index > 0 then
        DividerColor := AlphaColorWithAlpha(DarkenColor(GetBackgroundColor, 0.2), $88);
    end;
    bgvOutlined: begin
      // 子按钮是独立 HWND，外框必须由按钮自己画，否则会被子控件盖住。
      Btn.BorderWidth := 1;
      Btn.BorderColor := BorderColor;
      BorderWidth := 0;
    end;
    bgvText: begin
      Btn.BorderWidth := 0;
      BorderWidth := 0;
      if Index > 0 then
        DividerColor := AlphaColorWithAlpha(Btn.FontColor, $80);
    end;
  end;

  Btn.SetGroupRenderOptions(True, DividerColor, FOrientation = bgoHorizontal,
    GetParentBackgroundColor);
end;

procedure TDSkButtonGroup.ApplyButtonSize(Btn: TDSkButton);
begin
  case FSize of
    bgsSmall: begin
      Btn.Font.Size := 11;
    end;
    bgsMedium: begin
      Btn.Font.Size := 12;
    end;
    bgsLarge: begin
      Btn.Font.Size := 14;
    end;
  end;
  Btn.Height := GetSizeHeight;
end;

procedure TDSkButtonGroup.ApplyButtonColors(Btn: TDSkButton);
var
  MainColor, LightColor, DarkColor: TAlphaColor;
begin
  case FColorScheme of
    muiSecondary: begin MainColor := MUI_SECONDARY_MAIN; LightColor := MUI_SECONDARY_LIGHT; DarkColor := MUI_SECONDARY_DARK; end;
    muiError: begin MainColor := MUI_ERROR_MAIN; LightColor := MUI_ERROR_LIGHT; DarkColor := MUI_ERROR_DARK; end;
    muiWarning: begin MainColor := MUI_WARNING_MAIN; LightColor := MUI_WARNING_LIGHT; DarkColor := MUI_WARNING_DARK; end;
    muiInfo: begin MainColor := MUI_INFO_MAIN; LightColor := MUI_INFO_LIGHT; DarkColor := MUI_INFO_DARK; end;
    muiSuccess: begin MainColor := MUI_SUCCESS_MAIN; LightColor := MUI_SUCCESS_LIGHT; DarkColor := MUI_SUCCESS_DARK; end;
  else
    MainColor := MUI_PRIMARY_MAIN; LightColor := MUI_PRIMARY_LIGHT; DarkColor := MUI_PRIMARY_DARK;
  end;

  case FVariant of
    bgvContained: begin
      BackgroundColor := MainColor;
      Btn.ButtonColor := MainColor;
      if FDisableElevation then
        Btn.ButtonHover := MainColor
      else
        Btn.ButtonHover := DarkColor;
      Btn.ButtonPressed := DarkColor;
      Btn.ButtonChecked := DarkColor;
      Btn.FontColor := TAlphaColors.White;
      Btn.FontHover := TAlphaColors.White;
      Btn.FontChecked := TAlphaColors.White;
    end;
    bgvOutlined: begin
      BackgroundColor := TAlphaColors.White;
      Btn.ButtonColor := TAlphaColors.White;
      Btn.ButtonHover := BlendWithWhite(MainColor, 0.08);
      Btn.ButtonPressed := BlendWithWhite(MainColor, 0.14);
      Btn.ButtonChecked := BlendWithWhite(MainColor, 0.18);
      Btn.FontColor := MainColor;
      Btn.FontHover := MainColor;
      Btn.FontChecked := MainColor;
      BorderColor := AlphaColorWithAlpha(MainColor, $80);
    end;
    bgvText: begin
      BackgroundColor := TAlphaColors.Null;
      Btn.ButtonColor := TAlphaColors.Null;
      Btn.ButtonHover := BlendWithWhite(MainColor, 0.08);
      Btn.ButtonPressed := BlendWithWhite(MainColor, 0.14);
      Btn.ButtonChecked := BlendWithWhite(MainColor, 0.18);
      Btn.FontColor := MainColor;
      Btn.FontHover := MainColor;
      Btn.FontChecked := MainColor;
      BorderColor := TAlphaColors.Null;
    end;
  end;

  Btn.ButtonDisabled := MUI_DISABLED_BG;
  Btn.FontDisabled := MUI_DISABLED_TEXT;
end;

procedure TDSkButtonGroup.UpdateCheckedStates;
var
  i: Integer;
  Btn: TDSkButton;
begin
  if FUpdating then Exit;
  FUpdating := True;
  try
    if FExclusive then
      for i := 0 to GetButtonCount - 1 do
      begin
        Btn := GetButton(i);
        if Btn <> nil then
          Btn.Checked := i = FItemIndex;
      end;
  finally
    FUpdating := False;
  end;
end;

procedure TDSkButtonGroup.UpdateSelection(ClickedBtn: TDSkButton);
var
  Idx: Integer;
begin
  Idx := IndexOfButton(ClickedBtn);
  if Idx < 0 then Exit;

  if FExclusive then
  begin
    if FItemIndex = Idx then
    begin
      if FAllowNone then
        FItemIndex := -1;
    end
    else
      FItemIndex := Idx;
    UpdateCheckedStates;
  end
  else
  begin
    ClickedBtn.Checked := not ClickedBtn.Checked;
    FItemIndex := Idx;
  end;

  if Assigned(FOnItemClick) then
    FOnItemClick(Self, FItemIndex);
end;

procedure TDSkButtonGroup.WMDSkButtonGroupClick(var Message: TMessage);
begin
  if (TObject(Message.WParam) is TDSkButton) and not FUpdating then
    UpdateSelection(TDSkButton(Message.WParam));
end;

procedure TDSkButtonGroup.CMControlChange(var Message: TCMControlChange);
begin
  inherited;
  if Message.Control is TDSkButton then
  begin
    ApplyGroupSettings;
    Realign;
    Redraw;
  end;
end;

procedure TDSkButtonGroup.CMEnabledChanged(var Message: TMessage);
begin
  // 基类已处理 Enabled 状态传播给子控件和触发重绘
  inherited;
end;

procedure TDSkButtonGroup.DrawBackground(const ACanvas: ISkCanvas; const ADest: TRectF; AOpacity: Single);
begin
  if FVariant <> bgvText then
    inherited DrawBackground(ACanvas, ADest, AOpacity);
end;

procedure TDSkButtonGroup.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
var
  i: Integer;
  LineY: Single;
  Paint: ISkPaint;
begin
  if GetButtonCount = 0 then
  begin
    inherited Draw(ACanvas, ADest, AOpacity);
    Exit;
  end;

  Paint := TSkPaint.Create;
  Paint.AntiAlias := False;
  Paint.Style := TSkPaintStyle.Fill;
  Paint.Color := GetParentBackgroundColor;
  ACanvas.DrawRect(ADest, Paint);

  if (csDesigning in ComponentState) and FFullWidth then
  begin
    // 设计期给父控件留出一小条可点击区域，避免按钮铺满后无法直接拖动 ButtonGroup。
    Paint.Style := TSkPaintStyle.Stroke;
    Paint.StrokeWidth := DpiScaleValue(1);
    Paint.Color := $55000000;
    for i := 0 to 2 do
    begin
      LineY := ADest.Top + (ADest.Height / 2) - DpiScaleValue(4) + i * DpiScaleValue(4);
      ACanvas.DrawLine(
        PointF(ADest.Right - DpiScaleValue(DESIGNER_GRIP_SIZE) + DpiScaleValue(3), LineY),
        PointF(ADest.Right - DpiScaleValue(3), LineY), Paint);
    end;
  end;
end;

end.
