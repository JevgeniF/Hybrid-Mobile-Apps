import 'package:flut_todo/screens/categories/categories_screen.dart';
import 'package:flut_todo/screens/landing/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/provider/authentication.dart';
import 'screens/signin/signin_screen.dart';
import 'screens/signup/signup_screen.dart';
import 'screens/tasks/tasks_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  preferences.then((value) {
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
      create:(BuildContext context) {
        String? theme = value.getString("Theme");
        if (theme == null || theme == '' || theme == "System default") {
          value.setString('Theme', "System default");
          return ThemeNotifier(ThemeMode.system);
        }
        return ThemeNotifier(
          theme == "Dark" ? ThemeMode.dark : ThemeMode.light);
      },
      child: const MyApp(), 
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return ChangeNotifierProvider.value(
      value: Authentication(),
      child: Consumer<Authentication>(
        builder: (ctx, authentication, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flut-ToDo',
            theme: AppTheme().lightTheme,
            darkTheme: AppTheme().darkTheme,
            themeMode: themeNotifier.getThemeMode(),
            home: authentication.isAuth
                ? const CategoriesScreen()
                : FutureBuilder(
                    future: authentication.reSignIn(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? const LandingScreen()
                            : const LandingScreen(),
                  ),
            routes: {
              //'/': (_) => const LandingScreen(),
              SignInScreen.routeName: (_) => const SignInScreen(),
              SignUpScreen.routeName: (_) => const SignUpScreen(),
              TasksScreen.routeName: (_) => const TasksScreen(),
              //CategoriesScreen.routeName: (_) => const CategoriesScreen(),
            }),
      ),
    );
  }
}
