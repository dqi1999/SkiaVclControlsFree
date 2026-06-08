unit Demo.Frame.Switch;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Types,
  SkiaVclControls.Switch, SkiaVclControls.SwitchGroup, SkiaVclControls.RadioGroup,
  System.Skia, Vcl.Skia, Demo.Styles, SkiaVclControls.Base;

type
  TFrameSwitchDemo = class(TFrame)
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
    lblSize: TDSkLabel;
    rgSize: TDSkRadioGroup;
    lblLayout: TDSkLabel;
    rgLayout: TDSkRadioGroup;
    lblColor: TDSkLabel;
    rgColor: TDSkRadioGroup;
    lblPreviewTitle: TDSkLabel;
    sgVertical: TDSkSwitchGroup;
    sgHorizontal: TDSkSwitchGroup;
    swStandalone1: TDSkSwitch;
    swStandalone2: TDSkSwitch;
    swStandalone3: TDSkSwitch;
    procedure rgSizeItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgLayoutItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgColorItemClick(Sender: TObject; RadioIndex: Integer);
  private
    procedure SetupPanels;
    procedure UpdateSwitches;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TFrameSwitchDemo.Create(AOwner: TComponent);
begin
  inherited;
  SetupPanels;
  ApplyAdminFrameStyle(Self);
end;

procedure TFrameSwitchDemo.rgSizeItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateSwitches;
end;

procedure TFrameSwitchDemo.rgLayoutItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateSwitches;
end;

procedure TFrameSwitchDemo.rgColorItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateSwitches;
end;

procedure TFrameSwitchDemo.UpdateSwitches;
var
  LColor: TDSkMUIColorScheme;
  LSize: TDSkSwitchSize;
begin
  case rgColor.ItemIndex of
    1: LColor := muiSecondary;
    2: LColor := muiError;
    3: LColor := muiWarning;
    4: LColor := muiInfo;
    5: LColor := muiSuccess;
  else
    LColor := muiPrimary;
  end;
  
  if rgSize.ItemIndex = 1 then
    LSize := sssSmall
  else
    LSize := sssMedium;
  
  case rgLayout.ItemIndex of
    0: begin
      sgVertical.Orientation := rgoVertical;
      sgHorizontal.Orientation := rgoHorizontal;
    end;
    1: begin
      sgVertical.Orientation := rgoHorizontal;
      sgHorizontal.Orientation := rgoVertical;
    end;
  end;
  
  sgVertical.ColorScheme := LColor;
  sgHorizontal.ColorScheme := LColor;
  sgVertical.Size := LSize;
  sgHorizontal.Size := LSize;
  swStandalone1.ColorScheme := LColor;
  swStandalone2.ColorScheme := LColor;
  swStandalone3.ColorScheme := LColor;
  swStandalone1.Size := LSize;
  swStandalone2.Size := LSize;
  swStandalone3.Size := LSize;
end;

procedure TFrameSwitchDemo.SetupPanels;
begin
  // Header
  pnlHeader.Caption := 'Switch Component Demo';
  pnlHeader.CaptionPosition := cpLeftCenter;
  pnlHeader.CaptionFont.Size := 20;
  pnlHeader.CaptionFont.Style := [fsBold];
  pnlHeader.CaptionMargin := 24;
  pnlHeader.ChildPadding := 8;
  pnlHeader.PanelStyle := psSurface;
  pnlHeader.CornerRadius := 0;
  pnlHeader.BorderWidth := 0;

  // Control panel
  pnlControl.Caption := '';
  pnlControl.ChildPadding := 16;
  pnlControl.PanelStyle := psElevated;
  pnlControl.CornerRadius := MD3_CORNER_RADIUS_MEDIUM;
  pnlControl.BorderWidth := 0;

  // Preview panel
  pnlPreview.Caption := '';
  pnlPreview.ChildPadding := 24;
  pnlPreview.PanelStyle := psOutlined;
  pnlPreview.CornerRadius := MD3_CORNER_RADIUS_MEDIUM;
  pnlPreview.BorderColor := MD3_OUTLINE;
  pnlPreview.BorderWidth := 1;
end;

end.
