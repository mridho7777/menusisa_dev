import 'package:flutter/material.dart';
import '../repositories/activity_log_repository.dart';

/// Provider untuk Activity Logs
class ActivityLogProvider extends ChangeNotifier {
  final ActivityLogRepository _repository = ActivityLogRepository();

  List<Map<String, dynamic>> _logs = [];
  List<Map<String, dynamic>> get logs => _logs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _actionFilter = 'Semua';
  String get actionFilter => _actionFilter;

  String _userFilter = 'Semua';
  String get userFilter => _userFilter;

  ActivityLogProvider() {
    loadLogs();
  }

  Future<void> loadLogs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _logs = await _repository.query(
        orderBy: 'created_at',
        ascending: false,
      );
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ ActivityLogProvider loadLogs error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLog(Map<String, dynamic> log) async {
    try {
      final logWithTimestamp = {
        ...log,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      final result = await _repository.create(logWithTimestamp);
      _logs.insert(0, result);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ ActivityLogProvider addLog error: $e');
      notifyListeners();
    }
  }

  // Method untuk log aktivitas tertentu
  Future<void> logAction(String userId, String userName, String module, String activityType, String description) async {
    await addLog({
      'user_id': userId,
      'user_name': userName,
      'module': module,
      'activity_type': activityType,
      'description': description,
      'ip_address': '0.0.0.0', // TODO: Get real IP
      'device': 'Web Browser',
      'location': 'Unknown',
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setActionFilter(String action) {
    _actionFilter = action;
    notifyListeners();
  }

  void setUserFilter(String user) {
    _userFilter = user;
    notifyListeners();
  }

  List<Map<String, dynamic>> get filteredLogs {
    var filtered = List<Map<String, dynamic>>.from(_logs);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((log) {
        return (log['user_name']?.toString().toLowerCase().contains(query) ?? false) ||
            (log['activity_type']?.toString().toLowerCase().contains(query) ?? false) ||
            (log['description']?.toString().toLowerCase().contains(query) ?? false) ||
            (log['module']?.toString().toLowerCase().contains(query) ?? false) ||
            (log['ip_address']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (_actionFilter != 'Semua') {
      filtered = filtered.where((log) => log['activity_type'] == _actionFilter).toList();
    }

    if (_userFilter != 'Semua') {
      filtered = filtered.where((log) => log['user_name'] == _userFilter).toList();
    }

    return filtered;
  }

  // Get unique users for filter
  List<String> get uniqueUsers {
    final users = _logs.map((log) => log['user_name']?.toString() ?? 'Unknown').toSet().toList();
    users.sort();
    return ['Semua', ...users];
  }

  // Get unique actions for filter
  List<String> get uniqueActions {
    final actions = _logs.map((log) => log['activity_type']?.toString() ?? 'Unknown').toSet().toList();
    actions.sort();
    return ['Semua', ...actions];
  }

  // Metrics
  int get totalActivities => _logs.length;
  
  int get todayActivities {
    final today = DateTime.now();
    return _logs.where((log) {
      final createdAt = DateTime.tryParse(log['created_at']?.toString() ?? '');
      if (createdAt == null) return false;
      return createdAt.year == today.year && 
             createdAt.month == today.month && 
             createdAt.day == today.day;
    }).length;
  }

  int get uniqueUsersToday {
    final today = DateTime.now();
    final todayLogs = _logs.where((log) {
      final createdAt = DateTime.tryParse(log['created_at']?.toString() ?? '');
      if (createdAt == null) return false;
      return createdAt.year == today.year && 
             createdAt.month == today.month && 
             createdAt.day == today.day;
    });
    return todayLogs.map((log) => log['user_id']).toSet().length;
  }

  int countByActivityType(String type) {
    return _logs.where((log) => log['activity_type'] == type).length;
  }
}

