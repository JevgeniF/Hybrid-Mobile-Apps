import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableActionDelete extends StatelessWidget {
  const SlidableActionDelete({
    Key? key,
    required this.press,
  }) : super(key: key);

  final Function(BuildContext)? press;

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: press,
      backgroundColor: Colors.pinkAccent,
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: 'Delete',
    );
  }
}
