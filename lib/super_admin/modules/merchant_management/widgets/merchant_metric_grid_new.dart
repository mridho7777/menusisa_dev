import 'package:flutter/material.dart';
import '../models/merchant_management_models.dart';

/// Widget untuk menampilkan grid metric merchant
/// Layout responsif:
/// - Dengan sidebar (collapsed): 3 kolom atas, 3 kolom bawah
/// - Tanpa sidebar (expanded): 2 kolom atas, 2 kolom tengah, 2 kolom bawah
class MerchantMetricGrid extends StatelessWidget {
  const MerchantMetricGrid({
    super.key,
    required this.metrics,
    this.sidebarCollapsed = true,
  });

  final List<MerchantMetric> metrics;
  final bool sidebarCollapsed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Tentukan jumlah kolom berdasarkan sidebar state
        final crossAxisCount = 3;
        
        // Aspect ratio dinamis berdasarkan lebar
        final childAspectRatio = sidebarCollapsed
            ? (constraints.maxWidth >= 1500 ? 3.6 : 3.2)
            : (constraints.maxWidth >= 1500 ? 4.2 : 3.8);

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
          itemBuilder: (context, index) => _MerchantMetricCard(
            metric: metrics[index],
            delay: index * 60,
          ),
        );
      },
    );
  }
}

/// Card individual untuk menampilkan metric merchant
/// Desain mengikuti style dashboard dengan icon besar dan animasi
class _MerchantMetricCard extends StatelessWidget {
  const _MerchantMetricCard({
    required this.metric,
    required this.delay,
  });

  final MerchantMetric metric;
  final int delay;

  @override
  Widget build(BuildContext context) {
    // Mapping icon string ke IconData
    final icon = switch (metric.icon) {
      'store' => Icons.store_rounded,
      'people' => Icons.people_alt_rounded,
      'pending' => Icons.schedule_rounded,
      'lock' => Icons.lock_rounded,
      'new_releases' => Icons.new_releases_rounded,
      'payments' => Icons.payments_rounded,
      'verified' => Icons.verified_rounded,
      'close' => Icons.close_rounded,
      _ => Icons.analytics_rounded,
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
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon besar dengan background berwarna
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
            // Text content
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Nilai metric
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          metric.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Delta/perubahan
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          metric.delta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: metric.delta.startsWith('+')
                                ? const Color(0xFF16A34A)
                                : const Color(0xFF9CA3AF),
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
