import 'package:flutter/material.dart';
import 'package:todo_app/helpers/constants.dart';

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
  WeekStartDays? _startDay = WeekStartDays.saturday;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Radio<WeekStartDays>(
                  value: WeekStartDays.saturday,
                  groupValue: _startDay,
                  onChanged: (WeekStartDays? value) {
                    setState(() {
                      _startDay = value;
                    });
                  },
                ),
                title: const Text('Saturday', style: TextStyle(fontSize: 18)),
              ),
              ListTile(
                leading: Radio<WeekStartDays>(
                  value: WeekStartDays.sunday,
                  groupValue: _startDay,
                  onChanged: (WeekStartDays? value) {
                    setState(() {
                      _startDay = value;
                    });
                  },
                ),
                title: const Text('Sunday', style: TextStyle(fontSize: 18)),
              ),
              ListTile(
                leading: Radio<WeekStartDays>(
                  value: WeekStartDays.monday,
                  groupValue: _startDay,
                  onChanged: (WeekStartDays? value) {
                    setState(() {
                      _startDay = value;
                    });
                  },
                ),
                title: const Text('Monday', style: TextStyle(fontSize: 18)),
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
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context);
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
      ),
    );
  }
}
