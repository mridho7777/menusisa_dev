import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profil_model.dart';

class ProfilService {
  final _client = Supabase.instance.client;

  Future<ProfilModel> fetchProfilData() async {
    final user = _client.auth.currentUser;
    
    if (user == null) {
      return ProfilModel(
        title: 'Akun',
        subtitle: 'Kelola identitas merchant dan kredensial akun.',
        records: [],
      );
    }

    try {
      final userData = await _client
          .from('users')
          .select('id, email, full_name, phone')
          .eq('id', user.id)
          .maybeSingle();

      if (userData != null) {
        return ProfilModel(
          title: 'Akun',
          subtitle: 'Kelola identitas merchant dan kredensial akun.',
          records: [
            ProfileRecord(
              id: userData['id'] ?? 'main',
              name: userData['full_name'] ?? 'Nama Belum Diisi',
              whatsapp: userData['phone'] ?? '-',
              email: userData['email'] ?? user.email ?? '-',
              password: '********',
            ),
          ],
        );
      }
    } catch (e) {
      // Fallback jika error
    }

    return ProfilModel(
      title: 'Akun',
      subtitle: 'Kelola identitas merchant dan kredensial akun.',
      records: [
        ProfileRecord(
          id: 'main',
          name: 'Nama Belum Diisi',
          whatsapp: '-',
          email: user.email ?? '-',
          password: '********',
        ),
      ],
    );
  }

  Future<bool> updateProfilData({
    required String userId,
    required String fullName,
    required String phone,
  }) async {
    try {
      await _client.from('users').update({
        'full_name': fullName,
        'phone': phone,
      }).eq('id', userId);

      await _client.from('merchants').update({
        'shop_phone': phone,
      }).eq('user_id', userId);

      return true;
    } catch (e) {
      return false;
    }
  }
}
