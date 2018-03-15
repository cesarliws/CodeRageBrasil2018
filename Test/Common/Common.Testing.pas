unit Common.Testing;

interface

{$IFNDEF TESTINSIGHT}
uses
  DUnitTestRunner;
{$ELSE}
uses
  TestInsight.Client,
  TestInsight.DUnit;
{$ENDIF}

procedure RunRegisteredTests;

implementation

procedure RunRegisteredTests;
begin
{$IFNDEF TESTINSIGHT}
  DUnitTestRunner.RunRegisteredTests;
{$ELSE}
  TestInsight.DUnit.RunRegisteredTests;
{$ENDIF}
end;

end.
