import 'package:flutter/material.dart';
import '../core/services/data_sync_service.dart';
import '../core/services/local_storage_service.dart';

/// Provider untuk System Settings
class SystemSettingsProvider extends ChangeNotifier {
  final _syncService = DataSyncService.instance;
  final _localStorage = LocalStorageService.instance;
  
  Map<String, dynamic> _settings = {};
  Map<String, dynamic> get settings => _settings;

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
      final data = await _localStorage.getData(StorageKeys.systemSettings);
      if (data != null) {
        _settings = Map<String, dynamic>.from(data);
      } else {
        // Default settings
        _settings = {
          'app_name': 'MenuSisa',
          'app_version': '1.0.0',
          'maintenance_mode': false,
          'allow_registration': true,
          'max_upload_size': 5, // MB
          'session_timeout': 30, // minutes
          'enable_notifications': true,
          'enable_email': true,
          'smtp_host': '',
          'smtp_port': 587,
          'smtp_username': '',
          'smtp_password': '',
          'currency': 'IDR',
          'timezone': 'Asia/Jakarta',
          'date_format': 'dd/MM/yyyy',
          'time_format': 'HH:mm',
          'language': 'id',
          'theme': 'light',
          'commission_rate': 5.0, // percent
          'min_withdrawal': 50000,
          'payment_methods': ['Transfer Bank', 'E-Wallet', 'Cash'],
        };
        await saveSettings(_settings);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveSettings(Map<String, dynamic> newSettings) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _localStorage.saveData(StorageKeys.systemSettings, newSettings);
      _settings = newSettings;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSetting(String key, dynamic value) async {
    final updated = Map<String, dynamic>.from(_settings);
    updated[key] = value;
    await saveSettings(updated);
  }

  dynamic getSetting(String key, [dynamic defaultValue]) {
    return _settings[key] ?? defaultValue;
  }

  // Specific setting methods
  bool get maintenanceMode => _settings['maintenance_mode'] ?? false;
  bool get allowRegistration => _settings['allow_registration'] ?? true;
  bool get enableNotifications => _settings['enable_notifications'] ?? true;
  bool get enableEmail => _settings['enable_email'] ?? true;
  
  Future<void> setMaintenanceMode(bool enabled) async {
    await updateSetting('maintenance_mode', enabled);
  }

  Future<void> setAllowRegistration(bool allowed) async {
    await updateSetting('allow_registration', allowed);
  }

  Future<void> setEnableNotifications(bool enabled) async {
    await updateSetting('enable_notifications', enabled);
  }

  Future<void> setEnableEmail(bool enabled) async {
    await updateSetting('enable_email', enabled);
  }

  Future<void> setCommissionRate(double rate) async {
    await updateSetting('commission_rate', rate);
  }

  Future<void> setMinWithdrawal(int amount) async {
    await updateSetting('min_withdrawal', amount);
  }

  Future<void> setSmtpSettings({
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
    final updated = Map<String, dynamic>.from(_settings);
    updated['smtp_host'] = host;
    updated['smtp_port'] = port;
    updated['smtp_username'] = username;
    updated['smtp_password'] = password;
    await saveSettings(updated);
  }

  Future<void> resetToDefaults() async {
    _settings = {
      'app_name': 'MenuSisa',
      'app_version': '1.0.0',
      'maintenance_mode': false,
      'allow_registration': true,
      'max_upload_size': 5,
      'session_timeout': 30,
      'enable_notifications': true,
      'enable_email': true,
      'smtp_host': '',
      'smtp_port': 587,
      'smtp_username': '',
      'smtp_password': '',
      'currency': 'IDR',
      'timezone': 'Asia/Jakarta',
      'date_format': 'dd/MM/yyyy',
      'time_format': 'HH:mm',
      'language': 'id',
      'theme': 'light',
      'commission_rate': 5.0,
      'min_withdrawal': 50000,
      'payment_methods': ['Transfer Bank', 'E-Wallet', 'Cash'],
    };
    await saveSettings(_settings);
  }
}
