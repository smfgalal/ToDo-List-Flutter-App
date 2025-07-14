import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

class CustomRepeatDropDownList extends StatefulWidget {
  const CustomRepeatDropDownList({
    super.key,
    required this.initialTextColor,
    required this.prefixIconColor,
    required this.suffixIconColor,
    required this.listsDropdownItems,
    this.initialSelection,
    this.onSelected,
  });

  final Color initialTextColor;
  final Color prefixIconColor;
  final Color suffixIconColor;
  final List<Map<String, dynamic>> listsDropdownItems;
  final String? initialSelection;
  final ValueChanged<String?>? onSelected;

  @override
  State<CustomRepeatDropDownList> createState() => _CustomDropDownListState();
}

class _CustomDropDownListState extends State<CustomRepeatDropDownList> {
  late String? selectedValue;

  

  @override
  void initState() {
    super.initState();
    selectedValue =
        widget.initialSelection ?? widget.listsDropdownItems.first['value'];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelected?.call(selectedValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.listsDropdownItems.toList();

    return DropdownMenu(
      onSelected: (value) {
        if (value != null) {
          setState(() {
            selectedValue = value;
          });
          widget.onSelected?.call(value);
        }
      },
      //width: MediaQuery.of(context).size.width / 2.1,
      enableFilter: true,
      leadingIcon: const Icon(Icons.home),
      textStyle: TextStyle(color: widget.initialTextColor, fontSize: 18),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: widget.prefixIconColor,
        suffixIconColor: widget.suffixIconColor,
      ),

      initialSelection: selectedValue,
      dropdownMenuEntries: items.map((item) {
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
