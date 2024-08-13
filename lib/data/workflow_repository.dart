import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:android_content_provider/android_content_provider.dart';
import 'models/workflow.dart';
import 'database_helper.dart';

class WorkflowRepository {
  static const String _tableName = "workflows";
  final DatabaseHelper _dbHelper;

  WorkflowRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _db => _dbHelper.database;

  Future<void> createTable() async {
    try {
      await (await _db).execute('''
        CREATE TABLE IF NOT EXISTS $_tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT,
          external_id TEXT
        )
      ''');
    } catch (e) {
      print("Error creating table: $e");
      rethrow;
    }
  }

  // FIXME: There is inconsistency in this repository to accomodate for the content provider.
  Future<List<Workflow>> getAll() async {
    final List<Map<String, dynamic>> maps = await query();
    return List.generate(maps.length, (i) => Workflow.fromMap(maps[i]));
  }

  Future<Workflow?> getById(int id) async {
    final db = await _db;
    final maps = await db.query(_tableName, where: 'id = ?', whereArgs: [id], limit: 1);
    if (maps.isNotEmpty) {
      return Workflow.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> query() async {
    final db = await _db;
    return await db.query(_tableName);
  }

  Future<int> insert(Map<String, dynamic> values) async {
    final db = await _db;
    return await db.insert(_tableName, values);
  }

  Future<int> update(Map<String, dynamic> values, String selection, List<String> selectionArgs) async {
    final db = await _db;
    return await db.update(_tableName, values, where: selection, whereArgs: selectionArgs);
  }

  Future<int> delete(String selection, List<String> selectionArgs) async {
    final db = await _db;
    return await db.delete(_tableName, where: selection, whereArgs: selectionArgs);
  }
}