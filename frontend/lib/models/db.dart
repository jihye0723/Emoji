import 'package:path/path.dart';
import 'package:practice_01/models/chat.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:async';


class DBHelper {
  static var _db;
  // void db() async {
  //   final database = openDatabase(
  //     join(await getDatabasesPath(), 'chats.db'),
  //     onCreate: (db, version) {
  //       return db.execute(
  //         "CREATE TABLE chats(id INTEGER PRIMARY KEY, userid text, content TEXT, datetime TEXT)",
  //       );
  //     },
  //     version: 1,
  //   );

  static Future<Database> get database async{
    if( _db != null ) return _db;
    _db = openDatabase(
      join(await getDatabasesPath(), 'o2a4.db'),
      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE chats(id INTEGER PRIMARY KEY, userid text, content TEXT, datetime TEXT)",
         );
       },
      version : 1,
    );
  return _db;
  }
    static Future<void> insertChat(Chat chat) async {
      final Database db = await database;

      await db.insert(
        'chats',
        chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }


