class TodoModel {
  final int id;
  final String note;
  final String toDate;
  final String creationDate;
  String? todoListItem;
  String? todoRepeatItem;
  bool? isFinished;

  TodoModel({
    required this.id,
    required this.note,
    required this.toDate,
    required this.creationDate,
    this.todoListItem,
    this.todoRepeatItem,
    this.isFinished,
  });
}
