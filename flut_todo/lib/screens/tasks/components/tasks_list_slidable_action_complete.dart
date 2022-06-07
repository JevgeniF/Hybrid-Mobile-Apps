import 'package:flut_todo/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableActionComplete extends StatelessWidget {
  const SlidableActionComplete(
      {Key? key, required this.task, required this.press})
      : super(key: key);

  final Task task;
  final Function(BuildContext)? press;

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: press,
      backgroundColor: Colors.greenAccent,
      foregroundColor: Colors.white,
      icon: task.isCompleted ? Icons.undo : Icons.done,
      label: task.isCompleted ? 'Revert' : 'Complete',
    );
  }
}
