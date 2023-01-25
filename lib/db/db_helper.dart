// ignore_for_file: unused_local_variable, unused_field, prefer_const_declarations, empty_catches

import 'package:flutter_to_do_app/controller/task.dart';

import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = 'tasks';

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() +
          'tasks.db'; //do (Database  احناهنا بنجيب المسار بتاعDatabaseدا اسم tasks.db)
      _db = await openDatabase(
        //do (بننشأالجدول والاعمده الي فيه وبنديله اسم )
        _path,
        version: _version,
        onCreate: (db, version) {
          print('Create a new data base Done');
          return db.execute(
            "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, data STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER)",
          );
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<int> insert(Task? task) async {
    print('INSERT FUNCTION called');

    return await _db?.insert(
          _tableName,
          task!.tojson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ) ??
        25;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    //to get all data from database
    print('query method called');
    return await _db!.query(_tableName);
  }

  static delet(Task task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static upadata(int id) async {
    return await _db!.rawUpdate('''
    UPDATE tasks 
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }
}
