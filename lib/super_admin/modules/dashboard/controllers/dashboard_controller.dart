import 'package:flutter/material.dart';

class DashboardController extends ChangeNotifier {
  String globalFilter = 'Hari Ini';
  String chartFilter = '30 Hari Terakhir';
  String selectedTransactionId = '#ORD-20250520-001';

  void setGlobalFilter(String value) {
    globalFilter = value;
    notifyListeners();
  }

  void setChartFilter(String value) {
    chartFilter = value;
    notifyListeners();
  }

  void setSelectedTransaction(String id) {
    selectedTransactionId = id;
    notifyListeners();
  }
}
