import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository untuk autentikasi admin
class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Sign in admin
  Future<bool> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user != null;
    } catch (e) {
      return false;
    }
  }

  /// Sign out admin
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Get current admin user
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      
      return userData;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is admin
  Future<bool> isAdmin() async {
    final user = await getCurrentUser();
    return user?['role'] == 'admin' || user?['email'] == 'superadmin@menusisa.id';
  }
}
