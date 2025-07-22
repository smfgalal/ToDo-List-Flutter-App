import 'package:flutter/material.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/general_settings_model.dart';
import 'package:todo_app/widgets/general_widgets/custom_snack_bar.dart';

enum WeekStartDays { saturday, sunday, monday }

class ShowWeekStartDialog {
  Future<dynamic> showWeekStartDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const ShowStartOfWeekDialog();
      },
    );
  }
}

class ShowStartOfWeekDialog extends StatefulWidget {
  const ShowStartOfWeekDialog({super.key});

  @override
  State<ShowStartOfWeekDialog> createState() => _ShowStartOfWeekDialogState();
}

class _ShowStartOfWeekDialogState extends State<ShowStartOfWeekDialog> {
  WeekStartDays? _startDay;

  @override
  void initState() {
    super.initState();
    _loadCurrentWeekStart();
  }

  Future<void> _loadCurrentWeekStart() async {
    final settings = await databaseProvider.fetchCurrentGeneralSettings();
    if (settings != null && settings.weekStart != null) {
      setState(() {
        _startDay = WeekStartDays.values.firstWhere(
          (day) => day.name.toLowerCase() == settings.weekStart!.toLowerCase(),
          orElse: () => WeekStartDays.saturday,
        );
      });
    } else {
      setState(() {
        _startDay = WeekStartDays.saturday;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: WeekStartDays.values.length,
              itemBuilder: (context, index) {
                final day = WeekStartDays.values[index];
                return WeekStartTile(
                  groupValue: _startDay,
                  weekStartDays: day,
                  name: day.name[0].toUpperCase() + day.name.substring(1),
                  onChanged: (value) {
                    setState(() {
                      _startDay = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: kPrimaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    if (_startDay != null) {
                      try {
                        final settings = await databaseProvider
                            .fetchCurrentGeneralSettings();
                        if (settings != null) {
                          await databaseProvider.updateGeneralSettings(
                            GeneralSettingsModel(
                              id: settings.id,
                              isDarkMode: settings.isDarkMode,
                              listToShow: settings.listToShow,
                              weekStart: _startDay!.name,
                              timeFormat: settings.timeFormat,
                            ),
                          );
                        } else {
                          await databaseProvider.saveGeneralSettingsData(
                            GeneralSettingsModel(
                              isDarkMode: false,
                              listToShow: 'All Lists',
                              weekStart: _startDay!.name,
                              timeFormat: '12-hour',
                            ),
                          );
                        }
                        Navigator.pop(context);
                      } catch (e) {
                        CustomSnackBar().snackBarMessage(
                          context: context,
                          backGroundColor:
                              Theme.of(context).brightness == Brightness.dark
                              ? const Color.fromARGB(255, 49, 49, 49)
                              : const Color.fromARGB(255, 239, 239, 239),
                          closeIconColor: kPrimaryColor,
                          message:
                              'Failed to save Week start day selection: $e',
                          messageColor:
                              Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : kPrimaryColor,
                          duration: 2,
                          showCloseIcon: true,
                          borderColor:
                              Theme.of(context).brightness == Brightness.dark
                              ? kPrimaryLightColor
                              : kPrimaryColor,
                        );
                      }
                    } else {
                      CustomSnackBar().snackBarMessage(
                        context: context,
                        backGroundColor:
                            Theme.of(context).brightness == Brightness.dark
                            ? const Color.fromARGB(255, 49, 49, 49)
                            : const Color.fromARGB(255, 239, 239, 239),
                        closeIconColor: kPrimaryColor,
                        message: 'Please select a Week start day',
                        messageColor:
                            Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : kPrimaryColor,
                        duration: 2,
                        showCloseIcon: true,
                        borderColor:
                            Theme.of(context).brightness == Brightness.dark
                            ? kPrimaryLightColor
                            : kPrimaryColor,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: const Text(
                      'Choose',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WeekStartTile extends StatelessWidget {
  final WeekStartDays? groupValue;
  final ValueChanged<WeekStartDays?> onChanged;
  final WeekStartDays? weekStartDays;
  final String? name;

  const WeekStartTile({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.weekStartDays,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Radio<WeekStartDays>(
        value: weekStartDays!,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
      title: Text(name!, style: const TextStyle(fontSize: 18)),
    );
  }
}
