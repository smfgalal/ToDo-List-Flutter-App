import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/categories_list_model.dart';
import 'package:todo_app/models/repeat_list_model.dart';
import 'package:todo_app/widgets/general_widgets/categories_list_drop_down_list.dart';
import 'package:todo_app/widgets/general_widgets/custom_text_field.dart';
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
  GlobalKey<FormState> formKey = GlobalKey();

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
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.8,
                    child: StreamBuilder<List<CategoriesListsModel>>(
                      stream: databaseProvider.readCategoriesListsData(),
                      builder: (context, snapshot) {
                        final categories = snapshot.data ?? [];
                        return CustomTextField(
                          textController: _newListController,
                          hintText: 'New list name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'List name is required';
                            }
                            if (categories.any(
                              (item) => item.categoryListValue == value,
                            )) {
                              return 'List name already exists';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: const BoxDecoration(
                            color: kPrimaryLightColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: kPrimaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            if (_newListController.text.isNotEmpty) {
                              Navigator.pop(context, _newListController.text);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Text(
                            'Add List',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result != null && context.mounted) {
      await databaseProvider.saveCategoriesListData(
        CategoriesListsModel(categoryListValue: result),
      );
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
        StreamBuilder<List<RepeatListsModel>>(
          stream: databaseProvider.readRepeatListsData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final repeatLists = snapshot.data ?? [];
            final dropdownItems = repeatLists
                .map(
                  (repeat) => {
                    'value': repeat.repeatListValue,
                    'label': repeat.repeatListValue,
                    'icon': Icons.loop_outlined,
                  },
                )
                .toList();

            final bool isValidRepeat = dropdownItems.any(
              (item) => item['value'] == widget.initialRepeatList,
            );
            if (!isValidRepeat && widget.initialRepeatList != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Repeat option "${widget.initialRepeatList}" no longer exists. Reverted to default.',
                    ),
                  ),
                );
              });
            }
            return CustomRepeatDropDownList(
              initialTextColor: kPrimaryColor,
              prefixIconColor: kPrimaryColor,
              suffixIconColor: kPrimaryColor,
              listsDropdownItems: dropdownItems.isNotEmpty
                  ? dropdownItems
                  : [
                      {
                        'value': 'No repeat',
                        'label': 'No repeat',
                        'icon': Icons.loop_outlined,
                      },
                    ],
              initialSelection: isValidRepeat
                  ? widget.initialRepeatList
                  : (dropdownItems.isNotEmpty
                            ? dropdownItems.first['value']
                            : 'No repeat')
                        .toString(),
              onSelected: widget.onRepeatListChanged,
            );
          },
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
            StreamBuilder<List<CategoriesListsModel>>(
              stream: databaseProvider.readCategoriesListsData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final categories = snapshot.data ?? [];
                final dropdownItems = categories
                    .map(
                      (category) => {
                        'value': category.categoryListValue,
                        'label': category.categoryListValue,
                        'icon': Icons.blur_on_outlined,
                      },
                    )
                    .toList();

                final bool isValidCategory = dropdownItems.any(
                  (item) => item['value'] == widget.initialCategoriesList,
                );

                if (!isValidCategory && widget.initialCategoriesList != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Category "${widget.initialCategoriesList}" no longer exists. Reverted to default.',
                        ),
                      ),
                    );
                  });
                }

                return Flexible(
                  child: CustomCategoriesListDropDownList(
                    initialTextColor: kPrimaryColor,
                    prefixIconColor: kPrimaryColor,
                    suffixIconColor: kPrimaryColor,
                    listsDropdownItems: dropdownItems.isNotEmpty
                        ? dropdownItems
                        : [
                            {
                              'value': 'Default',
                              'label': 'Default',
                              'icon': Icons.blur_on_outlined,
                            },
                          ],
                    initialSelection: isValidCategory
                        ? widget.initialCategoriesList
                        : (dropdownItems.isNotEmpty
                                  ? dropdownItems.first['value']
                                  : 'Default')
                              .toString(),
                    onSelected: widget.onCategoriesListChanged,
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () {
                showAddNewToListDialog(context);
              },
              icon: const Icon(
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
