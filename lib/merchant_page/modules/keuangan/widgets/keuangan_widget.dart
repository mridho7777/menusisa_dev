import 'package:menusisa_dev/merchant_page/shared/widgets/merchant_toast.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/widgets/charts/reusable_charts.dart';
import '../controllers/keuangan_controller.dart';
import '../models/keuangan_model.dart';

class KeuanganWidget extends StatefulWidget {
  final MerchantKeuanganController controller;
  final KeuanganModel data;

  const KeuanganWidget({super.key, required this.controller, required this.data});

  @override
  State<KeuanganWidget> createState() => _KeuanganWidgetState();
}

class _KeuanganWidgetState extends State<KeuanganWidget> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _paymentFormKey = GlobalKey<FormState>();
  final _rekeningController = TextEditingController(text: '1234567890');
  final _infoController = TextEditingController(text: 'Terima pembayaran otomatis');
  final _imagePathController = TextEditingController();
  final _picker = ImagePicker();
  final Map<String, TextEditingController> _methodControllers = {
    'Bayar di tempat': TextEditingController(text: 'Pembayaran tunai saat pesanan diterima'),
    'QRIS': TextEditingController(text: 'Pembayaran via QRIS aktif'),
    'M-Banking': TextEditingController(text: 'Transfer bank BCA/BRI/BNI/Mandiri'),
  };
  String _selectedMethod = 'QRIS';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _rekeningController.dispose();
    _infoController.dispose();
    _imagePathController.dispose();
    for (final controller in _methodControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _savePaymentSettings() {
    if (!_paymentFormKey.currentState!.validate()) return;
    MerchantToast.show(context, 'Metode pembayaran tersimpan', type: ToastType.success);
  }

  List<_SummaryItem> _summaryItems() {
    return [
      _SummaryItem(title: 'Saldo Saat Ini', value: 'Rp${widget.data.saldo.toStringAsFixed(0)}'),
      _SummaryItem(title: 'Pemasukan', value: 'Rp${widget.data.pemasukan.toStringAsFixed(0)}'),
      _SummaryItem(title: 'Pengeluaran', value: 'Rp${widget.data.pengeluaran.toStringAsFixed(0)}'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth >= 980
            ? (constraints.maxWidth - 24) / 3
            : constraints.maxWidth >= 640
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Keuangan', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 12),
              _FinanceTabs(controller: _tabController),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(width: cardWidth, child: const _SummaryCard(label: 'Pendapatan Hari Ini', value: 'Rp0')),
                  SizedBox(width: cardWidth, child: const _SummaryCard(label: 'Total Pendapatan', value: 'Rp0')),
                  SizedBox(width: cardWidth, child: const _SummaryCard(label: 'Total Pendapatan Keseluruhan', value: 'Rp0')),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 640,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _RangkumanTab(data: data, summaryItems: _summaryItems()),
                    _TransaksiTab(data: data),
                    _YangLainTab(
                      formKey: _paymentFormKey,
                      rekeningController: _rekeningController,
                      infoController: _infoController,
                      imagePathController: _imagePathController,
                      methodControllers: _methodControllers,
                      selectedMethod: _selectedMethod,
                      onMethodChanged: (value) => setState(() => _selectedMethod = value),
                      onSave: _savePaymentSettings,
                      picker: _picker,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FinanceTabs extends StatelessWidget {
  final TabController controller;

  const _FinanceTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: TabBar(
          controller: controller,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF475569),
          indicator: BoxDecoration(color: const Color(0xFF0F6B43), borderRadius: BorderRadius.circular(10)),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          tabs: const [Tab(text: 'Rangkuman'), Tab(text: 'Transaksi'), Tab(text: 'Yang Lain')],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: child,
    );
  }
}

class _RangkumanTab extends StatelessWidget {
  final KeuanganModel data;
  final List<_SummaryItem> summaryItems;

  const _RangkumanTab({required this.data, required this.summaryItems});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Update dengan komponen grafik baru
          const ReusableLineChart(
            title: 'Grafik Pendapatan',
            dataKey: 'Pendapatan',
            supabaseTable: 'merchant_financial_records',
            supabaseQuery: 'SELECT DATE(created_at) as date, SUM(amount) as total FROM merchant_financial_records WHERE merchant_id = \$MERCHANT_ID AND type = \'income\' AND created_at >= NOW() AND created_at <= NOW() + INTERVAL \'7 days\' GROUP BY date ORDER BY date',
          ),
          const SizedBox(height: 18),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ikhtisar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ...summaryItems.map((item) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _MiniStatCard(title: item.title, value: item.value))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  const _MiniStatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Row(
          children: [
            const Icon(Icons.insights_outlined, color: Color(0xFF0F6B43)),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0F6B43))),
          ],
        ),
      );
}

class _TransaksiTab extends StatelessWidget {
  final KeuanganModel data;
  const _TransaksiTab({required this.data});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: ListView.separated(
        itemCount: data.transactions.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = data.transactions[index];
          final isIncome = item.type == 'income';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: isIncome ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                  child: Icon(isIncome ? Icons.trending_up : Icons.trending_down, color: isIncome ? const Color(0xFF0F6B43) : const Color(0xFFDC2626), size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('${item.date.day}/${item.date.month}/${item.date.year}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    ],
                  ),
                ),
                Text('${isIncome ? '+' : '-'}Rp${item.amount.toInt()}', style: TextStyle(fontWeight: FontWeight.w700, color: isIncome ? const Color(0xFF0F6B43) : const Color(0xFFDC2626))),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _YangLainTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController rekeningController;
  final TextEditingController infoController;
  final TextEditingController imagePathController;
  final Map<String, TextEditingController> methodControllers;
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;
  final VoidCallback onSave;
  final ImagePicker picker;

  const _YangLainTab({
    required this.formKey,
    required this.rekeningController,
    required this.infoController,
    required this.imagePathController,
    required this.methodControllers,
    required this.selectedMethod,
    required this.onMethodChanged,
    required this.onSave,
    required this.picker,
  });

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePathController.text = pickedFile.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            const Text('Metode Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedMethod,
              decoration: const InputDecoration(labelText: 'Pilih Metode', border: OutlineInputBorder()),
              items: methodControllers.keys.map((String method) => DropdownMenuItem(value: method, child: Text(method))).toList(),
              onChanged: (value) {
                if (value != null) onMethodChanged(value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: rekeningController,
              decoration: const InputDecoration(labelText: 'Nomor Rekening / ID', border: OutlineInputBorder()),
              validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: methodControllers[selectedMethod],
              decoration: const InputDecoration(labelText: 'Informasi Tambahan', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: imagePathController,
                    decoration: const InputDecoration(labelText: 'Unggah QR / Bukti', border: OutlineInputBorder()),
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () => _pickImage(context), child: const Text('Pilih')),
              ],
            ),
            if (imagePathController.text.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(imagePathController.text), height: 200, fit: BoxFit.cover)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: const Color(0xFF0F6B43)),
              child: const Text('Simpan Pengaturan', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem {
  final String title;
  final String value;
  _SummaryItem({required this.title, required this.value});
}

