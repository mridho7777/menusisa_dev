import 'package:flutter/material.dart';

class CustomerPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int startItem;
  final int endItem;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const CustomerPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.startItem,
    required this.endItem,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          totalItems == 0 ? 'Menampilkan 0 data pelanggan' : 'Menampilkan $startItem-$endItem dari $totalItems pelanggan',
          style: const TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: Color(0xFF64748B)),
        ),
        Row(
          children: [
            IconButton(onPressed: currentPage > 1 ? onPrevious : null, icon: const Icon(Icons.chevron_left)),
            Text('$currentPage / $totalPages', style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
            IconButton(onPressed: currentPage < totalPages ? onNext : null, icon: const Icon(Icons.chevron_right)),
          ],
        ),
      ],
    );
  }
}
