unit GettingStarted.Testing.Config;

interface

procedure RegisterTestCases;

implementation

uses
  Spring.Testing,
  ///
  GettingStared.Config.Test,
  GettingStart.Database.Test;

procedure RegisterTestCases;
begin
  TConfigTest.Register;
  TDatabaseTest.Register;
end;


end.
