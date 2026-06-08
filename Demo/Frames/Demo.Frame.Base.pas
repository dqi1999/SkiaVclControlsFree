unit Demo.Frame.Base;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics,
  SkiaVclControls.Panel, SkiaVclControls.Types, System.Skia, Vcl.Skia,
  SkiaVclControls.Base, Demo.Styles;

type
  IDemoFrame = interface
    ['{A8B5C3D2-E1F0-4A6B-9C8D-7E6F5A4B3C2D}']
    function GetTitle: string;
    function GetDescription: string;
    procedure ResetState;
  end;

  TDemoBaseFrame = class(TFrame, IDemoFrame)
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
  protected
    function GetFrameTitle: string; virtual;
    function GetFrameDescription: string; virtual;
    procedure DoResetState; virtual;
    procedure SetupPanels; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    function GetTitle: string;
    function GetDescription: string;
    procedure ResetState;
  end;

implementation

{$R *.dfm}

constructor TDemoBaseFrame.Create(AOwner: TComponent);
begin
  inherited;
  SetupPanels;
end;

procedure TDemoBaseFrame.SetupPanels;
begin
  // Header
  pnlHeader.Caption := GetFrameTitle;
  pnlHeader.CaptionPosition := cpLeftCenter;
  pnlHeader.CaptionFont.Size := 20;
  pnlHeader.CaptionFont.Style := [fsBold];
  pnlHeader.CaptionFont.Name := '微软雅黑';
  pnlHeader.CaptionMargin := 24;
  pnlHeader.ChildPadding := 8;
  pnlHeader.PanelStyle := psSurface;
  pnlHeader.BackgroundColor := MD3_SURFACE_CONTAINER;
  pnlHeader.CornerRadius := 0;
  pnlHeader.BorderWidth := 0;

  // Control panel
  pnlControl.Caption := '';
  pnlControl.CaptionPosition := cpTopLeft;
  pnlControl.ChildPadding := 16;
  pnlControl.PanelStyle := psElevated;
  pnlControl.BackgroundColor := MD3_SURFACE_CONTAINER;
  pnlControl.CornerRadius := MD3_CORNER_RADIUS_MEDIUM;
  pnlControl.BorderWidth := 0;

  // Preview panel
  pnlPreview.Caption := '';
  pnlPreview.CaptionPosition := cpTopLeft;
  pnlPreview.ChildPadding := 24;
  pnlPreview.PanelStyle := psOutlined;
  pnlPreview.BackgroundColor := MD3_SURFACE_CONTAINER;
  pnlPreview.CornerRadius := MD3_CORNER_RADIUS_MEDIUM;
  pnlPreview.BorderColor := MD3_OUTLINE;
  pnlPreview.BorderWidth := 1;
end;

function TDemoBaseFrame.GetFrameTitle: string;
begin
  Result := 'Demo Component';
end;

function TDemoBaseFrame.GetFrameDescription: string;
begin
  Result := 'Component demonstration';
end;

function TDemoBaseFrame.GetTitle: string;
begin
  Result := GetFrameTitle;
end;

function TDemoBaseFrame.GetDescription: string;
begin
  Result := GetFrameDescription;
end;

procedure TDemoBaseFrame.DoResetState;
begin
  // 子类重写
end;

procedure TDemoBaseFrame.ResetState;
begin
  DoResetState;
end;

end.
