import 'dart:convert';

import 'package:flut_todo/authentication/provider/authentication.dart';
import 'package:flut_todo/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/drawer_list_title.dart';
import 'components/drawer_user_container.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _name = '';
  String _lastName = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((preferences) => {
          setState(() {
            final restoredData =
                jsonDecode(preferences.getString('@user') as String);
            _name = restoredData['firstName'];
            _lastName = restoredData['lastName'];
            _email = restoredData['email'];
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: <Widget>[
      DrawerUserContainer(name: _name, lastName: _lastName, email: _email),
      DrawerListTile(
        icon: const Icon(Icons.dark_mode_rounded),
        name: 'Theme mode',
        tap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsScreen()));
        },
      ),
      DrawerListTile(
          icon: const Icon(Icons.logout),
          name: 'Logout',
          tap: () {
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Authentication>(context, listen: false).logout();
          })
    ]));
  }
}
