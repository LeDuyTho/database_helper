/// Database
class DatabaseInfo {
  String _databaseName;
  int _databaseVersion;

  DatabaseInfo(String dbName, int dbVersion) {
    _databaseName = dbName;
    _databaseVersion = dbVersion;
  }

  String get databaseName => _databaseName;

  int get databaseVersion => _databaseVersion;
}

/// Table
class TableInfo {
  String tableName;
  List<ColumnInfo> columns;

  TableInfo(this.tableName, this.columns);

  String get queryCreateTable {
    String query = '';
    String sFields = '';

    String primary = '';
    String nullValue = '';
    String type = '';

    for (int i = 0; i < columns.length; i++) {
      ColumnInfo col = columns[i];
      if (col.isPrimaryKey) {
        primary = ' PRIMARY KEY';
        nullValue = '';
      } else {
        primary = '';
        nullValue = (col.isNull) ? '' : ' NOT NULL';
      }

      type = col.type;

      if (i == 0)
        sFields =
            'CREATE TABLE $tableName (${col.columnName}$type$primary$nullValue';
      else
        sFields = ',${col.columnName}$type$primary$nullValue';

      query += sFields;
    }

    query += ')';

    return query;
  }
}

/// Column
class ColumnInfo {
  String columnName;
  SqliteType columnType;
  bool isNull;
  bool isPrimaryKey;

  ColumnInfo(
    this.columnName,
    this.columnType, {
    this.isNull = true,
    this.isPrimaryKey = false,
  });

  String get type {
    switch (columnType) {
      case SqliteType.INTEGER:
        return 'INTEGER';
      case SqliteType.TEXT:
        return 'TEXT';
      case SqliteType.REAL:
        return 'REAL';
      case SqliteType.NUMERIC:
        return 'NUMERIC';
      case SqliteType.BLOB:
        return 'BLOB';
      default:
        return '';
    }
  }
}

/// Sqlite data type
enum SqliteType {
  INTEGER,
  TEXT,
  REAL,
  NUMERIC,
  BLOB,
}
