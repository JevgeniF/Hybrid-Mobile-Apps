import 'package:flutter/material.dart';

import '../models/counter.dart';

class CounterModel with ChangeNotifier {
  final _counter = Counter();
  bool get bit0 => _counter.bit0;
  bool get bit1 => _counter.bit1;
  bool get bit2 => _counter.bit2;

  void addToBit0() {
    _counter.addToBit0();
    //inform the UI that state has changed - recreate widgets
    notifyListeners();
  }

  void addToBit1() {
    _counter.addToBit1();
    //inform the UI that state has changed - recreate widgets
    notifyListeners();
  }

  void addToBit2() {
    _counter.addToBit2();
    //inform the UI that state has changed - recreate widgets
    notifyListeners();
  }

  void decFromBit0() {
    _counter.decFromBit0();
    //inform the UI that state has changed - recreate widgets
    notifyListeners();
  }

  void decFromBit1() {
    _counter.decFromBit1();
    //inform the UI that state has changed - recreate widgets
    notifyListeners();
  }

  void decFromBit2() {
    _counter.decFromBit2();
    //inform the UI that state has changed - recreate widgets
    notifyListeners();
  }

  void reset() {
    _counter.reset();
    notifyListeners();
  }
}
