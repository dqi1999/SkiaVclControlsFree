unit Demo.Frame.Edit;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Types,
  SkiaVclControls.Edit, SkiaVclControls.RadioGroup, SkiaVclControls.Checkbox,
  System.Skia, Vcl.Skia, Demo.Styles, SkiaVclControls.Base;

type
  TFrameEditDemo = class(TFrame)
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
    rgVariant: TDSkRadioGroup;
    rgSize: TDSkRadioGroup;
    rgColor: TDSkRadioGroup;
    chkClearable: TDSkCheckbox;
    chkPassword: TDSkCheckbox;
    chkError: TDSkCheckbox;
    lblPreviewTitle: TDSkLabel;
    edtBasic: TDSkEdit;
    edtLabel: TDSkEdit;
    edtPlaceholder: TDSkEdit;
    edtClearable: TDSkEdit;
    edtPassword: TDSkEdit;
    edtError: TDSkEdit;
    procedure rgVariantItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgSizeItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgColorItemClick(Sender: TObject; RadioIndex: Integer);
    procedure chkClearableCheckChanged(Sender: TObject);
    procedure chkPasswordCheckChanged(Sender: TObject);
    procedure chkErrorCheckChanged(Sender: TObject);
  private
    procedure LayoutPreviewEdits(AEditSize: TDSkEditSize);
    procedure UpdateEdits;
    procedure SetupPanels;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TFrameEditDemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetupPanels;
  rgVariant.ItemIndex := 0;
  rgSize.ItemIndex := 0;
  rgColor.ItemIndex := 0;
  chkClearable.Checked := False;
  chkPassword.Checked := False;
  chkError.Checked := False;
  UpdateEdits;
  ApplyAdminFrameStyle(Self);
end;

procedure TFrameEditDemo.SetupPanels;
begin
  pnlHeader.Align := alTop;
  pnlHeader.Height := 48;
  pnlControl.Align := alLeft;
  pnlControl.Width := 280;
  pnlPreview.Align := alClient;
end;

procedure TFrameEditDemo.rgVariantItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateEdits;
end;

procedure TFrameEditDemo.rgSizeItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateEdits;
end;

procedure TFrameEditDemo.rgColorItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateEdits;
end;

procedure TFrameEditDemo.chkClearableCheckChanged(Sender: TObject);
begin
  edtClearable.Clearable := chkClearable.Checked;
end;

procedure TFrameEditDemo.chkPasswordCheckChanged(Sender: TObject);
begin
  if chkPassword.Checked then
    edtPassword.PasswordChar := '*'
  else
    edtPassword.PasswordChar := #0;
end;

procedure TFrameEditDemo.chkErrorCheckChanged(Sender: TObject);
begin
  edtError.Error := chkError.Checked;
end;

procedure TFrameEditDemo.UpdateEdits;
var
  LColor: TDSkMUIColorScheme;
  LVariant: TDSkEditVariant;
  LSize: TDSkEditSize;
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
    1: LVariant := evFilled;
    2: LVariant := evUnderline;
  else
    LVariant := evOutlined;
  end;

  if rgSize.ItemIndex = 1 then
    LSize := esSmall
  else
    LSize := esMedium;
  
  edtBasic.ColorScheme := LColor;
  edtBasic.Variant := LVariant;
  edtBasic.Size := LSize;
  edtLabel.ColorScheme := LColor;
  edtLabel.Variant := LVariant;
  edtLabel.Size := LSize;
  edtPlaceholder.ColorScheme := LColor;
  edtPlaceholder.Variant := LVariant;
  edtPlaceholder.Size := LSize;
  edtClearable.ColorScheme := LColor;
  edtClearable.Variant := LVariant;
  edtClearable.Size := LSize;
  edtPassword.ColorScheme := LColor;
  edtPassword.Variant := LVariant;
  edtPassword.Size := LSize;
  edtError.ColorScheme := LColor;
  edtError.Variant := LVariant;
  edtError.Size := LSize;

  LayoutPreviewEdits(LSize);
end;

procedure TFrameEditDemo.LayoutPreviewEdits(AEditSize: TDSkEditSize);
var
  LTop: Integer;
  LGap: Integer;

  procedure PlaceEdit(AEdit: TDSkEdit);
  begin
    AEdit.Top := LTop;
    Inc(LTop, AEdit.Height + LGap);
  end;

begin
  // Edit 的 Size 会改变控件高度，演示页同步重排预览控件，避免视觉间距失衡。
  LTop := 56;
  if AEditSize = esSmall then
    LGap := 16
  else
    LGap := 18;

  PlaceEdit(edtBasic);
  PlaceEdit(edtLabel);
  PlaceEdit(edtPlaceholder);
  PlaceEdit(edtClearable);
  PlaceEdit(edtPassword);
  PlaceEdit(edtError);
end;

end.
