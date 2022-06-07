import 'package:flutter/material.dart';
import 'package:route_demo/screens/custom_dialog.dart';
import 'package:route_demo/screens/second_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SecondScreen()),
                ),*/
                Navigator.pushNamed(context, '/xxx', arguments: 'test')
              },
              child: const Text('Navigate to second screen'),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SecondScreen(title: 'local')),
                ),
              },
              child: const Text('Navigate to second screen with param'),
            ),
            ElevatedButton(
              onPressed: () => {Navigator.pushNamed(context, '/third')},
              child: const Text('Navigate to third screen'),
            ),
            const CustomButton(),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          _navigateAndDisplayDialog(context);
        },
        child: const Text('Launch dialog'));
  }

  _navigateAndDisplayDialog(BuildContext context) async {
    final result = await Navigator.push(context, MaterialPageRoute(
      builder: (_)=> const CustomDialog(
        title: 'Dialog', 
        label: 'Do you agree?', 
        button1Label: 'Yes', 
        button2Label: 'No',)));
    
    Scaffold.of(context)
    // ignore: deprecated_member_use
    ..removeCurrentSnackBar()
    // ignore: deprecated_member_use
    ..showSnackBar(SnackBar(content: Text(result ?? 'nothing selected')));
  }
}
