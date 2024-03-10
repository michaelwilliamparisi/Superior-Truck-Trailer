import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

import '../models/employee_model.dart';

//db variable
var db;

//main function
class DatabaseHandler {
  static Future<Database> get db async => await getDB();

  static Future<Database> getDB() async {
    String databasesPath = await getDatabasesPath();
    String databasePath = join(databasesPath, 'superior_truck_trailer.db');

    bool databaseExists = await databaseFactory.databaseExists(databasePath);

    // Check if database already exists
    if (!databaseExists) {
      // Copy the asset database to the writable directory
      ByteData data =
          await rootBundle.load('asset/database/superior_truck_trailer.db');
      List<int> bytes = data.buffer.asUint8List();
      await File(databasePath).writeAsBytes(bytes, flush: true);
    }

    return openDatabase(
      databasePath,
      onCreate: (db, ver) {
        return db.execute('''
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
      },
      //version is used to execute onCreate and make database upgrades and downgrades.
      version: 1,
    );
  }

//Insert
  //the 'future' keyword defines a function that works asynchronously
  static Future<void> insertUser(Employee user) async {
    //local database variable
    final curDB = await db;
    //insert function
    await curDB.insert(
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
    final curDB = await db;
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
  static Future<bool> validUser(String email, String password) async {
    final curDB = await db;
    //query to get all users into a Map list
    final List<Map<String, dynamic>> userMaps = await curDB.query('EMP_Table',
        where: 'Email = ? AND Password = ?', whereArgs: [email, password]);
    //converting the map list to user list

    if (List.generate(userMaps.length, (i) {
          return Employee(
            Employee_code: userMaps[i]['Employee_code'],
            Email: userMaps[i]['Email'],
            Password: userMaps[i]['Password'],
          );
        }).length ==
        1) {
      return true;
    } else {
      return false;
    }
  }

//Update
  static Future<void> updateUser(Employee user) async {
    final curDB = await db;
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
    final curDB = await db;
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
