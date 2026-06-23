unit SkiaVclControls.Stepper;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Graphics, Vcl.Skia, System.Skia,
  Winapi.Messages, Winapi.Windows,
  SkiaVclControls.Types, SkiaVclControls.Base;

type
  { 步骤项数据 }
  TDSkStepItem = class(TCollectionItem)
  private
    FCaption: string;
    FDescription: string;
    FStatus: TDSkStepStatus;
    FOptional: Boolean;
    procedure SetCaption(const Value: string);
    procedure SetDescription(const Value: string);
    procedure SetStatus(Value: TDSkStepStatus);
    procedure SetOptional(Value: Boolean);
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Caption: string read FCaption write SetCaption;
    property Description: string read FDescription write SetDescription;
    property Status: TDSkStepStatus read FStatus write SetStatus default ssPending;
    property Optional: Boolean read FOptional write SetOptional default False;
  end;

  { 步骤项集合 }
  TDSkStepItems = class(TOwnedCollection)
  private
    FOnChange: TNotifyEvent;
    function GetItem(Index: Integer): TDSkStepItem;
    procedure SetItem(Index: Integer; Value: TDSkStepItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDSkStepItem;
    function Insert(Index: Integer): TDSkStepItem;
    property Items[Index: Integer]: TDSkStepItem read GetItem write SetItem; default;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { 步骤点击事件 }
  TDSkStepperStepClickEvent = procedure(Sender: TObject; StepIndex: Integer) of object;

  { TDSkStepper - MUI 风格步骤条组件 }
  TDSkStepper = class(TDSCustomSkControl)
  private
    FSteps: TDSkStepItems;
    FActiveStep: Integer;
    FOrientation: TDSkStepperOrientation;
    FVariant: TDSkStepperVariant;
    FLabelLayout: TDSkStepperLabelLayout;
    FColorScheme: TDSkMUIColorScheme;
    FStepSize: Single;
    FConnectorThickness: Single;
    FStepSpacing: Single;
    FAutoFit: Boolean;
    FStepFont: TFont;
    FLabelFont: TFont;
    FDescriptionFont: TFont;
    FOnStepClick: TDSkStepperStepClickEvent;
    FHoverIndex: Integer;
    FStepFontCache: ISkFont;
    FStepFontCacheName: string;
    FStepFontCacheSize: Single;
    FStepFontCachePPI: Integer;
    FLabelFontCache: ISkFont;
    FLabelFontCacheName: string;
    FLabelFontCacheSize: Single;
    FLabelFontCachePPI: Integer;
    FDescFontCache: ISkFont;
    FDescFontCacheName: string;
    FDescFontCacheSize: Single;
    FDescFontCachePPI: Integer;
    procedure SetSteps(Value: TDSkStepItems);
    procedure SetActiveStep(Value: Integer);
    procedure SetOrientation(Value: TDSkStepperOrientation);
    procedure SetVariant(Value: TDSkStepperVariant);
    procedure SetLabelLayout(Value: TDSkStepperLabelLayout);
    procedure SetColorScheme(Value: TDSkMUIColorScheme);
    procedure SetStepSize(Value: Single);
    procedure SetConnectorThickness(Value: Single);
    procedure SetStepSpacing(Value: Single);
    procedure SetAutoFit(Value: Boolean);
    procedure SetStepFont(Value: TFont);
    procedure SetLabelFont(Value: TFont);
    procedure SetDescriptionFont(Value: TFont);
    procedure StepFontChanged(Sender: TObject);
    procedure LabelFontChanged(Sender: TObject);
    procedure DescriptionFontChanged(Sender: TObject);
    procedure StepsChanged(Sender: TObject);
    procedure RequestRedraw;
    function GetStepCount: Integer;
    function GetStepRect(Index: Integer): TRectF;
    function GetStepCenter(Index: Integer): TPointF;
    function HitTest(X, Y: Integer): Integer;
    function GetStepColor(AStatus: TDSkStepStatus): TAlphaColor;
    function GetConnectorColor(AFromStatus, AToStatus: TDSkStepStatus): TAlphaColor;
    function GetStepFontCache: ISkFont;
    function GetLabelFontCache: ISkFont;
    function GetDescFontCache: ISkFont;
    procedure InvalidateStepFontCache;
    procedure InvalidateLabelFontCache;
    procedure InvalidateDescFontCache;
    function GetAutoSpacing: Single;
  protected
    procedure Loaded; override;
    procedure Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single); override;
    procedure DrawStep(const ACanvas: ISkCanvas; const ADest: TRectF; Index: Integer);
    procedure DrawStepIcon(const ACanvas: ISkCanvas; const ACenter: TPointF; ASize: Single; AStatus: TDSkStepStatus; AStepNumber: Integer);
    procedure DrawStepLabel(const ACanvas: ISkCanvas; const ACenter: TPointF; ASize: Single; Index: Integer);
    procedure DrawConnector(const ACanvas: ISkCanvas; const AFrom, ATo: TPointF; AFromStatus, AToStatus: TDSkStepStatus);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure Resize; override;
    function DependsOnParentBackground: Boolean; override;
    function DependsOnParentVisualBackground: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ShouldClipWindowRegion: Boolean; override;
    procedure NextStep;
    procedure PrevStep;
    procedure SetStepStatus(AIndex: Integer; AStatus: TDSkStepStatus);
    property StepCount: Integer read GetStepCount;
  published
    property Steps: TDSkStepItems read FSteps write SetSteps;
    property ActiveStep: Integer read FActiveStep write SetActiveStep default 0;
    property Orientation: TDSkStepperOrientation read FOrientation write SetOrientation default stoHorizontal;
    property Variant: TDSkStepperVariant read FVariant write SetVariant default svLinear;
    property LabelLayout: TDSkStepperLabelLayout read FLabelLayout write SetLabelLayout default sllStandard;
    property ColorScheme: TDSkMUIColorScheme read FColorScheme write SetColorScheme default muiPrimary;
    property StepSize: Single read FStepSize write SetStepSize;
    property StepSpacing: Single read FStepSpacing write SetStepSpacing;
    property AutoFit: Boolean read FAutoFit write SetAutoFit default False;
    property ConnectorThickness: Single read FConnectorThickness write SetConnectorThickness;
    property StepFont: TFont read FStepFont write SetStepFont;
    property LabelFont: TFont read FLabelFont write SetLabelFont;
    property DescriptionFont: TFont read FDescriptionFont write SetDescriptionFont;
    property OnStepClick: TDSkStepperStepClickEvent read FOnStepClick write FOnStepClick;
    property CornerRadius stored IsCornerRadiusStored;
    property BackgroundColor;
    property BorderColor;
    property BorderWidth;
    property OnClick;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

implementation

uses
  SkiaVclControls.MUIHelper;

const
  DEFAULT_STEP_SIZE = 32;
  DEFAULT_CONNECTOR_THICKNESS = 2;
  STEP_SPACING = 8;
  LABEL_GAP = 12;
  CONNECTOR_LENGTH = 60;

{ TDSkStepItem }

constructor TDSkStepItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FCaption := '';
  FDescription := '';
  FStatus := ssPending;
  FOptional := False;
end;

procedure TDSkStepItem.Assign(Source: TPersistent);
begin
  if Source is TDSkStepItem then
  begin
    FCaption := TDSkStepItem(Source).Caption;
    FDescription := TDSkStepItem(Source).Description;
    FStatus := TDSkStepItem(Source).Status;
    FOptional := TDSkStepItem(Source).Optional;
    Changed(False);
  end
  else
    inherited;
end;

procedure TDSkStepItem.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(False);
  end;
end;

procedure TDSkStepItem.SetDescription(const Value: string);
begin
  if FDescription <> Value then
  begin
    FDescription := Value;
    Changed(False);
  end;
end;

procedure TDSkStepItem.SetStatus(Value: TDSkStepStatus);
begin
  if FStatus <> Value then
  begin
    FStatus := Value;
    Changed(False);
  end;
end;

procedure TDSkStepItem.SetOptional(Value: Boolean);
begin
  if FOptional <> Value then
  begin
    FOptional := Value;
    Changed(False);
  end;
end;

{ TDSkStepItems }

constructor TDSkStepItems.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TDSkStepItem);
end;

function TDSkStepItems.Add: TDSkStepItem;
begin
  Result := TDSkStepItem(inherited Add);
end;

function TDSkStepItems.Insert(Index: Integer): TDSkStepItem;
begin
  Result := TDSkStepItem(inherited Insert(Index));
end;

function TDSkStepItems.GetItem(Index: Integer): TDSkStepItem;
begin
  Result := TDSkStepItem(inherited GetItem(Index));
end;

procedure TDSkStepItems.SetItem(Index: Integer; Value: TDSkStepItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TDSkStepItems.Update(Item: TCollectionItem);
begin
  inherited;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

{ TDSkStepper }

constructor TDSkStepper.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSteps := TDSkStepItems.Create(Self);
  FSteps.OnChange := StepsChanged;
  FActiveStep := 0;
  FOrientation := stoHorizontal;
  FVariant := svLinear;
  FLabelLayout := sllStandard;
  FColorScheme := muiPrimary;
  FStepSize := DEFAULT_STEP_SIZE;
  FConnectorThickness := DEFAULT_CONNECTOR_THICKNESS;
  FStepSpacing := CONNECTOR_LENGTH;
  FHoverIndex := -1;

  FStepFont := TFont.Create;
  FStepFont.Name := GetDefaultFontName;
  FStepFont.Size := 12;
  FStepFont.Style := [fsBold];
  FStepFont.OnChange := StepFontChanged;

  FLabelFont := TFont.Create;
  FLabelFont.Name := GetDefaultFontName;
  FLabelFont.Size := 12;
  FLabelFont.OnChange := LabelFontChanged;

  FDescriptionFont := TFont.Create;
  FDescriptionFont.Name := GetDefaultFontName;
  FDescriptionFont.Size := 10;
  FDescriptionFont.Color := $00757575; // 灰色
  FDescriptionFont.OnChange := DescriptionFontChanged;

  InvalidateStepFontCache;
  InvalidateLabelFontCache;
  InvalidateDescFontCache;

  Width := 400;
  Height := 80;
  CornerRadius := 0;
  BackgroundColor := TAlphaColors.Null;
  BorderColor := TAlphaColors.Null;
  BorderWidth := 0;

  // 设计期添加默认步骤，让组件拖到窗体后立即可见
  if csDesigning in ComponentState then
  begin
    with FSteps.Add do
    begin
      Caption := 'Step 1';
      Description := 'Basic info';
      Status := ssCompleted;
    end;
    with FSteps.Add do
    begin
      Caption := 'Step 2';
      Description := 'Details';
      Status := ssActive;
    end;
    with FSteps.Add do
    begin
      Caption := 'Step 3';
      Description := 'Confirm';
      Status := ssPending;
    end;
  end;
end;

destructor TDSkStepper.Destroy;
begin
  FSteps.Free;
  FStepFont.Free;
  FLabelFont.Free;
  FDescriptionFont.Free;
  inherited;
end;

procedure TDSkStepper.SetSteps(Value: TDSkStepItems);
begin
  FSteps.Assign(Value);
end;

procedure TDSkStepper.SetActiveStep(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if (FSteps.Count > 0) and (Value >= FSteps.Count) then Value := FSteps.Count - 1;
  if FActiveStep <> Value then
  begin
    FActiveStep := Value;
    RequestRedraw;
  end;
end;

procedure TDSkStepper.SetOrientation(Value: TDSkStepperOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    RequestRedraw;
  end;
end;

procedure TDSkStepper.SetVariant(Value: TDSkStepperVariant);
begin
  if FVariant <> Value then
  begin
    FVariant := Value;
    RequestRedraw;
  end;
end;

procedure TDSkStepper.SetLabelLayout(Value: TDSkStepperLabelLayout);
begin
  if FLabelLayout <> Value then
  begin
    FLabelLayout := Value;
    RequestRedraw;
  end;
end;

procedure TDSkStepper.SetColorScheme(Value: TDSkMUIColorScheme);
begin
  if FColorScheme <> Value then
  begin
    FColorScheme := Value;
    RequestRedraw;
  end;
end;

procedure TDSkStepper.SetStepSize(Value: Single);
begin
  if Value < 16 then Value := 16;
  if Value < 16 then Value := 16;
  if FStepSize <> Value then
  begin
    FStepSize := Value;
    RequestRedraw;
  end;
end;

procedure TDSkStepper.SetConnectorThickness(Value: Single);
begin
  if Value < 1 then Value := 1;
  if FConnectorThickness <> Value then
  begin
    FConnectorThickness := Value;
    RequestRedraw;
  end;
end;

procedure TDSkStepper.SetStepSpacing(Value: Single);
begin
  if Value < 40 then Value := 40;
  if FStepSpacing <> Value then
  begin
    FStepSpacing := Value;
    RequestRedraw;
  end;
end;

procedure TDSkStepper.SetAutoFit(Value: Boolean);
begin
  if FAutoFit <> Value then
  begin
    FAutoFit := Value;
    RequestRedraw;
  end;
end;

procedure TDSkStepper.SetStepFont(Value: TFont);
begin
  FStepFont.Assign(Value);
end;

procedure TDSkStepper.SetLabelFont(Value: TFont);
begin
  FLabelFont.Assign(Value);
end;

procedure TDSkStepper.SetDescriptionFont(Value: TFont);
begin
  FDescriptionFont.Assign(Value);
end;

procedure TDSkStepper.StepFontChanged(Sender: TObject);
begin
  InvalidateStepFontCache;
  RequestRedraw;
end;

procedure TDSkStepper.LabelFontChanged(Sender: TObject);
begin
  InvalidateLabelFontCache;
  RequestRedraw;
end;

procedure TDSkStepper.DescriptionFontChanged(Sender: TObject);
begin
  InvalidateDescFontCache;
  RequestRedraw;
end;

procedure TDSkStepper.StepsChanged(Sender: TObject);
begin
  RequestRedraw;
end;

procedure TDSkStepper.RequestRedraw;
begin
  if CanRedrawNow then
    Redraw;
end;

function TDSkStepper.GetStepCount: Integer;
begin
  Result := FSteps.Count;
end;

function TDSkStepper.GetAutoSpacing: Single;
var
  LAvailableWidth: Single;
  LStepSize: Single;
  LMargin: Single;
  LStepCount: Integer;
  LLastLabelWidth: Single;
begin
  // 计算自动间距
  // 公式：间距 = (可用宽度 - 首尾边距 - 步骤图标总宽度 - 最后一个步骤文字预留宽度) / (步骤数量 - 1)
  LStepCount := FSteps.Count;
  if LStepCount <= 1 then
  begin
    Result := DpiScaleValue(FStepSpacing);
    Exit;
  end;

  LStepSize := DpiScaleValue(FStepSize);
  LMargin := DpiScaleValue(STEP_SPACING) * 2;
  // 为最后一个步骤的文字预留空间（最小 80 像素）
  LLastLabelWidth := 80;

  if FOrientation = stoHorizontal then
  begin
    LAvailableWidth := Width - LMargin - (LStepSize * LStepCount) - LLastLabelWidth;
    Result := LAvailableWidth / (LStepCount - 1);
  end
  else
  begin
    LAvailableWidth := Height - LMargin - (LStepSize * LStepCount);
    Result := LAvailableWidth / (LStepCount - 1);
  end;

  // 确保最小间距
  if Result < DpiScaleValue(40) then
    Result := DpiScaleValue(40);
end;

function TDSkStepper.GetStepRect(Index: Integer): TRectF;
var
  LStepSize: Single;
  LSpacing: Single;
  LX, LY: Single;
begin
  LStepSize := DpiScaleValue(FStepSize);

  // 根据 AutoFit 属性决定使用手动间距还是自动间距
  if FAutoFit then
    LSpacing := GetAutoSpacing
  else
    LSpacing := DpiScaleValue(FStepSpacing);

  if FOrientation = stoHorizontal then
  begin
    LX := DpiScaleValue(STEP_SPACING) + Index * (LStepSize + LSpacing);
    if FLabelLayout = sllAlternative then
      LY := DpiScaleValue(STEP_SPACING)
    else
      LY := (Height - LStepSize) / 2;
    Result := TRectF.Create(LX, LY, LX + LStepSize, LY + LStepSize);
  end
  else
  begin
    LX := DpiScaleValue(STEP_SPACING);
    LY := DpiScaleValue(STEP_SPACING) + Index * (LStepSize + LSpacing);
    Result := TRectF.Create(LX, LY, LX + LStepSize, LY + LStepSize);
  end;
end;

function TDSkStepper.GetStepCenter(Index: Integer): TPointF;
var
  LRect: TRectF;
begin
  LRect := GetStepRect(Index);
  Result := TPointF.Create(LRect.CenterPoint.X, LRect.CenterPoint.Y);
end;

function TDSkStepper.HitTest(X, Y: Integer): Integer;
var
  I: Integer;
  LRect: TRectF;
begin
  Result := -1;
  for I := 0 to FSteps.Count - 1 do
  begin
    LRect := GetStepRect(I);
    if LRect.Contains(TPointF.Create(X, Y)) then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function TDSkStepper.GetStepColor(AStatus: TDSkStepStatus): TAlphaColor;
begin
  if not Enabled then
    Exit($FFBDBDBD);

  case AStatus of
    ssPending: Result := $FFBDBDBD;   // 灰色
    ssActive: Result := GetMUIColor(FColorScheme);  // 主题色
    ssCompleted: Result := GetMUIColor(FColorScheme);  // 主题色
    ssError: Result := GetMUIColor(muiError);  // 红色
  else
    Result := $FFBDBDBD;
  end;
end;

function TDSkStepper.GetConnectorColor(AFromStatus, AToStatus: TDSkStepStatus): TAlphaColor;
begin
  if not Enabled then
    Exit($FFBDBDBD);

  if (AFromStatus = ssCompleted) and (AToStatus in [ssActive, ssCompleted]) then
    Result := GetMUIColor(FColorScheme)  // 主题色
  else
    Result := $FFBDBDBD;  // 灰色
end;

function TDSkStepper.GetStepFontCache: ISkFont;
begin
  if (FStepFontCache = nil) or (FStepFontCacheName <> FStepFont.Name) or
    (FStepFontCacheSize <> FStepFont.Size) or (FStepFontCachePPI <> GetEffectivePPI) then
  begin
    FStepFontCache := TSkFont.Create(TSkTypeface.MakeFromName(FStepFont.Name, TSkFontStyle.Normal), FontSizeToPixels(FStepFont));
    FStepFontCacheName := FStepFont.Name;
    FStepFontCacheSize := FStepFont.Size;
    FStepFontCachePPI := GetEffectivePPI;
  end;
  Result := FStepFontCache;
end;

function TDSkStepper.GetLabelFontCache: ISkFont;
begin
  if (FLabelFontCache = nil) or (FLabelFontCacheName <> FLabelFont.Name) or
    (FLabelFontCacheSize <> FLabelFont.Size) or (FLabelFontCachePPI <> GetEffectivePPI) then
  begin
    FLabelFontCache := TSkFont.Create(TSkTypeface.MakeFromName(FLabelFont.Name, TSkFontStyle.Normal), FontSizeToPixels(FLabelFont));
    FLabelFontCacheName := FLabelFont.Name;
    FLabelFontCacheSize := FLabelFont.Size;
    FLabelFontCachePPI := GetEffectivePPI;
  end;
  Result := FLabelFontCache;
end;

function TDSkStepper.GetDescFontCache: ISkFont;
begin
  if (FDescFontCache = nil) or (FDescFontCacheName <> FDescriptionFont.Name) or
    (FDescFontCacheSize <> FDescriptionFont.Size) or (FDescFontCachePPI <> GetEffectivePPI) then
  begin
    FDescFontCache := TSkFont.Create(TSkTypeface.MakeFromName(FDescriptionFont.Name, TSkFontStyle.Normal), FontSizeToPixels(FDescriptionFont));
    FDescFontCacheName := FDescriptionFont.Name;
    FDescFontCacheSize := FDescriptionFont.Size;
    FDescFontCachePPI := GetEffectivePPI;
  end;
  Result := FDescFontCache;
end;

procedure TDSkStepper.InvalidateStepFontCache;
begin
  FStepFontCache := nil;
  FStepFontCacheName := '';
end;

procedure TDSkStepper.InvalidateLabelFontCache;
begin
  FLabelFontCache := nil;
  FLabelFontCacheName := '';
end;

procedure TDSkStepper.InvalidateDescFontCache;
begin
  FDescFontCache := nil;
  FDescFontCacheName := '';
end;

procedure TDSkStepper.Draw(const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
var
  I: Integer;
  LFrom, LTo: TPointF;
begin
  inherited;
  if FSteps.Count = 0 then Exit;

  // 绘制连接线
  for I := 0 to FSteps.Count - 2 do
  begin
    LFrom := GetStepCenter(I);
    LTo := GetStepCenter(I + 1);
    DrawConnector(ACanvas, LFrom, LTo, FSteps[I].Status, FSteps[I + 1].Status);
  end;

  // 绘制步骤
  for I := 0 to FSteps.Count - 1 do
    DrawStep(ACanvas, ADest, I);
end;

procedure TDSkStepper.DrawStep(const ACanvas: ISkCanvas; const ADest: TRectF; Index: Integer);
var
  LCenter: TPointF;
  LStepSize: Single;
  LStep: TDSkStepItem;
begin
  LStep := FSteps[Index];
  LCenter := GetStepCenter(Index);
  LStepSize := DpiScaleValue(FStepSize);

  // 绘制步骤图标
  DrawStepIcon(ACanvas, LCenter, LStepSize, LStep.Status, Index + 1);

  // 绘制标签
  DrawStepLabel(ACanvas, LCenter, LStepSize, Index);
end;

procedure TDSkStepper.DrawStepIcon(const ACanvas: ISkCanvas; const ACenter: TPointF; ASize: Single; AStatus: TDSkStepStatus; AStepNumber: Integer);
var
  LRadius: Single;
  LRect: TRectF;
  LPaint: ISkPaint;
  LTextPaint: ISkPaint;
  LFont: ISkFont;
  LText: string;
  LTextBounds: TRectF;
  LTextX, LTextY: Single;
begin
  LRadius := ASize / 2;
  LRect := TRectF.Create(ACenter.X - LRadius, ACenter.Y - LRadius,
    ACenter.X + LRadius, ACenter.Y + LRadius);

  // 创建画笔
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;

  // 根据状态绘制背景
  case AStatus of
    ssPending:
      begin
        LPaint.Style := TSkPaintStyle.Stroke;
        LPaint.StrokeWidth := 2;
        LPaint.Color := $FFBDBDBD;
        ACanvas.DrawCircle(ACenter, LRadius - 1, LPaint);
      end;
    ssActive:
      begin
        LPaint.Style := TSkPaintStyle.Fill;
        LPaint.Color := GetStepColor(AStatus);
        ACanvas.DrawCircle(ACenter, LRadius, LPaint);
      end;
    ssCompleted:
      begin
        LPaint.Style := TSkPaintStyle.Fill;
        LPaint.Color := GetStepColor(AStatus);
        ACanvas.DrawCircle(ACenter, LRadius, LPaint);
      end;
    ssError:
      begin
        LPaint.Style := TSkPaintStyle.Fill;
        LPaint.Color := GetStepColor(AStatus);
        ACanvas.DrawCircle(ACenter, LRadius, LPaint);
      end;
  end;

  // 创建文字画笔
  LTextPaint := TSkPaint.Create;
  LTextPaint.AntiAlias := True;

  // 获取字体
  LFont := GetStepFontCache;

  // 根据状态绘制内容
  case AStatus of
    ssPending:
      begin
        // 待处理 - 显示数字（灰色）
        LTextPaint.Color := $FF757575;
        LText := IntToStr(AStepNumber);
        LFont.MeasureText(LText, LTextBounds);
        LTextX := ACenter.X - LTextBounds.Width / 2 - LTextBounds.Left;
        LTextY := ACenter.Y + LTextBounds.Height / 2 - LTextBounds.Bottom;
        ACanvas.DrawSimpleText(LText, LTextX, LTextY, LFont, LTextPaint);
      end;
    ssActive:
      begin
        // 活动 - 显示数字（白色）
        LTextPaint.Color := TAlphaColors.White;
        LText := IntToStr(AStepNumber);
        LFont.MeasureText(LText, LTextBounds);
        LTextX := ACenter.X - LTextBounds.Width / 2 - LTextBounds.Left;
        LTextY := ACenter.Y + LTextBounds.Height / 2 - LTextBounds.Bottom;
        ACanvas.DrawSimpleText(LText, LTextX, LTextY, LFont, LTextPaint);
      end;
    ssCompleted:
      begin
        // 完成 - 显示勾（白色）
        LTextPaint.Color := TAlphaColors.White;
        LTextPaint.Style := TSkPaintStyle.Stroke;
        LTextPaint.StrokeWidth := 2;
        LTextPaint.StrokeCap := TSkStrokeCap.Round;
        // 绘制勾
        ACanvas.DrawLine(ACenter.X - LRadius * 0.3, ACenter.Y,
          ACenter.X - LRadius * 0.05, ACenter.Y + LRadius * 0.3, LTextPaint);
        ACanvas.DrawLine(ACenter.X - LRadius * 0.05, ACenter.Y + LRadius * 0.3,
          ACenter.X + LRadius * 0.35, ACenter.Y - LRadius * 0.25, LTextPaint);
      end;
    ssError:
      begin
        // 错误 - 显示叉（白色）
        LTextPaint.Color := TAlphaColors.White;
        LTextPaint.Style := TSkPaintStyle.Stroke;
        LTextPaint.StrokeWidth := 2;
        LTextPaint.StrokeCap := TSkStrokeCap.Round;
        // 绘制叉
        ACanvas.DrawLine(ACenter.X - LRadius * 0.25, ACenter.Y - LRadius * 0.25,
          ACenter.X + LRadius * 0.25, ACenter.Y + LRadius * 0.25, LTextPaint);
        ACanvas.DrawLine(ACenter.X + LRadius * 0.25, ACenter.Y - LRadius * 0.25,
          ACenter.X - LRadius * 0.25, ACenter.Y + LRadius * 0.25, LTextPaint);
      end;
  end;
end;

procedure TDSkStepper.DrawStepLabel(const ACanvas: ISkCanvas; const ACenter: TPointF; ASize: Single; Index: Integer);
var
  LStep: TDSkStepItem;
  LFont: ISkFont;
  LDescFont: ISkFont;
  LPaint: ISkPaint;
  LTextBounds: TRectF;
  LX, LY: Single;
  LMaxWidth: Single;
  LText: string;
  LDescText: string;
begin
  LStep := FSteps[Index];
  if (LStep.Caption = '') and (LStep.Description = '') then Exit;

  LFont := GetLabelFontCache;
  LDescFont := GetDescFontCache;

  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;

  if FOrientation = stoHorizontal then
  begin
    // 计算可用宽度（步骤图标右侧到下一个步骤中心）
    if FAutoFit then
      LMaxWidth := GetAutoSpacing - DpiScaleValue(LABEL_GAP)
    else
      LMaxWidth := DpiScaleValue(FStepSpacing) - DpiScaleValue(LABEL_GAP);

    if FLabelLayout = sllAlternative then
    begin
      // 备选布局 - 标签在图标下方
      if LStep.Caption <> '' then
      begin
        LPaint.Color := $FF212121;
        LText := LStep.Caption;
        // 截断过长的文字
        LFont.MeasureText(LText, LTextBounds);
        while (LTextBounds.Width > LMaxWidth) and (Length(LText) > 1) do
        begin
          SetLength(LText, Length(LText) - 1);
          LFont.MeasureText(LText + '...', LTextBounds);
        end;
        if Length(LText) < Length(LStep.Caption) then
          LText := LText + '...';
        LFont.MeasureText(LText, LTextBounds);
        LX := ACenter.X - LTextBounds.Width / 2 - LTextBounds.Left;
        LY := ACenter.Y + ASize / 2 + DpiScaleValue(STEP_SPACING);
        ACanvas.DrawSimpleText(LText, LX, LY, LFont, LPaint);
      end;
      if LStep.Description <> '' then
      begin
        LPaint.Color := $FF757575;
        LDescText := LStep.Description;
        // 截断过长的文字
        LDescFont.MeasureText(LDescText, LTextBounds);
        while (LTextBounds.Width > LMaxWidth) and (Length(LDescText) > 1) do
        begin
          SetLength(LDescText, Length(LDescText) - 1);
          LDescFont.MeasureText(LDescText + '...', LTextBounds);
        end;
        if Length(LDescText) < Length(LStep.Description) then
          LDescText := LDescText + '...';
        LDescFont.MeasureText(LDescText, LTextBounds);
        LX := ACenter.X - LTextBounds.Width / 2 - LTextBounds.Left;
        LY := ACenter.Y + ASize / 2 + DpiScaleValue(STEP_SPACING) + LFont.Size + DpiScaleValue(4);
        ACanvas.DrawSimpleText(LDescText, LX, LY, LDescFont, LPaint);
      end;
    end
    else
    begin
      // 标准布局 - 标签在右侧
      if LStep.Caption <> '' then
      begin
        LPaint.Color := $FF212121;
        LText := LStep.Caption;
        // 截断过长的文字
        LFont.MeasureText(LText, LTextBounds);
        while (LTextBounds.Width > LMaxWidth) and (Length(LText) > 1) do
        begin
          SetLength(LText, Length(LText) - 1);
          LFont.MeasureText(LText + '...', LTextBounds);
        end;
        if Length(LText) < Length(LStep.Caption) then
          LText := LText + '...';
        LX := ACenter.X + ASize / 2 + DpiScaleValue(LABEL_GAP);
        LY := ACenter.Y - LFont.Size / 2;
        ACanvas.DrawSimpleText(LText, LX, LY, LFont, LPaint);
      end;
      if LStep.Description <> '' then
      begin
        LPaint.Color := $FF757575;
        LDescText := LStep.Description;
        // 截断过长的文字
        LDescFont.MeasureText(LDescText, LTextBounds);
        while (LTextBounds.Width > LMaxWidth) and (Length(LDescText) > 1) do
        begin
          SetLength(LDescText, Length(LDescText) - 1);
          LDescFont.MeasureText(LDescText + '...', LTextBounds);
        end;
        if Length(LDescText) < Length(LStep.Description) then
          LDescText := LDescText + '...';
        LX := ACenter.X + ASize / 2 + DpiScaleValue(LABEL_GAP);
        LY := ACenter.Y + LFont.Size / 2 + DpiScaleValue(4);
        ACanvas.DrawSimpleText(LDescText, LX, LY, LDescFont, LPaint);
      end;
    end;
  end
  else
  begin
    // 垂直布局 - 标签在右侧（允许较长文字）
    if LStep.Caption <> '' then
    begin
      LPaint.Color := $FF212121;
      LText := LStep.Caption;
      LX := ACenter.X + ASize / 2 + DpiScaleValue(LABEL_GAP);
      LY := ACenter.Y - LFont.Size / 2;
      ACanvas.DrawSimpleText(LText, LX, LY, LFont, LPaint);
    end;
    if LStep.Description <> '' then
    begin
      LPaint.Color := $FF757575;
      LX := ACenter.X + ASize / 2 + DpiScaleValue(LABEL_GAP);
      LY := ACenter.Y + LFont.Size / 2 + DpiScaleValue(4);
      ACanvas.DrawSimpleText(LStep.Description, LX, LY, LDescFont, LPaint);
    end;
  end;
end;

procedure TDSkStepper.DrawConnector(const ACanvas: ISkCanvas; const AFrom, ATo: TPointF; AFromStatus, AToStatus: TDSkStepStatus);
var
  LPaint: ISkPaint;
  LColor: TAlphaColor;
begin
  LPaint := TSkPaint.Create;
  LPaint.AntiAlias := True;
  LPaint.Style := TSkPaintStyle.Stroke;
  LPaint.StrokeWidth := DpiScaleValue(FConnectorThickness);
  LPaint.StrokeCap := TSkStrokeCap.Round;

  LColor := GetConnectorColor(AFromStatus, AToStatus);
  LPaint.Color := LColor;

  // 根据方向绘制连接线
  if FOrientation = stoHorizontal then
  begin
    // 水平连接线 - 从当前步骤图标右侧到下一步骤图标左侧
    ACanvas.DrawLine(AFrom.X + DpiScaleValue(FStepSize) / 2,
      AFrom.Y,
      ATo.X - DpiScaleValue(FStepSize) / 2,
      ATo.Y,
      LPaint);
  end
  else
  begin
    // 垂直连接线 - 从当前步骤图标底部到下一步骤图标顶部
    ACanvas.DrawLine(AFrom.X,
      AFrom.Y + DpiScaleValue(FStepSize) / 2,
      ATo.X,
      ATo.Y - DpiScaleValue(FStepSize) / 2,
      LPaint);
  end;
end;

procedure TDSkStepper.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LIndex: Integer;
begin
  inherited;
  if Button = mbLeft then
  begin
    LIndex := HitTest(X, Y);
    if (LIndex >= 0) and (LIndex < FSteps.Count) then
    begin
      if FVariant = svNonLinear then
      begin
        // 非线性模式 - 直接跳转
        FActiveStep := LIndex;
        RequestRedraw;
        if Assigned(FOnStepClick) then
          FOnStepClick(Self, LIndex);
      end
      else
      begin
        // 线性模式 - 只能点击已完成或当前步骤
        if (LIndex <= FActiveStep) or (FSteps[LIndex].Status = ssCompleted) then
        begin
          FActiveStep := LIndex;
          RequestRedraw;
          if Assigned(FOnStepClick) then
            FOnStepClick(Self, LIndex);
        end;
      end;
    end;
  end;
end;

procedure TDSkStepper.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  LIndex: Integer;
begin
  inherited;
  LIndex := HitTest(X, Y);
  if LIndex <> FHoverIndex then
  begin
    FHoverIndex := LIndex;
    // 可以在这里添加悬停效果
  end;
end;

procedure TDSkStepper.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FHoverIndex := -1;
end;

procedure TDSkStepper.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  RequestRedraw;
end;

procedure TDSkStepper.Resize;
begin
  inherited;
  RequestRedraw;
end;

function TDSkStepper.DependsOnParentBackground: Boolean;
begin
  Result := True;
end;

function TDSkStepper.DependsOnParentVisualBackground: Boolean;
begin
  Result := False;
end;

function TDSkStepper.ShouldClipWindowRegion: Boolean;
begin
  Result := True;
end;

procedure TDSkStepper.Loaded;
begin
  inherited;
end;

procedure TDSkStepper.NextStep;
begin
  if FSteps.Count = 0 then
    Exit;

  if FActiveStep < FSteps.Count - 1 then
  begin
    FSteps[FActiveStep].Status := ssCompleted;
    Inc(FActiveStep);
    FSteps[FActiveStep].Status := ssActive;
    RequestRedraw;
  end
  else
  begin
    // 已经停在最后一步时，再执行 Next 表示流程完成，
    // 需要把最后一步也切换为 Completed，才能绘制白色勾图标。
    FSteps[FActiveStep].Status := ssCompleted;
    RequestRedraw;
  end;
end;

procedure TDSkStepper.PrevStep;
begin
  if FActiveStep > 0 then
  begin
    FSteps[FActiveStep].Status := ssPending;
    Dec(FActiveStep);
    FSteps[FActiveStep].Status := ssActive;
    RequestRedraw;
  end;
end;

procedure TDSkStepper.SetStepStatus(AIndex: Integer; AStatus: TDSkStepStatus);
begin
  if (AIndex >= 0) and (AIndex < FSteps.Count) then
  begin
    FSteps[AIndex].Status := AStatus;
    RequestRedraw;
  end;
end;

end.
