import 'package:flutter/material.dart';

class NotificationPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const NotificationPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          totalItems == 0 ? 'Menampilkan 0 dari 0 notifikasi' : 'Menampilkan ${(currentPage - 1) * 5 + 1}-${((currentPage - 1) * 5 + 5).clamp(1, totalItems)} dari $totalItems notifikasi',
          style: const TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: Color(0xFF64748B)),
        ),
        Row(
          children: [
            IconButton(onPressed: currentPage > 1 ? onPrevious : null, icon: const Icon(Icons.chevron_left)),
            Text('$currentPage', style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
            Text(' / $totalPages', style: const TextStyle(fontFamily: 'Quicksand', color: Color(0xFF64748B))),
            IconButton(onPressed: currentPage < totalPages ? onNext : null, icon: const Icon(Icons.chevron_right)),
          ],
        ),
      ],
    );
  }
}
