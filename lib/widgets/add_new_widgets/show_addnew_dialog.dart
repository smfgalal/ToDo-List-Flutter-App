import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/categories_list_model.dart';
import 'package:todo_app/widgets/general_widgets/custom_text_field.dart';

class ShowAddToListDialog {
  final String? initialCategoriesList;
  final ValueChanged<String?>? onCategoriesListChanged;
  final String? initialRepeatList;
  final ValueChanged<String?>? onRepeatListChanged;
  final TextEditingController newListController;
  final GlobalKey<FormState> formKey;
  ShowAddToListDialog({
    required this.initialCategoriesList,
    required this.onCategoriesListChanged,
    required this.initialRepeatList,
    required this.onRepeatListChanged,
    required this.newListController,
    required this.formKey,
  });

  Future<void> showAddNewToListDialog(BuildContext context) async {
    newListController.clear();

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
                          textController: newListController,
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
                            if (newListController.text.isNotEmpty) {
                              Navigator.pop(context, newListController.text);
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
      onCategoriesListChanged?.call(result);
    }
  }
}
