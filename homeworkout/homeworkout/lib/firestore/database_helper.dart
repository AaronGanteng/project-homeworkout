import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Singleton pattern agar hanya ada 1 koneksi database
  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'homeworkout.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Membuat Tabel saat pertama kali aplikasi diinstall
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workout_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workoutTitle TEXT,
        duration INTEGER, -- dalam menit
        kcal INTEGER,
        date TEXT -- Format ISO8601 (YYYY-MM-DD)
      )
    ''');
  }

  // --- FUNGSI CRUD (Create, Read) ---

  // 1. Insert Log Baru
  Future<int> insertLog(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('workout_logs', row);
  }

  // 2. Ambil Semua Log (Untuk ditampilkan di List)
  Future<List<Map<String, dynamic>>> getLogs() async {
    Database db = await database;
    // Urutkan dari yang terbaru (DESC)
    return await db.query('workout_logs', orderBy: 'date DESC');
  }

  // 3. Hapus Log (Opsional)
  Future<int> deleteLog(int id) async {
    Database db = await database;
    return await db.delete('workout_logs', where: 'id = ?', whereArgs: [id]);
  }
}