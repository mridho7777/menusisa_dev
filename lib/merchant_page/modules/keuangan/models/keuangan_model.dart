class KeuanganRecord {
  final String id;
  final String title;
  final double amount;
  final String type;
  final DateTime date;

  KeuanganRecord({required this.id, required this.title, required this.amount, required this.type, required this.date});
}

class KeuanganModel {
  final String title;
  final String subtitle;
  final double saldo;
  final double pemasukan;
  final double pengeluaran;
  final List<double> weeklyIncome;
  final List<String> days;
  final List<KeuanganRecord> transactions;

  KeuanganModel({required this.title, required this.subtitle, required this.saldo, required this.pemasukan, required this.pengeluaran, required this.weeklyIncome, required this.days, required this.transactions});
}
