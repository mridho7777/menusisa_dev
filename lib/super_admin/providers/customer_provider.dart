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
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCustomer(CustomerRecord customer) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newCustomer = await _repository.create(customer);
      _customers.insert(0, newCustomer);
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCustomer(String id, CustomerRecord customer) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _repository.update(id, customer);
      final index = _customers.indexWhere((c) => c.id == id);
      if (index != -1) {
        _customers[index] = updated;
        _applyFilters();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCustomer(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.delete(id);
      _customers.removeWhere((c) => c.id == id);
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setStatusFilter(String status) {
    _statusFilter = status;
    _applyFilters();
  }

  void _applyFilters() {
    // This will be used to filter the displayed list
    notifyListeners();
  }

  List<CustomerRecord> get filteredCustomers {
    var filtered = List<CustomerRecord>.from(_customers);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((c) {
        return c.name.toLowerCase().contains(query) ||
            c.email.toLowerCase().contains(query) ||
            c.phone.contains(query);
      }).toList();
    }

    // Apply status filter
    if (_statusFilter != 'Semua') {
      filtered = filtered.where((c) => c.accountStatus == _statusFilter).toList();
    }

    return filtered;
  }
}
