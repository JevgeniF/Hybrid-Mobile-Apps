import 'package:flutter/material.dart';
import 'package:flutter_provider/providers/counter_model.dart';
import 'package:provider/provider.dart';

class ButtonDec extends StatelessWidget {
  const ButtonDec({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {
      Provider.of<CounterModel>(context, listen: false).decFromBit0();
    }, child: const Text('Dec'));
  }

}