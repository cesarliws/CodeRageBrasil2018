unit GettingStarted.Main.Form;

interface

uses
  Buttons,
  Classes,
  ComCtrls,
  Controls,
  DB,
  DBCtrls,
  DBGrids,
  Dialogs,
  ExtCtrls,
  Forms,
  Graphics,
  Grids,
  Mask,
  Messages,
  StdCtrls,
  SysUtils,
  Variants,
  Windows,
  GettingStarted.Main.DataModule;

type
  TGettingStartedMainForm = class(TForm)
    ApplyButton: TButton;
    BackupButton: TButton;
    BackupDatabaseEdit: TEdit;
    BackupDatabaseLabel: TLabel;
    BackupImage: TImage;
    BackupPasswordEdit: TMaskEdit;
    BackupPasswordLabel: TLabel;
    BackupTabSheet: TTabSheet;
    ButtonsBevel: TBevel;
    ButtonsPanel: TPanel;
    CategoriesGrid: TDBGrid;
    CategoriesNavigator: TDBNavigator;
    CommonImage: TImage;
    CommonPanel: TPanel;
    ConnectImage: TImage;
    ConnectionDefsComboBox: TComboBox;
    ConnectionsDefLabel: TLabel;
    ConnectionsDefPanel: TPanel;
    DatabaseEdit: TEdit;
    DatabaseLabel: TLabel;
    DeleteButton: TButton;
    FiredacImage: TImage;
    GridsSplitter: TSplitter;
    InfoImage: TImage;
    InfoLabel: TLabel;
    InsertButton: TButton;
    LogLabel: TLabel;
    LogMemo: TMemo;
    MainPageControl: TPageControl;
    MainPanel: TPanel;
    MainStatusBar: TStatusBar;
    MasterDetailTabSheet: TTabSheet;
    MiscPanel: TPanel;
    OpenButton: TSpeedButton;
    OpenDialog: TOpenDialog;
    PasswordEdit: TMaskEdit;
    PasswordLabel: TLabel;
    ProductsGrid: TDBGrid;
    ProductsNavigator: TDBNavigator;
    SecurityActionsRadioGroup: TRadioGroup;
    SecurityImage: TImage;
    SecurityTabSheet: TTabSheet;
    ServicePageControl: TPageControl;
    ServiceTabSheet: TTabSheet;
    SubPageControlPanel: TPanel;
    TitleBevel: TBevel;
    TitleLabel: TLabel;
    TitlePanel: TPanel;
    ToPasswordEdit: TMaskEdit;
    ToPasswordLabel: TLabel;
    UpdateButton: TButton;
    ValidateButton: TButton;
    ValidateImage: TImage;
    ValidateTabSheet: TTabSheet;
    ValidationActionsRadioGroup: TRadioGroup;

    procedure ApplyButtonClick(Sender: TObject);
    procedure BackupButtonClick(Sender: TObject);
    procedure ConnectionDefsComboBoxClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure FiredacImageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InfoLabelClick(Sender: TObject);
    procedure InsertButtonClick(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
    procedure ValidateButtonClick(Sender: TObject);
  private
    FMainDataModule: TMainDataModule;
    procedure ShowDatabaseLog(const Text: string);
  end;

var
  GettingStartedMainForm: TGettingStartedMainForm;

implementation

uses
  FireDAC.Stan.Util;

const
  BACKUP_FILE_EXT         = '.backup';
  DEFAULT_NEW_CATEGORY    = 'New category';
  DEFAULT_NEW_DESCRIPTION = 'New description';
  FIREDAC_URL             = 'http://www.embarcadero.com/products/rad-studio/firedac';
  HTM_FILE_EXT            = '.htm';

resourcestring
  SLAST_CATEGORY_ID_CAPTION = 'Last CategoryID = ';
  SOPEN_DATABASE_TEXT       = '<Open database...>';

{$R *.dfm}

procedure TGettingStartedMainForm.FormCreate(Sender: TObject);
begin
  FMainDataModule := TMainDataModule.Create(Self);
  FMainDataModule.OnDatabaseLog := ShowDatabaseLog;

  ConnectionDefsComboBox.Clear;
  ConnectionDefsComboBox.Items.Add(SOPEN_DATABASE_TEXT);

  OpenDialog.InitialDir := FMainDataModule.GetConnectionDefFileName
end;

procedure TGettingStartedMainForm.ConnectionDefsComboBoxClick(Sender: TObject);
begin
  if not OpenDialog.Execute then
    Exit;

  FMainDataModule.OpenDatabase(OpenDialog.FileName);
end;

procedure TGettingStartedMainForm.InsertButtonClick(Sender: TObject);
begin
  if FMainDataModule.IsConnected then
  begin
    MainStatusBar.SimpleText := SLAST_CATEGORY_ID_CAPTION +
      IntToStr(FMainDataModule.Insert(DEFAULT_NEW_CATEGORY, DEFAULT_NEW_DESCRIPTION, $0334));
  end;
end;

procedure TGettingStartedMainForm.UpdateButtonClick(Sender: TObject);
begin
  FMainDataModule.Update(Random(5), Random(3));
end;

procedure TGettingStartedMainForm.DeleteButtonClick(Sender: TObject);
begin
  FMainDataModule.Delete(DEFAULT_NEW_CATEGORY);
end;

procedure TGettingStartedMainForm.ApplyButtonClick(Sender: TObject);
begin
  FMainDataModule.SetDatabasePassword(
    DatabaseEdit.Text,
    PasswordEdit.Text,
    ToPasswordEdit.Text,
    TDatabaseAction(SecurityActionsRadioGroup.ItemIndex)
  );
end;

procedure TGettingStartedMainForm.BackupButtonClick(Sender: TObject);
begin
  FMainDataModule.Backup(DatabaseEdit.Text, PasswordEdit.Text, BackupDatabaseEdit.Text, BackupPasswordEdit.Text);
end;

procedure TGettingStartedMainForm.ValidateButtonClick(Sender: TObject);
begin
  LogMemo.Clear;
  FMainDataModule.ValidateDatabase(DatabaseEdit.Text, PasswordEdit.Text, TDatabaseValidation(ValidationActionsRadioGroup.ItemIndex));
end;

procedure TGettingStartedMainForm.OpenButtonClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    DatabaseEdit.Text := OpenDialog.FileName;
    BackupDatabaseEdit.Text := ChangeFileExt(DatabaseEdit.Text, BACKUP_FILE_EXT);
  end;
end;

procedure TGettingStartedMainForm.InfoLabelClick(Sender: TObject);
var
  sHtmFile: String;
begin
  sHtmFile := ChangeFileExt(Application.ExeName, HTM_FILE_EXT);
  FDShell(sHtmFile, '');
end;

procedure TGettingStartedMainForm.FiredacImageClick(Sender: TObject);
begin
  FDShell(FIREDAC_URL, '');
end;

procedure TGettingStartedMainForm.ShowDatabaseLog(const Text: string);
begin
  LogMemo.Lines.Add(Text)
end;

end.

