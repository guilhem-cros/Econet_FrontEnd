import 'package:flutter/foundation.dart';

import 'ecospot.dart';

/// Currently displayed ecospot on a card in the app
class DisplayedEcospot extends ChangeNotifier{
  EcospotModel? _value;

  EcospotModel? get value => _value;

  set value(EcospotModel? newValue) {
    _value = newValue;
    notifyListeners();
  }
}