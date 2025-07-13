import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

class CustomRepeatDropDownList extends StatefulWidget {
  const CustomRepeatDropDownList({
    super.key,
    required this.initialTextColor,
    required this.prefixIconColor,
    required this.suffixIconColor,
  });

  final Color initialTextColor;
  final Color prefixIconColor;
  final Color suffixIconColor;

  @override
  State<CustomRepeatDropDownList> createState() => _CustomDropDownListState();
}

class _CustomDropDownListState extends State<CustomRepeatDropDownList> {
  @override
  Widget build(BuildContext context) {

    String? selectedItem = repeatDropdownItems.first['value'];
    return DropdownMenu(
      //width: MediaQuery.of(context).size.width / 2.1,
      enableFilter: true,
      leadingIcon: const Icon(Icons.home),
      textStyle: TextStyle(color: widget.initialTextColor, fontSize: 18),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: widget.prefixIconColor,
        suffixIconColor: widget.suffixIconColor,
      ),

      initialSelection: selectedItem,
      dropdownMenuEntries: repeatDropdownItems.map((item) {
        return DropdownMenuEntry<String>(
          value: item['value'],
          label: item['label'],
          leadingIcon: Icon(item['icon'], color: kPrimaryColor),
          style: ButtonStyle(
            surfaceTintColor: WidgetStateColor.resolveWith((C) {
              return kPrimaryColor;
            }),
            shape: WidgetStateOutlinedBorder.resolveWith((c) {
              return LinearBorder.bottom(side: BorderSide(color: Colors.white));
            }),
          ),
        );
      }).toList(),
    );
  }
}
