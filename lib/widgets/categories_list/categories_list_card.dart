import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/categories_list_model.dart';
import 'package:todo_app/widgets/add_new_widgets/show_addnew_dialog.dart';
import 'package:todo_app/widgets/categories_list/tasks_count.dart';
import 'package:todo_app/widgets/general_widgets/confirmation_dialog_message.dart';

class CategoriesListCard extends StatelessWidget {
  const CategoriesListCard({
    super.key,
    required this.categoriesModel,
    required this.newListController,
    required this.formKey,
  });

  final CategoriesListsModel categoriesModel;
  final TextEditingController newListController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        color: kPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoriesModel.categoryListValue!,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Tasks: ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 144, 163, 205),
                          fontSize: 14,
                        ),
                      ),
                      GetTasksCount(categoriesModel: categoriesModel),
                    ],
                  ),
                ],
              ),
              categoriesModel.categoryListValue != 'Default'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            ShowAddToListDialog(
                              categoryModel: categoriesModel,
                              newListController: newListController,
                              formKey: formKey,
                              initialvalue: categoriesModel.categoryListValue,
                            ).showAddNewToListDialog(context);
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return ConfirmationMessageShowDialog(
                                  message:
                                      'Are you sure you want to delete the list?',
                                  onPressedYes: () async {
                                    Navigator.pop(context, true);
                                    await Future.delayed(
                                      const Duration(milliseconds: 300),
                                    );
                                    await databaseProvider
                                        .deleteCategoryListItem(
                                          categoriesModel.id,
                                        );
                                    if (context.mounted) {
                                      databaseProvider.refreshCategoriesList();
                                    }
                                  },
                                  onPressedNo: () {
                                    Navigator.pop(context, false);
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
