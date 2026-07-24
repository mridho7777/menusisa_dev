import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:menusisa_dev/core/utils/restart_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:provider/provider.dart';

import '../app_state.dart';
import '../services/user_profile_service.dart';
import '../utils/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileService = UserProfileService.instance;
  final _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _fullName;
  String? _email;
  String? _phone;
  String? _avatarUrl;
  String? _role = 'customer';
  String? _userId;
  String? _createdAt;
  String? _updatedAt;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _editMode = false;
  File? _pickedAvatar;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    if (!_profileService.isAuthenticated) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final profile = await _profileService.getUserProfile();
      if (!mounted) return;
      setState(() {
        _userId = profile?['id']?.toString() ?? _profileService.userId;
        _fullName =
            profile?['full_name']?.toString() ??
            _profileService.userEmail?.split('@').first ??
            'Pengguna';
        _email = profile?['email']?.toString() ?? _profileService.userEmail;
        _phone = profile?['phone']?.toString();
        _avatarUrl = profile?['avatar_url']?.toString();
        _role = profile?['role']?.toString() ?? 'customer';
        _createdAt = profile?['created_at']?.toString();
        _updatedAt = profile?['updated_at']?.toString();
        _nameController.text = _fullName ?? '';
        _phoneController.text = _phone ?? '';
        _addressController.text = profile?['address']?.toString() ?? '';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackBar('Gagal memuat profil: $e', isError: true);
    }
  }

  Future<void> _pickAvatar() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
      maxHeight: 1200,
    );
    if (image == null) return;
    setState(() => _pickedAvatar = File(image.path));
  }

  Future<bool> _verifyPassword(String password) async {
    final email = _email;
    if (email == null || email.isEmpty) return false;
    try {
      final client = Supabase.instance.client;
      final result = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return result.session != null;
    } catch (_) {
      return false;
    }
  }

  Future<void> _showEditDialog({String? field}) async {
    final nameCtrl = TextEditingController(text: _nameController.text);
    final phoneCtrl = TextEditingController(text: _phoneController.text);
    final addressCtrl = TextEditingController(text: _addressController.text);

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (field == null || field == 'name')
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                ),
              if (field == null || field == 'name') const SizedBox(height: 12),
              if (field == null || field == 'phone')
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Nomor HP'),
                ),
              if (field == null || field == 'phone') const SizedBox(height: 12),
              if (field == null || field == 'address')
                TextField(
                  controller: addressCtrl,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                  maxLines: 2,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result != true) return;
    setState(() {
      _nameController.text = nameCtrl.text.trim();
      _phoneController.text = phoneCtrl.text.trim();
      _addressController.text = addressCtrl.text.trim();
      _editMode = true;
    });
    await _saveProfile();
  }

  Future<void> _saveProfile() async {
    if (!_editMode) return;
    final verifyCtrl = TextEditingController();
    final confirm = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Verifikasi sandi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Masukkan sandi utama akun $_email.'),
            const SizedBox(height: 12),
            TextField(
              controller: verifyCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Sandi utama'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, verifyCtrl.text),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
    if (confirm == null || confirm.isEmpty) return;

    if (_passwordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty) {
      if (_passwordController.text.length < 6) {
        _showSnackBar('Password minimal 6 karakter', isError: true);
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        _showSnackBar('Konfirmasi password tidak cocok', isError: true);
        return;
      }
    }

    setState(() => _isSaving = true);
    try {
      final verified = await _verifyPassword(confirm);
      if (!verified) throw Exception('Sandi utama salah');

      String? avatarUrl = _avatarUrl;
      if (_pickedAvatar != null) {
        avatarUrl = await _profileService.uploadAvatar(_pickedAvatar!);
        if (avatarUrl == null) throw Exception('Upload avatar gagal');
      }

      final ok = await _profileService.updateProfile(
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        avatarUrl: avatarUrl,
      );
      if (!ok) throw Exception('Update data gagal');

      if (_passwordController.text.isNotEmpty) {
        final pwOk = await _profileService.updatePassword(
          _passwordController.text,
        );
        if (!pwOk) throw Exception('Update password gagal');
      }

      setState(() {
        _fullName = _nameController.text.trim();
        _phone = _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim();
        _avatarUrl = avatarUrl;
        _pickedAvatar = null;
        _passwordController.clear();
        _confirmPasswordController.clear();
        _editMode = false;
      });
      await _loadUserProfile();
      _showSnackBar('Profil tersimpan');
    } catch (e) {
      _showSnackBar('Gagal simpan profil: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _editSingleField(String field) async {
    if (field == 'id') return;
    if (field == 'password') {
      final current = TextEditingController();
      final next = TextEditingController();
      final confirm = TextEditingController();
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ubah sandi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: current,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Sandi utama'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: next,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Sandi baru'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirm,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi sandi baru',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Konfirmasi'),
            ),
          ],
        ),
      );
      if (result != true) return;
      setState(() {
        _passwordController.text = next.text;
        _confirmPasswordController.text = confirm.text;
      });
      await _saveProfile();
      return;
    }

    final controller = field == 'name'
        ? TextEditingController(text: _nameController.text)
        : field == 'phone'
        ? TextEditingController(text: _phoneController.text)
        : TextEditingController(text: _addressController.text);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          field == 'name'
              ? 'Edit Nama'
              : field == 'phone'
              ? 'Edit Nomor HP'
              : 'Edit Alamat',
        ),
        content: TextField(
          controller: controller,
          maxLines: field == 'address' ? 2 : 1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (value == null) return;
    setState(() {
      if (field == 'name') _nameController.text = value.trim();
      if (field == 'phone') _phoneController.text = value.trim();
      if (field == 'address') _addressController.text = value.trim();
      _editMode = true;
    });
    await _saveProfile();
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus akun'),
        content: const Text(
          'Akun customer akan dihapus dari Supabase. Lanjut?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final ok = await _profileService.deleteAccount();
    if (ok && mounted) RestartWidget.restartApp(context);
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) RestartWidget.restartApp(context);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : AppColors.primary,
      ),
    );
  }

  ImageProvider<Object>? _avatarImageProvider() {
    if (_pickedAvatar != null) {
      return FileImage(_pickedAvatar!);
    }
    if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
      return NetworkImage(_avatarUrl!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final avatar = _avatarImageProvider();
    final initials = (_fullName ?? _email ?? 'U').trim().isEmpty
        ? 'U'
        : (_fullName ?? _email ?? 'U').trim()[0].toUpperCase();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF8FBF9), Color(0xFFE9F7EF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Profil Saya',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => _editMode
                              ? _showEditDialog()
                              : setState(() => _editMode = true),
                          icon: const Icon(Icons.edit, size: 18),
                          label: Text(_editMode ? 'Selesai' : 'Edit Profil'),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _logout,
                          icon: const Icon(Icons.settings_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 58,
                            backgroundColor: Colors.white,
                            backgroundImage: avatar,
                            child: avatar == null
                                ? Text(
                                    initials,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  )
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: _pickAvatar,
                              child: Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: Text(
                        _fullName ?? '-',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          (_role ?? 'customer').toLowerCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InfoCard(
                      title: 'Informasi Akun',
                      child: Column(
                        children: [
                          _InfoRow(
                            label: 'ID Pengguna',
                            value: _userId ?? '-',
                            editable: false,
                            onTap: null,
                          ),
                          _InfoRow(
                            label: 'Nama Lengkap',
                            value: _nameController.text,
                            editable: true,
                            onTap: () => _editSingleField('name'),
                          ),
                          _InfoRow(
                            label: 'Email',
                            value: _email ?? '-',
                            editable: false,
                            onTap: null,
                          ),
                          _InfoRow(
                            label: 'Nomor Telepon',
                            value: (_phone == null || _phone!.isEmpty)
                                ? '-'
                                : _phone!,
                            editable: true,
                            onTap: () => _editSingleField('phone'),
                          ),
                          _InfoRow(
                            label: 'Peran',
                            value: _role ?? 'customer',
                            editable: false,
                            onTap: null,
                          ),
                          _InfoRow(
                            label: 'Bergabung Sejak',
                            value: _createdAt ?? '-',
                            editable: false,
                            onTap: null,
                          ),
                          _InfoRow(
                            label: 'Terakhir Diperbarui',
                            value: _updatedAt ?? '-',
                            editable: false,
                            onTap: null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1.15,
                            child: _QuickTile(
                              title: 'Pesanan',
                              subtitle: 'Lihat pesanan Anda',
                              icon: Icons.receipt_long,
                              onTap: () =>
                                  context.read<AppState>().changeNavIndex(1),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1.15,
                            child: _QuickTile(
                              title: 'Favorit',
                              subtitle: 'Produk favorit',
                              icon: Icons.favorite,
                              onTap: () =>
                                  context.read<AppState>().changeNavIndex(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1.15,
                            child: _QuickTile(
                              title: 'Keranjang',
                              subtitle: 'Lihat keranjang Anda',
                              icon: Icons.shopping_cart_outlined,
                              onTap: () =>
                                  context.read<AppState>().changeNavIndex(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _InfoCard(
                      title: 'Aksi Akun',
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.password_outlined,
                              color: AppColors.primary,
                            ),
                            title: const Text('Ubah Sandi'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _editSingleField('password'),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(
                              Icons.location_on_outlined,
                              color: AppColors.primary,
                            ),
                            title: const Text('Alamat Saya'),
                            subtitle: Text(
                              _addressController.text.isEmpty
                                  ? 'Belum diisi'
                                  : _addressController.text,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _editSingleField('address'),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(
                              Icons.notifications_none_outlined,
                              color: AppColors.primary,
                            ),
                            title: const Text('Notifikasi'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(
                              Icons.help_outline,
                              color: AppColors.primary,
                            ),
                            title: const Text('Bantuan & Pusat Bantuan'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(
                              Icons.info_outline,
                              color: AppColors.primary,
                            ),
                            title: const Text('Tentang Aplikasi'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            title: const Text(
                              'Keluar',
                              style: TextStyle(color: Colors.red),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.red,
                            ),
                            onTap: _logout,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isSaving ? null : _saveProfile,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: const Text('Konfirmasi Ubah Data'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _deleteAccount,
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: const Text(
                        'Hapus Akun',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _InfoCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool editable;
  final VoidCallback? onTap;
  const _InfoRow({
    required this.label,
    required this.value,
    required this.editable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(label),
          subtitle: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          trailing: editable
              ? IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: onTap,
                )
              : const Icon(Icons.lock_outline, size: 18),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _QuickTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _QuickTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
