import 'package:flut_todo/theme/app_constants.dart';
import 'package:flut_todo/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<SettingsScreen> {
  int _selectedPosition = 0;
  List themes = ["System default", "Light", "Dark"];
  late SharedPreferences preferences;
  late ThemeNotifier themeNotifier;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _getSavedTheme();
    });
  }

  _getSavedTheme() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _selectedPosition =
          themes.indexOf(preferences.getString("Theme") ?? "System default");
    });
  }

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var appBarColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('Theme mode'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemBuilder: (context, position) {
            return _createList(context, themes[position], position);
          },
          itemCount: themes.length,
        ),
      ),
    );
  }

  _createList(context, item, position) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        _updateState(position);
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Radio(
            value: _selectedPosition,
            groupValue: position,
            activeColor: _isDarkMode ? cDarkAccentColor : cLightAccentColor,
            onChanged: (_) {
              _updateState(position);
            },
          ),
          Text(item),
        ],
      ),
    );
  }

  _updateState(int position) {
    setState(() {
      _selectedPosition = position;
    });
    onThemeChanged(themes[position]);
  }

  void onThemeChanged(String value) async {
    var prefs = await SharedPreferences.getInstance();
    if (value == "System default") {
      themeNotifier.setThemeMode(ThemeMode.system);
    } else if (value == "Dark") {
      themeNotifier.setThemeMode(ThemeMode.dark);
    } else {
      themeNotifier.setThemeMode(ThemeMode.light);
    }
    prefs.setString("Theme", value);
  }
}
