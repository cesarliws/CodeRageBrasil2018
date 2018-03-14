unit Common.Testing;

interface

procedure RunRegisteredTests;

implementation

uses
{$IFDEF TESTINSIGHT}
  TestInsight.DUnit;
{$ELSE}
  DUnitTestRunner;
{$ENDIF}

procedure RunRegisteredTests;
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnit.RunRegisteredTests;
{$ELSE}
  DUnitTestRunner.RunRegisteredTests;
{$ENDIF}
end;

end.
