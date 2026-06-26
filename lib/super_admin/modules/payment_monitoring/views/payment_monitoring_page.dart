import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../models/payment_monitoring_models.dart';
import '../widgets/payment_dialogs_widgets.dart';
import '../widgets/payment_metric_grid.dart';
import '../widgets/payment_monitoring_widgets.dart';

class PaymentMonitoringPage extends StatefulWidget {
  const PaymentMonitoringPage({super.key});

  @override
  State<PaymentMonitoringPage> createState() => _PaymentMonitoringPageState();
}

class _PaymentMonitoringPageState extends State<PaymentMonitoringPage>
    with TickerProviderStateMixin {
  late final AnimationController chartController;
  String _chartFilter = '30 Hari Terakhir';
  final List<PaymentNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.paymentMonitoring);
    });
  }

  @override
  void dispose() {
    chartController.dispose();
    super.dispose();
  }

  void _notify(PaymentNotification notification) {
    setState(() {
      _notifications.insert(0, notification);
    });
  }

  void _clearNotifications() {
    setState(() {
      _notifications.clear();
    });
  }

  void _viewPayment(PaymentItem payment) {
    showDialog<void>(
      context: context,
      builder: (_) => PaymentDetailDialog(payment: payment),
    );
  }

  void _updateStatus(PaymentItem payment) {
    showDialog<void>(
      context: context,
      builder: (_) => PaymentUpdateDialog(payment: payment),
    ).then((_) {
      _notify(
        PaymentNotification(
          title: 'Status pembayaran diupdate!',
          subtitle: ' telah diperbarui.',
          time: 'Baru saja',
          color: 0xFF16A34A,
          icon: 'check',
        ),
      );
    });
  }

  void _cancelPayment(PaymentItem payment) {
    showDialog<void>(
      context: context,
      builder: (_) => PaymentConfirmDialog(
        title: 'Batalkan Pembayaran',
        message: 'Anda yakin ingin membatalkan pembayaran ini?',
        primaryLabel: 'Batalkan',
        primaryColor: const Color(0xFFEF4444),
      ),
    ).then((_) {
      _notify(
        PaymentNotification(
          title: 'Pembayaran dibatalkan!',
          subtitle: ' telah dibatalkan.',
          time: 'Baru saja',
          color: 0xFFEF4444,
          icon: 'cancel',
        ),
      );
    });
  }

  void _refundPayment(PaymentItem payment) {
    showDialog<void>(
      context: context,
      builder: (_) => PaymentConfirmDialog(
        title: 'Proses Refund',
        message: 'Anda yakin ingin memproses refund untuk pembayaran ini?',
        primaryLabel: 'Proses Refund',
        primaryColor: const Color(0xFFF59E0B),
      ),
    ).then((_) {
      _notify(
        PaymentNotification(
          title: 'Refund sedang diproses!',
          subtitle: ' sedang diproses refund.',
          time: 'Baru saja',
          color: 0xFFF59E0B,
          icon: 'warning',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, menuProvider, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth;
            final padding = contentWidth < 900
                ? const EdgeInsets.fromLTRB(16, 16, 16, 18)
                : const EdgeInsets.fromLTRB(24, 18, 24, 20);

            return SingleChildScrollView(
              padding: padding,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderBar(),
                      const SizedBox(height: 14),
                      PaymentSectionCard(
                        child: PaymentMetricGrid(metrics: paymentMetrics),
                      ),
                      const SizedBox(height: 14),
                      PaymentSectionCard(
                        child: PaymentCombinedChartCard(
                          progress: chartController.value,
                          filter: _chartFilter,
                          sidebarCollapsed: menuProvider.sidebarCollapsed,
                          onFilterChanged: (value) {
                            setState(() {
                              _chartFilter = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      PaymentSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Top Merchant (Berdasarkan Pembayaran)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            PaymentTopMerchantList(items: topMerchantPayments),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      PaymentSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Daftar Pembayaran',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Cari pembayaran...',
                                      prefixIcon: const Icon(
                                        Icons.search_rounded,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            PaymentTableCard(
                              items: paymentItems,
                              onView: _viewPayment,
                              onUpdate: _updateStatus,
                              onCancel: _cancelPayment,
                              onRefund: _refundPayment,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (_notifications.isNotEmpty)
                        PaymentNotificationTray(
                          items: _notifications,
                          onClearAll: _clearNotifications,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Monitoring',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Pantau semua pembayaran yang terjadi pada platform. Monitor status pembayaran, metode, dan lakukan tindakan yang diperlukan.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F8D55),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Export Laporan'),
        ),
      ],
    );
  }
}
