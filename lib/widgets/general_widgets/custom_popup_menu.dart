import 'package:flutter/material.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/views/add_edit_todo_view.dart';
import 'package:todo_app/views/categories_list_view.dart';
import 'package:todo_app/views/settings_view.dart';

class CustomPopUpMenu extends StatelessWidget {
  const CustomPopUpMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
      ),
      onSelected: (value) {
        //print(value);
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'task lists',
            child: Row(
              children: [
                Icon(
                  Icons.list_alt_outlined,
                  color: ChangeTheme().theme(context)
                      ? Colors.white
                      : kPrimaryColor,
                ),
                const SizedBox(width: 10),
                const Text('Task Lists', style: TextStyle(fontSize: 16)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const CategoriesListView();
                  },
                ),
              );
            },
          ),
          PopupMenuItem(
            value: 'add new',
            child: Row(
              children: [
                Icon(
                  Icons.add_alarm_outlined,
                  color: ChangeTheme().theme(context)
                      ? Colors.white
                      : kPrimaryColor,
                ),
                const SizedBox(width: 10),
                const Text('Add New Task', style: TextStyle(fontSize: 16)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AddEditToDoView();
                  },
                ),
              );
            },
          ),
          PopupMenuItem(
            value: 'settings',
            child: Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  color: ChangeTheme().theme(context)
                      ? Colors.white
                      : kPrimaryColor,
                ),
                const SizedBox(width: 10),
                const Text('Settings', style: TextStyle(fontSize: 16)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SettingsView(
                    );
                  },
                ),
              );
            },
          ),
        ];
      },
    );
  }
}
