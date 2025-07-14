import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/widgets/custom_text_field.dart';
import 'package:todo_app/widgets/lists_drop_down_list.dart';
import 'package:todo_app/widgets/repeat_drop_down_list.dart';

class EditToDoAddToList extends StatelessWidget {
  const EditToDoAddToList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Repeat task',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
            fontSize: 18,
          ),
        ),
        const CustomRepeatDropDownList(
          initialTextColor: kPrimaryColor,
          prefixIconColor: kPrimaryColor,
          suffixIconColor: kPrimaryColor,
        ),
        const SizedBox(height: 50),
        const Text(
          'Task list',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
            fontSize: 18,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomListsDropDownList(
              isHomePage: false,
              initialTextColor: kPrimaryColor,
              prefixIconColor: kPrimaryColor,
              suffixIconColor: kPrimaryColor,
              listsDropdownItems: [
                {
                  'value': 'Default',
                  'label': 'Default',
                  'icon': Icons.blur_on_outlined,
                },
                {
                  'value': 'Personal',
                  'label': 'Personal',
                  'icon': Icons.blur_on_outlined,
                },
                {
                  'value': 'Shopping',
                  'label': 'Shopping',
                  'icon': Icons.blur_on_outlined,
                },
                {
                  'value': 'Wishlist',
                  'label': 'Wishlist',
                  'icon': Icons.blur_on_outlined,
                },
                {
                  'value': 'Work',
                  'label': 'Work',
                  'icon': Icons.blur_on_outlined,
                },
                {
                  'value': 'Finished',
                  'label': 'Finished',
                  'icon': Icons.check_circle,
                },
              ],
            ),
            IconButton(
              onPressed: () {
                showAddNewListDialog(context);
              },
              icon: Icon(
                Icons.format_list_bulleted_add,
                size: 30,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<dynamic> showAddNewListDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: CustomTextField(hintText: 'New list name'),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.check),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
