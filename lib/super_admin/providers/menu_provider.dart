import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier {
  String _currentRoute = '/dashboard';
  String get currentRoute => _currentRoute;

  bool _sidebarCollapsed = false;
  bool get sidebarCollapsed => _sidebarCollapsed;

  void setRoute(String route) {
    if (_currentRoute == route) return;
    _currentRoute = route;
    notifyListeners();
  }

  void toggleSidebar() {
    _sidebarCollapsed = !_sidebarCollapsed;
    notifyListeners();
  }

  void setSidebarCollapsed(bool value) {
    if (_sidebarCollapsed == value) return;
    _sidebarCollapsed = value;
    notifyListeners();
  }
}
