import 'package:flutter/material.dart';
import '../repositories/platform_revenue_repository.dart';

/// Provider untuk Revenue Management
class RevenueProvider extends ChangeNotifier {
  final PlatformRevenueRepository _repository = PlatformRevenueRepository();
  
  List<Map<String, dynamic>> _revenues = [];
  List<Map<String, dynamic>> get revenues => _revenues;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _periodFilter = 'Semua';
  String get periodFilter => _periodFilter;

  RevenueProvider() {
    loadRevenues();
  }

  Future<void> loadRevenues() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _revenues = await _repository.getAll();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ RevenueProvider loadRevenues error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRevenue(Map<String, dynamic> revenue) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.create(revenue);
      _revenues.insert(0, result);
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ RevenueProvider addRevenue error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRevenue(String id, Map<String, dynamic> revenue) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.update(id, revenue);
      final index = _revenues.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        _revenues[index] = result;
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ RevenueProvider updateRevenue error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setPeriodFilter(String period) {
    _periodFilter = period;
    notifyListeners();
  }

  List<Map<String, dynamic>> get filteredRevenues {
    var filtered = List<Map<String, dynamic>>.from(_revenues);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((r) {
        return (r['merchant_name']?.toString().toLowerCase().contains(query) ?? false) ||
            (r['merchant_id']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (_periodFilter != 'Semua') {
      final now = DateTime.now();
      filtered = filtered.where((r) {
        final date = DateTime.tryParse(r['date']?.toString() ?? r['created_at']?.toString() ?? '');
        if (date == null) return false;
        switch (_periodFilter) {
          case 'Hari Ini':
            return date.year == now.year && date.month == now.month && date.day == now.day;
          case 'Minggu Ini':
            return date.isAfter(now.subtract(const Duration(days: 7)));
          case 'Bulan Ini':
            return date.year == now.year && date.month == now.month;
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  double get totalRevenue {
    return filteredRevenues.fold(0.0, (sum, r) {
      final amount = double.tryParse(r['total_revenue']?.toString() ?? r['amount']?.toString() ?? '0') ?? 0.0;
      return sum + amount;
    });
  }

  Map<String, double> get revenueByMerchant {
    final Map<String, double> result = {};
    for (final r in filteredRevenues) {
      final merchant = r['merchant_name']?.toString() ?? 'Unknown';
      final amount = double.tryParse(r['total_revenue']?.toString() ?? r['amount']?.toString() ?? '0') ?? 0.0;
      result[merchant] = (result[merchant] ?? 0.0) + amount;
    }
    return result;
  }
}

