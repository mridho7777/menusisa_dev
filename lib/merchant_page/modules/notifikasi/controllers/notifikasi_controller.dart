import 'package:flutter/material.dart';

import '../models/notifikasi_model.dart';
import '../services/notifikasi_service.dart';

class MerchantNotifikasiController extends ChangeNotifier {
  final NotifikasiService _service = NotifikasiService();
  final TextEditingController searchController = TextEditingController();

  List<NotifikasiModel> _allData = [];
  final Set<String> _selectedIds = {};
  bool _isLoading = false;
  bool _showListView = true;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _rowsPerPage = 5;

  bool get isLoading => _isLoading;
  bool get showListView => _showListView;
  int get currentPage => _currentPage;
  int get rowsPerPage => _rowsPerPage;
  List<String> get selectedIds => _selectedIds.toList();

  List<NotifikasiModel> get filteredData {
    if (_searchQuery.trim().isEmpty) return _allData;
    final query = _searchQuery.toLowerCase();
    return _allData.where((item) => item.title.toLowerCase().contains(query) || item.description.toLowerCase().contains(query)).toList();
  }

  List<NotifikasiModel> get visibleData {
    final start = (_currentPage - 1) * _rowsPerPage;
    if (start >= filteredData.length) return [];
    final end = (start + _rowsPerPage).clamp(0, filteredData.length);
    return filteredData.sublist(start, end);
  }

  int get totalData => filteredData.length;
  int get totalPages => totalData == 0 ? 1 : ((totalData - 1) ~/ _rowsPerPage) + 1;
  bool get isAllSelected => visibleData.isNotEmpty && visibleData.every((item) => _selectedIds.contains(item.id));
  bool get isIndeterminate => _selectedIds.any((id) => visibleData.any((item) => item.id == id)) && !isAllSelected;
  int get unreadCount => _allData.where((item) => !item.isRead).length;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    _allData = await _service.fetchNotifikasiData();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNotification({required String title, required String description, required String iconKey}) async {
    final newNotif = NotifikasiModel(
      id: 'N-',
      title: title,
      description: description,
      timeLabel: 'Baru saja',
      iconKey: iconKey,
      isRead: false,
    );
    _allData.insert(0, newNotif);
    await _service.addNotification(newNotif);
    notifyListeners();
  }

  void showNotificationList() {
    _showListView = true;
    _resetPage();
    notifyListeners();
  }

  void backToIntro() {
    _showListView = false;
    notifyListeners();
  }

  void updateSearch(String value) {
    _searchQuery = value;
    _resetPage();
    notifyListeners();
  }

  void toggleSelection(String id, bool selected) {
    if (selected) {
      _selectedIds.add(id);
    } else {
      _selectedIds.remove(id);
    }
    notifyListeners();
  }

  void toggleSelectAll(bool selected) {
    for (final item in visibleData) {
      if (selected) {
        _selectedIds.add(item.id);
      } else {
        _selectedIds.remove(item.id);
      }
    }
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    _allData = _allData.map((item) => item.copyWith(isRead: true)).toList();
    for (final item in _allData) {
      await _service.updateNotification(item);
    }
    notifyListeners();
  }

  Future<void> markRead(String id) => markAsRead(id);

  Future<void> markAsRead(String id) async {
    final index = _allData.indexWhere((item) => item.id == id);
    if (index != -1) {
      _allData[index] = _allData[index].copyWith(isRead: true);
      await _service.updateNotification(_allData[index]);
      notifyListeners();
    }
  }

  Future<void> deleteSelected() async {
    for (final id in _selectedIds.toList()) {
      await _service.deleteNotification(id);
    }
    _selectedIds.clear();
    await loadData();
  }

  Future<void> deleteAll() async {
    for (final item in List<NotifikasiModel>.from(_allData)) {
      await _service.deleteNotification(item.id);
    }
    _allData.clear();
    _selectedIds.clear();
    notifyListeners();
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      notifyListeners();
    }
  }

  void nextPage() {
    if (_currentPage < totalPages) {
      _currentPage++;
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String id) async {
    await _service.deleteNotification(id);
    _allData.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void _resetPage() {
    _currentPage = 1;
  }
}
