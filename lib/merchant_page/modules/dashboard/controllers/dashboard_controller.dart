import 'package:flutter/material.dart';

import '../models/dashboard_model.dart';
import '../services/dashboard_service.dart';

class MerchantDashboardController extends ChangeNotifier {
  final DashboardService _service = DashboardService();
  DashboardModel? _data;
  bool _isLoading = false;

  DashboardModel? get data => _data;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _data = await _service.fetchDashboardData();
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshData() async => loadData();
}
