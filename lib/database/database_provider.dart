import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/models/todo_model_constants.dart';

class DatabaseProvider {
  static Database? database;
  final _todoStreamController = StreamController<List<TodoModel>>.broadcast();

  Future<Database?> get db async {
    if (database == null) {
      database = await openDatabasePath();
      refreshTodos();
      return database;
    } else {
      return database;
    }
  }

  Future openDatabasePath() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, dbName);
    Database todoDb = await openDatabase(
      path,
      version: kVersion,
      onCreate: (db, version) async {
        await _onCreate(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < kVersion) {
          await _onCreate(db);
        }
      },
    );
    return todoDb;
  }

  Future<void> _onCreate(Database db) async {
    // await db.execute('DROP TABLE If EXISTS $tableTodo');
    await db.execute('''
      CREATE TABLE $tableTodo (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $columnNote TEXT, 
        $columnDate TEXT, 
        $columnCreationDate TEXT,
        $columnTodoListItem TEXT,
        $columnRepeatItem TEXT,
        $columnIsFinished BOOLEAN)
    ''');
  }

  Future<void> refreshTodos() async {
    final todos = await fetchAllTodos();
    _todoStreamController.add(todos);
  }

  Future<List<TodoModel>> fetchAllTodos() async {
    Database? mydb = await db;
    var list = await mydb!.query(
      tableTodo,
      columns: [
        columnId,
        columnNote,
        columnDate,
        columnCreationDate,
        columnTodoListItem,
        columnRepeatItem,
        columnIsFinished,
      ],
    );
    return list.map((map) => TodoModel.fromMap(map)).toList();
  }

  Stream<List<TodoModel>> readAllData() {
    return _todoStreamController.stream;
  }

  Future<TodoModel?> readNoteData(int? id) async {
    Database? mydb = await db;
    var list = await mydb!.query(
      tableTodo,
      columns: [
        columnId,
        columnNote,
        columnDate,
        columnCreationDate,
        columnTodoListItem,
        columnRepeatItem,
        columnIsFinished,
      ],
      where: '$columnId = ?',
      whereArgs: <Object?>[id],
    );
    if (list.isNotEmpty) {
      return TodoModel.fromMap(list.first);
    }
    return null;
  }

  Future<int> saveData(TodoModel todo) async {
    Database? mydb = await db;
    int id = await mydb!.insert(tableTodo, {
      columnNote: todo.note,
      columnDate: todo.toDate,
      columnCreationDate: todo.creationDate,
      columnTodoListItem: todo.todoListItem,
      columnRepeatItem: todo.todoRepeatItem,
      columnIsFinished: todo.isFinished ?? false ? 1 : 0,
    });
    await refreshTodos(); // Update stream after insert
    return id;
  }

  Future<int> updateData(TodoModel todo) async {
    Database? mydb = await db;
    int count = await mydb!.update(
      tableTodo,
      {
        columnNote: todo.note,
        columnDate: todo.toDate,
        columnCreationDate: todo.creationDate,
        columnTodoListItem: todo.todoListItem,
        columnRepeatItem: todo.todoRepeatItem,
        columnIsFinished: todo.isFinished ?? false ? 1 : 0,
      },
      where: '$columnId = ?',
      whereArgs: [todo.id],
    );
    await refreshTodos(); // Update stream after update
    return count;
  }

  Future<void> deleteNote(int? id) async {
    Database? mydb = await db;
    await mydb!.delete(
      tableTodo,
      where: '$columnId = ?',
      whereArgs: <Object?>[id],
    );
    await refreshTodos(); // Update stream after delete
  }

  // Close the stream controller when no longer needed
  void dispose() {
    _todoStreamController.close();
  }
}
