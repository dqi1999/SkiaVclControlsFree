unit Demo.Frame.Select;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Types,
  SkiaVclControls.Select, SkiaVclControls.RadioGroup, SkiaVclControls.Checkbox,
  System.Skia, Vcl.Skia, Demo.Styles, SkiaVclControls.Base;

type
  TFrameSelectDemo = class(TFrame)
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
    rgVariant: TDSkRadioGroup;
    rgSize: TDSkRadioGroup;
    rgColor: TDSkRadioGroup;
    chkClearable: TDSkCheckbox;
    chkError: TDSkCheckbox;
    lblPreviewTitle: TDSkLabel;
    selBasic: TDSkSelect;
    selLabel: TDSkSelect;
    selPlaceholder: TDSkSelect;
    selClearable: TDSkSelect;
    selError: TDSkSelect;
    procedure rgVariantItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgSizeItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgColorItemClick(Sender: TObject; RadioIndex: Integer);
    procedure chkClearableCheckChanged(Sender: TObject);
    procedure chkErrorCheckChanged(Sender: TObject);
  private
    procedure SetupPanels;
    procedure LayoutPreviewSelects(ASelectSize: TDSkSelectSize);
    procedure UpdateSelects;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TFrameSelectDemo.Create(AOwner: TComponent);
begin
  inherited;
  SetupPanels;
  UpdateSelects;
  ApplyAdminFrameStyle(Self);
end;

procedure TFrameSelectDemo.SetupPanels;
begin
  pnlHeader.Align := alTop;
  pnlHeader.Height := 40;
  pnlControl.Align := alLeft;
  pnlControl.Width := 280;
  pnlPreview.Align := alClient;
end;

procedure TFrameSelectDemo.rgVariantItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateSelects;
end;

procedure TFrameSelectDemo.rgSizeItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateSelects;
end;

procedure TFrameSelectDemo.rgColorItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateSelects;
end;

procedure TFrameSelectDemo.chkClearableCheckChanged(Sender: TObject);
begin
  selClearable.Clearable := chkClearable.Checked;
end;

procedure TFrameSelectDemo.chkErrorCheckChanged(Sender: TObject);
begin
  selError.Error := chkError.Checked;
end;

procedure TFrameSelectDemo.UpdateSelects;
var
  LColor: TDSkMUIColorScheme;
  LVariant: TDSkSelectVariant;
  LSize: TDSkSelectSize;
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
    1: LVariant := svFilled;
    2: LVariant := svUnderline;
  else
    LVariant := svOutlined;
  end;

  if rgSize.ItemIndex = 1 then
    LSize := ssSmall
  else
    LSize := ssMedium;
  
  selBasic.ColorScheme := LColor;
  selBasic.Variant := LVariant;
  selBasic.Size := LSize;
  selLabel.ColorScheme := LColor;
  selLabel.Variant := LVariant;
  selLabel.Size := LSize;
  selPlaceholder.ColorScheme := LColor;
  selPlaceholder.Variant := LVariant;
  selPlaceholder.Size := LSize;
  selClearable.ColorScheme := LColor;
  selClearable.Variant := LVariant;
  selClearable.Size := LSize;
  selError.ColorScheme := LColor;
  selError.Variant := LVariant;
  selError.Size := LSize;

  LayoutPreviewSelects(LSize);
end;

procedure TFrameSelectDemo.LayoutPreviewSelects(ASelectSize: TDSkSelectSize);
var
  LTop: Integer;
  LGap: Integer;

  procedure PlaceSelect(ASelect: TDSkSelect);
  begin
    ASelect.Top := LTop;
    Inc(LTop, ASelect.Height + LGap);
  end;

begin
  // Size 切换会改变控件高度，同步调整间距，避免 Small 状态下预览区显得过散。
  LTop := 56;
  if ASelectSize = ssSmall then
    LGap := 16
  else
    LGap := 18;

  PlaceSelect(selBasic);
  PlaceSelect(selLabel);
  PlaceSelect(selPlaceholder);
  PlaceSelect(selClearable);
  PlaceSelect(selError);
end;

end.
