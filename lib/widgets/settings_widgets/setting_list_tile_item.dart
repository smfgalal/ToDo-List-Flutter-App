import 'package:flutter/material.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';

class SettingsListTileItem extends StatefulWidget {
  const SettingsListTileItem({
    super.key,
    required this.title,
    required this.subTitle,
    this.onTap,
  });

  final String title;
  final String subTitle;
  final Function()? onTap;

  @override
  State<SettingsListTileItem> createState() => _SettingsListTileItemState();
}

class _SettingsListTileItemState extends State<SettingsListTileItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: ChangeTheme().theme(context)
              ? kPrimaryDarkColor
              : const Color.fromARGB(255, 241, 241, 241),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: ListTile(
          splashColor: kPrimaryLightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          onTap: widget.onTap,
          title: Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              color: ChangeTheme().theme(context)
                  ? const Color.fromARGB(255, 241, 241, 241)
                  : kPrimaryColor,
            ),
          ),
          subtitle: Text(
            widget.subTitle,
            style:  TextStyle(
              fontSize: 16,
              // color: Color.fromARGB(255, 220, 143, 19),
              color: ChangeTheme().theme(context)
                  ? kPrimaryLightColor
                  : const Color.fromARGB(255, 212, 138, 17),
            ),
          ),
        ),
      ),
    );
  }
}
