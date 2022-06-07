import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Counter value: ' + _count.toString()),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _count++;
              });
            },
            child: const Text('Add 1'))
      ],
    );
  }
}
