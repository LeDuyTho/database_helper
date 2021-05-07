import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'db_base.dart';

/// Usage:
/// getDatabase
/// getDatabaseFromAsset
/// getDatabaseFromInternet
class DatabaseCreator {
  // make this a singleton class
  DatabaseCreator._privateConstructor();

  static final DatabaseCreator instance = DatabaseCreator._privateConstructor();

  //DatabaseInfo _dbInfo;
  TableInfo _tblInfo;

  // only have a single app-wide reference to the database
  static Database _database;

  ///=========== CREATOR From EMPTY ===========///
  Future<Database> getDatabase(DatabaseInfo dbInfo, TableInfo tblInfo) async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    //_dbInfo = dbInfo;
    _tblInfo = tblInfo;
    _database = await _initDatabase(dbInfo, tblInfo);
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase(DatabaseInfo dbInfo, TableInfo tblInfo) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbInfo.databaseName);
    return await openDatabase(path,
        version: dbInfo.databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(_tblInfo.queryCreateTable);
  }

  ///=========== CREATOR From ASSET ===========///
  ///[dbName] like "englishDictionary.db"
  /// asset db path like this: assets/englishDictionary.db
  Future<Database> getDatabaseFromAsset(String assetDbName) async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabaseFromAsset(assetDbName);
    return _database;
  }

  /// Open database from assets
  Future<Database> _initDatabaseFromAsset(String assetDbName) async {
    Directory applicationDirectory = await getApplicationDocumentsDirectory();

    String dbPath = join(applicationDirectory.path, assetDbName);

    bool dbExists = await File(dbPath).exists();

    if (!dbExists) {
      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", assetDbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(dbPath);
  }

  ///=========== CREATOR From INTERNET ===========///

  Future<Database> getDatabaseFromInternet(
      String url, String setLocalDbName) async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabaseFromInternet(url, setLocalDbName);
    return _database;
  }

  /// Open database from internet
  Future<Database> _initDatabaseFromInternet(
      String urlDb, String setLocalDbName) async {
    Directory applicationDirectory = await getApplicationDocumentsDirectory();

    String dbPath = join(applicationDirectory.path, setLocalDbName);

    bool dbExists = await File(dbPath).exists();

    if (!dbExists) {
      String url = urlDb;

      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();

      // thow an error if there was error getting the file
      // so it prevents from wrting the wrong content into the db file
      if (response.statusCode != 200) throw "Error getting db file";

      var bytes = await consolidateHttpClientResponseBytes(response);

      File file = new File(dbPath);
      await file.writeAsBytes(bytes);
    }

    return await openDatabase(dbPath);
  }
}
