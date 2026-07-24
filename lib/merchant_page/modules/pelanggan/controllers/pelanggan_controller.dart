import 'package:flutter/material.dart';

import '../models/pelanggan_model.dart';
import '../services/pelanggan_service.dart';

class MerchantPelangganController extends ChangeNotifier {
  final PelangganService _service = PelangganService();
  final TextEditingController searchController = TextEditingController();

  List<PelangganModel> _allData = [];
  bool _isLoading = false;
  bool _showCustomerList = false;
  int _currentPage = 1;
  final int _rowsPerPage = 5;
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  bool get showCustomerList => _showCustomerList;
  int get currentPage => _currentPage;
  int get rowsPerPage => _rowsPerPage;

  List<PelangganModel> get filteredData {
    if (_searchQuery.trim().isEmpty) return _allData;
    final query = _searchQuery.toLowerCase();
    return _allData.where((item) => item.name.toLowerCase().contains(query) || item.email.toLowerCase().contains(query) || item.phone.toLowerCase().contains(query)).toList();
  }

  int get totalItems => filteredData.length;
  int get totalPages => totalItems == 0 ? 1 : ((totalItems - 1) ~/ _rowsPerPage) + 1;

  List<PelangganModel> get paginatedData {
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    if (startIndex >= filteredData.length) return [];
    final endIndex = (startIndex + _rowsPerPage).clamp(0, filteredData.length);
    return filteredData.sublist(startIndex, endIndex);
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allData = await _service.fetchPelangganData();
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  void openCustomerList() { _showCustomerList = true; notifyListeners(); }
  void backToOverview() { _showCustomerList = false; notifyListeners(); }
  void updateSearch(String value) { _searchQuery = value; _currentPage = 1; notifyListeners(); }
  void goToPage(int page) { if (page < 1 || page > totalPages) return; _currentPage = page; notifyListeners(); }
  void nextPage() => goToPage(_currentPage + 1);
  void previousPage() => goToPage(_currentPage - 1);

  Future<void> updateCustomer(PelangganModel updatedCustomer) async {
    final index = _allData.indexWhere((c) => c.id == updatedCustomer.id);
    if (index != -1) {
      _allData = List<PelangganModel>.from(_allData);
      _allData[index] = updatedCustomer;
      notifyListeners();
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    _allData = List<PelangganModel>.from(_allData)..removeWhere((c) => c.id == customerId);
    if (_currentPage > totalPages && totalPages > 0) _currentPage = totalPages;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
