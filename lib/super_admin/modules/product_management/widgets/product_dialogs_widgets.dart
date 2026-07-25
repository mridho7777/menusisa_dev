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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1200),
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
          ),
          columnWidths: const {
            0: FixedColumnWidth(50),
            1: FixedColumnWidth(200),
            2: FixedColumnWidth(150),
            3: FixedColumnWidth(120),
            4: FixedColumnWidth(100),
            5: FixedColumnWidth(80),
            6: FixedColumnWidth(100),
            7: FixedColumnWidth(80),
            8: FixedColumnWidth(120),
            9: FixedColumnWidth(180),
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
              ),
              children: [
                _TableHeaderCell(label: 'No'),
                _TableHeaderCell(label: 'Nama Produk'),
                _TableHeaderCell(label: 'Merchant'),
                _TableHeaderCell(label: 'Kategori'),
                _TableHeaderCell(label: 'Harga'),
                _TableHeaderCell(label: 'Stok'),
                _TableHeaderCell(label: 'Status'),
                _TableHeaderCell(label: 'Terjual'),
                _TableHeaderCell(label: 'Tanggal'),
                _TableHeaderCell(label: 'Aksi'),
              ],
            ),
            ...items.map((item) {
              final isLow = item.status == 'Rendah';
              final active = item.status == 'Aktif';
              return TableRow(
                children: [
                  _TableCell(child: Text(item.id, style: const TextStyle(fontSize: 12.5))),
                  _TableCell(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _TableCell(child: Text(item.merchant, style: const TextStyle(fontSize: 12.5))),
                  _TableCell(child: Text(item.category, style: const TextStyle(fontSize: 12.5))),
                  _TableCell(child: Text(item.price, style: const TextStyle(fontSize: 12.5))),
                  _TableCell(
                    child: Text(
                      item.stock.toString(),
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isLow ? const Color(0xFFEF4444) : const Color(0xFF111827),
                        fontWeight: isLow ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  _TableCell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFFE7F8EC)
                            : isLow
                            ? const Color(0xFFFEF2F2)
                            : const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.status,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: active
                              ? const Color(0xFF16A34A)
                              : isLow
                              ? const Color(0xFFEF4444)
                              : const Color(0xFFF59E0B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  _TableCell(child: Text(item.sold.toString(), style: const TextStyle(fontSize: 12.5))),
                  _TableCell(child: Text(item.createdAt, style: const TextStyle(fontSize: 12.5))),
                  _TableCell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => onView(item),
                          icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => onEdit(item),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => onToggle(item),
                          icon: Icon(
                            active ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
                            size: 22,
                            color: active ? const Color(0xFF16A34A) : const Color(0xFFF59E0B),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => onDelete(item),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                            color: Color(0xFFEF4444),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  const _TableHeaderCell({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF374151),
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: child,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _DetailRow(label: 'ID Produk', value: product.id),
            _DetailRow(label: 'Nama Produk', value: product.name),
            _DetailRow(label: 'Merchant', value: product.merchant),
            _DetailRow(label: 'Kategori', value: product.category),
            _DetailRow(label: 'Harga', value: product.price),
            _DetailRow(label: 'Stok', value: product.stock.toString()),
            _DetailRow(label: 'Status', value: product.status),
            _DetailRow(label: 'Terjual', value: product.sold.toString()),
            _DetailRow(label: 'Dibuat', value: product.createdAt),
            _DetailRow(label: 'Deskripsi', value: product.description),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ),
          ],
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama Produk',
                hintText: product.name,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Harga',
                hintText: product.price,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Stok',
                hintText: product.stock.toString(),
              ),
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

