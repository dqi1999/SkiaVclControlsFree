---
name: skia-vcl-controls
description: 使用 SkiaVclControls 库开发 Delphi VCL Material Design 3 UI。涵盖所有 18 个组件的 API、流式工厂、主题系统和编码规范。当用户在 Delphi 项目中使用 TDSk* 系列控件、编写 MUI 风格界面、或需要组件属性/事件参考时触发。
---

# SkiaVclControls — Material Design 3 VCL 控件库

基于 Delphi 内置 Skia 的 MUI 风格 VCL 组件集。Delphi 11+，Windows，MIT 许可。

## 核心工作流

1. 编辑前先读取相关 `.pas`、`.dfm` 文件，复用项目现有结构
2. 新组件必须加入 `Sources/` 并在 `SkiaVclControls.dpk` 的 `contains` 段注册
3. 设计期组件在 `SkiaVclControls.Register.pas` 中注册到 `SkiaVclControls` 页签
4. 每次变更后运行编译验证：
   ```bash
   E:\temp\SkiaControls\build.bat
   ```
5. 输出 `Compilation successful.` 表示通过
6. 使用 `daofy` Delphi MCP 工具编辑 .pas/.dfm（禁止原生 read/write/edit 修改 Delphi 文件）

## 命名与文件约定

| 约定 | 规则 | 示例 |
|------|------|------|
| 单元文件 | `SkiaVclControls.<功能>.pas` | `SkiaVclControls.Button.pas` |
| 组件类名 | `TDSk` + PascalCase | `TDSkButton`, `TDSkRadioGroup` |
| 枚举类型 | `TDSk` + 功能 + 细分 | `TDSkMUIColorScheme`, `TDSkButtonStyle` |
| 枚举值前缀 | 类型缩写小写 | `muiPrimary`, `bsRoundRect`, `psElevated` |
| 私有字段 | `F` 前缀 | `FBackgroundColor`, `FCornerRadius` |
| 事件类型 | `TDSk` + 功能 + Event | `TDSkSliderChangeEvent`, `TDSkSelectItemClickEvent` |
| Demo Frame | `Demo.Frame.<功能>` | `Demo.Frame.Button` |

## Delphi 保留字规避

| 保留字 | 替换为 | 使用位置 |
|--------|--------|----------|
| `End` | `AlignEnd` | Layout 对齐枚举 |
| `Label` | `Label_` (属性) / `DisplayName` (字段) | Select/Edit 的标签属性 |
| `Label` | `CreateLabel` (方法) | Factory 工厂方法 |

## 已注册组件（18 个）

```
TDSkButton, TDSkPanel, TDSkButtonGroup,
TDSkRadio, TDSkRadioGroup, TDSkSlider,
TDSkCheckbox, TDSkCheckboxGroup,
TDSkSwitch, TDSkSwitchGroup,
TDSkSelect, TDSkEdit,
TDSkProgressBar, TDSkCircularProgress,
TDSkStepper, TDSkTabs, TDSkSnackbar,
TDSkLabel
```

## 组件完整参考

### 基类 — TDSCustomSkControl

```pascal
property CornerRadius: Single;
property CornerRadii[Index: Integer]: Single;
property BackgroundColor: TAlphaColor;
property BorderColor: TAlphaColor;
property BorderWidth: Single;
function DpiScaleValue(AValue: Single): integer;
function DpiScale: Single;
function IsParentDisabled: Boolean;
procedure BeginRedrawLock;
procedure EndRedrawLock;
```

### TDSkPanel — 面板

MUI 容器组件，8 种面板样式（含 MD3 容器色）。

```pascal
Panel1.PanelStyle := psElevated;  // psElevated/psFilled/psOutlined/psSurface/psPrimaryContainer/psSecondaryContainer/psErrorContainer/psStyleNone
Panel1.CornerRadius := 12;
Panel1.Caption := '标题';
Panel1.CaptionPosition := cpTopCenter;  // cpTopLeft/cpTopCenter/cpTopRight/cpLeftCenter/cpCenter/cpRightCenter/cpBottomLeft/cpBottomCenter/cpBottomRight
Panel1.HoverEnabled := True;
Panel1.ChildPadding := 16;
```

**PanelStyle 样式说明**：

| 样式 | 背景色 | 边框 | 默认圆角 | HoverEnabled |
|------|--------|------|----------|--------------|
| `psElevated` | 白色 | 0.5px 浅灰 | 12 | True |
| `psFilled` | 浅灰 #F5F5F5 | 无 | 12 | True |
| `psOutlined` | 白色 | 1px 浅灰 | 12 | True |
| `psSurface` | #FAFAFA | 无 | 12 | True |
| `psPrimaryContainer` | 主色浅底 #E3F2FD | 无 | 12 | True |
| `psSecondaryContainer` | 次色浅底 #F3E5F5 | 无 | 12 | True |
| `psErrorContainer` | 错误色浅底 #FFEBEE | 无 | 12 | True |
| `psStyleNone` | 用户自定义 | 用户自定义 | 0 | False |

### TDSkButton

```pascal
Button1.ButtonText := '提交';
Button1.MUIColorScheme := muiPrimary;
Button1.MUIStyle := muiContained;     // muiContained/muiOutlined/muiText
Button1.HoverEffect := heRipple;      // heNone/heRipple/heGlow/heScaleUp
Button1.ButtonStyle := bsRoundRect;   // bsRectangle/bsRoundRect/bsCircle
Button1.ButtonType := btToggle;       // btNormal/btToggle
Button1.Images := ImageList1;
Button1.ImageIndex := 0;
Button1.ImageAlign := iaLeft;         // iaLeft/iaRight/iaTop/iaBottom/iaCenter
Button1.OnClick := FormClick;
```

### TDSkButtonGroup

```pascal
ButtonGroup1.Orientation := bgoHorizontal;  // bgoHorizontal/bgoVertical
ButtonGroup1.Variant := bgvContained;       // bgvContained/bgvOutlined/bgvText
ButtonGroup1.ColorScheme := muiPrimary;
ButtonGroup1.Exclusive := True;
ButtonGroup1.ItemIndex := 0;
```

### TDSkRadio / TDSkRadioGroup

```pascal
Radio1.Caption := '选项一';
Radio1.Checked := True;
Radio1.ColorScheme := muiPrimary;
Radio1.RadioSize := 20;
Radio1.LabelPlacement := rlpRight;  // rlpTop/rlpBottom/rlpLeft/rlpRight

RadioGroup1.Items.Add('选项A');
RadioGroup1.ItemIndex := 0;
RadioGroup1.Orientation := rgoVertical;  // rgoVertical/rgoHorizontal
RadioGroup1.Scrollable := True;
RadioGroup1.OnItemClick := OnRadioGroupClick;
```

### TDSkCheckbox / TDSkCheckboxGroup

```pascal
Checkbox1.Caption := '同意条款';
Checkbox1.Checked := True;
Checkbox1.Indeterminate := False;
Checkbox1.ColorScheme := muiPrimary;

CheckboxGroup1.Items.Add('苹果');
CheckboxGroup1.Exclusive := False;
CheckboxGroup1.CheckedItems.Add(0);
```

### TDSkSwitch / TDSkSwitchGroup

```pascal
Switch1.Caption := '启用通知';
Switch1.Checked := True;
Switch1.Size := sssMedium;  // sssSmall/sssMedium
Switch1.ColorScheme := muiPrimary;
```

### TDSkEdit

```pascal
Edit1.Label_ := '用户名';
Edit1.Placeholder := '请输入用户名';
Edit1.HelperText := '必填项';
Edit1.ErrorText := '用户名不能为空';
Edit1.Error := False;
Edit1.Clearable := True;
Edit1.Variant := svOutlined;         // svOutlined/svFilled/svUnderline
Edit1.Size := ssMedium;
Edit1.PasswordChar := '*';
Edit1.MaxLength := 50;
Edit1.OnChange := OnEditChange;
```

### TDSkSelect

```pascal
Select1.Items.Add('选项一');
Select1.ItemIndex := 0;
Select1.Label_ := '请选择';
Select1.Variant := svOutlined;
Select1.ColorScheme := muiPrimary;
Select1.Size := ssMedium;           // ssMedium(62px)/ssSmall(46px)
Select1.Error := False;
Select1.ErrorText := '请选择一项';
Select1.Clearable := True;
Select1.MaxDropCount := 8;
Select1.OnItemClick := OnSelectChange;
```

### TDSkSlider

```pascal
Slider1.Min := 0; Slider1.Max := 100; Slider1.Value := 50;
Slider1.Step := 10;                  // 0=连续
Slider1.Orientation := sloHorizontal;  // sloHorizontal/sloVertical
Slider1.ColorScheme := muiPrimary;
Slider1.ShowValueLabel := svldAuto;    // svldAuto/svldOn/svldOff
Slider1.OnChange := OnSliderChange;

Slider1.Range := True;               // 范围模式
Slider1.ValueLow := 20; Slider1.ValueHigh := 80;
Slider1.OnRangeChange := OnRangeChange;
```

### TDSkProgressBar

```pascal
Progress1.Variant := pbvDeterminate; // pbvDeterminate/pbvIndeterminate/pbvBuffer
Progress1.Min := 0; Progress1.Max := 100; Progress1.Value := 60;
Progress1.Orientation := pboHorizontal;  // pboHorizontal/pboVertical
Progress1.ShowLabel := True;
Progress1.ColorScheme := muiPrimary;
```

### TDSkCircularProgress

```pascal
CircProgress1.Value := 75;
CircProgress1.Variant := cpvDeterminate;  // cpvDeterminate/cpvIndeterminate
CircProgress1.Size := 48;
CircProgress1.Thickness := 4;
CircProgress1.ColorScheme := muiPrimary;
CircProgress1.ShowLabel := True;
```

### TDSkStepper

```pascal
Stepper1.ActiveStep := 1;
Stepper1.Orientation := stoHorizontal;  // stoHorizontal/stoVertical
Stepper1.Variant := svLinear;           // svLinear/svNonLinear
Stepper1.LabelLayout := sllStandard;    // sllStandard/sllAlternative
Stepper1.AddStep('基本信息', '填写个人资料');
Stepper1.AddStep('验证', '手机验证');
Stepper1.StepStatus[0] := ssCompleted;  // ssPending/ssActive/ssCompleted/ssError
Stepper1.StepStatus[1] := ssActive;
```

### TDSkTabs

```pascal
Tabs1.AddTab('首页');
Tabs1.AddTab('设置');
Tabs1.ActiveTab := 0;
Tabs1.Orientation := toHorizontal;  // toHorizontal/toVertical
Tabs1.Variant := tvStandard;       // tvStandard/tvBottomNav
Tabs1.Alignment := taCenter;       // taLeft/taCenter/taFullWidth
Tabs1.ColorScheme := muiPrimary;
Tabs1.IndicatorColor := ticPrimary;  // ticPrimary/ticSecondary
Tabs1.TextColor := ttcPrimary;      // ttcPrimary/ttcSecondary
Tabs1.Scrollable := True;
Tabs1.OnTabChange := OnTabChange;
```

### TDSkSnackbar

```pascal
TDSkSnackbar.ShowSnackbar(Self, '操作成功！', snkSuccess);

Snackbar1.Message := '项目已删除';
Snackbar1.Severity := snkNone;      // snkSuccess/snkError/snkWarning/snkInfo/snkNone
Snackbar1.Variant := snvStandard;   // snvStandard/snvFilled/snvOutlined
Snackbar1.Position := spBottomCenter;  // spTopLeft/spTopCenter/spTopRight/spBottomLeft/spBottomCenter/spBottomRight
Snackbar1.AutoHideDuration := 6000;
Snackbar1.ActionText := '撤销';
Snackbar1.Show;
```

### TDSkLabel

```pascal
Label1.Caption := '标题文字';
Label1.Font.Size := 14;
Label1.FontColor := $FF212121;
Label1.TextAlign := ltaLeft;      // ltaLeft/ltaCenter/ltaRight
Label1.VerticalAlign := lvaCenter;  // lvaTop/lvaCenter/lvaBottom
Label1.TextEffect := lteSolid;    // lteSolid/lteGradient
Label1.GradientDirection := lgdHorizontal;  // lgdHorizontal/lgdVertical/lgdDiagonalDown/lgdDiagonalUp
```

## 工具单元

### SkiaVclControls.Compositor — 合成器

```pascal
uses SkiaVclControls.Compositor;

// 暴露 TDSCustomSkControl 的 protected Draw 方法为 public
// 使父容器能够将子控件渲染到自己的 canvas 上
TDSCustomSkControlHelper.RenderToCanvas(ACanvas, ADest, AOpacity);

// 获取 TWinControl 的所有 TDSCustomSkControl 子控件（按 Z-order）
Children := GetSkiaChildControls(ParentControl);
```

### SkiaVclControls.MUIHelper — MUI 配色

MUI 颜色方案辅助单元，提供 `muiPrimary`/`muiSecondary`/`muiError`/`muiWarning`/`muiInfo`/`muiSuccess` 六种预设配色。

## 流式工厂 API — TDSkUI

```pascal
uses SkiaVclControls.Factory;

// 面板
TDSkUI.Panel(Panel1)
  .Elevated         // .Elevated/.Filled/.Outlined/.Surface/.PrimaryContainer/.SecondaryContainer/.ErrorContainer
  .CornerRadius(12)
  .Padding(16)
  .Build;

// 按钮
TDSkUI.Button(Panel1, '提交').Primary.Contained.Ripple.OnClick(DoSubmit).Build;

// 布局
TDSkUI.Row(Panel1).Add(Btn1).Add(Btn2).Gap(16).Center.Build;
TDSkUI.Column(Panel1).Add(Edit1).Gap(12).Start.Build;
```

## 主题系统

```pascal
uses SkiaVclControls.Theme;
Theme.ApplyPreset(tpLight);   // tpLight/tpDark
Theme.BrandColor := $FF1976D2;
Theme.ApplyPreset(tpCustom);
```

## 编码规范要点

### Skia 组件开发要点
- **DPI 逆缩放**: `ACanvas.Concat(TMatrix.CreateScaling(1/Scale, 1/Scale))`
- **重绘**: 用 `Redraw` 而非 `Invalidate`
- **TColor ↔ TAlphaColor**: `TColor ≠ TAlphaColor`，用 `VclColorToAlphaColor` / `AlphaColorToVCLColor` 转换
- **Font.Color 赋值**: 用 `$00` 前缀（如 `$00424242`），不能用 `$FF`
- **字符串转颜色**（运行时）: 用 `StrToInt64Def('$FF' + hex, 0)` 而非 `StrToIntDef`（避免 $FFFxxxxx > MaxInt 导致 RangeError）
- **禁用状态**: `IsParentDisabled or not Enabled` → `LAlpha := 0.38`

### 常见编译错误

| 错误 | 原因 | 修复 |
|------|------|------|
| `E2003` 标识符未找到 | 缺少 `uses` 引用 | 添加 `SkiaVclControls.Types` 等 |
| `E2029` 保留字 | 使用了 `End`/`Label` 等 | 替换为 `AlignEnd`/`Label_` |
| `E2010` 不兼容类型 | `of object` 事件赋值匿名方法 | 使用 `TMethod` 强转 |
| `F1026` 文件路径 | dpk 未包含新单元 | 在 `contains` 段添加 |
| `F2039` 无法创建 .bpl | IDE(bds.exe) 锁定输出文件 | 关闭 IDE 后重试 |
| `ERangeError` | $FF 开头的颜色值运行时 StrToInt > MaxInt | 改用 `StrToInt64Def` |
| `EClassNotFound` | DFM 类未用 RegisterClass 注册 | `initialization` 段加 `RegisterClass` |
| `component named X already exists` | `GetChildren` + DFM 顶级组件双重保存 | 去掉 `GetChildren`，用 `CM_CONTROLCHANGE` + `DoLayout` |
