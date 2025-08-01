import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/widgets/add_new_widgets/table_calender_dialog.dart';
import 'package:todo_app/widgets/general_widgets/custom_text_field.dart';

class AddNewToDoDate extends StatefulWidget {
  const AddNewToDoDate({
    super.key,
    required this.title,
    required this.hintText,
    required this.icon,
    this.onDateTimeChanged,
    this.controller,
    this.todoModel,
  });

  final String title;
  final String hintText;
  final Icon icon;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final TextEditingController? controller;
  final TodoModel? todoModel;

  @override
  State<AddNewToDoDate> createState() => _AddNewToDoDateState();
}

class _AddNewToDoDateState extends State<AddNewToDoDate> {
  DateTime? chosenDate;
  StartingDayOfWeek? _startingDayOfWeek;

  @override
  void initState() {
    super.initState();
    chosenDate = widget.todoModel != null
        ? DateFormat.yMMMMd().add_jm().parse(widget.todoModel!.toDate)
        : null;
    _loadWeekStart();
  }

  Future<void> _loadWeekStart() async {
    final settings = await databaseProvider.fetchCurrentGeneralSettings();
    setState(() {
      _startingDayOfWeek = _mapWeekStartToStartingDay(settings?.weekStart);
    });
  }

  StartingDayOfWeek _mapWeekStartToStartingDay(String? weekStart) {
    switch (weekStart?.toLowerCase()) {
      case 'sunday':
        return StartingDayOfWeek.sunday;
      case 'monday':
        return StartingDayOfWeek.monday;
      case 'saturday':
      default:
        return StartingDayOfWeek.saturday;
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) => ShowTableCalenderDialog(
        chosenDate: chosenDate,
        startingDayOfWeek: _startingDayOfWeek,
      ),
    );

    if (selectedDate != null && context.mounted) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        confirmText: 'Confirm',
      );

      if (selectedTime != null && context.mounted) {
        // Combine date and time
        final dateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        setState(() {
          chosenDate = dateTime;
          widget.controller?.text = DateFormat.yMMMMd().add_jm().format(
            dateTime,
          );
        });
        // Notify parent widget
        widget.onDateTimeChanged?.call(dateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: ChangeTheme().theme(context) ? Colors.white : kPrimaryColor,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              child: CustomTextField(
                textController: widget.controller,
                hintText: widget.hintText,
                minLines: 1,
                maxLines: 5,
                isReadOnly: true,
                validator: (data) {
                  if (data == null || data.isEmpty) {
                    return 'Date and time field is required.';
                  }
                  return null;
                },
                onTap: () {
                  _selectDateTime(context);
                },
              ),
            ),
            IconButton(
              onPressed: () {
                _selectDateTime(context);
              },
              icon: widget.icon,
            ),
          ],
        ),
      ],
    );
  }
}

