import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

class ConfirmationMessageShowDialog extends StatelessWidget {
  const ConfirmationMessageShowDialog({
    super.key,
    required this.message,
    this.onPressedYes,
    this.onPressedNo,
  });

  final String message;
  final void Function()? onPressedYes;
  final void Function()? onPressedNo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        backgroundColor: const Color.fromARGB(255, 39, 39, 39),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                maxLines: 2,
                softWrap: true,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryLightColor,
                      foregroundColor: kPrimaryColor,
                    ),
                    onPressed: onPressedYes,
                    child: const Text('Yes'),
                  ),
                  const SizedBox(width: 35),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryLightColor,
                      foregroundColor: kPrimaryColor,
                    ),
                    onPressed: onPressedNo,
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
