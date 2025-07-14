import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/cubits/read_cubit/read_todo_notes_cubit.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/widgets/add_new_widgets/add_new_todo_date.dart';
import 'package:todo_app/widgets/add_new_widgets/add_new_todo_text.dart';
import 'package:todo_app/widgets/add_new_widgets/add_new_todo_tolist.dart';

class AddNewToDoView extends StatefulWidget {
  const AddNewToDoView({super.key, this.todoModel});

  final TodoModel? todoModel;

  @override
  State<AddNewToDoView> createState() => _AddNewToDoViewState();
}

class _AddNewToDoViewState extends State<AddNewToDoView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController? _noteTextController;
  DateTime? _selectedToDate;
  String? _selectedList;

  int? get _noteId => widget.todoModel?.id;

  @override
  void initState() {
    _noteTextController = TextEditingController(text: widget.todoModel?.note);
    _selectedToDate = widget.todoModel != null
        ? DateFormat.yMMMMd().add_jm().parse(widget.todoModel!.toDate)
        : null;
    _selectedList =
        widget.todoModel?.todoListItem ?? 'Default'; // Default to "Default"
    super.initState();
  }

  @override
  void dispose() {
    _noteTextController?.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (formKey.currentState!.validate()) {
      if (_selectedToDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a due date.')),
        );
        return;
      }
      try {
        final todo = TodoModel(
          id: _noteId,
          note: _noteTextController!.text,
          toDate: DateFormat.yMMMMd().add_jm().format(_selectedToDate!),
          creationDate: DateFormat.yMMMMd().add_jm().format(DateTime.now()),
          todoListItem: _selectedList ?? 'Default',
        );
        if (_noteId == null) {
          await todoProvider.saveData(todo);
        } else {
          await todoProvider.updateData(todo);
        }
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        if (_noteId != null) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving todo: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(_noteId == null ? 'New Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              AddNewToDoText(
                title: 'What is to be done?',
                hintText: 'Enter Task Here',
                icon: const Icon(Icons.mic),
                textController: _noteTextController,
              ),
              const SizedBox(height: 64),
              AddNewToDoDate(
                title: 'Due date',
                hintText: 'Date not Set',
                icon: const Icon(Icons.calendar_month_rounded),
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    _selectedToDate = dateTime;
                  });
                },
              ),
              const SizedBox(height: 64),
              AddNewToDoToList(
                initialList: _selectedList,
                onListChanged: (list) {
                  setState(() {
                    _selectedList = list;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          save();
          BlocProvider.of<ReadTodoNotesCubit>(context).fetchAllNotes();
        },
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: Icon(Icons.check, size: 30, color: kPrimaryLightColor),
      ),
    );
  }
}
