// Supabase Integration Reference:
// - customer_id, merchant_id, product_id, order_id, favorite_id, cart_item_id
// - order_code, product_name, merchant_name, category_id, rating, distance_km
// - image_url for product_images, proof_image_url for payment_proofs
// - Use this file as the UI binding layer only; data should come from Supabase tables and joins.
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:menusisa_dev/login_role_page/services/supabase_config.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(const LoginRoleApp());
}

class LoginRoleApp extends StatelessWidget {
  const LoginRoleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MenuSisa - Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E6F3B)),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Quicksand',
      ),
      home: const SplashScreen(),
    );
  }
}
