unit Demo.Frame.Snackbar;

interface

uses
  System.Classes, System.SysUtils, System.UITypes, System.TypInfo,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Button, SkiaVclControls.Types,
  SkiaVclControls.Snackbar, SkiaVclControls.RadioGroup, SkiaVclControls.Checkbox,
  System.Skia, Vcl.Skia, Demo.Styles, SkiaVclControls.Base;

type
  TFrameSnackbarDemo = class(TFrame)
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
    lblSeverity: TDSkLabel;
    rgSeverity: TDSkRadioGroup;
    lblPosition: TDSkLabel;
    rgPosition: TDSkRadioGroup;
    lblVariant: TDSkLabel;
    rgVariant: TDSkRadioGroup;
    lblDuration: TDSkLabel;
    rgDuration: TDSkRadioGroup;
    chkAction: TDSkCheckbox;
    chkClose: TDSkCheckbox;
    lblPreviewTitle: TDSkLabel;
    btnShow: TDSkButton;
    btnSuccess: TDSkButton;
    btnError: TDSkButton;
    btnWarning: TDSkButton;
    btnInfo: TDSkButton;
    lblInfo: TDSkLabel;
    mainSnackbar: TDSkSnackbar;
    procedure btnShowClick(Sender: TObject);
    procedure btnSuccessClick(Sender: TObject);
    procedure btnErrorClick(Sender: TObject);
    procedure btnWarningClick(Sender: TObject);
    procedure btnInfoClick(Sender: TObject);
    procedure mainSnackbarShow(Sender: TObject);
    procedure mainSnackbarClose(Sender: TObject);
    procedure mainSnackbarAction(Sender: TObject; var AllowClose: Boolean);
  private
    function GetSelectedPosition: TDSkSnackbarPosition;
    function GetSelectedVariant: TDSkSnackbarVariant;
    function GetSelectedDuration: Integer;
    procedure ShowSnackbar(ASeverity: TDSkSnackbarSeverity; const AMessage: string);
    procedure SetupPanels;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TFrameSnackbarDemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetupPanels;
  ApplyAdminFrameStyle(Self);
end;

procedure TFrameSnackbarDemo.SetupPanels;
begin
  rgSeverity.ItemIndex := 0;
  rgPosition.ItemIndex := 4;
  rgVariant.ItemIndex := 0;
  rgDuration.ItemIndex := 1;
  chkAction.Checked := False;
  chkClose.Checked := False;
end;

procedure TFrameSnackbarDemo.btnShowClick(Sender: TObject);
var
  LSeverity: TDSkSnackbarSeverity;
begin
  case rgSeverity.ItemIndex of
    0: LSeverity := snkSuccess;
    1: LSeverity := snkError;
    2: LSeverity := snkWarning;
    3: LSeverity := snkInfo;
  else
    LSeverity := snkNone;
  end;
  ShowSnackbar(LSeverity, 'This is a ' + rgSeverity.Items[rgSeverity.ItemIndex] + ' message!');
end;

procedure TFrameSnackbarDemo.btnSuccessClick(Sender: TObject);
begin
  ShowSnackbar(snkSuccess, 'Operation completed successfully!');
end;

procedure TFrameSnackbarDemo.btnErrorClick(Sender: TObject);
begin
  ShowSnackbar(snkError, 'An error occurred while processing.');
end;

procedure TFrameSnackbarDemo.btnWarningClick(Sender: TObject);
begin
  ShowSnackbar(snkWarning, 'Please check your input.');
end;

procedure TFrameSnackbarDemo.btnInfoClick(Sender: TObject);
begin
  ShowSnackbar(snkInfo, 'A new update is available.');
end;

procedure TFrameSnackbarDemo.ShowSnackbar(ASeverity: TDSkSnackbarSeverity; const AMessage: string);
begin
  mainSnackbar.Severity := ASeverity;
  mainSnackbar.Variant := GetSelectedVariant;
  mainSnackbar.Position := GetSelectedPosition;
  mainSnackbar.AutoHideDuration := GetSelectedDuration;
  
  if chkAction.Checked then
    mainSnackbar.ActionText := 'UNDO'
  else
    mainSnackbar.ActionText := '';
  
  mainSnackbar.ShowCloseButton := chkClose.Checked;
  mainSnackbar.Message := AMessage;
  mainSnackbar.Show;
end;

procedure TFrameSnackbarDemo.mainSnackbarShow(Sender: TObject);
begin
  lblInfo.Caption := Format('Showing %s snackbar', 
    [GetEnumName(TypeInfo(TDSkSnackbarSeverity), Ord(mainSnackbar.Severity))]);
end;

procedure TFrameSnackbarDemo.mainSnackbarClose(Sender: TObject);
begin
  lblInfo.Caption := 'Snackbar closed';
end;

procedure TFrameSnackbarDemo.mainSnackbarAction(Sender: TObject; var AllowClose: Boolean);
begin
  lblInfo.Caption := 'Action clicked!';
  AllowClose := True;
end;

function TFrameSnackbarDemo.GetSelectedPosition: TDSkSnackbarPosition;
begin
  case rgPosition.ItemIndex of
    0: Result := spTopLeft;
    1: Result := spTopCenter;
    2: Result := spTopRight;
    3: Result := spBottomLeft;
    4: Result := spBottomCenter;
    5: Result := spBottomRight;
  else
    Result := spBottomCenter;
  end;
end;

function TFrameSnackbarDemo.GetSelectedVariant: TDSkSnackbarVariant;
begin
  case rgVariant.ItemIndex of
    0: Result := snvStandard;
    1: Result := snvFilled;
    2: Result := snvOutlined;
  else
    Result := snvStandard;
  end;
end;

function TFrameSnackbarDemo.GetSelectedDuration: Integer;
begin
  case rgDuration.ItemIndex of
    0: Result := 2000;
    1: Result := 4000;
    2: Result := 6000;
    3: Result := 0;
  else
    Result := 4000;
  end;
end;

end.
