import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_provider/providers/counter_model.dart';
import 'package:flutter_provider/widgets/button_dec.dart';
import 'package:flutter_provider/widgets/button_inc.dart';
import 'package:flutter_provider/widgets/button_reset.dart';
import 'package:flutter_provider/widgets/single_bit.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CounterModel>(
      create: (_) => CounterModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bit Counter'),
        ),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SingleBit(bitNo: 2),
                SingleBit(bitNo: 1),
                SingleBit(bitNo: 0)
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ButtonDec(),
                ButtonInc(),
              ], 
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ButtonReset(),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
