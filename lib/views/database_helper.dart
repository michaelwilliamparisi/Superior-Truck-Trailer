// Page to interact with the database

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'superior_truck_trailer.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create tables here if needed
        await db.execute('''
          CREATE TABLE Job (
              Job_code TEXT PRIMARY KEY,
              Job_code_description TEXT,
              Emp_num TEXT REFERENCES EMP_Table(Employee_code),
              Work_hours INTEGER
          );

          -- Create EMP_Table
          CREATE TABLE EMP_Table (
              Fname TEXT,
              Lname TEXT,
              Address TEXT,
              Phone TEXT,
              Email TEXT,
              Employee_code TEXT PRIMARY KEY,
              Password TEXT
          );

          -- Create Trailer_Inventory table
          CREATE TABLE Trailer_Inventory (
              Trailer_num TEXT PRIMARY KEY,
              Length REAL,
              Width REAL,
              Height REAL,
              Weight REAL,
              Milage REAL,
              Customer_id TEXT REFERENCES Customer_table(Customer_id)
          );
          CREATE TABLE Customer_table (
            Name TEXT,
            Location TEXT,
            Customer_id TEXT PRIMARY KEY,
            Contact TEXT
          );
          -- Create Vendor_table
          CREATE TABLE Vendor_table (
              Vendor_num TEXT PRIMARY KEY,
              Name TEXT,
              Location TEXT,
              Phone TEXT,
              Email TEXT,
              Work_order_num TEXT REFERENCES Work_Orders(Work_order_num)
          );

          -- Create Work_Orders table
          CREATE TABLE Work_Orders (
              Work_order_num TEXT PRIMARY KEY,
              Emp_num TEXT REFERENCES EMP_Table(Employee_code),
              Trailer_num TEXT REFERENCES Trailer_Inventory(Trailer_num)
          );
        ''');
        // Add other tables as needed
      },
    );
  }

  // Add methods to perform CRUD operations on your tables
  Future<bool> isUserValid(String userName, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'EMP_Table',
      where: 'UserName = ? AND Password = ?',
      whereArgs: [userName, password],
    );

    return result.isNotEmpty;
  }
}
