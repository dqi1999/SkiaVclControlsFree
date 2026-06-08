unit SkiaVclControls.Types;

interface

uses
  System.UITypes;

type
  { 按钮形状样式 }
  TDSkButtonStyle = (
    bsRectangle,    // 矩形按钮
    bsRoundRect,    // 圆角矩形
    bsCircle        // 圆形按钮
  );

  { 按钮类型 }
  TDSkButtonType = (
    btNormal,       // 普通按钮
    btToggle        // 切换按钮
  );

  { 图像对齐方式 }
  TDSkImageAlign = (
    iaLeft,         // 图像在左
    iaRight,        // 图像在右
    iaTop,          // 图像在上
    iaBottom,       // 图像在下
    iaCenter        // 图像居中
  );

  { 标题位置（九宫格） }
  TDSkCaptionPosition = (
    cpTopLeft,      // 左上
    cpTopCenter,    // 上中
    cpTopRight,     // 右上
    cpLeftCenter,   // 左中
    cpCenter,       // 正中
    cpRightCenter,  // 右中
    cpBottomLeft,   // 左下
    cpBottomCenter, // 下中
    cpBottomRight   // 右下
  );

  { MUI 颜色方案 }
  TDSkMUIColorScheme = (
    muiPrimary,     // 主要 - 蓝色
    muiSecondary,   // 次要 - 紫色
    muiError,       // 错误 - 红色
    muiWarning,     // 警告 - 橙色
    muiInfo,        // 信息 - 浅蓝
    muiSuccess,     // 成功 - 绿色
    muiSchemeNone   // 不使用 MUI 配色
  );

  { MUI 按钮样式 }
  TDSkMUIStyle = (
    muiContained,   // 填充按钮
    muiOutlined,    // 轮廓按钮
    muiText,        // 文字按钮
    muiStyleNone    // 不使用 MUI 样式
  );

  { Label 文字填充效果 }
  TDSkLabelTextEffect = (
    lteSolid,        // 纯色填充（默认）
    lteGradient      // 线性渐变填充
  );

  { Label 渐变方向 }
  TDSkLabelGradientDirection = (
    lgdHorizontal,   // 从左到右
    lgdVertical,     // 从上到下
    lgdDiagonalDown, // 左上到右下
    lgdDiagonalUp    // 左下到右上
  );

  { Label 水平对齐方式 }
  TDSkLabelTextAlign = (
    ltaLeft,         // 左对齐
    ltaCenter,       // 水平居中
    ltaRight         // 右对齐
  );

  { Label 垂直对齐方式 }
  TDSkLabelVerticalAlign = (
    lvaTop,          // 顶部对齐
    lvaCenter,       // 垂直居中
    lvaBottom        // 底部对齐
  );

  { 悬停动画效果 }
  TDSkHoverEffect = (
    heNone,         // 无效果
    heRipple,       // 涟漪效果（从中心扩散的白色脉冲）
    heGlow,         // 发光边框效果
    heScaleUp       // 悬停放大效果
  );

  { Panel Material Design 3 容器样式 }
  TDSkPanelStyle = (
    psElevated,           // 浮起卡片 - 白底+微边框模拟阴影
    psFilled,             // 填充样式 - 表面变体色底
    psOutlined,           // 轮廓样式 - 白底+细边框
    psSurface,            // 表面样式 - 最低层级
    psPrimaryContainer,   // 主色容器 - 主色浅底
    psSecondaryContainer, // 次色容器 - 次色浅底
    psErrorContainer,     // 错误容器 - 错误色浅底
    psStyleNone           // 不使用预设样式
  );


  { ButtonGroup 方向 }
  TDSkButtonGroupOrientation = (
    bgoHorizontal,  // 水平排列
    bgoVertical     // 垂直排列
  );

  { ButtonGroup 变体样式 }
  TDSkButtonGroupVariant = (
    bgvContained,   // 填充样式（实心背景）
    bgvOutlined,    // 轮廓样式（边框）
    bgvText         // 文字样式（无背景无边框）
  );

  { ButtonGroup 大小 }
  TDSkButtonGroupSize = (
    bgsSmall,       // 小号
    bgsMedium,      // 中号（默认）
    bgsLarge        // 大号
  );

  { Radio 标签放置 }
  TDSkRadioLabelPlacement = (
    rlpTop,     // 标签在上
    rlpBottom,  // 标签在下
    rlpLeft,    // 标签在左
    rlpRight    // 标签在右（默认）
  );

  { RadioGroup 布局方向 }
  TDSkRadioGroupOrientation = (
    rgoVertical,   // 垂直排列（默认）
    rgoHorizontal  // 水平排列
  );

  { Slider 方向 }
  TDSkSliderOrientation = (
    sloHorizontal,  // 水平滑块（默认）
    sloVertical     // 垂直滑块
  );

  { Slider 值标签显示方式 }
  TDSkSliderValueLabelDisplay = (
    svldAuto,       // 自动显示（悬停/拖动时显示）
    svldOn,         // 始终显示
    svldOff         // 从不显示
  );

  { Slider 轨道显示方式 }
  TDSkSliderTrack = (
    stNormal,       // 正常轨道（默认）
    stFalse,        // 不显示轨道
    stInverted      // 反转轨道
  );

  { Switch 尺寸 }
  TDSkSwitchSize = (
    sssSmall,       // 小号
    sssMedium       // 中号（默认）
  );

  { ProgressBar 变体 }
  TDSkProgressBarVariant = (
    pbvDeterminate,      // 定量进度条（显示具体进度值）
    pbvIndeterminate,    // 不定量进度条（循环动画，表示加载中）
    pbvBuffer            // 缓冲进度条（显示进度值 + 缓冲值）
  );

  { ProgressBar 方向 }
  TDSkProgressBarOrientation = (
    pboHorizontal,       // 水平（默认）
    pboVertical          // 垂直
  );

  { CircularProgress 变体 }
  TDSkCircularProgressVariant = (
    cpvDeterminate,      // 定量环形进度（显示具体进度值）
    cpvIndeterminate     // 不定量环形进度（旋转动画，表示加载中）
  );

  { Stepper 方向 }
  TDSkStepperOrientation = (
    stoHorizontal,  // 水平步骤条（默认）
    stoVertical     // 垂直步骤条
  );

  { Stepper 步骤状态 }
  TDSkStepStatus = (
    ssPending,      // 待处理 - 灰色圆圈
    ssActive,       // 活动 - 主题色圆圈
    ssCompleted,    // 完成 - 主题色填充 + 白色勾
    ssError         // 错误 - 红色圆圈 + 白色叉
  );

  { Stepper 变体样式 }
  TDSkStepperVariant = (
    svLinear,       // 线性步骤条 - 必须按顺序完成
    svNonLinear     // 非线性步骤条 - 可任意跳转
  );

  { Stepper 标签布局 }
  TDSkStepperLabelLayout = (
    sllStandard,    // 标准布局 - 标签在右侧（水平）或下方（垂直）
    sllAlternative  // 备选布局 - 标签在图标下方（仅水平有效）
  );

  { Tabs 变体样式（外观） }
  TDSkTabsVariant = (
    tvStandard,     // 标准样式 - 纯文字+底部指示条
    tvBottomNav     // 底部导航样式 - 图标+文字+背景色+选中指示条
  );

  { Tabs 对齐方式（位置） }
  TDSkTabsAlignment = (
    taLeft,         // 靠左排列
    taCenter,       // 居中排列
    taFullWidth     // 全宽排列（标签平分容器宽度）
  );

  { Tabs 方向 }
  TDSkTabsOrientation = (
    toHorizontal,   // 水平选项卡（默认）
    toVertical      // 垂直选项卡
  );

  { Tabs 指示器颜色 }
  TDSkTabIndicatorColor = (
    ticPrimary,     // 主要色（默认）
    ticSecondary    // 次要色
  );

  { Tabs 文本颜色 }
  TDSkTabTextColor = (
    ttcPrimary,     // 主要色（默认）
    ttcSecondary    // 次要色
  );

  { Snackbar 位置 }
  TDSkSnackbarPosition = (
    spTopLeft,      // 左上
    spTopCenter,    // 上中
    spTopRight,     // 右上
    spBottomLeft,   // 左下
    spBottomCenter, // 下中（默认）
    spBottomRight   // 右下
  );

  { Snackbar 严重程度 }
  TDSkSnackbarSeverity = (
    snkSuccess,     // 成功 - 绿色
    snkError,       // 错误 - 红色
    snkWarning,     // 警告 - 橙色
    snkInfo,        // 信息 - 蓝色
    snkNone         // 无（默认深灰色）
  );

  { Snackbar 变体 }
  TDSkSnackbarVariant = (
    snvStandard,    // 标准样式（背景色）
    snvFilled,      // 填充样式（深色背景）
    snvOutlined     // 轮廓样式（边框）
  );

implementation

end.
