import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../repositories/notification_repository.dart';

/// Provider untuk Notifications
class NotificationsProvider extends ChangeNotifier {
  final NotificationRepository _repository = NotificationRepository();
  final _uuid = const Uuid();
  
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
      _notifications = await _repository.query(
        orderBy: 'created_at',
        ascending: false,
      );
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ NotificationsProvider loadNotifications error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNotification(Map<String, dynamic> notification) async {
    try {
      final id = notification['id'] ?? _uuid.v4();
      
      final notificationWithDefaults = {
        'id': id,
        'title': notification['title'] ?? 'Notifikasi',
        'body': notification['message'] ?? notification['body'] ?? '',
        'type': notification['type'] ?? 'system',
        'reference_id': notification['entity_id'] ?? notification['reference_id'],
        'user_id': notification['user_id'],
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      final result = await _repository.create(notificationWithDefaults);
      _notifications.insert(0, result);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ NotificationsProvider addNotification error: $e');
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      try {
        final updated = Map<String, dynamic>.from(_notifications[index]);
        updated['is_read'] = true;
        updated['read_at'] = DateTime.now().toIso8601String();
        
        final result = await _repository.update(id, updated);
        _notifications[index] = result;
        notifyListeners();
      } catch (e) {
        _error = e.toString();
        debugPrint('❌ NotificationsProvider markAsRead error: $e');
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
    try {
      await _repository.delete(id);
      _notifications.removeWhere((n) => n['id'] == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ NotificationsProvider deleteNotification error: $e');
      notifyListeners();
    }
  }

  Future<void> deleteMultiple(List<String> ids) async {
    for (final id in ids) {
      await deleteNotification(id);
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

  Future<void> clearAll() async {
    try {
      for (var notif in _notifications) {
        await _repository.delete(notif['id']);
      }
      _notifications.clear();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ NotificationsProvider clearAll error: $e');
      notifyListeners();
    }
  }
}

