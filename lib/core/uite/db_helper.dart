import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {

  static final NotesDatabase _instance = NotesDatabase._internal();

  factory NotesDatabase() => _instance;

  static Database? _database;

  NotesDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }


  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'notes.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {

    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE user_profile(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        phone TEXT,
        age TEXT,
        weight TEXT,
        height TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE appointments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        note TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_profile(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT,
          phone TEXT,
          age TEXT,
          weight TEXT,
          height TEXT
        )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS appointments(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          date TEXT NOT NULL,
          time TEXT NOT NULL,
          note TEXT
        )
      ''');
    }
  }


  Future<int> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    return await db.insert('notes', note);
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;
    return await db.query('notes', orderBy: 'id DESC');
  }

  Future<int> updateNote(Map<String, dynamic> note) async {
    final db = await database;
    return await db.update(
      'notes',
      note,
      where: 'id = ?',
      whereArgs: [note['id']],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final db = await database;
    final result = await db.query(
      'user_profile',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<int> upsertProfile(Map<String, dynamic> profile) async {
    final db = await database;

    final existing = await db.query(
      'user_profile',
      limit: 1,
    );

    if (existing.isEmpty) {

      return await db.insert('user_profile', profile);
    } else {

      int id = existing.first['id'] as int;
      return await db.update(
        'user_profile',
        profile,
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }


  Future<int> insertAppointment(Map<String, dynamic> appointment) async {
    final db = await database;
    return await db.insert('appointments', appointment);
  }

  Future<List<Map<String, dynamic>>> getAllAppointments() async {
    final db = await database;
    return await db.query(
      'appointments',
      orderBy: 'id DESC',
    );
  }

  Future<int> deleteAppointment(int id) async {
    final db = await database;
    return await db.delete(
      'appointments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
