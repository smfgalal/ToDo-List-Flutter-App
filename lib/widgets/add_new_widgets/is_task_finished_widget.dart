import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/read_cubit/read_todo_notes_cubit.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/widgets/general_widgets/custom_check_box.dart';

// ignore: must_be_immutable
class IsTaskFinishedWidget extends StatefulWidget {
  IsTaskFinishedWidget({
    super.key,
    required this.isChecked,
    required this.todoModel,
    this.onChanged,
    this.originalCategory,
  });

  late bool isChecked;
  final TodoModel todoModel;
  final ValueChanged<bool>? onChanged;
  final String? originalCategory;

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
          borderColor: ChangeTheme().theme(context) ? Colors.white : kPrimaryColor,
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
                todoListItem: value
                    ? 'Finished'
                    : widget
                          .originalCategory, // Restore original category when unchecked
                todoRepeatItem: widget.todoModel.todoRepeatItem,
                isFinished: value,
                originalCategory: widget.todoModel.originalCategory,
              );
              await databaseProvider.updateData(updatedTodo);
              if (context.mounted) {
                BlocProvider.of<ReadTodoNotesCubit>(context).fetchAllNotes();
              }
            }
          },
        ),
        const Text(
          'Task finished?',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
