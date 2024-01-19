import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RecipeDatabaseHelper {
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
          name TEXT,
          ingradient TEXT,
          time TEXT,
          instruction TEXT,
          imagePath TEXT
        )
      ''');
    });
  }

  static Future<int> insertRecipe(Map<String, dynamic> recipe) async {
    Database db = await database;
    return await db.insert(tableName, recipe);
  }

  static Future<List<Map<String, dynamic>>> getAllRecipes() async {
    Database db = await database;
    return await db.query(tableName);
  }
}


