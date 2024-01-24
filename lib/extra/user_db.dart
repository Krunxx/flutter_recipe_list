import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class userDatabaseHelper {
  static Database? _database;
  static const String tableName = 'recipes';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'recipes.db');
    return openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT,
          password TEXT
        )
      ''');
    });
  }

  static Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert(tableName, user);
  }

  static Future<List<Map<String, dynamic>>> getAllUser() async {
    Database db = await database;
    return await db.query(tableName);
  }
}


