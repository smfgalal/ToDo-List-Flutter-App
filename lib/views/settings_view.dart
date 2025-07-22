import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/general_settings_model.dart';
import 'package:todo_app/widgets/general_widgets/custom_snack_bar.dart';
import 'package:todo_app/widgets/settings_widgets/setting_list_tile_item.dart';
import 'package:todo_app/widgets/settings_widgets/setting_list_tile_switch.dart';
import 'package:todo_app/widgets/settings_widgets/show_list_startup_dialog.dart';
import 'package:todo_app/widgets/settings_widgets/show_weekstart_dialog.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late bool isVibrationChecked = true;

  @override
  void initState() {
    super.initState();
    databaseProvider.refreshGeneralSettings();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Setting'),
        toolbarHeight: 75,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: StreamBuilder<List<GeneralSettingsModel>>(
          stream: databaseProvider.readGeneralSettingsData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final settings = snapshot.data?.isNotEmpty == true
                ? snapshot.data!.first
                : null;
            bool isDarkMode = settings?.isDarkMode ?? themeProvider.isDarkMode;

            return ListView(
              children: [
                const Text(
                  'General',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                SettingListTileWithSwitch(
                  isChecked: isDarkMode,
                  titleText: 'App Theme',
                  subTitleText: isDarkMode ? 'Dark' : 'Light',
                  switchActiveColor: kPrimaryLightColor,
                  onChanged: (value) async {
                    try {
                      themeProvider.toggleTheme(value);
                      if (settings != null) {
                        await databaseProvider.updateGeneralSettings(
                          GeneralSettingsModel(
                            id: settings.id,
                            isDarkMode: value,
                            listToShow: settings.listToShow,
                            weekStart: settings.weekStart,
                            timeFormat: settings.timeFormat,
                          ),
                        );
                      } else {
                        await databaseProvider.saveGeneralSettingsData(
                          GeneralSettingsModel(
                            isDarkMode: value,
                            listToShow: 'All Lists',
                            weekStart: 'Saturday',
                            timeFormat: '12-hour',
                          ),
                        );
                      }
                    } catch (e) {
                      CustomSnackBar().snackBarMessage(
                        // ignore: use_build_context_synchronously
                        context: context,
                        // ignore: use_build_context_synchronously
                        backGroundColor: ChangeTheme().theme(context)
                            ? const Color.fromARGB(255, 49, 49, 49)
                            : const Color.fromARGB(255, 239, 239, 239),
                        closeIconColor: kPrimaryColor,
                        message: 'Failed to save theme: $e',
                        // ignore: use_build_context_synchronously
                        messageColor: ChangeTheme().theme(context)
                            ? Colors.white
                            : kPrimaryColor,
                        duration: 2,
                        showCloseIcon: true,
                        // ignore: use_build_context_synchronously
                        borderColor: ChangeTheme().theme(context)
                            ? kPrimaryLightColor
                            : kPrimaryColor,
                      );
                    }
                  },
                ),
                const SizedBox(height: 8),
                SettingsListTileItem(
                  title: 'List to show at startup',
                  subTitle: settings?.listToShow ?? 'All lists',
                  onTap: () {
                    ShowListToShowDialog().showWeekStartDialog(context);
                  },
                ),
                SettingsListTileItem(
                  title: 'First day of week',
                  subTitle: settings?.weekStart ?? 'Saturday',
                  onTap: () {
                    ShowWeekStartDialog().showWeekStartDialog(context);
                  },
                ),
                SettingsListTileItem(
                  title: 'Time format',
                  subTitle: settings?.timeFormat ?? '12-hour',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                const Text(
                  'Notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                SettingsListTileItem(
                  title: 'Sound',
                  subTitle: 'Default',
                  onTap: () {},
                ),
                SettingListTileWithSwitch(
                  isChecked: isVibrationChecked,
                  titleText: 'Vibration',
                  subTitleText: 'Enabled',
                  switchActiveColor: kPrimaryLightColor,
                  onChanged: (value) {
                    setState(() {
                      isVibrationChecked = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                SettingsListTileItem(
                  title: 'Task notification',
                  subTitle: 'on time',
                  onTap: () {},
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
