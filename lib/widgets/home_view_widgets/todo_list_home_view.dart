import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/views/home_view.dart';
import 'package:todo_app/widgets/general_widgets/no_data_column.dart';
import 'package:todo_app/widgets/home_view_widgets/todo_list_item.dart';

class TasksListHomeView extends StatelessWidget {
  const TasksListHomeView({
    super.key,
    required this.selectedCategory,
    required this.searchQuery,
    required this.widget,
    required this.onFilteredNotesUpdated,
  });

  final String? selectedCategory;
  final String searchQuery;
  final HomeView widget;
  final Function(List<TodoModel>) onFilteredNotesUpdated;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: StreamBuilder<List<TodoModel>>(
        stream: databaseProvider.readAllData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final notes = snapshot.data ?? [];
          // Apply category and search filtering
          final filteredNotes = notes.where((note) {
            // Category filtering
            bool matchesCategory = selectedCategory == 'All Lists'
                ? note.todoListItem != 'Finished'
                : selectedCategory == 'Finished'
                ? note.todoListItem == 'Finished'
                : note.todoListItem == selectedCategory;
            // Search query filtering
            bool matchesSearch =
                searchQuery.isEmpty ||
                note.note.toLowerCase().contains(searchQuery.toLowerCase());
            return matchesCategory && matchesSearch;
          }).toList();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            onFilteredNotesUpdated(filteredNotes);
          });

          if (snapshot.hasData) {
            return filteredNotes.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredNotes.length,
                    controller: widget.getScrollController,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final note = filteredNotes.reversed.toList()[index];
                      return TodoListItem(
                        todoModel: note,
                        isAllLists: selectedCategory == 'All Lists'
                            ? true
                            : false,
                      );
                    },
                  )
                : const NoDataColumn();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
