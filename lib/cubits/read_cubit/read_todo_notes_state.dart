part of 'read_todo_notes_cubit.dart';

@immutable
sealed class ReadTodoNotesState {}

final class ReadTodoNotesInitial extends ReadTodoNotesState {}

final class ReadTodoNotesSuccess extends ReadTodoNotesState {
  final List<TodoModel> todos; // Add todos list

  ReadTodoNotesSuccess(this.todos);
}

final class ReadTodoNotesFailure extends ReadTodoNotesState {
  final String errorMessage;

  ReadTodoNotesFailure({required this.errorMessage});
}
