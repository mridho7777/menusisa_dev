import 'package:menusisa_dev/merchant_page/shared/widgets/merchant_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../notifikasi/controllers/notifikasi_controller.dart';
import '../controllers/pelanggan_controller.dart';
import '../models/pelanggan_model.dart';
import 'customer_action_menu.dart';
import 'customer_detail_dialog.dart';
import 'customer_edit_dialog.dart';

class CustomerTable extends StatelessWidget {
  final List<PelangganModel> customers;
  final MerchantPelangganController controller;

  const CustomerTable({super.key, required this.customers, required this.controller});

  String _currency(double value) {
    final formatted = value.toInt().toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => '${match[1]}.');
    return 'Rp$formatted';
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return '-';
    }
  }

  void _showDeleteConfirmation(BuildContext context, PelangganModel customer) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Hapus Pelanggan', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
        content: Text(
          'Apakah Anda yakin ingin menghapus pelanggan "${customer.name}"?',
          style: const TextStyle(fontFamily: 'Quicksand'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal', style: TextStyle(fontFamily: 'Quicksand', color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteCustomer(customer.id);
              final shortId = customer.id.length > 6 ? customer.id.substring(customer.id.length - 6) : customer.id;
              context.read<MerchantNotifikasiController>().addNotification(
                title: 'Pelanggan Dihapus',
                description: 'Data pelanggan ${customer.name} (ID $shortId) telah dihapus.',
                iconKey: 'close',
              );
              Navigator.of(ctx).pop();
              MerchantToast.show(context, '${customer.name} berhasil dihapus', type: ToastType.success);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Hapus', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowHeight: 44,
                  dataRowMinHeight: 60,
                  dataRowMaxHeight: 72,
                  horizontalMargin: 16,
                  columnSpacing: 24,
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        width: constraints.maxWidth * 0.25,
                        child: const Text(
                          'Pelanggan',
                          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: constraints.maxWidth * 0.15,
                        child: const Text(
                          'Total Pesanan',
                          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: constraints.maxWidth * 0.2,
                        child: const Text(
                          'Total Belanja',
                          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: constraints.maxWidth * 0.18,
                        child: const Text(
                          'Terakhir Order',
                          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: constraints.maxWidth * 0.1,
                        child: const Text(
                          'Aksi',
                          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  rows: customers.map((customer) {
                    return DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: constraints.maxWidth * 0.25,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xFFE2E8F0),
                                  backgroundImage: customer.avatarUrl != null && customer.avatarUrl!.isNotEmpty
                                      ? NetworkImage(customer.avatarUrl!)
                                      : null,
                                  child: customer.avatarUrl == null || customer.avatarUrl!.isEmpty
                                      ? const Icon(Icons.person_outline, size: 18, color: Color(0xFF64748B))
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    customer.name,
                                    style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: constraints.maxWidth * 0.15,
                            child: Text('${customer.totalOrders}', style: const TextStyle(fontFamily: 'Quicksand', color: Color(0xFF64748B))),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: constraints.maxWidth * 0.2,
                            child: Text(_currency(customer.totalSpent), style: const TextStyle(fontFamily: 'Quicksand', color: Color(0xFF64748B))),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: constraints.maxWidth * 0.18,
                            child: Text(_formatDate(customer.lastOrderDate), style: const TextStyle(fontFamily: 'Quicksand', color: Color(0xFF64748B))),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: constraints.maxWidth * 0.1,
                            child: CustomerActionMenu(
                              onView: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => CustomerDetailDialog(customer: customer),
                                );
                              },
                              onEdit: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => CustomerEditDialog(
                                    customer: customer,
                                    onSave: (updatedCustomer) {
                                      controller.updateCustomer(updatedCustomer);
                                      final shortId = updatedCustomer.id.length > 6 ? updatedCustomer.id.substring(updatedCustomer.id.length - 6) : updatedCustomer.id;
                                      context.read<MerchantNotifikasiController>().addNotification(
                                        title: 'Pelanggan Diperbarui',
                                        description: 'Data pelanggan ${updatedCustomer.name} (ID $shortId) berhasil diperbarui.',
                                        iconKey: 'edit',
                                      );
                                      MerchantToast.show(context, '${updatedCustomer.name} berhasil diubah', type: ToastType.success);
                                    },
                                  ),
                                );
                              },
                              onDelete: () => _showDeleteConfirmation(context, customer),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
