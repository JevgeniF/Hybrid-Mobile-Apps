import 'package:flutter/material.dart';
import 'package:flutter_provider/providers/counter_model.dart';
import 'package:provider/provider.dart';

class SingleBit extends StatelessWidget {
  const SingleBit({
    Key? key,
    required this.bitNo,
  }) : super(key: key);

  final int bitNo;

  @override
  Widget build(BuildContext context) {
    return Consumer<CounterModel>(builder: (context, counterModel, child) {
      return getUI(counterModel);
    });
  }

  Widget getUI(CounterModel counterModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.black87),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          getBitStr(counterModel),
          style: const TextStyle(
              fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  decFromBit(counterModel);
                },
                icon: const Icon(
                  Icons.exposure_minus_1,
                  color: Colors.red,
                )),
            IconButton(
                onPressed: () {
                  addToBit(counterModel);
                },
                icon: const Icon(Icons.exposure_plus_1, color: Colors.red)),
          ],
        )
      ]),
    );
  }

  String getBitStr(CounterModel counterModel) {
    switch (bitNo) {
      case 0:
        return counterModel.bit0 ? '1' : '0';
      case 1:
        return counterModel.bit1 ? '1' : '0';
      case 2:
        return counterModel.bit2 ? '1' : '0';
    }

    return 'X';
  }

  void addToBit(CounterModel counterModel) {
    switch (bitNo) {
      case 0:
        counterModel.addToBit0();
        break;
      case 1:
        counterModel.addToBit1();
        break;
      case 2:
        counterModel.addToBit2();
        break;
    }
  }

  void decFromBit(CounterModel counterModel) {
    switch (bitNo) {
      case 0:
        counterModel.decFromBit0();
        break;
      case 1:
        counterModel.decFromBit1();
        break;
      case 2:
        counterModel.decFromBit2();
        break;
    }
  }
}
