import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';
import 'package:todo_app/widgets/settings_widgets/setting_list_tile_item.dart';
import 'package:todo_app/widgets/settings_widgets/setting_list_tile_switch.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late bool isVibrationChecked = true;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
      bool isAppThemeChecked = themeProvider.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Setting'),
        toolbarHeight: 75,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ListView(
          children: [
            const Text(
              'General',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            SettingListTileWithSwitch(
              isChecked: isAppThemeChecked,
              titleText: 'App Theme',
              subTitleText: isAppThemeChecked ? 'Dark' : 'Light',
              switchActiveColor: kPrimaryLightColor,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
            const SizedBox(height: 8),
            SettingsListTileItem(
              title: 'List to show at startup',
              subTitle: 'All lists',
              onTap: () {},
            ),
            SettingsListTileItem(
              title: 'First day of week',
              subTitle: 'Saturday',
              onTap: () {},
            ),
            SettingsListTileItem(
              title: 'Time format',
              subTitle: '12-hour',
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
        ),
      ),
    );
  }
}
