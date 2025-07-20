import 'package:flutter/material.dart';
import 'package:todo_app/helpers/constants.dart';

class CustomCheckBox extends StatelessWidget {
  final bool? value;
  final Color borderColor;
  final Function(bool?)? onChanged;

  const CustomCheckBox({
    super.key,
    this.value,
    required this.borderColor,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      splashRadius: 100,
      activeColor: kPrimaryLightColor,
      side: BorderSide(color: borderColor, width: 2, strokeAlign: 2),
      value: value,
      onChanged: onChanged,
    );
  }
}
