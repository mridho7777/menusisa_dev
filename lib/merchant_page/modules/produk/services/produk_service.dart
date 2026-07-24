import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/produk_model.dart';

class ProdukService {
  final _client = Supabase.instance.client;

  Future<List<ProdukModel>> fetchProdukData() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    try {
      final merchant = await _client
          .from('merchants')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();
      if (merchant == null) return [];

      final data = await _client
          .from('products')
          .select(
            'id, product_code, merchant_id, name, category_id, categories(name), description, price, original_price, stock, tag, approval_status, is_active, created_at, updated_at, product_images(image_url, is_primary)',
          )
          .eq('merchant_id', merchant['id'])
          .order('created_at', ascending: false);

      return data.map<ProdukModel>((row) {
        final category = row['categories'] as Map<String, dynamic>?;
        String? imageUrl;
        Uint8List? imageBytes;
        final images = row['product_images'] as List<dynamic>?;
        String? imagePath;
        if (images != null && images.isNotEmpty) {
          final primary = images.firstWhere(
            (img) => img['is_primary'] == true,
            orElse: () => images.first,
          );
          imageUrl = primary['image_url']?.toString();
          imageBytes = _decodeImageBytes(imageUrl);
        }
        return ProdukModel(
          id: row['id']?.toString() ?? '',
          nama: row['name']?.toString() ?? '',
          kategori: category?['name']?.toString() ?? '',
          harga: (row['price'] ?? 0).toDouble(),
          hargaAsli: (row['original_price'] ?? row['price'] ?? 0).toDouble(),
          hargaDiskon: null,
          stok: row['stock'] ?? 0,
          terjual: 0,
          status: row['is_active'] ?? true,
          gambar: imageUrl,
          gambarPath: imagePath,
          gambarBytes: imageBytes,
          deskripsi: row['description']?.toString(),
          satuan: row['tag']?.toString(),
        );
      }).toList();
    } catch (e, s) {
      debugPrint('? ProdukService fetchProdukData error: $e\n$s');
      return [];
    }
  }

  Future<String?> _ensureMerchantId(User user) async {
    try {
      final existingRows = await _client
          .from('merchants')
          .select('id, created_at')
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(1);
      if (existingRows is List && existingRows.isNotEmpty) {
        final existing = existingRows.first as Map<String, dynamic>;
        final existingId = existing['id']?.toString();
        if (existingId != null && existingId.isNotEmpty) return existingId;
      }

      final profileName = await _client
          .from('users')
          .select('full_name')
          .eq('id', user.id)
          .maybeSingle();
      final fallbackName = (profileName?['full_name']?.toString().trim().isNotEmpty ?? false)
          ? profileName!['full_name'].toString().trim()
          : (user.email?.split('@').first ?? 'Toko Saya');

      final createdRows = await _client
          .from('merchants')
          .insert({
            'user_id': user.id,
            'shop_name': fallbackName,
            'shop_address': '-',
            'approval_status': 'approved',
            'is_active': true,
          })
          .select('id')
          .limit(1);
      if (createdRows is List && createdRows.isNotEmpty) {
        return (createdRows.first as Map<String, dynamic>)['id']?.toString();
      }
      return null;
    } catch (e) {
      debugPrint('?? createProduct: ensure merchant failed: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _resolveCategory(String categoryName) async {
    if (categoryName.trim().isEmpty) return null;
    final normalized = categoryName.trim();
    try {
      final direct = await _client
          .from('categories')
          .select('id, name')
          .eq('name', normalized)
          .maybeSingle();
      if (direct != null) return direct;
      final slugMatch = await _client
          .from('categories')
          .select('id, name')
          .ilike('name', normalized)
          .maybeSingle();
      if (slugMatch != null) return slugMatch;
      final fallback = await _client
          .from('categories')
          .select('id, name')
          .limit(1)
          .maybeSingle();
      return fallback;
    } catch (e) {
      debugPrint('? ProdukService _resolveCategory error: $e');
      return null;
    }
  }

  Future<void> _deleteStorageFile(String? path) async {
    if (path == null || path.trim().isEmpty) return;
    try {
      await _client.storage.from('product-images').remove([path.trim()]);
      debugPrint('? Storage file deleted: $path');
    } catch (e) {
      debugPrint('?? Failed to delete storage file $path: $e');
    }
  }

  Future<Map<String, String>?> _uploadImageIfNeeded(
    Uint8List? bytes,
    String? fileName,
  ) async {
    if (bytes == null || bytes.isEmpty) return null;
    const bucketNames = ['product-images', 'product_images'];
    final safeName = (fileName == null || fileName.trim().isEmpty)
        ? 'product.jpg'
        : fileName.trim();
    final extension = safeName.toLowerCase().endsWith('.png')
        ? 'png'
        : safeName.toLowerCase().endsWith('.webp')
        ? 'webp'
        : 'jpg';
    final path =
        'merchant-products/${DateTime.now().millisecondsSinceEpoch}.$extension';

    for (final bucketName in bucketNames) {
      try {
        final bucket = _client.storage.from(bucketName);
        await bucket.uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: extension == 'png'
                ? 'image/png'
                : extension == 'webp'
                ? 'image/webp'
                : 'image/jpeg',
          ),
        );
        return {'url': bucket.getPublicUrl(path), 'path': path};
      } catch (e) {
        debugPrint('? upload image failed for bucket $bucketName: $e');
      }
    }

    return null;
  }

  Future<bool> createProduct(Map<String, dynamic> data) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        debugPrint('? createProduct: user not authenticated');
        return false;
      }
      final merchantId = await _ensureMerchantId(user);
      if (merchantId == null || merchantId.isEmpty) {
        debugPrint('? createProduct: merchant id missing for user ${user.id}');
        return false;
      }

      final categoryName = (data['category_name'] ?? data['category_id'] ?? '')
          .toString();
      final category = await _resolveCategory(categoryName);
      if (category == null) {
        debugPrint('? createProduct: category not found for "$categoryName"');
        return false;
      }

      final imageBytes = data['image_bytes'] as Uint8List?;
      final imageFileName = data['image_file_name']?.toString();
      final uploadedImage = await _uploadImageIfNeeded(
        imageBytes,
        imageFileName,
      );
      debugPrint('createProduct upload result: $uploadedImage');
      if (imageBytes != null && imageBytes.isNotEmpty && uploadedImage == null) {
        debugPrint('?? createProduct: image upload failed');
        return false;
      }
      final imageUrl = uploadedImage?['url'] ?? data['image_url']?.toString();

      final inserted = await _client
          .from('products')
          .insert({
            "product_code": data['product_code'] ?? data['id'],
            "merchant_id": merchantId,
            "category_id": category['id'],
            "name": data['name'],
            "description": data['description'],
            "price": data['price'],
            "original_price": data['original_price'] ?? data['price'],
            "stock": data['stock'],
            "tag": data['tag'],
            "is_active": data['is_active'] ?? true,
            "approval_status": 'pending',
          })
          .select('id, product_code, approval_status, is_active')
          .single();

      final productId = inserted['id']?.toString();
      debugPrint('? createProduct: product inserted id=$productId');

      if (imageUrl != null && imageUrl.isNotEmpty && productId != null) {
        try {
          await _client.from('product_images').insert({
            'product_id': productId,
            'image_url': imageUrl,
            'is_primary': true,
            'display_order': 0,
          });
        } catch (imgErr, s) {
          debugPrint('?? createProduct: image insert failed: $imgErr\n$s');
          return false;
        }
      }

      return true;
    } catch (e, s) {
      debugPrint('? createProduct error: $e\n$s');
      return false;
    }
  }

  Future<bool> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final categoryName = (data['category_name'] ?? data['category_id'] ?? '')
          .toString();
      final category = await _resolveCategory(categoryName);
      if (category == null) {
        debugPrint('? updateProduct: category not found for "$categoryName"');
        return false;
      }

      await _client
          .from('products')
          .update({
            "name": data['name'],
            "category_id": category['id'],
            "description": data['description'],
            "price": data['price'],
            "original_price": data['original_price'] ?? data['price'],
            "stock": data['stock'],
            "tag": data['tag'],
            "is_active": data['is_active'] ?? true,
            "approval_status": data['approval_status'] ?? 'pending',
          })
          .eq('id', id);

      final imageBytes = data['image_bytes'] as Uint8List?;
      final imageFileName = data['image_file_name']?.toString();
      final uploadedImage = await _uploadImageIfNeeded(
        imageBytes,
        imageFileName,
      );
      debugPrint('createProduct upload result: $uploadedImage');
      if (imageBytes != null && imageBytes.isNotEmpty && uploadedImage == null) {
        debugPrint('?? createProduct: image upload failed');
        return false;
      }
      final imageUrl = uploadedImage?['url'] ?? data['image_url']?.toString();
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          final existing = await _client
              .from('product_images')
              .select('id')
              .eq('product_id', id)
              .maybeSingle();
          if (existing != null) {
            await _client
                .from('product_images')
                .update({'image_url': imageUrl})
                .eq('product_id', id);
          } else {
            await _client.from('product_images').insert({
              'product_id': id,
              'image_url': imageUrl,
              'is_primary': true,
              'display_order': 0,
            });
          }
        } catch (imgErr) {
          debugPrint('?? updateProduct: image update failed: $imgErr');
        }
      }

      debugPrint('? updateProduct: product $id updated');
      return true;
    } catch (e, s) {
      debugPrint('? updateProduct error: $e\n$s');
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      try {
        final existing = await _client
            .from('product_images')
            .select('id')
            .eq('product_id', id)
            .maybeSingle();
      } catch (err) {
        debugPrint('?? deleteProduct: failed to clean storage file: $err');
      }
      await _client.from('products').delete().eq('id', id);
      debugPrint('? deleteProduct: $id deleted');
      return true;
    } catch (e, s) {
      debugPrint('? deleteProduct error: $e\n$s');
      return false;
    }
  }

  List<String> fetchKategoriOptions() => [
    'Semua Kategori',
    'Makanan',
    'Minuman',
    'Dessert',
    'Snack',
  ];

  Uint8List? _decodeImageBytes(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.startsWith('data:image/')) {
      final comma = value.indexOf(',');
      if (comma == -1) return null;
      return base64Decode(value.substring(comma + 1));
    }
    return null;
  }
}



