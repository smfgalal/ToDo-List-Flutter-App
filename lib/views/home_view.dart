import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/read_cubit/read_todo_notes_cubit.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/handle_notifications.dart';
import 'package:todo_app/views/add_edit_todo_view.dart';
import 'package:todo_app/widgets/general_widgets/custom_popup_menu.dart';
import 'package:todo_app/widgets/home_view_widgets/main_categories_dropdown_list.dart';
import 'package:todo_app/widgets/home_view_widgets/search_tasks_bar.dart';
import 'package:todo_app/widgets/home_view_widgets/todo_list_home_view.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  final ScrollController scrollController = ScrollController();
  ScrollController get getScrollController => scrollController;

  final TextEditingController searchController = TextEditingController();
  TextEditingController get getSearchController => searchController;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? selectedCategory;
  String searchQuery = '';
  List<TodoModel> filteredNotes = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReadTodoNotesCubit>(context).fetchAllNotes();
    HandleNotifications(
      widget.getScrollController,
      context: context,
    ).rescheduleActiveNotifications();
    HandleNotifications(
      widget.getScrollController,
      context: context,
    ).onTapNotification();
    widget.getSearchController.addListener(() {
      setState(() {
        searchQuery = widget.getSearchController.text.trim();
      });
    });
  }

  // Callback to reset search query
  void resetSearchQuery() {
    setState(() {
      searchQuery = '';
      widget.getSearchController.clear();
    });
  }

  // Callback to update filtered notes
  void updateFilteredNotes(List<TodoModel> notes) {
    // Only update if the filtered notes have changed
    if (filteredNotes.length != notes.length ||
        !filteredNotes.every((note) => notes.contains(note))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            filteredNotes = notes;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadTodoNotesCubit, ReadTodoNotesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: MainCategoriesDropDownList().mainCategoriesDropDownList(
                selectedCategory,
                (value) {
                  setState(() {
                    selectedCategory = value;
                    if (searchQuery.isNotEmpty) {
                      resetSearchQuery();
                    }
                  });
                },
              ),
            ),
            leadingWidth: MediaQuery.of(context).size.width / 1.3,
            actions: [
              SearchTasksBar(
                searchBarController: widget.getSearchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim();
                  });
                },
                onCancel: () {
                  if (filteredNotes.isEmpty) {
                    resetSearchQuery();
                  }
                },
                filteredNotes: filteredNotes,
              ),
              const CustomPopUpMenu(),
            ],
            toolbarHeight: 75,
          ),
          body: TasksListHomeView(
            selectedCategory: selectedCategory,
            searchQuery: searchQuery,
            widget: widget,
            onFilteredNotesUpdated: updateFilteredNotes,
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
    widget.searchController.dispose();
    super.dispose();
  }
}
