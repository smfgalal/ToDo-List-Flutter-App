import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/cubits/read_cubit/read_todo_notes_cubit.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/views/add_edit_todo_view.dart';
import 'package:todo_app/widgets/general_widgets/confirmation_dialog_message.dart';
import 'package:todo_app/widgets/general_widgets/custom_check_box.dart';

class TodoListItem extends StatefulWidget {
  const TodoListItem({super.key, required this.todoModel});

  final TodoModel todoModel;

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late bool isChecked;
  bool isDeleting = false;

  @override
  void initState() {
    isChecked = widget.todoModel.isFinished ?? false;
    super.initState();
  }

  @override
  void didUpdateWidget(TodoListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.todoModel != widget.todoModel) {
      setState(() {
        isChecked = widget.todoModel.isFinished ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // if (widget.todoModel.id == null) {
    //   return const SizedBox.shrink();
    // }

    return Dismissible(
      key: ValueKey<int>(widget.todoModel.id!),
      background: Card(
        color: Colors.green,
        child: Padding(
          padding: EdgeInsets.only(right: width / 2),
          child: const Center(
            child: Text(
              'Edit',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      secondaryBackground: Card(
        color: const Color.fromARGB(255, 188, 36, 25),
        child: Padding(
          padding: EdgeInsets.only(left: width / 2.3),
          child: const Center(
            child: Text(
              'Delete',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe right to edit
          Navigator.push(
            context,
            MaterialPageRoute(
              barrierDismissible: true,
              builder: (context) {
                return AddEditToDoView(todoModel: widget.todoModel);
              },
            ),
          );
          return false; // Don't dismiss the card for edit
        } else {
          // Swipe left to delete
          return await showDialog(
            context: context,
            builder: (context) {
              return ConfirmationMessageShowDialog(
                message: 'Are you sure you want to delete note?',
                onPressedYes: () async {
                  setState(() {
                    isDeleting = true;
                  });
                   if (context.mounted) {
                    Navigator.pop(context, true);
                  }
                  await Future.delayed(const Duration(seconds: 1));
                  await databaseProvider.deleteNote(widget.todoModel.id);
                  if (context.mounted) {
                    BlocProvider.of<ReadTodoNotesCubit>(context,).fetchAllNotes();
                  }
                },
                onPressedNo: () {
                  Navigator.pop(context, false);
                },
              );
            },
          );
        }
      },
      child: AnimatedCrossFade(
        firstChild: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddEditToDoView(todoModel: widget.todoModel),
              ),
            );
          },
          child: SizedBox(
            height: 120,
            child: Stack(
              children: [
                Card(
                  color: kPrimaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8),
                      CustomCheckBox(
                        value: isChecked,
                        borderColor: Colors.white,
                        onChanged: (value) async {
                          if (value != null) {
                            setState(() {
                              isChecked = value;
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
                            if (context.mounted) {
                              BlocProvider.of<ReadTodoNotesCubit>(
                                context,
                              ).fetchAllNotes();
                            }
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.todoModel.note,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            widget.todoModel.toDate,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 14,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Creation Date: ${widget.todoModel.creationDate}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 180, 162, 244),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'List: ${widget.todoModel.todoListItem}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 180, 162, 244),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        secondChild: const SizedBox.shrink(),
        crossFadeState: isDeleting && widget.todoModel.id == null
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
