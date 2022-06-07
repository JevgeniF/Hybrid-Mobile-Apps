import 'package:flut_todo/models/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskListItemDueDate extends StatelessWidget {
  const TaskListItemDueDate({
    Key? key,
    required this.task,
    this.tap,
  }) : super(key: key);

  final Task task;
  final Function()? tap;

  String getTime(Task task) {
    var dateFormat = DateFormat('HH:mm');
    if (task.dueDt != null) {
      var utcDate = dateFormat.format(DateTime.parse(task.dueDt!));
      var localDate = dateFormat
          .parse(utcDate, true)
          .toLocal()
          .subtract(const Duration(hours: 1))
          .toString();
      return dateFormat.format(DateTime.parse(localDate));
    }
    return 'set';
  }

  String getDate(Task task) {
    var dateFormat = DateFormat('dd.MM.yyyy');
    if (task.dueDt != null) {
      var utcDate = dateFormat.format(DateTime.parse(task.dueDt!));
      var localDate = dateFormat
          .parse(utcDate, true)
          .toLocal()
          .subtract(const Duration(hours: 1))
          .toString();
      return dateFormat.format(DateTime.parse(localDate));
    }
    return 'due date';
  }

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var textColor = _isDarkMode ? Colors.white70 : Colors.black87;
    return GestureDetector(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  getTime(task),
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
                Text(getDate(task),
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor,
                    ))
              ],
            ),
            const SizedBox(width: 5),
            Icon(Icons.alarm, color: textColor, size: 20)
          ],
        ),
        onTap: tap);
  }
}
