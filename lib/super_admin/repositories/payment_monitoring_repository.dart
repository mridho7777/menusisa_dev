import 'base_repository.dart';

class PaymentMonitoringRepository extends BaseRepository<Map<String, dynamic>> {
  PaymentMonitoringRepository() : super('payment_monitoring');

  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) => Map<String, dynamic>.from(json);

  @override
  Map<String, dynamic> toJson(Map<String, dynamic> item) => Map<String, dynamic>.from(item);

  Future<Map<String, dynamic>> verifyPayment(String id, String verifiedBy) async {
    final data = await supabase.update('payment_monitoring', id, {
      'status': 'verified',
      'verified_by': verifiedBy,
      'verified_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
    return data;
  }

  Future<Map<String, dynamic>> rejectPayment(String id, String reason) async {
    final data = await supabase.update('payment_monitoring', id, {
      'status': 'failed',
      'notes': reason,
      'updated_at': DateTime.now().toIso8601String(),
    });
    return data;
  }
}
