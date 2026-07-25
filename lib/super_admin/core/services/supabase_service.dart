import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  // Auth helpers
  User? get currentUser => client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Generic CRUD operations
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final response = await client.from(table).select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getById(String table, String id) async {
    final response = await client.from(table).select().eq('id', id).maybeSingle();
    return response;
  }

  Future<Map<String, dynamic>> insert(String table, Map<String, dynamic> data) async {
    final response = await client.from(table).insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> update(String table, String id, Map<String, dynamic> data) async {
    final response = await client.from(table).update(data).eq('id', id).select().single();
    return response;
  }

  Future<void> delete(String table, String id) async {
    await client.from(table).delete().eq('id', id);
  }

  // Query with filters
  Future<List<Map<String, dynamic>>> query(
    String table, {
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    dynamic query = client.from(table).select();

    if (filters != null) {
      filters.forEach((key, value) {
        query = query.eq(key, value);
      });
    }

    if (orderBy != null) {
      query = query.order(orderBy, ascending: ascending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }
}
