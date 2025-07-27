import 'package:flutter/material.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/models/todo_model.dart';

class SearchTasksBar extends StatelessWidget {
  const SearchTasksBar({
    super.key,
    this.searchBarController,
    this.onChanged,
    this.onCancel,
    this.filteredNotes,
  });

  final TextEditingController? searchBarController;
  final Function(String)? onChanged;
  final VoidCallback? onCancel;
  final List<TodoModel>? filteredNotes;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 10,
      color: Colors.transparent,
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.search),
      onCanceled: onCancel,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: SearchBar(
              controller: searchBarController,
              hintText: 'Search for tasks',
              keyboardType: TextInputType.multiline,
              autoFocus: true,
              padding: WidgetStateProperty.resolveWith((_) {
                return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
              }),
              leading: Icon(
                Icons.search,
                color: ChangeTheme().theme(context)
                    ? Colors.white
                    : kPrimaryColor,
              ),
              onChanged: onChanged,
            ),
          ),
        ];
      },
    );
  }
}
