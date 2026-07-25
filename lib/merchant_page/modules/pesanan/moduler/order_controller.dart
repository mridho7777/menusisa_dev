import 'package:flutter/material.dart';
import 'order_model.dart';
import 'order_service.dart';

class OrderController extends ChangeNotifier {
  final OrderService _service = OrderService();

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  int _selectedTabIndex = 0;
  String _searchQuery = '';
  bool _sortNewestFirst = true;
  String _selectedFilter = 'Semua';

  List<String> get tabs => const ['Semua', 'Baru', 'Diproses', 'Siap Diambil', 'Selesai', 'Dibatalkan'];
  bool get isLoading => _isLoading;
  int get selectedTabIndex => _selectedTabIndex;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  List<OrderModel> get orders => _orders;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();
    _orders = await _service.fetchOrders();
    _isLoading = false;
    notifyListeners();
  }

  void setTabIndex(int index) { _selectedTabIndex = index; notifyListeners(); }
  void setSearchQuery(String query) { _searchQuery = query; notifyListeners(); }
  void setFilter(String filter) { _selectedFilter = filter; notifyListeners(); }
  void toggleSort() { _sortNewestFirst = !_sortNewestFirst; notifyListeners(); }

  List<OrderModel> get filteredOrders {
    Iterable<OrderModel> result = _orders;
    if (_selectedTabIndex > 0) {
      final tabStatus = OrderStatus.values[_selectedTabIndex - 1];
      result = result.where((order) => order.status == tabStatus);
    }
    if (_selectedFilter != 'Semua') {
      result = result.where((order) => order.status.displayName == _selectedFilter);
    }
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((order) => order.orderNumber.toLowerCase().contains(query) || order.customerName.toLowerCase().contains(query) || order.customerPhone.toLowerCase().contains(query));
    }
    final list = result.toList();
    list.sort((a, b) => _sortNewestFirst ? b.orderDate.compareTo(a.orderDate) : a.orderDate.compareTo(b.orderDate));
    return list;
  }

  Future<void> updateStatus(String id, OrderStatus status) async {
    final ok = await _service.updateOrderStatus(id, status);
    if (ok) await loadOrders();
  }

  Future<void> refresh() => loadOrders();
}
