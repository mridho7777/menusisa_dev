import '../core/services/supabase_service.dart';
import '../modules/customer_management/models/customer_models.dart';
import 'base_repository.dart';

class CustomerRepository extends BaseRepository<CustomerRecord> {
  CustomerRepository() : super('customers');

  final _supabase = SupabaseService.instance;

  // In-memory storage for now (before Supabase integration)
  final List<CustomerRecord> _customers = List.from(customerRecords);

  @override
  CustomerRecord fromJson(Map<String, dynamic> json) {
    return CustomerRecord(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      registeredAt: json['registered_at'] as String,
      totalOrders: json['total_orders'] as String,
      totalSpent: json['total_spent'] as String,
      accountStatus: json['account_status'] as String,
      customerTag: json['customer_tag'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson(CustomerRecord item) {
    return {
      'id': item.id,
      'name': item.name,
      'email': item.email,
      'phone': item.phone,
      'registered_at': item.registeredAt,
      'total_orders': item.totalOrders,
      'total_spent': item.totalSpent,
      'account_status': item.accountStatus,
      'customer_tag': item.customerTag,
    };
  }

  @override
  Future<List<CustomerRecord>> getAll() async {
    // TODO: Replace with Supabase call
    // final data = await _supabase.getAll(tableName);
    // return data.map((e) => fromJson(e)).toList();
    
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    return List.from(_customers);
  }

  @override
  Future<CustomerRecord?> getById(String id) async {
    // TODO: Replace with Supabase call
    // final data = await _supabase.getById(tableName, id);
    // return data != null ? fromJson(data) : null;
    
    await Future.delayed(const Duration(milliseconds: 200));
    return _customers.firstWhere((c) => c.id == id);
  }

  @override
  Future<CustomerRecord> create(CustomerRecord item) async {
    // TODO: Replace with Supabase call
    // final data = await _supabase.insert(tableName, toJson(item));
    // return fromJson(data);
    
    await Future.delayed(const Duration(milliseconds: 300));
    _customers.insert(0, item);
    return item;
  }

  @override
  Future<CustomerRecord> update(String id, CustomerRecord item) async {
    // TODO: Replace with Supabase call
    // final data = await _supabase.update(tableName, id, toJson(item));
    // return fromJson(data);
    
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _customers.indexWhere((c) => c.id == id);
    if (index != -1) {
      _customers[index] = item;
    }
    return item;
  }

  @override
  Future<void> delete(String id) async {
    // TODO: Replace with Supabase call
    // await _supabase.delete(tableName, id);
    
    await Future.delayed(const Duration(milliseconds: 300));
    _customers.removeWhere((c) => c.id == id);
  }

  Future<List<CustomerRecord>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query.isEmpty) return _customers;
    
    final lowerQuery = query.toLowerCase();
    return _customers.where((c) {
      return c.name.toLowerCase().contains(lowerQuery) ||
          c.email.toLowerCase().contains(lowerQuery) ||
          c.phone.contains(lowerQuery);
    }).toList();
  }

  Future<List<CustomerRecord>> filterByStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _customers.where((c) => c.accountStatus == status).toList();
  }
}
