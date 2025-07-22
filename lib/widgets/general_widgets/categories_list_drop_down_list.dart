import 'package:flutter/material.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';

class CustomCategoriesListDropDownList extends StatefulWidget {
  const CustomCategoriesListDropDownList({
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
  State<CustomCategoriesListDropDownList> createState() =>
      _CustomCategoriesListDropDownListState();
}

class _CustomCategoriesListDropDownListState
    extends State<CustomCategoriesListDropDownList> {
  late String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue =
        widget.initialSelection ?? widget.listsDropdownItems.first['value'];
    // Notify parent with initial selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelected?.call(selectedValue);
    });
  }

  @override
  void didUpdateWidget(CustomCategoriesListDropDownList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelection != oldWidget.initialSelection) {
      setState(() {
        selectedValue =
            widget.initialSelection ?? widget.listsDropdownItems.first['value'];
      });
      // Notify parent with updated selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelected?.call(selectedValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.listsDropdownItems;

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
          leadingIcon: Icon(
            item['icon'],
            color: ChangeTheme().theme(context) ? Colors.white : kPrimaryColor,
          ),
          style: ButtonStyle(
            surfaceTintColor: WidgetStateColor.resolveWith(
              (_) =>
                  ChangeTheme().theme(context) ? Colors.white : kPrimaryColor,
            ),
            backgroundColor: WidgetStateColor.resolveWith(
              (_) => ChangeTheme().theme(context)
                  ? const Color.fromARGB(255, 18, 18, 18)
                  : const Color.fromARGB(255, 242, 242, 242),
            ),
            shape: WidgetStateOutlinedBorder.resolveWith((_) {
              return LinearBorder.bottom(
                side: BorderSide(
                  color: ChangeTheme().theme(context)
                      ? const Color.fromARGB(255, 55, 55, 55)
                      : const Color.fromARGB(255, 208, 208, 208),
                ),
              );
            }),
          ),
        );
      }).toList(),
    );
  }
}
