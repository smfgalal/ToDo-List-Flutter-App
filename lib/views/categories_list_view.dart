import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/categories_list_model.dart';
import 'package:todo_app/widgets/add_new_widgets/show_addnew_dialog.dart';
import 'package:todo_app/widgets/categories_list/categories_list_card.dart';

class CategoriesListView extends StatefulWidget {
  const CategoriesListView({super.key});

  @override
  State<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  final _newListController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    databaseProvider.refreshCategoriesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Tasks Lists'),
        toolbarHeight: 75,
        actions: [
          IconButton(
            onPressed: () {
              ShowAddToListDialog(
                newListController: _newListController,
                formKey: formKey,
              ).showAddNewToListDialog(context);
            },
            icon: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.add, size: 30),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: StreamBuilder<List<CategoriesListsModel>>(
          stream: databaseProvider.readCategoriesListsData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final categories = snapshot.data ?? [];
            final dropdownItems = categories
                .map(
                  (category) => {
                    'value': category.categoryListValue,
                    'label': category.categoryListValue,
                  },
                )
                .toList();
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: dropdownItems.length,
                itemBuilder: (context, index) {
                  return CategoriesListCard(
                    categoriesModel: categories[index],
                    newListController: _newListController,
                    formKey: formKey,
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _newListController.dispose();
    super.dispose();
  }
}
