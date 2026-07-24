class ProductValidation {
  static String? validateId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ID produk wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'ID minimal 3 karakter';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama produk wajib diisi';
    }
    if (value.length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Harga wajib diisi';
    }
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Harga harus lebih dari 0';
    }
    return null;
  }

  static String? validateStock(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Stok wajib diisi';
    }
    final stock = int.tryParse(value);
    if (stock == null || stock < 0) {
      return 'Stok tidak valid';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value != null && value.length > 500) {
      return 'Deskripsi maksimal 500 karakter';
    }
    return null;
  }
}
