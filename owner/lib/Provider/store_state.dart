import 'package:flutter/material.dart';

class StoreState extends ChangeNotifier {
  bool _isOpen = false;

  bool get isOpen => _isOpen;
  VoidCallback? _refreshCallback;

  void openStore() {
    _isOpen = true;
    notifyListeners();
  }

  void closeStore() {
    _isOpen = false;
    notifyListeners();
    _refreshCallback?.call(); // closeStore가 호출되면 menuManagePage의 refresh 함수 실행
  }

  void setOpen(bool value) {
    _isOpen = value;
    notifyListeners();
  }

  void setRefreshCallback(VoidCallback callback) {
    _refreshCallback = callback;
  }
}
