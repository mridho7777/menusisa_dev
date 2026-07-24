import 'base_repository.dart';
import '../modules/transaction_management/models/transaction_models.dart';

class TransactionRepository extends BaseRepository<TransactionRecord> {
  TransactionRepository() : super('orders');

  @override
  TransactionRecord fromJson(Map<String, dynamic> json) => TransactionRecord.fromJson(json);

  @override
  Map<String, dynamic> toJson(TransactionRecord item) => item.toJson();

  Future<TransactionRecord> updateStatus(String id, String status) async {
    final data = await supabase.update('orders', id, {'status': status, 'updated_at': DateTime.now().toIso8601String()});
    return fromJson(data);
  }
}
