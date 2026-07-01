import '../core/services/supabase_service.dart';
import '../modules/merchant_management/models/merchant_management_models.dart';
import 'base_repository.dart';

class MerchantRepository extends BaseRepository<MerchantRecord> {
  MerchantRepository() : super('merchants');

  final _supabase = SupabaseService.instance;

  // In-memory storage for now
  final List<MerchantRecord> _merchants = List.from(merchantRecords);

  @override
  MerchantRecord fromJson(Map<String, dynamic> json) {
    return MerchantRecord(
      id: json['id'] as String,
      merchantId: json['merchant_id'] as String,
      shopName: json['shop_name'] as String,
      ownerName: json['owner_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      status: json['status'] as String,
      registeredAt: json['registered_at'] as String,
      totalProducts: json['total_products'] as String,
      totalSales: json['total_sales'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson(MerchantRecord item) {
    return {
      'id': item.id,
      'merchant_id': item.merchantId,
      'shop_name': item.shopName,
      'owner_name': item.ownerName,
      'email': item.email,
      'phone': item.phone,
      'status': item.status,
      'registered_at': item.registeredAt,
      'total_products': item.totalProducts,
      'total_sales': item.totalSales,
    };
  }

  @override
  Future<List<MerchantRecord>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_merchants);
  }

  @override
  Future<MerchantRecord?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _merchants.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<MerchantRecord> create(MerchantRecord item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _merchants.insert(0, item);
    return item;
  }

  @override
  Future<MerchantRecord> update(String id, MerchantRecord item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _merchants.indexWhere((m) => m.id == id);
    if (index != -1) {
      _merchants[index] = item;
    }
    return item;
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _merchants.removeWhere((m) => m.id == id);
  }

  Future<MerchantRecord> approve(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _merchants.indexWhere((m) => m.id == id);
    if (index != -1) {
      _merchants[index] = _merchants[index].copyWith(status: 'Aktif');
      return _merchants[index];
    }
    throw Exception('Merchant not found');
  }

  Future<MerchantRecord> suspend(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _merchants.indexWhere((m) => m.id == id);
    if (index != -1) {
      _merchants[index] = _merchants[index].copyWith(status: 'Suspend');
      return _merchants[index];
    }
    throw Exception('Merchant not found');
  }

  Future<MerchantRecord> deactivate(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _merchants.indexWhere((m) => m.id == id);
    if (index != -1) {
      _merchants[index] = _merchants[index].copyWith(status: 'Nonaktif');
      return _merchants[index];
    }
    throw Exception('Merchant not found');
  }

  Future<List<MerchantRecord>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query.isEmpty) return _merchants;
    
    final lowerQuery = query.toLowerCase();
    return _merchants.where((m) {
      return m.shopName.toLowerCase().contains(lowerQuery) ||
          m.ownerName.toLowerCase().contains(lowerQuery) ||
          m.email.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<List<MerchantRecord>> filterByStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _merchants.where((m) => m.status == status).toList();
  }
}
