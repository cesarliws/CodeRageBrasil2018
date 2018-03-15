unit GettingStarted.Main.DataModule;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.DatS,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.UI,
  FireDAC.Stan.Consts,
  FireDAC.VCLUI.Controls,
  FireDAC.Stan.Error,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Phys,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.VCLUI.Wait,
  FireDAC.VCLUI.Error,
  FireDAC.VCLUI.Login,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteWrapper,
  FireDAC.Phys.SQLiteDef;

type
   TDatabaseAction = (
     SetPassword,
     RemovePassword,
     ChangePassword
   );

   TDatabaseValidation = (
     Analyze,
     CheckOnly,
     Sweep
   );

   TOnDatabaseLog = reference to procedure(const Text: string);

  TMainDataModule = class(TDataModule)
    BackupSQLite: TFDSQLiteBackup;
    CategoriesQuery: TFDQuery;
    DatabaseConnection: TFDConnection;
    DriverLinkSQLite: TFDPhysSQLiteDriverLink;
    ErrorDialogFireDAC: TFDGUIxErrorDialog;
    FunctionSQLite: TFDSQLiteFunction;
    LoginDialogFireDAC: TFDGUIxLoginDialog;
    ProductsQuery: TFDQuery;
    SecuritySQLite: TFDSQLiteSecurity;
    ValidateSQLite: TFDSQLiteValidate;
    WaitCursorFireDAC: TFDGUIxWaitCursor;
    CategoriesDataSource: TDataSource;
    ///
    procedure DatabaseConnectionBeforeConnect(Sender: TObject);
    procedure DatabaseConnectionBeforeDisconnect(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FunctionSQLiteCalculate(AFunc: TSQLiteFunctionInstance; AInputs: TSQLiteInputs; AOutput: TSQLiteOutput; var AUserData: TObject);
    procedure ValidateSQLiteProgress(ASender: TFDPhysDriverService; const AMessage: String);
  private
    FOnDatabaseLog: TOnDatabaseLog;
    procedure WriteLog(const Text: string);
  public
    function GetConnectionDefFileName: string;
    function IsConnected: Boolean;
    ///
    function Insert(const Categoria, Descricao: string; Picture: Integer): Integer;
    procedure Delete(const Categoria: string);
    procedure Update(Valor1, Valor2: Integer);
    ///
    procedure Backup(const Database, Password, BackupDatabase, BackupPassword: string);
    procedure OpenDatabase(const FileName: string);
    procedure SetDatabasePassword(const Database, Password, NewPassword: string; Action: TDatabaseAction);
    procedure ValidateDatabase(const Database, Password: string; ValidationAction: TDatabaseValidation);

    procedure OpenDefaultDatabase;
    ///
    property OnDatabaseLog: TOnDatabaseLog read FOnDatabaseLog write FOnDatabaseLog;
  end;

  EDataValidation = class(Exception);

var
  MainDataModule: TMainDataModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  GettingStarted.Consts,
  GettingStarted.Sql,
  GettingStarted.Config;

procedure TMainDataModule.DataModuleDestroy(Sender: TObject);
begin
  CategoriesQuery    .Close;
  ProductsQuery      .Close;
  DatabaseConnection .Close;
end;

procedure TMainDataModule.Backup(const Database, Password, BackupDatabase, BackupPassword: string);
begin
  if Database = '' then
    Exit;

  BackupSQLite.Database     := Database;
  BackupSQLite.Password     := Password;

  BackupSQLite.DestDatabase := BackupDatabase;
  BackupSQLite.DestPassword := BackupPassword;
  BackupSQLite.Backup;
end;

procedure TMainDataModule.DatabaseConnectionBeforeConnect(Sender: TObject);
begin
  FunctionSQLite.Active := True;
end;

procedure TMainDataModule.DatabaseConnectionBeforeDisconnect(Sender: TObject);
begin
  FunctionSQLite.Active := False;
end;

procedure TMainDataModule.Delete(const Categoria: string);
begin
  if not DatabaseConnection.Connected then
    Exit;

  // Delete a record
  DatabaseConnection.ExecSQL(DELETE_CATEGORIES_SQL, [Categoria]);
  CategoriesQuery.Refresh;
end;

function TMainDataModule.GetConnectionDefFileName: string;
begin
  Result := FDManager.ActualConnectionDefFileName;
end;

function TMainDataModule.Insert(const Categoria, Descricao: string; Picture: Integer): Integer;
var
  CategoryID: Integer;
begin
  if not IsConnected then
    Exit(-1);

  if Categoria = '' then
  begin
    raise EDataValidation.Create(SREQUIRED_CATEGORY_ERROR);
  end;

  if Descricao = '' then
  begin
    raise EDataValidation.Create(SREQUIRED_DESCRIPTION_ERROR);
  end;

  // Insert a record
  DatabaseConnection.ExecSQL(INSERT_CATEGORIES_SQL, [Categoria, Descricao, Picture]);
  CategoriesQuery.Refresh;

  // Get a scalar value from DB
  CategoryID := DatabaseConnection.ExecSQLScalar(SELECT_MAX_CATEGORYID_SQL);
  Result := CategoryID;
end;

function TMainDataModule.IsConnected: Boolean;
begin
  Result := DatabaseConnection.Connected;
end;

procedure TMainDataModule.OpenDatabase(const FileName: string);
begin
  DatabaseConnection.Close;

  // create temporary connection definition
  DatabaseConnection.Params.Clear;
  DatabaseConnection.Params.Add(DRIVERID_SQLITE_PARAM);
  DatabaseConnection.Params.Add(SDATABASE_PARAM + FileName);
  DatabaseConnection.Open;
  CategoriesQuery.Open;
  ProductsQuery.Open;
end;

procedure TMainDataModule.SetDatabasePassword(const Database, Password, NewPassword: string; Action: TDatabaseAction);
begin
  if Database = '' then
    Exit;

  SecuritySQLite.Database := Database;
  SecuritySQLite.Password := Password;
  SecuritySQLite.ToPassword := Password;

  case Action of
    TDatabaseAction.SetPassword:
      SecuritySQLite.SetPassword;

    TDatabaseAction.RemovePassword:
      SecuritySQLite.RemovePassword;

    TDatabaseAction.ChangePassword:
      SecuritySQLite.ChangePassword;
  end;
end;

procedure TMainDataModule.FunctionSQLiteCalculate(AFunc: TSQLiteFunctionInstance; AInputs: TSQLiteInputs; AOutput: TSQLiteOutput; var AUserData: TObject);
begin
  AOutput.AsCurrency := AInputs[0].AsCurrency * AInputs[1].AsInteger;
end;

procedure TMainDataModule.OpenDefaultDatabase;
var
  Config: TConfig;
begin
  Config := TConfig.Create;
  try
    if not Config.FileExists then
    begin
      Config.DatabaseFile := TConfig.GetDefaultDatabaseFileName;
      Config.Save;
    end;

    Config.Load;
    OpenDatabase(Config.DatabaseFile );
  finally
    Config.Free;
  end;
end;

procedure TMainDataModule.ValidateSQLiteProgress(ASender: TFDPhysDriverService; const AMessage: String);
begin
  WriteLog(AMessage);
end;

procedure TMainDataModule.Update(Valor1, Valor2: Integer);
begin
  if not IsConnected then
    Exit;

  // Update records
  DatabaseConnection.ExecSQL(UPDATE_PRODUCTS_SQL, [Valor1, Valor2]);
  ProductsQuery.Refresh;
end;

procedure TMainDataModule.ValidateDatabase(const Database, Password: string; ValidationAction: TDatabaseValidation);
begin
  if Database = '' then
    Exit;

  ValidateSQLite.Database := Database;
  ValidateSQLite.Password := Password;

  case ValidationAction of
    TDatabaseValidation.Analyze:
      ValidateSQLite.Analyze;

    TDatabaseValidation.CheckOnly:
      if not ValidateSQLite.CheckOnly then
        WriteLog(SDATABASE_HAS_PROBLEMS_ERROR)
      else
        WriteLog(SDATABASE_IS_VALID_MESSAGE);

    TDatabaseValidation.Sweep:
      ValidateSQLite.Sweep;
  end;
end;

procedure TMainDataModule.WriteLog(const Text: string);
begin
  if Assigned(FOnDatabaseLog) then
  begin
    FOnDatabaseLog(Text);
  end;
end;

end.



