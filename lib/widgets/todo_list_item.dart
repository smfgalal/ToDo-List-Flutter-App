import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/read_cubit/read_todo_notes_cubit.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/views/add_edit_todo_view.dart';
import 'package:todo_app/widgets/general_widgets/confirmation_dialog_message.dart';
import 'package:todo_app/widgets/general_widgets/custom_check_box.dart';
import 'package:todo_app/widgets/general_widgets/custom_snack_bar.dart';

class TodoListItem extends StatefulWidget {
  const TodoListItem({
    super.key,
    required this.todoModel,
    this.isAllLists = true,
  });

  final TodoModel todoModel;
  final bool? isAllLists;

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late bool isChecked;
  bool isDeleting = false;
  late String originalCategory;
  bool isSliding = false;
  bool slideToRight = true;

  @override
  void initState() {
    isChecked = widget.todoModel.isFinished ?? false;
    originalCategory = widget.todoModel.originalCategory ?? 'Default';

    super.initState();
  }

  @override
  void didUpdateWidget(TodoListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.todoModel != widget.todoModel) {
      setState(() {
        isChecked = widget.todoModel.isFinished ?? false;
        originalCategory = widget.todoModel.originalCategory ?? 'Default';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
                    BlocProvider.of<ReadTodoNotesCubit>(
                      context,
                    ).fetchAllNotes();
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
          child: item(context),
        ),
        secondChild: const SizedBox.shrink(),
        crossFadeState: isDeleting && widget.todoModel.id == null
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  SizedBox item(BuildContext context) {
    return SizedBox(
      height: 130,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(
          isSliding
              ? (slideToRight
                    ? MediaQuery.of(context).size.width
                    : -MediaQuery.of(context).size.width)
              : 0,
          0,
          0,
        ),
        curve: Curves.fastEaseInToSlowEaseOut,
        child: Stack(
          children: [
            Card(
              color: ChangeTheme().theme(context)
                  ? kPrimaryDarkColor
                  : kPrimaryColor,
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
                          isSliding = true;
                          slideToRight = value;
                        });
                        await Future.delayed(const Duration(milliseconds: 300));
                        final updatedTodo = TodoModel(
                          id: widget.todoModel.id,
                          note: widget.todoModel.note,
                          toDate: widget.todoModel.toDate,
                          creationDate: widget.todoModel.creationDate,
                          todoListItem: value ? 'Finished' : originalCategory,
                          todoRepeatItem: widget.todoModel.todoRepeatItem,
                          isFinished: value,
                          originalCategory: widget.todoModel.originalCategory,
                        );
                        await databaseProvider.updateData(updatedTodo);
                        if (context.mounted) {
                          BlocProvider.of<ReadTodoNotesCubit>(
                            context,
                          ).fetchAllNotes();
                          if (value) {
                            NotificationService().cancelNotifications(
                              widget.todoModel.id!,
                            );
                            CustomSnackBar().snackBarMessage(
                              context: context,
                              backGroundColor: ChangeTheme().theme(context)
                                  ? const Color.fromARGB(255, 49, 49, 49)
                                  : const Color.fromARGB(255, 239, 239, 239),
                              closeIconColor: kPrimaryColor,
                              message:
                                  '(${widget.todoModel.note}) Task marked as Finished successfully',
                              messageColor: ChangeTheme().theme(context)
                                  ? Colors.white
                                  : kPrimaryColor,
                              duration: 2,
                              showCloseIcon: true,
                              borderColor: ChangeTheme().theme(context)
                                  ? kPrimaryLightColor
                                  : kPrimaryColor,
                            );
                          }
                          setState(() {
                            isSliding = false;
                          });
                          // NotificationService().cancelNotifications(
                          //   widget.todoModel.id!,
                          // );
                        }
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.todoModel.note,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.todoModel.toDate,
                          style: const TextStyle(
                            color: kPrimaryLightColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 18,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'last modified: ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 178, 178, 178),
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            widget.todoModel.creationDate,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 180, 162, 244),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      widget.isAllLists!
                          ? Row(
                              children: [
                                const Text(
                                  'List: ',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 180, 162, 244),
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${widget.todoModel.todoListItem}',
                                  style: const TextStyle(
                                    color: kPrimaryLightColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
