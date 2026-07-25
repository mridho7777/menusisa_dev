import 'package:flutter/material.dart';
import '../repositories/payment_monitoring_repository.dart';

/// Provider untuk Payment Monitoring
class PaymentProvider extends ChangeNotifier {
  final PaymentMonitoringRepository _repository = PaymentMonitoringRepository();

  List<Map<String, dynamic>> _payments = [];
  List<Map<String, dynamic>> get payments => _payments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _statusFilter = 'Semua';
  String get statusFilter => _statusFilter;

  String _methodFilter = 'Semua';
  String get methodFilter => _methodFilter;

  PaymentProvider() {
    loadPayments();
  }

  Future<void> loadPayments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _payments = await _repository.getAll();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ PaymentProvider loadPayments error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPayment(Map<String, dynamic> payment) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.create(payment);
      _payments.insert(0, result);
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ PaymentProvider addPayment error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePayment(String id, Map<String, dynamic> payment) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.update(id, payment);
      final index = _payments.indexWhere((p) => p['id'] == id);
      if (index != -1) {
        _payments[index] = result;
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ PaymentProvider updatePayment error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePayment(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.delete(id);
      _payments.removeWhere((p) => p['id'] == id);
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ PaymentProvider deletePayment error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setMethodFilter(String method) {
    _methodFilter = method;
    notifyListeners();
  }

  List<Map<String, dynamic>> get filteredPayments {
    var filtered = List<Map<String, dynamic>>.from(_payments);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((p) {
        return (p['id']?.toString().toLowerCase().contains(query) ?? false) ||
            (p['order_id']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (_statusFilter != 'Semua') {
      filtered = filtered.where((p) => p['status'] == _statusFilter).toList();
    }

    if (_methodFilter != 'Semua') {
      filtered = filtered.where((p) => p['payment_method'] == _methodFilter).toList();
    }

    return filtered;
  }

  /// Method untuk verifikasi pembayaran
  Future<bool> verifyPayment(String id, String verifiedBy) async {
    try {
      final updated = await _repository.verifyPayment(id, verifiedBy);
      final index = _payments.indexWhere((p) => p['id'] == id);
      if (index != -1) {
        _payments[index] = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ PaymentProvider verifyPayment error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Method untuk reject pembayaran
  Future<bool> rejectPayment(String id, String reason) async {
    try {
      final updated = await _repository.rejectPayment(id, reason);
      final index = _payments.indexWhere((p) => p['id'] == id);
      if (index != -1) {
        _payments[index] = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ PaymentProvider rejectPayment error: $e');
      notifyListeners();
      return false;
    }
  }

  // Metrics
  int get totalPayments => _payments.length;
  int get pendingPayments => _payments.where((p) => p['status'] == 'pending').length;
  int get verifiedPayments => _payments.where((p) => p['status'] == 'verified').length;
  int get failedPayments => _payments.where((p) => p['status'] == 'failed').length;
}

