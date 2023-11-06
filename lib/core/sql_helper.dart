import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class SQLHelper {
  static Future<void> createDatabaseTableQuerry(
      sqflite.Database database) async {
    await database.execute("""CREATE TABLE items(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
   )""");
  }

  static Future<sqflite.Database> createDatabase() async {
    return sqflite.openDatabase('test_db.db', version: 1,
        onCreate: (sqflite.Database database, int version) async {
      await createDatabaseTableQuerry(database);
    });
  }

  static Future<int> createItem(String title, String? description) async {
    final db = await SQLHelper.createDatabase();

    final data = {'title': title, 'description': description};

    final id = await db.insert('items', data,
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.createDatabase();
    return db.query('items', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.createDatabase();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(
      int id, String title, String description) async {
    final db = await SQLHelper.createDatabase();

    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.createDatabase();
    try {
      await db.delete('items', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint('Something went wrong $err');
    }
  }
}
