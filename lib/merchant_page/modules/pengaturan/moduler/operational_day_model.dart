class OperationalDayModel {
  final String day;
  String openTime;
  String closeTime;
  bool isActive;

  OperationalDayModel({
    required this.day,
    required this.openTime,
    required this.closeTime,
    required this.isActive,
  });

  OperationalDayModel copyWith({
    String? day,
    String? openTime,
    String? closeTime,
    bool? isActive,
  }) {
    return OperationalDayModel(
      day: day ?? this.day,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      isActive: isActive ?? this.isActive,
    );
  }
}
