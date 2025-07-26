import 'package:flutter/material.dart';
import 'package:todo_app/helpers/change_theme.dart';
import 'package:todo_app/helpers/constants.dart';

class NoDataColumn extends StatelessWidget {
  const NoDataColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'There are no data to show!',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ChangeTheme().theme(context)
                  ? const Color.fromARGB(255, 37, 37, 37)
                  : const Color.fromARGB(255, 241, 241, 241),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Swipe left '),
                Icon(Icons.arrow_back, color: kPrimaryLightColor),
                Text(' to delete the task'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ChangeTheme().theme(context)
                  ? const Color.fromARGB(255, 37, 37, 37)
                  : const Color.fromARGB(255, 241, 241, 241),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Swipe right '),
                const Icon(Icons.arrow_forward, color: kPrimaryLightColor),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: const Text(
                    ' to edit the task or Tap on it',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
