import 'package:flutter/material.dart';

/// MerchantToast: Lightweight overlay notification shown just below the header.
/// - Use MerchantToast.show(context, message, type: ToastType.success/error/info/warning)
/// - Auto-dismisses after 3 seconds.
/// - Does NOT modify any existing UI layout.

enum ToastType { success, error, info, warning, order }

class MerchantToast {
  static void show(BuildContext context, String message, {ToastType type = ToastType.info}) {
    final overlay = Overlay.of(context);

    final color = switch (type) {
      ToastType.success => const Color(0xFF0F6B43),
      ToastType.error   => const Color(0xFFEF4444),
      ToastType.warning => const Color(0xFFF59E0B),
      ToastType.order   => const Color(0xFF6366F1),
      ToastType.info    => const Color(0xFF1E6F3B),
    };

    final icon = switch (type) {
      ToastType.success => Icons.check_circle_outline,
      ToastType.error   => Icons.error_outline,
      ToastType.warning => Icons.warning_amber_outlined,
      ToastType.order   => Icons.receipt_long_outlined,
      ToastType.info    => Icons.info_outline,
    };

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _MerchantToastWidget(
        message: message,
        color: color,
        icon: icon,
        onDismiss: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

class _MerchantToastWidget extends StatefulWidget {
  const _MerchantToastWidget({required this.message, required this.color, required this.icon, required this.onDismiss});
  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback onDismiss;

  @override
  State<_MerchantToastWidget> createState() => _MerchantToastWidgetState();
}

class _MerchantToastWidgetState extends State<_MerchantToastWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 3), _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _ctrl.reverse().then((_) => widget.onDismiss());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Positioned(
      top: mq.padding.top + 70 + 8,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: GestureDetector(
            onTap: _dismiss,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.color.withValues(alpha: 0.4), width: 1.5),
                ),
                child: Row(
                  children: [
                    Icon(widget.icon, color: widget.color, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Icon(Icons.close, size: 16, color: const Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
