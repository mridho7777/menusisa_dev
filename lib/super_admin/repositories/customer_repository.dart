import '../modules/customer_management/models/customer_models.dart';
import 'base_repository.dart';

class CustomerRepository extends BaseRepository<CustomerRecord> {
  CustomerRepository()
    : super(
        'users',
      ); // tabel public.users yang menyimpan data user role 'customer'

  @override
  CustomerRecord fromJson(Map<String, dynamic> json) {
    return CustomerRecord(
      id: json['id']?.toString() ?? '',
      name: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      registeredAt: json['created_at']?.toString() ?? '',
      totalOrders: '0', // Dihitung dinamis nanti
      totalSpent: '0', // Dihitung dinamis nanti
      accountStatus: 'Aktif', // default, atau bisa disesuaikan
      customerTag: json['role']?.toString() ?? 'customer',
    );
  }

  @override
  Map<String, dynamic> toJson(CustomerRecord item) {
    return {
      'id': item.id,
      'full_name': item.name,
      'email': item.email,
      'phone': item.phone,
      'role': 'customer',
    };
  }

  /// Get all customers (users with role = 'customer')
  @override
  Future<List<CustomerRecord>> getAll() async {
    final data = await supabase.client
        .from('users')
        .select()
        .eq('role', 'customer')
        .order('created_at', ascending: false);

    return data.map((e) => fromJson(e)).toList();
  }

  /// Update customer details
  Future<CustomerRecord> updateCustomer(
    String id,
    String fullName,
    String phone,
  ) async {
    final updated = await supabase.client
        .from('users')
        .update({
          'full_name': fullName,
          'phone': phone,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id)
        .select()
        .single();

    return fromJson(updated);
  }
}
