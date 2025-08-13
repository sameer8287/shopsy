import 'package:pocket_fm/features/cart/data/local/schema/cart_schema.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import '../../core/uitls/helper_function.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return instance;
  }

  static Database? _database;

  final String _dbName = 'pocket_fm.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    try {
      String dbpath = await getDatabasesPath();
      dbpath = path.join(dbpath, _dbName);

      return await openDatabase(
        dbpath,
        version: 1,
        onCreate: (db, version) async {
          // Here you can create your tables
          // Example:
          // await db.execute('CREATE TABLE example (id INTEGER PRIMARY KEY, name TEXT)');
          return await _onCreate(db, version);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          // Handle database upgrades if needed
        },
      );
    } catch (e) {
      HelperFunctions.printLog('Error initializing database', e);
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // This method can be used to create tables if needed
    // Example:
    // await db.execute('CREATE TABLE example (id INTEGER PRIMARY KEY, name TEXT)');
    await db.execute(CartSchema.createTableQuery);
  }

  // Retrieve all rows from a table
  Future<List<Map<String, dynamic>>> queryAllRows(
    String table, {
    List<String>? columns,
    String? where,
    int? offset,
    int? limit,
    String? orderBy,
  }) async {
    final db = await database;
    return await db.query(table, columns: columns, where: where, offset: offset, limit: limit, orderBy: orderBy);
  }

  Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    final db = await database;
    return await db.rawQuery(query);
  }

  Future<int> update(String table, Map<String, dynamic> row, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.update(table, row, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, {required String where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
