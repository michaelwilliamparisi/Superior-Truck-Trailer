import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {

  static const int _version = 1;
  static const String _dbName = "Trailers.db";

  static Future<Database> getDB() async {

    return openDatabase(join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => 
      await db.execute("CREATE TABLE User(id INTEGER PRIMARY KEY, email TEXT NOT NULL, password TEXT NOT NULL);"), 
      version: _version
    );
  }



}