unit GettingStared.Config.Test;

interface

uses
  Spring.Testing,
  GettingStared.Config;

type
  TConfigTest = class(TTestCase)
  strict private
    FConfig: TConfig;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure FileNotExistsTest;
    procedure LoadConfigFailTest;
    procedure SaveConfigTest;
    procedure SaveDatabaseConfigTest;
  end;

implementation



procedure TConfigTest.SetUp;
begin
  FConfig := TConfig.Create;
  FConfig.DeleteFile;
end;

procedure TConfigTest.TearDown;
begin
  FConfig.DeleteFile;

  FConfig.Free;
  FConfig := nil;
end;

procedure TConfigTest.FileNotExistsTest;
begin
  CheckFalse(FConfig.FileExists);
end;

procedure TConfigTest.LoadConfigFailTest;
begin
  CheckFalse(FConfig.Load);
end;

procedure TConfigTest.SaveDatabaseConfigTest;
begin
  CheckFalse(FConfig.FileExists);

  FConfig.DatabaseFile := TConfig.GetDefaultDatabaseFileName;
  CheckTrue(FConfig.Save);

  CheckTrue(FConfig.FileExists);
  CheckTrue(FConfig.Load);
  CheckEquals(TConfig.GetDefaultDatabaseFileName, FConfig.DatabaseFile);
end;

procedure TConfigTest.SaveConfigTest;
begin
  CheckTrue(FConfig.Save);
  CheckTrue(FConfig.FileExists);
end;

end.

