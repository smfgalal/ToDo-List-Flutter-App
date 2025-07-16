import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/widgets/general_widgets/custom_text_field.dart';
import 'package:todo_app/widgets/general_widgets/lists_drop_down_list.dart';
import 'package:todo_app/widgets/general_widgets/repeat_drop_down_list.dart';

class AddNewItemToList extends StatefulWidget {
  const AddNewItemToList({
    super.key,
    this.initialCategoriesList,
    this.onCategoriesListChanged,
    this.initialRepeatList,
    this.onRepeatListChanged,
  });

  final String? initialCategoriesList;
  final ValueChanged<String?>? onCategoriesListChanged;
  final String? initialRepeatList;
  final ValueChanged<String?>? onRepeatListChanged;

  @override
  State<AddNewItemToList> createState() => _AddNewAddToListState();
}

class _AddNewAddToListState extends State<AddNewItemToList> {
  final _newListController = TextEditingController();

  @override
  void initState() {
    if (widget.initialCategoriesList == null) {
      widget.onCategoriesListChanged?.call(
        categoriesListsDropdownItems.first['value'],
      );
    }
    if (widget.initialRepeatList == null) {
      widget.onRepeatListChanged?.call(repeatDropdownItems.first['value']);
    }
    super.initState();
  }

  @override
  void dispose() {
    _newListController.dispose();
    super.dispose();
  }

  Future<void> showAddNewToListDialog(BuildContext context) async {
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
                      if (categoriesListsDropdownItems.any(
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
        categoriesListsDropdownItems.add({
          'value': result,
          'label': result,
          'icon': Icons.blur_on_outlined,
        });
      });
      widget.onCategoriesListChanged?.call(result);
    }
  }

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
        CustomRepeatDropDownList(
          initialTextColor: kPrimaryColor,
          prefixIconColor: kPrimaryColor,
          suffixIconColor: kPrimaryColor,
          listsDropdownItems: repeatDropdownItems,
          initialSelection:
              widget.initialRepeatList ?? repeatDropdownItems.first['value'],
          onSelected: widget.onRepeatListChanged,
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
            CustomListsDropDownList(
              isHomePage: false,
              initialTextColor: kPrimaryColor,
              prefixIconColor: kPrimaryColor,
              suffixIconColor: kPrimaryColor,
              listsDropdownItems: categoriesListsDropdownItems,
              initialSelection:
                  widget.initialCategoriesList ??
                  categoriesListsDropdownItems.first['value'],
              onSelected: widget.onCategoriesListChanged,
            ),
            IconButton(
              onPressed: () {
                showAddNewToListDialog(context);
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
