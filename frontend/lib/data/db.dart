import 'package:path/path.dart';
import '/data/chat.dart';
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

  static Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(
      join(await getDatabasesPath(), 'o2a4.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE chats(userid text, content TEXT, datetime TEXT)",
        );
      },
      version: 1,
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

  static Future<List<Chat>> getChat() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('chats');

    return List.generate(maps.length, (i) {
      return Chat(
        userid: maps[i]['userid'],
        content: maps[i]['content'],
        datetime: maps[i]['datetime'],
      );
    });
  }
}
