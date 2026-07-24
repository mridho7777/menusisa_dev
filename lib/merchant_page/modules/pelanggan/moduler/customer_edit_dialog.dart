import 'package:flutter/material.dart';

import '../models/pelanggan_model.dart';

class CustomerEditDialog extends StatefulWidget {
  final PelangganModel customer;
  final Function(PelangganModel) onSave;

  const CustomerEditDialog({super.key, required this.customer, required this.onSave});

  @override
  State<CustomerEditDialog> createState() => _CustomerEditDialogState();
}

class _CustomerEditDialogState extends State<CustomerEditDialog> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController totalOrdersController;
  late TextEditingController totalSpentController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.customer.name);
    emailController = TextEditingController(text: widget.customer.email);
    phoneController = TextEditingController(text: widget.customer.phone);
    totalOrdersController = TextEditingController(text: widget.customer.totalOrders.toString());
    totalSpentController = TextEditingController(text: widget.customer.totalSpent.toStringAsFixed(0));
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    totalOrdersController.dispose();
    totalSpentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text('Edit Pelanggan', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Pelanggan',
                labelStyle: TextStyle(fontFamily: 'Quicksand'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(fontFamily: 'Quicksand'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'No. Telepon',
                labelStyle: TextStyle(fontFamily: 'Quicksand'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: totalOrdersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Pesanan',
                labelStyle: TextStyle(fontFamily: 'Quicksand'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: totalSpentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Belanja (Rp)',
                labelStyle: TextStyle(fontFamily: 'Quicksand'),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal', style: TextStyle(fontFamily: 'Quicksand', color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedCustomer = widget.customer.copyWith(
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              phone: phoneController.text.trim(),
              totalOrders: int.tryParse(totalOrdersController.text.trim()) ?? widget.customer.totalOrders,
              totalSpent: double.tryParse(totalSpentController.text.trim()) ?? widget.customer.totalSpent,
            );
            widget.onSave(updatedCustomer);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F6B43),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Simpan', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
