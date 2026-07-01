import 'package:flutter/material.dart';
import '../core/services/data_sync_service.dart';
import '../core/services/local_storage_service.dart';

/// Provider untuk Payment Monitoring
class PaymentProvider extends ChangeNotifier {
  final _syncService = DataSyncService.instance;
  
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
      _payments = await _syncService.fetchData(
        StorageKeys.payments,
        'payments',
      );
    } catch (e) {
      _error = e.toString();
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
      final result = await _syncService.addItem(
        StorageKeys.payments,
        'payments',
        payment,
      );
      if (result != null) {
        _payments.insert(0, result);
      }
    } catch (e) {
      _error = e.toString();
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
      final result = await _syncService.updateItem(
        StorageKeys.payments,
        'payments',
        id,
        payment,
      );
      if (result != null) {
        final index = _payments.indexWhere((p) => p['id'] == id);
        if (index != -1) {
          _payments[index] = result;
        }
      }
    } catch (e) {
      _error = e.toString();
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
      final success = await _syncService.deleteItem(
        StorageKeys.payments,
        'payments',
        id,
      );
      if (success) {
        _payments.removeWhere((p) => p['id'] == id);
      }
    } catch (e) {
      _error = e.toString();
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
            (p['transaction_id']?.toString().toLowerCase().contains(query) ?? false) ||
            (p['merchant_name']?.toString().toLowerCase().contains(query) ?? false);
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

  // Method untuk verifikasi pembayaran
  Future<void> verifyPayment(String id) async {
    final index = _payments.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      final updated = Map<String, dynamic>.from(_payments[index]);
      updated['status'] = 'Verified';
      updated['verified_at'] = DateTime.now().toIso8601String();
      await updatePayment(id, updated);
    }
  }

  // Method untuk refund pembayaran
  Future<void> refundPayment(String id, String reason) async {
    final index = _payments.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      final updated = Map<String, dynamic>.from(_payments[index]);
      updated['status'] = 'Refunded';
      updated['refund_reason'] = reason;
      updated['refunded_at'] = DateTime.now().toIso8601String();
      await updatePayment(id, updated);
    }
  }
}
