import 'package:flutter/material.dart';

class CategoriesListItemTasksCounter extends StatelessWidget {
  const CategoriesListItemTasksCounter({
    Key? key,
    required this.tasksCount,
    required this.tap,
  }) : super(key: key);

  final int tasksCount;
  final Function()? tap;

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var textColor = _isDarkMode ? Colors.white70 : Colors.black87;
    return GestureDetector(
      child: Row(
        children: [
          Text(tasksCount.toString(),
              style: TextStyle(fontSize: 18, color: textColor)),
          const SizedBox(width: 15),
          Icon(Icons.task_alt, color: textColor, size: 20),
        ],
      ),
      onTap: tap,
    );
  }
}
