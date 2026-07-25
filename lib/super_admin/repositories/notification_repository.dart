import 'base_repository.dart';

class NotificationRepository extends BaseRepository<Map<String, dynamic>> {
  NotificationRepository() : super('notifications');

  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) => Map<String, dynamic>.from(json);

  @override
  Map<String, dynamic> toJson(Map<String, dynamic> item) => Map<String, dynamic>.from(item);

  /// Mark notification as read
  Future<Map<String, dynamic>> markAsRead(String id) async {
    final data = await supabase.update('notifications', id, {
      'is_read': true,
      'read_at': DateTime.now().toIso8601String(),
    });
    return fromJson(data);
  }

  /// Get unread notifications count
  Future<int> getUnreadCount() async {
    final notifications = await query(filters: {'is_read': false});
    return notifications.length;
  }

  /// Get notifications by type
  Future<List<Map<String, dynamic>>> getByType(String type) async {
    return await query(filters: {'type': type});
  }
}
