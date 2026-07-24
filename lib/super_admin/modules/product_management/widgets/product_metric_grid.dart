import 'package:flutter/material.dart';

import '../models/product_management_models.dart';

class ProductMetricGrid extends StatelessWidget {
  const ProductMetricGrid({super.key, required this.metrics});

  final List<ProductMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = 3;
        final childAspectRatio = constraints.maxWidth >= 1500
            ? 3.6
            : constraints.maxWidth >= 1180
            ? 3.2
            : 4.2;
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
          itemBuilder: (context, index) =>
              _MetricCard(metric: metrics[index], delay: index * 60),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric, required this.delay});

  final ProductMetric metric;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final icon = switch (metric.icon) {
      'inventory' => Icons.inventory_2_rounded,
      'check' => Icons.check_circle_rounded,
      'close' => Icons.cancel_rounded,
      'low_stock' => Icons.inventory_rounded,
      'sell' => Icons.shopping_cart_rounded,
      'new' => Icons.new_releases_rounded,
      _ => Icons.inventory_2_rounded,
    };

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 450 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: child,
        ),
      ),
      child: Container(
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
              child: Icon(icon, color: Colors.white, size: 36),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    metric.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          metric.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16A34A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          metric.delta,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
