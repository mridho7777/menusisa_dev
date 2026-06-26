import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/product_approval_models.dart';

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
      ),
      child: child,
    );
  }
}

class ProductMetricGrid extends StatelessWidget {
  const ProductMetricGrid({super.key, required this.metrics});

  final List<ProductApprovalMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 1180 ? 5 : 2;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric.title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  metric.value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  metric.delta,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF6B7280),
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

class ProductApprovalChartCard extends StatelessWidget {
  const ProductApprovalChartCard({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final sections = [
      PieChartSectionData(
        color: const Color(0xFF0F8D55),
        value: 84 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFFF59E0B),
        value: 11 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFFEF4444),
        value: 3 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFF7C3AED),
        value: 2 * progress,
        radius: 34,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 1180;
          final chart = Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 74,
                    startDegreeOffset: -90,
                    sections: sections,
                    borderData: FlBorderData(show: false),
                  ),
                  duration: const Duration(milliseconds: 250),
                ),
              ),
              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '1.256',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ],
          );

          final legend = const _ApprovalLegend();

          if (stacked) {
            return Column(
              children: [
                SizedBox(height: 280, child: chart),
                const SizedBox(height: 12),
                legend,
              ],
            );
          }
          return Row(
            children: [
              Expanded(flex: 5, child: SizedBox(height: 320, child: chart)),
              const SizedBox(width: 14),
              const Expanded(flex: 4, child: _ApprovalLegend()),
            ],
          );
        },
      ),
    );
  }
}

class _ApprovalLegend extends StatelessWidget {
  const _ApprovalLegend();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _LegendItem(
          color: Color(0xFF0F8D55),
          title: 'Approved',
          value: '1.056 (84%)',
        ),
        SizedBox(height: 14),
        _LegendItem(
          color: Color(0xFFF59E0B),
          title: 'Pending',
          value: '142 (11%)',
        ),
        SizedBox(height: 14),
        _LegendItem(
          color: Color(0xFFEF4444),
          title: 'Rejected',
          value: '38 (3%)',
        ),
        SizedBox(height: 14),
        _LegendItem(
          color: Color(0xFF7C3AED),
          title: 'Inactive',
          value: '20 (2%)',
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.title,
    required this.value,
  });

  final Color color;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ],
    );
  }
}

class ProductTopMerchantList extends StatelessWidget {
  const ProductTopMerchantList({super.key, required this.items});

  final List<TopMerchantProduct> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Color(item.color).withValues(alpha: 0.16),
                child: Text(
                  item.rank,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(item.color),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                ' Produk',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
            'Filter Status',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const _CheckLine(label: 'Pending Approval'),
          const _CheckLine(label: 'Approved'),
          const _CheckLine(label: 'Rejected'),
          const _CheckLine(label: 'Inactive'),
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

class _CheckLine extends StatelessWidget {
  const _CheckLine({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        const Icon(Icons.check_box_rounded, size: 18, color: Color(0xFF0F8D55)),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 12.5)),
      ],
    ),
  );
}

class ProductApprovalTable extends StatelessWidget {
  const ProductApprovalTable({
    super.key,
    required this.items,
    required this.onView,
    required this.onApprove,
    required this.onReject,
    required this.onInactive,
  });

  final List<ProductApprovalItem> items;
  final ValueChanged<ProductApprovalItem> onView;
  final ValueChanged<ProductApprovalItem> onApprove;
  final ValueChanged<ProductApprovalItem> onReject;
  final ValueChanged<ProductApprovalItem> onInactive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
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
                width: 90,
                child: Text(item.price, style: const TextStyle(fontSize: 12)),
              ),
              SizedBox(
                width: 50,
                child: Text('', style: const TextStyle(fontSize: 12)),
              ),
              SizedBox(
                width: 140,
                child: Text(
                  item.submittedAt,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(
                width: 86,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Pending',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFF59E0B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 180,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => onView(item),
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                    ),
                    IconButton(
                      onPressed: () => onApprove(item),
                      icon: const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                    IconButton(
                      onPressed: () => onReject(item),
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                    IconButton(
                      onPressed: () => onInactive(item),
                      icon: const Icon(
                        Icons.block_rounded,
                        size: 18,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
