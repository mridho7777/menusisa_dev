import 'package:flutter/material.dart';

import '../../../shared/widgets/charts/reusable_charts.dart';
import '../models/product_approval_models.dart';

// TODO: Supabase Integration
// Table: product_approvals - linked to ProductApprovalItem
// Real-time subscription for status changes

class ProductSectionCard extends StatelessWidget {
  const ProductSectionCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class ProductMetricGrid extends StatelessWidget {
  const ProductMetricGrid({
    super.key,
    required this.metrics,
    this.sidebarCollapsed = true,
  });
  final List<ProductApprovalMetric> metrics;
  final bool sidebarCollapsed;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 1180 ? 3 : 2;
        final childAspectRatio = constraints.maxWidth >= 1500
            ? 3.2
            : constraints.maxWidth >= 1180
            ? 3.0
            : 3.8;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) => _MetricCard(metric: metrics[index]),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});
  final ProductApprovalMetric metric;
  @override
  Widget build(BuildContext context) {
    final icon = switch (metric.icon) {
      'hourglass' => Icons.hourglass_top_rounded,
      'check' => Icons.check_circle_rounded,
      'close' => Icons.cancel_rounded,
      'block' => Icons.block_rounded,
      'inventory' => Icons.inventory_2_rounded,
      'rate_review' => Icons.rate_review_rounded,
      _ => Icons.inventory_2_rounded,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: Color(metric.color),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 34),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        metric.title,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        metric.value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F8EC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    metric.delta,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF0F8D55),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Alias agar ProductApprovalPage tetap compile
class ProductApprovalTable extends StatelessWidget {
  const ProductApprovalTable({
    super.key,
    required this.items,
    required this.onView,
    required this.onApprove,
    required this.onReject,
    required this.onInactive,
    required this.onPublish,
  });

  final List<ProductApprovalItem> items;
  final ValueChanged<ProductApprovalItem> onView;
  final ValueChanged<ProductApprovalItem> onApprove;
  final ValueChanged<ProductApprovalItem> onReject;
  final ValueChanged<ProductApprovalItem> onInactive;
  final ValueChanged<ProductApprovalItem> onPublish;

  @override
  Widget build(BuildContext context) {
    return ProductApprovalDataTable(
      items: items,
      onView: onView,
      onApprove: onApprove,
      onReject: onReject,
      onInactive: onInactive,
      onPublish: onPublish,
    );
  }
}

class ProductApprovalChartCard extends StatelessWidget {
  const ProductApprovalChartCard({super.key, required this.progress});
  final double progress;
  @override
  Widget build(BuildContext context) {
    return DualChartWrapper(
      leftChart: ReusableLineChart(
        title: 'Grafik Produk Masuk',
        filter: '7 Hari Ke Depan',
        dataKey: 'product_approvals',
        supabaseTable: 'product_approvals',
        supabaseQuery:
            'SELECT DATE(created_at) AS date, COUNT(*) AS count FROM product_approvals GROUP BY date',
      ),
      rightChart: ReusableDonutChart(
        title: 'Status Produk',
        supabaseTable: 'product_approvals',
        supabaseQuery:
            'SELECT status, COUNT(*) FROM product_approvals GROUP BY status',
      ),
    );
  }
}

class ProductTopMerchantList extends StatelessWidget {
  const ProductTopMerchantList({super.key, required this.items});
  final List<dynamic> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(radius: 14, child: Text('${item.rank}')),
                  const SizedBox(width: 10),
                  Expanded(child: Text('${item.name}')),
                  Text('${item.revenue}'),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class ProductFilterPanel extends StatelessWidget {
  const ProductFilterPanel({super.key, required this.onReset});
  final VoidCallback onReset;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Filter Produk'),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: onReset, child: const Text('Reset Filter')),
      ],
    );
  }
}

class ProductApprovalDataTable extends StatelessWidget {
  const ProductApprovalDataTable({
    super.key,
    required this.items,
    required this.onView,
    required this.onApprove,
    required this.onReject,
    required this.onInactive,
    required this.onPublish,
    this.sidebarCollapsed = true,
  });
  final List<ProductApprovalItem> items;
  final ValueChanged<ProductApprovalItem> onView;
  final ValueChanged<ProductApprovalItem> onApprove;
  final ValueChanged<ProductApprovalItem> onReject;
  final ValueChanged<ProductApprovalItem> onInactive;
  final ValueChanged<ProductApprovalItem> onPublish;
  final bool sidebarCollapsed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Daftar Produk Menunggu Persetujuan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              'Menampilkan 1 - ${items.length} dari ${items.length} data',
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
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
              DataColumn(label: Text('ID Produk')),
              DataColumn(label: Text('Nama Produk')),
              DataColumn(label: Text('Merchant')),
              DataColumn(label: Text('Kategori')),
              DataColumn(label: Text('Harga')),
              DataColumn(label: Text('Stok')),
              DataColumn(label: Text('Tanggal Submit')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return DataRow(
                cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(Text(item.productId)),
                  DataCell(
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  DataCell(Text(item.merchant)),
                  DataCell(Text(item.category)),
                  DataCell(
                    Text(
                      item.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F8D55),
                      ),
                    ),
                  ),
                  DataCell(Text('${item.stock}')),
                  DataCell(Text(item.submittedAt)),
                  DataCell(_StatusBadge(status: item.status)),
                  DataCell(
                    _ActionMenu(
                      item: item,
                      onView: onView,
                      onApprove: onApprove,
                      onReject: onReject,
                      onInactive: onInactive,
                      onPublish: onPublish,
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
    final config = switch (status) {
      'Approved' => (
        color: const Color(0xFF0F8D55),
        bg: const Color(0xFFD1FAE5),
      ),
      'Pending' => (
        color: const Color(0xFFF59E0B),
        bg: const Color(0xFFFEF3C7),
      ),
      'Rejected' => (
        color: const Color(0xFFEF4444),
        bg: const Color(0xFFFEE2E2),
      ),
      'Inactive' => (
        color: const Color(0xFF7C3AED),
        bg: const Color(0xFFEDE9FE),
      ),
      'Review' => (color: const Color(0xFF0891B2), bg: const Color(0xFFE0F2FE)),
      _ => (color: const Color(0xFF6B7280), bg: const Color(0xFFF3F4F6)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: config.color,
        ),
      ),
    );
  }
}

class _ActionMenu extends StatelessWidget {
  const _ActionMenu({
    required this.item,
    required this.onView,
    required this.onApprove,
    required this.onReject,
    required this.onInactive,
    required this.onPublish,
  });
  final ProductApprovalItem item;
  final ValueChanged<ProductApprovalItem> onView;
  final ValueChanged<ProductApprovalItem> onApprove;
  final ValueChanged<ProductApprovalItem> onReject;
  final ValueChanged<ProductApprovalItem> onInactive;
  final ValueChanged<ProductApprovalItem> onPublish;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      offset: const Offset(0, 40),
      onSelected: (action) {
        switch (action) {
          case 'approve':
            onApprove(item);
            break;
          case 'reject':
            onReject(item);
            break;
          case 'inactive':
            onInactive(item);
            break;
          case 'detail':
            onView(item);
            break;
          case 'publish':
            onPublish(item);
            break;
        }
      },
      itemBuilder: (context) => [
        _buildMenuItem(Icons.check_circle_rounded, 'Approve', 'approve'),
        _buildMenuItem(Icons.cancel_rounded, 'Reject', 'reject'),
        _buildMenuItem(Icons.send_rounded, 'Tampilkan ke Customer', 'publish'),
        _buildMenuItem(Icons.rate_review_rounded, 'Set Review', 'review'),
        _buildMenuItem(Icons.hourglass_top_rounded, 'Set Pending', 'pending'),
        _buildMenuItem(Icons.block_rounded, 'Set Inactive', 'inactive'),
        const PopupMenuDivider(),
        _buildMenuItem(Icons.visibility_rounded, 'Detail Produk', 'detail'),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    IconData icon,
    String label,
    String value,
  ) => PopupMenuItem(
    value: value,
    child: Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6B7280)),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
        ),
      ],
    ),
  );
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls();
  @override
  Widget build(BuildContext context) => Row(
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
          _PageButton(icon: Icons.chevron_left_rounded, onPressed: () {}),
          ...[1, 2, 3].map(
            (page) => _PageButton(
              label: '$page',
              isActive: page == 1,
              onPressed: () {},
            ),
          ),
          _PageButton(icon: Icons.chevron_right_rounded, onPressed: () {}),
        ],
      ),
    ],
  );
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
  Widget build(BuildContext context) => Padding(
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
            border: isActive
                ? null
                : Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: icon != null
              ? Icon(
                  icon,
                  size: 18,
                  color: isActive ? Colors.white : const Color(0xFF6B7280),
                )
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
