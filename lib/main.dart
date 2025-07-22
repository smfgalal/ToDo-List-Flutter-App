import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/cubits/read_cubit/read_todo_notes_cubit.dart';
import 'package:todo_app/database/database_provider.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/views/home_view.dart';

late DatabaseProvider databaseProvider;

void main() {
  databaseProvider = DatabaseProvider();
  runApp(const ToDoListApp());
}

class ToDoListApp extends StatelessWidget {
  const ToDoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(create: (context) => ReadTodoNotesCubit()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: HomeView(),
          );
        },
      ),
    );
  }
}
