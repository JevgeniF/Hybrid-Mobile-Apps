import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

class Root extends StatelessWidget {
  const Root({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var rootColor = _isDarkMode ? cDarkPrimaryColorLight : cLightPrimaryColorLight;
    Size size = MediaQuery.of(context).size;
    return Container(
        color: rootColor,
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            child,
          ],
        ));
  }
}
