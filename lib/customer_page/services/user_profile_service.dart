import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileService {
  static UserProfileService? _instance;
  static UserProfileService get instance {
    _instance ??= UserProfileService._();
    return _instance!;
  }

  UserProfileService._();

  SupabaseClient get client => Supabase.instance.client;
  User? get currentUser => client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  String? get userId => currentUser?.id;
  String? get userEmail => currentUser?.email;

  Future<Map<String, dynamic>?> getUserProfile() async {
    if (userId == null) return null;
    try {
      return await client
          .from('users')
          .select('*')
          .eq('id', userId!)
          .maybeSingle();
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    if (userId == null) return false;
    try {
      final data = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (fullName != null) data['full_name'] = fullName;
      if (phone != null) data['phone'] = phone;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;
      await client.from('users').update(data).eq('id', userId!);
      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  Future<String?> uploadAvatar(File imageFile) async {
    if (userId == null) return null;
    try {
      final bucket = client.storage.from('avatars');
      final path =
          'customer-avatars/${userId!}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await bucket.uploadBinary(
        path,
        await imageFile.readAsBytes(),
        fileOptions: const FileOptions(upsert: true, contentType: 'image/jpeg'),
      );
      return bucket.getPublicUrl(path);
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
      return null;
    }
  }

  Future<bool> updatePassword(String password) async {
    try {
      await client.auth.updateUser(UserAttributes(password: password));
      return true;
    } catch (e) {
      debugPrint('Error updating password: $e');
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    if (userId == null) return false;
    try {
      await client.from('users').delete().eq('id', userId!);
      await client.auth.signOut();
      return true;
    } catch (e) {
      debugPrint('Error deleting account: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Future<bool> userExistsInPublicTable() async {
    if (userId == null) return false;
    try {
      final response = await client
          .from('users')
          .select('id')
          .eq('id', userId!)
          .maybeSingle();
      return response != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createUserInPublicTable({
    required String fullName,
    required String role,
    String? phone,
  }) async {
    if (userId == null || userEmail == null) return false;
    try {
      await client.from('users').insert({
        'id': userId,
        'email': userEmail,
        'full_name': fullName,
        'phone': phone,
        'role': role,
      });
      return true;
    } catch (e) {
      debugPrint('Error creating user in public table: $e');
      return false;
    }
  }
}
