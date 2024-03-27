import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import '../models/employee_model.dart';

//main function
class DatabaseHandler {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    // Get the application documents directory (using path_provider)
    //final documentsDirectory = "asset/database/superior_truck_trailer.db";
    final dbpath = "asset/database/superior_truck_trailer.db";

    print("Database path: $dbpath"); // Fixed typo in path variable name

    if (await databaseExists(dbpath)) {
      print("Database already exists");
    } else {
      // Copy the database from the assets directory (if needed)
      final data =
          await rootBundle.load("asset/database/superior_truck_trailer.db");
      final bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbpath).writeAsBytes(bytes, flush: true);
      print("Database copied to $dbpath");
    }

    return await openDatabase(dbpath, version: 1,
        onCreate: (db, version) async {
      // Your database creation logic here (if needed)
      ('''
          CREATE TABLE Job (
              Job_code TEXT PRIMARY KEY,
              Job_code_description TEXT,
              Emp_num TEXT REFERENCES EMP_Table(Employee_code),
              Work_hours INTEGER
          );

          -- Create EMP_Table
          CREATE TABLE EMP_Table (
              UserName TEXT,
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
    });
  }

//Insert
  //the 'future' keyword defines a function that works asynchronously
  static Future<void> insertUser(Employee user) async {
    DatabaseHandler.initDatabase();
    //local database variable
    final curDB = _database;
    //insert function
    await curDB?.insert(
      //first parameter is Table name
      'EMP_Table',
      //second parameter is data to be inserted
      user.mapUser(),
      //replace if two same entries are inserted
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//Read
  static Future<List<Employee>> getUsers() async {
    final curDB = await database;
    //query to get all users into a Map list
    final List<Map<String, dynamic>> userMaps = await curDB.query('EMP_Table');
    //converting the map list to user list
    return List.generate(userMaps.length, (i) {
      //loop to traverse the list and return user object
      return Employee(
        Employee_code: userMaps[i]['Employee_code'],
        Email: userMaps[i]['Email'],
        Password: userMaps[i]['Password'],
      );
    });
  }

//Read Valid User
  static Future<Employee?> validUser(String email, String password) async {
    final curDB = await database;
    // Query to get the user with the provided email and password
    List<Map<String, dynamic>> userMaps = await curDB.query('EMP_Table',
        where: 'Email = ? AND Password = ?', whereArgs: [email, password]);

    // If user found, return Employee object, else return null
    if (userMaps.isNotEmpty) {
      return Employee(
        Employee_code: userMaps[0]['Employee_code'],
        Email: userMaps[0]['Email'],
        Password: userMaps[0]['Password'],
        // Add other fields as needed
      );
    } else {
      return null;
    }
  }

//Update
  static Future<void> updateUser(Employee user) async {
    final curDB = await database;
    //update a specific user
    await curDB.update(
      //table name
      'EMP_Table',
      //convert user object to a map
      user.mapUser(),
      //ensure that the user has a matching email
      where: 'Email = ?',
      //argument of where statement(the email we want to search in our case)
      whereArgs: [user.Email],
    );
  }

//Delete
  static Future<void> deleteUser(String Email) async {
    final curDB = await database;
    // Delete operation
    await curDB.delete(
      //table name
      'EMP_Table',
      //'where statement to identify a specific user'
      where: 'Email = ?',
      //arguments to the where statement(email passed as parameter in our case)
      whereArgs: [Email],
    );
  }
}
