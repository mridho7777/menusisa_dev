import 'package:flutter/foundation.dart';
import 'local_storage_service.dart';
import 'supabase_service.dart';

/// Service untuk sinkronisasi data antara local storage dan Supabase
/// Memungkinkan aplikasi bekerja dengan data lokal sementara
/// dan siap untuk integrasi Supabase di masa depan
class DataSyncService {
  static DataSyncService? _instance;
  static DataSyncService get instance {
    _instance ??= DataSyncService._();
    return _instance!;
  }

  DataSyncService._();

  final _localStorage = LocalStorageService.instance;
  final _supabase = SupabaseService.instance;

  bool _useSupabase = false;
  bool get useSupabase => _useSupabase;

  /// Toggle mode: local storage atau Supabase
  void setSupabaseMode(bool enabled) {
    _useSupabase = enabled;
  }

  /// Generic fetch data - otomatis pilih sumber (local atau Supabase)
  Future<List<Map<String, dynamic>>> fetchData(
    String storageKey,
    String? supabaseTable,
  ) async {
    if (_useSupabase && supabaseTable != null) {
      try {
        return await _supabase.getAll(supabaseTable);
      } catch (e) {
        debugPrint('Supabase fetch error, falling back to local: $e');
        return await _localStorage.getList(storageKey);
      }
    } else {
      return await _localStorage.getList(storageKey);
    }
  }

  /// Generic save data
  Future<bool> saveData(
    String storageKey,
    String? supabaseTable,
    List<Map<String, dynamic>> data,
  ) async {
    // Simpan ke local storage terlebih dahulu
    final localSaved = await _localStorage.saveList(storageKey, data);

    // Jika mode Supabase aktif, sync ke cloud
    if (_useSupabase && supabaseTable != null) {
      try {
        // TODO: Implement batch upload to Supabase
        debugPrint('Supabase sync will be implemented here');
      } catch (e) {
        debugPrint('Supabase save error: $e');
      }
    }

    return localSaved;
  }

  /// Tambah item baru
  Future<Map<String, dynamic>?> addItem(
    String storageKey,
    String? supabaseTable,
    Map<String, dynamic> item,
  ) async {
    if (_useSupabase && supabaseTable != null) {
      try {
        final result = await _supabase.insert(supabaseTable, item);
        // Simpan juga ke local sebagai cache
        final localData = await _localStorage.getList(storageKey);
        localData.insert(0, result);
        await _localStorage.saveList(storageKey, localData);
        return result;
      } catch (e) {
        debugPrint('Supabase insert error: $e');
        return null;
      }
    } else {
      // Mode local storage
      final localData = await _localStorage.getList(storageKey);
      localData.insert(0, item);
      final saved = await _localStorage.saveList(storageKey, localData);
      return saved ? item : null;
    }
  }

  /// Update item
  Future<Map<String, dynamic>?> updateItem(
    String storageKey,
    String? supabaseTable,
    String id,
    Map<String, dynamic> item,
  ) async {
    if (_useSupabase && supabaseTable != null) {
      try {
        final result = await _supabase.update(supabaseTable, id, item);
        // Update local cache
        final localData = await _localStorage.getList(storageKey);
        final index = localData.indexWhere((e) => e['id'] == id);
        if (index != -1) {
          localData[index] = result;
          await _localStorage.saveList(storageKey, localData);
        }
        return result;
      } catch (e) {
        debugPrint('Supabase update error: $e');
        return null;
      }
    } else {
      // Mode local storage
      final localData = await _localStorage.getList(storageKey);
      final index = localData.indexWhere((e) => e['id'] == id);
      if (index != -1) {
        localData[index] = item;
        final saved = await _localStorage.saveList(storageKey, localData);
        return saved ? item : null;
      }
      return null;
    }
  }

  /// Delete item
  Future<bool> deleteItem(
    String storageKey,
    String? supabaseTable,
    String id,
  ) async {
    if (_useSupabase && supabaseTable != null) {
      try {
        await _supabase.delete(supabaseTable, id);
        // Hapus dari local cache
        final localData = await _localStorage.getList(storageKey);
        localData.removeWhere((e) => e['id'] == id);
        await _localStorage.saveList(storageKey, localData);
        return true;
      } catch (e) {
        debugPrint('Supabase delete error: $e');
        return false;
      }
    } else {
      // Mode local storage
      final localData = await _localStorage.getList(storageKey);
      localData.removeWhere((e) => e['id'] == id);
      return await _localStorage.saveList(storageKey, localData);
    }
  }

  /// Sync dari Supabase ke Local (refresh)
  Future<bool> syncFromSupabase(
    String storageKey,
    String supabaseTable,
  ) async {
    if (!_useSupabase) return false;

    try {
      final data = await _supabase.getAll(supabaseTable);
      await _localStorage.saveList(storageKey, data);
      await _localStorage.saveString(
        '\_last_sync',
        DateTime.now().toIso8601String(),
      );
      return true;
    } catch (e) {
      debugPrint('Sync from Supabase error: $e');
      return false;
    }
  }

  /// Get last sync time
  Future<DateTime?> getLastSyncTime(String storageKey) async {
    final timeString = await _localStorage.getString('\_last_sync');
    if (timeString == null) return null;
    try {
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }

  /// Clear all local data
  Future<bool> clearLocalData() async {
    return await _localStorage.clearAll();
  }
}
