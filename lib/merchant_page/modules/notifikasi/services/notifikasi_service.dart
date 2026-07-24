import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/notifikasi_model.dart';

class NotifikasiService {
  final _client = Supabase.instance.client;

  Future<List<NotifikasiModel>> fetchNotifikasiData() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    try {
      final merchant = await _client.from('merchants').select('id').eq('user_id', user.id).maybeSingle();
      if (merchant == null) return [];

      final data = await _client
          .from('notifications')
          .select('id, title, message, type, icon_key, is_read, created_at')
          .eq('recipient', 'merchant')
          .eq('entity_id', merchant['id'])
          .order('created_at', ascending: false);

      return data.map<NotifikasiModel>((row) => NotifikasiModel(
        id: row['id']?.toString() ?? '',
        title: row['title']?.toString() ?? '',
        description: row['message']?.toString() ?? '',
        timeLabel: row['created_at']?.toString() ?? '',
        iconKey: row['icon_key']?.toString() ?? 'notification',
        isRead: row['is_read'] == true,
      )).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> addNotification(NotifikasiModel item) async {
    try {
      await _client.from('notifications').insert({
        'id': item.id,
        'title': item.title,
        'message': item.description,
        'icon_key': item.iconKey,
        'recipient': 'merchant',
        'is_read': item.isRead,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateNotification(NotifikasiModel item) async {
    try {
      await _client.from('notifications').update({
        'title': item.title,
        'message': item.description,
        'icon_key': item.iconKey,
        'is_read': item.isRead,
      }).eq('id', item.id);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteNotification(String id) async {
    try {
      await _client.from('notifications').delete().eq('id', id);
      return true;
    } catch (_) {
      return false;
    }
  }
}
