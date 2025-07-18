import 'package:todo_app/models/todo_model_constants.dart';

class RepeatListsModel {
  final int? id;
  String? repeatListValue;

  RepeatListsModel({this.id, required this.repeatListValue});

  factory RepeatListsModel.fromMap(dynamic map) {
    return RepeatListsModel(
      id: map[columnId] as int,
      repeatListValue: map[columnRepeatListTitle] as String,
    );
  }
}
