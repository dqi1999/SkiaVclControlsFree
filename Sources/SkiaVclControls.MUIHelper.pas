unit SkiaVclControls.MUIHelper;

interface

uses
  System.UITypes, SkiaVclControls.Types, SkiaVclControls.Button;

type
  TDSkMUIColorConfig = record
    ButtonColor: TAlphaColor;
    ButtonHover: TAlphaColor;
    ButtonPressed: TAlphaColor;
    BorderColor: TAlphaColor;
    FontColor: TAlphaColor;
  end;

function GetMUIColorConfig(ColorScheme: TDSkMUIColorScheme; Style: TDSkMUIStyle): TDSkMUIColorConfig;
function GetMUIColor(ColorScheme: TDSkMUIColorScheme): TAlphaColor;
procedure ApplyMUITheme(Button: TDSkButton; ColorScheme: TDSkMUIColorScheme; Style: TDSkMUIStyle = muiContained);

implementation

const
  // Material-UI 颜色常量 (ARGB 格式)
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
  MUI_CONTRAST         = $FFFFFFFF;

function GetMUIColorConfig(ColorScheme: TDSkMUIColorScheme; Style: TDSkMUIStyle): TDSkMUIColorConfig;
begin
  case ColorScheme of
    muiPrimary: begin
      Result.ButtonColor := MUI_PRIMARY_MAIN;
      Result.ButtonHover := MUI_PRIMARY_LIGHT;
      Result.ButtonPressed := MUI_PRIMARY_DARK;
      Result.BorderColor := MUI_PRIMARY_MAIN;
      Result.FontColor := MUI_CONTRAST;
    end;
    muiSecondary: begin
      Result.ButtonColor := MUI_SECONDARY_MAIN;
      Result.ButtonHover := MUI_SECONDARY_LIGHT;
      Result.ButtonPressed := MUI_SECONDARY_DARK;
      Result.BorderColor := MUI_SECONDARY_MAIN;
      Result.FontColor := MUI_CONTRAST;
    end;
    muiError: begin
      Result.ButtonColor := MUI_ERROR_MAIN;
      Result.ButtonHover := MUI_ERROR_LIGHT;
      Result.ButtonPressed := MUI_ERROR_DARK;
      Result.BorderColor := MUI_ERROR_MAIN;
      Result.FontColor := MUI_CONTRAST;
    end;
    muiWarning: begin
      Result.ButtonColor := MUI_WARNING_MAIN;
      Result.ButtonHover := MUI_WARNING_LIGHT;
      Result.ButtonPressed := MUI_WARNING_DARK;
      Result.BorderColor := MUI_WARNING_MAIN;
      Result.FontColor := MUI_CONTRAST;
    end;
    muiInfo: begin
      Result.ButtonColor := MUI_INFO_MAIN;
      Result.ButtonHover := MUI_INFO_LIGHT;
      Result.ButtonPressed := MUI_INFO_DARK;
      Result.BorderColor := MUI_INFO_MAIN;
      Result.FontColor := MUI_CONTRAST;
    end;
    muiSuccess: begin
      Result.ButtonColor := MUI_SUCCESS_MAIN;
      Result.ButtonHover := MUI_SUCCESS_LIGHT;
      Result.ButtonPressed := MUI_SUCCESS_DARK;
      Result.BorderColor := MUI_SUCCESS_MAIN;
      Result.FontColor := MUI_CONTRAST;
    end;
  else
    // muiSchemeNone: 返回 Primary 作为安全默认值
    Result.ButtonColor := MUI_PRIMARY_MAIN;
    Result.ButtonHover := MUI_PRIMARY_LIGHT;
    Result.ButtonPressed := MUI_PRIMARY_DARK;
    Result.BorderColor := MUI_PRIMARY_MAIN;
    Result.FontColor := MUI_CONTRAST;
  end;

  case Style of
    muiOutlined: begin
      Result.ButtonColor := $FFF5F5F5;
      Result.ButtonHover := Result.BorderColor;
      Result.FontColor := Result.BorderColor;
    end;
    muiText: begin
      Result.ButtonColor := $00000000;
      Result.ButtonHover := Result.BorderColor;
      Result.FontColor := Result.BorderColor;
      Result.BorderColor := $00000000;
    end;
    // muiContained 和 muiStyleNone: 不额外调整，保持颜色方案的值
  end;
end;

function GetMUIColor(ColorScheme: TDSkMUIColorScheme): TAlphaColor;
begin
  case ColorScheme of
    muiPrimary: Result := MUI_PRIMARY_MAIN;
    muiSecondary: Result := MUI_SECONDARY_MAIN;
    muiError: Result := MUI_ERROR_MAIN;
    muiWarning: Result := MUI_WARNING_MAIN;
    muiInfo: Result := MUI_INFO_MAIN;
    muiSuccess: Result := MUI_SUCCESS_MAIN;
  else
    Result := MUI_PRIMARY_MAIN;
  end;
end;

procedure ApplyMUITheme(Button: TDSkButton; ColorScheme: TDSkMUIColorScheme; Style: TDSkMUIStyle);
var
  Config: TDSkMUIColorConfig;
begin
  Config := GetMUIColorConfig(ColorScheme, Style);
  Button.ButtonColor := Config.ButtonColor;
  Button.ButtonHover := Config.ButtonHover;
  Button.ButtonPressed := Config.ButtonPressed;
  Button.BorderColor := Config.BorderColor;
  Button.FontColor := Config.FontColor;
  case Style of
    muiContained: Button.BorderWidth := 0;
    muiOutlined: Button.BorderWidth := 2;
    muiText: Button.BorderWidth := 0;
  end;
end;

end.
