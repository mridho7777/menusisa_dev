import 'package:flutter/material.dart';
import '../models/produk_model.dart';
import '../services/produk_service.dart';

class MerchantProdukController extends ChangeNotifier {
  final ProdukService _produkService = ProdukService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _showListView = false;
  bool get showListView => _showListView;

  final _introData = IntroData(
    title: 'Kelola Produk Anda',
    description: 'Tambah, edit, dan kelola produk yang akan dijual. Produk yang disetujui super admin akan tampil di aplikasi customer.',
  );
  IntroData get data => _introData;

  List<ProdukModel> _allData = [];
  List<ProdukModel> _visibleData = [];
  List<ProdukModel> get visibleData => _visibleData;
  int get totalData => _visibleData.length;

  int _currentPage = 1;
  int get currentPage => _currentPage;
  int get totalPages => _visibleData.isEmpty ? 1 : ((_visibleData.length - 1) ~/ 6) + 1;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  String _selectedKategori = 'Semua Kategori';
  String get selectedKategori => _selectedKategori;
  String _selectedSort = 'Terbaru';
  String get selectedSort => _selectedSort;
  List<String> get kategoriOptions => _produkService.fetchKategoriOptions();

  MerchantProdukController() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    _allData = await _produkService.fetchProdukData();
    _currentPage = _currentPage.clamp(1, totalPages);
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  void showProductList() {
    _showListView = true;
    notifyListeners();
  }

  void hideProductList() {
    _showListView = false;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }

  void setKategori(String value) {
    _selectedKategori = value;
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }

  void setSort(String value) {
    _selectedSort = value;
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }

  void goToPage(int page) {
    _currentPage = page.clamp(1, totalPages);
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    Iterable<ProdukModel> items = _allData;

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      items = items.where((item) => item.nama.toLowerCase().contains(query));
    }

    if (_selectedKategori != 'Semua Kategori') {
      items = items.where((item) => item.kategori == _selectedKategori);
    }

    final sorted = items.toList();
    switch (_selectedSort) {
      case 'Nama A-Z':
        sorted.sort((a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));
        break;
      case 'Harga Tertinggi':
        sorted.sort((a, b) => b.harga.compareTo(a.harga));
        break;
      case 'Harga Terendah':
        sorted.sort((a, b) => a.harga.compareTo(b.harga));
        break;
      case 'Terbaru':
      default:
        break;
    }

    final start = (_currentPage - 1) * 6;
    _visibleData = sorted.skip(start).take(6).toList();
  }

  ProdukModel? getProductById(String id) {
    for (final item in _allData) {
      if (item.id == id) return item;
    }
    return null;
  }

  Future<bool> addProduct(ProdukModel product, {String? merchantId}) async {
    final ok = await _produkService.createProduct({
      'product_code': product.id,
      'merchant_id': merchantId,
      'name': product.nama,
      'category_name': product.kategori,
      'description': product.deskripsi,
      'price': product.harga,
      'original_price': product.hargaAsli ?? product.harga,
      'stock': product.stok,
      'tag': product.satuan,
      'is_active': product.status,
      'image_url': product.gambar,
      'image_bytes': product.gambarBytes,
      'image_file_name': product.gambarPath ?? product.gambar,
    });
    if (ok) await loadData();
    return ok;
  }

  Future<bool> updateProduct(ProdukModel product, {String? merchantId}) async {
    final ok = await _produkService.updateProduct(product.id, {
      'name': product.nama,
      'category_name': product.kategori,
      'description': product.deskripsi,
      'price': product.harga,
      'original_price': product.hargaAsli ?? product.harga,
      'stock': product.stok,
      'tag': product.satuan,
      'is_active': product.status,
      'image_url': product.gambar,
      'image_bytes': product.gambarBytes,
      'image_file_name': product.gambarPath ?? product.gambar,
    });
    if (ok) await loadData();
    return ok;
  }

  Future<bool> deleteProduct(String id) async {
    final ok = await _produkService.deleteProduct(id);
    if (ok) await loadData();
    return ok;
  }

  Future<bool> toggleStatus(String id) async {
    final product = getProductById(id);
    if (product == null) return false;
    final ok = await _produkService.updateProduct(id, {'is_active': !product.status});
    if (ok) await loadData();
    return ok;
  }

  Future<bool> submitForApproval(String id) async {
    final ok = await _produkService.updateProduct(id, {
      'approval_status': 'pending',
      'is_active': true,
    });
    if (ok) await loadData();
    return ok;
  }
}

class IntroData {
  final String title;
  final String description;

  IntroData({required this.title, required this.description});
}


