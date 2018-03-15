unit GettingStarted.Config;

interface

type
  TConfig = class(TObject)
  private
    FDatabaseFile: string;
    FFileName: string;
  public
    class function GetDefaultFileName: string; static;
    class function GetDefaultDatabaseFileName: string; static;
  public
    constructor Create(const FileName: string); overload;
    constructor Create; overload;

    function DeleteFile: Boolean;
    function FileExists: Boolean;
    function Load: Boolean;
    function Save: Boolean;

    property FileName: string read FFileName;
    property DatabaseFile: string read FDatabaseFile write FDatabaseFile;
  end;

implementation

uses
  System.IniFiles,
  System.SysUtils,
  Vcl.Forms;

constructor TConfig.Create(const FileName: string);
begin
  inherited Create;
  FFileName := FileName;
end;

constructor TConfig.Create;
begin
  Create(TConfig.GetDefaultFileName);
end;

function TConfig.DeleteFile: Boolean;
begin
  Result := FileExists and System.SysUtils.DeleteFile(FFileName);
end;

function TConfig.FileExists: Boolean;
begin
  Result := System.SysUtils.FileExists(FFileName);
end;

class function TConfig.GetDefaultDatabaseFileName: string;
begin
  Result := ExtractFilePath(Application.ExeName) + 'Data\fddemo.sdb';
end;

class function TConfig.GetDefaultFileName: string;
begin
  Result := ChangeFileExt(Application.ExeName, '.ini');
end;

function TConfig.Load: Boolean;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FFileName);
  try
     FDatabaseFile := IniFile.ReadString('Database', 'FileName', FDatabaseFile);
     Result := FileExists;
  finally
    IniFile.Free;
  end;
end;

function TConfig.Save: Boolean;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FFileName);
  try
   IniFile.WriteString('Database', 'FileName', FDatabaseFile);
   Result := FileExists;
finally
  IniFile.Free;
end;
end;

end.
