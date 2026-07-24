import 'dart:typed_data';

import '../models/produk_model.dart';

class ProductRepository {
  ProductRepository();

  final List<ProdukModel> _products = [];

  List<String> categories() => const ['Makanan', 'Minuman', 'Dessert', 'Snack'];
  List<String> units() => const ['Porsi', 'Pcs', 'Box', 'Cup', 'Botol'];

  ProdukModel buildProduct({
    required String id,
    required String nama,
    required String kategori,
    required String deskripsi,
    required double hargaAsli,
    required double hargaDiskon,
    required int stok,
    required String satuan,
    required bool status,
    String? gambar,
    Uint8List? gambarBytes,
    int terjual = 0,
  }) {
    return ProdukModel(
      id: id,
      nama: nama,
      kategori: kategori,
      harga: hargaDiskon,
      hargaAsli: hargaAsli,
      hargaDiskon: hargaDiskon,
      stok: stok,
      terjual: terjual,
      status: status,
      gambar: gambar,
      gambarBytes: gambarBytes,
      deskripsi: deskripsi,
      satuan: satuan,
    );
  }

  Map<String, dynamic> toJson(ProdukModel item) {
    return {
      'id': item.id,
      'name': item.nama,
      'category': item.kategori,
      'description': item.deskripsi,
      'price': item.harga,
      'original_price': item.hargaAsli,
      'discount_price': item.hargaDiskon,
      'stock': item.stok,
      'sold_count': item.terjual,
      'unit': item.satuan,
      'is_active': item.status,
      'image_url': item.gambar,
      'image_bytes': item.gambarBytes,
    };
  }

  ProdukModel fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      id: (json['id'] ?? '') as String,
      nama: (json['name'] ?? json['nama'] ?? '') as String,
      kategori: (json['category'] ?? json['kategori'] ?? '') as String,
      harga: _toDouble(json['price'] ?? json['harga'] ?? json['discount_price']),
      hargaAsli: _toNullableDouble(json['original_price'] ?? json['harga_asli']),
      hargaDiskon: _toNullableDouble(json['discount_price'] ?? json['harga_diskon']),
      stok: _toInt(json['stock'] ?? json['stok']),
      terjual: _toInt(json['sold_count'] ?? json['terjual']),
      status: (json['is_active'] ?? json['status'] ?? true) as bool,
      gambar: json['image_url'] as String?,
      gambarBytes: json['image_bytes'] as Uint8List?,
      deskripsi: json['description'] as String? ?? json['deskripsi'] as String?,
      satuan: json['unit'] as String? ?? json['satuan'] as String?,
    );
  }

  Future<List<ProdukModel>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_products);
  }

  Future<ProdukModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _products.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<ProdukModel>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (query.trim().isEmpty) return List.unmodifiable(_products);

    final lowerQuery = query.toLowerCase();
    return _products.where((item) {
      return item.nama.toLowerCase().contains(lowerQuery) ||
          item.kategori.toLowerCase().contains(lowerQuery) ||
          (item.deskripsi ?? '').toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<List<ProdukModel>> filterByStatus(bool isActive) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _products.where((item) => item.status == isActive).toList();
  }

  Future<ProdukModel> create(ProdukModel item) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _products.insert(0, item);
    return item;
  }

  Future<ProdukModel> update(String id, ProdukModel item) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _products.indexWhere((value) => value.id == id);
    if (index != -1) {
      _products[index] = item;
    }
    return item;
  }

  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _products.removeWhere((item) => item.id == id);
  }

  Future<ProdukModel> toggleStatus(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _products.indexWhere((item) => item.id == id);
    if (index == -1) {
      throw Exception('Product not found');
    }

    final updated = _products[index].copyWith(status: !_products[index].status);
    _products[index] = updated;
    return updated;
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  double? _toNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
