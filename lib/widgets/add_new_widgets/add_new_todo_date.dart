import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/widgets/custom_text_field.dart';

class AddNewToDoDate extends StatelessWidget {
  const AddNewToDoDate({
    super.key,
    required this.title,
    required this.hintText,
    required this.icon,
  });

  final String title;
  final String hintText;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
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
                hintText: hintText,
                minLines: 1,
                maxLines: 5,
                isReadOnly: true,
                validator: (data) {
                  if (data!.isEmpty) {
                    return 'Date and time field is required.';
                  }
                  return null;
                },
                onTap: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050),
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2050),
                );
              },
              icon: icon,
            ),
          ],
        ),
      ],
    );
  }
}
