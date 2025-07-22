import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/main.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode = false;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() : _themeData = _createLightTheme() {
    _loadThemeFromDatabase();
  }

  static ThemeData _createLightTheme() {
    return ThemeData(
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
  }

  static ThemeData _createDarkTheme() {
    return ThemeData(
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
    );
  }

  Future<void> _loadThemeFromDatabase() async {
    try {
      final settings = await databaseProvider.fetchCurrentGeneralSettings();
      _isDarkMode = settings?.isDarkMode ?? false;
      _themeData = _isDarkMode ? _createDarkTheme() : _createLightTheme();
      notifyListeners();
    } catch (e) {
      //print('Error loading theme from database: $e');
      // Fallback to light theme
      _isDarkMode = false;
      _themeData = _createLightTheme();
      notifyListeners();
    }
  }

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    _themeData = isDark ? _createDarkTheme() : _createLightTheme();
    notifyListeners();
  }
}

class ChangeTheme {
  bool theme(BuildContext context) {
    try {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      return themeProvider.isDarkMode;
    } catch (e) {
      rethrow;
    }
  }

  ThemeProvider themeProvider(BuildContext context) {
    try {
      return Provider.of<ThemeProvider>(context, listen: false);
    } catch (e) {
      rethrow;
    }
  }
}