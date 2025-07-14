import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/widgets/general_widgets/custom_text_field.dart';

class AddNewToDoText extends StatelessWidget {
  const AddNewToDoText({
    super.key,
    required this.title,
    this.hintText = '',
    required this.icon, this.textController,
  });

  final String title;
  final String hintText;
  final Icon icon;
  final TextEditingController? textController;

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
                textController: textController,
                validator: (data) {
                  if (data!.isEmpty) {
                    return 'Task field is required.';
                  }
                  return null;
                },
              ),
            ),
            IconButton(onPressed: () {}, icon: icon),
          ],
        ),
      ],
    );
  }
}
