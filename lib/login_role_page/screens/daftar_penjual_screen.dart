import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '_parts/auth_components.dart';
import '_parts/page_fade_route.dart';
import 'login_penjual_screen.dart';
import 'package:menusisa_dev/core/auth/auth_service.dart';
import 'package:menusisa_dev/core/utils/restart_widget.dart';

class DaftarPenjualScreen extends StatefulWidget {
  const DaftarPenjualScreen({super.key});

  @override
  State<DaftarPenjualScreen> createState() => _DaftarPenjualScreenState();
}

class _DaftarPenjualScreenState extends State<DaftarPenjualScreen> {
  bool _showForm = false;
  final _shopNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _authService = AuthService.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _shopNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              final maxContentWidth = isDesktop ? 600.0 : double.infinity;

              return Container(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _showForm ? _buildRegisterForm() : _buildOnboardingSeller(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  // Slide 6: Onboarding Seller
  Widget _buildOnboardingSeller() {
    return Column(
      key: const ValueKey('onboarding_seller'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 12),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              const SizedBox(height: 10),
              // Illustration placeholder
              Center(
                child: Container(
                  height: 220,
                  width: 220,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.storefront, size: 100, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Jual Makanan Berlebih\nJadi Lebih Mudah',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.25),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bantu kurangi food waste sekaligus tambah penghasilan dengan MenuSisa.',
                style: TextStyle(color: Colors.black54, fontSize: 15, height: 1.45),
              ),
              const SizedBox(height: 24),
              _buildBulletPoint('Jangkau lebih banyak pelanggan'),
              _buildBulletPoint('Proses jualan mudah & cepat'),
              _buildBulletPoint('Keuntungan lebih besar'),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => setState(() => _showForm = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Daftar Sekarang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Pelajari lebih lanjut', style: TextStyle(color: AppColors.textGrey)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  // Slide 7: Form Registrasi Merchant
  Widget _buildRegisterForm() {
    return Column(
      key: const ValueKey('register_form'),
      children: [
        // Header hijau dengan ikon toko
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 40, bottom: 60),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => setState(() => _showForm = false),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 10),
              const Icon(Icons.storefront, color: Colors.white, size: 64),
            ],
          ),
        ),

        // Form body melengkung putih
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                const Text(
                  'Daftar Akun Toko',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lengkapi data di bawah untuk mendaftar sebagai penjual.',
                  style: TextStyle(color: AppColors.textGrey),
                ),
                const SizedBox(height: 24),
                AuthField(
                  controller: _shopNameController,
                  label: 'Nama Toko',
                  hint: 'Masukkan nama toko',
                ),
                const SizedBox(height: 16),
                AuthField(
                  controller: _fullNameController,
                  label: 'Nama Lengkap Pemilik',
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
                  label: 'No. WhatsApp',
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
                  controller: _confirmController,
                  label: 'Konfirmasi Kata Sandi',
                  hint: 'Ulangi kata sandi',
                  obscure: true,
                ),
                const SizedBox(height: 24),
                PrimaryAuthButton(
                  label: 'Daftar',
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        PageFadeRoute(builder: (_) => const LoginPenjualScreen()),
                      );
                    },
                    child: const Text('Sudah punya akun toko? Masuk', style: TextStyle(color: Colors.black54)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleRegister() async {
    // Validasi input
    if (_shopNameController.text.trim().isEmpty) {
      _showError('Nama toko harus diisi');
      return;
    }

    if (_fullNameController.text.trim().isEmpty) {
      _showError('Nama lengkap harus diisi');
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showError('Email harus diisi');
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      _showError('No. WhatsApp harus diisi');
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

    if (_passwordController.text != _confirmController.text) {
      _showError('Kata sandi tidak cocok');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Sign up menggunakan AuthService
      final result = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        role: 'merchant',
      );

      if (!mounted) return;

      if (!result.success) {
        _showError(result.message);
        setState(() => _isLoading = false);
        return;
      }

      // Sekarang buat entry di merchants table dengan shop_name
      try {
        await _authService.client.from('merchants').insert({
          'user_id': result.user!.id,
          'shop_name': _shopNameController.text.trim(),
          'shop_address': '-', // Default, akan diisi lengkap nanti
          'approval_status': 'pending',
        });
      } catch (e) {
        debugPrint('Error creating merchant entry: $e');
        // Continue anyway, merchant bisa melengkapi nanti
      }

      // Sign up berhasil
      if (!mounted) return;

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 72, color: AppColors.primary),
              const SizedBox(height: 16),
              const Text('Registrasi Berhasil!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Akun toko Anda telah berhasil didaftarkan dan menunggu persetujuan admin.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  // Restart app untuk masuk ke pending screen
                  RestartWidget.restartApp(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      );
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
}
