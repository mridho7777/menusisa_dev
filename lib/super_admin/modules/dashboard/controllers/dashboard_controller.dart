import 'package:flutter/material.dart';
import '../../../repositories/analytics_repository.dart';
import '../../../repositories/metrics_repository.dart';

class DashboardController extends ChangeNotifier {
  final AnalyticsRepository _analyticsRepo = AnalyticsRepository();
  final MetricsRepository _metricsRepo = MetricsRepository();

  String globalFilter = 'Hari Ini';
  String chartFilter = '30 Hari Terakhir';
  String selectedTransactionId = '#ORD-20250520-001';

  Map<String, dynamic> _dashboardData = {};
  Map<String, dynamic> get dashboardData => _dashboardData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  DashboardController() {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _dashboardData = await _analyticsRepo.getAggregatedDashboard();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ DashboardController loadDashboardData error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, int>> getMerchantMetrics() async {
    return await _metricsRepo.getMerchantMetrics();
  }

  Future<Map<String, int>> getProductMetrics() async {
    return await _metricsRepo.getProductApprovalMetrics();
  }

  Future<Map<String, int>> getTransactionMetrics() async {
    return await _metricsRepo.getTransactionMetrics();
  }

  Future<Map<String, int>> getPaymentMetrics() async {
    return await _metricsRepo.getPaymentMetrics();
  }

  Future<Map<String, int>> getCustomerMetrics() async {
    return await _metricsRepo.getCustomerMetrics();
  }

  void setGlobalFilter(String value) {
    globalFilter = value;
    notifyListeners();
    loadDashboardData();
  }

  void setChartFilter(String value) {
    chartFilter = value;
    notifyListeners();
  }

  void setSelectedTransaction(String id) {
    selectedTransactionId = id;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadDashboardData();
  }
}

