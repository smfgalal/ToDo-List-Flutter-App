import 'package:todo_app/helpers/todo_model_constants.dart';

class TodoModel {
  final int? id;
  final String note;
  final String toDate;
  final String creationDate;
  String? todoListItem;
  String? todoRepeatItem;
  bool? isFinished;
  final String? originalCategory;

  TodoModel({
    this.id,
    required this.note,
    required this.toDate,
    required this.creationDate,
    this.todoListItem,
    this.todoRepeatItem,
    this.isFinished,
    this.originalCategory,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map[columnId] as int,
      note: map[columnNote] as String,
      toDate: map[columnDate] as String,
      creationDate: map[columnCreationDate] as String,
      todoListItem: map[columnTodoListItem] as String?,
      todoRepeatItem: map[columnRepeatItem] as String?,
      isFinished: map[columnIsFinished] == 1 ? true : false,
      originalCategory: map[columnOriginalCategory] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnNote: note,
      columnDate: toDate,
      columnCreationDate: creationDate,
      columnTodoListItem: todoListItem,
      columnRepeatItem: todoRepeatItem,
      columnIsFinished: isFinished ?? false ? 1 : 0,
      columnOriginalCategory: originalCategory,
    };
  }
}
