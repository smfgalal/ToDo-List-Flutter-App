import 'package:flutter/material.dart';

class CustomSnackBar {
  void snackBarMessage({
    required BuildContext context,
    required Color backGroundColor,
    required Color closeIconColor,
    required String message,
    required Color messageColor,
    required int duration,
    required bool showCloseIcon,
    required Color borderColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: backGroundColor,
          elevation: 0,
          showCloseIcon: showCloseIcon,
          closeIconColor: closeIconColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          duration: Duration(seconds: duration),
          shape: Border.symmetric(
            vertical: BorderSide(width: 5, color: borderColor),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: messageColor,
              fontSize: 14,
            ),
          ),
          //behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
