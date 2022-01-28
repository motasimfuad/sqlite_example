import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_example/notes_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    print("initDB executed");
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    print("executing");
    await db.execute('''
      CREATE TABLE IF NOT EXISTS note (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title	TEXT NOT NULL,
        description	TEXT NOT NULL
      );
    ''');
  }

  Future<int> insert(NoteModel noteModel) async {
    print("inserting");
    var dbClient = await db;
    var noteId = await dbClient!.insert('note', noteModel.toMap());
    getNotes();
    return noteId;
  }

  Future<List<NoteModel>> getNotes() async {
    var dbClient = await db;
    final List<Map<String, Object?>> getQurey = await dbClient!.query('note');
    return getQurey.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<int> deleteNote(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'note',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateNote(NoteModel noteModel) async {
    var dbClient = await db;
    return await dbClient!.update(
      'note',
      noteModel.toMap(),
      where: 'id = ?',
      whereArgs: [noteModel.id],
    );
  }
}
