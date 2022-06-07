import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var iconColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    return Icon(Icons.list, size: 20, color: iconColor);
  }
}
