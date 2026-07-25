import 'base_repository.dart';

class ActivityLogRepository extends BaseRepository<Map<String, dynamic>> {
  ActivityLogRepository() : super('activity_logs');

  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) => json;

  @override
  Map<String, dynamic> toJson(Map<String, dynamic> item) => item;
}
