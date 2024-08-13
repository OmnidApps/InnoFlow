import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'models/usecase.dart';

// TODO: Extract to generic
class UsecaseRepository {
  static const String _tableName =  "usecases";
  final DatabaseHelper _dbHelper;

  UsecaseRepository({DatabaseHelper? dbHelper}) 
      : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _db => _dbHelper.database;

  Future<void> createTable() async {
    try {
      await (await _db).execute('''
        CREATE TABLE IF NOT EXISTS $_tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT,
          workflow_id INTEGER
        )
      ''');
    } catch (e) {
      print("Error creating table: $e");
      rethrow;
    }
  }

  Future<int> insert(Usecase item) async {
    return (await _db).insert(_tableName, item.toMap());
  }

  Future<List<Usecase>> getAll() async {
    final List<Map<String, dynamic>> maps = await (await _db).query(_tableName);
    return List.generate(maps.length, (i) => Usecase.fromMap(maps[i]));
  }

  Future<Usecase?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await (await _db).query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Usecase.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(Usecase item) async {
    return (await _db).update(
      _tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    return (await _db).delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}