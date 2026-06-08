unit Demo.Styles;

interface

uses
  System.UITypes, System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics,
  SkiaVclControls.Types, System.Skia,
  SkiaVclControls.Base, SkiaVclControls.Panel, SkiaVclControls.LabelControl,
  SkiaVclControls.RadioGroup, SkiaVclControls.CheckboxGroup,
  SkiaVclControls.SwitchGroup;

const
  // Material Design 3 颜色常量
  MD3_PRIMARY         = $FF1976D2;
  MD3_PRIMARY_LIGHT   = $FF42A5F5;
  MD3_PRIMARY_DARK    = $FF1565C0;
  MD3_PRIMARY_CONTAINER = $FFE3F2FD;
  MD3_ON_PRIMARY      = $FFFFFFFF;

  MD3_SECONDARY       = $FF9C27B0;
  MD3_SECONDARY_CONTAINER = $FFF3E5F5;

  MD3_ERROR           = $FFD32F2F;
  MD3_ERROR_CONTAINER = $FFEBEE;

  MD3_WARNING         = $FFED6C02;
  MD3_WARNING_CONTAINER = $FFFFF3E0;

  MD3_INFO            = $FF0288D1;
  MD3_INFO_CONTAINER  = $FFE1F5FE;

  MD3_SUCCESS         = $FF2E7D32;
  MD3_SUCCESS_CONTAINER = $FFE8F5E9;

  // Surface 颜色
  MD3_SURFACE         = $FFFAFAFA;
  MD3_SURFACE_CONTAINER = $FFFFFFFF;
  MD3_SURFACE_CONTAINER_LOW = $FFF5F5F5;
  MD3_SURFACE_CONTAINER_HIGH = $FFEEEEEE;

  // 文本颜色
  MD3_ON_SURFACE      = $FF212121;
  MD3_ON_SURFACE_VARIANT = $FF757575;

  // 边框颜色
  MD3_OUTLINE         = $FFE0E0E0;
  MD3_OUTLINE_VARIANT = $FFBDBDBD;

  // 圆角半径
  MD3_CORNER_RADIUS_SMALL  = 8;
  MD3_CORNER_RADIUS_MEDIUM = 12;
  MD3_CORNER_RADIUS_LARGE  = 16;
  MD3_CORNER_RADIUS_EXTRA  = 24;

  // 间距
  MD3_PADDING_SMALL   = 8;
  MD3_PADDING_MEDIUM  = 16;
  MD3_PADDING_LARGE   = 24;
  MD3_PADDING_EXTRA   = 32;

  // 字体大小
  MD3_FONT_SIZE_SMALL  = 12;
  MD3_FONT_SIZE_MEDIUM = 14;
  MD3_FONT_SIZE_LARGE  = 16;
  MD3_FONT_SIZE_TITLE  = 20;
  MD3_FONT_SIZE_HEADLINE = 24;

type
  TDemoColorScheme = (
    dcsPrimary,
    dcsSecondary,
    dcsError,
    dcsWarning,
    dcsInfo,
    dcsSuccess
  );

  TDemoCardStyle = record
    BackgroundColor: TAlphaColor;
    BorderColor: TAlphaColor;
    BorderWidth: Single;
    CornerRadius: Single;
    ShadowEnabled: Boolean;
  end;

function GetColorSchemeMain(AScheme: TDemoColorScheme): TAlphaColor;
function GetColorSchemeContainer(AScheme: TDemoColorScheme): TAlphaColor;
function GetColorSchemeLight(AScheme: TDemoColorScheme): TAlphaColor;
function GetColorSchemeDark(AScheme: TDemoColorScheme): TAlphaColor;
function GetMUIColorScheme(AScheme: TDemoColorScheme): TDSkMUIColorScheme;

function CreateCardStyle(AElevated: Boolean = True): TDemoCardStyle;
function CreateFilledCardStyle: TDemoCardStyle;
function CreateOutlinedCardStyle: TDemoCardStyle;

function ColorToHex(AColor: TAlphaColor): string;
function HexToColor(const AHex: string; ADefault: TAlphaColor = MD3_PRIMARY): TAlphaColor;

procedure ApplyDemoLabelStyle(ALabel: TDSkLabel; ATitle: Boolean = False);
procedure ApplyAdminFrameStyle(AFrame: TWinControl);

implementation

function GetColorSchemeMain(AScheme: TDemoColorScheme): TAlphaColor;
begin
  case AScheme of
    dcsPrimary:   Result := MD3_PRIMARY;
    dcsSecondary: Result := MD3_SECONDARY;
    dcsError:     Result := MD3_ERROR;
    dcsWarning:   Result := MD3_WARNING;
    dcsInfo:      Result := MD3_INFO;
    dcsSuccess:   Result := MD3_SUCCESS;
  else
    Result := MD3_PRIMARY;
  end;
end;

function GetColorSchemeContainer(AScheme: TDemoColorScheme): TAlphaColor;
begin
  case AScheme of
    dcsPrimary:   Result := MD3_PRIMARY_CONTAINER;
    dcsSecondary: Result := MD3_SECONDARY_CONTAINER;
    dcsError:     Result := MD3_ERROR_CONTAINER;
    dcsWarning:   Result := MD3_WARNING_CONTAINER;
    dcsInfo:      Result := MD3_INFO_CONTAINER;
    dcsSuccess:   Result := MD3_SUCCESS_CONTAINER;
  else
    Result := MD3_PRIMARY_CONTAINER;
  end;
end;

function GetColorSchemeLight(AScheme: TDemoColorScheme): TAlphaColor;
begin
  case AScheme of
    dcsPrimary:   Result := MD3_PRIMARY_LIGHT;
    dcsSecondary: Result := $FFBA68C8;
    dcsError:     Result := $FFEF5350;
    dcsWarning:   Result := $FFFF9800;
    dcsInfo:      Result := $FF03A9F4;
    dcsSuccess:   Result := $FF4CAF50;
  else
    Result := MD3_PRIMARY_LIGHT;
  end;
end;

function GetColorSchemeDark(AScheme: TDemoColorScheme): TAlphaColor;
begin
  case AScheme of
    dcsPrimary:   Result := MD3_PRIMARY_DARK;
    dcsSecondary: Result := $FF7B1FA2;
    dcsError:     Result := $FFC62828;
    dcsWarning:   Result := $FFE65100;
    dcsInfo:      Result := $FF01579B;
    dcsSuccess:   Result := $FF1B5E20;
  else
    Result := MD3_PRIMARY_DARK;
  end;
end;

function GetMUIColorScheme(AScheme: TDemoColorScheme): TDSkMUIColorScheme;
begin
  case AScheme of
    dcsPrimary:   Result := muiPrimary;
    dcsSecondary: Result := muiSecondary;
    dcsError:     Result := muiError;
    dcsWarning:   Result := muiWarning;
    dcsInfo:      Result := muiInfo;
    dcsSuccess:   Result := muiSuccess;
  else
    Result := muiPrimary;
  end;
end;

function CreateCardStyle(AElevated: Boolean): TDemoCardStyle;
begin
  Result.BackgroundColor := MD3_SURFACE_CONTAINER;
  Result.BorderColor := MD3_OUTLINE;
  Result.CornerRadius := MD3_CORNER_RADIUS_MEDIUM;
  Result.ShadowEnabled := AElevated;
  if AElevated then
    Result.BorderWidth := 0
  else
    Result.BorderWidth := 1;
end;

function CreateFilledCardStyle: TDemoCardStyle;
begin
  Result.BackgroundColor := MD3_SURFACE_CONTAINER_LOW;
  Result.BorderColor := MD3_OUTLINE;
  Result.BorderWidth := 0;
  Result.CornerRadius := MD3_CORNER_RADIUS_MEDIUM;
  Result.ShadowEnabled := False;
end;

function CreateOutlinedCardStyle: TDemoCardStyle;
begin
  Result.BackgroundColor := MD3_SURFACE_CONTAINER;
  Result.BorderColor := MD3_OUTLINE;
  Result.BorderWidth := 1;
  Result.CornerRadius := MD3_CORNER_RADIUS_MEDIUM;
  Result.ShadowEnabled := False;
end;

function ColorToHex(AColor: TAlphaColor): string;
begin
  Result := Format('%.8X', [AColor]);
end;

function HexToColor(const AHex: string; ADefault: TAlphaColor): TAlphaColor;
var
  LHex: string;
  LCode: Integer;
begin
  LHex := StringReplace(AHex, ' ', '', [rfReplaceAll]);
  LHex := StringReplace(LHex, '#', '', [rfReplaceAll]);
  LHex := StringReplace(LHex, '$', '', [rfReplaceAll]);
  if Length(LHex) = 6 then
    LHex := 'FF' + LHex;
  if Length(LHex) = 8 then
  begin
    Val('$' + LHex, Result, LCode);
    if LCode <> 0 then
      Result := ADefault;
  end
  else
    Result := ADefault;
end;

function ControlHasParentNamed(AControl: TControl; const AParentName: string): Boolean;
var
  LControl: TControl;
begin
  Result := False;
  LControl := AControl;
  while LControl <> nil do
  begin
    if SameText(LControl.Name, AParentName) then
      Exit(True);
    LControl := LControl.Parent;
  end;
end;

procedure ApplyDemoLabelStyle(ALabel: TDSkLabel; ATitle: Boolean);
begin
  if ALabel = nil then
    Exit;

  ALabel.BackgroundColor := TAlphaColors.Null;
  ALabel.BorderColor := TAlphaColors.Null;
  ALabel.BorderWidth := 0;
  ALabel.ColorScheme := muiSchemeNone;
  ALabel.Font.Name := GetDefaultFontName;
  ALabel.Font.Color := clWindowText;
  ALabel.TextAlign := ltaLeft;
  ALabel.VerticalAlign := lvaCenter;

  if ATitle then
  begin
    ALabel.Font.Style := [fsBold];
    if ALabel.Font.Size < 11 then
      ALabel.Font.Size := 11;
    ALabel.FontColor := $FF0F172A;
  end
  else
  begin
    if ALabel.Font.Size < 9 then
      ALabel.Font.Size := 9;
    if ALabel.Font.Style = [fsBold] then
      ALabel.FontColor := $FF334155
    else
      ALabel.FontColor := $FF64748B;
  end;
end;

procedure StyleDemoPanel(APanel: TDSkPanel; const AFrameName: string);
begin
  if APanel = nil then
    Exit;

  APanel.CaptionFont.Name := GetDefaultFontName;
  APanel.CaptionFont.Color := clWindowText;
  APanel.BackgroundHover := APanel.BackgroundColor;

  if SameText(APanel.Name, 'pnlHeader') then
  begin
    APanel.Align := alTop;
    APanel.Height := 56;
    APanel.CaptionPosition := cpLeftCenter;
    APanel.CaptionFont.Size := 16;
    APanel.CaptionFont.Style := [fsBold];
    APanel.CaptionFont.Color := clWindowText;
    APanel.CaptionMargin := 24;
    APanel.ChildPadding := 0;
    APanel.PanelStyle := psStyleNone;
    APanel.CornerRadius := 0;
    APanel.BackgroundColor := $FFFFFFFF;
    APanel.BackgroundHover := $FFFFFFFF;
    APanel.BorderColor := $00FFFFFF;
    APanel.BorderWidth := 0;
  end
  else if SameText(APanel.Name, 'pnlControl') then
  begin
    APanel.Align := alLeft;
    APanel.Width := 292;
    APanel.Caption := '';
    APanel.CaptionPosition := cpTopLeft;
    APanel.ChildPadding := 18;
    APanel.PanelStyle := psStyleNone;
    APanel.CornerRadius := 18;
    APanel.BackgroundColor := $FFF7FAFF;
    APanel.BackgroundHover := $FFF7FAFF;
    APanel.BorderColor := $FFE2E8F0;
    APanel.BorderWidth := 1;
  end
  else if SameText(APanel.Name, 'pnlPreview') then
  begin
    APanel.Align := alClient;
    APanel.Caption := '';
    APanel.CaptionPosition := cpTopLeft;
    APanel.ChildPadding := 24;
    APanel.PanelStyle := psStyleNone;
    APanel.CornerRadius := 18;
    APanel.BackgroundColor := $FFFFFFFF;
    APanel.BackgroundHover := $FFFFFFFF;
    APanel.BorderColor := $FFE4E9F1;
    APanel.BorderWidth := 1;
  end
  else if Pos('card', LowerCase(APanel.Name)) = 1 then
  begin
    APanel.PanelStyle := psStyleNone;
    APanel.CornerRadius := 18;
    if APanel.BackgroundColor = TAlphaColors.Null then
      APanel.BackgroundColor := $FFFFFFFF;
    APanel.BackgroundHover := APanel.BackgroundColor;
    APanel.BorderColor := $FFE2E8F0;
    APanel.BorderWidth := 1;
  end;
end;

procedure StyleDemoControl(AControl: TControl; const AFrameName: string);
var
  LLabel: TDSkLabel;
  LRadioGroup: TDSkRadioGroup;
begin
  if AControl is TDSkPanel then
    StyleDemoPanel(TDSkPanel(AControl), AFrameName)
  else if AControl is TDSkLabel then
  begin
    LLabel := TDSkLabel(AControl);
    if not ControlHasParentNamed(LLabel, 'FrameLabelDemo') then
      ApplyDemoLabelStyle(LLabel,
        SameText(LLabel.Name, 'lblPreviewTitle') or
        SameText(LLabel.Name, 'lblControlTitle') or
        SameText(LLabel.Name, 'lblOptions') or
        SameText(LLabel.Name, 'lblInfo'));
  end
  else if AControl is TDSkRadioGroup then
  begin
    LRadioGroup := TDSkRadioGroup(AControl);
    LRadioGroup.BackgroundColor := TAlphaColors.Null;
    LRadioGroup.BorderColor := TAlphaColors.Null;
    LRadioGroup.BorderWidth := 0;

    LRadioGroup.CaptionFont.Name := GetDefaultFontName;
    LRadioGroup.CaptionFont.Size := 10;
    LRadioGroup.CaptionFont.Style := [fsBold];
    LRadioGroup.CaptionFont.Color := $00554133; // #334155，分组标题使用更稳的蓝灰色。

    LRadioGroup.ItemFont.Name := GetDefaultFontName;
    LRadioGroup.ItemFont.Size := 10;
    LRadioGroup.ItemFont.Style := [];
    LRadioGroup.ItemFont.Color := $003B291E; // #1E293B，选项文字保持高对比度。
  end
  else if AControl is TDSkCheckboxGroup then
  begin
    TDSkCheckboxGroup(AControl).BackgroundColor := TAlphaColors.Null;
    TDSkCheckboxGroup(AControl).BorderColor := TAlphaColors.Null;
    TDSkCheckboxGroup(AControl).BorderWidth := 0;
  end
  else if AControl is TDSkSwitchGroup then
  begin
    TDSkSwitchGroup(AControl).BackgroundColor := TAlphaColors.Null;
    TDSkSwitchGroup(AControl).BorderColor := TAlphaColors.Null;
    TDSkSwitchGroup(AControl).BorderWidth := 0;
  end;
end;

procedure ApplyAdminFrameStyle(AFrame: TWinControl);
var
  i: Integer;
begin
  if AFrame = nil then
    Exit;

  if AFrame is TFrame then
  begin
    TFrame(AFrame).Color := $00F7F9FC;
    TFrame(AFrame).ParentColor := False;
    TFrame(AFrame).Font.Name := GetDefaultFontName;
    TFrame(AFrame).Font.Color := clWindowText;
  end;

  for i := 0 to AFrame.ControlCount - 1 do
  begin
    StyleDemoControl(AFrame.Controls[i], AFrame.Name);
    if AFrame.Controls[i] is TWinControl then
      ApplyAdminFrameStyle(TWinControl(AFrame.Controls[i]));
  end;
end;

end.
