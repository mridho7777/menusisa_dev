class NotificationSettingModel {
  final String id;
  final String label;
  bool isActive;

  NotificationSettingModel({
    required this.id,
    required this.label,
    required this.isActive,
  });

  NotificationSettingModel copyWith({
    String? id,
    String? label,
    bool? isActive,
  }) {
    return NotificationSettingModel(
      id: id ?? this.id,
      label: label ?? this.label,
      isActive: isActive ?? this.isActive,
    );
  }
}
