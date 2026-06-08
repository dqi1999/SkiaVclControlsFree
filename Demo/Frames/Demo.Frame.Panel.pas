unit Demo.Frame.Panel;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Types,
  SkiaVclControls.RadioGroup, SkiaVclControls.Checkbox,
  Demo.Styles, System.Skia, Vcl.Skia, SkiaVclControls.Base;

type
  TFramePanelDemo = class(TFrame)
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
    rgStyle: TDSkRadioGroup;
    rgCaptionPos: TDSkRadioGroup;
    lblOptions: TDSkLabel;
    chkHover: TDSkCheckbox;
    chkBorder: TDSkCheckbox;
    lblPreviewTitle: TDSkLabel;
    pnlMain: TDSkPanel;
    pnlCard1: TDSkPanel;
    pnlCard2: TDSkPanel;
    pnlCard3: TDSkPanel;
    pnlContainer: TDSkPanel;
    procedure rgStyleItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgCaptionPosItemClick(Sender: TObject; RadioIndex: Integer);
    procedure edtCaptionChange(Sender: TObject; const AText: string);
    procedure chkHoverCheckChanged(Sender: TObject);
    procedure chkBorderCheckChanged(Sender: TObject);
  private
    procedure SetupPanels;
    procedure UpdatePanelStyles;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TFramePanelDemo.Create(AOwner: TComponent);
begin
  inherited;
  SetupPanels;
  ApplyAdminFrameStyle(Self);
end;

procedure TFramePanelDemo.SetupPanels;
begin
  // Header
  pnlHeader.Caption := 'Panel Component Demo';
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

procedure TFramePanelDemo.rgStyleItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdatePanelStyles;
end;

procedure TFramePanelDemo.rgCaptionPosItemClick(Sender: TObject; RadioIndex: Integer);
begin
  case rgCaptionPos.ItemIndex of
    0: pnlMain.CaptionPosition := cpTopLeft;
    1: pnlMain.CaptionPosition := cpTopCenter;
    2: pnlMain.CaptionPosition := cpTopRight;
    3: pnlMain.CaptionPosition := cpLeftCenter;
    4: pnlMain.CaptionPosition := cpCenter;
    5: pnlMain.CaptionPosition := cpRightCenter;
    6: pnlMain.CaptionPosition := cpBottomLeft;
    7: pnlMain.CaptionPosition := cpBottomCenter;
    8: pnlMain.CaptionPosition := cpBottomRight;
  end;
end;

procedure TFramePanelDemo.edtCaptionChange(Sender: TObject; const AText: string);
begin
  pnlMain.Caption := 'Panel Title';
end;

procedure TFramePanelDemo.chkHoverCheckChanged(Sender: TObject);
begin
  pnlMain.HoverEnabled := chkHover.Checked;
end;

procedure TFramePanelDemo.chkBorderCheckChanged(Sender: TObject);
begin
  if chkBorder.Checked then
  begin
    pnlMain.BorderWidth := 1;
    pnlMain.BorderColor := MD3_OUTLINE;
  end
  else
    pnlMain.BorderWidth := 0;
end;

procedure TFramePanelDemo.UpdatePanelStyles;
begin
  case rgStyle.ItemIndex of
    0: pnlMain.PanelStyle := psElevated;
    1: pnlMain.PanelStyle := psFilled;
    2: pnlMain.PanelStyle := psOutlined;
    3: pnlMain.PanelStyle := psSurface;
    4: pnlMain.PanelStyle := psPrimaryContainer;
    5: pnlMain.PanelStyle := psSecondaryContainer;
    6: pnlMain.PanelStyle := psErrorContainer;
  end;
end;

end.
