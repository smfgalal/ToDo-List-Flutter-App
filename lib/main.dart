import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/database/todo_provider.dart';
import 'package:todo_app/views/home_view.dart';

late TodoProvider todoProvider;

void main() {
  todoProvider = TodoProvider();
  runApp(const ToDoListApp());
}

class ToDoListApp extends StatefulWidget {
  const ToDoListApp({super.key});

  @override
  State<ToDoListApp> createState() => _ToDoListAppState();
}

class _ToDoListAppState extends State<ToDoListApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: kPrimaryColor,
        primaryColorLight: kPrimaryLightColor,
        primaryColorDark: kPrimaryDarkColor,
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeView(),
    );
  }

  @override
  void dispose() {
    todoProvider.dispose();
    super.dispose();
  }
}
