import 'package:flutter/material.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/widgets/general_widgets/custom_text_field.dart';

class AddNewToDoText extends StatelessWidget {
  const AddNewToDoText({
    super.key,
    required this.title,
    this.hintText = '',
    this.textController,
  });

  final String title;
  final String hintText;
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
            fontSize: 18,
            color: ChangeTheme().theme(context) ? Colors.white : kPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.2,
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
      ],
    );
  }
}
