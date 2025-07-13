import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/views/home_view.dart';

void main() {
  runApp(const ToDoListApp());
}

class ToDoListApp extends StatelessWidget {
  const ToDoListApp({super.key});

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
}
