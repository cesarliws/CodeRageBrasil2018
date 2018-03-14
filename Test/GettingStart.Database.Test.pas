unit GettingStart.Database.Test;

interface

uses
  Spring.Testing,
  GettingStarted.Main.DataModule;

type
  TDatabaseTest = class(TTestCase)
  strict private
    FMainDataModule: TMainDataModule;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure DefaultConnectionTest;

    [TestCase('Categoria 1,Descrição 1')]
    [TestCase('Categoria 2,Descrição 2')]
    [TestCase('Categoria 3,Descrição 3')]
    [TestCase('Categoria 4,Descrição 4')]
    procedure InsertTest(const Categoria, Descricao: string);

    [TestCase('Categoria,')]
    [TestCase(',Descricao')]
    [ExpectedException(EDataValidation)]
    procedure InsertTestException(const Categoria, Descricao: string);
  end;

implementation

procedure TDatabaseTest.SetUp;
begin
  FMainDataModule := TMainDataModule.Create(nil);
  FMainDataModule.OpenDefaultDatabase;
end;

procedure TDatabaseTest.TearDown;
begin
  FMainDataModule.Free;
end;

procedure TDatabaseTest.DefaultConnectionTest;
begin
  Check(FMainDataModule.IsConnected);
end;

procedure TDatabaseTest.InsertTest(const Categoria, Descricao: string);
var
  ID: Integer;
begin
  ID := FMainDataModule.Insert(Categoria, Descricao, $001);
  Check(ID > 0);
  Check(FMainDataModule.CategoriesQuery.Locate('CategoryID', ID));
  CheckEquals(Categoria, FMainDataModule.CategoriesQuery.FieldByName('CategoryName').AsString);
  CheckEquals(Descricao, FMainDataModule.CategoriesQuery.FieldByName('Description').AsString);
end;

procedure TDatabaseTest.InsertTestException(const Categoria, Descricao: string);
begin
  FMainDataModule.Insert(Categoria, Descricao, $002);
end;

end.
