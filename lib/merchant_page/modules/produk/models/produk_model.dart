import 'dart:typed_data';

// Supabase Integration:
// Table: products
// Columns: id (uuid/text PK), merchant_id (uuid FK), name (text), category (text),
//          description (text), price (numeric), original_price (numeric),
//          discount_price (numeric), stock (integer), sold_count (integer),
//          unit (text), is_active (boolean), image_url (text), image_path (text),
//          created_at (timestamp), updated_at (timestamp)
// 
// Sample query:
// final response = await supabase
//   .from('products')
//   .select()
//   .eq('merchant_id', merchantId)
//   .order('created_at', ascending: false);
//
// Insert:
// await supabase.from('products').insert({
//   'merchant_id': merchantId,
//   'name': nama,
//   'category': kategori,
//   'price': harga,
//   'stock': stok,
//   'is_active': status,
//   ...
// });

class ProdukModel {
  final String id;
  final String nama;
  final String kategori;
  final double harga;
  final double? hargaAsli;
  final double? hargaDiskon;
  final int stok;
  final int terjual;
  final bool status;
  final String? gambar;
  final String? gambarPath;
  final Uint8List? gambarBytes;
  final String? deskripsi;
  final String? satuan;

  ProdukModel({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    this.hargaAsli,
    this.hargaDiskon,
    required this.stok,
    required this.terjual,
    required this.status,
    this.gambar,
    this.gambarPath,
    this.gambarBytes,
    this.deskripsi,
    this.satuan,
  });

  ProdukModel copyWith({
    String? id,
    String? nama,
    String? kategori,
    double? harga,
    double? hargaAsli,
    double? hargaDiskon,
    int? stok,
    int? terjual,
    bool? status,
    String? gambar,
    String? gambarPath,
    Uint8List? gambarBytes,
    String? deskripsi,
    String? satuan,
  }) {
    return ProdukModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kategori: kategori ?? this.kategori,
      harga: harga ?? this.harga,
      hargaAsli: hargaAsli ?? this.hargaAsli,
      hargaDiskon: hargaDiskon ?? this.hargaDiskon,
      stok: stok ?? this.stok,
      terjual: terjual ?? this.terjual,
      status: status ?? this.status,
      gambar: gambar ?? this.gambar,
      gambarPath: gambarPath ?? this.gambarPath,
      gambarBytes: gambarBytes ?? this.gambarBytes,
      deskripsi: deskripsi ?? this.deskripsi,
      satuan: satuan ?? this.satuan,
    );
  }
}
