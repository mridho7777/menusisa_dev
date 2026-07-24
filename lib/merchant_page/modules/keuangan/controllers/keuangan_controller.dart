import 'package:flutter/material.dart';

import '../models/keuangan_model.dart';
import '../services/keuangan_service.dart';

class MerchantKeuanganController extends ChangeNotifier {
  final KeuanganService _service = KeuanganService();
  KeuanganModel? _data;
  bool _isLoading = true;

  KeuanganModel? get data => _data;
  bool get isLoading => _isLoading;

  MerchantKeuanganController() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _data = await _service.fetchKeuanganData();
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(KeuanganRecord record) async {
    if (_data == null) return;
    _data = KeuanganModel(
      title: _data!.title,
      subtitle: _data!.subtitle,
      saldo: record.type == 'income' ? _data!.saldo + record.amount : _data!.saldo - record.amount,
      pemasukan: record.type == 'income' ? _data!.pemasukan + record.amount : _data!.pemasukan,
      pengeluaran: record.type == 'expense' ? _data!.pengeluaran + record.amount : _data!.pengeluaran,
      weeklyIncome: List<double>.from(_data!.weeklyIncome),
      days: List<String>.from(_data!.days),
      transactions: [record, ..._data!.transactions],
    );
    notifyListeners();
  }

  Future<void> updateTransaction(String id, KeuanganRecord updated) async {
    if (_data == null) return;
    _data = KeuanganModel(
      title: _data!.title,
      subtitle: _data!.subtitle,
      saldo: _data!.saldo,
      pemasukan: _data!.pemasukan,
      pengeluaran: _data!.pengeluaran,
      weeklyIncome: List<double>.from(_data!.weeklyIncome),
      days: List<String>.from(_data!.days),
      transactions: _data!.transactions.map((item) => item.id == id ? updated : item).toList(),
    );
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    if (_data == null) return;
    _data = KeuanganModel(
      title: _data!.title,
      subtitle: _data!.subtitle,
      saldo: _data!.saldo,
      pemasukan: _data!.pemasukan,
      pengeluaran: _data!.pengeluaran,
      weeklyIncome: List<double>.from(_data!.weeklyIncome),
      days: List<String>.from(_data!.days),
      transactions: _data!.transactions.where((item) => item.id != id).toList(),
    );
    notifyListeners();
  }
}
