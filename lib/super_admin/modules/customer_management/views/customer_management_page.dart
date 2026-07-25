import 'package:menusisa_dev/super_admin/shared/widgets/admin_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/customer_provider.dart';
import '../models/customer_models.dart';

class CustomerManagementPage extends StatefulWidget {
  const CustomerManagementPage({super.key});

  @override
  State<CustomerManagementPage> createState() => _CustomerManagementPageState();
}

class _CustomerManagementPageState extends State<CustomerManagementPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.customers);
      context.read<CustomerProvider>().loadCustomers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showEditCustomerDialog(BuildContext context, CustomerRecord customer) {
    final nameController = TextEditingController(text: customer.name);
    final phoneController = TextEditingController(text: customer.phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Data Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'No. HP'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await context
                  .read<CustomerProvider>()
                  .updateCustomer(
                    customer.id,
                    nameController.text,
                    phoneController.text,
                  );

              if (success && context.mounted) {
                AdminToast.show(
                  context,
                  'Data customer berhasil diupdate',
                  type: AdminToastType.success,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showCustomerDetailDialog(
    BuildContext context,
    CustomerRecord customer,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Customer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('ID Pengguna', customer.id),
              _detailRow('Nama Lengkap', customer.name),
              _detailRow('Email', customer.email),
              _detailRow(
                'No. HP',
                customer.phone.isEmpty ? '-' : customer.phone,
              ),
              _detailRow('Role', customer.customerTag),
              _detailRow('Status', customer.accountStatus),
              _detailRow('Bergabung Sejak', customer.registeredAt),
              _detailRow('Total Pesanan', customer.totalOrders),
              _detailRow('Total Pembelanjaan', customer.totalSpent),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, CustomerRecord customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Customer'),
        content: Text(
          'Apakah Anda yakin ingin menghapus data customer ${customer.name}? Aksi ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final success = await context
                  .read<CustomerProvider>()
                  .deleteCustomer(customer.id);
              if (success && context.mounted) {
                AdminToast.show(
                  context,
                  'Customer berhasil dihapus',
                  type: AdminToastType.success,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sidebarCollapsed = context.watch<MenuProvider>().sidebarCollapsed;
    final customerProvider = context.watch<CustomerProvider>();
    final filtered = customerProvider.filteredCustomers;

    final metrics = [
      CustomerStat(
        title: 'Total Customer',
        value: customerProvider.totalCustomers.toString(),
        delta: '+0%',
        color: 0xFF16A34A,
        icon: Icons.people_outline,
      ),
      CustomerStat(
        title: 'Customer Aktif',
        value: customerProvider.activeCustomers.toString(),
        delta: '+0%',
        color: 0xFF0F8D55,
        icon: Icons.check_circle_outline,
      ),
      CustomerStat(
        title: 'Total Pesanan',
        value: '0',
        delta: '+0%',
        color: 0xFF3B82F6,
        icon: Icons.shopping_cart_outlined,
      ),
      CustomerStat(
        title: 'Total Pembelanjaan',
        value: 'Rp 0',
        delta: '+0%',
        color: 0xFF8B5CF6,
        icon: Icons.payments_outlined,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const padding = EdgeInsets.fromLTRB(24, 18, 24, 20);

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

                  _SectionCard(
                    child: _MetricGrid(
                      metrics: metrics,
                      sidebarCollapsed: sidebarCollapsed,
                    ),
                  ),
                  const SizedBox(height: 14),

                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daftar Customer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            SizedBox(
                              width: 260,
                              child: TextField(
                                controller: _searchController,
                                onChanged: customerProvider.setSearchQuery,
                                decoration: InputDecoration(
                                  hintText: 'Cari nama, email, hp...',
                                  hintStyle: const TextStyle(fontSize: 13),
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    size: 20,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (customerProvider.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(
                                color: Color(0xFF16A34A),
                              ),
                            ),
                          )
                        else if (filtered.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text('Tidak ada data customer'),
                            ),
                          )
                        else
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                const Color(0xFFF9FAFB),
                              ),
                              columns: const [
                                DataColumn(label: Text('Nama Lengkap')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('No. HP')),
                                DataColumn(label: Text('Tgl Daftar')),
                                DataColumn(label: Text('Aksi')),
                              ],
                              rows: filtered
                                  .map(
                                    (c) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            c.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(c.email)),
                                        DataCell(
                                          Text(c.phone.isEmpty ? '-' : c.phone),
                                        ),
                                        DataCell(
                                          Text(c.registeredAt.split('T').first),
                                        ),
                                        DataCell(
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.visibility,
                                                  size: 18,
                                                  color: Colors.green,
                                                ),
                                                onPressed: () =>
                                                    _showCustomerDetailDialog(
                                                      context,
                                                      c,
                                                    ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 18,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () =>
                                                    _showEditCustomerDialog(
                                                      context,
                                                      c,
                                                    ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 18,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () =>
                                                    _showDeleteConfirmDialog(
                                                      context,
                                                      c,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              'Kelola semua pelanggan terdaftar',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MetricGrid extends StatelessWidget {
  final List<CustomerStat> metrics;
  final bool sidebarCollapsed;

  const _MetricGrid({required this.metrics, required this.sidebarCollapsed});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const crossAxisCount = 4;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 110,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final m = metrics[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(m.color).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(m.color).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(m.color).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(m.icon, color: Color(m.color)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          m.title,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m.value,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
