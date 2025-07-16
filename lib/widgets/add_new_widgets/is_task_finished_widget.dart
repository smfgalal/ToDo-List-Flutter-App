import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/cubits/read_cubit/read_todo_notes_cubit.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/widgets/general_widgets/custom_check_box.dart';

// ignore: must_be_immutable
class IsTaskFinishedWidget extends StatefulWidget {
  IsTaskFinishedWidget({
    super.key,
    required this.isChecked,
    required this.todoModel,
    this.onChanged, // Add callback
  });

  late bool isChecked;
  final TodoModel todoModel;
  final ValueChanged<bool>? onChanged; // Callback for checkbox changes

  @override
  State<IsTaskFinishedWidget> createState() => _IsTaskFinishedWidgetState();
}

class _IsTaskFinishedWidgetState extends State<IsTaskFinishedWidget> {
  @override
  void initState() {
    widget.isChecked = widget.todoModel.isFinished ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCheckBox(
          value: widget.isChecked,
          borderColor: kPrimaryColor,
          onChanged: (value) async {
            if (value != null) {
              setState(() {
                widget.isChecked = value;
              });
              widget.onChanged?.call(value); // Notify parent
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
              // ignore: use_build_context_synchronously
              BlocProvider.of<ReadTodoNotesCubit>(context).fetchAllNotes();
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
