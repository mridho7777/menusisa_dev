import 'package:supabase_flutter/supabase_flutter.dart';

class MerchantSupabaseService {
  static final MerchantSupabaseService instance = MerchantSupabaseService._();
  MerchantSupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  User? get currentUser => client.auth.currentUser;
  String? get userId => currentUser?.id;

  // Mendapatkan merchant id yang terkait dengan user login saat ini
  Future<String?> getMerchantId() async {
    if (userId == null) return null;
    final res = await client.from('merchants').select('id').eq('user_id', userId!).maybeSingle();
    return res?['id']?.toString();
  }
}
