import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductImageSelection {
  final Uint8List bytes;
  final String fileName;

  const ProductImageSelection({required this.bytes, required this.fileName});
}

class ProductImagePicker extends StatefulWidget {
  final ValueChanged<ProductImageSelection?> onImageSelected;
  final ProductImageSelection? initialImage;

  const ProductImagePicker({super.key, required this.onImageSelected, this.initialImage});

  @override
  State<ProductImagePicker> createState() => _ProductImagePickerState();
}

class _ProductImagePickerState extends State<ProductImagePicker> {
  final ImagePicker _picker = ImagePicker();
  ProductImageSelection? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(_selectedImage!.bytes, fit: BoxFit.cover),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFF0F6B43).withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF0F6B43), size: 28),
        ),
        const SizedBox(height: 6),
        const Text('Upload foto produk', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        const Text('PNG, JPG, WEBP', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
      ],
    );
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90, maxHeight: 1600, maxWidth: 1600);
    if (image == null) return;
    final bytes = await image.readAsBytes();
    final selection = ProductImageSelection(bytes: bytes, fileName: image.name);
    setState(() => _selectedImage = selection);
    widget.onImageSelected(selection);
  }
}
