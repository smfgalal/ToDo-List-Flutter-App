import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubits/read_cubit/read_todo_notes_cubit.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/notification_service.dart';

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
  final ScrollController? scrollController;

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
    this.scrollController,
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
        // Validate category
        final categories = await databaseProvider.fetchCategoriesList();
        final isValidCategory = categories.any(
          (cat) => cat.categoryListValue == originalCategory,
        );
        if (!isValidCategory && originalCategory != 'Default') {
          originalCategory = 'Default';
        }

        // Create or update TodoModel
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
          originalCategory: selectedCategoriesList ?? originalCategory,
        );

        // Save or update in database
        int savedId;
        if (noteId == null) {
          savedId = await databaseProvider.saveData(todo);
        } else {
          await databaseProvider.updateData(todo);
          savedId = noteId!;
        }

        // Handle notification scheduling
        if (!isChecked && todo.toDate.isNotEmpty) {
          // Cancel any existing notification
          try {
            await NotificationService().cancelNotifications(savedId);
          } catch (e, stack) {
            debugPrint(
              'Error canceling notification for ID: $savedId: $e\n$stack',
            );
          }

          // Schedule new notification
          try {
            await NotificationService().showScheduledNotifications(
              id: savedId,
              title: todo.note,
              body: 'Your task is ready To Do',
              date: selectedToDate!,
              repeatInterval: todo.todoRepeatItem,
            );
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to schedule notification: $e')),
              );
            }
          }
        } else {
          try {
            await NotificationService().cancelNotifications(savedId);
          } catch (e, stack) {
            debugPrint(
              'Error canceling notification for ID: $savedId: $e\n$stack',
            );
          }
        }

        if (context.mounted) {
          Navigator.pop(context);
          BlocProvider.of<ReadTodoNotesCubit>(context).fetchAllNotes();
        }

        // Schedule scroll for new tasks
        if (scrollController != null &&
            scrollController!.hasClients &&
            noteId == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final targetOffset = scrollController!.position.minScrollExtent;
            scrollController!.animateTo(
              targetOffset,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error saving todo: $e')));
        }
      }
    }
  }
}
