import 'package:auto_size_text/auto_size_text.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

class ListItemName extends StatelessWidget {
  const ListItemName({
    Key? key,
    required this.itemName,
    this.decoration,
  }) : super(key: key);

  final String itemName;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var textColor = _isDarkMode ? Colors.white : cLightPrimaryColor;
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.55,
      child: AutoSizeText(
        itemName,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textColor,
            decoration: decoration),
        maxLines: 3,
        maxFontSize: 18,
        overflow: TextOverflow.fade,
      ),
    );
  }
}
