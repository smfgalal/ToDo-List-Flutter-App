// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';

// ignore: must_be_immutable
class SettingListTileWithSwitch extends StatefulWidget {
  SettingListTileWithSwitch({
    super.key,
    required this.isChecked,
    required this.titleText,
    required this.subTitleText,
    required this.switchActiveColor,
    required this.onChanged,
  });
  bool? isChecked;
  final String titleText;
  final String subTitleText;
  final Color switchActiveColor;
  final Function(bool)? onChanged;

  @override
  State<SettingListTileWithSwitch> createState() =>
      _SettingListTileWithSwitchState();
}

class _SettingListTileWithSwitchState extends State<SettingListTileWithSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: ChangeTheme().theme(context)
            ? kPrimaryDarkColor
            : const Color.fromARGB(255, 241, 241, 241),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.titleText,
                style: TextStyle(
                  fontSize: 18,
                  color: ChangeTheme().theme(context)
                      ? const Color.fromARGB(255, 241, 241, 241)
                      : kPrimaryColor,
                ),
              ),
              Text(
                widget.subTitleText,
                style: TextStyle(
                  fontSize: 14,
                  color: ChangeTheme().theme(context)
                      ? kPrimaryLightColor
                      : const Color.fromARGB(255, 220, 143, 19),
                ),
              ),
            ],
          ),
          Switch(
            trackOutlineWidth: const WidgetStatePropertyAll(2),
            activeTrackColor: widget.switchActiveColor,
            value: widget.isChecked!,
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}
