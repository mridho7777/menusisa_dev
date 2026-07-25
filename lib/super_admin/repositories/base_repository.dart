import '../core/services/supabase_service.dart';

abstract class BaseRepository<T> {
  final String tableName;
  SupabaseService get supabase => SupabaseService.instance;

  BaseRepository(this.tableName);

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T item);

  Future<List<T>> getAll() async {
    final data = await supabase.getAll(tableName);
    return data.map((e) => fromJson(e)).toList();
  }

  Future<T?> getById(String id) async {
    final data = await supabase.getById(tableName, id);
    if (data == null) return null;
    return fromJson(data);
  }

  Future<T> create(T item) async {
    final data = await supabase.insert(tableName, toJson(item));
    return fromJson(data);
  }

  Future<T> update(String id, T item) async {
    final data = await supabase.update(tableName, id, toJson(item));
    return fromJson(data);
  }

  Future<void> delete(String id) async {
    await supabase.delete(tableName, id);
  }

  Future<List<T>> query({
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    final data = await supabase.query(
      tableName,
      filters: filters,
      orderBy: orderBy,
      ascending: ascending,
      limit: limit,
    );
    return data.map((e) => fromJson(e)).toList();
  }
}