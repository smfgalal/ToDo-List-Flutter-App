import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/helpers/constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode = false;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider()
      : _themeData = ThemeData(
          brightness: Brightness.light,
          primaryColor: kPrimaryColor,
          primaryColorLight: kPrimaryLightColor,
          primaryColorDark: kPrimaryDarkColor,
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: kPrimaryDarkColor),
            titleLarge: TextStyle(color: kPrimaryDarkColor),
          ),
        );

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    _themeData = isDark
        ? ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.white,
            primaryColorLight: kPrimaryLightColor,
            primaryColorDark: Colors.white,
            fontFamily: 'Poppins',
            appBarTheme: const AppBarTheme(
              backgroundColor: kPrimaryDarkColor,
              foregroundColor: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.grey[900],
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white),
            ),
          )
        : ThemeData(
            brightness: Brightness.light,
            primaryColor: kPrimaryColor,
            primaryColorLight: kPrimaryLightColor,
            primaryColorDark: kPrimaryDarkColor,
            fontFamily: 'Poppins',
            appBarTheme: const AppBarTheme(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: kPrimaryDarkColor),
              titleLarge: TextStyle(color: kPrimaryDarkColor),
            ),
          );
    notifyListeners();
  }
}

class ChangeTheme {
  bool theme(BuildContext context) {
    try {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      bool isAppThemeChecked = themeProvider.isDarkMode;
      return isAppThemeChecked;
    } catch (e) {
      rethrow;
    }
  }
   ThemeProvider themeProvider(BuildContext context) {
    try {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      return themeProvider;
    } catch (e) {
      rethrow;
    }
  }
}
