import 'package:flutter/material.dart';
import '../core/services/data_sync_service.dart';
import '../core/services/local_storage_service.dart';

/// Provider untuk Activity Logs
class ActivityLogProvider extends ChangeNotifier {
  final _syncService = DataSyncService.instance;
  
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
      _logs = await _syncService.fetchData(
        StorageKeys.activityLogs,
        'activity_logs',
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLog(Map<String, dynamic> log) async {
    try {
      final logWithTimestamp = {
        ...log,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      final result = await _syncService.addItem(
        StorageKeys.activityLogs,
        'activity_logs',
        logWithTimestamp,
      );
      if (result != null) {
        _logs.insert(0, result);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Method untuk log aktivitas tertentu
  Future<void> logAction(String userId, String userName, String action, String description) async {
    await addLog({
      'id': 'log_',
      'user_id': userId,
      'user_name': userName,
      'action': action,
      'description': description,
      'timestamp': DateTime.now().toIso8601String(),
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
            (log['action']?.toString().toLowerCase().contains(query) ?? false) ||
            (log['description']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (_actionFilter != 'Semua') {
      filtered = filtered.where((log) => log['action'] == _actionFilter).toList();
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
    final actions = _logs.map((log) => log['action']?.toString() ?? 'Unknown').toSet().toList();
    actions.sort();
    return ['Semua', ...actions];
  }
}
