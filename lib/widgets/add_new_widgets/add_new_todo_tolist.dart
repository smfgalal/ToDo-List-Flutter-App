import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/widgets/custom_text_field.dart';
import 'package:todo_app/widgets/lists_drop_down_list.dart';

class AddNewToDoToList extends StatefulWidget {
  const AddNewToDoToList({super.key, this.initialList, this.onListChanged});

  final String? initialList;
  final ValueChanged<String?>? onListChanged;

  @override
  State<AddNewToDoToList> createState() => _AddNewToDoToListState();
}

class _AddNewToDoToListState extends State<AddNewToDoToList> {
  final List<Map<String, dynamic>> listsDropdownItems = [
    {'value': 'Default', 'label': 'Default', 'icon': Icons.blur_on_outlined},
    {'value': 'Personal', 'label': 'Personal', 'icon': Icons.blur_on_outlined},
    {'value': 'Shopping', 'label': 'Shopping', 'icon': Icons.blur_on_outlined},
    {'value': 'Wishlist', 'label': 'Wishlist', 'icon': Icons.blur_on_outlined},
    {'value': 'Work', 'label': 'Work', 'icon': Icons.blur_on_outlined},
  ];

  final _newListController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Notify parent with "Default" if no initial list is provided
    if (widget.initialList == null) {
      widget.onListChanged?.call('Default');
    }
  }

  @override
  void dispose() {
    _newListController.dispose();
    super.dispose();
  }

  Future<void> showAddNewListDialog(BuildContext context) async {
    _newListController.clear();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: CustomTextField(
                    textController: _newListController,
                    hintText: 'New list name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'List name is required';
                      }
                      if (listsDropdownItems.any(
                        (item) => item['value'] == value,
                      )) {
                        return 'List name already exists';
                      }
                      return null;
                    },
                  ),
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
                      if (_newListController.text.isNotEmpty) {
                        Navigator.pop(context, _newListController.text);
                      }
                    },
                    icon: const Icon(Icons.check),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null && context.mounted) {
      setState(() {
        listsDropdownItems.add({
          'value': result,
          'label': result,
          'icon': Icons.blur_on_outlined,
        });
      });
      widget.onListChanged?.call(result);
    }
  }

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
            CustomListsDropDownList(
              isHomePage: false,
              initialTextColor: kPrimaryColor,
              prefixIconColor: kPrimaryColor,
              suffixIconColor: kPrimaryColor,
              listsDropdownItems: listsDropdownItems,
              initialSelection:
                  widget.initialList ?? 'Default', // Default to "Default"
              onSelected: widget.onListChanged,
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
}
