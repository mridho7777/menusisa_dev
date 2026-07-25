import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '_parts/auth_components.dart';
import '_parts/page_fade_route.dart';
import 'daftar_penjual_screen.dart';
import 'package:menusisa_dev/core/auth/auth_service.dart';
import 'package:menusisa_dev/main_merchant_page.dart';

class LoginPenjualScreen extends StatelessWidget {
  const LoginPenjualScreen({super.key});

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
                    ? Row(
                        children: [
                          const Expanded(child: AuthSidebarArt(asset: 'assets/images/login_seller.png', title: 'Masuk sebagai\nPemilik Toko')),
                          const Expanded(child: _LoginForm()),
                        ],
                      )
                    : const SingleChildScrollView(padding: EdgeInsets.all(24), child: _LoginForm()),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      _showError('Email dan kata sandi harus diisi');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      if (!result.success) {
        _showError(result.message);
        setState(() => _isLoading = false);
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message), backgroundColor: Colors.green, duration: const Duration(seconds: 1)));
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MerchantApp()), (route) => false);
    } catch (e) {
      if (mounted) {
        _showError('Error tidak diketahui: $e');
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Masuk', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('Selamat datang kembali, Pemilik Toko!', style: TextStyle(color: AppColors.textGrey)),
          const SizedBox(height: 28),
          AuthField(controller: _emailController, label: 'Email', hint: 'Contoh: email@example.com'),
          const SizedBox(height: 16),
          AuthField(controller: _passwordController, label: 'Kata Sandi', hint: 'Masukkan kata sandi', obscure: true),
          const SizedBox(height: 10),
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('Lupa kata sandi?'))),
          const SizedBox(height: 8),
          PrimaryAuthButton(label: 'Masuk', isLoading: _isLoading, onPressed: _handleLogin),
          const SizedBox(height: 28),
          Center(child: TextButton(onPressed: () => Navigator.of(context).push(PageFadeRoute(builder: (_) => const DaftarPenjualScreen())), child: const Text('Belum punya akun? Daftar'))),
        ],
      ),
    );
  }
}
