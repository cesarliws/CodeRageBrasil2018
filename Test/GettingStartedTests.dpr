program GettingStartedTests;

uses
  TestFramework,
  Spring.Testing,
  Common.Testing in 'Common\Common.Testing.pas',
  GettingStarted.Testing.Config in 'Common\GettingStarted.Testing.Config.pas',
  GettingStarted.Config in '..\Config\GettingStarted.Config.pas',
  GettingStart.Database.Test in 'GettingStart.Database.Test.pas',
  GettingStared.Config.Test in 'GettingStared.Config.Test.pas',
  GettingStarted.Main.DataModule in '..\GettingStarted.Main.DataModule.pas' {MainDataModule: TDataModule},
  GettingStarted.Sql in '..\GettingStarted.Sql.pas',
  GettingStarted.Consts in '..\GettingStarted.Consts.pas';

{$R *.res}

begin
  RegisterTestCases;
  RunRegisteredTests;
  TestFramework.ClearRegistry;
end.

