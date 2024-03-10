import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

import '../models/user_model.dart';

//db variable
var db;
//main function
class DatabaseHandler {

  static Future<Database> getDB() async {
    return openDatabase(
      join(await getDatabasesPath(),'trailerDB'),
      onCreate:(db,ver){
      return db.execute('CREATE TABLE User(id INT PRIMARY KEY, email TEXT NOT NULL, password TEXT NOT NULL)',);        
      },
    //version is used to execute onCreate and make database upgrades and downgrades.
      version:1,    
    );
  }

//Insert
  //the 'future' keyword defines a function that works asynchronously
static Future<void> insertUser(User user) async{
  //local database variable
  final curDB = await db;
  //insert function
  await curDB.insert(
    //first parameter is Table name
    'User',
    //second parameter is data to be inserted
    user.mapUser(),
    //replace if two same entries are inserted
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
//Read
static Future<List<User>> getUsers() async {
  final curDB = await db;
  //query to get all users into a Map list
  final List<Map<String, dynamic>> userMaps = await curDB.query('User');
  //converting the map list to user list
  return List.generate(userMaps.length, (i) {
    //loop to traverse the list and return user object
    return User(
      id: userMaps[i]['id'],
      email: userMaps[i]['email'],
      password: userMaps[i]['password'],
    );
  });
}

//Read Valid User
static Future<bool> validUser(String email, String password) async {
  final curDB = await db;
  //query to get all users into a Map list
  final List<Map<String, dynamic>> userMaps = await curDB.query('User', where: 'email = ?, password = ?', whereArgs: [email, password]);
  //converting the map list to user list
  

  if (List.generate(userMaps.length, (i) {return User(id: userMaps[i]['id'], email: userMaps[i]['email'], password: userMaps[i]['password'],);}).length == 1){
    return true;
  }else {
    return false;
  }



}

//Update
static Future<void> updateUser(User user) async {
  final curDB = await db;
  //update a specific user
  await curDB.update(
    //table name
    'User',
    //convert user object to a map
    user.mapUser(),
    //ensure that the user has a matching email
    where: 'email = ?',
    //argument of where statement(the email we want to search in our case)
    whereArgs: [user.email],
  );
}
//Delete
static Future<void> deleteUser(String email) async {
  final curDB = await db;
  // Delete operation
  await curDB.delete(
    //table name
    'User',
    //'where statement to identify a specific user'
    where: 'email = ?',
    //arguments to the where statement(email passed as parameter in our case)
    whereArgs: [email],
  );
}
}