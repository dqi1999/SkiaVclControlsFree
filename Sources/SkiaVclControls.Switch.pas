unit SkiaVclControls.Switch;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  { TDSkSwitch - MUI风格滑动开关组件
    由轨道(长条背景)和滑块(圆形按钮)组成，支持Small/Medium两种尺寸
    无边框透明背景，可单独使用或配合TDSkSwitchGroup管理 }
  TDSkSwitch = class(TDSCustomSkControl)
  private
    FChecked: Boolean;                    // 开关状态：True=开启，False=关闭
    FCaption: string;                     // 标签文字
    FLabelPlacement: TDSkRadioLabelPlacement; // 标签位置：左/右/上/下
    FColorScheme: TDSkMUIColorScheme;     // 颜色主题
    FSize: TDSkSwitchSize;                // 尺寸：Small(小)或Medium(中)
    FFont: TFont;                         // 标签字体
    FMouseIsDown: Boolean;                // 鼠标是否按下（用于判断点击有效性）
    FOnCheckChanged: TNotifyEvent;        // 状态改变事件
    // 字体缓存相关字段，避免每次重绘都重新创建字体对象
    FTextCacheFont: ISkFont;              // 缓存的Skia字体对象
    FTextCacheTypeface: ISkTypeface;      // 缓存的字形对象
    FTextCacheFontName: string;           // 缓存的字体名称
    FTextCacheFontStyle: TFontStyles;     // 缓存的字体样式(粗体/斜体等)
    FTextCacheFontSize: Single;           // 缓存的字体大小
    FTextCachePPI: Integer;               // 缓存的屏幕像素密度
    FTextCacheText: string;               // 缓存的文字内容
    FTextCacheWidth: Single;              // 缓存的文字宽度
    procedure RequestRedraw;              // 请求重绘（统一使用 Redraw，设计时和运行时都能生效）
    procedure SetChecked(Value: Boolean); // 设置开关状态
    procedure SetCaption(const Value: string); // 设置标签文字
    procedure SetLabelPlacement(Value: TDSkRadioLabelPlacement); // 设置标签位置
    procedure SetColorScheme(Value: TDSkMUIColorScheme); // 设置颜色主题
    procedure SetSize(Value: TDSkSwitchSize); // 设置尺寸
    procedure SetFont(Value: TFont);      // 设置字体
    procedure FontChanged(Sender: TObject); // 字体改变时回调
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED; // 启用状态改变消息处理
    procedure InvalidateTextCache;        // 使文字缓存失效（字体/文字变化时调用）
    function GetTextFont: ISkFont;        // 获取Skia字体对象（带缓存）
    function MeasureCaptionText: Single;  // 测量标签文字宽度（带缓存）
    function GetTrackWidth: Single;       // 获取轨道宽度（根据尺寸）
    function GetTrackHeight: Single;      // 获取轨道高度（根据尺寸）
    function GetThumbRadius: Single;      // 获取滑块半径（根据尺寸）
  protected
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override; // 绘制入口
    procedure DrawSwitch(const ACanvas: ISkCanvas; const ADest: TRectF); // 绘制开关（轨道+滑块）
    procedure DrawLabel(const ACanvas: ISkCanvas; const ADest: TRectF);  // 绘制标签文字
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override; // 鼠标按下
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;   // 鼠标抬起
    procedure KeyDown(var Key: Word; Shift: TShiftState); override; // 键盘按下（空格键切换）
    procedure Click; override;            // 点击事件
    function ShouldClipWindowRegion: Boolean; override; // 是否裁剪窗口区域
    function DependsOnParentBackground: Boolean; override; // 是否依赖父背景
    function DependsOnParentVisualBackground: Boolean; override; // 是否依赖父视觉背景
  public
    constructor Create(AOwner: TComponent); override; // 构造函数
    destructor Destroy; override;         // 析构函数
    procedure Toggle;                     // 切换开关状态
  published
    property Checked: Boolean read FChecked write SetChecked default False; // 开关状态属性
    property Caption: string read FCaption write SetCaption; // 标签文字属性
    property LabelPlacement: TDSkRadioLabelPlacement read FLabelPlacement write SetLabelPlacement default rlpRight; // 标签位置属性
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary; // 颜色主题属性
    property Size: TDSkSwitchSize read FSize write SetSize default sssMedium; // 尺寸属性
    property Font: TFont read FFont write SetFont; // 字体属性
    property OnCheckChanged: TNotifyEvent read FOnCheckChanged write FOnCheckChanged; // 状态改变事件
    property Enabled;                     // 继承：是否启用
    property Visible;                     // 继承：是否可见
    property OnClick;                     // 继承：点击事件
    property OnEnter;                     // 继承：获得焦点事件
    property OnExit;                      // 继承：失去焦点事件
  end;

implementation

const
  // Medium尺寸常量（单位：像素）
  SWITCH_MEDIUM_WIDTH = 36;   // 轨道宽度
  SWITCH_MEDIUM_HEIGHT = 20;  // 轨道高度
  SWITCH_MEDIUM_THUMB = 18;   // 滑块直径
  // Small尺寸常量
  SWITCH_SMALL_WIDTH = 28;    // 轨道宽度
  SWITCH_SMALL_HEIGHT = 16;   // 轨道高度
  SWITCH_SMALL_THUMB = 12;    // 滑块直径

{ TDSkSwitch 构造函数 }
constructor TDSkSwitch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // 初始化字段默认值
  FChecked := False;                    // 默认关闭
  FCaption := '';                       // 默认无标签
  FLabelPlacement := rlpRight;          // 标签默认在右侧
  FColorScheme := muiPrimary;           // 默认主色调
  FSize := sssMedium;                   // 默认中等尺寸
  // 创建并设置字体
  FFont := TFont.Create;
  FFont.Name := GetDefaultFontName;       // 默认字体
  FFont.Size := 10;                     // 默认字号
  FFont.OnChange := FontChanged;        // 字体变化时通知
  FMouseIsDown := False;                // 鼠标未按下
  InvalidateTextCache;                  // 初始化文字缓存
  // 设置默认尺寸
  Width := 80;
  Height := 24;
  TabStop := True;                      // 可接收Tab焦点
  // 设置透明背景（与Radio/Checkbox一样叠加在父容器上）
  CornerRadius := 0;                    // 无圆角（组件本身）
  BackgroundColor := TAlphaColors.Null; // 透明背景
  BorderColor := TAlphaColors.Null;     // 无边框
  BorderWidth := 0;                     // 边框宽度为0
end;

{ 析构函数：释放字体对象 }
destructor TDSkSwitch.Destroy;
begin
  FFont.Free;                           // 释放字体对象
  inherited;
end;

{ 获取轨道宽度：根据当前尺寸返回对应常量 }
function TDSkSwitch.GetTrackWidth: Single;
begin
  if FSize = sssSmall then
    Result := SWITCH_SMALL_WIDTH
  else
    Result := SWITCH_MEDIUM_WIDTH;
end;

{ 获取轨道高度：根据当前尺寸返回对应常量 }
function TDSkSwitch.GetTrackHeight: Single;
begin
  if FSize = sssSmall then
    Result := SWITCH_SMALL_HEIGHT
  else
    Result := SWITCH_MEDIUM_HEIGHT;
end;

{ 获取滑块半径：直径/2 }
function TDSkSwitch.GetThumbRadius: Single;
begin
  if FSize = sssSmall then
    Result := SWITCH_SMALL_THUMB / 2
  else
    Result := SWITCH_MEDIUM_THUMB / 2;
end;

{ 设置开关状态：变化时重绘并触发事件 }
procedure TDSkSwitch.SetChecked(Value: Boolean);
begin
  if FChecked <> Value then             // 只有真正变化时才处理
  begin
    FChecked := Value;
    RequestRedraw;                      // 请求重绘以更新外观
    if Assigned(FOnCheckChanged) then   // 如果有事件处理器
      FOnCheckChanged(Self);            // 触发状态改变事件
  end;
end;

{ 设置标签文字：变化时使缓存失效并重绘 }
procedure TDSkSwitch.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    InvalidateTextCache;                // 文字变化，缓存失效
    RequestRedraw;
  end;
end;

{ 设置标签位置：变化时重绘 }
procedure TDSkSwitch.SetLabelPlacement(Value: TDSkRadioLabelPlacement);
begin
  if FLabelPlacement <> Value then
  begin
    FLabelPlacement := Value;
    RequestRedraw;
  end;
end;

{ 设置颜色主题：变化时重绘 }
procedure TDSkSwitch.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then
  begin
    FColorScheme := Value;
    RequestRedraw;
  end;
end;

{ 设置尺寸：变化时重绘 }
procedure TDSkSwitch.SetSize(Value: TDSkSwitchSize);
begin
  if FSize <> Value then
  begin
    FSize := Value;
    RequestRedraw;
  end;
end;

{ 设置字体：复制新字体值并使缓存失效 }
procedure TDSkSwitch.SetFont(Value: TFont);
begin
  FFont.Assign(Value);                  // 复制字体属性
  InvalidateTextCache;                  // 字体变化，缓存失效
end;

{ 字体改变回调：由FFont.OnChange触发 }
procedure TDSkSwitch.FontChanged(Sender: TObject);
begin
  InvalidateTextCache;
  RequestRedraw;
end;

{ 启用状态改变消息处理：重绘以更新禁用状态外观 }
procedure TDSkSwitch.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  RequestRedraw;
end;

{ 请求重绘：设计时用Invalidate，运行时用Redraw }
procedure TDSkSwitch.RequestRedraw;
begin
  if csLoading in ComponentState then
    Exit;
  Redraw;
end;

{ 是否裁剪窗口区域：返回False表示不裁剪 }
function TDSkSwitch.ShouldClipWindowRegion: Boolean;
begin
  Result := False;
end;

{ 是否依赖父背景：返回False }
function TDSkSwitch.DependsOnParentBackground: Boolean;
begin
  Result := False;
end;

{ 是否依赖父视觉背景：当父是Skia控件且有鼠标跟踪视觉状态时返回True }
function TDSkSwitch.DependsOnParentVisualBackground: Boolean;
begin
  if Parent is TDSCustomSkControl then
    Result := TDSCustomSkControl(Parent).HasVisualStateChangesOnMouseTrack
  else
    Result := False;
end;

{ 绘制入口：清空画布后依次绘制开关和标签 }
procedure TDSkSwitch.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
begin
  ACanvas.Clear($00FFFFFF);             // 清空为透明
  DrawSwitch(ACanvas, ADest);           // 绘制开关（轨道+滑块）
  DrawLabel(ACanvas, ADest);            // 绘制标签文字
end;

{ 绘制开关：包括轨道（圆角矩形）和滑块（圆形）}
procedure TDSkSwitch.DrawSwitch(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LTrackWidth, LTrackHeight, LThumbRadius: Single;  // 轨道宽/高，滑块半径
  LTrackLeft, LTrackTop: Single;        // 轨道左上角坐标
  LTrackRect: TRectF;                   // 轨道矩形区域
  LRoundRect: ISkRoundRect;             // Skia圆角矩形对象
  LPaint: ISkPaint;                     // Skia画笔对象
  LTrackColor: TAlphaColor;             // 轨道颜色
  LThumbCenter: TPointF;                // 滑块中心坐标
  LCornerRadius: Single;                // 轨道圆角半径
begin
  // 获取尺寸参数
  LTrackWidth := GetTrackWidth;
  LTrackHeight := GetTrackHeight;
  LThumbRadius := GetThumbRadius;
  LCornerRadius := LTrackHeight / 2;    // 圆角半径=高度的一半（形成胶囊形状）

  // 根据标签位置计算轨道位置
  case FLabelPlacement of
    rlpRight: begin                     // 标签在右：轨道靠左
      LTrackLeft := ADest.Left;
      LTrackTop := ADest.Top + (ADest.Height - LTrackHeight) / 2; // 垂直居中
    end;
    rlpLeft: begin                      // 标签在左：轨道靠右
      LTrackLeft := ADest.Right - LTrackWidth;
      LTrackTop := ADest.Top + (ADest.Height - LTrackHeight) / 2;
    end;
    rlpTop: begin                       // 标签在上：轨道靠下
      LTrackLeft := ADest.Left + (ADest.Width - LTrackWidth) / 2; // 水平居中
      LTrackTop := ADest.Bottom - LTrackHeight;
    end;
    rlpBottom: begin                    // 标签在下：轨道靠上
      LTrackLeft := ADest.Left + (ADest.Width - LTrackWidth) / 2;
      LTrackTop := ADest.Top;
    end;
  else
    begin                               // 默认：标签在右
      LTrackLeft := ADest.Left;
      LTrackTop := ADest.Top + (ADest.Height - LTrackHeight) / 2;
    end;
  end;

  // 构建轨道矩形
  LTrackRect := RectF(LTrackLeft, LTrackTop, LTrackLeft + LTrackWidth, LTrackTop + LTrackHeight);

  // 确定轨道颜色：禁用/开启/关闭三种状态
  if (not Enabled) or IsParentDisabled then
    LTrackColor := $FFBDBDBD            // 禁用：灰色
  else if FChecked then
  begin
    // 开启：根据颜色主题选择
    case FColorScheme of
      muiSecondary: LTrackColor := $FF9C27B0;  // 紫色
      muiError: LTrackColor := $FFD32F2F;      // 红色
      muiWarning: LTrackColor := $FFED6C02;    // 橙色
      muiInfo: LTrackColor := $FF0288D1;       // 蓝色
      muiSuccess: LTrackColor := $FF2E7D32;    // 绿色
    else
      LTrackColor := $FF1976D2;                // Primary：主蓝色
    end;
  end
  else
    LTrackColor := $FFE0E0E0;           // 关闭：浅灰色

  // 创建画笔并开启抗锯齿
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;

  // 创建圆角矩形（轨道）
  LRoundRect := TSkRoundRect.Create;
  LRoundRect.SetRect(LTrackRect, LCornerRadius, LCornerRadius);

  // 绘制轨道背景
  LPaint.Style := TSkPaintStyle.Fill;
  if (not Enabled) or IsParentDisabled then
    LPaint.Color := (LTrackColor and $00FFFFFF) or $80000000  // 禁用时半透明
  else
    LPaint.Color := LTrackColor;
  ACanvas.DrawRoundRect(LRoundRect, LPaint);

  // 计算滑块中心位置：开启时在右，关闭时在左
  if FChecked then
    LThumbCenter := PointF(LTrackRect.Right - LCornerRadius, LTrackRect.Top + LCornerRadius)
  else
    LThumbCenter := PointF(LTrackRect.Left + LCornerRadius, LTrackRect.Top + LCornerRadius);

  // 绘制滑块阴影（在滑块下方1像素处，增加立体感）
  LPaint.Style := TSkPaintStyle.Fill;
  LPaint.Color := $40000000;            // 25%透明度黑色
  ACanvas.DrawCircle(PointF(LThumbCenter.X, LThumbCenter.Y + 1), LThumbRadius + 0.5, LPaint);

  // 绘制滑块（白色圆形）
  LPaint.Style := TSkPaintStyle.Fill;
  if (not Enabled) or IsParentDisabled then
    LPaint.Color := $FFFFFFFF or $80000000  // 禁用时半透明白
  else
    LPaint.Color := $FFFFFFFF;          // 纯白色
  ACanvas.DrawCircle(LThumbCenter, LThumbRadius, LPaint);
end;

{ 绘制标签文字 }
procedure TDSkSwitch.DrawLabel(const ACanvas: ISkCanvas; const ADest: TRectF);
var
  LFont: ISkFont;                       // Skia字体对象
  LPaint: ISkPaint;                     // Skia画笔对象
  LX, LY: Single;                       // 文字绘制坐标
  LTextW, LTextH: Single;               // 文字宽高
  LTrackWidth: Single;                  // 轨道宽度（用于定位）
begin
  if FCaption = '' then Exit;           // 无文字直接返回
  LFont := GetTextFont;                 // 获取字体（带缓存）
  LTextW := MeasureCaptionText;         // 测量文字宽度（带缓存）
  LTextH := LFont.Size;                 // 文字高度=字体大小
  LTrackWidth := GetTrackWidth;

  // 创建画笔并设置颜色
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  if (not Enabled) or IsParentDisabled then
    LPaint.Color := $FF757575           // 禁用：灰色文字
  else
    LPaint.Color := $DE000000;          // 正常：87%透明度黑色

  // 根据标签位置计算文字坐标
  case FLabelPlacement of
    rlpRight: begin                     // 标签在右：文字在轨道右侧
      LX := ADest.Left + LTrackWidth + 8;  // 8像素间距
      LY := ADest.Top + (ADest.Height - LTextH) / 2 + LTextH; // 垂直居中（Skia文字基线对齐需加高度）
    end;
    rlpLeft: begin                      // 标签在左：文字在轨道左侧
      LX := ADest.Right - LTrackWidth - 8 - LTextW;
      LY := ADest.Top + (ADest.Height - LTextH) / 2 + LTextH;
    end;
    rlpTop: begin                       // 标签在上：文字在轨道上方
      LX := ADest.Left + (ADest.Width - LTextW) / 2; // 水平居中
      LY := ADest.Bottom - GetTrackHeight - 8;
    end;
    rlpBottom: begin                    // 标签在下：文字在轨道下方
      LX := ADest.Left + (ADest.Width - LTextW) / 2;
      LY := ADest.Top + GetTrackHeight + 8 + LTextH;
    end;
  else
    begin                               // 默认：标签在右
      LX := ADest.Left + LTrackWidth + 8;
      LY := ADest.Top + (ADest.Height - LTextH) / 2 + LTextH;
    end;
  end;

  // 绘制文字
  ACanvas.DrawSimpleText(FCaption, LX, LY, LFont, LPaint);
end;

{ 使文字缓存失效：重置所有缓存字段 }
procedure TDSkSwitch.InvalidateTextCache;
begin
  FTextCacheFont := nil;
  FTextCacheTypeface := nil;
  FTextCacheFontName := '';
  FTextCacheFontStyle := [];
  FTextCacheFontSize := -1;
  FTextCachePPI := 0;
  FTextCacheText := '';
  FTextCacheWidth := 0;
end;

{ 获取Skia字体对象：带缓存机制，避免重复创建 }
function TDSkSwitch.GetTextFont: ISkFont;
var
  LFontStyle: TSkFontStyle;             // Skia字体样式
  LPPI: Integer;                        // 当前屏幕PPI
  LFontSize: Single;                    // 字体大小（像素）
begin
  LPPI := GetEffectivePPI;              // 获取有效PPI
  LFontSize := FontSizeToPixels(FFont); // 将字体大小转换为像素

  // 根据VCL字体样式转换为Skia字体样式
  if (fsBold in FFont.Style) and (fsItalic in FFont.Style) then
    LFontStyle := TSkFontStyle.BoldItalic
  else if fsBold in FFont.Style then
    LFontStyle := TSkFontStyle.Bold
  else if fsItalic in FFont.Style then
    LFontStyle := TSkFontStyle.Italic
  else
    LFontStyle := TSkFontStyle.Normal;

  // 检查缓存是否有效：任一参数变化都需要重建
  if (FTextCacheFont = nil) or (FTextCachePPI <> LPPI) or
    (FTextCacheFontName <> FFont.Name) or (FTextCacheFontStyle <> FFont.Style) or
    not SameValue(FTextCacheFontSize, LFontSize) then
  begin
    // 创建新的字形和字体对象
    FTextCacheTypeface := TSkTypeface.MakeFromName(FFont.Name, LFontStyle);
    FTextCacheFont := TSkFont.Create(FTextCacheTypeface, LFontSize);
    // 更新缓存值
    FTextCacheFontName := FFont.Name;
    FTextCacheFontStyle := FFont.Style;
    FTextCacheFontSize := LFontSize;
    FTextCachePPI := LPPI;
    FTextCacheText := '';
    FTextCacheWidth := 0;
  end;
  Result := FTextCacheFont;
end;

{ 测量标签文字宽度：带缓存机制 }
function TDSkSwitch.MeasureCaptionText: Single;
var
  LFont: ISkFont;
begin
  LFont := GetTextFont;
  if FTextCacheText <> FCaption then    // 文字内容变化时重新测量
  begin
    FTextCacheWidth := LFont.MeasureText(FCaption);
    FTextCacheText := FCaption;
  end;
  Result := FTextCacheWidth;
end;

{ 鼠标按下：记录按下状态 }
procedure TDSkSwitch.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FMouseIsDown := True;
end;

{ 鼠标抬起：如果之前按下则切换开关状态 }
procedure TDSkSwitch.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if FMouseIsDown then
  begin
    FMouseIsDown := False;
    Toggle;                             // 切换开关状态
  end;
end;

{ 键盘按下：空格键切换开关 }
procedure TDSkSwitch.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_SPACE then
    Toggle;
end;

{ 点击事件：继承自父类 }
procedure TDSkSwitch.Click;
begin
  inherited;
end;

{ 切换开关状态：调用Setter以触发事件 }
procedure TDSkSwitch.Toggle;
begin
  Checked := not Checked;
end;

end.
