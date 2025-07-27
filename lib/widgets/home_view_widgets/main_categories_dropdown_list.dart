import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/categories_list_model.dart';
import 'package:todo_app/models/general_settings_model.dart';
import 'package:todo_app/widgets/general_widgets/categories_list_drop_down_list.dart';

class MainCategoriesDropDownList{
  StreamBuilder<List<GeneralSettingsModel>> mainCategoriesDropDownList(String? selectedCategory, Function(String?)? onSelected) {
    return StreamBuilder<List<GeneralSettingsModel>>(
      stream: databaseProvider.readGeneralSettingsData(),
      builder: (context, settingsSnapshot) {
        if (settingsSnapshot.hasError) {
          return Text('Error: ${settingsSnapshot.error}');
        }
        final settings = settingsSnapshot.data?.isNotEmpty == true
            ? settingsSnapshot.data!.first
            : null;
        selectedCategory = settings?.listToShow ?? 'All Lists';

        return StreamBuilder<List<CategoriesListsModel>>(
          stream: databaseProvider.readCategoriesListsData(),
          builder: (context, categoriesSnapshot) {
            if (categoriesSnapshot.hasError) {
              return Text('Error: ${categoriesSnapshot.error}');
            }
            final categories = categoriesSnapshot.data ?? [];
            final dropdownItems = [
              {'value': 'All Lists', 'label': 'All Lists', 'icon': Icons.home},
              ...categories.map((category) {
                return {
                  'value': category.categoryListValue,
                  'label': category.categoryListValue,
                  'icon': Icons.blur_on_outlined,
                };
              }),
              {'value': 'Finished', 'label': 'Finished', 'icon': Icons.done},
            ];
            // Ensure selectedCategory is valid
            if (selectedCategory == null ||
                !dropdownItems.any(
                  (item) => item['value'] == selectedCategory,
                )) {
              selectedCategory = dropdownItems.first['value'].toString();
            }
            return CustomCategoriesListDropDownList(
              initialTextColor: Colors.white,
              prefixIconColor: Colors.white,
              suffixIconColor: Colors.white,
              listsDropdownItems: dropdownItems,
              initialSelection: selectedCategory,
              onSelected: onSelected,
            );
          },
        );
      },
    );
  }
}