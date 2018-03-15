unit GettingStarted.Sql;

interface

const
  DRIVERID_SQLITE_PARAM = 'DriverID=SQLite';
  SDATABASE_PARAM       = 'Database=';
  ///
  DELETE_CATEGORIES_SQL =
    'delete from Categories where CategoryName like :N';

  INSERT_CATEGORIES_SQL =
    'insert into Categories(CategoryName, Description, Picture) values(:N, :D, :P)';

  SELECT_MAX_CATEGORYID_SQL =
    'select MAX(CategoryID) from Categories';

  UPDATE_PRODUCTS_SQL =
    'update Products set UnitPrice = UnitPrice * :P1 + :P2 where ProductID < 3';

implementation

end.
