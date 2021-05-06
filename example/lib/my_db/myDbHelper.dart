import 'package:database_helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class MyDbHelper extends DatabaseHelper {
  MyDbHelper._privateConstructor();

  static final MyDbHelper instance = MyDbHelper._privateConstructor();

  /// IMPORTANT: Remember override this method!
  @override
  Future<Database> getDb() async {
    return await DatabaseCreator.instance.getDatabaseFromAsset("SinhVien.db");
  }
}
