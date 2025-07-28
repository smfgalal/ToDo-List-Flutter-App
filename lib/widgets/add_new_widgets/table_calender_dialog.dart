import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';

class ShowTableCalenderDialog extends StatelessWidget {
  const ShowTableCalenderDialog({
    super.key,
    required this.chosenDate,
    required StartingDayOfWeek? startingDayOfWeek,
  }) : _startingDayOfWeek = startingDayOfWeek;

  final DateTime? chosenDate;
  final StartingDayOfWeek? _startingDayOfWeek;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime(2050),
              currentDay: chosenDate ?? DateTime.now(),
              focusedDay: chosenDate ?? DateTime.now(),
              startingDayOfWeek:
                  _startingDayOfWeek ?? StartingDayOfWeek.saturday,
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selectedDay, focusedDay) {
                Navigator.of(context).pop(selectedDay);
              },
              calendarStyle: CalendarStyle(
                tableBorder: TableBorder(
                  bottom: BorderSide(
                    width: 1,
                    color: ChangeTheme().theme(context)
                        ? const Color.fromARGB(255, 85, 85, 85)
                        : const Color.fromARGB(255, 183, 183, 183),
                  ),
                ),
                todayDecoration: BoxDecoration(
                  color: ChangeTheme().theme(context)
                      ? kPrimaryLightColor
                      : kPrimaryColor,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: ChangeTheme().theme(context)
                      ? kPrimaryColor
                      : kPrimaryLightColor,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(chosenDate ?? DateTime.now()),
                  child: const Text('Choose'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
