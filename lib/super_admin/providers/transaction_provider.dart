import 'package:flutter/material.dart';
import '../core/services/data_sync_service.dart';
import '../core/services/local_storage_service.dart';

/// Provider untuk Transaction Management
class TransactionProvider extends ChangeNotifier {
  final _syncService = DataSyncService.instance;
  
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> get transactions => _transactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _statusFilter = 'Semua';
  String get statusFilter => _statusFilter;

  TransactionProvider() {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _transactions = await _syncService.fetchData(
        StorageKeys.transactions,
        'transactions',
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(Map<String, dynamic> transaction) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _syncService.addItem(
        StorageKeys.transactions,
        'transactions',
        transaction,
      );
      if (result != null) {
        _transactions.insert(0, result);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTransaction(String id, Map<String, dynamic> transaction) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _syncService.updateItem(
        StorageKeys.transactions,
        'transactions',
        id,
        transaction,
      );
      if (result != null) {
        final index = _transactions.indexWhere((t) => t['id'] == id);
        if (index != -1) {
          _transactions[index] = result;
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _syncService.deleteItem(
        StorageKeys.transactions,
        'transactions',
        id,
      );
      if (success) {
        _transactions.removeWhere((t) => t['id'] == id);
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

  List<Map<String, dynamic>> get filteredTransactions {
    var filtered = List<Map<String, dynamic>>.from(_transactions);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((t) {
        return (t['id']?.toString().toLowerCase().contains(query) ?? false) ||
            (t['customer_name']?.toString().toLowerCase().contains(query) ?? false) ||
            (t['merchant_name']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (_statusFilter != 'Semua') {
      filtered = filtered.where((t) => t['status'] == _statusFilter).toList();
    }

    return filtered;
  }

  // Method untuk update status transaksi
  Future<void> updateTransactionStatus(String id, String newStatus) async {
    final index = _transactions.indexWhere((t) => t['id'] == id);
    if (index != -1) {
      final updated = Map<String, dynamic>.from(_transactions[index]);
      updated['status'] = newStatus;
      await updateTransaction(id, updated);
    }
  }
}
