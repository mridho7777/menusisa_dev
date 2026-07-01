import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk mengelola penyimpanan data lokal sementara
/// Digunakan sebelum integrasi dengan Supabase
class LocalStorageService {
  static LocalStorageService? _instance;
  static LocalStorageService get instance {
    _instance ??= LocalStorageService._();
    return _instance!;
  }

  LocalStorageService._();

  SharedPreferences? _prefs;

  /// Inisialisasi SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Simpan data sebagai JSON string
  Future<bool> saveData(String key, dynamic data) async {
    await init();
    try {
      final jsonString = jsonEncode(data);
      return await _prefs!.setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }

  /// Ambil data dari storage
  Future<dynamic> getData(String key) async {
    await init();
    try {
      final jsonString = _prefs!.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString);
    } catch (e) {
      return null;
    }
  }

  /// Simpan list data
  Future<bool> saveList(String key, List<Map<String, dynamic>> data) async {
    await init();
    try {
      final jsonString = jsonEncode(data);
      return await _prefs!.setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }

  /// Ambil list data
  Future<List<Map<String, dynamic>>> getList(String key) async {
    await init();
    try {
      final jsonString = _prefs!.getString(key);
      if (jsonString == null) return [];
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Hapus data tertentu
  Future<bool> removeData(String key) async {
    await init();
    return await _prefs!.remove(key);
  }

  /// Hapus semua data
  Future<bool> clearAll() async {
    await init();
    return await _prefs!.clear();
  }

  /// Cek apakah key ada
  Future<bool> hasKey(String key) async {
    await init();
    return _prefs!.containsKey(key);
  }

  /// Simpan string sederhana
  Future<bool> saveString(String key, String value) async {
    await init();
    return await _prefs!.setString(key, value);
  }

  /// Ambil string
  Future<String?> getString(String key) async {
    await init();
    return _prefs!.getString(key);
  }

  /// Simpan int
  Future<bool> saveInt(String key, int value) async {
    await init();
    return await _prefs!.setInt(key, value);
  }

  /// Ambil int
  Future<int?> getInt(String key) async {
    await init();
    return _prefs!.getInt(key);
  }

  /// Simpan bool
  Future<bool> saveBool(String key, bool value) async {
    await init();
    return await _prefs!.setBool(key, value);
  }

  /// Ambil bool
  Future<bool?> getBool(String key) async {
    await init();
    return _prefs!.getBool(key);
  }
}

/// Storage keys constants
class StorageKeys {
  // Merchant Management
  static const String merchants = 'merchants_data';
  static const String merchantsLastSync = 'merchants_last_sync';

  // Customer Management
  static const String customers = 'customers_data';
  static const String customersLastSync = 'customers_last_sync';

  // Product Management
  static const String products = 'products_data';
  static const String productsLastSync = 'products_last_sync';

  // Transaction Management
  static const String transactions = 'transactions_data';
  static const String transactionsLastSync = 'transactions_last_sync';

  // Payment Monitoring
  static const String payments = 'payments_data';
  static const String paymentsLastSync = 'payments_last_sync';

  // Merchant Revenue
  static const String revenues = 'revenues_data';
  static const String revenuesLastSync = 'revenues_last_sync';

  // Notifications
  static const String notifications = 'notifications_data';
  static const String notificationsLastSync = 'notifications_last_sync';

  // Activity Logs
  static const String activityLogs = 'activity_logs_data';
  static const String activityLogsLastSync = 'activity_logs_last_sync';

  // System Settings
  static const String systemSettings = 'system_settings_data';
  
  // Auth
  static const String authToken = 'auth_token';
  static const String userProfile = 'user_profile';
  static const String isLoggedIn = 'is_logged_in';

  // Dashboard
  static const String dashboardStats = 'dashboard_stats';
  static const String dashboardLastSync = 'dashboard_last_sync';

  // Profile
  static const String profileData = 'profile_data';
}
