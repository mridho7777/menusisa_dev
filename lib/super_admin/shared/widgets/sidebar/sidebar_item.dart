import 'package:flutter/material.dart';

class SidebarItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final String route;
  final bool isActive;
  final bool collapsed;
  final String? badge;
  final VoidCallback onTap;

  const SidebarItem({super.key, required this.title, required this.icon, required this.route, required this.isActive, required this.collapsed, required this.onTap, this.badge});

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.symmetric(horizontal: widget.collapsed ? 10 : 12, vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFB8E986) : hovered ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: widget.collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(widget.icon, color: active ? const Color(0xFF0B6F3B) : Colors.white, size: 22),
              if (!widget.collapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: active ? const Color(0xFF0B6F3B) : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (widget.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(999)),
                    child: Text(widget.badge!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
