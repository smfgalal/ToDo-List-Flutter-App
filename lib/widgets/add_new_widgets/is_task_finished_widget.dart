// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo_model.dart';

// ignore: must_be_immutable
class IsTaskFinishedWidget extends StatefulWidget {
  IsTaskFinishedWidget({
    super.key,
    required this.isChecked,
    required this.todoModel,
  });
  bool? isChecked;
  final TodoModel todoModel;

  @override
  State<IsTaskFinishedWidget> createState() => _IsTaskFinishedWidgetState();
}

class _IsTaskFinishedWidgetState extends State<IsTaskFinishedWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: kPrimaryLightColor,
          side: BorderSide(color: kPrimaryColor),
          value: widget.isChecked,
          onChanged: (value) async {
            if (value != null) {
              setState(() {
                widget.isChecked = value;
              });
              final updatedTodo = TodoModel(
                id: widget.todoModel.id,
                note: widget.todoModel.note,
                toDate: widget.todoModel.toDate,
                creationDate: widget.todoModel.creationDate,
                todoListItem: widget.todoModel.todoListItem,
                todoRepeatItem: widget.todoModel.todoRepeatItem,
                isFinished: value,
              );
              await databaseProvider.updateData(updatedTodo);
            }
          },
        ),
        Text(
          'Task finished?',
          style: TextStyle(color: kPrimaryColor, fontSize: 16),
        ),
      ],
    );
  }
}
