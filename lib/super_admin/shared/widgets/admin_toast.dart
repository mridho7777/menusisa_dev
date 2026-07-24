import 'package:flutter/material.dart';

enum AdminToastType { success, error, info, warning }

class AdminToast {
  static void show(BuildContext context, String message, {AdminToastType type = AdminToastType.info}) {
    final overlay = Overlay.of(context);

    final color = switch (type) {
      AdminToastType.success => const Color(0xFF0F8D55),
      AdminToastType.error   => const Color(0xFFDC2626),
      AdminToastType.warning => const Color(0xFFF59E0B),
      AdminToastType.info    => const Color(0xFF1E3A8A),
    };

    final icon = switch (type) {
      AdminToastType.success => Icons.check_circle_rounded,
      AdminToastType.error   => Icons.error_rounded,
      AdminToastType.warning => Icons.warning_rounded,
      AdminToastType.info    => Icons.info_rounded,
    };

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _AdminToastWidget(
        message: message,
        color: color,
        icon: icon,
        onDismiss: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

class _AdminToastWidget extends StatefulWidget {
  const _AdminToastWidget({required this.message, required this.color, required this.icon, required this.onDismiss});
  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback onDismiss;

  @override
  State<_AdminToastWidget> createState() => _AdminToastWidgetState();
}

class _AdminToastWidgetState extends State<_AdminToastWidget> with SingleTickerProviderStateMixin {
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
    return Positioned(
      top: 90, // below header (header is usually 70-80)
      left: 0,
      right: 0,
      child: Center(
        child: SlideTransition(
          position: _slide,
          child: FadeTransition(
            opacity: _fade,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border(left: BorderSide(color: widget.color, width: 4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, color: widget.color, size: 24),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        widget.message,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _dismiss,
                      child: const Icon(Icons.close, size: 18, color: Colors.grey),
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
