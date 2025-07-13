import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF14213d);
const kPrimaryLightColor = Color(0xFFfca311);
const kPrimaryDarkColor = Color.fromARGB(255, 15, 22, 37);


const List<Map<String, dynamic>> repeatDropdownItems = [
  {'value': 'No repeat', 'label': 'No repeat', 'icon': Icons.loop_outlined},
  {'value': 'Once a day', 'label': 'Once a day', 'icon': Icons.loop_outlined},
  {'value': 'Once a week', 'label': 'Once a week', 'icon': Icons.loop_outlined},
  {
    'value': 'Once a month',
    'label': 'Once a month',
    'icon': Icons.loop_outlined,
  },
  {'value': 'Once a year', 'label': 'Once a year', 'icon': Icons.loop_outlined},
  {'value': 'Other', 'label': 'Other', 'icon': Icons.repeat},
];
