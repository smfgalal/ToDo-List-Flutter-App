import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.minLines = 1,
    this.maxLines = 1,
    this.validator,
    this.onTap,
    this.isReadOnly = false,
    this.textController,
  });

  final String hintText;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final int minLines;
  final int maxLines;
  final bool isReadOnly;
  final TextEditingController? textController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      controller: textController,
      keyboardType: TextInputType.multiline,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        hintText: hintText,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryLightColor),
        ),
      ),
    );
  }
}
