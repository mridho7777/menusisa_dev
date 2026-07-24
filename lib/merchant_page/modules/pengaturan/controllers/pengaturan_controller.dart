import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../notifikasi/controllers/notifikasi_controller.dart';

import '../moduler/operational_day_model.dart';
import '../moduler/payment_method_model.dart';
import '../moduler/notification_setting_model.dart';
import '../models/pengaturan_model.dart';
import '../services/pengaturan_service.dart';

class MerchantPengaturanController extends ChangeNotifier {
  static PengaturanModel? _cachedData;
  static List<OperationalDayModel>? _cachedSchedule;
  static List<PaymentMethodModel>? _cachedPayments;
  static List<NotificationSettingModel>? _cachedNotifications;

  final PengaturanService _service = PengaturanService();
  PengaturanModel? _data;
  bool _isLoading = false;
  bool _showForm = false;
  int _selectedTabIndex = 0;

  final formKey = GlobalKey<FormState>();
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController storeDescriptionController = TextEditingController();
  final TextEditingController storeAddressController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final List<TextEditingController> openTimeControllers = [];
  final List<TextEditingController> closeTimeControllers = [];

  List<OperationalDayModel> _operationalDays = [];
  List<PaymentMethodModel> _paymentMethods = [];
  List<NotificationSettingModel> _notificationSettings = [];

  
  String photoLabel = 'Kopi Kita';
  String bannerLabel = 'Banner Toko';

  PengaturanModel? get data => _data;
  bool get isLoading => _isLoading;
  bool get showForm => _showForm;
  int get selectedTabIndex => _selectedTabIndex;
  List<OperationalDayModel> get operationalDays => _operationalDays;
  List<PaymentMethodModel> get paymentMethods => _paymentMethods;
  List<NotificationSettingModel> get notificationSettings => _notificationSettings;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    if (_cachedData == null) {
      _data = await _service.fetchPengaturanData();
    } else {
      _data = _cachedData;
    }
    _operationalDays = _cachedSchedule ?? _defaultOperationalDays();
    _paymentMethods = _cachedPayments ?? _defaultPaymentMethods();
    _notificationSettings = _cachedNotifications ?? _defaultNotificationSettings();
    _syncControllersFromData();
    _isLoading = false;
    notifyListeners();
  }

  void openForm() {
    _showForm = true;
    notifyListeners();
  }

  void backToOverview() {
    _showForm = false;
    notifyListeners();
  }

  void setTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void toggleNotificationSetting(int index, bool value, [MerchantNotifikasiController? notifController]) {
    if (index < 0 || index >= _notificationSettings.length) return;
    _notificationSettings[index] = _notificationSettings[index].copyWith(isActive: value);
    notifController?.addNotification(title: 'Pengaturan Notifikasi Diubah', description: 'Pengaturan ${_notificationSettings[index].label} diubah menjadi ${value ? 'Aktif' : 'Nonaktif'}.', iconKey: 'settings');
    notifyListeners();
  }

  void updatePhotoLabel([MerchantNotifikasiController? notifController]) {
    photoLabel = 'Foto Diperbarui';
    notifController?.addNotification(title: 'Foto Profil Diperbarui', description: 'Foto profil toko berhasil diubah.', iconKey: 'settings');
    notifyListeners();
  }

  void updateBannerLabel([MerchantNotifikasiController? notifController]) {
    bannerLabel = 'Banner Diperbarui';
    notifController?.addNotification(title: 'Banner Toko Diperbarui', description: 'Banner toko berhasil diubah.', iconKey: 'settings');
    notifyListeners();
  }

  void updateOperationalDay(int index, {String? openTime, String? closeTime, bool? isActive}) {
    if (index < 0 || index >= _operationalDays.length) return;
    _operationalDays[index] = _operationalDays[index].copyWith(
      openTime: openTime,
      closeTime: closeTime,
      isActive: isActive,
    );
    notifyListeners();
  }

  void togglePaymentMethod(int index, bool value) {
    if (index < 0 || index >= _paymentMethods.length) return;
    final activeCount = _paymentMethods.where((p) => p.isActive).length;
    if (!value && activeCount <= 1) {
      return;
    }
    _paymentMethods[index] = _paymentMethods[index].copyWith(isActive: value);
    notifyListeners();
  }

  void addPaymentMethod(String name, String iconKey, [MerchantNotifikasiController? notifController]) {
    final newId = 'PM-${DateTime.now().millisecondsSinceEpoch}';
    _paymentMethods.add(PaymentMethodModel(id: newId, name: name, iconKey: iconKey, isActive: true));
    notifController?.addNotification(title: 'Metode Pembayaran Ditambahkan', description: 'Metode pembayaran $name (ID ${newId.substring(newId.length - 6)}) berhasil ditambahkan.', iconKey: 'check');
    notifyListeners();
  }

  void deletePaymentMethod(int index, [MerchantNotifikasiController? notifController]) {
    if (index < 0 || index >= _paymentMethods.length) return;
    final activeCount = _paymentMethods.where((p) => p.isActive).length;
    if (_paymentMethods[index].isActive && activeCount <= 1) {
      return;
    }
    final name = _paymentMethods[index].name;
    _paymentMethods.removeAt(index);
    notifController?.addNotification(title: 'Metode Pembayaran Dihapus', description: 'Metode pembayaran $name telah dihapus.', iconKey: 'close');
    notifyListeners();
  }

  String? validateDayTimes(int index) {
    if (index < 0 || index >= _operationalDays.length) return null;
    final day = _operationalDays[index];
    if (!day.isActive) return null;
    final open = _parseMinutes(day.openTime);
    final close = _parseMinutes(day.closeTime);
    if (open == null || close == null) {
      return 'Format jam harus HH:mm';
    }
    if (open >= close) {
      return 'Jam buka harus lebih kecil dari jam tutup';
    }
    return null;
  }

  Future<bool> saveChanges([MerchantNotifikasiController? notifController]) async {
    final form = formKey.currentState;
    if (form == null || !form.validate()) return false;

    for (var i = 0; i < _operationalDays.length; i++) {
      final error = validateDayTimes(i);
      if (error != null) {
        return false;
      }
    }

    final activePayments = _paymentMethods.where((p) => p.isActive).length;
    if (activePayments < 1) {
      return false;
    }

    final currentData = _data;
    if (currentData == null) return false;

    _data = currentData.copyWith(
      storeName: storeNameController.text.trim(),
      storeDescription: storeDescriptionController.text.trim(),
      storeAddress: storeAddressController.text.trim(),
      whatsapp: whatsappController.text.trim(),
      email: emailController.text.trim(),
      
      photoLabel: photoLabel,
      bannerLabel: bannerLabel,
    );
    _cachedData = _data;
    _cachedSchedule = _operationalDays.map((day) => day.copyWith()).toList();
    _cachedNotifications = _notificationSettings.map((n) => n.copyWith()).toList();
    _cachedPayments = _paymentMethods.map((pm) => pm.copyWith()).toList();
    notifController?.addNotification(title: 'Pengaturan Toko Disimpan', description: 'Perubahan pengaturan toko berhasil disimpan.', iconKey: 'settings');
    await _saveToSupabase();
    notifyListeners();
    return true;
  }


  Future<void> _saveToSupabase() async {
    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user != null) {
        await _service.updatePengaturanData(
          userId: user.id,
          storeName: storeNameController.text.trim(),
          storeDescription: storeDescriptionController.text.trim(),
          storeAddress: storeAddressController.text.trim(),
          whatsapp: whatsappController.text.trim(),
        );
      }
    } catch (e) {
      // Handle error silently or show error
    }
  }
  void _syncControllersFromData() {
    final current = _data;
    if (current == null) return;
    storeNameController.text = current.storeName;
    storeDescriptionController.text = current.storeDescription;
    storeAddressController.text = current.storeAddress;
    whatsappController.text = current.whatsapp;
    emailController.text = current.email;
    
    photoLabel = current.photoLabel;
    bannerLabel = current.bannerLabel;
    _rebuildOperationalControllers();
  }

  void _rebuildOperationalControllers() {
    for (final controller in openTimeControllers) {
      controller.dispose();
    }
    for (final controller in closeTimeControllers) {
      controller.dispose();
    }
    openTimeControllers.clear();
    closeTimeControllers.clear();
    for (final day in _operationalDays) {
      openTimeControllers.add(TextEditingController(text: day.openTime));
      closeTimeControllers.add(TextEditingController(text: day.closeTime));
    }
  }

  List<OperationalDayModel> _defaultOperationalDays() {
    return [
      OperationalDayModel(day: 'Senin', openTime: '08:00', closeTime: '21:00', isActive: true),
      OperationalDayModel(day: 'Selasa', openTime: '08:00', closeTime: '21:00', isActive: true),
      OperationalDayModel(day: 'Rabu', openTime: '08:00', closeTime: '21:00', isActive: true),
      OperationalDayModel(day: 'Kamis', openTime: '08:00', closeTime: '21:00', isActive: true),
      OperationalDayModel(day: 'Jumat', openTime: '08:00', closeTime: '22:00', isActive: true),
      OperationalDayModel(day: 'Sabtu', openTime: '08:00', closeTime: '22:00', isActive: true),
      OperationalDayModel(day: 'Minggu', openTime: '08:00', closeTime: '20:00', isActive: true),
    ];
  }

  List<NotificationSettingModel> _defaultNotificationSettings() {
    return [
      NotificationSettingModel(id: 'N-001', label: 'Pesanan baru masuk', isActive: true),
      NotificationSettingModel(id: 'N-002', label: 'Pesanan diproses', isActive: true),
      NotificationSettingModel(id: 'N-003', label: 'Pesanan siap diambil', isActive: true),
      NotificationSettingModel(id: 'N-004', label: 'Pesanan selesai', isActive: true),
      NotificationSettingModel(id: 'N-005', label: 'Stok hampir habis', isActive: true),
      NotificationSettingModel(id: 'N-006', label: 'Promo akan berakhir', isActive: true),
    ];
  }

  List<PaymentMethodModel> _defaultPaymentMethods() {
    return [
      PaymentMethodModel(id: 'PM-001', name: 'Tunai', iconKey: 'cash', isActive: true),
      PaymentMethodModel(id: 'PM-002', name: 'QRIS', iconKey: 'qr', isActive: true),
      PaymentMethodModel(id: 'PM-003', name: 'Transfer Bank', iconKey: 'bank', isActive: true),
      PaymentMethodModel(id: 'PM-004', name: 'E-Wallet (OVO, GoPay, DANA)', iconKey: 'wallet', isActive: false),
    ];
  }

  int? _parseMinutes(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);
    if (hours == null || minutes == null || hours < 0 || hours > 23 || minutes < 0 || minutes > 59) return null;
    return hours * 60 + minutes;
  }

  @override
  void dispose() {
    storeNameController.dispose();
    storeDescriptionController.dispose();
    storeAddressController.dispose();
    whatsappController.dispose();
    emailController.dispose();
    for (final controller in openTimeControllers) {
      controller.dispose();
    }
    for (final controller in closeTimeControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

