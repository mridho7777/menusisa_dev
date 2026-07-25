import 'package:flutter/material.dart';
import '../modules/merchant_management/models/merchant_management_models.dart';
import '../repositories/merchant_repository.dart';

class MerchantProvider extends ChangeNotifier {
  final MerchantRepository _repository = MerchantRepository();

  List<MerchantRecord> _merchants = [];
  List<MerchantRecord> get merchants => _merchants;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _statusFilter = 'Semua';
  String get statusFilter => _statusFilter;

  MerchantProvider() {
    loadMerchants();
  }

  Future<void> loadMerchants() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _merchants = await _repository.getAll();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ MerchantProvider loadMerchants error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMerchant(MerchantRecord merchant) async {
    try {
      final newMerchant = await _repository.create(merchant);
      _merchants.insert(0, newMerchant);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateMerchant(String id, MerchantRecord merchant) async {
    try {
      final updated = await _repository.update(id, merchant);
      final index = _merchants.indexWhere((m) => m.id == id);
      if (index != -1) {
        _merchants[index] = updated;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteMerchant(String id) async {
    try {
      await _repository.delete(id);
      _merchants.removeWhere((m) => m.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Approve merchant - ubah approval_status ke approved
  Future<bool> approveMerchant(String id) async {
    try {
      final updated = await _repository.approve(id);
      final index = _merchants.indexWhere((m) => m.id == id);
      if (index != -1) {
        _merchants[index] = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ approveMerchant error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Reject merchant - ubah approval_status ke rejected
  Future<bool> rejectMerchant(String id, String reason) async {
    try {
      final updated = await _repository.reject(id, reason);
      final index = _merchants.indexWhere((m) => m.id == id);
      if (index != -1) {
        _merchants[index] = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ rejectMerchant error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Suspend merchant
  Future<bool> suspendMerchant(String id) async {
    try {
      final updated = await _repository.suspend(id);
      final index = _merchants.indexWhere((m) => m.id == id);
      if (index != -1) {
        _merchants[index] = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deactivateMerchant(String id) async {
    try {
      final updated = await _repository.deactivate(id);
      final index = _merchants.indexWhere((m) => m.id == id);
      if (index != -1) {
        _merchants[index] = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners();
  }

  List<MerchantRecord> get filteredMerchants {
    var filtered = List<MerchantRecord>.from(_merchants);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((m) {
        return m.shopName.toLowerCase().contains(query) ||
            m.ownerName.toLowerCase().contains(query) ||
            m.email.toLowerCase().contains(query);
      }).toList();
    }

    if (_statusFilter != 'Semua') {
      filtered = filtered.where((m) => m.status == _statusFilter).toList();
    }

    return filtered;
  }

  // Counters for metrics
  int get totalMerchants => _merchants.length;
  int get pendingMerchants => _merchants.where((m) => m.status == 'pending').length;
  int get approvedMerchants => _merchants.where((m) => m.status == 'approved').length;
  int get rejectedMerchants => _merchants.where((m) => m.status == 'rejected').length;
}
