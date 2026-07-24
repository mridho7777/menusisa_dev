import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pengaturan_model.dart';

class PengaturanService {
  final _client = Supabase.instance.client;

  Future<PengaturanModel> fetchPengaturanData() async {
    final user = _client.auth.currentUser;
    
    if (user == null) {
      return _defaultModel();
    }

    try {
      final userData = await _client
          .from('users')
          .select('email')
          .eq('id', user.id)
          .maybeSingle();

      final merchantData = await _client
          .from('merchants')
          .select('shop_name, shop_description, shop_address, shop_phone')
          .eq('user_id', user.id)
          .maybeSingle();

      if (merchantData != null) {
        return PengaturanModel(
          title: 'Halaman Pengaturan',
          description: 'Kelola jam operasional toko, alamat, dan pengaturan lainnya.',
          storeName: merchantData['shop_name'] ?? '',
          storeDescription: merchantData['shop_description'] ?? '',
          storeAddress: merchantData['shop_address'] ?? '',
          whatsapp: merchantData['shop_phone'] ?? '',
          email: userData?['email'] ?? user.email ?? '',
          openTime: '08:00',
          closeTime: '21:00',
          paymentMethod: '',
          orderNotification: true,
          promoNotification: true,
          stockNotification: true,
          photoLabel: '',
          bannerLabel: '',
        );
      }
    } catch (e) {
      // Return default if error
    }

    return _defaultModel();
  }

  Future<bool> updatePengaturanData({
    required String userId,
    required String storeName,
    required String storeDescription,
    required String storeAddress,
    required String whatsapp,
  }) async {
    try {
      await _client.from('merchants').update({
        'shop_name': storeName,
        'shop_description': storeDescription,
        'shop_address': storeAddress,
        'shop_phone': whatsapp,
      }).eq('user_id', userId);

      return true;
    } catch (e) {
      return false;
    }
  }

  PengaturanModel _defaultModel() {
    return PengaturanModel(
      title: 'Halaman Pengaturan',
      description: 'Kelola jam operasional toko, alamat, dan pengaturan lainnya.',
      storeName: '',
      storeDescription: '',
      storeAddress: '',
      whatsapp: '',
      email: '',
      openTime: '08:00',
      closeTime: '21:00',
      paymentMethod: '',
      orderNotification: true,
      promoNotification: true,
      stockNotification: true,
      photoLabel: '',
      bannerLabel: '',
    );
  }
}
