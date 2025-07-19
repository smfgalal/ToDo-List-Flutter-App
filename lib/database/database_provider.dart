import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/categories_list_model.dart';
import 'package:todo_app/models/repeat_list_model.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/models/todo_model_constants.dart';

class DatabaseProvider {
  static Database? database;
  final _todoStreamController = StreamController<List<TodoModel>>.broadcast();
  final _categoriesListsStreamController =
      StreamController<List<CategoriesListsModel>>.broadcast();
  final _repeatListsStreamController =
      StreamController<List<RepeatListsModel>>.broadcast();
  Future<Database?> get db async {
    if (database == null) {
      database = await openDatabasePath();
      await refreshTodos();
      await refreshCategoriesList();
      await refreshRepeatList();
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
        $columnIsFinished BOOLEAN,
        $columnOriginalCategory TEXT)
    ''');

    await db.execute('''
  CREATE TABLE $categoriesListsTable (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
    $columnCategoryListTitle TEXT
  )
''');
    await db.execute('''
  CREATE TABLE $repeatListTable (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
    $columnRepeatListTitle TEXT
  )
''');

    // Insert default categories
    Batch batch = db.batch();
    const List<String> defaultCategories = [
      'Default',
      'Personal',
      'Shopping',
      'Wishlist',
      'Work',
    ];
    for (var category in defaultCategories) {
      batch.insert(categoriesListsTable, {columnCategoryListTitle: category});
    }
    // Insert default repeat options
    const List<String> defaultRepeats = [
      'No repeat',
      'Once a day',
      'Once a week',
      'Once a month',
      'Once a year',
    ];
    for (var repeat in defaultRepeats) {
      batch.insert(repeatListTable, {columnRepeatListTitle: repeat});
    }
    await batch.commit(noResult: true);
  }

  Future<void> refreshTodos() async {
    final todos = await fetchAllTodos();
    _todoStreamController.add(todos);
  }

  Future<void> refreshCategoriesList() async {
    final lists = await fetchCategoriesList();
    _categoriesListsStreamController.add(lists);
  }

  Future<void> refreshRepeatList() async {
    final lists = await fetchRepeatList();
    _repeatListsStreamController.add(lists);
  }

  Future<List<TodoModel>> fetchAllTodos() async {
    try {
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
          columnOriginalCategory,
        ],
      );

      return list.map((map) => TodoModel.fromMap(map)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoriesListsModel>> fetchCategoriesList() async {
    try {
      Database? mydb = await db;
      var list = await mydb!.query(
        categoriesListsTable,
        columns: [columnId, columnCategoryListTitle],
      );

      return list.map((map) => CategoriesListsModel.fromMap(map)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RepeatListsModel>> fetchRepeatList() async {
    try {
      Database? mydb = await db;
      var list = await mydb!.query(
        repeatListTable,
        columns: [columnId, columnRepeatListTitle],
      );

      return list.map((map) => RepeatListsModel.fromMap(map)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<TodoModel>> readAllData() {
    return _todoStreamController.stream;
  }

  Stream<List<CategoriesListsModel>> readCategoriesListsData() {
    return _categoriesListsStreamController.stream;
  }

  Stream<List<RepeatListsModel>> readRepeatListsData() {
    return _repeatListsStreamController.stream;
  }
// Future<void> debugDatabaseContents() async {
//   final db = await this.db;
//   final categories = await db!.query(categoriesListsTable);
//   final repeats = await db.query(repeatListTable);
//   print('Categories: $categories');
//   print('Repeats: $repeats');
// }
  Future<TodoModel?> readNoteData(int? id) async {
    try {
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
          columnOriginalCategory,
        ],
        where: '$columnId = ?',
        whereArgs: <Object?>[id],
      );
      if (list.isNotEmpty) {
        return TodoModel.fromMap(list.first);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> saveData(TodoModel todo) async {
    try {
      Database? mydb = await db;
      int id = await mydb!.insert(tableTodo, {
        columnNote: todo.note,
        columnDate: todo.toDate,
        columnCreationDate: todo.creationDate,
        columnTodoListItem: todo.todoListItem,
        columnRepeatItem: todo.todoRepeatItem,
        columnIsFinished: todo.isFinished ?? false ? 1 : 0,
        columnOriginalCategory: todo.originalCategory,
      });
      await refreshTodos();
      return id;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> saveCategoriesListData(CategoriesListsModel categories) async {
    try {
      Database? mydb = await db;
      int id = await mydb!.insert(categoriesListsTable, {
        columnCategoryListTitle: categories.categoryListValue,
      });
      await refreshCategoriesList();
      return id;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> saveRepeatListData(RepeatListsModel repeat) async {
    try {
      Database? mydb = await db;
      int id = await mydb!.insert(repeatListTable, {
        columnRepeatListTitle: repeat.repeatListValue,
      });
      await refreshRepeatList();
      return id;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateData(TodoModel todo) async {
    try {
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
          columnOriginalCategory: todo.originalCategory,
        },
        where: '$columnId = ?',
        whereArgs: [todo.id],
      );
      await refreshTodos();
      return count;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNote(int? id) async {
    try {
      Database? mydb = await db;
      await mydb!.delete(
        tableTodo,
        where: '$columnId = ?',
        whereArgs: <Object?>[id],
      );
      await refreshTodos();
    } catch (e) {
      rethrow;
    }
  }

  // Close the stream controller when no longer needed
  void dispose() {
    _todoStreamController.close();
    _categoriesListsStreamController.close();
    _repeatListsStreamController.close();
  }
}
