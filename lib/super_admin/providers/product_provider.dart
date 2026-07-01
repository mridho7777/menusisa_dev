import 'package:flutter/material.dart';
import '../core/services/data_sync_service.dart';
import '../core/services/local_storage_service.dart';

/// Provider untuk Product Management
class ProductProvider extends ChangeNotifier {
  final _syncService = DataSyncService.instance;
  
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

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _syncService.fetchData(
        StorageKeys.products,
        'products', // Supabase table name
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Map<String, dynamic> product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _syncService.addItem(
        StorageKeys.products,
        'products',
        product,
      );
      if (result != null) {
        _products.insert(0, result);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _syncService.updateItem(
        StorageKeys.products,
        'products',
        id,
        product,
      );
      if (result != null) {
        final index = _products.indexWhere((p) => p['id'] == id);
        if (index != -1) {
          _products[index] = result;
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _syncService.deleteItem(
        StorageKeys.products,
        'products',
        id,
      );
      if (success) {
        _products.removeWhere((p) => p['id'] == id);
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

  void setCategoryFilter(String category) {
    _categoryFilter = category;
    notifyListeners();
  }

  List<Map<String, dynamic>> get filteredProducts {
    var filtered = List<Map<String, dynamic>>.from(_products);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((p) {
        return (p['name']?.toString().toLowerCase().contains(query) ?? false) ||
            (p['description']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (_categoryFilter != 'Semua') {
      filtered = filtered.where((p) => p['category'] == _categoryFilter).toList();
    }

    return filtered;
  }
}
