import 'package:flutter/material.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/categories_list_model.dart';
import 'package:todo_app/models/general_settings_model.dart';
import 'package:todo_app/widgets/general_widgets/custom_snack_bar.dart';

class ShowListToShowDialog {
  Future<dynamic> showWeekStartDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const ShowListToShowStartupDialog();
      },
    );
  }
}

class ShowListToShowStartupDialog extends StatefulWidget {
  const ShowListToShowStartupDialog({super.key});

  @override
  State<ShowListToShowStartupDialog> createState() =>
      _ShowListToShowStartupDialogState();
}

class _ShowListToShowStartupDialogState
    extends State<ShowListToShowStartupDialog> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Ensure categories are refreshed
    databaseProvider.refreshCategoriesList();
    // Load current listToShow from generalSettingsTable
    _loadCurrentListToShow();
  }

  Future<void> _loadCurrentListToShow() async {
    try {
      final settings = await databaseProvider.fetchCurrentGeneralSettings();
      setState(() {
        _selectedCategory = settings?.listToShow ?? 'All Lists';
      });
    } catch (e) {
      print('Error loading current listToShow: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CategoriesListsModel>>(
      stream: databaseProvider.readCategoriesListsData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snapshot.hasError) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text('Error: ${snapshot.error}')),
            ),
          );
        }
        final lists = snapshot.data ?? [];
        // Add "All Lists" as a default option
        final allListsOption = CategoriesListsModel(
          id: null,
          categoryListValue: 'All Lists',
        );
        final allCategories = [allListsOption, ...lists];

        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select List to Show at Startup',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      return ListToShowTile(
                        category: allCategories[index],
                        groupValue: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: const BoxDecoration(
                          color: kPrimaryLightColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        if (_selectedCategory != null) {
                          try {
                            final settings = await databaseProvider
                                .fetchCurrentGeneralSettings();
                            if (settings != null) {
                              await databaseProvider.updateGeneralSettings(
                                GeneralSettingsModel(
                                  id: settings.id,
                                  isDarkMode: settings.isDarkMode,
                                  listToShow: _selectedCategory,
                                  weekStart: settings.weekStart,
                                  timeFormat: settings.timeFormat,
                                ),
                              );
                            } else {
                              await databaseProvider.saveGeneralSettingsData(
                                GeneralSettingsModel(
                                  isDarkMode: false,
                                  listToShow: _selectedCategory,
                                  weekStart: 'Saturday',
                                  timeFormat: '12-hour',
                                ),
                              );
                            }
                            Navigator.pop(context);
                          } catch (e) {
                            CustomSnackBar().snackBarMessage(
                              context: context,
                              backGroundColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color.fromARGB(255, 49, 49, 49)
                                  : const Color.fromARGB(255, 239, 239, 239),
                              closeIconColor: kPrimaryColor,
                              message: 'Failed to save list selection: $e',
                              messageColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : kPrimaryColor,
                              duration: 2,
                              showCloseIcon: true,
                              borderColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? kPrimaryLightColor
                                  : kPrimaryColor,
                            );
                          }
                        } else {
                          CustomSnackBar().snackBarMessage(
                            context: context,
                            backGroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                ? const Color.fromARGB(255, 49, 49, 49)
                                : const Color.fromARGB(255, 239, 239, 239),
                            closeIconColor: kPrimaryColor,
                            message: 'Please select a list',
                            messageColor:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : kPrimaryColor,
                            duration: 2,
                            showCloseIcon: true,
                            borderColor:
                                Theme.of(context).brightness == Brightness.dark
                                ? kPrimaryLightColor
                                : kPrimaryColor,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: const BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: const Text(
                          'Choose',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ListToShowTile extends StatelessWidget {
  final CategoriesListsModel category;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const ListToShowTile({
    super.key,
    required this.category,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Radio<String?>(
        value: category.categoryListValue,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
      title: Text(
        category.categoryListValue!,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
