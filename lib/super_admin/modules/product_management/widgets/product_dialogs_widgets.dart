import 'package:flutter/material.dart';

import '../models/product_management_models.dart';

class ProductTableCard extends StatelessWidget {
  const ProductTableCard({
    super.key,
    required this.items,
    required this.onView,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final List<ProductItem> items;
  final ValueChanged<ProductItem> onView;
  final ValueChanged<ProductItem> onEdit;
  final ValueChanged<ProductItem> onToggle;
  final ValueChanged<ProductItem> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...items.map((item) {
          final isLow = item.status == 'Rendah';
          final active = item.status == 'Aktif';
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text(item.id, style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    item.merchant,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Text(
                    item.category,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 86,
                  child: Text(item.price, style: const TextStyle(fontSize: 12)),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 12,
                      color: isLow
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF111827),
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: _StatusChip(
                    label: item.status,
                    color: active
                        ? const Color(0xFF16A34A)
                        : isLow
                        ? const Color(0xFFEF4444)
                        : const Color(0xFFF59E0B),
                  ),
                ),
                SizedBox(
                  width: 66,
                  child: Text('', style: const TextStyle(fontSize: 12)),
                ),
                SizedBox(
                  width: 98,
                  child: Text(
                    item.createdAt,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => onView(item),
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () => onEdit(item),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                      ),
                      IconButton(
                        onPressed: () => onToggle(item),
                        icon: Icon(
                          active
                              ? Icons.toggle_on_rounded
                              : Icons.toggle_off_rounded,
                          size: 22,
                          color: active
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                      IconButton(
                        onPressed: () => onDelete(item),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ProductDetailDialog extends StatelessWidget {
  const ProductDetailDialog({super.key, required this.product});

  final ProductItem product;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Detail Produk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const Divider(height: 24),
              _DetailRow(label: 'Nama Produk', value: product.name),
              _DetailRow(label: 'Merchant', value: product.merchant),
              _DetailRow(label: 'Kategori', value: product.category),
              _DetailRow(label: 'Harga', value: product.price),
              _DetailRow(label: 'Stok', value: ''),
              _DetailRow(label: 'Terjual', value: ''),
              _DetailRow(label: 'Deskripsi', value: product.description),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductEditDialog extends StatelessWidget {
  const ProductEditDialog({super.key, required this.product});

  final ProductItem product;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Edit Produk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const Divider(height: 24),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                controller: TextEditingController(text: product.name),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                controller: TextEditingController(text: product.price),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                controller: TextEditingController(text: product.description),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Simpan Perubahan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductConfirmDialog extends StatelessWidget {
  const ProductConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.primaryColor,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(primaryLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductFilterPanel extends StatelessWidget {
  const ProductFilterPanel({super.key, required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Lainnya',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const _FilterLine(label: 'Semua Merchant'),
          const _FilterLine(label: 'Semua Kategori'),
          const _FilterLine(label: 'Semua Status'),
          const _FilterLine(label: 'Tanggal Dibuat'),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onReset,
              child: const Text('Reset Filter'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterLine extends StatelessWidget {
  const _FilterLine({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        const Icon(
          Icons.check_box_outline_blank_rounded,
          size: 18,
          color: Color(0xFF0F8D55),
        ),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 12.5)),
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
