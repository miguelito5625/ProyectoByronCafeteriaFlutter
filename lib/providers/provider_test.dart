import 'package:flutter/foundation.dart';

class TestProvider with ChangeNotifier{
  int _contador = 0;

  int get contador => _contador;

  set contador(int value){
    _contador = value;
  }

  void incrementar(){
    _contador++;
    notifyListeners();
  }

}