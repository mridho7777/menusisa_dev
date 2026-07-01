import 'package:flutter/material.dart';
import '../core/services/data_sync_service.dart';
import '../core/services/local_storage_service.dart';

/// Provider untuk Notifications
class NotificationsProvider extends ChangeNotifier {
  final _syncService = DataSyncService.instance;
  
  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _typeFilter = 'Semua';
  String get typeFilter => _typeFilter;

  bool _showOnlyUnread = false;
  bool get showOnlyUnread => _showOnlyUnread;

  NotificationsProvider() {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await _syncService.fetchData(
        StorageKeys.notifications,
        'notifications',
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNotification(Map<String, dynamic> notification) async {
    try {
      final notificationWithTimestamp = {
        ...notification,
        'created_at': DateTime.now().toIso8601String(),
        'is_read': false,
      };
      
      final result = await _syncService.addItem(
        StorageKeys.notifications,
        'notifications',
        notificationWithTimestamp,
      );
      if (result != null) {
        _notifications.insert(0, result);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      final updated = Map<String, dynamic>.from(_notifications[index]);
      updated['is_read'] = true;
      updated['read_at'] = DateTime.now().toIso8601String();
      
      final result = await _syncService.updateItem(
        StorageKeys.notifications,
        'notifications',
        id,
        updated,
      );
      
      if (result != null) {
        _notifications[index] = result;
        notifyListeners();
      }
    }
  }

  Future<void> markAllAsRead() async {
    for (var notification in _notifications) {
      if (notification['is_read'] != true) {
        await markAsRead(notification['id']);
      }
    }
  }

  Future<void> deleteNotification(String id) async {
    final success = await _syncService.deleteItem(
      StorageKeys.notifications,
      'notifications',
      id,
    );
    
    if (success) {
      _notifications.removeWhere((n) => n['id'] == id);
      notifyListeners();
    }
  }

  void setTypeFilter(String type) {
    _typeFilter = type;
    notifyListeners();
  }

  void setShowOnlyUnread(bool value) {
    _showOnlyUnread = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> get filteredNotifications {
    var filtered = List<Map<String, dynamic>>.from(_notifications);

    if (_showOnlyUnread) {
      filtered = filtered.where((n) => n['is_read'] != true).toList();
    }

    if (_typeFilter != 'Semua') {
      filtered = filtered.where((n) => n['type'] == _typeFilter).toList();
    }

    return filtered;
  }

  int get unreadCount {
    return _notifications.where((n) => n['is_read'] != true).length;
  }

  List<String> get uniqueTypes {
    final types = _notifications.map((n) => n['type']?.toString() ?? 'Unknown').toSet().toList();
    types.sort();
    return ['Semua', ...types];
  }
}
