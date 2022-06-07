import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final String title;

  // ignore: use_key_in_widget_constructors
  const SecondScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second screen - ' + title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => {Navigator.pushNamed(context, '/third')},
              child: const Text('Third'),
            ),
            ElevatedButton(
              onPressed: () => {Navigator.pop(context)},
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
