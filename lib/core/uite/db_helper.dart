import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  /// create one object from this class
  static final NotesDatabase _instance = NotesDatabase._internal();

  factory NotesDatabase() => _instance;

  static Database? _database;

  NotesDatabase._internal();

  /// method [get database if exists if not create new one]
  Future<Database> get database async {
    /// if database exists return it
    if (_database != null) return _database!;

    /// if database not exists create new one
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    /// get path to database
    final path = join(await getDatabasesPath(), 'notes.db');

    /// open database
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    /// create table notes
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');
  }

  /// Insert new note
  Future<int> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    return await db.insert('notes', note);
  }

  /// Get all notes
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;
    return await db.query('notes', orderBy: "id DESC");
  }

  /// Update note
  Future<int> updateNote(Map<String, dynamic> note) async {
    final db = await database;
    return await db.update(
      'notes',
      note,
      where: 'id = ?',
      whereArgs: [note['id']],
    );
  }

  /// Delete note
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}