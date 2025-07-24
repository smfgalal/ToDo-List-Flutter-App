import 'package:flutter/material.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/categories_list_model.dart';
import 'package:todo_app/models/general_settings_model.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/widgets/general_widgets/custom_snack_bar.dart';
import 'package:todo_app/widgets/general_widgets/custom_text_field.dart';

class ShowAddToListDialog {
  final ValueChanged<String?>? onCategoriesListChanged;
  final TextEditingController newListController;
  final GlobalKey<FormState> formKey;
  final CategoriesListsModel? categoryModel;
  final String? initialvalue;
  ShowAddToListDialog({
    this.onCategoriesListChanged,
    required this.newListController,
    required this.formKey,
    this.categoryModel,
    this.initialvalue,
  });

  Future<void> showAddNewToListDialog(BuildContext context) async {
    newListController.clear();
    if (initialvalue != null) {
      newListController.text = initialvalue!; // Set initial text in controller
    }

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
                          hintText: categoryModel == null
                              ? 'New list name'
                              : 'Update list name',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'List name is required';
                            }
                            if (categories.any(
                              (item) =>
                                  item.categoryListValue
                                          ?.trim()
                                          .toLowerCase() ==
                                      value.trim().toLowerCase() &&
                                  item.id != categoryModel?.id,
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
                          child: Text(
                            categoryModel == null ? 'Add List' : 'Update List',
                            style: const TextStyle(color: Colors.white),
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
      try {
        if (categoryModel == null) {
          await databaseProvider.saveCategoriesListData(
            CategoriesListsModel(categoryListValue: result),
          );
        } else {
          // Update the category
          await databaseProvider.updateCategoryListItem(
            CategoriesListsModel(
              id: categoryModel!.id,
              categoryListValue: result,
            ),
          );

          final todosToUpdate = await databaseProvider.fetchTodosByCategory(
            categoryModel!.categoryListValue!,
          );
          final listToShowToUpdate = await databaseProvider
              .fetchSettingsByListToShow(categoryModel!.categoryListValue!);
              
          for (var todo in todosToUpdate) {
            final updatedTodo = TodoModel(
              id: todo.id,
              note: todo.note,
              toDate: todo.toDate,
              creationDate: todo.creationDate,
              todoListItem: result,
              todoRepeatItem: todo.todoRepeatItem,
              originalCategory: result,
              isFinished: todo.isFinished,
            );
            await databaseProvider.updateData(updatedTodo);
            await databaseProvider.refreshCategoriesList();
          }
          for (var listItem in listToShowToUpdate) {
            final updatedListItem = GeneralSettingsModel(
              id: listItem.id,
              isDarkMode: listItem.isDarkMode,
              listToShow: result,
              weekStart: listItem.weekStart,
            );
            await databaseProvider.updateGeneralSettings(updatedListItem);
            await databaseProvider.refreshGeneralSettings();
          }
        }
        onCategoriesListChanged?.call(result);
      } catch (e) {
        if (context.mounted) {
          CustomSnackBar().snackBarMessage(
            context: context,
            backGroundColor: const Color.fromARGB(255, 244, 244, 244),
            closeIconColor: kPrimaryColor,
            message:
                'Tasks list with name "${newListController.text}" is already exists. Please choose another one.',
            messageColor: kPrimaryColor,
            duration: 2,
            showCloseIcon: true,
            borderColor: kPrimaryColor,
          );
        }
      }
    }
  }
}
