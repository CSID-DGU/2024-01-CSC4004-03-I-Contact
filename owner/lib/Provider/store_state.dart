import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Model/menu_model.dart';
import 'package:leftover_is_over_owner/Services/menu_services.dart';
import 'package:leftover_is_over_owner/Services/store_services.dart';

class StoreState extends ChangeNotifier {
  bool _isOpen = false;
  VoidCallback? _refreshSalesCallback;
  VoidCallback? _refreshMenuCallback;
  VoidCallback? _refreshOrderCallback;

  bool get isOpen => _isOpen;

  void toggleStore() async {
    _isOpen = !_isOpen;
    notifyListeners();
    if (!_isOpen) {
      List<Future> futures = [];
      List<MenuModel> menus = await MenuService.getMenuList();
      for (var menu in menus) {
        futures.add(MenuService.setMenu(
            foodId: menu.foodId, capacity: '0', visible: false));
      }
      await Future.wait(futures);
    }
    _callAllCallbacks();
    await StoreService.changeStoreState();
  }

  void setOpen(bool value) {
    _isOpen = value;
    notifyListeners();
    if (!value) {
      _refreshMenuCallback?.call();
    }
  }

  void refreshSalesCallback() async {
    _refreshSalesCallback?.call();
  }

  void setRefreshSalesCallback(VoidCallback callback) {
    _refreshSalesCallback = callback;
  }

  void setRefreshMenuCallback(VoidCallback callback) {
    _refreshMenuCallback = callback;
  }

  void setRefreshOrderCallback(VoidCallback callback) {
    _refreshOrderCallback = callback;
  }

  void _callAllCallbacks() {
    _refreshSalesCallback?.call();
    _refreshMenuCallback?.call();
    _refreshOrderCallback?.call();
  }
}
