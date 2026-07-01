abstract class BaseRepository<T> {
  final String tableName;

  BaseRepository(this.tableName);

  // Convert from Map to Model
  T fromJson(Map<String, dynamic> json);

  // Convert from Model to Map
  Map<String, dynamic> toJson(T item);

  // CRUD operations will be implemented by children
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<T> create(T item);
  Future<T> update(String id, T item);
  Future<void> delete(String id);
}
