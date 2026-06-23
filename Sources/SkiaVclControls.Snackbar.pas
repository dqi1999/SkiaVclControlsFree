unit SkiaVclControls.Snackbar;

interface

uses
  System.Classes, System.Types, System.UITypes, System.Math,
  System.Generics.Collections,
  Vcl.Controls, Vcl.Graphics, Vcl.ExtCtrls,
  Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  { 操作按钮点击事件，AllowClose=False 可阻止自动关闭 }
  TDSkSnackbarActionEvent = procedure(Sender: TObject; var AllowClose: Boolean) of object;

  { TDSkSnackbar - MUI 风格的消息条组件
    从屏幕底部滑入的简短消息，支持自动隐藏、操作按钮和堆叠显示 }
  TDSkSnackbar = class(TDSCustomSkControl)
  private
    FMessage: string;
    FSeverity: TDSkSnackbarSeverity;
    FVariant: TDSkSnackbarVariant;
    FPosition: TDSkSnackbarPosition;
    FAutoHideDuration: Integer;
    FActionText: string;
    FShowCloseButton: Boolean;
    FIsOpen: Boolean;
    FFont: TFont;
    FActionFont: TFont;
    FOnAction: TDSkSnackbarActionEvent;
    FOnClose: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FAnimTimer: TTimer;
    FAutoHideTimer: TTimer;
    FAnimProgress: Single;
    FAnimDirection: Integer;
    FMessageCacheFont: ISkFont;
    FMessageCacheTypeface: ISkTypeface;
    FActionCacheFont: ISkFont;
    FActionCacheTypeface: ISkTypeface;
    FLoading: Boolean;
    procedure SetMessage(const Value: string);
    procedure SetSeverity(const Value: TDSkSnackbarSeverity);
    procedure SetVariant(const Value: TDSkSnackbarVariant);
    procedure SetPosition(const Value: TDSkSnackbarPosition);
    procedure SetAutoHideDuration(const Value: Integer);
    procedure SetActionText(const Value: string);
    procedure SetShowCloseButton(const Value: Boolean);
    procedure SetFont(const Value: TFont);
    procedure SetActionFont(const Value: TFont);
    procedure FontChanged(Sender: TObject);
    procedure InvalidateMessageCache;
    procedure InvalidateActionCache;
    function GetMessageFontCache: ISkFont;
    function GetActionFontCache: ISkFont;
    function MeasureMessageText: Single;
    function MeasureActionText: Single;
    procedure DoAnimTimer(Sender: TObject);
    procedure DoAutoHideTimer(Sender: TObject);
    procedure UpdatePosition;
    function GetSeverityColor: TAlphaColor;
    function GetSeverityLightColor: TAlphaColor;
    function GetSeverityDarkColor: TAlphaColor;
    procedure RequestRedraw;
    function GetAvailableTextWidth: Single;
    procedure WrapTextToLines(const AText: string; AFont: ISkFont; AMaxWidth: Single; ALines: TStrings);
    procedure UpdateHeight;
  protected
    procedure PaintDesignTime(ACanvas: TCanvas); override;
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawBackground(const ACanvas: ISkCanvas; const ADest: TRectF; AOpacity: Single); override;
    procedure DrawMessage(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawActionButton(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawCloseButton(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawSeverityIcon(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    function ShouldClipWindowRegion: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Show;
    procedure Hide;
    procedure Open;
    procedure Close;
    class procedure ShowSnackbar(AOwner: TComponent; const AMessage: string;
      ASeverity: TDSkSnackbarSeverity = snkNone;
      APosition: TDSkSnackbarPosition = spBottomCenter;
      AAutoHideDuration: Integer = 4000;
      const AActionText: string = '');
  published
    property Message: string read FMessage write SetMessage;
    property Severity: TDSkSnackbarSeverity read FSeverity write SetSeverity default snkNone;
    property Variant: TDSkSnackbarVariant read FVariant write SetVariant default snvStandard;
    property Position: TDSkSnackbarPosition read FPosition write SetPosition default spBottomCenter;
    property AutoHideDuration: Integer read FAutoHideDuration write SetAutoHideDuration default 4000;
    property ActionText: string read FActionText write SetActionText;
    property ShowCloseButton: Boolean read FShowCloseButton write SetShowCloseButton default False;
    property Font: TFont read FFont write SetFont;
    property ActionFont: TFont read FActionFont write SetActionFont;
    property OnAction: TDSkSnackbarActionEvent read FOnAction write FOnAction;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
  end;

implementation

uses
  System.SysUtils, Vcl.Forms;

var
  SnackbarList: TList<TDSkSnackbar>;

const
  SNACKBAR_HEIGHT = 48;
  SNACKBAR_MARGIN = 16;
  SNACKBAR_SPACING = 8;
  SNACKBAR_PADDING = 16;
  SNACKBAR_PADDING_LEFT = 16;
  SNACKBAR_ACTION_MARGIN = 8;
  SNACKBAR_CLOSE_SIZE = 24;
  SNACKBAR_CORNER_RADIUS = 8;
  SNACKBAR_ANIM_STEP = 0.08;
  SNACKBAR_ICON_SIZE = 24;
  SNACKBAR_ICON_TEXT_SPACING = 12;
  SNACKBAR_MAX_WIDTH = 560;
  SNACKBAR_MIN_WIDTH = 300;
  SNACKBAR_MAX_LINES = 2;

  MUI_SUCCESS_MAIN = $FF43A047;
  MUI_SUCCESS_LIGHT = $FF66BB6A;
  MUI_SUCCESS_DARK = $FF2E7D32;
  MUI_ERROR_MAIN = $FFD32F2F;
  MUI_ERROR_LIGHT = $FFEF5350;
  MUI_ERROR_DARK = $FFC62828;
  MUI_WARNING_MAIN = $FFFF9800;
  MUI_WARNING_LIGHT = $FFFFB74D;
  MUI_WARNING_DARK = $FFF57C00;
  MUI_INFO_MAIN = $FF2196F3;
  MUI_INFO_LIGHT = $FF64B5F6;
  MUI_INFO_DARK = $FF1565C0;
  MUI_NONE_MAIN = $FF323232;
  MUI_NONE_LIGHT = $FF616161;
  MUI_NONE_DARK = $FF212121;

{ TDSkSnackbar }

constructor TDSkSnackbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMessage := 'Snackbar Message';
  FSeverity := snkNone;
  FVariant := snvStandard;
  FPosition := spBottomCenter;
  FAutoHideDuration := 4000;
  FActionText := '';
  FShowCloseButton := False;
  FIsOpen := False;
  FAnimProgress := 0;
  FAnimDirection := 0;
  FLoading := True;

  Width := 300;
  Height := SNACKBAR_HEIGHT;
  Visible := False;

  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
  FFont.Name := GetDefaultFontName;
  FFont.Size := 12;
  FFont.Color := clWhite;

  FActionFont := TFont.Create;
  FActionFont.OnChange := FontChanged;
  FActionFont.Name := GetDefaultFontName;
  FActionFont.Size := 12;
  FActionFont.Color := clWhite;
  FActionFont.Style := [fsBold];

  FAnimTimer := TTimer.Create(Self);
  FAnimTimer.Interval := 16;
  FAnimTimer.Enabled := False;
  FAnimTimer.OnTimer := DoAnimTimer;

  FAutoHideTimer := TTimer.Create(Self);
  FAutoHideTimer.Interval := FAutoHideDuration;
  FAutoHideTimer.Enabled := False;
  FAutoHideTimer.OnTimer := DoAutoHideTimer;

  InvalidateMessageCache;
  InvalidateActionCache;

  if SnackbarList = nil then
    SnackbarList := TList<TDSkSnackbar>.Create;
  SnackbarList.Add(Self);
end;

destructor TDSkSnackbar.Destroy;
begin
  if SnackbarList <> nil then
    SnackbarList.Remove(Self);

  FAnimTimer.Free;
  FAutoHideTimer.Free;
  FFont.Free;
  FActionFont.Free;
  inherited;
end;

procedure TDSkSnackbar.CreateWnd;
begin
  inherited;
  FLoading := False;
end;

procedure TDSkSnackbar.DestroyWnd;
begin
  FAnimTimer.Enabled := False;
  FAutoHideTimer.Enabled := False;
  inherited;
end;

function TDSkSnackbar.ShouldClipWindowRegion: Boolean;
begin
  Result := False;
end;

procedure TDSkSnackbar.SetMessage(const Value: string);
begin
  if FMessage <> Value then
  begin
    FMessage := Value;
    InvalidateMessageCache;
    UpdateHeight;
    RequestRedraw;
  end;
end;

procedure TDSkSnackbar.SetSeverity(const Value: TDSkSnackbarSeverity);
begin
  if FSeverity <> Value then
  begin
    FSeverity := Value;
    RequestRedraw;
  end;
end;

procedure TDSkSnackbar.SetVariant(const Value: TDSkSnackbarVariant);
begin
  if FVariant <> Value then
  begin
    FVariant := Value;
    RequestRedraw;
  end;
end;

procedure TDSkSnackbar.SetPosition(const Value: TDSkSnackbarPosition);
begin
  if FPosition <> Value then
  begin
    FPosition := Value;
    if FIsOpen then
      UpdatePosition;
  end;
end;

procedure TDSkSnackbar.SetAutoHideDuration(const Value: Integer);
begin
  if FAutoHideDuration <> Value then
  begin
    FAutoHideDuration := Value;
    FAutoHideTimer.Interval := Value;
  end;
end;

procedure TDSkSnackbar.SetActionText(const Value: string);
begin
  if FActionText <> Value then
  begin
    FActionText := Value;
    InvalidateActionCache;
    RequestRedraw;
  end;
end;

procedure TDSkSnackbar.SetShowCloseButton(const Value: Boolean);
begin
  if FShowCloseButton <> Value then
  begin
    FShowCloseButton := Value;
    RequestRedraw;
  end;
end;

procedure TDSkSnackbar.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  InvalidateMessageCache;
  RequestRedraw;
end;

procedure TDSkSnackbar.SetActionFont(const Value: TFont);
begin
  FActionFont.Assign(Value);
  InvalidateActionCache;
  RequestRedraw;
end;

procedure TDSkSnackbar.FontChanged(Sender: TObject);
begin
  InvalidateMessageCache;
  InvalidateActionCache;
  RequestRedraw;
end;

procedure TDSkSnackbar.RequestRedraw;
begin
  if not FLoading then
    Redraw;
end;

procedure TDSkSnackbar.InvalidateMessageCache;
begin
  FMessageCacheFont := nil;
  FMessageCacheTypeface := nil;
end;

procedure TDSkSnackbar.InvalidateActionCache;
begin
  FActionCacheFont := nil;
  FActionCacheTypeface := nil;
end;

function TDSkSnackbar.GetAvailableTextWidth: Single;
begin
  // 可用文本宽度 = 总宽度 - 左侧padding - 右侧padding - 操作按钮 - 关闭按钮
  Result := Width - SNACKBAR_PADDING_LEFT * 2;
  // 减去图标空间
  if FSeverity in [snkSuccess, snkError, snkWarning, snkInfo] then
    Result := Result - SNACKBAR_ICON_SIZE - SNACKBAR_ICON_TEXT_SPACING;
  // 减去操作按钮空间
  if FActionText <> '' then
    Result := Result - MeasureActionText - SNACKBAR_ACTION_MARGIN;
  // 减去关闭按钮空间
  if FShowCloseButton then
    Result := Result - SNACKBAR_CLOSE_SIZE - SNACKBAR_ACTION_MARGIN;
  // 确保最小宽度
  if Result < 50 then
    Result := 50;
end;

procedure TDSkSnackbar.WrapTextToLines(const AText: string; AFont: ISkFont; AMaxWidth: Single; ALines: TStrings);
var
  LWords: TArray<string>;
  LLine: string;
  LWord: string;
  LTestLine: string;
  LWidth: Single;
  i: Integer;
begin
  ALines.Clear;
  if AText = '' then Exit;

  // 按空格分词
  LWords := AText.Split([' ']);

  LLine := '';
  for i := 0 to High(LWords) do
  begin
    LWord := LWords[i];
    if LLine = '' then
      LTestLine := LWord
    else
      LTestLine := LLine + ' ' + LWord;

    // 测量当前行宽度
    LWidth := AFont.MeasureText(LTestLine);

    if LWidth <= AMaxWidth then
    begin
      // 当前行可以容纳这个词
      LLine := LTestLine;
    end
    else
    begin
      // 当前行已满，保存当前行，开始新行
      if LLine <> '' then
      begin
        ALines.Add(LLine);
        // 检查是否超过最大行数
        if ALines.Count >= SNACKBAR_MAX_LINES then
        begin
          // 最后一行添加省略号
          if i <= High(LWords) then
          begin
            LLine := ALines[ALines.Count - 1];
            // 截断最后一行并添加省略号
            while (Length(LLine) > 0) do
            begin
              LWidth := AFont.MeasureText(LLine + '...');
              if LWidth <= AMaxWidth then
              begin
                ALines[ALines.Count - 1] := LLine + '...';
                Break;
              end;
              Delete(LLine, Length(LLine), 1);
            end;
            if LLine = '' then
              ALines[ALines.Count - 1] := '...';
          end;
          Exit;
        end;
      end;
      LLine := LWord;
    end;
  end;

  // 添加最后一行
  if LLine <> '' then
  begin
    if ALines.Count >= SNACKBAR_MAX_LINES then
    begin
      // 截断最后一行并添加省略号
      LLine := ALines[ALines.Count - 1];
      LWidth := AFont.MeasureText(LLine + '...');
      while (Length(LLine) > 0) and (LWidth > AMaxWidth) do
      begin
        Delete(LLine, Length(LLine), 1);
        LWidth := AFont.MeasureText(LLine + '...');
      end;
      ALines[ALines.Count - 1] := LLine + '...';
    end
    else
      ALines.Add(LLine);
  end;
end;

procedure TDSkSnackbar.UpdateHeight;
var
  LFont: ISkFont;
  LLines: TStringList;
  LMaxWidth: Single;
  LLineHeight: Single;
  LNewHeight: Integer;
begin
  LFont := GetMessageFontCache;
  LMaxWidth := GetAvailableTextWidth;

  // 计算行高
  LLineHeight := LFont.Size * 1.4; // 1.4倍行高

  LLines := TStringList.Create;
  try
    WrapTextToLines(FMessage, LFont, LMaxWidth, LLines);

    // 计算所需高度：行数 * 行高 + 上下padding
    if LLines.Count <= 1 then
      LNewHeight := SNACKBAR_HEIGHT
    else
      LNewHeight := Round(SNACKBAR_PADDING + LLines.Count * LLineHeight + SNACKBAR_PADDING);

    // 确保最小高度
    if LNewHeight < SNACKBAR_HEIGHT then
      LNewHeight := SNACKBAR_HEIGHT;

    // 更新高度
    if Height <> LNewHeight then
      Height := LNewHeight;
  finally
    LLines.Free;
  end;
end;

function TDSkSnackbar.GetMessageFontCache: ISkFont;
var
  LTypeface: ISkTypeface;
begin
  LTypeface := TSkTypeface.MakeFromName(FFont.Name, TSkFontStyle.Normal);
  if (FMessageCacheFont = nil) or (FMessageCacheTypeface <> LTypeface) or
     (FMessageCacheFont.Size <> FFont.Size) then
  begin
    FMessageCacheTypeface := LTypeface;
    FMessageCacheFont := TSkFont.Create(LTypeface, FFont.Size);
  end;
  Result := FMessageCacheFont;
end;

function TDSkSnackbar.GetActionFontCache: ISkFont;
var
  LTypeface: ISkTypeface;
begin
  LTypeface := TSkTypeface.MakeFromName(FActionFont.Name, TSkFontStyle.Bold);
  if (FActionCacheFont = nil) or (FActionCacheTypeface <> LTypeface) or
     (FActionCacheFont.Size <> FActionFont.Size) then
  begin
    FActionCacheTypeface := LTypeface;
    FActionCacheFont := TSkFont.Create(LTypeface, FActionFont.Size);
  end;
  Result := FActionCacheFont;
end;

function TDSkSnackbar.MeasureMessageText: Single;
var
  LFont: ISkFont;
  LBounds: TRectF;
begin
  LFont := GetMessageFontCache;
  LFont.MeasureText(FMessage, LBounds);
  Result := LBounds.Width;
end;

function TDSkSnackbar.MeasureActionText: Single;
var
  LFont: ISkFont;
  LBounds: TRectF;
begin
  if FActionText = '' then
    Result := 0
  else
  begin
    LFont := GetActionFontCache;
    LFont.MeasureText(FActionText, LBounds);
    Result := LBounds.Width;
  end;
end;

function TDSkSnackbar.GetSeverityColor: TAlphaColor;
begin
  case FSeverity of
    snkSuccess: Result := MUI_SUCCESS_MAIN;
    snkError: Result := MUI_ERROR_MAIN;
    snkWarning: Result := MUI_WARNING_MAIN;
    snkInfo: Result := MUI_INFO_MAIN;
  else
    Result := MUI_NONE_MAIN;
  end;
end;

function TDSkSnackbar.GetSeverityLightColor: TAlphaColor;
begin
  case FSeverity of
    snkSuccess: Result := MUI_SUCCESS_LIGHT;
    snkError: Result := MUI_ERROR_LIGHT;
    snkWarning: Result := MUI_WARNING_LIGHT;
    snkInfo: Result := MUI_INFO_LIGHT;
  else
    Result := MUI_NONE_LIGHT;
  end;
end;

function TDSkSnackbar.GetSeverityDarkColor: TAlphaColor;
begin
  case FSeverity of
    snkSuccess: Result := MUI_SUCCESS_DARK;
    snkError: Result := MUI_ERROR_DARK;
    snkWarning: Result := MUI_WARNING_DARK;
    snkInfo: Result := MUI_INFO_DARK;
  else
    Result := MUI_NONE_DARK;
  end;
end;

procedure TDSkSnackbar.UpdatePosition;
var
  LScreenWidth, LScreenHeight: Integer;
  LX, LY: Integer;
  LIndex: Integer;
  LOffset: Integer;
begin
  LX := 0;
  LY := 0;

  if Parent <> nil then
  begin
    LScreenWidth := Parent.ClientWidth;
    LScreenHeight := Parent.ClientHeight;
  end
  else
  begin
    LScreenWidth := Screen.Width;
    LScreenHeight := Screen.Height;
  end;

  LOffset := 0;
  if SnackbarList <> nil then
  begin
    LIndex := SnackbarList.IndexOf(Self);
    if LIndex >= 0 then
    begin
      case FPosition of
        spTopLeft, spTopCenter, spTopRight:
          LOffset := LIndex * (Height + SNACKBAR_SPACING);
        spBottomLeft, spBottomCenter, spBottomRight:
          LOffset := (SnackbarList.Count - 1 - LIndex) * (Height + SNACKBAR_SPACING);
      end;
    end;
  end;

  case FPosition of
    spTopLeft:
      begin
        LX := SNACKBAR_MARGIN;
        LY := SNACKBAR_MARGIN + LOffset;
      end;
    spTopCenter:
      begin
        LX := (LScreenWidth - Width) div 2;
        LY := SNACKBAR_MARGIN + LOffset;
      end;
    spTopRight:
      begin
        LX := LScreenWidth - Width - SNACKBAR_MARGIN;
        LY := SNACKBAR_MARGIN + LOffset;
      end;
    spBottomLeft:
      begin
        LX := SNACKBAR_MARGIN;
        LY := LScreenHeight - Height - SNACKBAR_MARGIN - LOffset;
      end;
    spBottomCenter:
      begin
        LX := (LScreenWidth - Width) div 2;
        LY := LScreenHeight - Height - SNACKBAR_MARGIN - LOffset;
      end;
    spBottomRight:
      begin
        LX := LScreenWidth - Width - SNACKBAR_MARGIN;
        LY := LScreenHeight - Height - SNACKBAR_MARGIN - LOffset;
      end;
  end;

  SetBounds(LX, LY, Width, Height);
end;

procedure TDSkSnackbar.Show;
begin
  if not FIsOpen then
  begin
    FIsOpen := True;
    FAnimDirection := 1;
    FAnimProgress := 0;
    FAnimTimer.Enabled := True;
    Visible := True;
    UpdateHeight;  // 根据文本内容调整高度
    UpdatePosition;

    if FAutoHideDuration > 0 then
    begin
      FAutoHideTimer.Interval := FAutoHideDuration;
      FAutoHideTimer.Enabled := True;
    end;

    if Assigned(FOnShow) then
      FOnShow(Self);
  end;
end;

procedure TDSkSnackbar.Hide;
begin
  if FIsOpen then
  begin
    FIsOpen := False;
    FAnimDirection := -1;
    FAnimTimer.Enabled := True;
    FAutoHideTimer.Enabled := False;
  end;
end;

procedure TDSkSnackbar.Open;
begin
  Show;
end;

procedure TDSkSnackbar.Close;
begin
  Hide;
end;

procedure TDSkSnackbar.DoAnimTimer(Sender: TObject);
begin
  if FAnimDirection > 0 then
  begin
    FAnimProgress := FAnimProgress + SNACKBAR_ANIM_STEP;
    if FAnimProgress >= 1 then
    begin
      FAnimProgress := 1;
      FAnimTimer.Enabled := False;
    end;
  end
  else
  begin
    FAnimProgress := FAnimProgress - SNACKBAR_ANIM_STEP;
    if FAnimProgress <= 0 then
    begin
      FAnimProgress := 0;
      FAnimTimer.Enabled := False;
      Visible := False;
      if Assigned(FOnClose) then
        FOnClose(Self);
    end;
  end;

  Opacity := Round(FAnimProgress * 255);
  Redraw;
end;

procedure TDSkSnackbar.DoAutoHideTimer(Sender: TObject);
begin
  FAutoHideTimer.Enabled := False;
  Hide;
end;

procedure TDSkSnackbar.PaintDesignTime(ACanvas: TCanvas);
var
  LRect: TRect;
begin
  LRect := ClientRect;
  ACanvas.Brush.Color := clGray;
  ACanvas.FillRect(LRect);
  ACanvas.Font.Color := clWhite;
  ACanvas.Font.Size := 12;
  ACanvas.TextOut(10, 10, 'Snackbar: ' + FMessage);
end;

procedure TDSkSnackbar.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
begin
  inherited;
  // 先绘制背景
  DrawBackground(ACanvas, ADest, AOpacity);
  // 绘制图标
  if FSeverity in [snkSuccess, snkError, snkWarning, snkInfo] then
    DrawSeverityIcon(ACanvas, ADest);
  // 绘制消息
  DrawMessage(ACanvas, ADest);

  if FActionText <> '' then
    DrawActionButton(ACanvas, ADest);

  if FShowCloseButton then
    DrawCloseButton(ACanvas, ADest);
end;

procedure TDSkSnackbar.DrawBackground(const ACanvas: ISkCanvas; const ADest: TRectF; AOpacity: Single);
var
  LPaint: ISkPaint;
  LColor: TAlphaColor;
begin
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;

  case FVariant of
    snvStandard, snvFilled:
      begin
        LColor := GetSeverityColor;
        LPaint.Color := LColor;
        LPaint.Style := TSkPaintStyle.Fill;
      end;
    snvOutlined:
      begin
        LColor := GetSeverityColor;
        LPaint.Color := $FFFFFFFF;
        LPaint.Style := TSkPaintStyle.Fill;
      end;
  end;

  ACanvas.DrawRoundRect(TSkRoundRect.Create(ADest, SNACKBAR_CORNER_RADIUS, SNACKBAR_CORNER_RADIUS), LPaint);

  if FVariant = snvOutlined then
  begin
    LPaint.Style := TSkPaintStyle.Stroke;
    LPaint.StrokeWidth := 1;
    LPaint.Color := LColor;
    ACanvas.DrawRoundRect(TSkRoundRect.Create(ADest, SNACKBAR_CORNER_RADIUS, SNACKBAR_CORNER_RADIUS), LPaint);
  end;
end;

procedure TDSkSnackbar.DrawMessage(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LPaint: ISkPaint;
  LFont: ISkFont;
  LX, LY: Single;
  LLines: TStringList;
  LMaxWidth: Single;
  LLineHeight: Single;
  LTextTop: Single;
  i: Integer;
begin
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;

  case FVariant of
    snvStandard, snvFilled:
      LPaint.Color := TAlphaColors.White;
    snvOutlined:
      LPaint.Color := GetSeverityColor;
  end;

  LFont := GetMessageFontCache;

  // 计算X位置：左侧padding + 图标宽度 + 间距
  LX := ADest.Left + SNACKBAR_PADDING_LEFT;
  if FSeverity in [snkSuccess, snkError, snkWarning, snkInfo] then
    LX := LX + SNACKBAR_ICON_SIZE + SNACKBAR_ICON_TEXT_SPACING;

  // 计算可用文本宽度
  LMaxWidth := GetAvailableTextWidth;

  // 计算行高
  LLineHeight := LFont.Size * 1.4;

  // 使用换行计算
  LLines := TStringList.Create;
  try
    WrapTextToLines(FMessage, LFont, LMaxWidth, LLines);

    if LLines.Count <= 1 then
    begin
      // 单行文本，垂直居中
      LY := ADest.Top + (ADest.Height + LFont.Size) / 2 - 2;
      ACanvas.DrawSimpleText(FMessage, LX, LY, LFont, LPaint);
    end
    else
    begin
      // 多行文本，从顶部开始绘制
      LTextTop := ADest.Top + SNACKBAR_PADDING;
      for i := 0 to LLines.Count - 1 do
      begin
        LY := LTextTop + (i + 1) * LLineHeight;
        ACanvas.DrawSimpleText(LLines[i], LX, LY, LFont, LPaint);
      end;
    end;
  finally
    LLines.Free;
  end;
end;

procedure TDSkSnackbar.DrawActionButton(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LPaint: ISkPaint;
  LFont: ISkFont;
  LX, LY: Single;
  LTextWidth: Single;
  LLines: TStringList;
  LMaxWidth: Single;
  LLineHeight: Single;
begin
  if FActionText = '' then Exit;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;

  case FVariant of
    snvStandard, snvFilled:
      LPaint.Color := TAlphaColors.White;
    snvOutlined:
      LPaint.Color := GetSeverityColor;
  end;

  LFont := GetActionFontCache;
  LTextWidth := MeasureActionText;

  LX := ADest.Right - SNACKBAR_PADDING - LTextWidth;
  if FShowCloseButton then
    LX := LX - SNACKBAR_CLOSE_SIZE - SNACKBAR_ACTION_MARGIN;

  // 检查消息是否多行，决定操作按钮的Y位置
  LMaxWidth := GetAvailableTextWidth;
  LLineHeight := GetMessageFontCache.Size * 1.4;
  LLines := TStringList.Create;
  try
    WrapTextToLines(FMessage, GetMessageFontCache, LMaxWidth, LLines);
    if LLines.Count > 1 then
    begin
      // 多行文本时，操作按钮放在底部
      LY := ADest.Bottom - SNACKBAR_PADDING - 2;
    end
    else
    begin
      // 单行文本时，操作按钮垂直居中
      LY := ADest.Top + (ADest.Height + LFont.Size) / 2 - 2;
    end;
  finally
    LLines.Free;
  end;

  ACanvas.DrawSimpleText(FActionText, LX, LY, LFont, LPaint);
end;

procedure TDSkSnackbar.DrawCloseButton(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LPaint: ISkPaint;
  LX, LY: Single;
  LSize: Single;
begin
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;

  case FVariant of
    snvStandard, snvFilled:
      LPaint.Color := TAlphaColors.White;
    snvOutlined:
      LPaint.Color := GetSeverityColor;
  end;

  LPaint.Style := TSkPaintStyle.Stroke;
  LPaint.StrokeWidth := 2;
  LPaint.StrokeCap := TSkStrokeCap.Round;

  LSize := 10;
  LX := ADest.Right - SNACKBAR_PADDING - SNACKBAR_CLOSE_SIZE / 2;
  LY := ADest.Top + ADest.Height / 2;

  ACanvas.DrawLine(LX - LSize, LY - LSize, LX + LSize, LY + LSize, LPaint);
  ACanvas.DrawLine(LX + LSize, LY - LSize, LX - LSize, LY + LSize, LPaint);
end;

procedure TDSkSnackbar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
end;

procedure TDSkSnackbar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LActionRect, LCloseRect: TRectF;
  LAllowClose: Boolean;
begin
  inherited;

  if FActionText <> '' then
  begin
    LActionRect := RectF(
      Width - SNACKBAR_PADDING - MeasureActionText - SNACKBAR_ACTION_MARGIN,
      0,
      Width - SNACKBAR_PADDING,
      Height
    );
    if FShowCloseButton then
      LActionRect.Offset(-SNACKBAR_CLOSE_SIZE - SNACKBAR_ACTION_MARGIN, 0);

    if LActionRect.Contains(PointF(X, Y)) then
    begin
      LAllowClose := True;
      if Assigned(FOnAction) then
        FOnAction(Self, LAllowClose);
      if LAllowClose then
        Hide;
      Exit;
    end;
  end;

  if FShowCloseButton then
  begin
    LCloseRect := RectF(
      Width - SNACKBAR_PADDING - SNACKBAR_CLOSE_SIZE,
      (Height - SNACKBAR_CLOSE_SIZE) / 2,
      Width - SNACKBAR_PADDING,
      (Height + SNACKBAR_CLOSE_SIZE) / 2
    );

    if LCloseRect.Contains(PointF(X, Y)) then
    begin
      Hide;
      Exit;
    end;
  end;
end;

procedure TDSkSnackbar.DrawSeverityIcon(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LPaint: ISkPaint;
  LX, LY, LSize: Single;
  LPathBuilder: ISkPathBuilder;
  LPath: ISkPath;
  LCenter: TPointF;
begin
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Stroke;
  LPaint.StrokeWidth := 2.5;
  LPaint.StrokeCap := TSkStrokeCap.Round;
  LPaint.StrokeJoin := TSkStrokeJoin.Round;

  // 图标颜色
  case FVariant of
    snvStandard, snvFilled:
      LPaint.Color := TAlphaColors.White;
    snvOutlined:
      LPaint.Color := GetSeverityColor;
  end;

  LSize := SNACKBAR_ICON_SIZE;
  LX := ADest.Left + SNACKBAR_PADDING_LEFT;
  LY := ADest.Top + (ADest.Height - LSize) / 2;
  LCenter := PointF(LX + LSize / 2, LY + LSize / 2);

  case FSeverity of
    snkSuccess:
      begin
        // 成功图标：圆圈 + 勾
        ACanvas.DrawCircle(LCenter.X, LCenter.Y, LSize / 2, LPaint);
        LPaint.StrokeWidth := 2.5;
        ACanvas.DrawLine(LCenter.X - 4, LCenter.Y, LCenter.X - 1, LCenter.Y + 4, LPaint);
        ACanvas.DrawLine(LCenter.X - 1, LCenter.Y + 4, LCenter.X + 5, LCenter.Y - 3, LPaint);
      end;
    snkError:
      begin
        // 错误图标：圆圈 + X
        ACanvas.DrawCircle(LCenter.X, LCenter.Y, LSize / 2, LPaint);
        LPaint.StrokeWidth := 2.5;
        ACanvas.DrawLine(LCenter.X - 4, LCenter.Y - 4, LCenter.X + 4, LCenter.Y + 4, LPaint);
        ACanvas.DrawLine(LCenter.X + 4, LCenter.Y - 4, LCenter.X - 4, LCenter.Y + 4, LPaint);
      end;
    snkWarning:
      begin
        // 警告图标：三角形 + 感叹号
        LPathBuilder := TSkPathBuilder.Create;
        LPathBuilder.MoveTo(PointF(LCenter.X, LY + 2));
        LPathBuilder.LineTo(PointF(LX + LSize - 2, LY + LSize - 2));
        LPathBuilder.LineTo(PointF(LX + 2, LY + LSize - 2));
        LPathBuilder.Close;
        LPath := LPathBuilder.Detach;
        ACanvas.DrawPath(LPath, LPaint);
        // 感叹号
        LPaint.Style := TSkPaintStyle.Fill;
        ACanvas.DrawCircle(LCenter.X, LCenter.Y - 1, 1.5, LPaint);
        ACanvas.DrawLine(LCenter.X, LCenter.Y + 2, LCenter.X, LCenter.Y + 5, LPaint);
      end;
    snkInfo:
      begin
        // 信息图标：圆圈 + i
        ACanvas.DrawCircle(LCenter.X, LCenter.Y, LSize / 2, LPaint);
        LPaint.Style := TSkPaintStyle.Fill;
        ACanvas.DrawCircle(LCenter.X, LCenter.Y - 3, 1.5, LPaint);
        ACanvas.DrawLine(LCenter.X, LCenter.Y + 1, LCenter.X, LCenter.Y + 4, LPaint);
      end;
  end;
end;

class procedure TDSkSnackbar.ShowSnackbar(AOwner: TComponent; const AMessage: string;
  ASeverity: TDSkSnackbarSeverity; APosition: TDSkSnackbarPosition;
  AAutoHideDuration: Integer; const AActionText: string);
var
  LSnackbar: TDSkSnackbar;
begin
  LSnackbar := TDSkSnackbar.Create(AOwner);
  LSnackbar.Parent := AOwner as TWinControl;
  LSnackbar.Message := AMessage;
  LSnackbar.Severity := ASeverity;
  LSnackbar.Position := APosition;
  LSnackbar.AutoHideDuration := AAutoHideDuration;
  LSnackbar.ActionText := AActionText;
  LSnackbar.Show;
end;

initialization
  SnackbarList := nil;

finalization
  FreeAndNil(SnackbarList);

end.
