import 'package:flutter/material.dart';
import '../modules/transaction_management/models/transaction_models.dart';
import '../repositories/transaction_repository.dart';

/// Provider untuk Transaction Management
class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();
  
  List<TransactionRecord> _transactions = [];
  List<TransactionRecord> get transactions => _transactions;

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
      _transactions = await _repository.getAll();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ TransactionProvider loadTransactions error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTransactionStatus(String id, String newStatus) async {
    try {
      final updated = await _repository.updateStatus(id, newStatus);
      final index = _transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        _transactions[index] = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ TransactionProvider updateStatus error: $e');
      notifyListeners();
      return false;
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

  List<TransactionRecord> get filteredTransactions {
    var filtered = List<TransactionRecord>.from(_transactions);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((t) {
        return t.orderCode.toLowerCase().contains(query) ||
            t.customerName.toLowerCase().contains(query) ||
            t.merchantName.toLowerCase().contains(query);
      }).toList();
    }

    if (_statusFilter != 'Semua') {
      filtered = filtered.where((t) => t.status == _statusFilter).toList();
    }

    return filtered;
  }

  // Metrics
  int get totalTransactions => _transactions.length;
  int get processingTransactions => _transactions.where((t) => t.status == 'processing').length;
  int get completedTransactions => _transactions.where((t) => t.status == 'done').length;
  int get cancelledTransactions => _transactions.where((t) => t.status == 'cancelled').length;
}

