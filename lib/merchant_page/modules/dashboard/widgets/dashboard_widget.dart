import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../shared/widgets/charts/reusable_charts.dart';
import '../models/dashboard_model.dart';

class DashboardWidget extends StatelessWidget {
  final DashboardModel data;

  const DashboardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 980;
        final metricCardWidth = constraints.maxWidth >= 1100
            ? (constraints.maxWidth - 36) / 4
            : constraints.maxWidth >= 700
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;


        final leftPaneWidth = isWide ? (constraints.maxWidth - 14) * 0.58 : constraints.maxWidth;
        final rightPaneWidth = isWide ? (constraints.maxWidth - 14) * 0.42 : constraints.maxWidth;

        final salesSpots = List<FlSpot>.generate(
          data.salesTrend.length,
          (index) => FlSpot((index + 1).toDouble(), data.salesTrend[index]),
        );

        final productCount = data.products.fold<int>(0, (sum, item) => sum + item.sold);
        final productSections = [
          PieChartSectionData(color: const Color(0xFF0F6B43), value: productCount == 0 ? 1 : productCount.toDouble(), radius: 24, titleStyle: const TextStyle(fontSize: 0)),
          PieChartSectionData(color: const Color(0xFFF59E0B), value: productCount == 0 ? 1 : (productCount * 0.5).clamp(1, double.infinity), radius: 24, titleStyle: const TextStyle(fontSize: 0)),
          PieChartSectionData(color: const Color(0xFFEF4444), value: productCount == 0 ? 1 : (productCount * 0.25).clamp(1, double.infinity), radius: 24, titleStyle: const TextStyle(fontSize: 0)),
        ];

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(title: data.title, subtitle: data.subtitle),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: data.metrics
                    .map((metric) => SizedBox(
                          width: metricCardWidth,
                          child: _MetricCard(metric: metric),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              _BaseCard(
                child: LayoutBuilder(
                  builder: (context, chartConstraints) {

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRect(
                            child: ReusableLineChart(
                              title: 'Grafik Penjualan',
                              dataKey: 'Penjualan',
                              supabaseTable: 'orders',
                              supabaseQuery: r"SELECT created_at, total_amount FROM orders WHERE merchant_id = $MERCHANT_ID AND status = \'done\'",
                              spots: salesSpots,
                              labels: data.days,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: ClipRect(
                            child: ReusableDonutChart(
                              title: 'Kategori Produk',
                              legendItems: const [
                                DonutChartLegendItem(color: Color(0xFF0F6B43), title: 'Makanan', value: 'utama'),
                                DonutChartLegendItem(color: Color(0xFFF59E0B), title: 'Minuman', value: 'utama'),
                                DonutChartLegendItem(color: Color(0xFFEF4444), title: 'Lainnya', value: 'utama'),
                              ],
                              supabaseTable: 'products',
                              supabaseQuery: r"SELECT category, COUNT(*) FROM products WHERE merchant_id = $MERCHANT_ID GROUP BY category",
                              sections: productSections,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: leftPaneWidth,
                    child: _ProductsCard(products: data.products),
                  ),
                  SizedBox(
                    width: rightPaneWidth,
                    child: Column(
                      children: [
                        _OrdersCard(orders: data.orders),
                        const SizedBox(height: 12),
                        _SummaryCard(total: 'Rp0', discount: 'Rp0', net: 'Rp0'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BaseCard extends StatelessWidget {
  final Widget child;
  const _BaseCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 18, offset: Offset(0, 8))],
      ),
      child: child,
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  const _Header({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final DashboardMetric metric;
  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(metric.title, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 10),
          Text(metric.value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          const SizedBox(height: 8),
          Text(metric.subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}

class _ProductsCard extends StatelessWidget {
  final List<DashboardProduct> products;
  const _ProductsCard({required this.products});

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Produk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...products.map((product) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(product.name), Text('${product.sold}')],
            ),
          )),
        ],
      ),
    );
  }
}

class _OrdersCard extends StatelessWidget {
  final List<DashboardOrder> orders;
  const _OrdersCard({required this.orders});

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...orders.map((order) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(order.customer), Text(order.status)],
            ),
          )),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String total;
  final String discount;
  final String net;
  const _SummaryCard({required this.total, required this.discount, required this.net});

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ringkasan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Text('Total: $total'),
          Text('Diskon: $discount'),
          Text('Bersih: $net'),
        ],
      ),
    );
  }
}


