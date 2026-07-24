import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:menusisa_dev/core/utils/restart_widget.dart';
import 'package:menusisa_dev/merchant_page/shared/widgets/merchant_toast.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../providers/merchant_workspace_provider.dart';
import '../../notifikasi/controllers/notifikasi_controller.dart';
import '../controllers/profil_controller.dart';
import '../models/profil_model.dart';

class ProfilWidget extends StatefulWidget {
  final MerchantProfilController controller;
  final ProfilModel data;

  const ProfilWidget({super.key, required this.controller, required this.data});

  @override
  State<ProfilWidget> createState() => _ProfilWidgetState();
}

class _ProfilWidgetState extends State<ProfilWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _editingId;
  Uint8List? _imageBytes;


  @override
  void initState() {
    super.initState();
    // Isi form otomatis dengan data dari database saat inisialisasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.data.records.isNotEmpty) {
        _fillForm(widget.data.records.first);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({required bool banner}) async {
    final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90, maxHeight: 1600, maxWidth: 1600);
    if (image == null) return;
    final bytes = await image.readAsBytes();
    if (!mounted) return;
    if (!banner) {
      setState(() => _imageBytes = bytes);
    }
    final workspace = context.read<MerchantWorkspaceProvider>();
    final notifController = context.read<MerchantNotifikasiController>();
    if (banner) {
      workspace.updateBanner(imageBytes: bytes, imageLabel: image.name);
      notifController.addNotification(title: 'Banner Profil Diperbarui', description: 'Banner profil berhasil diperbarui dengan ${image.name}.', iconKey: 'settings');
    } else {
      workspace.updateProfile(profileName: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(), imageBytes: bytes, imageLabel: image.name);
      notifController.addNotification(title: 'Foto Profil Diperbarui', description: 'Foto profil berhasil diperbarui dengan ${image.name}.', iconKey: 'settings');
    }
  }

  void _fillForm([ProfileRecord? record]) {
    _editingId = record?.id;
    _nameController.text = record?.name ?? '';
    _whatsappController.text = record?.whatsapp ?? '';
    _emailController.text = record?.email ?? '';
    _passwordController.text = '';
    setState(() {});
  }

  Future<void> _save() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      try {
        await Supabase.instance.client.from('users').update({
          'full_name': _nameController.text.trim(),
          'phone': _whatsappController.text.trim(),
        }).eq('id', userId);
        await Supabase.instance.client.from('merchants').update({
          'shop_name': _nameController.text.trim(),
          'shop_phone': _whatsappController.text.trim(),
        }).eq('user_id', userId);
      } catch (e) {}
    }
    if (!_formKey.currentState!.validate()) return;
    final record = ProfileRecord(id: _editingId ?? DateTime.now().millisecondsSinceEpoch.toString(), name: _nameController.text.trim(), whatsapp: _whatsappController.text.trim(), email: _emailController.text.trim(), password: _passwordController.text.trim().isEmpty ? '******' : _passwordController.text.trim());
    if (_editingId == null) {
      widget.controller.addRecord(record);
      context.read<MerchantNotifikasiController>().addNotification(title: 'Profil Ditambahkan', description: 'Profil ${record.name} berhasil disimpan.', iconKey: 'check');
    } else {
      widget.controller.updateRecord(_editingId!, record);
      context.read<MerchantNotifikasiController>().addNotification(title: 'Profil Diperbarui', description: 'Profil ${record.name} berhasil diperbarui.', iconKey: 'edit');
    }
    context.read<MerchantWorkspaceProvider>().updateStoreInfo(storeName: record.name, email: record.email);
    context.read<MerchantWorkspaceProvider>().updateProfile(profileName: record.name, imageBytes: _imageBytes);
    MerchantToast.show(context, 'Data profil tersimpan', type: ToastType.success);
  }

  @override

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari halaman Toko?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await Supabase.instance.client.auth.signOut();
      if (context.mounted) {
        RestartWidget.restartApp(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<MerchantWorkspaceProvider>();
    final record = widget.data.records.isNotEmpty ? widget.data.records.first : null;
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Profil Merchant', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 8),
              const Text('Profil konsisten, profesional, dan sinkron ke Toko Saya.', style: TextStyle(color: Color(0xFF64748B))),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 800;
                  final formSection = Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        _field('Nama Toko', _nameController, validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null),
                        _field('No. Whatsapp', _whatsappController, validator: (v) => (v == null || v.trim().isEmpty) ? 'Nomor wajib diisi' : null),
                        _field('Email', _emailController, readOnly: true, validator: (v) => (v == null || !v.contains('@')) ? 'Email tidak valid' : null),
                        _field('Sandi 6 Digit', _passwordController, obscure: true, maxLength: 6, validator: (v) { if (v == null || v.isEmpty) return 'Sandi wajib diisi'; if (v.length != 6) return 'Sandi harus 6 digit'; return null; }),
                        const SizedBox(height: 12),
                        Wrap(spacing: 10, runSpacing: 10, children: [
                          FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save_outlined, size: 18), label: const Text('Simpan')),
                          OutlinedButton.icon(onPressed: record == null ? null : () { final deletedId = record.id; widget.controller.deleteRecord(deletedId); _fillForm(); context.read<MerchantNotifikasiController>().addNotification(title: 'Profil Dihapus', description: 'Profil ${record.name} (ID ${deletedId.length > 6 ? deletedId.substring(deletedId.length - 6) : deletedId}) telah dihapus.', iconKey: 'close'); }, icon: const Icon(Icons.delete_outline, size: 18), label: const Text('Hapus')),
                          OutlinedButton.icon(onPressed: () => _fillForm(record), icon: const Icon(Icons.edit_outlined, size: 18), label: const Text('Edit')),
                          OutlinedButton.icon(onPressed: () => _pickImage(banner: false), icon: const Icon(Icons.image_outlined, size: 18), label: const Text('Upload Profil')),
                          OutlinedButton.icon(onPressed: () => _pickImage(banner: true), icon: const Icon(Icons.panorama_outlined, size: 18), label: const Text('Upload Banner')),
                        ]),
                      ]),
                    ),
                  );
                  final previewSection = Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Preview Profil', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                CircleAvatar(radius: 36, backgroundColor: const Color(0xFFE2E8F0), backgroundImage: workspace.profileImageBytes == null ? null : MemoryImage(workspace.profileImageBytes!)),
                                const SizedBox(width: 12),
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(workspace.profileName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)), const SizedBox(height: 4), Text(workspace.email, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)))])),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(workspace.profileImageLabel ?? 'Foto profil belum dipilih', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: workspace.bannerImageBytes == null
                              ? const Center(child: Text('Preview Banner', style: TextStyle(color: Color(0xFF94A3B8))))
                              : Image.memory(workspace.bannerImageBytes!, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Preview ini akan tampil di halaman Toko Saya dan header.', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  );
                  return wide
                      ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: formSection), const SizedBox(width: 16), Expanded(flex: 2, child: previewSection)])
                      : Column(children: [formSection, const SizedBox(height: 16), previewSection]);
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Data Tersimpan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ElevatedButton.icon(
                    onPressed: () => _handleLogout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Keluar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...widget.data.records.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
                  child: Row(children: [
                    const CircleAvatar(backgroundColor: Color(0xFFD1FAE5), child: Icon(Icons.person_outline, color: Color(0xFF0F6B43), size: 18)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 4), Text(item.email, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12))])),
                    IconButton(onPressed: () => _fillForm(item), icon: const Icon(Icons.edit_outlined)),
                    IconButton(onPressed: () => widget.controller.deleteRecord(item.id), icon: const Icon(Icons.delete_outline, color: Colors.red)),
                  ]),
                ),
              )),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, {bool obscure = false, int? maxLength, int maxLines = 1, String? Function(String?)? validator, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        maxLength: maxLength,
        maxLines: maxLines,
        validator: validator,
        readOnly: readOnly,
        decoration: InputDecoration(labelText: label, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      ),
    );
  }
}

