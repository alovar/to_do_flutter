import 'package:to_do_flutter/model/note_task.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "notes_data_base.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Notes(id INTEGER PRIMARY KEY, task TEXT, priority INTEGER )");
    print("Created tables");
  }

  Future<List<NoteTask>> getNotes() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Notes');
    List<NoteTask> notes = new List();
    for (int i = 0; i < list.length; i++) {
      notes.add(new NoteTask(list[i]["task"], list[i]["priority"]));
    }
    print(notes.length);
    return notes;
  }

  void saveNote(NoteTask notes) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Notes(task, priority) VALUES(?, ?)',
          [notes.task, notes.priority]
      );
    });

  }

  void deleteNote(String task) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawDelete(
          'DELETE FROM Notes WHERE task = ?', [task]
      );
    });

  }

  void updateNote(NoteTask note, String oldTask) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawUpdate(
          'UPDATE Notes SET task = ?, priority = ? WHERE task = ?',
          [note.task, note.priority, oldTask]
      );
    });

  }


}