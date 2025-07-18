import 'package:todo_app/models/todo_model_constants.dart';

class CategoriesListsModel {
  final int? id;
  String? categoryListValue;

  CategoriesListsModel({this.id, required this.categoryListValue});

  factory CategoriesListsModel.fromMap(dynamic map) {
    return CategoriesListsModel(
      id: map[columnId] as int,
      categoryListValue: map[columnCategoryListTitle] as String,
    );
  }
}
