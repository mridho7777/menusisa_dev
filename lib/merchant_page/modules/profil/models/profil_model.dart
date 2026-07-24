class ProfileRecord {
  final String id;
  final String name;
  final String whatsapp;
  final String email;
  final String password;

  ProfileRecord({required this.id, required this.name, required this.whatsapp, required this.email, required this.password});
}

class ProfilModel {
  final String title;
  final String subtitle;
  final List<ProfileRecord> records;

  ProfilModel({required this.title, required this.subtitle, required this.records});
}
