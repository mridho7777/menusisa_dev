import 'package:flutter/material.dart';

class ProductPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final ValueChanged<int> onPageChanged;

  const ProductPagination({super.key, required this.currentPage, required this.totalPages, required this.totalItems, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    final start = totalItems == 0 ? 0 : ((currentPage - 1) * 6 + 1).clamp(1, totalItems);
    final end = totalItems == 0 ? 0 : (currentPage * 6).clamp(1, totalItems);
    final visiblePages = totalItems == 0 ? 0 : totalPages.clamp(0, 5);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Menampilkan $start - $end dari $totalItems produk', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.chevron_left), onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null, color: currentPage > 1 ? const Color(0xFF0F6B43) : const Color(0xFFCBD5E1)),
            ...List.generate(visiblePages, (index) {
              final page = index + 1;
              final isActive = page == currentPage;
              return GestureDetector(
                onTap: () => onPageChanged(page),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: isActive ? const Color(0xFF0F6B43) : Colors.transparent, borderRadius: BorderRadius.circular(6), border: isActive ? null : Border.all(color: const Color(0xFFE2E8F0))),
                  child: Text('$page', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isActive ? Colors.white : const Color(0xFF334155))),
                ),
              );
            }),
            IconButton(icon: const Icon(Icons.chevron_right), onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null, color: currentPage < totalPages ? const Color(0xFF0F6B43) : const Color(0xFFCBD5E1)),
          ],
        ),
      ],
    );
  }
}
