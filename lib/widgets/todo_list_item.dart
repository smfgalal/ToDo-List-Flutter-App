import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/views/edit_todo_view.dart';

class TodoListItem extends StatefulWidget {
  const TodoListItem({super.key, required this.todoModel});

  final TodoModel todoModel;

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.todoModel.isFinished ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditToDoView()),
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
                  Checkbox(
                    splashRadius: 100,
                    activeColor: kPrimaryLightColor,
                    side: const BorderSide(
                      color: Colors.white,
                      width: 2,
                      strokeAlign: 2,
                    ),
                    value: isChecked,
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
                        await todoProvider.updateData(updatedTodo);
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
    );
  }
}
