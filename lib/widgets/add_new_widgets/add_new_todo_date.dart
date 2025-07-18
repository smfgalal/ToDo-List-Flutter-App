import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/widgets/general_widgets/custom_text_field.dart';

class AddNewToDoDate extends StatefulWidget {
  const AddNewToDoDate({
    super.key,
    required this.title,
    required this.hintText,
    required this.icon,
    this.onDateTimeChanged,
    this.controller,
  });

  final String title;
  final String hintText;
  final Icon icon;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final TextEditingController? controller;

  @override
  State<AddNewToDoDate> createState() => _AddNewToDoDateState();
}

class _AddNewToDoDateState extends State<AddNewToDoDate> {
  DateTime? chosenDate;


  Future<void> _selectDateTime(BuildContext context) async {
    // Show DatePicker
    final selectedDate = await showDatePicker(
      context: context,
      switchToInputEntryModeIcon: const Icon(Icons.edit),
      confirmText: 'Choose',
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
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
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
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
