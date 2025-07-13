import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/widgets/add_new_widgets/add_new_todo_date.dart';
import 'package:todo_app/widgets/add_new_widgets/add_new_todo_text.dart';
import 'package:todo_app/widgets/add_new_widgets/add_new_todo_tolist.dart';

class AddNewToDoView extends StatefulWidget {
  const AddNewToDoView({super.key});


  @override
  State<AddNewToDoView> createState() => _AddNewToDoViewState();
}

class _AddNewToDoViewState extends State<AddNewToDoView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController? _noteTextController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, title: Text('New Task')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
               AddNewToDoText(
                title: 'What is to be done?',
                hintText: 'Enter Task Here',
                icon: Icon(Icons.mic),
                textController: _noteTextController,
              ),
              const SizedBox(height: 64),
              const AddNewToDoDate(
                title: 'Due date',
                hintText: 'Date not Set',
                icon: Icon(Icons.calendar_month_rounded),
              ),
              const SizedBox(height: 64),
              const AddNewToDoToList(),
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
