import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/widgets/add_new_widgets/add_new_todo_date.dart';
import 'package:todo_app/widgets/add_new_widgets/add_new_todo_text.dart';
import 'package:todo_app/widgets/add_new_widgets/edit_todo_add_tolist.dart';

class EditToDoView extends StatefulWidget {
  const EditToDoView({super.key});

  @override
  State<EditToDoView> createState() => _AddNewToDoState();
}

class _AddNewToDoState extends State<EditToDoView> {
  bool? isChecked = false;
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, title: Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const AddNewToDoText(
                title: 'What is to be done?',
                hintText: 'Enter Task Here',
                icon: Icon(Icons.mic),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    activeColor: kPrimaryLightColor,
                    side: BorderSide(color: kPrimaryColor),
                    value: isChecked,
                    onChanged: (value) {
                      isChecked = value;
                      setState(() {});
                    },
                  ),
                  Text(
                    'Task finished?',
                    style: TextStyle(color: kPrimaryColor, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const AddNewToDoDate(
                title: 'Due date',
                hintText: 'Date not Set',
                icon: Icon(Icons.calendar_month_rounded),
              ),
              const SizedBox(height: 50),
              const EditToDoAddToList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            setState(() {});
          }
        },
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(Icons.check, size: 30, color: kPrimaryLightColor),
      ),
    );
  }
}
