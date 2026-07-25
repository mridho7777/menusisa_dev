import 'package:flutter/material.dart';
import '../models/pesanan_model.dart';
import '../services/pesanan_service.dart';

class MerchantPesananController extends ChangeNotifier {
  final PesananService _service = PesananService();
  PesananModel? _data;
  bool _isLoading = false;

  PesananModel? get data => _data;
  bool get isLoading => _isLoading;

  void loadData() {
    _isLoading = true;
    notifyListeners();
    _data = _service.fetchPesananData();
    _isLoading = false;
    notifyListeners();
  }
}
