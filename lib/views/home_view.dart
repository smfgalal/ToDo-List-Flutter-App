import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/read_cubit/read_todo_notes_cubit.dart';
import 'package:todo_app/helpers/constants.dart';
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
    // Listen to search controller changes
    widget.getSearchController.addListener(() {
      setState(() {
        searchQuery = widget.getSearchController.text.trim();
      });
    });
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
                (value) async {
                  setState(() {
                    selectedCategory = value;
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
              ),
              const CustomPopUpMenu(),
            ],
            toolbarHeight: 75,
          ),
          body: TasksListHomeView(
            selectedCategory: selectedCategory,
            searchQuery: searchQuery,
            widget: widget,
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
    widget.searchController.dispose(); // Dispose search controller
    super.dispose();
  }
}
