

import 'package:database_helper/database_helper.dart';

///========== DATABASE ==========///
final DatabaseInfo databaseInfo = DatabaseInfo('MyDatabase.db', 2);

///========== TABLE ==========///
final TableInfo tableInfo = TableInfo('my_table', [
  columnId,
  columnName,
  columnAge,
]);

final ColumnInfo columnId =
    ColumnInfo('_id', SqliteType.INTEGER, isPrimaryKey: true);
final ColumnInfo columnName =
    ColumnInfo('name', SqliteType.TEXT, isNull: false);
final ColumnInfo columnAge = ColumnInfo('age', SqliteType.TEXT, isNull: false);
