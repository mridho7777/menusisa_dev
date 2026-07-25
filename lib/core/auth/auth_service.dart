import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized Authentication Service
/// Menangani semua operasi auth: Sign Up, Sign In, Sign Out, Session Management
class AuthService {
  static AuthService? _instance;
  static AuthService get instance {
    _instance ??= AuthService._();
    return _instance!;
  }

  AuthService._();

  SupabaseClient get _client => Supabase.instance.client;
  
  // Public getter untuk client (dibutuhkan oleh daftar_penjual_screen)
  SupabaseClient get client => _client;

  // Getters
  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;
  bool get isAuthenticated => currentSession != null;
  String? get userId => currentUser?.id;
  String? get userEmail => currentUser?.email;

  /// Sign Up - Register user baru
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    required String role, // 'customer', 'merchant', 'admin'
  }) async {
    try {
      // 1. Sign up ke Supabase Auth
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
      );

      if (response.user == null) {
        return AuthResult.error('Gagal membuat akun. Silakan coba lagi.');
      }

      final user = response.user!;

      // 2. Wait untuk session ready (PENTING!)
      await Future.delayed(const Duration(milliseconds: 500));

      // 3. Insert ke public.users table
      try {
        await _client.from('users').insert({
          'id': user.id,
          'email': email.trim(),
          'full_name': fullName.trim(),
          'phone': phone?.trim(),
          'role': role,
        });
      } on PostgrestException catch (e) {
        // Jika insert gagal karena duplicate, mungkin sudah ada (dari trigger)
        if (!e.message.contains('duplicate') && !e.message.contains('already exists')) {
          // Delete auth user jika insert gagal
          await _client.auth.signOut();
          return AuthResult.error('Gagal menyimpan data pengguna: ${e.message}');
        }
      }

      // 4. Verify session tersimpan
      final session = _client.auth.currentSession;
      if (session == null) {
        return AuthResult.error('Session gagal dibuat. Silakan login manual.');
      }

      return AuthResult.success(
        user: user,
        role: role,
        message: 'Akun berhasil dibuat!',
      );
    } on AuthException catch (e) {
      return AuthResult.error(_parseAuthError(e));
    } catch (e) {
      return AuthResult.error('Error tidak diketahui: $e');
    }
  }

  /// Sign In - Login user
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Sign in ke Supabase Auth
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.user == null || response.session == null) {
        return AuthResult.error('Login gagal. Periksa email dan password Anda.');
      }

      final user = response.user!;

      // 2. Wait untuk session ready
      await Future.delayed(const Duration(milliseconds: 300));

      // 3. Check apakah super admin
      if (email.trim().toLowerCase() == 'superadmin@menusisa.id') {
        return AuthResult.success(
          user: user,
          role: 'admin',
          message: 'Selamat datang, Super Admin!',
        );
      }

      // 4. Get role dari public.users
      final userData = await _client
          .from('users')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (userData == null) {
        // User tidak ada di public.users, mungkin data corrupt
        await _client.auth.signOut();
        return AuthResult.error(
          'Data pengguna tidak ditemukan. Silakan hubungi admin.',
        );
      }

      final role = userData['role'] as String;

      // 5. Jika merchant, check approval status
      String? approvalStatus;
      if (role == 'merchant') {
        final merchantData = await _client
            .from('merchants')
            .select('approval_status')
            .eq('user_id', user.id)
            .maybeSingle();

        approvalStatus = merchantData?['approval_status'] as String?;
      }

      return AuthResult.success(
        user: user,
        role: role,
        approvalStatus: approvalStatus,
        message: 'Login berhasil!',
      );
    } on AuthException catch (e) {
      return AuthResult.error(_parseAuthError(e));
    } catch (e) {
      return AuthResult.error('Error tidak diketahui: $e');
    }
  }

  /// Sign Out - Logout user
  Future<bool> signOut() async {
    try {
      await _client.auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get User Role
  Future<String?> getUserRole() async {
    if (userId == null) return null;

    try {
      // Check super admin
      if (userEmail?.toLowerCase() == 'superadmin@menusisa.id') {
        return 'admin';
      }

      final userData = await _client
          .from('users')
          .select('role')
          .eq('id', userId!)
          .maybeSingle();

      return userData?['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// Get Merchant Approval Status
  Future<String?> getMerchantApprovalStatus() async {
    if (userId == null) return null;

    try {
      final merchantData = await _client
          .from('merchants')
          .select('approval_status')
          .eq('user_id', userId!)
          .maybeSingle();

      return merchantData?['approval_status'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// Parse Auth Error ke bahasa yang user friendly
  String _parseAuthError(AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('invalid login') || message.contains('invalid credentials')) {
      return 'Email atau password salah.';
    } else if (message.contains('email not confirmed')) {
      return 'Email belum dikonfirmasi. Periksa inbox Anda.';
    } else if (message.contains('user already registered')) {
      return 'Email sudah terdaftar. Silakan login.';
    } else if (message.contains('password')) {
      return 'Password minimal 6 karakter.';
    } else if (message.contains('rate limit')) {
      return 'Terlalu banyak percobaan. Tunggu beberapa saat.';
    } else {
      return e.message;
    }
  }
}

/// Auth Result Model
class AuthResult {
  final bool success;
  final String message;
  final User? user;
  final String? role;
  final String? approvalStatus;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.role,
    this.approvalStatus,
  });

  factory AuthResult.success({
    required User user,
    required String role,
    required String message,
    String? approvalStatus,
  }) {
    return AuthResult(
      success: true,
      message: message,
      user: user,
      role: role,
      approvalStatus: approvalStatus,
    );
  }

  factory AuthResult.error(String message) {
    return AuthResult(
      success: false,
      message: message,
    );
  }
}
