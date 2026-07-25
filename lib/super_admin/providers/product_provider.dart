import 'package:flutter/material.dart';
import '../repositories/product_repository.dart';

/// Provider untuk Product Management
class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _categoryFilter = 'Semua';
  String get categoryFilter => _categoryFilter;

  String _statusFilter = 'Semua';
  String get statusFilter => _statusFilter;

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _repository.getAll();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ ProductProvider loadProducts error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(Map<String, dynamic> product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.create(product);
      _products.insert(0, result);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ ProductProvider addProduct error: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  Future<bool> updateProduct(String id, Map<String, dynamic> product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.update(id, product);
      final index = _products.indexWhere((p) => p['id'] == id);
      if (index != -1) {
        _products[index] = result;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ ProductProvider updateProduct error: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.delete(id);
      _products.removeWhere((p) => p['id'] == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ ProductProvider deleteProduct error: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  Future<bool> approveProduct(String id) async {
    try {
      final updated = await _repository.approve(id);
      final index = _products.indexWhere((p) => p['id'] == id);
      if (index != -1) {
        _products[index] = updated;
      }
      await loadProducts();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('? ProductProvider approveProduct error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> publishProduct(String id) async {
    try {
      final updated = await _repository.publishToCustomer(id);
      final index = _products.indexWhere((p) => p['id'] == id);
      if (index != -1) {
        _products[index] = updated;
      }
      await loadProducts();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('? ProductProvider publishProduct error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> rejectProduct(String id, String reason) async {
    try {
      final updated = await _repository.reject(id, reason);
      final index = _products.indexWhere((p) => p['id'] == id);
      if (index != -1) {
        _products[index] = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ ProductProvider rejectProduct error: $e');
      notifyListeners();
      return false;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners();
  }

  List<Map<String, dynamic>> get filteredProducts {
    var filtered = List<Map<String, dynamic>>.from(_products);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((p) {
        return (p['name']?.toString().toLowerCase().contains(query) ?? false) ||
            (p['description']?.toString().toLowerCase().contains(query) ??
                false) ||
            (p['product_code']?.toString().toLowerCase().contains(query) ??
                false);
      }).toList();
    }

    if (_categoryFilter != 'Semua') {
      filtered = filtered
          .where((p) => p['category_id'] == _categoryFilter)
          .toList();
    }

    if (_statusFilter != 'Semua') {
      filtered = filtered
          .where((p) => p['approval_status'] == _statusFilter)
          .toList();
    }

    return filtered;
  }

  // Metrics
  int get totalProducts => _products.length;
  int get pendingProducts =>
      _products.where((p) => p['approval_status'] == 'pending').length;
  int get approvedProducts =>
      _products.where((p) => p['approval_status'] == 'approved').length;
  int get rejectedProducts =>
      _products.where((p) => p['approval_status'] == 'rejected').length;
  int get activeProducts =>
      _products.where((p) => p['is_active'] == true).length;
}
