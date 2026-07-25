import 'package:flutter/material.dart';

import '../models/profil_model.dart';
import '../services/profil_service.dart';

class MerchantProfilController extends ChangeNotifier {
  final ProfilService _service = ProfilService();
  late ProfilModel _data;
  bool _isLoading = true;

  ProfilModel get data => _data;
  bool get isLoading => _isLoading;

  MerchantProfilController() {
    // loadData(); // Dipanggil dari view setelah provider dibuat untuk menghindari masalah init
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    _data = await _service.fetchProfilData();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateRecord(String id, ProfileRecord record) async {
    // Optimistic update
    _data = ProfilModel(
      title: _data.title,
      subtitle: _data.subtitle,
      records: _data.records.map((item) => item.id == id ? record : item).toList()
    );
    notifyListeners();
    
    // Save to database
    await _service.updateProfilData(
      userId: id,
      fullName: record.name,
      phone: record.whatsapp,
    );
    
    // Reload to ensure consistency
    await loadData();
  }

  void addRecord(ProfileRecord record) {
    _data = ProfilModel(title: _data.title, subtitle: _data.subtitle, records: [record, ..._data.records]);
    notifyListeners();
  }

  void deleteRecord(String id) {
    _data = ProfilModel(title: _data.title, subtitle: _data.subtitle, records: _data.records.where((item) => item.id != id).toList());
    notifyListeners();
  }
}
