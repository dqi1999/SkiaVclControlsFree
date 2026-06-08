unit Demo.Frame.Tabs;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Types,
  SkiaVclControls.Tabs, SkiaVclControls.RadioGroup,
  System.Skia, Vcl.Skia, Demo.Styles, SkiaVclControls.Base;

type
  TFrameTabsDemo = class(TFrame)
    lblVariant: TDSkLabel;
    rgVariant: TDSkRadioGroup;
    lblAlignment: TDSkLabel;
    rgAlignment: TDSkRadioGroup;
    lblOrientation: TDSkLabel;
    rgOrientation: TDSkRadioGroup;
    lblColor: TDSkLabel;
    rgColor: TDSkRadioGroup;
    lblPreviewTitle: TDSkLabel;
    tabsMain: TDSkTabs;
    lblInfo: TDSkLabel;
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
    procedure rgVariantItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgAlignmentItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgOrientationItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgColorItemClick(Sender: TObject; RadioIndex: Integer);
    procedure tabsMainItemClick(Sender: TObject; TabIndex: Integer);
  private
    procedure UpdateTabs;
    procedure SetupPanels;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TFrameTabsDemo.Create(AOwner: TComponent);
begin
  inherited;
  SetupPanels;
  ApplyAdminFrameStyle(Self);
end;

procedure TFrameTabsDemo.SetupPanels;
begin
  pnlHeader.Caption := 'Tabs Component Demo';
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

  pnlControl.Caption := '';
  pnlControl.CaptionPosition := cpTopLeft;
  pnlControl.ChildPadding := 16;
  pnlControl.PanelStyle := psElevated;
  pnlControl.BackgroundColor := MD3_SURFACE_CONTAINER;
  pnlControl.CornerRadius := MD3_CORNER_RADIUS_MEDIUM;
  pnlControl.BorderWidth := 0;

  pnlPreview.Caption := '';
  pnlPreview.CaptionPosition := cpTopLeft;
  pnlPreview.ChildPadding := 24;
  pnlPreview.PanelStyle := psOutlined;
  pnlPreview.BackgroundColor := MD3_SURFACE_CONTAINER;
  pnlPreview.CornerRadius := MD3_CORNER_RADIUS_MEDIUM;
  pnlPreview.BorderColor := MD3_OUTLINE;
  pnlPreview.BorderWidth := 1;
end;

procedure TFrameTabsDemo.rgVariantItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateTabs;
end;

procedure TFrameTabsDemo.rgAlignmentItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateTabs;
end;

procedure TFrameTabsDemo.rgOrientationItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateTabs;
end;

procedure TFrameTabsDemo.rgColorItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateTabs;
end;

procedure TFrameTabsDemo.tabsMainItemClick(Sender: TObject; TabIndex: Integer);
begin
  if TabIndex >= 0 then
    lblInfo.Caption := Format('Selected: %s (Index: %d)', 
      [tabsMain.Items[TabIndex], TabIndex])
  else
    lblInfo.Caption := 'Selected: None';
end;

procedure TFrameTabsDemo.UpdateTabs;
var
  LColor: TDSkMUIColorScheme;
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
  
  case rgVariant.ItemIndex of
    0: tabsMain.Variant := tvStandard;
    1: tabsMain.Variant := tvBottomNav;
  end;
  
  case rgAlignment.ItemIndex of
    0: tabsMain.Alignment := taLeft;
    1: tabsMain.Alignment := taCenter;
    2: tabsMain.Alignment := taFullWidth;
  end;
  
  case rgOrientation.ItemIndex of
    0: begin
      tabsMain.Orientation := toHorizontal;
      tabsMain.Width := 600;
      tabsMain.Height := 52;
    end;
    1: begin
      tabsMain.Orientation := toVertical;
      tabsMain.Width := 120;
      tabsMain.Height := 300;
    end;
  end;
  
  tabsMain.ColorScheme := LColor;
end;

end.
