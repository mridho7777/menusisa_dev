import 'package:flutter/material.dart';

import '../models/dashboard_models.dart';

class DashboardTopSummary extends StatelessWidget {
  const DashboardTopSummary({
    super.key,
    required this.items,
    required this.sidebarCollapsed,
  });

  final List<DashboardPendingItem> items;
  final bool sidebarCollapsed;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: LayoutBuilder(
        key: ValueKey<bool>(sidebarCollapsed),
        builder: (context, constraints) {
          final crossAxisCount = 4;
          final itemHeight = sidebarCollapsed ? 88.0 : 96.0;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: itemHeight,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              final positive = item.actionLabel.startsWith('+');
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            item.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            item.actionLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: positive
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DashboardTableCard extends StatelessWidget {
  const DashboardTableCard({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.child,
    this.height,
  });

  final String title;
  final String actionLabel;
  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (actionLabel.isNotEmpty)
                Text(
                  actionLabel,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF0F8D55),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(child: SingleChildScrollView(child: child)),
        ],
      ),
    );

    if (height == null) {
      return card;
    }

    return SizedBox(height: height, child: card);
  }
}

class DashboardTransactionTable extends StatelessWidget {
  const DashboardTransactionTable({
    super.key,
    required this.items,
    required this.onTap,
  });

  final List<DashboardTransaction> items;
  final ValueChanged<DashboardTransaction> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        headingRowHeight: 36,
        dataRowMinHeight: 38,
        dataRowMaxHeight: 42,
        columns: const [
          DataColumn(label: Text('No. Transaksi')),
          DataColumn(label: Text('Customer')),
          DataColumn(label: Text('Merchant')),
          DataColumn(label: Text('Total')),
          DataColumn(label: Text('Metode')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Waktu')),
        ],
        rows: items.map((item) {
          return DataRow(
            onSelectChanged: (_) => onTap(item),
            cells: [
              DataCell(Text(item.id)),
              DataCell(Text(item.customer)),
              DataCell(Text(item.merchant)),
              DataCell(Text(item.total)),
              DataCell(Text(item.method)),
              DataCell(_StatusChip(status: item.status)),
              DataCell(Text(item.time)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'Berhasil' => const Color(0xFF16A34A),
      'Pending' => const Color(0xFFF59E0B),
      _ => const Color(0xFF3B82F6),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10.5,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class DashboardMerchantList extends StatelessWidget {
  const DashboardMerchantList({super.key, required this.items});

  final List<DashboardMerchant> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              SizedBox(width: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Merchant',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)),
                ),
              ),
              SizedBox(width: 12),
              SizedBox(
                width: 112,
                child: Text(
                  'Revenue',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)),
                ),
              ),
              SizedBox(width: 16),
              SizedBox(
                width: 96,
                child: Text(
                  'Orders',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: Color(item.color),
                  child: Text(
                    item.rank,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Data merchant siap dikembangkan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10.5, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 112,
                  child: Text(
                    item.revenue,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 96,
                  child: Text(
                    item.orders,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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

class DashboardActivityList extends StatelessWidget {
  const DashboardActivityList({
    super.key,
    required this.items,
    required this.onSeeAll,
  });

  final List<DashboardActivity> items;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...items.map((item) {
          final icon = switch (item.icon) {
            'store' => Icons.store_rounded,
            'shopping_bag' => Icons.shopping_bag_rounded,
            'verified' => Icons.verified_rounded,
            'inventory_2' => Icons.inventory_2_rounded,
            'percent' => Icons.percent_rounded,
            _ => Icons.notifications_rounded,
          };
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(item.color).withValues(alpha: 0.14),
                  child: Icon(icon, size: 14, color: Color(item.color)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  item.time,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonal(
            onPressed: onSeeAll,
            child: const Text('Lihat Semua Aktivitas'),
          ),
        ),
      ],
    );
  }
}

class DashboardNoticeList extends StatelessWidget {
  const DashboardNoticeList({
    super.key,
    required this.items,
    required this.onSeeAll,
  });

  final List<DashboardNotice> items;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...items.map((item) {
          final icon = switch (item.icon) {
            'store' => Icons.store_rounded,
            'inventory_2' => Icons.inventory_2_rounded,
            'receipt_long' => Icons.receipt_long_rounded,
            'payments' => Icons.payments_rounded,
            'warning' => Icons.warning_rounded,
            _ => Icons.notifications_rounded,
          };
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(item.color).withValues(alpha: 0.14),
                  child: Icon(icon, size: 14, color: Color(item.color)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  item.time,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onSeeAll,
            child: const Text('Lihat Semua Notifikasi'),
          ),
        ),
      ],
    );
  }
}
