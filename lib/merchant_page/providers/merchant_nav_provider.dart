import 'package:flutter/material.dart';

class MerchantNavProvider extends ChangeNotifier {
  int _currentIndex = 0;
  bool _isSidebarOpen = true;

  int get currentIndex => _currentIndex;
  bool get isSidebarOpen => _isSidebarOpen;

  final List<String> _titles = [
    'Dashboard',
    'Produk',
    'Pesanan',
    'Pelanggan',
    'Keuangan',
    'Notifikasi',
    'Pengaturan',
    'Profil',
    'Toko Saya',
  ];

  String get activeTitle => _titles[_currentIndex];

  void setIndex(int index) {
    if (index >= 0 && index < _titles.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void toggleSidebar() {
    _isSidebarOpen = !_isSidebarOpen;
    notifyListeners();
  }

  void setSidebarOpen(bool isOpen) {
    _isSidebarOpen = isOpen;
    notifyListeners();
  }
}

