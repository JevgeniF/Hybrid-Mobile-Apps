import 'package:flutter/material.dart';

class ListItemContainerWithRow extends StatelessWidget {
  const ListItemContainerWithRow({
    Key? key,
    required this.children,
    required this.color
  }) : super(key: key);

  final List<Widget> children;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            color: color,
            border: const Border(bottom: BorderSide(color: Colors.black12, width: 1)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 3),
                blurRadius: 5,
                spreadRadius: 1,
              )
            ]),
        child: Row(children: children));
  }
}
