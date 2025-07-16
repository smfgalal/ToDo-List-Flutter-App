import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

class CustomListsDropDownList extends StatefulWidget {
  const CustomListsDropDownList({
    super.key,
    required this.initialTextColor,
    required this.prefixIconColor,
    required this.suffixIconColor,
    required this.isHomePage,
    required this.listsDropdownItems,
    this.initialSelection,
    this.onSelected,
  });

  final Color initialTextColor;
  final Color prefixIconColor;
  final Color suffixIconColor;
  final bool isHomePage;
  final List<Map<String, dynamic>> listsDropdownItems;
  final String? initialSelection;
  final ValueChanged<String?>? onSelected;

  @override
  State<CustomListsDropDownList> createState() =>
      _CustomListsDropDownListState();
}

class _CustomListsDropDownListState extends State<CustomListsDropDownList> {
  late String? selectedValue;

  @override
  void initState() {
    // Set default to "All Lists" if isHomePage, else use initialSelection or first item
    selectedValue = widget.isHomePage
        ? 'All Lists'
        : widget.initialSelection ?? widget.listsDropdownItems.first['value'];
    // Notify parent with initial selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelected?.call(selectedValue);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.isHomePage
        ? [
            {'value': 'All Lists', 'label': 'All Lists', 'icon': Icons.home},
            ...widget.listsDropdownItems,
          ]
        : widget.listsDropdownItems
              .where((item) => item['value'] != 'Finished')
              .toList();

    return DropdownMenu(
      onSelected: (value) {
        if (value != null) {
          setState(() {
            selectedValue = value;
          });
          widget.onSelected?.call(value);
        }
      },
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
            surfaceTintColor: WidgetStateColor.resolveWith(
              (_) => kPrimaryColor,
            ),
            shape: WidgetStateOutlinedBorder.resolveWith((_) {
              return LinearBorder.bottom(
                side: const BorderSide(color: Colors.white),
              );
            }),
          ),
        );
      }).toList(),
    );
  }
}
