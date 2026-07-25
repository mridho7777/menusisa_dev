import 'package:flutter/material.dart';

class MerchantRowData {
  final String no;
  final String id;
  final String shop;
  final String owner;
  final String email;
  final String phone;
  final String status;
  final String date;
  final String products;
  final String sales;

  const MerchantRowData(
    this.no,
    this.id,
    this.shop,
    this.owner,
    this.email,
    this.phone,
    this.status,
    this.date,
    this.products,
    this.sales,
  );
}

class MerchantDataTableSection extends StatelessWidget {
  const MerchantDataTableSection({
    super.key,
    required this.rows,
    this.compact = false,
    required this.onAction,
  });

  final List<MerchantRowData> rows;
  final bool compact;
  final Function(String, String) onAction; // (action, merchantId)

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Daftar Merchant',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              'Menampilkan 1 - ${rows.length} dari ${rows.length} data',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              const Color(0xFFF9FAFB),
            ),
            headingTextStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
            ),
            dataTextStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xFF111827),
            ),
            columnSpacing: 24,
            horizontalMargin: 16,
            dataRowMinHeight: 56,
            dataRowMaxHeight: 56,
            columns: const [
              DataColumn(label: Text('No.')),
              DataColumn(label: Text('ID Merchant')),
              DataColumn(label: Text('Nama Toko')),
              DataColumn(label: Text('Pemilik')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('No. HP')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Tanggal Daftar')),
              DataColumn(label: Text('Total Produk')),
              DataColumn(label: Text('Total Penjualan')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: rows.map((row) {
              return DataRow(
                cells: [
                  DataCell(Text(row.no)),
                  DataCell(Text(row.id.length > 8 ? '${row.id.substring(0, 8)}...' : row.id)),
                  DataCell(
                    Text(
                      row.shop,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  DataCell(Text(row.owner)),
                  DataCell(Text(row.email)),
                  DataCell(Text(row.phone)),
                  DataCell(_StatusBadge(status: row.status)),
                  DataCell(Text(row.date.split('T').first)), // Hanya ambil tanggalnya
                  DataCell(Text(row.products)),
                  DataCell(
                    Text(
                      row.sales,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F8D55),
                      ),
                    ),
                  ),
                  DataCell(
                    _ActionMenu(
                      merchantId: row.id,
                      status: row.status,
                      onAction: onAction,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        const _PaginationControls(),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color color;
    final Color bg;

    if (status.toLowerCase() == 'approved' || status.toLowerCase() == 'active') {
      label = 'Aktif';
      color = const Color(0xFF0F8D55);
      bg = const Color(0xFFD1FAE5);
    } else if (status.toLowerCase() == 'pending') {
      label = 'Pending';
      color = const Color(0xFFF59E0B);
      bg = const Color(0xFFFEF3C7);
    } else if (status.toLowerCase() == 'suspended') {
      label = 'Suspend';
      color = const Color(0xFF7C3AED);
      bg = const Color(0xFFEDE9FE);
    } else if (status.toLowerCase() == 'rejected' || status.toLowerCase() == 'inactive') {
      label = 'Nonaktif';
      color = const Color(0xFFEF4444);
      bg = const Color(0xFFFEE2E2);
    } else {
      label = status;
      color = const Color(0xFF6B7280);
      bg = const Color(0xFFF3F4F6);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ActionMenu extends StatelessWidget {
  const _ActionMenu({
    required this.merchantId,
    required this.status,
    required this.onAction,
  });

  final String merchantId;
  final String status;
  final Function(String, String) onAction;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      offset: const Offset(0, 40),
      onSelected: (action) => onAction(action, merchantId),
      itemBuilder: (context) {
        final isPending = status.toLowerCase() == 'pending';
        
        return [
          _buildMenuItem(Icons.visibility_rounded, 'Detail Merchant', 'detail'),
          _buildMenuItem(Icons.edit_rounded, 'Edit Merchant', 'edit'),
          
          if (isPending) ...[
            const PopupMenuDivider(),
            _buildMenuItem(Icons.verified_rounded, 'Approve Merchant', 'approve'),
            _buildMenuItem(Icons.cancel_rounded, 'Reject Merchant', 'reject', isDestructive: true),
          ],
          
          if (!isPending) ...[
            _buildMenuItem(Icons.shopping_bag_rounded, 'Lihat Produk', 'products'),
            _buildMenuItem(Icons.block_rounded, 'Suspend Merchant', 'suspend'),
            _buildMenuItem(Icons.notifications_rounded, 'Kirim Notifikasi', 'notify'),
            const PopupMenuDivider(),
            _buildMenuItem(Icons.delete_rounded, 'Hapus Merchant', 'delete', isDestructive: true),
          ]
        ];
      },
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    IconData icon,
    String label,
    String value, {
    bool isDestructive = false,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              '10 / halaman',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_drop_down, size: 18),
            ),
          ],
        ),
        Row(
          children: [
            _PageButton(
              icon: Icons.chevron_left_rounded,
              onPressed: () {},
            ),
            ...[1].map((page) {
              return _PageButton(
                label: '$page',
                isActive: page == 1,
                onPressed: () {},
              );
            }),
            _PageButton(
              icon: Icons.chevron_right_rounded,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    this.label,
    this.icon,
    this.isActive = false,
    required this.onPressed,
  });

  final String? label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isActive ? const Color(0xFF0F8D55) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: isActive ? null : Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: icon != null
                ? Icon(icon, size: 18, color: isActive ? Colors.white : const Color(0xFF6B7280))
                : Text(
                    label!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : const Color(0xFF374151),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
