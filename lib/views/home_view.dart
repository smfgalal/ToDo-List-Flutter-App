import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/cubits/read_cubit/read_todo_notes_cubit.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/categories_list_model.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/views/add_edit_todo_view.dart';
import 'package:todo_app/widgets/general_widgets/categories_list_drop_down_list.dart';
import 'package:todo_app/widgets/general_widgets/custom_popup_menu.dart';
import 'package:todo_app/widgets/todo_list_item.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  final ScrollController scrollController = ScrollController();
  ScrollController get getScrollController => scrollController;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? selectedCategory;

  @override
  void initState() {
    BlocProvider.of<ReadTodoNotesCubit>(context).fetchAllNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadTodoNotesCubit, ReadTodoNotesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: StreamBuilder<List<CategoriesListsModel>>(
                stream: databaseProvider.readCategoriesListsData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final categories = snapshot.data ?? [];
                  final dropdownItems = [
                    {
                      'value': 'All Lists',
                      'label': 'All Lists',
                      'icon': Icons.home,
                    },
                    ...categories.map((category) {
                      return {
                        'value': category.categoryListValue,
                        'label': category.categoryListValue,
                        'icon': Icons.blur_on_outlined,
                      };
                    }),
                    {
                      'value': 'Finished',
                      'label': 'Finished',
                      'icon': Icons.done,
                    },
                  ];
                  selectedCategory ??= dropdownItems.first['value'].toString();
                  return CustomCategoriesListDropDownList(
                    initialTextColor: Colors.white,
                    prefixIconColor: Colors.white,
                    suffixIconColor: Colors.white,
                    listsDropdownItems: dropdownItems,
                    initialSelection: selectedCategory,
                    onSelected: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  );
                },
              ),
            ),
            leadingWidth: MediaQuery.of(context).size.width / 1.8,
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              const CustomPopUpMenu(),
            ],
            toolbarHeight: 75,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: StreamBuilder<List<TodoModel>>(
              stream: databaseProvider.readAllData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final notes = snapshot.data ?? [];
                final filteredNotes = selectedCategory == 'All Lists'
                    ? notes
                          .where((note) => note.todoListItem != 'Finished')
                          .toList()
                    : selectedCategory == 'Finished'
                    ? notes
                          .where((note) => note.todoListItem == 'Finished')
                          .toList()
                    : notes
                          .where(
                            (note) => note.todoListItem == selectedCategory,
                          )
                          .toList();
                if (snapshot.hasData) {
                  return filteredNotes.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredNotes.length,
                          controller: widget.getScrollController,
                          itemBuilder: (context, index) {
                            return TodoListItem(
                              todoModel: filteredNotes[index],
                            );
                          },
                        )
                      : const Center(child: Text('There are no data to show!'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: kPrimaryLightColor,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.add_task_outlined),
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddEditToDoView(
                      scrollController: widget.getScrollController,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }
}

