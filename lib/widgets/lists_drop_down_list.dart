import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

class CustomListsDropDownList extends StatefulWidget {
  const CustomListsDropDownList({
    super.key,
    required this.initialTextColor,
    required this.prefixIconColor,
    required this.suffixIconColor,
    required this.isHomePage,
  });

  final Color initialTextColor;
  final Color prefixIconColor;
  final Color suffixIconColor;
  final bool isHomePage;

  @override
  State<CustomListsDropDownList> createState() => _CustomListsDropDownListState();
}

class _CustomListsDropDownListState extends State<CustomListsDropDownList> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> listsDropdownItems = [
      //{'value': 'All Lists', 'label': 'All Lists', 'icon': Icons.home},
      {'value': 'Default', 'label': 'Default', 'icon': Icons.blur_on_outlined},
      {
        'value': 'Personal',
        'label': 'Personal',
        'icon': Icons.blur_on_outlined,
      },
      {
        'value': 'Shopping',
        'label': 'Shopping',
        'icon': Icons.blur_on_outlined,
      },
      {
        'value': 'Wishlist',
        'label': 'Wishlist',
        'icon': Icons.blur_on_outlined,
      },
      {'value': 'Work', 'label': 'Work', 'icon': Icons.blur_on_outlined},
      {'value': 'Finished', 'label': 'Finished', 'icon': Icons.check_circle},
    ];
    if (widget.isHomePage) {
      listsDropdownItems.elementAt(0).addAll({
        'value': 'All Lists',
        'label': 'All Lists',
        'icon': Icons.home,
      });
    } else {
      listsDropdownItems.removeLast();
    }

    String? selectedItem = listsDropdownItems.first['value'];
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
      dropdownMenuEntries: listsDropdownItems.map((item) {
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
