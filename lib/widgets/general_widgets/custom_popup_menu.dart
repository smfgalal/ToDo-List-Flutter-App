import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/views/add_edit_todo_view.dart';
import 'package:todo_app/views/categories_list_view.dart';

class CustomPopUpMenu extends StatelessWidget {
  const CustomPopUpMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
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
            child: const Row(
              children: [
                Icon(Icons.list_alt_outlined, color: kPrimaryColor),
                SizedBox(width: 10),
                Text('Task Lists', style: TextStyle(fontSize: 16)),
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
            child: const Row(
              children: [
                Icon(Icons.add_alarm_outlined, color: kPrimaryColor),
                SizedBox(width: 10),
                Text('Add New Task', style: TextStyle(fontSize: 16)),
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
            child: const Row(
              children: [
                Icon(Icons.settings_outlined, color: kPrimaryColor),
                SizedBox(width: 10),
                Text('Settings', style: TextStyle(fontSize: 16)),
              ],
            ),
            onTap: () {},
          ),
        ];
      },
    );
  }
}
