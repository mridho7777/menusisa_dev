import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MerchantWorkspaceProvider extends ChangeNotifier {
  String _storeName = 'Memuat...';
  String _storeId = '';
  String _email = 'Memuat...';
  String _description = '';
  String _address = '';
  String _profileName = 'Memuat...';
  Uint8List? _profileImageBytes;
  String? _profileImageLabel;
  Uint8List? _bannerImageBytes;
  String? _bannerImageLabel;


  Future<void> loadData() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    _storeName = 'Memuat...';
    _storeId = '';
    _email = 'Memuat...';
    _description = '';
    _address = '';
    _profileName = 'Memuat...';
    if (user != null) {
      _email = user.email ?? _email;
      Map<String, dynamic>? userData;
      try {
        userData = await client
            .from('users')
            .select('full_name, email, phone')
            .eq('id', user.id)
            .maybeSingle();
        if (userData != null) {
          _profileName = userData['full_name'] ?? _profileName;
          _email = userData['email'] ?? _email;
        }
      } catch (e) {
        debugPrint('MerchantWorkspaceProvider users load failed: $e');
      }

      try {
        final merchantRows = await client
            .from('merchants')
            .select('id, shop_name, shop_description, shop_address, created_at')
            .eq('user_id', user.id)
            .order('created_at', ascending: false)
            .limit(1);
        if (merchantRows is List && merchantRows.isNotEmpty) {
          final merchantData = merchantRows.first as Map<String, dynamic>;
          _storeName = merchantData['shop_name'] ?? _storeName;
          _storeId = merchantData['id'] ?? _storeId;
          _description = merchantData['shop_description'] ?? _description;
          _address = merchantData['shop_address'] ?? _address;
        } else {
          final fallbackName = (userData?['full_name']?.toString().trim().isNotEmpty ?? false)
              ? userData!['full_name'].toString().trim()
              : (user.email?.split('@').first ?? 'Toko Saya');
          final createdMerchant = await client
              .from('merchants')
              .insert({
                'user_id': user.id,
                'shop_name': fallbackName,
                'shop_address': '-',
                'approval_status': 'approved',
                'is_active': true,
              })
              .select('id, shop_name, shop_description, shop_address')
              .single();
          _storeName = createdMerchant['shop_name'] ?? fallbackName;
          _storeId = createdMerchant['id'] ?? _storeId;
          _description = createdMerchant['shop_description'] ?? _description;
          _address = createdMerchant['shop_address'] ?? _address;
        }
      } catch (e) {
        debugPrint('MerchantWorkspaceProvider merchants load failed: $e');
      }
    }
    notifyListeners();
  }

  String get storeName => _storeName;
  String get storeId => _storeId;
  String get email => _email;
  String get description => _description;
  String get address => _address;
  String get profileName => _profileName;
  Uint8List? get profileImageBytes => _profileImageBytes;
  String? get profileImageLabel => _profileImageLabel;
  Uint8List? get bannerImageBytes => _bannerImageBytes;
  String? get bannerImageLabel => _bannerImageLabel;

  void updateStoreInfo({String? storeName, String? storeId, String? email, String? description, String? address}) {
    if (storeName != null && storeName.isNotEmpty) _storeName = storeName;
    if (storeId != null && storeId.isNotEmpty) _storeId = storeId;
    if (email != null && email.isNotEmpty) _email = email;
    if (description != null && description.isNotEmpty) _description = description;
    if (address != null && address.isNotEmpty) _address = address;
    notifyListeners();
  }

  void updateProfile({String? profileName, Uint8List? imageBytes, String? imageLabel}) {
    if (profileName != null && profileName.isNotEmpty) _profileName = profileName;
    if (imageBytes != null) _profileImageBytes = imageBytes;
    if (imageLabel != null) _profileImageLabel = imageLabel;
    notifyListeners();
  }

  void updateBanner({Uint8List? imageBytes, String? imageLabel}) {
    if (imageBytes != null) _bannerImageBytes = imageBytes;
    if (imageLabel != null) _bannerImageLabel = imageLabel;
    notifyListeners();
  }

  void clearProfileImage() {
    _profileImageBytes = null;
    _profileImageLabel = null;
    notifyListeners();
  }
}
