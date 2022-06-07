import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.icon,
    required this.name,
    required this.tap,
  }) : super(key: key);

  final Icon icon;
  final String name;
  final Function() tap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: icon,
        title: Text(name, style: const TextStyle(fontSize: 18)),
        onTap: tap);
  }
}
