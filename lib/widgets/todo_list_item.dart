import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

class TodoListItem extends StatefulWidget {
  const TodoListItem({super.key,});


  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late bool isChecked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => EditToDoView(),
        //   ),
        // );
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
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Todo Note',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '02:45 AM',
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
              child: Text(
                'Creation Date: 25/04/2025 03:32 PM',
                style: const TextStyle(
                  color: Color.fromARGB(255, 180, 162, 244),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}