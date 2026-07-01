import 'package:flutter/material.dart';

import '../models/merchant_management_models.dart';

class MerchantFooterPanel extends StatelessWidget {
  const MerchantFooterPanel({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Expanded(child: child),
      ],
    );
  }
}

class MerchantTopMerchantList extends StatelessWidget {
  const MerchantTopMerchantList({super.key, required this.items});

  final List<MerchantTopMerchant> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(item.color).withOpacity(0.16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.orders,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.revenue,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MerchantNotificationList extends StatelessWidget {
  const MerchantNotificationList({super.key});

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
        child: Column(
          children: [
            _NotificationItem(
              icon: Icons.check_circle,
              iconColor: Color(0xFF16A34A),
              title: 'Merchant berhasil disetujui',
              subtitle: 'Kopi Nusantara telah aktif',
              time: '2 menit lalu',
            ),
            SizedBox(height: 10),
            _NotificationItem(
              icon: Icons.warning_amber_rounded,
              iconColor: Color(0xFFF59E0B),
              title: 'Merchant menunggu verifikasi',
              subtitle: 'Burger Jaya perlu dokumen tambahan',
              time: '15 menit lalu',
            ),
            SizedBox(height: 10),
            _NotificationItem(
              icon: Icons.block,
              iconColor: Color(0xFFEF4444),
              title: 'Merchant berhasil disuspend',
              subtitle: 'Ayam Bakar ID disuspend oleh admin',
              time: '1 jam lalu',
            ),
          ],
        ),
      );
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9CA3AF),
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

// Widget baru untuk Recent Activity
class MerchantRecentActivityList extends StatelessWidget {
  const MerchantRecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      _ActivityData(
        icon: Icons.person_add_rounded,
        iconColor: const Color(0xFF3B82F6),
        title: 'Merchant baru terdaftar',
        subtitle: 'Nasi Goreng Spesial',
        time: '5 menit lalu',
      ),
      _ActivityData(
        icon: Icons.edit_rounded,
        iconColor: const Color(0xFFF59E0B),
        title: 'Data merchant diperbarui',
        subtitle: 'Es Teh Indonesia',
        time: '10 menit lalu',
      ),
      _ActivityData(
        icon: Icons.shopping_bag_rounded,
        iconColor: const Color(0xFF16A34A),
        title: 'Produk baru ditambahkan',
        subtitle: 'Martabak Enak (5 produk)',
        time: '20 menit lalu',
      ),
      _ActivityData(
        icon: Icons.verified_rounded,
        iconColor: const Color(0xFF0F8D55),
        title: 'Merchant diverifikasi',
        subtitle: 'Nasgor Spesial',
        time: '35 menit lalu',
      ),
      _ActivityData(
        icon: Icons.attach_money_rounded,
        iconColor: const Color(0xFF7C3AED),
        title: 'Transaksi berhasil',
        subtitle: 'Pizza Mantap (Rp 850.000)',
        time: '1 jam lalu',
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        children: activities.map((activity) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ActivityItem(
              icon: activity.icon,
              iconColor: activity.iconColor,
              title: activity.title,
              subtitle: activity.subtitle,
              time: activity.time,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ActivityData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  _ActivityData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MerchantVerificationSummary extends StatelessWidget {
  const MerchantVerificationSummary({super.key});
  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
        child: Column(
          children: [
            _VerificationRow(
              label: 'Menunggu Verifikasi',
              value: '10',
              color: Color(0xFFF59E0B),
              progress: 0.3,
            ),
            SizedBox(height: 16),
            _VerificationRow(
              label: 'Disetujui Hari Ini',
              value: '8',
              color: Color(0xFF16A34A),
              progress: 0.8,
            ),
            SizedBox(height: 16),
            _VerificationRow(
              label: 'Ditolak Hari Ini',
              value: '2',
              color: Color(0xFFEF4444),
              progress: 0.2,
            ),
          ],
        ),
      );
}

class _VerificationRow extends StatelessWidget {
  const _VerificationRow({
    required this.label,
    required this.value,
    required this.color,
    required this.progress,
  });
  final String label;
  final String value;
  final Color color;
  final double progress;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      );
}

class MerchantRevenueSummary extends StatelessWidget {
  const MerchantRevenueSummary({super.key});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Pendapatan Merchant',
              style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 6),
            const Text(
              'Rp 45.500.000',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bulan Ini',
                        style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rp 12.750.000',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up, size: 14, color: Color(0xFF16A34A)),
                      SizedBox(width: 4),
                      Text(
                        '+18%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: CustomPaint(painter: _MiniChartPainter(), child: Container()),
            ),
          ],
        ),
      );
}

class _MiniChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F8D55)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path();
    final points = [0.2, 0.5, 0.3, 0.7, 0.4, 0.8, 0.9];
    path.moveTo(0, size.height * (1 - points[0]));
    for (int i = 1; i < points.length; i++) {
      path.lineTo(
        size.width * i / (points.length - 1),
        size.height * (1 - points[i]),
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
