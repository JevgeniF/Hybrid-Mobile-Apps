import 'package:flutter/material.dart';

class ListItemDescription extends StatelessWidget {
  const ListItemDescription({
    Key? key,
    required this.children,
    required this.tap,
  }) : super(key: key);

  final List<Widget> children;
  final Function()? tap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
      onTap: tap,
    );
  }
}
