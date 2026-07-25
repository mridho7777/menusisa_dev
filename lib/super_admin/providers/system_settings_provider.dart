import 'package:flutter/material.dart';
import '../repositories/system_settings_repository.dart';

/// Provider untuk System Settings
class SystemSettingsProvider extends ChangeNotifier {
  final SystemSettingsRepository _repository = SystemSettingsRepository();
  
  List<Map<String, dynamic>> _settings = [];
  List<Map<String, dynamic>> get settings => _settings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  SystemSettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _settings = await _repository.getAll();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ SystemSettingsProvider loadSettings error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveSetting(String key, Map<String, dynamic> value, {String? description, String? updatedBy}) async {
    try {
      final existing = _settings.where((s) => s['key'] == key).toList();
      if (existing.isEmpty) {
        final result = await _repository.create({
          'key': key,
          'value': value,
          'description': description,
          'updated_by': updatedBy,
        });
        _settings.insert(0, result);
      } else {
        final id = existing.first['id']?.toString() ?? '';
        final result = await _repository.update(id, {
          'key': key,
          'value': value,
          'description': description,
          'updated_by': updatedBy,
        });
        final index = _settings.indexWhere((s) => s['id'] == id);
        if (index != -1) _settings[index] = result;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ SystemSettingsProvider saveSetting error: $e');
      notifyListeners();
    }
  }

  Map<String, dynamic>? getSetting(String key) {
    try {
      return _settings.firstWhere((s) => s['key'] == key);
    } catch (_) {
      return null;
    }
  }
}

