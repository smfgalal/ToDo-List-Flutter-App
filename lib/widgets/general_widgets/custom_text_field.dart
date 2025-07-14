import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.onSaved,
    this.minLines = 1,
    this.maxLines = 1,
    this.validator,
    this.onTap,
    this.isReadOnly = false,
    this.textController,
    this.initialvalue,
  });

  final String hintText;
  final Function(String?)? onSaved;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final int minLines;
  final int maxLines;
  final bool isReadOnly;
  final TextEditingController? textController;
  final String? initialvalue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      onTap: onTap,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      initialValue: initialvalue,
      controller: textController,
      keyboardType: TextInputType.multiline,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        hintText: hintText,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryLightColor),
        ),
      ),
    );
  }
}
