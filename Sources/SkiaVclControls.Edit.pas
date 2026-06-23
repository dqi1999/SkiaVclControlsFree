unit SkiaVclControls.Edit;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  System.Generics.Collections,
  Vcl.Controls, Vcl.Graphics, Vcl.Forms, Vcl.Clipbrd, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  { 编辑框变体样式 }
  TDSkEditVariant = (evOutlined, evFilled, evUnderline);

  { 标签放置方式 }
  TDSkEditLabelPlacement = (elpFloat, elpShrink);

  { 编辑框尺寸 }
  TDSkEditSize = (esMedium, esSmall);

  { 文本变化事件 }
  TDSkEditChangeEvent = procedure(Sender: TObject; const AText: string) of object;

  { TDSkEdit - MUI 风格文本编辑框
    参考 Material-UI TextField 组件，支持 Outlined / Filled / Underline 三种变体 }
  TDSkEdit = class(TDSCustomSkControl)
  private
    FText: string;                    // 当前文本内容
    FSelStart: Integer;               // 选区起始位置（字符索引）
    FSelEnd: Integer;                 // 选区结束位置（不含）
    FCaretPos: Integer;               // 光标位置（字符索引）
    FCaretVisible: Boolean;           // 光标是否可见（闪烁）
    FCaretTimer: Cardinal;            // 光标闪烁定时器
    FScrollOffset: Single;            // 文本滚动偏移量（像素）
    FSelecting: Boolean;              // 是否正在鼠标拖选
    FVariant: TDSkEditVariant;        // 变体样式
    FLabelPlacement: TDSkEditLabelPlacement; // 标签放置方式
    FColorScheme: TDSkMUIColorScheme; // MUI 颜色方案
    FSize: TDSkEditSize;             // 尺寸
    FLabel: string;                   // 浮动标签文字
    FPlaceholder: string;             // 占位提示文字
    FHelperText: string;              // 底部帮助文字
    FErrorText: string;               // 错误提示文字
    FError: Boolean;                  // 错误状态
    FClearable: Boolean;              // 显示清除按钮
    FReadOnly: Boolean;               // 只读状态
    FMaxLength: Integer;              // 最大字符数，0=不限制
    FPasswordChar: Char;              // 密码掩码字符，#0=不使用
    FFont: TFont;                     // 输入文字字体
    FLabelFont: TFont;                // 标签字体
    FOnChange: TDSkEditChangeEvent;   // 文本变化事件
    // 字体缓存
    FTextCacheFont: ISkFont;
    FTextCacheTypeface: ISkTypeface;
    FTextCacheFontName: string;
    FTextCacheFontStyle: TFontStyles;
    FTextCacheFontSize: Single;
    FTextCachePPI: Integer;
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
    procedure SetText(const Value: string);
    procedure SetLabel_(const Value: string);
    procedure SetPlaceholder(const Value: string);
    procedure SetHelperText(const Value: string);
    procedure SetErrorText(const Value: string);
    procedure SetError(Value: Boolean);
    procedure SetClearable(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);
    procedure SetMaxLength(Value: Integer);
    procedure SetPasswordChar(Value: Char);
    procedure SetVariant(Value: TDSkEditVariant);
    procedure SetColorScheme(Value: TDSkMUIColorScheme);
    procedure SetLabelPlacement(Value: TDSkEditLabelPlacement);
    procedure SetSize(Value: TDSkEditSize);
    procedure SetFont(Value: TFont);
    procedure SetLabelFont(Value: TFont);
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
    function GetEditBorderColor: TAlphaColor;
    function GetEditLabelColor: TAlphaColor;
    function HasValue: Boolean;
    function IsLabelFloating: Boolean;
    function GetEffectiveText: string;
    procedure EnsureCaretVisible;
    function CharIndexToPixelPos(AIndex: Integer): Single;
    function PixelPosToCharIndex(APos: Single): Integer;
    function GetTextContentLeft: Single;
    function GetTextContentTop: Single;
    procedure StartCaretTimer;
    procedure StopCaretTimer;
    procedure ResetCaretBlink;
    procedure CaretTimerTick;
    procedure InsertText(const AText: string);
    procedure DeleteSelection;
    procedure SelectAll;
    procedure CopyToClipboard;
    procedure CutToClipboard;
    procedure PasteFromClipboard;
    function HasSelection: Boolean;
    function GetSelText: string;
    function GetSelStart: Integer;
    function GetSelLength: Integer;
    procedure SetSelStart(Value: Integer);
    procedure SetSelLength(Value: Integer);
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure WMTimer(var Message: TMessage); message WM_TIMER;
    procedure WMGetText(var Message: TWMGetText); message WM_GETTEXT;
    procedure WMGetTextLength(var Message: TWMGetTextLength); message WM_GETTEXTLENGTH;
    procedure WMSetText(var Message: TWMSetText); message WM_SETTEXT;
    procedure WMChar(var Message: TWMChar); message WM_CHAR;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMCopy(var Message: TMessage); message WM_COPY;
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
  protected
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawBackground(const ACanvas: ISkCanvas; const ADest: TRectF; AOpacity: Single); override;
    procedure DrawBorder(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawLabel(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawText(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawPlaceholder(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawCaret(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawSelection(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawClearButton(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure DrawHelperText(const ACanvas: ISkCanvas; const ADest: TRectF);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    procedure DblClick; override;
    procedure SetFocus; override;
    procedure KillFocus;
    function CanFocus: Boolean; override;
    procedure DestroyWnd; override;
    function ShouldClipWindowRegion: Boolean; override;
    function DependsOnParentBackground: Boolean; override;
    function DependsOnParentVisualBackground: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    procedure ClearSelection;
    function GetTextLen: Integer;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property SelText: string read GetSelText;
  published
    property Text: string read FText write SetText;
    property Label_: string read FLabel write SetLabel_;
    property Placeholder: string read FPlaceholder write SetPlaceholder;
    property HelperText: string read FHelperText write SetHelperText;
    property ErrorText: string read FErrorText write SetErrorText;
    property Error: Boolean read FError write SetError default False;
    property Clearable: Boolean read FClearable write SetClearable default False;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property PasswordChar: Char read FPasswordChar write SetPasswordChar default #0;
    property Variant: TDSkEditVariant read FVariant write SetVariant default evOutlined;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property LabelPlacement: TDSkEditLabelPlacement read FLabelPlacement write SetLabelPlacement default elpFloat;
    property Size: TDSkEditSize read FSize write SetSize default esMedium;
    property Font: TFont read FFont write SetFont;
    property LabelFont: TFont read FLabelFont write SetLabelFont;
    property OnChange: TDSkEditChangeEvent read FOnChange write FOnChange;
    property Enabled;
    property Visible;
    property TabOrder;
    property TabStop default True;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

implementation

const
  ITEM_PADDING_H = 16;
  CLEAR_BTN_SIZE = 18;
  LABEL_FLOAT_SIZE_RATIO = 0.75;
  BORDER_RADIUS = 4;
  HELPER_TEXT_GAP = 4;
  CARET_WIDTH = 1.5;
  CARET_BLINK_MS = 530;

{ TDSkEdit }

constructor TDSkEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FText := '';
  FSelStart := 0;
  FSelEnd := 0;
  FCaretPos := 0;
  FCaretVisible := False;
  FCaretTimer := 0;
  FScrollOffset := 0;
  FSelecting := False;
  FVariant := evOutlined;
  FLabelPlacement := elpFloat;
  FColorScheme := muiPrimary;
  FSize := esMedium;
  FLabel := '';
  FPlaceholder := '';
  FHelperText := '';
  FErrorText := '';
  FError := False;
  FClearable := False;
  FReadOnly := False;
  FMaxLength := 0;
  FPasswordChar := #0;
  FFont := TFont.Create;
  FFont.Name := GetDefaultFontName;
  FFont.Size := 12;
  FFont.Color := $00575049; // #495057 深灰色
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
  if FSize = esSmall then
    Height := 46
  else
    Height := 62;
  TabStop := True;
  CornerRadius := BORDER_RADIUS;
  BackgroundColor := TAlphaColors.Null;
  BorderColor := TAlphaColors.Null;
  BorderWidth := 0;

  // 设计期添加默认标签，让组件拖到窗体后立即可见
  if csDesigning in ComponentState then
    FLabel := 'Text Field';
end;

destructor TDSkEdit.Destroy;
begin
  StopCaretTimer;
  FFont.Free;
  FLabelFont.Free;
  inherited;
end;

procedure TDSkEdit.SetText(const Value: string);
var
  LNewText: string;
begin
  LNewText := Value;
  if (FMaxLength > 0) and (Length(LNewText) > FMaxLength) then
    LNewText := Copy(LNewText, 1, FMaxLength);
  if FText <> LNewText then begin
    FText := LNewText;
    FCaretPos := Min(FCaretPos, Length(FText));
    FSelStart := FCaretPos;
    FSelEnd := FCaretPos;
    FScrollOffset := 0;
    InvalidateTextCache;
    RequestRedraw;
    if Assigned(FOnChange) then FOnChange(Self, FText);
  end;
end;

procedure TDSkEdit.SetLabel_(const Value: string);
begin
  if FLabel <> Value then begin FLabel := Value; InvalidateLabelFontCache; RequestRedraw; end;
end;

procedure TDSkEdit.SetPlaceholder(const Value: string);
begin
  if FPlaceholder <> Value then begin FPlaceholder := Value; RequestRedraw; end;
end;

procedure TDSkEdit.SetHelperText(const Value: string);
begin
  if FHelperText <> Value then begin FHelperText := Value; RequestRedraw; end;
end;

procedure TDSkEdit.SetErrorText(const Value: string);
begin
  if FErrorText <> Value then begin FErrorText := Value; RequestRedraw; end;
end;

procedure TDSkEdit.SetError(Value: Boolean);
begin
  if FError <> Value then begin FError := Value; RequestRedraw; end;
end;

procedure TDSkEdit.SetClearable(Value: Boolean);
begin
  if FClearable <> Value then begin FClearable := Value; RequestRedraw; end;
end;

procedure TDSkEdit.SetReadOnly(Value: Boolean);
begin
  FReadOnly := Value;
end;

procedure TDSkEdit.SetMaxLength(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if FMaxLength <> Value then begin
    FMaxLength := Value;
    if (FMaxLength > 0) and (Length(FText) > FMaxLength) then begin
      FText := Copy(FText, 1, FMaxLength);
      FCaretPos := Min(FCaretPos, Length(FText));
      FSelStart := FCaretPos;
      FSelEnd := FCaretPos;
      InvalidateTextCache;
      RequestRedraw;
    end;
  end;
end;

procedure TDSkEdit.SetPasswordChar(Value: Char);
begin
  if FPasswordChar <> Value then begin FPasswordChar := Value; RequestRedraw; end;
end;

procedure TDSkEdit.SetVariant(Value: TDSkEditVariant);
begin
  if FVariant <> Value then begin FVariant := Value; RequestRedraw; end;
end;

procedure TDSkEdit.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then begin FColorScheme := Value; RequestRedraw; end;
end;

procedure TDSkEdit.SetLabelPlacement(Value: TDSkEditLabelPlacement);
begin
  if FLabelPlacement <> Value then begin FLabelPlacement := Value; RequestRedraw; end;
end;

procedure TDSkEdit.SetSize(Value: TDSkEditSize);
const
  HEIGHTS: array[TDSkEditSize] of Integer = (62, 46);
begin
  if FSize <> Value then begin
    FSize := Value;
    Height := HEIGHTS[Value];
    RequestRedraw;
  end;
end;

procedure TDSkEdit.SetFont(Value: TFont); begin FFont.Assign(Value); InvalidateTextCache; end;
procedure TDSkEdit.SetLabelFont(Value: TFont); begin FLabelFont.Assign(Value); InvalidateLabelFontCache; end;

procedure TDSkEdit.FontChanged(Sender: TObject); begin InvalidateTextCache; RequestRedraw; end;
procedure TDSkEdit.LabelFontChanged(Sender: TObject); begin InvalidateLabelFontCache; RequestRedraw; end;
procedure TDSkEdit.RequestRedraw; begin if not (csLoading in ComponentState) then Redraw; end;

procedure TDSkEdit.InvalidateTextCache;
begin
  FTextCacheFont := nil; FTextCacheTypeface := nil; FTextCacheFontName := '';
  FTextCacheFontStyle := []; FTextCacheFontSize := -1; FTextCachePPI := 0;
end;

procedure TDSkEdit.InvalidateLabelFontCache;
begin
  FLabelCacheFont := nil; FLabelCacheTypeface := nil; FLabelCacheFontName := '';
  FLabelCacheFontStyle := []; FLabelCacheFontSize := -1; FLabelCachePPI := 0;
end;

procedure TDSkEdit.InvalidateHelperFontCache;
begin
  FHelperCacheFont := nil; FHelperCacheTypeface := nil; FHelperCacheFontName := '';
  FHelperCacheFontSize := -1; FHelperCachePPI := 0;
end;

function TDSkEdit.GetTextFont: ISkFont;
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
    FTextCacheFontSize := LFontSize; FTextCachePPI := LPPI;
  end;
  Result := FTextCacheFont;
end;

function TDSkEdit.GetLabelFontCache: ISkFont;
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

function TDSkEdit.GetHelperFontCache: ISkFont;
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

function TDSkEdit.GetDisplayText: string;
begin
  Result := FText;
end;

function TDSkEdit.GetEffectiveText: string;
var
  i: Integer;
begin
  if FPasswordChar <> #0 then begin
    SetLength(Result, Length(FText));
    for i := 1 to Length(FText) do
      Result[i] := FPasswordChar;
  end else
    Result := FText;
end;

function TDSkEdit.HasValue: Boolean;
begin
  Result := FText <> '';
end;

function TDSkEdit.IsLabelFloating: Boolean;
begin
  Result := (FLabelPlacement = elpShrink) or HasValue or Focused;
end;

function TDSkEdit.GetEditBorderColor: TAlphaColor;
begin
  if FError then Result := $FFD32F2F
  else if Focused then begin
    case FColorScheme of
      muiSecondary: Result := $FF9C27B0; muiError: Result := $FFD32F2F;
      muiWarning: Result := $FFED6C02; muiInfo: Result := $FF0288D1;
      muiSuccess: Result := $FF2E7D32;
    else Result := $FF1976D2; end;
  end else Result := $FFBDBDBD;
end;

function TDSkEdit.GetEditLabelColor: TAlphaColor;
begin
  if FError then Result := $FFD32F2F
  else if Focused then begin
    case FColorScheme of
      muiSecondary: Result := $FF9C27B0; muiError: Result := $FFD32F2F;
      muiWarning: Result := $FFED6C02; muiInfo: Result := $FF0288D1;
      muiSuccess: Result := $FF2E7D32;
    else Result := $FF1976D2; end;
  end else Result := $FF757575;
end;

function TDSkEdit.GetTextContentLeft: Single;
begin
  Result := DpiScaleValue(ITEM_PADDING_H);
end;

function TDSkEdit.GetTextContentTop: Single;
var
  LFont: ISkFont;
  LMetrics: TSkFontMetrics;
begin
  LFont := GetTextFont;
  LFont.GetMetrics(LMetrics);
  if IsLabelFloating and (FLabel <> '') then begin
    if FSize = esSmall then
      Result := DpiScaleValue(16) + LFont.Size
    else
      Result := DpiScaleValue(28) + LFont.Size;
  end else
    Result := (Height + LFont.Size) / 2;
end;

function TDSkEdit.CharIndexToPixelPos(AIndex: Integer): Single;
var
  LFont: ISkFont;
  LText: string;
begin
  LFont := GetTextFont;
  LText := GetEffectiveText;
  if AIndex <= 0 then
    Result := 0
  else if AIndex >= Length(LText) then
    Result := LFont.MeasureText(LText)
  else
    Result := LFont.MeasureText(Copy(LText, 1, AIndex));
end;

function TDSkEdit.PixelPosToCharIndex(APos: Single): Integer;
var
  LFont: ISkFont;
  LText: string;
  i: Integer;
  LPrevPos, LCurrPos: Single;
begin
  LFont := GetTextFont;
  LText := GetEffectiveText;
  Result := Length(LText);
  LPrevPos := 0;
  for i := 1 to Length(LText) do begin
    LCurrPos := LFont.MeasureText(Copy(LText, 1, i));
    if APos <= (LPrevPos + LCurrPos) / 2 then begin
      Result := i - 1;
      Exit;
    end;
    LPrevPos := LCurrPos;
  end;
end;

procedure TDSkEdit.EnsureCaretVisible;
var
  LCaretX, LLeft, LRight, LContentWidth: Single;
begin
  LLeft := GetTextContentLeft;
  LRight := Width - LLeft;
  if FClearable and HasValue then
    LRight := LRight - DpiScaleValue(CLEAR_BTN_SIZE) - DpiScaleValue(8);
  LContentWidth := LRight - LLeft;
  LCaretX := CharIndexToPixelPos(FCaretPos);
  if LCaretX - FScrollOffset < 0 then
    FScrollOffset := LCaretX
  else if LCaretX - FScrollOffset > LContentWidth then
    FScrollOffset := LCaretX - LContentWidth;
end;

procedure TDSkEdit.StartCaretTimer;
begin
  if (FCaretTimer = 0) and HandleAllocated then begin
    FCaretTimer := SetTimer(Handle, 1, CARET_BLINK_MS, nil);
    FCaretVisible := True;
  end;
end;

procedure TDSkEdit.StopCaretTimer;
begin
  if FCaretTimer <> 0 then begin
    if HandleAllocated then
      KillTimer(Handle, 1);
    FCaretTimer := 0;
    FCaretVisible := False;
  end;
end;

procedure TDSkEdit.ResetCaretBlink;
begin
  FCaretVisible := True;
  if (FCaretTimer <> 0) and HandleAllocated then begin
    KillTimer(Handle, 1);
    FCaretTimer := SetTimer(Handle, 1, CARET_BLINK_MS, nil);
  end;
end;

procedure TDSkEdit.CaretTimerTick;
begin
  FCaretVisible := not FCaretVisible;
  RequestRedraw;
end;

procedure TDSkEdit.InsertText(const AText: string);
var
  LNewText: string;
  LInsertText: string;
begin
  if FReadOnly then Exit;
  DeleteSelection;
  LInsertText := AText;
  if FMaxLength > 0 then begin
    if Length(FText) + Length(LInsertText) > FMaxLength then
      LInsertText := Copy(LInsertText, 1, FMaxLength - Length(FText));
  end;
  if LInsertText = '' then Exit;
  LNewText := Copy(FText, 1, FCaretPos) + LInsertText + Copy(FText, FCaretPos + 1, MaxInt);
  FText := LNewText;
  FCaretPos := FCaretPos + Length(LInsertText);
  FSelStart := FCaretPos;
  FSelEnd := FCaretPos;
  InvalidateTextCache;
  EnsureCaretVisible;
  ResetCaretBlink;
  RequestRedraw;
  if Assigned(FOnChange) then FOnChange(Self, FText);
end;

procedure TDSkEdit.DeleteSelection;
var
  LSelStart, LSelEnd, LLen: Integer;
begin
  if not HasSelection then Exit;
  LSelStart := Min(FSelStart, FSelEnd);
  LSelEnd := Max(FSelStart, FSelEnd);
  LLen := LSelEnd - LSelStart;
  Delete(FText, LSelStart + 1, LLen);
  FCaretPos := LSelStart;
  FSelStart := FCaretPos;
  FSelEnd := FCaretPos;
  InvalidateTextCache;
  EnsureCaretVisible;
  RequestRedraw;
  if Assigned(FOnChange) then FOnChange(Self, FText);
end;

procedure TDSkEdit.SelectAll;
begin
  FSelStart := 0;
  FSelEnd := Length(FText);
  FCaretPos := FSelEnd;
  EnsureCaretVisible;
  RequestRedraw;
end;

procedure TDSkEdit.CopyToClipboard;
begin
  if HasSelection then
    Clipboard.AsText := GetSelText;
end;

procedure TDSkEdit.CutToClipboard;
begin
  if HasSelection and not FReadOnly then begin
    Clipboard.AsText := GetSelText;
    DeleteSelection;
  end;
end;

procedure TDSkEdit.PasteFromClipboard;
var
  LPasteText: string;
begin
  if FReadOnly then Exit;
  LPasteText := Clipboard.AsText;
  if LPasteText <> '' then
    InsertText(LPasteText);
end;

function TDSkEdit.HasSelection: Boolean;
begin
  Result := FSelStart <> FSelEnd;
end;

function TDSkEdit.GetSelText: string;
var
  LSelStart, LSelEnd: Integer;
begin
  if HasSelection then begin
    LSelStart := Min(FSelStart, FSelEnd);
    LSelEnd := Max(FSelStart, FSelEnd);
    Result := Copy(FText, LSelStart + 1, LSelEnd - LSelStart);
  end else
    Result := '';
end;

function TDSkEdit.GetSelStart: Integer;
begin
  Result := Min(FSelStart, FSelEnd);
end;

function TDSkEdit.GetSelLength: Integer;
begin
  Result := Abs(FSelEnd - FSelStart);
end;

procedure TDSkEdit.SetSelStart(Value: Integer);
begin
  Value := Max(0, Min(Value, Length(FText)));
  FSelStart := Value;
  FSelEnd := Value;
  FCaretPos := Value;
  EnsureCaretVisible;
  ResetCaretBlink;
  RequestRedraw;
end;

procedure TDSkEdit.SetSelLength(Value: Integer);
begin
  FSelEnd := Max(0, Min(FSelStart + Value, Length(FText)));
  FCaretPos := FSelEnd;
  EnsureCaretVisible;
  ResetCaretBlink;
  RequestRedraw;
end;

function TDSkEdit.GetTextLen: Integer;
begin
  Result := Length(FText);
end;

procedure TDSkEdit.Clear;
begin
  FText := '';
  FCaretPos := 0;
  FSelStart := 0;
  FSelEnd := 0;
  FScrollOffset := 0;
  InvalidateTextCache;
  RequestRedraw;
  if Assigned(FOnChange) then FOnChange(Self, FText);
end;

procedure TDSkEdit.ClearSelection;
begin
  FSelStart := FCaretPos;
  FSelEnd := FCaretPos;
  RequestRedraw;
end;

procedure TDSkEdit.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not Enabled then StopCaretTimer;
  RequestRedraw;
end;

procedure TDSkEdit.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
  if Focused then
    StartCaretTimer
  else begin
    StopCaretTimer;
    ClearSelection;
  end;
  RequestRedraw;
end;

procedure TDSkEdit.WMTimer(var Message: TMessage);
begin
  if Message.WParam = 1 then
    CaretTimerTick
  else
    inherited;
end;

procedure TDSkEdit.DestroyWnd;
begin
  // 窗口销毁前必须先停止定时器，避免 WM_TIMER 消息到达已销毁的窗口
  StopCaretTimer;
  inherited;
end;

procedure TDSkEdit.WMGetText(var Message: TWMGetText);
var
  LLen: Integer;
begin
  LLen := Min(Length(FText), Message.TextMax - 1);
  if LLen > 0 then
    Move(FText[1], Message.Text^, LLen * SizeOf(Char));
  Message.Text[LLen] := #0;
  Message.Result := LLen;
end;

procedure TDSkEdit.WMGetTextLength(var Message: TWMGetTextLength);
begin
  Message.Result := Length(FText);
end;

procedure TDSkEdit.WMSetText(var Message: TWMSetText);
begin
  SetText(Message.Text);
  Message.Result := 1;
end;

procedure TDSkEdit.WMChar(var Message: TWMChar);
var
  LKey: Char;
begin
  LKey := Char(Message.CharCode);
  if LKey >= #32 then
    InsertText(LKey);
end;

procedure TDSkEdit.WMKeyDown(var Message: TWMKeyDown);
var
  LKey: Word;
  LShift: TShiftState;
begin
  LKey := Message.CharCode;
  LShift := KeyDataToShiftState(Message.KeyData);
  KeyDown(LKey, LShift);
end;

procedure TDSkEdit.WMPaste(var Message: TMessage);
begin
  PasteFromClipboard;
end;

procedure TDSkEdit.WMCopy(var Message: TMessage);
begin
  CopyToClipboard;
end;

procedure TDSkEdit.WMCut(var Message: TMessage);
begin
  CutToClipboard;
end;

procedure TDSkEdit.WMUndo(var Message: TMessage);
begin
  // 暂不支持撤销
end;

procedure TDSkEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LClearBtnSize, LClearBtnX, LClearBtnY: Single;
  LTextX, LTextY, LClickPos: Single;
begin
  inherited;
  if (Button <> mbLeft) or not Enabled then Exit;
  // 检查清除按钮
  if FClearable and HasValue then begin
    LClearBtnSize := DpiScaleValue(CLEAR_BTN_SIZE);
    LClearBtnX := Width - DpiScaleValue(ITEM_PADDING_H) - LClearBtnSize;
    LClearBtnY := (Height - LClearBtnSize) / 2;
    if (X >= LClearBtnX) and (X <= LClearBtnX + LClearBtnSize) and
       (Y >= LClearBtnY) and (Y <= LClearBtnY + LClearBtnSize) then begin Clear; Exit; end;
  end;
  // 文本区域点击定位光标
  if CanFocus then SetFocus;
  LTextX := GetTextContentLeft;
  LClickPos := X - LTextX + FScrollOffset;
  FCaretPos := PixelPosToCharIndex(LClickPos);
  FSelStart := FCaretPos;
  FSelEnd := FCaretPos;
  FSelecting := True;
  ResetCaretBlink;
  RequestRedraw;
end;

procedure TDSkEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  LTextX, LClickPos: Single;
begin
  inherited;
  if FSelecting then begin
    LTextX := GetTextContentLeft;
    LClickPos := X - LTextX + FScrollOffset;
    FCaretPos := PixelPosToCharIndex(LClickPos);
    FSelEnd := FCaretPos;
    EnsureCaretVisible;
    RequestRedraw;
  end;
end;

procedure TDSkEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
    FSelecting := False;
end;

procedure TDSkEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  LPrevCaret: Integer;
begin
  inherited;
  LPrevCaret := FCaretPos;
  case Key of
    VK_LEFT: begin
      if FCaretPos > 0 then Dec(FCaretPos);
      if ssShift in Shift then
        FSelEnd := FCaretPos
      else begin
        FSelStart := FCaretPos;
        FSelEnd := FCaretPos;
      end;
      EnsureCaretVisible;
      ResetCaretBlink;
      RequestRedraw;
    end;
    VK_RIGHT: begin
      if FCaretPos < Length(FText) then Inc(FCaretPos);
      if ssShift in Shift then
        FSelEnd := FCaretPos
      else begin
        FSelStart := FCaretPos;
        FSelEnd := FCaretPos;
      end;
      EnsureCaretVisible;
      ResetCaretBlink;
      RequestRedraw;
    end;
    VK_HOME: begin
      FCaretPos := 0;
      if ssShift in Shift then
        FSelEnd := FCaretPos
      else begin
        FSelStart := FCaretPos;
        FSelEnd := FCaretPos;
      end;
      EnsureCaretVisible;
      ResetCaretBlink;
      RequestRedraw;
    end;
    VK_END: begin
      FCaretPos := Length(FText);
      if ssShift in Shift then
        FSelEnd := FCaretPos
      else begin
        FSelStart := FCaretPos;
        FSelEnd := FCaretPos;
      end;
      EnsureCaretVisible;
      ResetCaretBlink;
      RequestRedraw;
    end;
    VK_BACK: begin
      if not FReadOnly then begin
        if HasSelection then
          DeleteSelection
        else if FCaretPos > 0 then begin
          Delete(FText, FCaretPos, 1);
          Dec(FCaretPos);
          FSelStart := FCaretPos;
          FSelEnd := FCaretPos;
          InvalidateTextCache;
          EnsureCaretVisible;
          ResetCaretBlink;
          RequestRedraw;
          if Assigned(FOnChange) then FOnChange(Self, FText);
        end;
      end;
    end;
    VK_DELETE: begin
      if not FReadOnly then begin
        if HasSelection then
          DeleteSelection
        else if FCaretPos < Length(FText) then begin
          Delete(FText, FCaretPos + 1, 1);
          InvalidateTextCache;
          EnsureCaretVisible;
          ResetCaretBlink;
          RequestRedraw;
          if Assigned(FOnChange) then FOnChange(Self, FText);
        end;
      end;
    end;
    VK_INSERT: begin
      if ssCtrl in Shift then CopyToClipboard
      else if ssShift in Shift then PasteFromClipboard;
    end;
    Ord('A'): begin
      if ssCtrl in Shift then SelectAll;
    end;
    Ord('C'): begin
      if ssCtrl in Shift then CopyToClipboard;
    end;
    Ord('X'): begin
      if ssCtrl in Shift then CutToClipboard;
    end;
    Ord('V'): begin
      if ssCtrl in Shift then PasteFromClipboard;
    end;
  end;
end;

procedure TDSkEdit.KeyPress(var Key: Char);
begin
  inherited;
  if Key = #27 then Exit; // Escape 不处理
end;

function TDSkEdit.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  // 水平滚动
  FScrollOffset := FScrollOffset - WheelDelta / 120 * 20;
  EnsureCaretVisible;
  Result := True;
  RequestRedraw;
end;

procedure TDSkEdit.DblClick;
begin
  inherited;
  // 双击选中当前单词
  SelectAll;
end;

procedure TDSkEdit.SetFocus;
begin
  inherited;
  StartCaretTimer;
end;

procedure TDSkEdit.KillFocus;
begin
  StopCaretTimer;
  ClearSelection;
end;

function TDSkEdit.CanFocus: Boolean;
begin
  Result := inherited CanFocus and Enabled;
end;

function TDSkEdit.ShouldClipWindowRegion: Boolean; begin Result := False; end;
function TDSkEdit.DependsOnParentBackground: Boolean; begin Result := False; end;
function TDSkEdit.DependsOnParentVisualBackground: Boolean;
begin
  if Parent is TDSCustomSkControl then Result := TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack
  else Result := False;
end;

procedure TDSkEdit.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
begin
  ACanvas.Clear($00FFFFFF);
  DrawBackground(ACanvas, ADest, AOpacity);
  DrawBorder(ACanvas, ADest);
  DrawLabel(ACanvas, ADest);
  if HasSelection then DrawSelection(ACanvas, ADest);
  if HasValue or (FPasswordChar <> #0) then
    DrawText(ACanvas, ADest)
  else if FPlaceholder <> '' then
    DrawPlaceholder(ACanvas, ADest);
  if Focused then DrawCaret(ACanvas, ADest);
  if FClearable and HasValue then DrawClearButton(ACanvas, ADest);
  DrawHelperText(ACanvas, ADest);
end;

procedure TDSkEdit.DrawBackground(const ACanvas: ISkCanvas; const ADest: TRectF; AOpacity: Single);
var LPaint: ISkPaint; LRoundRect: ISkRoundRect; LRadius: Single;
begin
  if FVariant = evFilled then begin
    LPaint := TSkPaint.Create; LPaint.AntiAlias := True;
    LPaint.Style := TSkPaintStyle.Fill; LPaint.Color := $08000000;
    LRadius := DpiScaleValue(BORDER_RADIUS);
    LRoundRect := TSkRoundRect.Create; LRoundRect.SetRect(ADest, LRadius, LRadius);
    ACanvas.DrawRoundRect(LRoundRect, LPaint);
  end;
end;

procedure TDSkEdit.DrawBorder(const ACanvas: ISkCanvas; const ADest: TRectF);
var LPaint: ISkPaint; LPathBuilder: ISkPathBuilder; LPath: ISkPath;
    LRect: TRectF; LRadius, LBorderW: Single; LColor: TAlphaColor;
    LLabelFont: ISkFont; LLabelW, LLabelLeft: Single; LRoundRect: ISkRoundRect;
begin
  LColor := GetEditBorderColor;
  LBorderW := DpiScaleValue(1);
  if Focused then LBorderW := DpiScaleValue(2);
  LRadius := DpiScaleValue(BORDER_RADIUS);
  LRect := ADest; LRect.Inflate(-LBorderW / 2, -LBorderW / 2);
  LPaint := TSkPaint.Create; LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Stroke; LPaint.StrokeWidth := LBorderW;
  LPaint.Color := LColor; LPaint.StrokeJoin := TSkStrokeJoin.Round;
  if FVariant = evOutlined then begin
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
    LPaint.StrokeCap := TSkStrokeCap.Round;
    if FVariant = evUnderline then
      ACanvas.DrawLine(PointF(LRect.Left, LRect.Bottom - DpiScaleValue(6)), PointF(LRect.Right, LRect.Bottom - DpiScaleValue(6)), LPaint)
    else
      ACanvas.DrawLine(PointF(LRect.Left, LRect.Bottom), PointF(LRect.Right, LRect.Bottom), LPaint);
  end;
end;

procedure TDSkEdit.DrawLabel(const ACanvas: ISkCanvas; const ADest: TRectF);
var LFont: ISkFont; LPaint: ISkPaint; LX, LY, LTextW: Single;
    LBackPaint: ISkPaint; LBackRect: TRectF;
    LMetrics: TSkFontMetrics;
begin
  if FLabel = '' then Exit;
  LFont := GetLabelFontCache;
  LFont.GetMetrics(LMetrics);
  LPaint := TSkPaint.Create; LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Fill; LPaint.Color := GetEditLabelColor;
  if IsLabelFloating then begin
    LX := DpiScaleValue(ITEM_PADDING_H - 2);
    if FVariant = evOutlined then begin
      LY := ADest.Top + DpiScaleValue(1) - LMetrics.Ascent;
      LTextW := LFont.MeasureText(FLabel);
      LBackRect := RectF(LX - DpiScaleValue(4), ADest.Top - DpiScaleValue(1),
        LX + LTextW + DpiScaleValue(4), ADest.Top + LMetrics.Descent + DpiScaleValue(1));
      LBackPaint := TSkPaint.Create; LBackPaint.AntiAlias := False;
      LBackPaint.Style := TSkPaintStyle.Fill; LBackPaint.Color := $FFFFFFFF;
      ACanvas.DrawRect(LBackRect, LBackPaint);
    end else
      LY := DpiScaleValue(8) + LFont.Size;
  end else begin
    LX := DpiScaleValue(ITEM_PADDING_H);
    LY := ADest.Top + (ADest.Height + LFont.Size) / 2;
  end;
  ACanvas.DrawSimpleText(FLabel, LX, LY, LFont, LPaint);
end;

procedure TDSkEdit.DrawText(const ACanvas: ISkCanvas; const ADest: TRectF);
var LFont: ISkFont; LPaint: ISkPaint; LX, LY: Single; LText: string;
begin
  LText := GetEffectiveText; if LText = '' then Exit;
  LFont := GetTextFont;
  LPaint := TSkPaint.Create; LPaint.AntiAlias := True; LPaint.Style := TSkPaintStyle.Fill;
  if not Enabled then LPaint.Color := $FF757575 else LPaint.Color := VclColorToAlphaColor(FFont.Color);
  LX := GetTextContentLeft - FScrollOffset;
  LY := GetTextContentTop;
  ACanvas.DrawSimpleText(LText, LX, LY, LFont, LPaint);
end;

procedure TDSkEdit.DrawPlaceholder(const ACanvas: ISkCanvas; const ADest: TRectF);
var LFont: ISkFont; LPaint: ISkPaint; LX, LY: Single;
begin
  if FPlaceholder = '' then Exit;
  if (FLabel <> '') and (FLabelPlacement = elpFloat) and not IsLabelFloating then Exit;
  LFont := GetTextFont;
  LPaint := TSkPaint.Create; LPaint.AntiAlias := True; LPaint.Style := TSkPaintStyle.Fill; LPaint.Color := $61000000;
  LX := GetTextContentLeft;
  if (FLabel <> '') and not IsLabelFloating then begin
    if FSize = esSmall then
      LY := ADest.Top + DpiScaleValue(16) + LFont.Size
    else
      LY := ADest.Top + DpiScaleValue(28) + LFont.Size;
  end else
    LY := ADest.Top + (ADest.Height + LFont.Size) / 2;
  ACanvas.DrawSimpleText(FPlaceholder, LX, LY, LFont, LPaint);
end;

procedure TDSkEdit.DrawSelection(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LSelStart, LSelEnd: Integer;
  LX1, LX2, LY, LH: Single;
  LPaint: ISkPaint;
  LSelectColor: TAlphaColor;
begin
  if not HasSelection then Exit;
  LSelStart := Min(FSelStart, FSelEnd);
  LSelEnd := Max(FSelStart, FSelEnd);
  LX1 := GetTextContentLeft + CharIndexToPixelPos(LSelStart) - FScrollOffset;
  LX2 := GetTextContentLeft + CharIndexToPixelPos(LSelEnd) - FScrollOffset;
  LY := GetTextContentTop - GetTextFont.Size + DpiScaleValue(2);
  LH := GetTextFont.Size + DpiScaleValue(4);
  // 选择颜色：主题色 30% 透明度
  case FColorScheme of
    muiSecondary: LSelectColor := $4D9C27B0; muiError: LSelectColor := $4DD32F2F;
    muiWarning: LSelectColor := $4DED6C02; muiInfo: LSelectColor := $4D0288D1;
    muiSuccess: LSelectColor := $4D2E7D32;
  else LSelectColor := $4D1976D2; end;
  LPaint := TSkPaint.Create; LPaint.AntiAlias := False;
  LPaint.Style := TSkPaintStyle.Fill; LPaint.Color := LSelectColor;
  ACanvas.DrawRect(RectF(LX1, LY, LX2, LY + LH), LPaint);
end;

procedure TDSkEdit.DrawCaret(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LCaretX, LCaretTop, LCaretBottom: Single;
  LPaint: ISkPaint;
begin
  if not FCaretVisible then Exit;
  LCaretX := GetTextContentLeft + CharIndexToPixelPos(FCaretPos) - FScrollOffset;
  LCaretTop := GetTextContentTop - GetTextFont.Size + DpiScaleValue(2);
  LCaretBottom := GetTextContentTop + DpiScaleValue(4);
  LPaint := TSkPaint.Create; LPaint.AntiAlias := False;
  LPaint.Style := TSkPaintStyle.Stroke; LPaint.StrokeWidth := DpiScaleValue(CARET_WIDTH);
  LPaint.Color := $FF000000; LPaint.StrokeCap := TSkStrokeCap.Round;
  ACanvas.DrawLine(PointF(LCaretX, LCaretTop), PointF(LCaretX, LCaretBottom), LPaint);
end;

procedure TDSkEdit.DrawClearButton(const ACanvas: ISkCanvas; const ADest: TRectF);
var LPaint: ISkPaint; LCenter: TPointF; LSize: Single;
    LPathBuilder: ISkPathBuilder; LPath: ISkPath;
begin
  LSize := DpiScaleValue(CLEAR_BTN_SIZE / 2);
  LCenter := PointF(ADest.Right - DpiScaleValue(ITEM_PADDING_H) - LSize, ADest.Top + ADest.Height / 2);
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

procedure TDSkEdit.DrawHelperText(const ACanvas: ISkCanvas; const ADest: TRectF);
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
