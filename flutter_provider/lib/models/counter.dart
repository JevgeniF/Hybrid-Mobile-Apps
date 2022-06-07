class Counter {
  bool _bit0 = false;
  bool _bit1 = false;
  bool _bit2 = false;

  bool get bit0 => _bit0;
  bool get bit1 => _bit1;
  bool get bit2 => _bit2;

  void addToBit0() {
    _bit0 = !_bit0;
    if (!_bit0) {
      addToBit1();
    }
  }

  void addToBit1() {
    _bit1 = !_bit1;
    if (!_bit1) {
      addToBit2();
    }
  }

  void addToBit2() {
    _bit2 = !_bit2;
  }

  void reset() {
    _bit0 = false;
    _bit1 = false;
    _bit2 = false;
  }

  void decFromBit0() {
    _bit0 = !_bit0;
    if (_bit0) {
      decFromBit1();
    }
  }

  void decFromBit1() {
    _bit1 = !_bit1;
    if (_bit1) {
      decFromBit2();
    }
  }

  void decFromBit2() {
    _bit2 = !_bit2;
  }
}
