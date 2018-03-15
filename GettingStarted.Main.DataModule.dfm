object MainDataModule: TMainDataModule
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Height = 444
  Width = 540
  object WaitCursorFireDAC: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrHourGlass
    Left = 312
    Top = 312
  end
  object BackupSQLite: TFDSQLiteBackup
    DriverLink = DriverLinkSQLite
    Catalog = 'MAIN'
    DestCatalog = 'MAIN'
    Left = 48
    Top = 160
  end
  object ValidateSQLite: TFDSQLiteValidate
    DriverLink = DriverLinkSQLite
    OnProgress = ValidateSQLiteProgress
    Left = 176
    Top = 168
  end
  object SecuritySQLite: TFDSQLiteSecurity
    DriverLink = DriverLinkSQLite
    Left = 312
    Top = 168
  end
  object CategoriesQuery: TFDQuery
    Connection = DatabaseConnection
    SQL.Strings = (
      'select * from Categories')
    Left = 176
    Top = 15
  end
  object CategoriesDataSource: TDataSource
    DataSet = CategoriesQuery
    Left = 312
    Top = 15
  end
  object DriverLinkSQLite: TFDPhysSQLiteDriverLink
    Left = 48
    Top = 9
  end
  object DatabaseConnection: TFDConnection
    Params.Strings = (
      'Password=12345')
    LoginPrompt = False
    BeforeConnect = DatabaseConnectionBeforeConnect
    BeforeDisconnect = DatabaseConnectionBeforeDisconnect
    Left = 48
    Top = 64
  end
  object ProductsQuery: TFDQuery
    MasterSource = CategoriesDataSource
    MasterFields = 'CategoryId'
    Connection = DatabaseConnection
    FetchOptions.AssignedValues = [evMode, evItems, evCache]
    FetchOptions.Mode = fmAll
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      'select *, '
      'StockPrice(UnitPrice, UnitsInStock) as StockCost '
      'from Products'
      'where CategoryId = :CategoryID')
    Left = 176
    Top = 72
    ParamData = <
      item
        Name = 'CATEGORYID'
        DataType = ftAutoInc
        ParamType = ptInput
        Size = 4
        Value = Null
      end>
  end
  object LoginDialogFireDAC: TFDGUIxLoginDialog
    Provider = 'Forms'
    Left = 48
    Top = 312
  end
  object ErrorDialogFireDAC: TFDGUIxErrorDialog
    Provider = 'Forms'
    Caption = 'FireDAC Executor Error'
    Left = 176
    Top = 312
  end
  object FunctionSQLite: TFDSQLiteFunction
    DriverLink = DriverLinkSQLite
    FunctionName = 'StockPrice'
    ArgumentsCount = 2
    OnCalculate = FunctionSQLiteCalculate
    Left = 48
    Top = 232
  end
end
