import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// import 'Photo.dart';

class DBHelper {
  static final _databaseName = 'User.db';
  static final _databaseVersion = 1;
  static final table = 'user_table';
  static final columnID = 'id';
  static final columnName = 'name';
  static final columnEmail = 'email';
  static final columnPasscode = 'passcode';
  static final columnNumber = 'number';
  static final columnPhoto = 'photo';

  static Database _db;

  DBHelper._privateConstructor();

  static final DBHelper instance = DBHelper._privateConstructor();

  Future<Database> get db async {
    if (null != _db) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    var db = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $table ($columnID INTEGER PRIMARY KEY, $columnName TEXT NOT NULL, $columnEmail TEXT NOT NULL, $columnPasscode TEXT NOT NULL, $columnNumber INTEGER NOT NULL, $columnPhoto TEXT NOT NULL)");
  }

  // Database CRUD Operations

  Future<int> insert(Map<String, dynamic> row) async {
    Database database = await instance.db;
    return await database.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> querySpecific(
      String email, String passcode) async {
    Database database = await instance.db;
    var res = await database.query(table,
        where: 'email = ? and passcode = ?', whereArgs: [email, passcode]);
    return res;
  }

  // Future<Photo> save(Photo employee) async {
  //   var dbClient = await db;
  //   employee.id = await dbClient.insert(TABLE, employee.toMap());
  //   return employee;
  // }

  // Future<List<Photo>> getPhotos() async {
  //   var dbClient = await db;
  //   List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME]);
  //   List<Photo> employees = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       employees.add(Photo.fromMap(maps[i]));
  //     }
  //   }
  //   return employees;
  // }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
