import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubits/read_cubit/read_todo_notes_cubit.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/categories_list_model.dart';
import 'package:todo_app/models/general_settings_model.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/views/add_edit_todo_view.dart';
import 'package:todo_app/widgets/general_widgets/categories_list_drop_down_list.dart';
import 'package:todo_app/widgets/general_widgets/custom_popup_menu.dart';
import 'package:todo_app/widgets/general_widgets/no_data_column.dart';
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
    super.initState();
    BlocProvider.of<ReadTodoNotesCubit>(context).fetchAllNotes();
    onTapNotification();
  }

  void onTapNotification() {
    NotificationService.streamController.stream.listen((response) async {
      if (response.payload != null) {
        final noteId = int.tryParse(response.payload!);
        if (noteId != null) {
          // Fetch the specific note from the database
          final note = await databaseProvider.getNoteById(noteId);
          if (note != null && context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AddEditToDoView(
                    todoModel: note,
                    scrollController: widget.getScrollController,
                  );
                },
              ),
            );
          }
        }
      }
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
              child: StreamBuilder<List<GeneralSettingsModel>>(
                stream: databaseProvider.readGeneralSettingsData(),
                builder: (context, settingsSnapshot) {
                  if (settingsSnapshot.hasError) {
                    return Text('Error: ${settingsSnapshot.error}');
                  }
                  final settings = settingsSnapshot.data?.isNotEmpty == true
                      ? settingsSnapshot.data!.first
                      : null;
                  selectedCategory = settings?.listToShow ?? 'All Lists';

                  return StreamBuilder<List<CategoriesListsModel>>(
                    stream: databaseProvider.readCategoriesListsData(),
                    builder: (context, categoriesSnapshot) {
                      if (categoriesSnapshot.hasError) {
                        return Text('Error: ${categoriesSnapshot.error}');
                      }
                      final categories = categoriesSnapshot.data ?? [];
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
                      // Ensure selectedCategory is valid
                      if (selectedCategory == null ||
                          !dropdownItems.any(
                            (item) => item['value'] == selectedCategory,
                          )) {
                        selectedCategory = dropdownItems.first['value']
                            .toString();
                      }
                      return CustomCategoriesListDropDownList(
                        initialTextColor: Colors.white,
                        prefixIconColor: Colors.white,
                        suffixIconColor: Colors.white,
                        listsDropdownItems: dropdownItems,
                        initialSelection: selectedCategory,
                        onSelected: (value) async {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      );
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
                  // Schedule notifications only for non-finished notes with valid dates
                  for (var note in filteredNotes) {
                    if (note.toDate.isNotEmpty && !(note.isFinished ?? false)) {
                      try {
                        final parsedToDate = DateFormat.yMMMMd().add_jm().parse(
                          note.toDate,
                        );
                        NotificationService().showScheduledNotifications(
                          id: note.id!,
                          title: note.note,
                          body: 'Your task is ready To Do',
                          date: parsedToDate,
                        );
                      } catch (e) {
                        debugPrint(
                          'Error parsing toDate for note ${note.id}: $e',
                        );
                      }
                    }
                  }
                  return filteredNotes.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredNotes.length,
                          controller: widget.getScrollController,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final note = filteredNotes.reversed.toList()[index];
                            return TodoListItem(
                              todoModel: note,
                              isAllLists: selectedCategory == 'All Lists'
                                  ? true
                                  : false,
                            );
                          },
                        )
                      : const NoDataColumn();
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
