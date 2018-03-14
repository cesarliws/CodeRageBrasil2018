program GettingStartedTests;

uses
  TestFramework,
  Spring.Testing,
  {$IFDEF TESTINSIGHT}
  TestInsight.Client,
  TestInsight.DUnit,
  {$ENDIF }
  Common.Testing in 'Common\Common.Testing.pas',
  GettingStarted.Testing.Config in 'Common\GettingStarted.Testing.Config.pas',
  GettingStared.Config in '..\Config\GettingStared.Config.pas',
  GettingStart.Database.Test in 'GettingStart.Database.Test.pas',
  GettingStared.Config.Test in 'GettingStared.Config.Test.pas',
  GettingStarted.Main.DataModule in '..\GettingStarted.Main.DataModule.pas' {MainDataModule: TDataModule};

{$R *.res}

begin
  RegisterTestCases;
  RunRegisteredTests;
  TestFramework.ClearRegistry;
end.

