class NotifikasiModel {
  final String id;
  final String title;
  final String description;
  final String timeLabel;
  final String iconKey;
  final bool isRead;
  final String colorKey;

  NotifikasiModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timeLabel,
    required this.iconKey,
    this.isRead = false,
    this.colorKey = 'default',
  });

  NotifikasiModel copyWith({
    String? id,
    String? title,
    String? description,
    String? timeLabel,
    String? iconKey,
    bool? isRead,
    String? colorKey,
  }) {
    return NotifikasiModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timeLabel: timeLabel ?? this.timeLabel,
      iconKey: iconKey ?? this.iconKey,
      isRead: isRead ?? this.isRead,
      colorKey: colorKey ?? this.colorKey,
    );
  }
}
