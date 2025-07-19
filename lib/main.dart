import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/cubits/read_cubit/read_todo_notes_cubit.dart';
import 'package:todo_app/database/database_provider.dart';
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
    return BlocProvider(
      create: (context) => ReadTodoNotesCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: kPrimaryColor,
          primaryColorLight: kPrimaryLightColor,
          primaryColorDark: kPrimaryDarkColor,
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        home: HomeView(),
      ),
    );
  }
}
