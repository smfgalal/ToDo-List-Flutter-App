import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/categories_list_model.dart';
import 'package:todo_app/models/repeat_list_model.dart';
import 'package:todo_app/widgets/add_new_widgets/show_addnew_dialog.dart';
import 'package:todo_app/widgets/general_widgets/categories_list_drop_down_list.dart';
import 'package:todo_app/widgets/general_widgets/custom_snack_bar.dart';
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
                    CustomSnackBar().snackBarMessage(
                      context: context,
                      backGroundColor: const Color.fromARGB(255, 244, 244, 244),
                      closeIconColor: kPrimaryColor,
                      message:
                          'Category "${widget.initialCategoriesList}" no longer exists. Reverted to default.',
                      messageColor: kPrimaryColor,
                      duration: 2,
                      showCloseIcon: true,
                      borderColor: kPrimaryColor,
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
                //showAddNewToListDialog(context);
                ShowAddToListDialog(
                  initialCategoriesList: widget.initialCategoriesList,
                  onCategoriesListChanged: widget.onCategoriesListChanged,
                  initialRepeatList: widget.initialRepeatList,
                  onRepeatListChanged: widget.onRepeatListChanged,
                  newListController: _newListController,
                  formKey: formKey,
                ).showAddNewToListDialog(context);
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
  @override
  void dispose() {
    _newListController.dispose();
    super.dispose();
  }
}
