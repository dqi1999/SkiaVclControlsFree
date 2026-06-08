unit SkiaVclControls.Compositor;

interface

uses
  System.Types, System.Classes, Vcl.Controls, System.Skia,
  SkiaVclControls.Base;

type
  { Class helper: 将 protected 的 Draw 方法暴露为 public，
    使父容器能够将子控件的内容渲染到自己的 canvas 上。 }
  TDSCustomSkControlHelper = class helper for TDSCustomSkControl
  public
    procedure RenderToCanvas(const ACanvas: ISkCanvas;
      const ADest: TRectF; const AOpacity: Single);
  end;

{ 获取 AControl 的所有 TDSCustomSkControl 子控件（按 Z-order 底层→顶层） }
function GetSkiaChildControls(AControl: TWinControl): TArray<TDSCustomSkControl>;

implementation

procedure TDSCustomSkControlHelper.RenderToCanvas(
  const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
begin
  Self.Draw(ACanvas, ADest, AOpacity);
end;

function GetSkiaChildControls(AControl: TWinControl): TArray<TDSCustomSkControl>;
var
  i, LCount: Integer;
begin
  LCount := 0;
  SetLength(Result, AControl.ControlCount);
  for i := 0 to AControl.ControlCount - 1 do
    if AControl.Controls[i] is TDSCustomSkControl then
    begin
      Result[LCount] := TDSCustomSkControl(AControl.Controls[i]);
      Inc(LCount);
    end;
  SetLength(Result, LCount);
end;

end.
