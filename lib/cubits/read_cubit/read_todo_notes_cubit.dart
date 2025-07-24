import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo_model.dart';

part 'read_todo_notes_state.dart';

class ReadTodoNotesCubit extends Cubit<ReadTodoNotesState> {
  ReadTodoNotesCubit() : super(ReadTodoNotesInitial());
  // TodoModel? todoModel;
  Future<void> fetchAllNotes() async {
    try {
      final todos = await databaseProvider.fetchAllTodos();
      // for (var item in todos) {
      //   todoModel = item;
      // }
      emit(ReadTodoNotesSuccess(todos));
    } catch (e) {
      emit(ReadTodoNotesFailure(errorMessage: e.toString()));
    }
  }
}
