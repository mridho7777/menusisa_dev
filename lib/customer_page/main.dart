import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_state.dart';
import 'config/supabase_config.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MenuSisa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E6F3B)),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Quicksand',
      ),
      home: const CustomerSplashScreen(),
    );
  }
}

class CustomerSplashScreen extends StatefulWidget {
  const CustomerSplashScreen({super.key});

  @override
  State<CustomerSplashScreen> createState() => _CustomerSplashScreenState();
}

class _CustomerSplashScreenState extends State<CustomerSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: SvgPicture.asset('assets/svg/logonotext.svg', fit: BoxFit.contain),
            ),
            const SizedBox(height: 18),
            const Text(
              'MenuSisa',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E6F3B),
              ),
            ),
            const SizedBox(height: 12),
            const CircularProgressIndicator(color: Color(0xFF1E6F3B)),
          ],
        ),
      ),
    );
  }
}
