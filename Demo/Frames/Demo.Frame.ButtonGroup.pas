unit Demo.Frame.ButtonGroup;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Button, SkiaVclControls.Types,
  SkiaVclControls.ButtonGroup, SkiaVclControls.RadioGroup, SkiaVclControls.Checkbox,
  System.Skia, Vcl.Skia, Demo.Styles, SkiaVclControls.Base;

type
  TFrameButtonGroupDemo = class(TFrame)
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
    lblOrientation: TDSkLabel;
    rgOrientation: TDSkRadioGroup;
    lblVariant: TDSkLabel;
    rgVariant: TDSkRadioGroup;
    lblSize: TDSkLabel;
    rgSize: TDSkRadioGroup;
    lblColor: TDSkLabel;
    rgColor: TDSkRadioGroup;
    chkExclusive: TDSkCheckbox;
    chkFullWidth: TDSkCheckbox;
    lblPreviewTitle: TDSkLabel;
    btnGroupMain: TDSkButtonGroup;
    btnGroupItem1: TDSkButton;
    btnGroupItem2: TDSkButton;
    btnGroupItem3: TDSkButton;
    btnGroupItem4: TDSkButton;
    btnGroupVertical: TDSkButtonGroup;
    btnVertItem1: TDSkButton;
    btnVertItem2: TDSkButton;
    btnVertItem3: TDSkButton;
    btnVertItem4: TDSkButton;
    procedure rgOrientationItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgVariantItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgSizeItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgColorItemClick(Sender: TObject; RadioIndex: Integer);
    procedure chkExclusiveCheckChanged(Sender: TObject);
    procedure chkFullWidthCheckChanged(Sender: TObject);
  private
    procedure SetupPanels;
    procedure UpdateGroups;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TFrameButtonGroupDemo.Create(AOwner: TComponent);
begin
  inherited;
  SetupPanels;
  ApplyAdminFrameStyle(Self);
end;

procedure TFrameButtonGroupDemo.SetupPanels;
begin
  pnlHeader.Caption := 'ButtonGroup Component Demo';
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

procedure TFrameButtonGroupDemo.rgOrientationItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateGroups;
end;

procedure TFrameButtonGroupDemo.rgVariantItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateGroups;
end;

procedure TFrameButtonGroupDemo.rgSizeItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateGroups;
end;

procedure TFrameButtonGroupDemo.rgColorItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateGroups;
end;

procedure TFrameButtonGroupDemo.chkExclusiveCheckChanged(Sender: TObject);
begin
  UpdateGroups;
end;

procedure TFrameButtonGroupDemo.chkFullWidthCheckChanged(Sender: TObject);
begin
  UpdateGroups;
end;

procedure TFrameButtonGroupDemo.UpdateGroups;
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
  
  case rgOrientation.ItemIndex of
    0: begin
      btnGroupMain.Orientation := bgoHorizontal;
      btnGroupVertical.Orientation := bgoVertical;
    end;
    1: begin
      btnGroupMain.Orientation := bgoVertical;
      btnGroupVertical.Orientation := bgoHorizontal;
    end;
  end;
  
  case rgVariant.ItemIndex of
    0: begin
      btnGroupMain.Variant := bgvContained;
      btnGroupVertical.Variant := bgvContained;
    end;
    1: begin
      btnGroupMain.Variant := bgvOutlined;
      btnGroupVertical.Variant := bgvOutlined;
    end;
    2: begin
      btnGroupMain.Variant := bgvText;
      btnGroupVertical.Variant := bgvText;
    end;
  end;
  
  case rgSize.ItemIndex of
    0: begin
      btnGroupMain.Size := bgsSmall;
      btnGroupVertical.Size := bgsSmall;
    end;
    1: begin
      btnGroupMain.Size := bgsMedium;
      btnGroupVertical.Size := bgsMedium;
    end;
    2: begin
      btnGroupMain.Size := bgsLarge;
      btnGroupVertical.Size := bgsLarge;
    end;
  end;
  
  btnGroupMain.ColorScheme := LColor;
  btnGroupVertical.ColorScheme := LColor;
  btnGroupMain.Exclusive := chkExclusive.Checked;
  btnGroupVertical.Exclusive := chkExclusive.Checked;
  btnGroupMain.FullWidth := chkFullWidth.Checked;
  btnGroupVertical.FullWidth := chkFullWidth.Checked;
end;

end.
