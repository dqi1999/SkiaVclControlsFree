program ProgressBarDebug;

uses
  Vcl.Forms,
  Vcl.Controls,
  Vcl.Graphics,
  System.SysUtils,
  System.Types,
  System.UITypes,
  SkiaVclControls.ProgressBar,
  SkiaVclControls.Panel,
  SkiaVclControls.Types;

{$R *.res}

type
  TDebugForm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    FProgressBar: TDSkProgressBar;
    FLog: TStringList;
    procedure Log(const Msg: string);
    procedure DrawAndLog;
  end;

procedure TDebugForm.Log(const Msg: string);
begin
  FLog.Add(FormatDateTime('hh:nn:ss.zzz', Now) + ' - ' + Msg);
  OutputDebugString(PChar(Msg));
end;

procedure TDebugForm.DrawAndLog;
var
  LFont: ISkFont;
  LMetrics: TSkFontMetrics;
  LText: string;
  LTextW: Single;
  LTrackRect: TRectF;
  LX, LY: Single;
  LGap: Single;
  LPercent: Single;
  ADest: TRectF;
begin
  LPercent := 50;
  LText := Format('%.0f%%', [LPercent]);

  Log('=== ProgressBar Draw Analysis ===');
  Log(Format('Control Size: %d x %d', [FProgressBar.Width, FProgressBar.Height]));
  Log(Format('TrackHeight: %.1f', [FProgressBar.TrackHeight]));
  Log(Format('Text: %s', [LText]));

  // 模拟GetTrackRect
  ADest := RectF(0, 0, FProgressBar.Width, FProgressBar.Height);
  LGap := 4;

  // 计算轨道矩形
  LTrackRect := RectF(
    ADest.Left,
    ADest.Top + (ADest.Height - FProgressBar.TrackHeight) / 2,
    ADest.Right,
    ADest.Top + (ADest.Height + FProgressBar.TrackHeight) / 2);

  Log(Format('ADest: (%.1f, %.1f, %.1f, %.1f)', [ADest.Left, ADest.Top, ADest.Right, ADest.Bottom]));
  Log(Format('TrackRect: (%.1f, %.1f, %.1f, %.1f)', [LTrackRect.Left, LTrackRect.Top, LTrackRect.Right, LTrackRect.Bottom]));

  // 获取字体信息
  LFont := TSkFont.Create(TSkTypeface.MakeFromName('Segoe UI', TSkFontStyle.Normal), 10);
  LFont.GetMetrics(LMetrics);

  Log(Format('Font Metrics - Ascent: %.2f, Descent: %.2f', [LMetrics.Ascent, LMetrics.Descent]));
  Log(Format('Font Height: %.2f', [-LMetrics.Ascent + LMetrics.Descent]));

  LTextW := LFont.MeasureText(LText);
  Log(Format('Text Width: %.2f', [LTextW]));

  // 计算文字位置（水平模式）
  LX := ADest.Left + (ADest.Width - LTextW) / 2;
  LY := LTrackRect.Top - LGap - LMetrics.Descent;

  Log(Format('Calculated Position - LX: %.2f, LY: %.2f', [LX, LY]));
  Log(Format('Text Top (LY + Ascent): %.2f', [LY + LMetrics.Ascent]));
  Log(Format('Text Bottom (LY - Descent): %.2f', [LY - LMetrics.Descent]));

  // 检查是否可见
  if LY + LMetrics.Ascent < 0 then
    Log('WARNING: Text TOP is above control!')
  else
    Log('Text top is within control bounds');

  if LY > ADest.Bottom then
    Log('WARNING: Text BOTTOM is below control!')
  else
    Log('Text bottom is within control bounds');

  // 保存日志
  FLog.SaveToFile('E:\temp\SkiaControls\ProgressBarDebug.log');
  Log('Log saved to ProgressBarDebug.log');
end;

procedure TDebugForm.FormCreate(Sender: TObject);
begin
  FLog := TStringList.Create;

  // 创建ProgressBar
  FProgressBar := TDSkProgressBar.Create(Self);
  FProgressBar.Parent := Self;
  FProgressBar.Left := 20;
  FProgressBar.Top := 50;
  FProgressBar.Width := 300;
  FProgressBar.Height := 20;
  FProgressBar.TrackHeight := 4;
  FProgressBar.ShowLabel := True;
  FProgressBar.Value := 50;

  // 测试不同高度
  Log('=== Test 1: Height=20, TrackHeight=4 ===');
  DrawAndLog;

  // 测试更小的高度
  FProgressBar.Height := 10;
  Log('=== Test 2: Height=10, TrackHeight=4 ===');
  DrawAndLog;

  // 测试更大的高度
  FProgressBar.Height := 40;
  Log('=== Test 3: Height=40, TrackHeight=4 ===');
  DrawAndLog;

  // 显示结果
  ShowMessage('Debug log saved to E:\temp\SkiaControls\ProgressBarDebug.log');
end;

var
  DebugForm: TDebugForm;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  DebugForm := TDebugForm.CreateNew(Application);
  DebugForm.Caption := 'ProgressBar Debug';
  DebugForm.Width := 400;
  DebugForm.Height := 200;
  DebugForm.Position := poScreenCenter;

  Application.Run;
end.
