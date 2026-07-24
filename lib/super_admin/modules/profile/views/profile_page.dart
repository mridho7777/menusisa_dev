import 'package:menusisa_dev/super_admin/shared/widgets/admin_toast.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import 'package:menusisa_dev/core/utils/restart_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Super Admin');
  final _emailController = TextEditingController(text: 'superadmin@menusisa.id');
  final _phoneController = TextEditingController(text: '021-1234-5678');
  final _positionController = TextEditingController(text: 'Super Administrator');
  
  File? _avatarImage;
  final _picker = ImagePicker();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.profile);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    
    if (pickedFile != null) {
      if (!mounted) return;
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
      AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
    }
  }

  void _removeAvatar() {
    setState(() {
      _avatarImage = null;
    });
    AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isEditing = false);
      AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari halaman Super Admin?'),
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
      if (mounted) {
        RestartWidget.restartApp(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Profile Settings',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      ElevatedButton.icon(
                        onPressed: _handleLogout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text('Keluar Sistem', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Content details will be truncated to keep it small
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar Section
                        Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: const Color(0xFFF3F4F6),
                                  backgroundImage: _avatarImage != null 
                                      ? FileImage(_avatarImage!) 
                                      : null,
                                  child: _avatarImage == null 
                                      ? const Icon(Icons.person, size: 60, color: Color(0xFF9CA3AF))
                                      : null,
                                ),
                                if (_isEditing)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: _pickImage,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF16A34A),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            if (_isEditing && _avatarImage != null) ...[
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: _removeAvatar,
                                icon: const Icon(Icons.delete_outline, size: 18),
                                label: const Text('Hapus Foto'),
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                              ),
                            ]
                          ],
                        ),
                        const SizedBox(width: 32),
                        
                        // Form Section
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Informasi Pribadi',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    if (!_isEditing)
                                      ElevatedButton.icon(
                                        onPressed: () => setState(() => _isEditing = true),
                                        icon: const Icon(Icons.edit_outlined, size: 18),
                                        label: const Text('Edit Profil'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF0FDF4),
                                          foregroundColor: const Color(0xFF16A34A),
                                          elevation: 0,
                                        ),
                                      )
                                    else
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () => setState(() => _isEditing = false),
                                            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: _saveProfile,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF16A34A),
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('Simpan'),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                _buildFormField('Nama Lengkap', _nameController, Icons.person_outline),
                                const SizedBox(height: 16),
                                _buildFormField('Email', _emailController, Icons.email_outlined, isEmail: true),
                                const SizedBox(height: 16),
                                _buildFormField('No. HP', _phoneController, Icons.phone_outlined),
                                const SizedBox(height: 16),
                                _buildFormField('Posisi / Jabatan', _positionController, Icons.work_outline),
                              ],
                            ),
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

  Widget _buildFormField(String label, TextEditingController controller, IconData icon, {bool isEmail = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: _isEditing && !isEmail, // Email usually can't be changed easily
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6B7280)),
            filled: true,
            fillColor: _isEditing && !isEmail ? Colors.white : const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }
}
