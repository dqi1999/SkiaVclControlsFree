unit Demo.Frame.Checkbox;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Types,
  SkiaVclControls.Checkbox, SkiaVclControls.CheckboxGroup, SkiaVclControls.RadioGroup,
  System.Skia, Vcl.Skia, Demo.Styles, SkiaVclControls.Base;

type
  TFrameCheckboxDemo = class(TFrame)
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
    lblLayout: TDSkLabel;
    rgLayout: TDSkRadioGroup;
    lblColor: TDSkLabel;
    rgColor: TDSkRadioGroup;
    chkExclusive: TDSkCheckbox;
    lblPreviewTitle: TDSkLabel;
    cgVertical: TDSkCheckboxGroup;
    cgHorizontal: TDSkCheckboxGroup;
    cbStandalone1: TDSkCheckbox;
    cbStandalone2: TDSkCheckbox;
    cbStandalone3: TDSkCheckbox;
    procedure rgLayoutItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgColorItemClick(Sender: TObject; RadioIndex: Integer);
    procedure chkExclusiveCheckChanged(Sender: TObject);
  private
    procedure SetupPanels;
    procedure UpdateCheckboxes;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TFrameCheckboxDemo.Create(AOwner: TComponent);
begin
  inherited;
  SetupPanels;
  ApplyAdminFrameStyle(Self);
end;

procedure TFrameCheckboxDemo.SetupPanels;
begin
  // Header
  pnlHeader.Caption := 'Checkbox Component Demo';
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

procedure TFrameCheckboxDemo.rgLayoutItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateCheckboxes;
end;

procedure TFrameCheckboxDemo.rgColorItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateCheckboxes;
end;

procedure TFrameCheckboxDemo.chkExclusiveCheckChanged(Sender: TObject);
begin
  UpdateCheckboxes;
end;

procedure TFrameCheckboxDemo.UpdateCheckboxes;
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
  
  case rgLayout.ItemIndex of
    0: begin
      cgVertical.Orientation := rgoVertical;
      cgHorizontal.Orientation := rgoHorizontal;
    end;
    1: begin
      cgVertical.Orientation := rgoHorizontal;
      cgHorizontal.Orientation := rgoVertical;
    end;
  end;
  
  cgVertical.ColorScheme := LColor;
  cgHorizontal.ColorScheme := LColor;
  cgVertical.Exclusive := chkExclusive.Checked;
  cgHorizontal.Exclusive := chkExclusive.Checked;
  cbStandalone1.ColorScheme := LColor;
  cbStandalone2.ColorScheme := LColor;
  cbStandalone3.ColorScheme := LColor;
end;

end.
