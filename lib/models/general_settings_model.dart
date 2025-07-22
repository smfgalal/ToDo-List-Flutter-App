import 'package:todo_app/helpers/todo_model_constants.dart';

class GeneralSettingsModel {
  final int? id;
  bool? isDarkMode;
  String? listToShow;
  String? weekStart;
  String? timeFormat;

  GeneralSettingsModel({
    this.id,
    this.isDarkMode,
    this.listToShow,
    this.weekStart,
    this.timeFormat,
  });

  factory GeneralSettingsModel.fromMap(dynamic map) {
    return GeneralSettingsModel(
      id: map[columnId] as int,
      isDarkMode: (map[isDarkTheme] as int?) == 1,
      listToShow: map[listToShowStartup] as String?,
      weekStart: map[weekStartDay] as String?,
      timeFormat: map[formatTime] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      isDarkTheme: isDarkMode == true ? 1 : 0, // Explicit conversion
      listToShowStartup: listToShow,
      weekStartDay: weekStart,
      formatTime: timeFormat,
    };
  }
}