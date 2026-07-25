import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '_parts/auth_components.dart';
import '_parts/page_fade_route.dart';
import 'package:menusisa_dev/core/auth/auth_service.dart';
import 'package:menusisa_dev/core/utils/restart_widget.dart';

class DaftarPembeliScreen extends StatelessWidget {
  const DaftarPembeliScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              return Container(
                constraints: BoxConstraints(maxWidth: isDesktop ? 1100 : 420),
                child: isDesktop
                    ? Row(children: [
                        const Expanded(child: AuthSidebarArt(asset: 'assets/images/register_buyer.png', title: 'Daftar Akun\nPembeli')),
                        const Expanded(child: _RegisterForm())
                      ])
                    : const SingleChildScrollView(padding: EdgeInsets.all(24), child: _RegisterForm()),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Validasi input
    if (_nameController.text.trim().isEmpty) {
      _showError('Nama lengkap harus diisi');
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showError('Email harus diisi');
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showError('Password harus diisi');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showError('Password minimal 6 karakter');
      return;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Kata sandi tidak cocok');
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Sign up menggunakan AuthService
      final result = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
        role: 'customer',
      );

      if (!mounted) return;

      if (!result.success) {
        _showError(result.message);
        setState(() => _isLoading = false);
        return;
      }

      // Sign up berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Wait untuk user lihat success message
      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) return;

      // Restart app untuk trigger AuthRouter
      // User sudah login otomatis setelah sign up
      RestartWidget.restartApp(context);
      
    } catch (e) {
      if (mounted) {
        _showError('Error tidak diketahui: $e');
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Daftar Akun', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('Buat akun baru untuk mulai menggunakan MenuSisa.', style: TextStyle(color: AppColors.textGrey)),
          const SizedBox(height: 28),
          AuthField(
            controller: _nameController,
            label: 'Nama Lengkap',
            hint: 'Masukkan nama lengkap',
          ),
          const SizedBox(height: 16),
          AuthField(
            controller: _emailController,
            label: 'Email',
            hint: 'Contoh: email@example.com',
          ),
          const SizedBox(height: 16),
          AuthField(
            controller: _phoneController,
            label: 'No. WhatsApp (Opsional)',
            hint: 'Contoh: 08123456789',
          ),
          const SizedBox(height: 16),
          AuthField(
            controller: _passwordController,
            label: 'Kata Sandi',
            hint: 'Minimal 6 karakter',
            obscure: true,
          ),
          const SizedBox(height: 16),
          AuthField(
            controller: _confirmPasswordController,
            label: 'Konfirmasi Kata Sandi',
            hint: 'Ulangi kata sandi',
            obscure: true,
          ),
          const SizedBox(height: 18),
          PrimaryAuthButton(
            label: 'Daftar',
            isLoading: _isLoading,
            onPressed: _handleRegister,
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Sudah punya akun? Masuk'),
            ),
          ),
        ],
      ),
    );
  }
}