import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubits/read_cubit/read_todo_notes_cubit.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo_model.dart';


class SaveUpdateTodo {
  final TodoModel? todoModel;
  late bool isChecked;
  final DateTime? selectedToDate;
  final TextEditingController? noteTextController;
  final String? selectedCategoriesList;
  final String? selectedRepeatList;
  late String originalCategory;
  final BuildContext context;
  final int? noteId;
  final GlobalKey<FormState> key;

  SaveUpdateTodo({
    required this.key,
    required this.todoModel,
    required this.isChecked,
    required this.selectedToDate,
    required this.noteTextController,
    required this.selectedCategoriesList,
    required this.selectedRepeatList,
    required this.originalCategory,
    required this.context,
    required this.noteId,
  });

  Future<void> saveUpdateTodos() async {
    if (key.currentState!.validate()) {
      if (selectedToDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a due date.')),
        );
        return;
      }
      try {
        final categories = await databaseProvider.fetchCategoriesList();
        final isValidCategory = categories.any(
          (cat) => cat.categoryListValue == originalCategory,
        );
        final todo = TodoModel(
          id: noteId,
          note: noteTextController!.text,
          toDate: DateFormat.yMMMMd().add_jm().format(selectedToDate!),
          creationDate: DateFormat.yMMMMd().add_jm().format(DateTime.now()),
          todoListItem: isChecked
              ? 'Finished'
              : (selectedCategoriesList ??
                    (isValidCategory ? originalCategory : 'Default')),
          todoRepeatItem: selectedRepeatList ?? 'No repeat',
          isFinished: isChecked,
          originalCategory: selectedCategoriesList,
        );
        if (noteId == null) {
          await databaseProvider.saveData(todo);
        } else {
          await databaseProvider.updateData(todo);
        }
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        BlocProvider.of<ReadTodoNotesCubit>(context).fetchAllNotes();
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving todo: $e')));
      }
    }
  }
}
