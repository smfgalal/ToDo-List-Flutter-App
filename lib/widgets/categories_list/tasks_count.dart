import 'package:flutter/material.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/categories_list_model.dart';

class GetTasksCount extends StatelessWidget {
  const GetTasksCount({super.key, required this.categoriesModel});

  final CategoriesListsModel categoriesModel;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: databaseProvider.getTaskCountForCategory(
        categoriesModel.categoryListValue,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            'No data',
            style: TextStyle(color: kPrimaryLightColor, fontSize: 14),
          );
        }
        if (snapshot.hasData) {
          return Text(
            snapshot.data?.toString() ?? '0',
            style: const TextStyle(color: kPrimaryLightColor, fontSize: 16),
          );
        } else {
          return const Text(
            '0',
            style: TextStyle(color: kPrimaryLightColor, fontSize: 14),
          );
        }
      },
    );
  }
}
