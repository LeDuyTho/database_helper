library database_helper;

import 'package:sqflite/sqflite.dart';

export 'db_base.dart';
export 'db_creator.dart';

abstract class DatabaseHelper {
  ///--- get database
  /// Please override this method
  //return await DatabaseCreator.instance.getDatabase(databaseInfo, tableInfo);
  //return await DatabaseCreator.instance.getDatabaseFromAsset("mydb.db");
  Future<Database> getDb();

  void printAllRows(String tableName) async {
    final allRows = await (await getDb()).query(tableName);
    print('query all rows:');
    allRows.forEach(print);
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(String tableName, Map<String, dynamic> row) async {
    return await (await getDb()).insert(tableName, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    return await (await getDb()).query(tableName);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> rowCount(String tableName) async {
    return Sqflite.firstIntValue(
        await (await getDb()).rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(
      String tableName, String columnName, Map<String, dynamic> row) async {
    int id = row[columnName];
    return await (await getDb())
        .update(tableName, row, where: '$columnName = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(
      String tableName, String columnName, List<dynamic> arguments) async {
    return await (await getDb())
        .delete(tableName, where: '$columnName = ?', whereArgs: arguments);
  }

  Future<int> deleteById(int id, String tableName, String columnName) async {
    return await (await getDb())
        .delete(tableName, where: '$columnName = ?', whereArgs: [id]);
  }
}
