import 'package:flutter/material.dart';
import 'package:route_demo/screens/home_screen.dart';

import 'screens/second_screen.dart';
import 'screens/third_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation',
    initialRoute: '/',
    //match any route not found in rotes table
    onGenerateRoute: (settings) {
      final String title = settings.arguments.toString();
      return MaterialPageRoute(builder: (_) => 
        SecondScreen(title: title + ' ' + settings.name.toString())
      );
    },
    routes: {
      "/": (_) => const HomeScreen(),
      "/second": (_) => const SecondScreen(
            title: 'fixed',
          ),
      "/third": (_) => const ThirdScreen(),
    },
    //do not declare Home with initial route.
    //home: HomeScreen(),
  ));
}
