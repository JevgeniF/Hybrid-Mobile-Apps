import 'package:flutter/material.dart';
import 'package:flutter_provider/providers/counter_model.dart';
import 'package:provider/provider.dart';

class ButtonReset extends StatelessWidget {
  const ButtonReset({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {
      Provider.of<CounterModel>(context, listen: false).reset();
    }, child: const Text('Reset'));
  }

}