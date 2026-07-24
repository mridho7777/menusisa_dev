import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:menusisa_dev/merchant_page/core/config/supabase_config.dart';

import 'merchant_page/providers/merchant_nav_provider.dart';
import 'merchant_page/providers/merchant_workspace_provider.dart';
import 'merchant_page/modules/produk/controllers/produk_controller.dart';
import 'merchant_page/modules/notifikasi/controllers/notifikasi_controller.dart';
import 'merchant_page/modules/dashboard/views/dashboard_view.dart';
import 'merchant_page/modules/produk/views/produk_view.dart';
import 'merchant_page/modules/pesanan/views/pesanan_view.dart';
import 'merchant_page/modules/pelanggan/views/pelanggan_view.dart';
import 'merchant_page/modules/keuangan/views/keuangan_view.dart';
import 'merchant_page/modules/notifikasi/views/notifikasi_view.dart';
import 'merchant_page/modules/pengaturan/views/pengaturan_view.dart';
import 'merchant_page/modules/profil/views/profil_view.dart';
import 'merchant_page/modules/toko_saya/views/toko_saya_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MerchantNavProvider()),
        ChangeNotifierProvider(create: (_) => MerchantWorkspaceProvider()..loadData()),
        ChangeNotifierProvider(create: (_) => MerchantProdukController()..loadData()),
        ChangeNotifierProvider(create: (_) => MerchantNotifikasiController()..loadData()),
      ],
      child: const MerchantApp(),
    ),
  );
}

class MerchantApp extends StatefulWidget {
  const MerchantApp({super.key});

  @override
  State<MerchantApp> createState() => _MerchantAppState();
}

class _MerchantAppState extends State<MerchantApp> {
  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.tokenRefreshed) {
        _refreshRoleData();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshRoleData());
  }

  Future<void> _refreshRoleData() async {
    if (!mounted) return;
    final workspace = context.read<MerchantWorkspaceProvider>();
    final produk = context.read<MerchantProdukController>();
    final notifikasi = context.read<MerchantNotifikasiController>();
    await Future.wait([
      workspace.loadData(),
      produk.loadData(),
      notifikasi.loadData(),
    ]);
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MenuSisa Merchant',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primaryColor: const Color(0xFF0F6B43),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        useMaterial3: true,
      ),
      home: const MerchantMainLayout(),
    );
  }
}

class MerchantMainLayout extends StatelessWidget {
  const MerchantMainLayout({super.key});

  static const double _desktopLayoutWidth = 1440;

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<MerchantNavProvider>(context);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: MerchantHeader(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final viewportHeight = constraints.maxHeight;

          return Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _desktopLayoutWidth,
                child: SizedBox(
                  height: viewportHeight,
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: navProvider.isSidebarOpen ? 260.0 : 0.0,
                        child: const MerchantSidebar(),
                      ),
                      Expanded(
                        child: Container(
                          color: const Color(0xFFF8FAFC),
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(32.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: _getActiveView(navProvider.currentIndex),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getActiveView(int index) {
    switch (index) {
      case 0:
        return const DashboardView();
      case 1:
        return const ProdukView();
      case 2:
        return const PesananView();
      case 3:
        return const PelangganView();
      case 4:
        return const KeuanganView();
      case 5:
        return const NotifikasiView();
      case 6:
        return const PengaturanView();
      case 7:
        return const ProfilView();
      case 8:
        return const TokoSayaView();
      default:
        return const DashboardView();
    }
  }
}

class MerchantHeader extends StatelessWidget {
  const MerchantHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<MerchantNavProvider>(context, listen: false);
    final notificationController = context.watch<MerchantNotifikasiController>();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final showCompactBranding = screenWidth < 420;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1.0,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final headerWidth = constraints.maxWidth < 1100 ? 1100.0 : constraints.maxWidth;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: headerWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black87),
                      onPressed: () => navProvider.toggleSidebar(),
                    ),
                    const SizedBox(width: 6),
                    SvgPicture.asset(
                      'assets/svg/logonotext.svg',
                      height: 36,
                      width: 36,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F6B43).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.storefront_outlined,
                            color: Color(0xFF0F6B43),
                            size: 20,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MenuSisa',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F6B43),
                            ),
                          ),
                          if (!showCompactBranding)
                            const Text(
                              'Merchant',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4C934C),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (screenWidth > 900) ...[
                      const HeaderDateTimeWidget(),
                      const SizedBox(width: 24),
                    ],
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none_outlined, color: Colors.black87, size: 28),
                          onPressed: () => Provider.of<MerchantNavProvider>(context, listen: false).setIndex(5),
                        ),
                        if (notificationController.unreadCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                              child: Text(
                                notificationController.unreadCount > 99 ? '99+' : '${notificationController.unreadCount}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    if (screenWidth > 600)
                      Consumer<MerchantWorkspaceProvider>(
                        builder: (context, workspace, child) => InkWell(
                          onTap: () {
                            Provider.of<MerchantNavProvider>(context, listen: false).setIndex(7);
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(0xFFE2E8F0),
                                  backgroundImage: workspace.profileImageBytes == null ? null : MemoryImage(workspace.profileImageBytes!),
                                  child: workspace.profileImageBytes == null ? const Icon(Icons.person_outline, size: 18, color: Color(0xFF94A3B8)) : null,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  workspace.email,
                                  style: const TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (screenWidth > 600) const SizedBox(width: 12),
                    if (screenWidth > 700)
                      OutlinedButton.icon(
                        onPressed: () => Provider.of<MerchantNavProvider>(context, listen: false).setIndex(8),
                        icon: const Icon(Icons.storefront_outlined, size: 18),
                        label: const Text(
                          'Toko Saya',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0F6B43),
                          side: const BorderSide(color: Color(0xFF0F6B43), width: 1.5),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HeaderDateTimeWidget extends StatefulWidget {
  const HeaderDateTimeWidget({super.key});

  @override
  State<HeaderDateTimeWidget> createState() => _HeaderDateTimeWidgetState();
}

class _HeaderDateTimeWidgetState extends State<HeaderDateTimeWidget> {
  late Timer _timer;
  late String _timeString;

  @override
  void initState() {
    super.initState();
    _timeString = _getFormattedDateTime();
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      if (mounted) {
        setState(() {
          _timeString = _getFormattedDateTime();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getFormattedDateTime() {
    final now = DateTime.now();
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    final dayName = days[now.weekday % 7];
    final day = now.day;
    final monthName = months[now.month - 1];
    final year = now.year;
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$dayName, $day $monthName $year | $hour:$minute WIB';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeString,
      style: const TextStyle(
        fontFamily: 'Quicksand',
        fontSize: 14,
        color: Color(0xFF64748B),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class MerchantSidebar extends StatelessWidget {
  const MerchantSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<MerchantNavProvider>(context);
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Dashboard'},
      {'icon': Icons.inventory_2_outlined, 'activeIcon': Icons.inventory_2, 'label': 'Produk'},
      {'icon': Icons.receipt_long_outlined, 'activeIcon': Icons.receipt_long, 'label': 'Pesanan'},
      {'icon': Icons.people_outline, 'activeIcon': Icons.people, 'label': 'Pelanggan'},
      {'icon': Icons.account_balance_wallet_outlined, 'activeIcon': Icons.account_balance_wallet, 'label': 'Keuangan'},
      {'icon': Icons.campaign_outlined, 'activeIcon': Icons.campaign, 'label': 'Notifikasi'},
      {'icon': Icons.settings_outlined, 'activeIcon': Icons.settings, 'label': 'Pengaturan'},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'Profil'},
    ];

    return ColoredBox(
      color: const Color(0xFF0F6B43),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  final isActive = navProvider.currentIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: InkWell(
                      onTap: () => navProvider.setIndex(index),
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF3F8F56) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isActive ? item['activeIcon'] : item['icon'],
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item['label'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'v1.0.0 ? MenuSisa',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Color(0x66FFFFFF),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
