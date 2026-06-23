unit AdminMainForm;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Tabs, SkiaVclControls.Types,
  SkiaVclControls.Base, System.Skia, Vcl.Skia, Demo.Styles,
  Demo.Frame.Button, Demo.Frame.Panel, Demo.Frame.ButtonGroup,
  Demo.Frame.Radio, Demo.Frame.Checkbox, Demo.Frame.Switch,
  Demo.Frame.Select, Demo.Frame.Edit, Demo.Frame.Slider,
  Demo.Frame.Progress, Demo.Frame.Stepper, Demo.Frame.Tabs,
  Demo.Frame.LabelControl, Demo.Frame.Snackbar, System.ImageList, Vcl.ImgList,
  SVGIconImageListBase, SVGIconImageList;

type
  TAdminDemoPage = record
    NavText: string;
    Title: string;
    Description: string;
    Frame: TFrame;
  end;

  TFormAdminDemo = class(TForm)
    pnlMain: TDSkPanel;
    pnlHeader: TDSkPanel;
    lblHeaderTitle: TDSkLabel;
    lblHeaderSubtitle: TDSkLabel;
    pnlSidebar: TDSkPanel;
    pnlBrand: TDSkPanel;
    lblBrandTitle: TDSkLabel;
    lblBrandSubtitle: TDSkLabel;
    pnlContent: TDSkPanel;
    pnlPageHeader: TDSkPanel;
    lblPageTitle: TDSkLabel;
    lblPageDescription: TDSkLabel;
    pnlFrameHost: TDSkPanel;
    sideNav: TDSkTabs;
    frameButton: TFrameButtonDemo;
    framePanel: TFramePanelDemo;
    frameButtonGroup: TFrameButtonGroupDemo;
    frameRadio: TFrameRadioDemo;
    frameCheckbox: TFrameCheckboxDemo;
    frameSwitch: TFrameSwitchDemo;
    frameSelect: TFrameSelectDemo;
    frameEdit: TFrameEditDemo;
    frameSlider: TFrameSliderDemo;
    frameProgress: TFrameProgressDemo;
    frameStepper: TFrameStepperDemo;
    frameTabs: TFrameTabsDemo;
    frameLabel: TFrameLabelDemo;
    frameSnackbar: TFrameSnackbarDemo;
    SVGIconImageList1: TSVGIconImageList;
    procedure FormCreate(Sender: TObject);
    procedure sideNavItemClick(Sender: TObject; TabIndex: Integer);
  private
    FFrames: array[0..13] of TFrame;
    FPages: array[0..13] of TAdminDemoPage;
    procedure ApplyShellStyle;
    procedure CreateFrames;
    procedure AddPage(AIndex: Integer; const ANavText, ATitle, ADescription: string; AFrame: TFrame; AImageIndex: Integer = -1);
    procedure ConfigureSideNavItems;
    procedure ShowFrame(AIndex: Integer);
    procedure UpdatePageHeader(AIndex: Integer);
  end;

var
  FormAdminDemo: TFormAdminDemo;

implementation

{$R *.dfm}

procedure TFormAdminDemo.FormCreate(Sender: TObject);
begin
  ApplyShellStyle;
  CreateFrames;
  ShowFrame(0);
end;

procedure TFormAdminDemo.ApplyShellStyle;
begin
  Color := $00F7F9FC;

  lblHeaderTitle.BackgroundColor := TAlphaColors.Null;
  lblHeaderTitle.BorderColor := TAlphaColors.Null;
  lblHeaderTitle.BorderWidth := 0;
  lblHeaderTitle.ColorScheme := muiSchemeNone;
  lblHeaderTitle.TextAlign := ltaLeft;
  lblHeaderTitle.VerticalAlign := lvaCenter;
  lblHeaderTitle.Font.Name := GetDefaultFontName;
  lblHeaderTitle.Font.Size := 16;
  lblHeaderTitle.Font.Style := [fsBold];
  lblHeaderTitle.FontColor := $FF212121;

  lblHeaderSubtitle.BackgroundColor := TAlphaColors.Null;
  lblHeaderSubtitle.BorderColor := TAlphaColors.Null;
  lblHeaderSubtitle.BorderWidth := 0;
  lblHeaderSubtitle.ColorScheme := muiSchemeNone;
  lblHeaderSubtitle.TextAlign := ltaLeft;
  lblHeaderSubtitle.VerticalAlign := lvaCenter;
  lblHeaderSubtitle.Font.Name := GetDefaultFontName;
  lblHeaderSubtitle.Font.Size := 9;
  lblHeaderSubtitle.FontColor := $FF757575;

  lblBrandTitle.BackgroundColor := TAlphaColors.Null;
  lblBrandTitle.BorderColor := TAlphaColors.Null;
  lblBrandTitle.BorderWidth := 0;
  lblBrandTitle.ColorScheme := muiSchemeNone;
  lblBrandTitle.TextAlign := ltaLeft;
  lblBrandTitle.VerticalAlign := lvaCenter;
  lblBrandTitle.Font.Name := GetDefaultFontName;
  lblBrandTitle.Font.Size := 15;
  lblBrandTitle.Font.Style := [fsBold];
  lblBrandTitle.FontColor := $FF1565C0;

  lblBrandSubtitle.BackgroundColor := TAlphaColors.Null;
  lblBrandSubtitle.BorderColor := TAlphaColors.Null;
  lblBrandSubtitle.BorderWidth := 0;
  lblBrandSubtitle.ColorScheme := muiSchemeNone;
  lblBrandSubtitle.TextAlign := ltaLeft;
  lblBrandSubtitle.VerticalAlign := lvaCenter;
  lblBrandSubtitle.Font.Name := GetDefaultFontName;
  lblBrandSubtitle.Font.Size := 9;
  lblBrandSubtitle.FontColor := $FF576B7D;

  lblPageTitle.BackgroundColor := TAlphaColors.Null;
  lblPageTitle.BorderColor := TAlphaColors.Null;
  lblPageTitle.BorderWidth := 0;
  lblPageTitle.ColorScheme := muiSchemeNone;
  lblPageTitle.TextAlign := ltaLeft;
  lblPageTitle.VerticalAlign := lvaCenter;
  lblPageTitle.Font.Name := GetDefaultFontName;
  lblPageTitle.Font.Size := 20;
  lblPageTitle.Font.Style := [fsBold];
  lblPageTitle.FontColor := $FF212121;

  lblPageDescription.BackgroundColor := TAlphaColors.Null;
  lblPageDescription.BorderColor := TAlphaColors.Null;
  lblPageDescription.BorderWidth := 0;
  lblPageDescription.ColorScheme := muiSchemeNone;
  lblPageDescription.TextAlign := ltaLeft;
  lblPageDescription.VerticalAlign := lvaCenter;
  lblPageDescription.Font.Name := GetDefaultFontName;
  lblPageDescription.Font.Size := 10;
  lblPageDescription.FontColor := $FF757575;

  sideNav.TabFont.Name := GetDefaultFontName;
  sideNav.TabFont.Size := 11;
  sideNav.TabHeight := 48;
  sideNav.TabPadding := 18;
  sideNav.Images := SVGIconImageList1;

  pnlBrand.Anchors := [akLeft, akTop, akRight];
  sideNav.Anchors := [akLeft, akTop, akRight, akBottom];

  pnlPageHeader.AlignWithMargins := True;
  pnlPageHeader.Margins.Left := 24;
  pnlPageHeader.Margins.Top := 22;
  pnlPageHeader.Margins.Right := 24;
  pnlPageHeader.Margins.Bottom := 10;

  pnlFrameHost.AlignWithMargins := True;
  pnlFrameHost.Margins.Left := 24;
  pnlFrameHost.Margins.Top := 0;
  pnlFrameHost.Margins.Right := 24;
  pnlFrameHost.Margins.Bottom := 24;
end;

procedure TFormAdminDemo.AddPage(AIndex: Integer; const ANavText, ATitle,
  ADescription: string; AFrame: TFrame; AImageIndex: Integer = -1);
begin
  if AImageIndex < 0 then
    AImageIndex := AIndex;
  FPages[AIndex].NavText := Format('%s:%d', [ANavText, AImageIndex]);
  FPages[AIndex].Title := ATitle;
  FPages[AIndex].Description := ADescription;
  FPages[AIndex].Frame := AFrame;
  FFrames[AIndex] := AFrame;
end;

procedure TFormAdminDemo.ConfigureSideNavItems;
var
  I: Integer;
begin
  sideNav.Items.BeginUpdate;
  try
    sideNav.Items.Clear;
    for I := Low(FPages) to High(FPages) do
      sideNav.Items.Add(FPages[I].NavText);
  finally
    sideNav.Items.EndUpdate;
  end;
  sideNav.ItemIndex := 0;
end;

procedure TFormAdminDemo.CreateFrames;
var
  I: Integer;
begin
  AddPage(0, 'Label', 'Label',
    'Skia-powered text with gradients, outlines, hollow text, shadows and alignment.',
    frameLabel, 1);
  AddPage(1, 'Button', 'Button',
    'Foundational actions: contained, outlined, text, toggle and icon button states.',
    frameButton, 0);
  AddPage(2, 'Panel', 'Panel',
    'Surface containers, rounded sections and Material card styles.',
    framePanel, 2);
  AddPage(3, 'Radio', 'Radio',
    'Single choice controls with label placement and visual states.',
    frameRadio, 5);
  AddPage(4, 'Checkbox', 'Checkbox',
    'Checkbox and checkbox group patterns for multi-select workflows.',
    frameCheckbox, 6);
  AddPage(5, 'Switch', 'Switch',
    'Switch controls for compact on/off settings.',
    frameSwitch, 7);
  AddPage(6, 'Slider', 'Slider',
    'Continuous, discrete, range and vertical slider interactions.',
    frameSlider, 8);
  AddPage(7, 'Progress', 'Progress',
    'Linear and circular progress indicators for task status.',
    frameProgress, 9);
  AddPage(8, 'Select', 'Select',
    'Outlined, filled and underline select fields.',
    frameSelect, 4);
  AddPage(9, 'Edit', 'Edit',
    'Text input, floating labels, selection and password states.',
    frameEdit, 3);
  AddPage(10, 'Snackbar', 'Snackbar',
    'Transient feedback messages with severity and placement options.',
    frameSnackbar, 10);
  AddPage(11, 'Button Group', 'Button Group',
    'Grouped actions with connected button layouts and selection modes.',
    frameButtonGroup, 11);
  AddPage(12, 'Tabs', 'Tabs',
    'Horizontal, vertical and navigation tab patterns.',
    frameTabs, 12);
  AddPage(13, 'Stepper', 'Stepper',
    'Linear and non-linear step flows with status styling.',
    frameStepper, 13);

  ConfigureSideNavItems;

  for I := 0 to High(FFrames) do
  begin
    if FFrames[I] <> nil then
    begin
      FFrames[I].Parent := pnlFrameHost;
      FFrames[I].Align := alClient;
      FFrames[I].Visible := False;
    end;
  end;
end;

procedure TFormAdminDemo.sideNavItemClick(Sender: TObject; TabIndex: Integer);
begin
  ShowFrame(TabIndex);
end;

procedure TFormAdminDemo.ShowFrame(AIndex: Integer);
var
  I: Integer;
begin
  // Hide all frames
  for I := 0 to High(FFrames) do
  begin
    if FFrames[I] <> nil then
      FFrames[I].Visible := False;
  end;
  
  // Show selected frame
  if (AIndex >= 0) and (AIndex <= High(FFrames)) then
  begin
    UpdatePageHeader(AIndex);
    if FFrames[AIndex] <> nil then
    begin
      FFrames[AIndex].Visible := True;
      FFrames[AIndex].Align := alClient;
      FFrames[AIndex].BringToFront;
    end;
  end;
end;

procedure TFormAdminDemo.UpdatePageHeader(AIndex: Integer);
begin
  if (AIndex < Low(FPages)) or (AIndex > High(FPages)) then
    Exit;

  lblPageTitle.Caption := FPages[AIndex].Title;
  lblPageDescription.Caption := FPages[AIndex].Description;
end;

end.
