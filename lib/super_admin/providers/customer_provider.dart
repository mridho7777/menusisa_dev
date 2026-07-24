import 'package:flutter/material.dart';
import '../modules/customer_management/models/customer_models.dart';
import '../repositories/customer_repository.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerRepository _repository = CustomerRepository();

  List<CustomerRecord> _customers = [];
  List<CustomerRecord> get customers => _customers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _statusFilter = 'Semua';
  String get statusFilter => _statusFilter;

  CustomerProvider() {
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _customers = await _repository.getAll();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ CustomerProvider loadCustomers error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCustomer(String id, String fullName, String phone) async {
    try {
      final updated = await _repository.updateCustomer(id, fullName, phone);
      final index = _customers.indexWhere((c) => c.id == id);
      if (index != -1) {
        _customers[index] = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ updateCustomer error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCustomer(String id) async {
    try {
      await _repository.delete(id);
      _customers.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ deleteCustomer error: $e');
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

  List<CustomerRecord> get filteredCustomers {
    var filtered = List<CustomerRecord>.from(_customers);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((c) {
        return c.name.toLowerCase().contains(query) ||
            c.email.toLowerCase().contains(query) ||
            c.phone.contains(query);
      }).toList();
    }

    if (_statusFilter != 'Semua') {
      filtered = filtered
          .where((c) => c.accountStatus == _statusFilter)
          .toList();
    }

    return filtered;
  }

  // Counters for metrics
  int get totalCustomers => _customers.length;
  int get activeCustomers =>
      _customers.where((c) => c.accountStatus == 'Aktif').length;
}
