import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/widgets/custom_text_field.dart';
import 'package:todo_app/widgets/lists_drop_down_list.dart';

class AddNewToDoToList extends StatelessWidget {
  const AddNewToDoToList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add to list',
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
