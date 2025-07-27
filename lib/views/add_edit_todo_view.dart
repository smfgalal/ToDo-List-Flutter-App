import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/database/save_update.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/categories_list_model.dart';
import 'package:todo_app/models/repeat_list_model.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/widgets/add_new_widgets/add_new_item_tolist.dart';
import 'package:todo_app/widgets/add_new_widgets/add_new_todo_date.dart';
import 'package:todo_app/widgets/add_new_widgets/add_new_todo_text.dart';
import 'package:todo_app/widgets/add_new_widgets/is_task_finished_widget.dart';

class AddEditToDoView extends StatefulWidget {
  const AddEditToDoView({
    super.key,
    this.todoModel,
    this.catModel,
    this.repeatModel,
    this.scrollController,
  });

  final TodoModel? todoModel;
  final CategoriesListsModel? catModel;
  final RepeatListsModel? repeatModel;
  final ScrollController? scrollController;

  @override
  State<AddEditToDoView> createState() => _AddEditToDoViewState();
}

class _AddEditToDoViewState extends State<AddEditToDoView> {
  late bool isChecked;
  final formKey = GlobalKey<FormState>();
  TextEditingController? _noteTextController;
  TextEditingController? _toDateTextController;
  DateTime? _selectedToDate;
  String? _selectedCategoriesList;
  String? _selectedRepeatList;
  late String _originalCategory;

  int? get _noteId => widget.todoModel?.id;

  @override
  void initState() {
    databaseProvider.refreshCategoriesList();
    databaseProvider.refreshRepeatList();
    _noteTextController = TextEditingController(text: widget.todoModel?.note);
    _toDateTextController = TextEditingController(
      text: widget.todoModel?.toDate,
    );
    _selectedToDate = widget.todoModel != null
        ? DateFormat.yMMMMd().add_jm().parse(widget.todoModel!.toDate)
        : null;
    _selectedCategoriesList = widget.todoModel?.todoListItem;
    _selectedRepeatList = widget.todoModel?.todoRepeatItem;
    _originalCategory = widget.todoModel?.originalCategory ?? 'Default';
    isChecked = widget.todoModel?.isFinished ?? false;
    super.initState();
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
                textController: _noteTextController,
              ),
              _noteId != null
                  ? IsTaskFinishedWidget(
                      isChecked: isChecked,
                      todoModel: widget.todoModel!,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value;
                          _selectedCategoriesList = value
                              ? 'Finished'
                              : _originalCategory;
                        });
                      },
                      originalCategory: _originalCategory,
                    )
                  : const SizedBox(),
              const SizedBox(height: 64),
              AddNewToDoDate(
                title: 'Due date',
                hintText: 'Date not set',
                controller: _toDateTextController,
                icon: const Icon(Icons.calendar_month_rounded),
                todoModel: _noteId != null ? widget.todoModel! : null,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    _selectedToDate = dateTime;
                  });
                },
              ),
              const SizedBox(height: 64),
              AddNewItemToList(
                initialCategoriesList: _selectedCategoriesList,
                onCategoriesListChanged: (list) {
                  setState(() {
                    _selectedCategoriesList = list;
                    if (!isChecked) {
                      _originalCategory = list ?? _originalCategory;
                    }
                  });
                },
                initialRepeatList: _selectedRepeatList,
                onRepeatListChanged: (list) {
                  setState(() {
                    _selectedRepeatList = list;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          SaveUpdateTodo(
            key: formKey,
            todoModel: widget.todoModel,
            isChecked: isChecked,
            selectedToDate: _selectedToDate,
            noteTextController: _noteTextController,
            selectedCategoriesList: _selectedCategoriesList,
            selectedRepeatList: _selectedRepeatList,
            originalCategory: _originalCategory,
            context: context,
            noteId: _noteId,
            scrollController: widget.scrollController,
          ).saveUpdateTodos();
        },
        backgroundColor: ChangeTheme().theme(context)
            ? Colors.white
            : kPrimaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: Icon(
          Icons.check,
          size: 30,
          color: ChangeTheme().theme(context)
              ? kPrimaryColor
              : kPrimaryLightColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteTextController?.dispose();
    _toDateTextController?.dispose();
    super.dispose();
  }
}
