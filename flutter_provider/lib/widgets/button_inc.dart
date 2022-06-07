import 'package:flutter/material.dart';
import 'package:flutter_provider/providers/counter_model.dart';
import 'package:provider/provider.dart';

class ButtonInc extends StatelessWidget {
  const ButtonInc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {
      Provider.of<CounterModel>(context, listen: false).addToBit0();
    }, child: const Text('Inc'));
  }

}