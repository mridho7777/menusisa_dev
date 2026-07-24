import 'package:flutter/material.dart';

import '../models/produk_model.dart';
import 'product_image_picker.dart';
import 'product_repository.dart';
import 'product_validation.dart';

class ProductFormPage extends StatefulWidget {
  final ProdukModel? product;
  final VoidCallback onClose;
  final VoidCallback onCancel;
  final ValueChanged<ProdukModel> onSave;

  const ProductFormPage({
    super.key,
    this.product,
    required this.onClose,
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _repository = ProductRepository();
  late final TextEditingController _namaController;
  late final TextEditingController _deskripsiController;
  late final TextEditingController _hargaAsliController;
  late final TextEditingController _hargaDiskonController;
  late final TextEditingController _stokController;
  late String _kategori;
  late String _satuan;
  late bool _status;
  ProductImageSelection? _imageSelection;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _namaController = TextEditingController(text: product?.nama ?? '');
    _deskripsiController = TextEditingController(
      text: product?.deskripsi ?? '',
    );
    _hargaAsliController = TextEditingController(
      text: product?.hargaAsli?.toStringAsFixed(0) ?? '',
    );
    _hargaDiskonController = TextEditingController(
      text:
          product?.hargaDiskon?.toStringAsFixed(0) ??
          product?.harga.toStringAsFixed(0) ??
          '',
    );
    _stokController = TextEditingController(
      text: product?.stok.toString() ?? '0',
    );
    _kategori = product?.kategori ?? 'Makanan';
    _satuan = product?.satuan ?? 'Porsi';
    _status = product?.status ?? true;
    if (product?.gambarBytes != null) {
      _imageSelection = ProductImageSelection(
        bytes: product!.gambarBytes!,
        fileName: product.gambar ?? 'produk.png',
      );
    }

  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaAsliController.dispose();
    _hargaDiskonController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product == null
                              ? 'Tambah Produk'
                              : 'Edit Produk',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        InkWell(
                          onTap: widget.onClose,
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      '// Supabase plan: products table stores image_url, image_path, and merchant_id.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                    const SizedBox(height: 20),
                    Flexible(
                      child: SingleChildScrollView(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 840;
                            final formFields = Column(
                              children: [
                                _field(
                                  'Nama Produk',
                                  _namaController,
                                  validator: ProductValidation.validateName,
                                ),
                                const SizedBox(height: 12),
                                _field(
                                  'Deskripsi',
                                  _deskripsiController,
                                  maxLines: 3,
                                  validator:
                                      ProductValidation.validateDescription,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _field(
                                        'Harga Asli',
                                        _hargaAsliController,
                                        numeric: true,
                                        validator:
                                            ProductValidation.validatePrice,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _field(
                                        'Harga Diskon',
                                        _hargaDiskonController,
                                        numeric: true,
                                        validator:
                                            ProductValidation.validatePrice,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _field(
                                        'Stok',
                                        _stokController,
                                        numeric: true,
                                        validator:
                                            ProductValidation.validateStock,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _dropdownField(
                                        'Kategori',
                                        _kategori,
                                        _repository.categories(),
                                        (value) =>
                                            setState(() => _kategori = value),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _dropdownField(
                                        'Satuan',
                                        _satuan,
                                        _repository.units(),
                                        (value) =>
                                            setState(() => _satuan = value),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Status Produk'),
                                  subtitle: Text(
                                    _status ? 'Aktif' : 'Nonaktif',
                                  ),
                                  value: _status,
                                  onChanged: (value) =>
                                      setState(() => _status = value),
                                ),
                              ],
                            );
                            final imagePicker = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Foto Produk',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ProductImagePicker(
                                  initialImage: _imageSelection,
                                  onImageSelected: (selection) {
                                    setState(() => _imageSelection = selection);
                                  },
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _imageSelection?.fileName ??
                                      'Gambar tersimpan sementara di memory selama app berjalan',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            );
                            return isWide
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 2, child: formFields),
                                      const SizedBox(width: 20),
                                      Expanded(child: imagePicker),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      imagePicker,
                                      const SizedBox(height: 20),
                                      formFields,
                                    ],
                                  );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: widget.onCancel,
                          child: const Text('Batal'),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          onPressed: _submit,
                          child: Text(
                            widget.product == null
                                ? 'Simpan Produk'
                                : 'Perbarui Produk',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
    bool numeric = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: numeric ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _dropdownField(
    String label,
    String value,
    List<String> items,
    ValueChanged<String> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (newValue) {
        if (newValue != null) onChanged(newValue);
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSave(
      _repository.buildProduct(
        id: widget.product?.id ?? '',
        nama: _namaController.text.trim(),
        kategori: _kategori,
        deskripsi: _deskripsiController.text.trim(),
        hargaAsli: double.tryParse(_hargaAsliController.text) ?? 0,
        hargaDiskon: double.tryParse(_hargaDiskonController.text) ?? 0,
        stok: int.tryParse(_stokController.text) ?? 0,
        satuan: _satuan,
        status: _status,
        gambar: _imageSelection?.fileName ?? widget.product?.gambar,
        gambarBytes: _imageSelection?.bytes,
      ),
    );
  }
}

